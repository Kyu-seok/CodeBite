"""Replay each problem's Accepted Python solution on a Judge0 language id, against all its test cases.

The gate before switching "python" to Python 3.12 (id 100): proves working solutions still pass,
not just that the starters load. See docs/PYTHON_312_PLAN.md, step 4.

The solution is the problem's latest Accepted Python submission (a user's, otherwise an admin's), or
else its reference solution in scripts/replay-solutions/<slug>.py. Problems are judged one at a time
with a pause between, a Time Limit Exceeded case is rerun once, and the report lists the problems
that failed apart from those with nothing to replay. Exits 1 unless every problem was Accepted.

Usage:
  docker exec -i codebite-postgres psql -U codebite -d codebite -tA < scripts/replay-judge0-python.sql > /tmp/replay.json
  python3 -I scripts/replay-judge0-python.py http://192.168.219.200:2359 100 . /tmp/replay.json [--pause 2] [--only slug,...]

Port 2359 is the throwaway test stack; the gate itself runs on production Judge0 (localhost:2358 on mini).
On this machine, scripts/replay-local.sh slug,... does the export and the local run in one go.

Locally, name a Python 3.12+ interpreter instead of a Judge0 URL. Each test case then runs in its own
process with the same verdicts, under a wall-clock limit of --time-limit seconds (default 5, the number of
Judge0's default CPU limit, but stricter: waiting on a busy machine counts too):
  python3 -I scripts/replay-judge0-python.py /opt/homebrew/bin/python3.12 100 . /tmp/replay-local.json --pause 0 --only slug,...
"""
import argparse, base64, json, os, re, subprocess, sys, tempfile, time, urllib.request
from collections import namedtuple
from pathlib import Path

# Judge0 status ids: 1 In Queue, 2 Processing, 3 Accepted, 5 TLE, 6 Compilation Error, 7-12 runtime errors.
PROCESSING, ACCEPTED, TLE, COMPILATION_ERROR, RUNTIME_ERRORS = 2, 3, 5, 6, range(7, 13)
NZEC = 11  # Runtime Error (NZEC): how Judge0 reports a Python exception or syntax error
BATCH_SIZE = 20  # Judge0's default MAX_SUBMISSION_BATCH_SIZE
POLL_TIMEOUT_S = 60
LOCAL_TIME_LIMIT_S = 5  # wall-clock; Judge0's default CPU_TIME_LIMIT is 5s of CPU, so this is stricter under load

Report = namedtuple("Report", "passed failed nothing")
# case is 1-based, in order_index order (None when no case ran); detail is the last line of the output.
Failure = namedtuple("Failure", "slug origin status case detail")


def judged(result, expected):
    """The verdict JudgeService.mapStatus gives one test case."""
    sid = result["status"]["id"]
    if sid == ACCEPTED:
        return "ACCEPTED" if (result["stdout"] or "").strip() == expected.strip() else "WRONG_ANSWER"
    if sid == TLE:
        return "TIME_LIMIT_EXCEEDED"
    if sid == COMPILATION_ERROR:
        return "COMPILATION_ERROR"
    if sid in RUNTIME_ERRORS:
        return "RUNTIME_ERROR"
    return "INTERNAL_ERROR"


def last_line(result):
    out = (result.get("stderr") or result.get("compile_output") or result.get("stdout") or "").strip()
    return out.splitlines()[-1][:200] if out else ""


def first_failure(source, cases, judge, language_id):
    """(verdict, 1-based case, detail) of the first case that isn't Accepted, or None when all are."""
    if not cases:
        return ("NO_TEST_CASES", None, "")
    results = judge(source, language_id, [c["input"] for c in cases])
    verdicts = [judged(r, c["expected_output"]) for r, c in zip(results, cases)]
    # A Time Limit Exceeded may be timing noise: rerun just those cases, once.
    slow = [i for i, v in enumerate(verdicts) if v == "TIME_LIMIT_EXCEEDED"]
    if slow:
        for i, r in zip(slow, judge(source, language_id, [cases[i]["input"] for i in slow])):
            results[i], verdicts[i] = r, judged(r, cases[i]["expected_output"])
    failing = next((i for i, v in enumerate(verdicts) if v != "ACCEPTED"), None)
    return None if failing is None else (verdicts[failing], failing + 1, last_line(results[failing]))


