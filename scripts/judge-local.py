"""Judges one problem's Test Cases on this machine, without Judge0, in any of the four Languages.

For each Language the problem's reference solution, scripts/replay-solutions/<slug>.<ext>, goes into
its Driver at {USER_CODE} (Library markers resolved, as ProblemAssets.assemble does), is compiled
where the Language needs it, and runs once per Test Case. A case is Accepted when the program exits 0
and its trimmed stdout equals the trimmed expected output, as CaseVerdict compares them; a null
expected output is an Unjudged Case and only has to run.

Usage (scripts/judge-local.sh does the export from the local database):
  python3 -I scripts/judge-local.py <repo root> <cases.json> <slug> [--languages python,java,javascript,cpp]

cases.json is a list of {"input": ..., "expected_output": ...} in order_index order.
Exits 0 when every Language asked for was Accepted, 1 when a case failed, 2 when a toolchain or a
reference solution is missing (reported as such, never as a failed case).
"""
import argparse, json, os, re, shutil, subprocess, sys, tempfile
from pathlib import Path

LANGUAGES = {"python": "py", "java": "java", "javascript": "js", "cpp": "cpp"}  # code -> extension, as Language
LIB_MARKER = re.compile(r"^(?://|#)\s*\{\{LIB:(\w+)}}$", re.M)
TIME_LIMIT_S = 5


class Missing(Exception):
    """A toolchain or reference solution that isn't there: the Language can't be judged."""


class CompileError(Exception):
    """The assembled program doesn't compile."""


def assemble(root, slug, language, code):
    drivers = root / "common/src/main/resources/drivers"
    ext = LANGUAGES[language]
    driver = (drivers / slug / f"{language}.{ext}").read_text()
    driver = LIB_MARKER.sub(lambda m: (drivers / "lib" / language / f"{m.group(1)}.{ext}").read_text(), driver)
    return driver.replace("{USER_CODE}", code)


def python_tool():
    """A Python 3.12 or newer, like the id 100 image: CODEBITE_PYTHON312, python3.12 or python3."""
    for candidate in (os.environ.get("CODEBITE_PYTHON312"), shutil.which("python3.12"), shutil.which("python3")):
        if not candidate:
            continue
        try:
            out = subprocess.run([candidate, "-c", "import sys; print(sys.version_info >= (3, 12))"],
                                 capture_output=True, text=True, timeout=30).stdout.strip()
        except (OSError, subprocess.TimeoutExpired):
            continue
        if out == "True":
            return candidate
    raise Missing("no Python 3.12 or newer (set CODEBITE_PYTHON312, or install python3.12)")


def tool(name, env=None):
    """The path of a compiler or interpreter: $env when set, else name on PATH; raises Missing."""
    named = os.environ.get(env) if env else None
    if named:
        path = shutil.which(named)
        if not path:
            raise Missing(f"{env}={named} is not an executable")
        return path
    path = shutil.which(name)
    if not path:
        raise Missing(f"{name} not found on PATH" + (f" (or set {env})" if env else ""))
    return path


def compile_(command, workdir):
    done = subprocess.run(command, cwd=workdir, capture_output=True, text=True, errors="replace", timeout=120)
    if done.returncode != 0:
        raise CompileError(first_error(done.stderr or done.stdout))


def first_error(text):
    lines = [line for line in (text or "").splitlines() if "error" in line.lower()] or (text or "").splitlines()
    return lines[0][:200] if lines else ""


def build(language, source, workdir):
    """Writes and compiles the source in workdir, as Judge0's image would; returns the command that runs it.

    Java compiles with --release 13 and C++ with -std=gnu++14, Judge0 ids 62 (OpenJDK 13) and 54
    (GCC 9.2, default standard), so an API or feature those lack fails here too. JavaScript runs on
    the local node, newer than id 63's Node 12, so a newer API can pass here and fail on Judge0."""
    if language == "python":
        (workdir / "script.py").write_text(source)
        return [python_tool(), "script.py"]
    if language == "java":
        javac, java = tool("javac"), tool("java")
        (workdir / "Main.java").write_text(source)
        compile_([javac, "--release", "13", "-nowarn", "Main.java"], workdir)
        return [java, "-cp", ".", "Main"]
    if language == "javascript":
        (workdir / "script.js").write_text(source)
        return [tool("node"), "script.js"]
    if language == "cpp":
        cxx = tool("g++", "CXX")
        (workdir / "main.cpp").write_text(source)
        compile_([cxx, "-std=gnu++14", "-O2", "-o", "main", "main.cpp"], workdir)
        return [str(workdir / "main")]
    raise ValueError(language)


def run_case(command, workdir, stdin, expected):
    """(verdict, detail) for one Test Case."""
    try:
        done = subprocess.run(command, cwd=workdir, input=stdin, capture_output=True, text=True,
                              errors="replace", timeout=TIME_LIMIT_S)
    except subprocess.TimeoutExpired:
        return "TIME_LIMIT_EXCEEDED", f"over {TIME_LIMIT_S}s"
    if done.returncode != 0:
        return "RUNTIME_ERROR", last_line(done.stderr or done.stdout)
    if expected is not None and done.stdout.strip() != expected.strip():
        return "WRONG_ANSWER", f"expected {expected.strip()[:80]!r}, got {done.stdout.strip()[:80]!r}"
    return "ACCEPTED", ""


def last_line(text):
    text = (text or "").strip()
    return text.splitlines()[-1][:200] if text else ""


def judge(root, slug, language, cases):
    """'ACCEPTED' or a one-line failure; raises Missing."""
    if not cases:
        return "NO_TEST_CASES: no Test Cases to judge"
    driver = root / "common/src/main/resources/drivers" / slug / f"{language}.{LANGUAGES[language]}"
    if not driver.exists():
        return f"NO_DRIVER: {driver.relative_to(root)} doesn't exist"
    solution = root / "scripts/replay-solutions" / f"{slug}.{LANGUAGES[language]}"
    if not solution.exists():
        raise Missing(f"no reference solution at {solution.relative_to(root)}")
    source = assemble(root, slug, language, solution.read_text())
    with tempfile.TemporaryDirectory(prefix="judge-local-") as tmp:
        workdir = Path(tmp)
        try:
            command = build(language, source, workdir)
        except CompileError as e:
            return f"COMPILATION_ERROR: {e}"
        for n, case in enumerate(cases, 1):
            verdict, detail = run_case(command, workdir, case["input"], case["expected_output"])
            if verdict != "ACCEPTED":
                return f"{verdict} on test case {n}: {detail}"
    return "ACCEPTED"


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("root", type=Path)
    ap.add_argument("cases", type=Path)
    ap.add_argument("slug")
    ap.add_argument("--languages", default=",".join(LANGUAGES))
    args = ap.parse_args()
    languages = args.languages.split(",")
    unknown = [language for language in languages if language not in LANGUAGES]
    if unknown:
        ap.error(f"unknown language {', '.join(unknown)}; one of {', '.join(LANGUAGES)}")
    cases = json.loads(args.cases.read_text())
    print(f"== {len(cases)} Test Cases", flush=True)
    failed = missing = False
    for language in languages:
        try:
            outcome = judge(args.root, args.slug, language, cases)
        except Missing as e:
            outcome, missing = f"NOT JUDGED: {e}", True
        failed |= not outcome.startswith(("ACCEPTED", "NOT JUDGED"))
        print(f"  {language:<11} {outcome}", flush=True)
    sys.exit(1 if failed else 2 if missing else 0)


if __name__ == "__main__":
    main()
