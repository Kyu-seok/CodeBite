#!/usr/bin/env python3
"""Measure end-to-end backend submission latency for CodeBite.

For each run: POST /api/problems/{slug}/submit, then poll the
submission GET endpoint as fast as possible until status leaves
PENDING. Records wall-clock time per run and prints percentile
stats. Use the `compare` subcommand to diff two runs (A/B).

Stdlib only -- no `pip install` needed. Auth uses a JWT bearer
token that the caller obtains via the normal browser login flow.
"""

import argparse
import json
import statistics
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path


def _request(method, url, token, body=None):
    headers = {"Authorization": f"Bearer {token}"}
    data = None
    if body is not None:
        headers["Content-Type"] = "application/json"
        data = json.dumps(body).encode()
    req = urllib.request.Request(url, method=method, data=data, headers=headers)
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read())


def submit(base_url, token, slug, language, source):
    return _request(
        "POST",
        f"{base_url}/api/problems/{slug}/submit",
        token,
        {"language": language, "sourceCode": source},
    )


def get_submission(base_url, token, submission_id):
    return _request("GET", f"{base_url}/api/submissions/{submission_id}", token)


def measure_once(base_url, token, slug, language, source, poll_interval, timeout):
    """Time from submit until backend returns non-PENDING. Backend-only
    measurement -- the frontend's 500ms polling cadence is not included."""
    start = time.monotonic()
    sub = submit(base_url, token, slug, language, source)
    submission_id = sub["id"]
    while True:
        data = get_submission(base_url, token, submission_id)
        if data["status"] != "PENDING":
            return time.monotonic() - start, data["status"]
        if time.monotonic() - start > timeout:
            raise TimeoutError(
                f"Submission {submission_id} still PENDING after {timeout}s"
            )
        time.sleep(poll_interval)


def percentile(sorted_values, p):
    if not sorted_values:
        return 0.0
    k = (len(sorted_values) - 1) * p
    lo = int(k)
    hi = min(lo + 1, len(sorted_values) - 1)
    return sorted_values[lo] + (sorted_values[hi] - sorted_values[lo]) * (k - lo)


def summarize(label, times):
    s = sorted(times)
    return {
        "label": label,
        "n": len(times),
        "min_s": min(times),
        "p50_s": percentile(s, 0.50),
        "p95_s": percentile(s, 0.95),
        "p99_s": percentile(s, 0.99),
        "max_s": max(times),
        "mean_s": statistics.mean(times),
        "stdev_s": statistics.stdev(times) if len(times) > 1 else 0.0,
        "raw_s": times,
    }


def print_summary(s):
    print(f"\n=== {s['label']} (n={s['n']}) ===")
    print(f"  min    = {s['min_s']:7.3f}s")
    print(f"  p50    = {s['p50_s']:7.3f}s")
    print(f"  p95    = {s['p95_s']:7.3f}s")
    print(f"  p99    = {s['p99_s']:7.3f}s")
    print(f"  max    = {s['max_s']:7.3f}s")
    print(f"  mean   = {s['mean_s']:7.3f}s  (stdev {s['stdev_s']:.3f}s)")


def cmd_measure(args):
    source = Path(args.source_file).read_text()
    times = []
    statuses = []
    print(f"Running {args.runs} submissions against {args.base_url} (slug={args.slug}, lang={args.language})")
    for i in range(args.runs):
        try:
            elapsed, status = measure_once(
                args.base_url, args.token, args.slug, args.language, source,
                args.poll_interval, args.timeout,
            )
            times.append(elapsed)
            statuses.append(status)
            print(f"  run {i+1:2}/{args.runs}: {elapsed:6.3f}s  status={status}")
        except (urllib.error.HTTPError, urllib.error.URLError, TimeoutError, KeyError) as e:
            print(f"  run {i+1:2}/{args.runs}: FAILED ({type(e).__name__}: {e})", file=sys.stderr)
        # Sleep between runs to avoid hot caches or worker queueing skewing samples.
        if i + 1 < args.runs and args.between > 0:
            time.sleep(args.between)

    if not times:
        sys.exit("No successful runs - aborting")

    summary = summarize(args.label, times)
    summary["statuses"] = statuses
    print_summary(summary)
    if args.out:
        Path(args.out).write_text(json.dumps(summary, indent=2))
        print(f"\nSaved to {args.out}")


def cmd_compare(args):
    before = json.loads(Path(args.before).read_text())
    after = json.loads(Path(args.after).read_text())
    print_summary(before)
    print_summary(after)
    print(f"\n=== delta ({before['label']} -> {after['label']}) ===")
    for k in ("min_s", "p50_s", "p95_s", "p99_s", "max_s", "mean_s"):
        b, a = before[k], after[k]
        if a == 0:
            continue
        pct = (a - b) / b * 100 if b else 0.0
        speedup = b / a if a else float("inf")
        print(f"  {k:7} : {b:7.3f}s -> {a:7.3f}s  ({pct:+6.1f}%, {speedup:4.2f}x)")


def main():
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    sub = parser.add_subparsers(dest="cmd", required=True)

    m = sub.add_parser("measure", help="Run N submissions and report stats")
    m.add_argument("--base-url", default="http://localhost:8080",
                   help="Backend base URL (default: http://localhost:8080)")
    m.add_argument("--token", required=True, help="JWT bearer token")
    m.add_argument("--slug", required=True, help="Problem slug, e.g. two-sum")
    m.add_argument("--language", required=True, choices=["java", "python", "javascript", "cpp"])
    m.add_argument("--source-file", required=True, help="Path to source file containing the solution")
    m.add_argument("--runs", type=int, default=10, help="Number of submissions (default: 10)")
    m.add_argument("--label", required=True, help="Label for this measurement set (e.g. 'before', 'after')")
    m.add_argument("--out", default=None, help="Write JSON summary to this path")
    m.add_argument("--poll-interval", type=float, default=0.05,
                   help="Seconds between status polls (default: 0.05 - tight to avoid skewing latency)")
    m.add_argument("--timeout", type=float, default=120.0,
                   help="Per-run timeout in seconds (default: 120)")
    m.add_argument("--between", type=float, default=0.5,
                   help="Seconds to wait between runs (default: 0.5)")
    m.set_defaults(func=cmd_measure)

    c = sub.add_parser("compare", help="Compare two JSON summaries side-by-side")
    c.add_argument("before", help="JSON summary from the 'before' run")
    c.add_argument("after", help="JSON summary from the 'after' run")
    c.set_defaults(func=cmd_compare)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