def replay(problems, judge, language_id, assemble, sleep, log, references=None, pause=0):
    """references: slug -> reference solution, for problems with no Accepted Python submission.
    pause: seconds between judged problems, so live judging isn't crowded out."""
    report = Report([], [], [])
    judged_one = False
    for p in problems:
        solution = p["solution"]
        if solution is None and p["slug"] in (references or {}):
            solution = {"source": references[p["slug"]], "origin": "reference"}
        if solution is None:
            report.nothing.append(p["slug"])
            log(p["slug"], "nothing to replay")
            continue
        if judged_one:
            sleep(pause)
        judged_one = True
        try:
            failure = first_failure(assemble(p["slug"], solution["source"]), p["test_cases"], judge, language_id)
        except Exception as e:  # a missing driver or a Judge0 error fails this problem, not the whole replay
            failure = ("ERROR", None, f"{type(e).__name__}: {e}")
        if failure is None:
            report.passed.append(p["slug"])
            log(p["slug"], "ACCEPTED")
        else:
            report.failed.append(Failure(p["slug"], solution["origin"], *failure))
            log(p["slug"], failure[0] if failure[1] is None else f"{failure[0]} on test case {failure[1]}")
    return report


def judge0(url):
    """A judge on a real Judge0: runs one source against stdins, BATCH_SIZE at a time."""
    b64 = lambda s: base64.b64encode(s.encode()).decode()
    unb64 = lambda s: base64.b64decode(s).decode(errors="replace") if s else ""

    def call(path, body=None):
        data = json.dumps(body).encode() if body is not None else None
        req = urllib.request.Request(url + path, data, {"Content-Type": "application/json"})
        return json.load(urllib.request.urlopen(req, timeout=120))

    def run(source, language_id, stdins):
        results = []
        for i in range(0, len(stdins), BATCH_SIZE):
            subs = [{"source_code": b64(source), "language_id": language_id, "stdin": b64(s)}
                    for s in stdins[i:i + BATCH_SIZE]]
            tokens = ",".join(t["token"] for t in call("/submissions/batch?base64_encoded=true", {"submissions": subs}))
            deadline = time.monotonic() + POLL_TIMEOUT_S
            while True:
                rs = call(f"/submissions/batch?tokens={tokens}&base64_encoded=true"
                          "&fields=status,stdout,stderr,compile_output")["submissions"]
                if all(r["status"]["id"] > PROCESSING for r in rs):
                    break
                if time.monotonic() > deadline:
                    raise TimeoutError(f"Judge0 still judging after {POLL_TIMEOUT_S}s")
                time.sleep(0.3)
            results += [{**r, **{k: unb64(r[k]) for k in ("stdout", "stderr", "compile_output")}} for r in rs]
        return results

    return run


def local_judge(python, time_limit=LOCAL_TIME_LIMIT_S):
    """A judge on a local Python: runs the source once per stdin and answers in Judge0's shape.

    Exit 0 is Judge0's "ran" status (the replay compares the output), any other exit is a runtime
    error (a syntax error included, as Judge0 reports Python's), and a run past time_limit seconds
    of wall-clock time is Time Limit Exceeded (stricter than Judge0's CPU limit when the machine is busy). The environment matches the id 100 image's run_cmd.
    Raises ValueError unless python is Python 3.12 or newer, so a pass can't come from the wrong interpreter."""
    try:
        version = subprocess.run([python, "-c", "import sys; print('.'.join(map(str, sys.version_info[:3])))"],
                                 capture_output=True, text=True, timeout=30).stdout.strip()
        major, minor = (int(n) for n in version.split(".")[:2])  # fewer than two numbers is a ValueError too
    except (OSError, ValueError, subprocess.TimeoutExpired):
        raise ValueError(f"{python} is not a Python interpreter")
    if (major, minor) < (3, 12):
        raise ValueError(f"{python} is Python {version}; the local replay needs Python 3.12 or newer")

    def run(source, language_id, stdins):
        results = []
        with tempfile.TemporaryDirectory(prefix="replay-") as workdir:
            (Path(workdir) / "script.py").write_text(source)
            for stdin in stdins:
                try:
                    finished = subprocess.run([python, "script.py"], cwd=workdir, input=stdin, capture_output=True,
                                              text=True, errors="replace", timeout=time_limit,
                                              env={"PATH": os.environ.get("PATH", ""), "PYTHONINTMAXSTRDIGITS": "0"})
                    status = ACCEPTED if finished.returncode == 0 else NZEC
                    results.append({"status": {"id": status}, "stdout": finished.stdout, "stderr": finished.stderr,
                                    "compile_output": ""})
                except subprocess.TimeoutExpired:
                    results.append({"status": {"id": TLE}, "stdout": "", "stderr": "", "compile_output": ""})
        return results

    return run


