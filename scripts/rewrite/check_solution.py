#!/usr/bin/env python3
"""
Validate a proposed problem rewrite by running a reference solution through
Judge0 against each sample input and comparing stdout to the claimed sample output.

Proves the rewrite is internally consistent: the sample I/O pairs actually
describe a correct solution. This is a behavioral check only; content-hygiene
checks (fingerprint denylist, similarity probe) live in check_denylist.py and
the operator runbook.

Usage:
    check_solution.py \\
        --slug pair-sum \\
        --rewrite rewrite.json \\
        --solution reference.py \\
        --language python

Rewrite JSON shape (relevant fields):
    {
      "slug": "...",
      "sample_inputs": ["stdin_1", "stdin_2", ...],
      "sample_outputs": ["expected_1", "expected_2", ...]
    }

Exit 0 on all pass, 1 on any mismatch. Details printed as JSON lines.
"""
import argparse
import base64
import json
import re
import sys
import time
from pathlib import Path
from typing import Optional
from urllib import request as urlreq
from urllib.error import HTTPError, URLError


REPO_ROOT = Path(__file__).resolve().parents[2]
DRIVERS_DIR = REPO_ROOT / "common" / "src" / "main" / "resources" / "drivers"
LIB_DIR = DRIVERS_DIR / "lib"

LANG_META = {
    "python":     {"ext": ".py",  "judge0_id": 71},
    "java":       {"ext": ".java", "judge0_id": 62},
    "cpp":        {"ext": ".cpp", "judge0_id": 54},
    "javascript": {"ext": ".js",  "judge0_id": 63},
}

LIB_MARKER_RE = re.compile(r"^(?://|#)\s*\{\{LIB:(\w+)}}$", re.MULTILINE)


def b64e(s: str) -> str:
    return base64.b64encode(s.encode("utf-8")).decode("ascii")


def b64d(s: Optional[str]) -> str:
    if not s:
        return ""
    return base64.b64decode(s).decode("utf-8", errors="replace")


def resolve_lib_markers(template: str, language: str) -> str:
    def replace(m):
        cls = m.group(1)
        lib_file = LIB_DIR / language / f"{cls}{LANG_META[language]['ext']}"
        if not lib_file.exists():
            raise RuntimeError(f"Library not found: {lib_file}")
        return lib_file.read_text()
    return LIB_MARKER_RE.sub(replace, template)


def load_driver(slug: str, language: str) -> str:
    meta = LANG_META[language]
    path = DRIVERS_DIR / slug / f"{language}{meta['ext']}"
    if not path.exists():
        raise RuntimeError(f"Driver not found: {path}")
    template = path.read_text()
    template = resolve_lib_markers(template, language)
    if "{USER_CODE}" not in template:
        raise RuntimeError(f"Driver missing {{USER_CODE}} placeholder: {path}")
    return template


def inject_solution(template: str, solution_code: str) -> str:
    return template.replace("{USER_CODE}", solution_code)


def submit_judge0(base_url: str, source: str, language_id: int, stdin: str, timeout_s: float) -> dict:
    """Async submit + poll. Judge0's wait=true is flaky on this instance.
    Polls every 500ms for up to timeout_s seconds."""
    base = base_url.rstrip("/")
    payload = {
        "source_code": b64e(source),
        "language_id": language_id,
        "stdin": b64e(stdin),
    }
    body = json.dumps(payload).encode("utf-8")
    req = urlreq.Request(f"{base}/submissions?base64_encoded=true",
                         data=body,
                         headers={"Content-Type": "application/json"},
                         method="POST")
    with urlreq.urlopen(req, timeout=10) as resp:
        token = json.loads(resp.read())["token"]

    deadline = time.time() + timeout_s
    while time.time() < deadline:
        time.sleep(0.5)
        with urlreq.urlopen(f"{base}/submissions/{token}?base64_encoded=true", timeout=10) as resp:
            r = json.loads(resp.read())
        if (r.get("status") or {}).get("id", 0) > 2:
            return r
    raise TimeoutError(f"Judge0 poll timed out after {timeout_s}s for token={token}")


def normalize_output(s: str) -> str:
    # Trim trailing whitespace per line, strip overall, collapse \r\n -> \n.
    s = s.replace("\r\n", "\n")
    return "\n".join(line.rstrip() for line in s.split("\n")).strip()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--slug", required=True)
    parser.add_argument("--rewrite", required=True, help="Path to rewrite JSON")
    parser.add_argument("--solution", required=True, help="Path to reference solution file")
    parser.add_argument("--language", required=True, choices=LANG_META.keys())
    parser.add_argument("--judge0-url", default="http://192.168.219.200:2358")
    parser.add_argument("--timeout", type=float, default=30.0)
    args = parser.parse_args()

    rewrite = json.loads(Path(args.rewrite).read_text())
    solution_code = Path(args.solution).read_text()

    sample_inputs = rewrite.get("sample_inputs", [])
    sample_outputs = rewrite.get("sample_outputs", [])
    if len(sample_inputs) != len(sample_outputs):
        print(json.dumps({
            "category": "solution",
            "error": "sample_inputs/sample_outputs length mismatch",
            "n_inputs": len(sample_inputs),
            "n_outputs": len(sample_outputs),
        }))
        return 1

    try:
        driver = load_driver(args.slug, args.language)
    except RuntimeError as e:
        print(json.dumps({"category": "solution", "error": str(e)}))
        return 1

    source = inject_solution(driver, solution_code)
    lang_id = LANG_META[args.language]["judge0_id"]

    failures = 0
    for i, (stdin, expected) in enumerate(zip(sample_inputs, sample_outputs)):
        t0 = time.time()
        try:
            result = submit_judge0(args.judge0_url, source, lang_id, stdin, args.timeout)
        except (HTTPError, URLError, TimeoutError) as e:
            print(json.dumps({
                "category": "solution", "slug": args.slug, "sample": i,
                "error": f"judge0 request failed: {e}",
            }))
            failures += 1
            continue

        status = (result.get("status") or {}).get("description", "unknown")
        stdout = normalize_output(b64d(result.get("stdout")))
        stderr = b64d(result.get("stderr"))
        compile_output = b64d(result.get("compile_output"))
        expected_norm = normalize_output(expected)

        ok = status == "Accepted" and stdout == expected_norm
        if not ok:
            failures += 1
            print(json.dumps({
                "category": "solution",
                "slug": args.slug,
                "sample": i,
                "status": status,
                "expected": expected_norm,
                "actual": stdout,
                "stderr": stderr[:400] if stderr else "",
                "compile_output": compile_output[:400] if compile_output else "",
                "elapsed_s": round(time.time() - t0, 2),
            }))
        else:
            print(json.dumps({
                "category": "solution",
                "slug": args.slug,
                "sample": i,
                "status": "pass",
                "elapsed_s": round(time.time() - t0, 2),
            }))

    return 1 if failures > 0 else 0


if __name__ == "__main__":
    sys.exit(main())
