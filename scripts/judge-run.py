"""Runs problems' reference solutions through a backend's Run endpoint, so they compile and pass the
sample Test Cases on Judge0 against this backend's Drivers, and checks that Former Slugs resolve.

Usage (scripts/judge-run.sh passes the repository root):
  python3 -I scripts/judge-run.py <repo root> <slug> [--former <old-slug>]... [<slug> ...]
      [--languages python,java,javascript,cpp] [--backend <url>]

Each Language's reference solution is <repo root>/scripts/replay-solutions/<slug>.<py|java|js|cpp>;
a Language without one is NOT JUDGED. A --former belongs to the slug before it: GET
/api/problems/<old-slug> must answer that slug. The backend defaults to the one
`scripts/dev-branch-servers.sh status` prints for this checkout.

Runs go JUDGE_RUN_SPACING seconds apart (5.5, past the backend's 5 s per-IP Run cooldown), and a
429 is waited out, up to JUDGE_RUN_MAX_WAITS times (12), never reported as a verdict.

Exits 0 when every Language was Accepted and every Former Slug resolves, 1 on any other verdict or
Former Slug, 2 when the backend can't be reached (or keeps answering 429), lacks a problem, or a
Language has no reference solution.
"""
import json, os, re, subprocess, sys, time, urllib.error, urllib.request
from pathlib import Path

LANGUAGES = {"python": "py", "java": "java", "javascript": "js", "cpp": "cpp"}  # code -> extension, as Language
SPACING = float(os.environ.get("JUDGE_RUN_SPACING", "5.5"))
MAX_WAITS = int(os.environ.get("JUDGE_RUN_MAX_WAITS", "12"))
RUN_TIMEOUT_S = 180
USAGE = ("usage: scripts/judge-run.sh <slug> [--former <old-slug>] [<slug> ...] "
         "[--languages python,java,javascript,cpp] [--backend <url>]")


class Unreachable(Exception):
    """The backend can't answer: exit 2 at once, since nothing after it can be judged either."""


def usage(message=None):
    if message:
        print(f"judge-run.sh: {message}", file=sys.stderr)
    print(USAGE, file=sys.stderr)
    sys.exit(2)


def parse(argv):
    """[(slug, [former, ...])], languages, backend or None."""
    problems, languages, backend = [], list(LANGUAGES), None
    i = 0
    while i < len(argv):
        arg = argv[i]
        if arg in ("--former", "--languages", "--backend"):
            if i + 1 >= len(argv):
                usage(f"{arg} needs a value")
            value = argv[i + 1]
            if arg == "--former":
                if not problems:
                    usage("--former names the old slug of the slug before it")
                problems[-1][1].append(value)
            elif arg == "--languages":
                languages = value.split(",")
                unknown = [language for language in languages if language not in LANGUAGES]
                if unknown:
                    usage(f"unknown language {', '.join(unknown)}; one of {', '.join(LANGUAGES)}")
            else:
                backend = value
            i += 2
        elif arg.startswith("-"):
            usage()
        else:
            problems.append((arg, []))
            i += 1
    if not problems:
        usage()
    return problems, languages, backend


def backend_from_status(text):
    """The backend URL in `scripts/dev-branch-servers.sh status` output, or None when not running."""
    m = re.search(r"^\s*backend\s+(http://\S+)", text, re.M)
    return m.group(1) if m else None


def default_backend(root):
    script = root / "scripts/dev-branch-servers.sh"
    done = subprocess.run([str(script), "status"], capture_output=True, text=True)
    backend = backend_from_status(done.stdout)
    if not backend:
        print(f"judge-run.sh: no --backend, and this checkout's branch servers aren't running "
              f"({(done.stdout or done.stderr).strip()}); start them: scripts/dev-branch-servers.sh start --detach",
              file=sys.stderr)
        sys.exit(2)
    return backend


def api_base(backend):
    """http://host:port/api from http://host:port, http://host:port/ or http://host:port/api."""
    return backend.rstrip("/").removesuffix("/api") + "/api"