def judge_for(target, language_id, time_limit=LOCAL_TIME_LIMIT_S):
    """(judge, what it judges on): a Judge0 base URL (http:// or https://) judges on that Judge0, on
    language_id; anything else names a local Python 3.12+, which ignores language_id."""
    if re.match(r"https?://", target):
        return judge0(target.rstrip("/")), f"language {language_id}"
    return local_judge(target, time_limit), target


def driver_assembler(root):
    """Puts a solution into the problem's Python driver, as ProblemAssets.assemble does."""
    drivers = root / "common/src/main/resources/drivers"
    lib = re.compile(r"^(?://|#)\s*\{\{LIB:(\w+)}}$", re.M)

    def assemble(slug, code):
        driver = (drivers / slug / "python.py").read_text()
        driver = lib.sub(lambda m: (drivers / "lib/python" / f"{m.group(1)}.py").read_text(), driver)
        return driver.replace("{USER_CODE}", code)

    return assemble


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("target", help="Judge0 base URL, or the path of a local Python 3.12+ interpreter")
    ap.add_argument("language_id", type=int,
                    help="Judge0 language id to replay on, e.g. 100 for Python 3.12 (unused by a local interpreter)")
    ap.add_argument("root", type=Path, help="repository root")
    ap.add_argument("export", type=Path, help="output of scripts/replay-judge0-python.sql")
    ap.add_argument("--pause", type=float, default=2, help="seconds between problems (default 2)")
    ap.add_argument("--time-limit", type=float, default=LOCAL_TIME_LIMIT_S,
                    help=f"wall-clock seconds per test case on a local interpreter (default {LOCAL_TIME_LIMIT_S}; "
                         "stricter than Judge0's CPU limit under load)")
    ap.add_argument("--only", help="comma-separated slugs to replay, e.g. the failures of an earlier run")
    args = ap.parse_args()

    problems = json.loads(args.export.read_text())
    if args.only:
        wanted = set(args.only.split(","))
        unknown = wanted - {problem["slug"] for problem in problems}
        if unknown:  # a misspelled slug would otherwise replay nothing and pass
            sys.exit(f"replay: not in the export: {', '.join(sorted(unknown))}")
        problems = [problem for problem in problems if problem["slug"] in wanted]
    references = {f.stem: f.read_text() for f in (args.root / "scripts/replay-solutions").glob("*.py")}

    def log(slug, verdict):
        print(f"  {slug:<40} {verdict}", flush=True)

    try:
        judge, judged_on = judge_for(args.target, args.language_id, args.time_limit)
    except ValueError as e:
        sys.exit(f"replay: {e}")
    print(f"== replaying {len(problems)} problems on {judged_on}, {args.pause}s apart")
    report = replay(problems, judge, args.language_id, driver_assembler(args.root),
                    time.sleep, log, references, args.pause)

    print(f"\n== {len(report.passed)} Accepted")
    print(f"== {len(report.failed)} failed")
    for f in report.failed:
        where = f" on test case {f.case}" if f.case else ""
        print(f"  {f.slug} ({f.origin}): {f.status}{where}: {f.detail}")
    print(f"== {len(report.nothing)} with nothing to replay (no Accepted Python submission, no reference solution)")
    for slug in report.nothing:
        print(f"  {slug}")
    sys.exit(1 if report.failed or report.nothing else 0)


if __name__ == "__main__":
    main()
