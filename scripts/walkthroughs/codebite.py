"""What every CodeBite tracer shares: the problem's sample Test Cases, read from the database, and
sample runs pinned to them (docs/adr/0011).

    samples = sample_cases("rotting-donuts")          # [{"input": ..., "expected": ...}], by order_index
    run = sample_run(wt, 1, samples[0], input=f"ward = {samples[0]['input']}")
    ...
    run.frame(..., answer="4")                         # the answer as the Driver prints it
    wt.write(walkthrough_path("rotting-donuts"))

The samples come through scripts/db-sql.sh, so the local database (or CODEBITE_DB's) must be at this
checkout's migrations: db-sql.sh refuses one behind instead of letting a tracer copy stale samples.
"""
import json
import os
import subprocess

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))


def sample_cases(slug):
    """The problem's sample Test Cases in order, each {"input": text, "expected": text}, verbatim."""
    if "'" in slug:
        raise ValueError(f"not a Slug: {slug!r}")
    sql = ("SELECT coalesce(json_agg(json_build_object('input', t.input, 'expected', t.expected_output)"
           " ORDER BY t.order_index), '[]') FROM test_cases t JOIN problems p ON p.id = t.problem_id"
           f" WHERE p.slug = '{slug}' AND t.is_sample")
    out = subprocess.run([os.path.join(ROOT, "scripts", "db-sql.sh"), sql],
                         check=True, capture_output=True, text=True).stdout
    samples = json.loads(out)
    if not samples:
        raise SystemExit(f"{slug}: no sample Test Cases in the database (is it the right one? CODEBITE_DB)")
    return samples


def sample_run(wt, number, sample, input, setup=None):
    """Run `number` (1-based) on `sample`: labelled "Example N" as the description labels it, carrying
    the sample's input text as `sampleInput` and its expected output text as `expected`."""
    run = wt.run({"en": f"Example {number}", "ko": f"예시 {number}"}, input=input,
                 expected=sample["expected"], setup=setup)
    run.data["sampleInput"] = sample["input"]
    return run


def walkthrough_path(slug):
    return os.path.join(ROOT, "common", "src", "main", "resources", "walkthroughs", f"{slug}.json")