def request(url, body=None):
    """(status, parsed JSON or None); raises Unreachable when there is no HTTP answer at all."""
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(url, data=data, method="POST" if body is not None else "GET",
                                 headers={"Content-Type": "application/json", "Accept": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=RUN_TIMEOUT_S) as response:
            status, raw = response.status, response.read()
    except urllib.error.HTTPError as e:
        status, raw = e.code, e.read()
    except (urllib.error.URLError, OSError) as e:
        reason = getattr(e, "reason", e)
        why = "connection refused" if isinstance(reason, ConnectionRefusedError) else str(reason)
        raise Unreachable(f"the backend at {url} is down ({why}); "
                          f"start the branch servers again: scripts/dev-branch-servers.sh restart") from None
    try:
        return status, json.loads(raw) if raw else None
    except ValueError:
        return status, None


def message(body):
    return body.get("message", "") if isinstance(body, dict) else ""


class Runner:
    """Posts Runs no sooner than SPACING after the last one, waiting out a 429."""

    def __init__(self, api):
        self.api = api
        self.last = None

    def run(self, slug, language, source):
        url = f"{self.api}/problems/{slug}/run"
        for waits in range(MAX_WAITS + 1):
            if self.last is not None:
                time.sleep(max(0.0, self.last + SPACING - time.monotonic()))
            status, body = request(url, {"language": language, "sourceCode": source})
            self.last = time.monotonic()
            if status != 429:
                return status, body
            print(f"  ({language}: 429, waiting out the Run cooldown)", file=sys.stderr, flush=True)
        raise Unreachable(f"{url} still answers 429 after {MAX_WAITS} waits: "
                          f"is another session Running from this machine?")


def describe(body):
    """ACCEPTED, or the verdict and the first sample that isn't Accepted, with the compiler's or
    program's output under it."""
    overall = body.get("overallStatus") if isinstance(body, dict) else None
    if overall == "ACCEPTED":
        return "ACCEPTED", []
    results = (body.get("results") or []) if isinstance(body, dict) else []
    for n, result in enumerate(results, 1):
        if result.get("status") != "ACCEPTED":
            detail = result.get("compileOutput") or result.get("stderr") or ""
            lines = detail.strip().splitlines()[:6]
            if not lines and result.get("expectedOutput") is not None:
                lines = [f"expected {result.get('expectedOutput')!r}, got {result.get('actualOutput')!r}"]
            return f"{overall or result.get('status')} on sample {n}", lines
    return str(overall), []


def judge(root, runner, slug, languages):
    """Prints a line per Language; returns 'failed', 'missing' or None."""
    worst = None
    for language in languages:
        path = root / "scripts/replay-solutions" / f"{slug}.{LANGUAGES[language]}"
        if not path.is_file():
            print(f"  {language:<11} NOT JUDGED: no reference solution scripts/replay-solutions/{path.name}", flush=True)
            worst = worst or "missing"
            continue
        status, body = runner.run(slug, language, path.read_text())
        if status == 404:
            print(f"  no problem {slug} at {runner.api} ({message(body)}); after a new migration: "
                  f"scripts/dev-branch-servers.sh restart", flush=True)
            return worst if worst == "failed" else "missing"
        if status != 200:
            print(f"  {language:<11} HTTP {status}: {message(body)}", flush=True)
            worst = "failed"
            continue
        verdict, lines = describe(body)
        print(f"  {language:<11} {verdict}", flush=True)
        for line in lines:
            print(f"  {'':<11} {line}", flush=True)
        if verdict != "ACCEPTED":
            worst = "failed"
    return worst


def check_former(api, slug, former):
    status, body = request(f"{api}/problems/{former}")
    if status != 200:
        print(f"  {former:<11} HTTP {status}: {message(body)}", flush=True)
        return False
    resolved = body.get("slug") if isinstance(body, dict) else None
    if resolved == slug:
        print(f"  {former:<11} resolves to {slug}", flush=True)
        return True
    print(f"  {former:<11} resolves to {resolved}, not {slug}", flush=True)
    return False


def main(argv):
    if not argv:
        usage()
    root = Path(argv[0])
    problems, languages, backend = parse(argv[1:])
    api = api_base(backend or default_backend(root))
    runner = Runner(api)
    failed = missing = False
    try:
        for slug, formers in problems:
            print(f"== running {slug} on {api}", flush=True)
            outcome = judge(root, runner, slug, languages)
            failed |= outcome == "failed"
            missing |= outcome == "missing"
            for former in formers:
                failed |= not check_former(api, slug, former)
    except Unreachable as e:
        print(f"judge-run.sh: {e}", file=sys.stderr)
        sys.exit(2)
    sys.exit(1 if failed else 2 if missing else 0)


if __name__ == "__main__":
    main(sys.argv[1:])
