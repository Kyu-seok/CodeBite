"""What every CodeBite tracer shares: the problem's sample Test Cases, read from the database, and
sample runs pinned to them (docs/adr/0011).

    samples = sample_cases("rotting-donuts")          # [{"input", "expected", "label"}], by order_index
    run = sample_run(wt, 1, samples[0], input=f"ward = {samples[0]['input']}")
    ...
    run.frame(..., answer="4")                         # the answer as the Driver prints it
    wt.write(walkthrough_path("rotting-donuts"))

The samples come through scripts/db-sql.sh, so the local database (or CODEBITE_DB's) must be at this
checkout's migrations: db-sql.sh refuses one behind instead of letting a tracer copy stale samples.
"""
import json
import os
import re
import subprocess

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))


def sample_cases(slug):
    """The problem's sample Test Cases in order, each {"input": text, "expected": text, "label": Text},
    input and expected verbatim, label as run_label gives it."""
    if "'" in slug:
        raise ValueError(f"not a Slug: {slug!r}")
    sql = ("SELECT json_build_object('description', p.description, 'samples', coalesce(json_agg("
           "json_build_object('input', t.input, 'expected', t.expected_output) ORDER BY t.order_index)"
           " FILTER (WHERE t.id IS NOT NULL), '[]')) FROM problems p"
           " LEFT JOIN test_cases t ON t.problem_id = p.id AND t.is_sample"
           f" WHERE p.slug = '{slug}' GROUP BY p.id")
    out = subprocess.run([os.path.join(ROOT, "scripts", "db-sql.sh"), sql],
                         check=True, capture_output=True, text=True).stdout
    found = json.loads(out) if out.strip() else {"description": "", "samples": []}
    samples = found["samples"]
    if not samples:
        raise SystemExit(f"{slug}: no sample Test Cases in the database (is it the right one? CODEBITE_DB)")
    for number, sample in enumerate(samples, start=1):
        sample["label"] = run_label(number, found["description"])
    return samples


def run_label(number, description):
    """Sample `number`'s run label: "Example N" when the description shows it as **Example N:**, or
    else "Case N", as the test panel numbers the samples, so no run names an Example the learner
    can't find."""
    if re.search(rf"\*\*Example {number}:\*\*", description):
        return {"en": f"Example {number}", "ko": f"예시 {number}"}
    return {"en": f"Case {number}", "ko": f"케이스 {number}"}


def sample_run(wt, number, sample, input, setup=None):
    """Run `number` (1-based) on `sample`, labelled by run_label, carrying the sample's input text as
    `sampleInput` and its expected output text as `expected`."""
    run = wt.run(sample["label"], input=input,
                 expected=sample["expected"], setup=setup)
    run.data["sampleInput"] = sample["input"]
    return run


def walkthrough_path(slug):
    return os.path.join(ROOT, "common", "src", "main", "resources", "walkthroughs", f"{slug}.json")
