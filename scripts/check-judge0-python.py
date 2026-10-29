"""Compare two Python languages on a Judge0: today's Python 3.8.1 (id 71) and the custom Python 3.12 (id 100).

Checks modern syntax, compiled standard-library modules, the sandbox limits on the new Python,
and that every problem's Python starter loads through its driver. See docs/PYTHON_312_PLAN.md.

Usage:
  docker exec codebite-postgres psql -U codebite -d codebite -tAc "select json_agg(json_build_object('slug', p.slug, 'input', t.input)) from problems p join test_cases t on t.problem_id = p.id and t.is_sample and t.order_index = (select min(order_index) from test_cases t2 where t2.problem_id = p.id and t2.is_sample)" > /tmp/samples.json
  python3 -I scripts/check-judge0-python.py http://192.168.219.200:2359 . /tmp/samples.json
"""
import base64, json, re, sys, time, urllib.request
from pathlib import Path

JUDGE0, ROOT, SAMPLES = sys.argv[1], Path(sys.argv[2]), Path(sys.argv[3])
PY38, PY312 = 71, 100
DRIVERS = ROOT / "common/src/main/resources/drivers"
STARTERS = ROOT / "common/src/main/resources/starters"
LIB = re.compile(r"^(?://|#)\s*\{\{LIB:(\w+)}}$", re.M)

b64 = lambda s: base64.b64encode(s.encode()).decode()
unb64 = lambda s: base64.b64decode(s).decode(errors="replace") if s else ""

def call(path, body=None):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(JUDGE0 + path, data, {"Content-Type": "application/json"})
    return json.load(urllib.request.urlopen(req, timeout=120))

def run_many(jobs):
    """jobs: list of (source, language_id, stdin[, extra]). Returns Judge0 results in order."""
    results = []
    for i in range(0, len(jobs), 20):  # Judge0's default MAX_SUBMISSION_BATCH_SIZE
        chunk = jobs[i:i + 20]
        subs = [{"source_code": b64(j[0]), "language_id": j[1], "stdin": b64(j[2]), **(j[3] if len(j) > 3 else {})}
                for j in chunk]
        tokens = ",".join(t["token"] for t in call("/submissions/batch?base64_encoded=true", {"submissions": subs}))
        while True:
            rs = call(f"/submissions/batch?tokens={tokens}&base64_encoded=true"
                      "&fields=status,stdout,stderr,compile_output,time,memory")["submissions"]
            if all(r["status"]["id"] > 2 for r in rs):
                break
            time.sleep(0.3)
        results += rs
    return results

def short(r):
    out = (unb64(r["stdout"]) or unb64(r["stderr"]) or unb64(r["compile_output"])).strip()
    last = out.splitlines()[-1] if out else ""
    return f"{r['status']['description']}: {last[:110]}"

# 1. Languages registered on the server.
print("== languages")
for lang in call("/languages"):
    if "Python" in lang["name"]:
        print(f"  {lang['id']}: {lang['name']}")

# 2. Version, modern syntax and standard-library modules.
PROBES = {
    "version": "import sys; print(sys.version.split()[0])",
    "list[int] hint": "def f(x: list[int]) -> dict[str, int]: return {'n': len(x)}\nprint(f([1, 2]))",
    "match statement": "match [1, 2]:\n    case [a, b]: print(a + b)",
    "X | None hint": "def f(x: int | None = None) -> int: return x or 0\nprint(f())",
    "PEP 701 f-string": "xs = ['a', 'b']\nprint(f\"{\", \".join(xs)}\")",
    "itertools.pairwise": "from itertools import pairwise; print(list(pairwise([1, 2, 3])))",
    # 3.11+ refuses to print ints over 4300 digits unless PYTHONINTMAXSTRDIGITS=0, as id 100 sets.
    "int of 5001 digits": "print(len(str(10**5000)))",
    "stdlib C modules": "import ssl, ctypes, sqlite3, decimal, zlib, lzma, bz2, hashlib, uuid, readline, json, heapq, bisect\n"
                        "from functools import cache; print(ssl.OPENSSL_VERSION)",
}
print("\n== syntax and modules            Python 3.8.1   |   Python 3.12")
probe_jobs = [(code, lid, "") for code in PROBES.values() for lid in (PY38, PY312)]
rs = run_many(probe_jobs)
for idx, name in enumerate(PROBES):
    print(f"  {name:<18} 3.8 -> {short(rs[2 * idx])}")
    print(f"  {'':<18} 3.12 -> {short(rs[2 * idx + 1])}")

# 3. The sandbox still enforces its limits on the new binary.
SANDBOX = {
    "network blocked": ("import socket\ns = socket.create_connection(('1.1.1.1', 80), timeout=3)\nprint('CONNECTED')", {}),
    "time limit": ("while True: pass", {"cpu_time_limit": 2, "wall_time_limit": 4}),
    "memory limit": ("x = bytearray(512 * 1024 * 1024)\nprint('ALLOCATED')", {"memory_limit": 128000}),
    "process limit": ("import os\nfor _ in range(200): os.fork()\nprint('FORKED')", {"max_processes_and_or_threads": 30}),
    "write outside box": ("open('/usr/local/hacked', 'w').write('x')\nprint('WROTE')", {}),
}
print("\n== sandbox on Python 3.12 (expect every one to fail or be stopped)")
rs = run_many([(code, PY312, "", extra) for code, extra in SANDBOX.values()])
for name, r in zip(SANDBOX, rs):
    print(f"  {name:<18} {short(r)}")

# 4. Every Python starter through its driver with sample 1, unchanged (body is `pass`).
samples = {s["slug"]: s["input"] for s in json.load(open(SAMPLES))}
slugs = sorted(p.name for p in DRIVERS.iterdir() if p.is_dir() and p.name != "lib")
missing = [s for s in slugs if s not in samples]
if missing:  # e.g. the database is behind the migrations that renamed these slugs
    print(f"\n  skipping {len(missing)} problems with no sample in the export: {missing}")
    slugs = [s for s in slugs if s in samples]
jobs = []
for slug in slugs:
    driver = (DRIVERS / slug / "python.py").read_text()
    driver = LIB.sub(lambda m: (DRIVERS / "lib/python" / f"{m.group(1)}.py").read_text(), driver)
    source = driver.replace("{USER_CODE}", (STARTERS / slug / "python.py").read_text())
    jobs += [(source, PY38, samples[slug] + "\n"), (source, PY312, samples[slug] + "\n")]
rs = run_many(jobs)

def loads(r):
    # A starter "loads" when the program gets past defining Solution: no TypeError from type hints.
    err = unb64(r["stderr"])
    return not ("not subscriptable" in err or "unsupported operand type(s) for |" in err or "SyntaxError" in err)

broken38 = [s for i, s in enumerate(slugs) if not loads(rs[2 * i])]
broken312 = [s for i, s in enumerate(slugs) if not loads(rs[2 * i + 1])]
other312 = {}
for i, s in enumerate(slugs):
    r = rs[2 * i + 1]
    if loads(r) and r["status"]["id"] not in (3, 4):  # 3 Accepted / 4 WA are both fine for a `pass` body
        other312[s] = short(r)
print(f"\n== {len(slugs)} Python starters, unchanged")
print(f"  fail to load on 3.8:  {len(broken38)}")
print(f"  fail to load on 3.12: {len(broken312)} {broken312}")
print(f"  other errors on 3.12 (from the empty `pass` body reaching the driver): {len(other312)}")
for s, why in list(other312.items())[:8]:
    print(f"    {s}: {why}")
