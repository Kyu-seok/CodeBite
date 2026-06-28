# Performance Measurement Scripts

Tools for measuring CodeBite submission latency and comparing before/after states.

## `measure_latency.py`

Submits a solution N times and reports min / p50 / p95 / p99 / max / mean wall-clock time from submit until the backend returns a non-PENDING status. Uses stdlib only; no `pip install` needed.

### Prerequisites

1. **Backend + worker + infra running** (docker-compose with Postgres + Kafka + Redis + Judge0, plus the Spring apps).
2. **JWT token** — log into the frontend in a browser, then copy the token. In DevTools console:
   ```js
   localStorage.getItem("auth.token")  // adjust key if different
   ```
3. **A problem with many test cases** to amplify any per-case overhead. Pick one with 10+ test cases for a meaningful signal. List them via `GET /api/problems/{slug}` and count `sampleTestCases` + admin-only `testCases`.
4. **A solution file** that you expect to pass (or fail consistently) — keeps the measurement stable across runs. Write it to e.g. `solution.java`.

### Single run

```bash
python3 scripts/perf/measure_latency.py measure \
  --base-url http://localhost:8080 \
  --token "$JWT" \
  --slug two-sum \
  --language java \
  --source-file solution.java \
  --runs 10 \
  --label after \
  --out after.json
```

Output: per-run line + summary block. The `--out` JSON contains both summary stats and raw per-run times.

### A/B comparison workflow

The four perf fixes (#1, #2, #3, #4) span code in `common/`, `worker/`, and `frontend/`. To isolate the worker-side improvement, this script measures **backend-only** latency (submit → first non-PENDING) — the frontend's polling cadence does not factor in.

**Step 1 — "after" measurement (current master)**

Make sure `master` is checked out and the worker + backend are running on the current build:

```bash
git checkout master
./gradlew :worker:bootRun &     # in one terminal
./gradlew :backend:bootRun &    # in another
# ... wait for both to be ready ...

python3 scripts/perf/measure_latency.py measure \
  --base-url http://localhost:8080 \
  --token "$JWT" \
  --slug <slug> --language java --source-file solution.java \
  --runs 10 --label after --out after.json
```

**Step 2 — "before" measurement (pre-fix commit)**

Stop the running worker + backend processes. Then check out the commit immediately *before* any of the four perf PRs were merged. The four merge commits are `6780fb7`, `fbbc24e`, `d4c2e98`, `a8a76e1` — their common parent (and the first commit *before* any perf change) is `457fe40` (the `docs: add git workflow guide` merge). Use its parent for a clean "before":

```bash
git checkout a2dbfc1    # last functional commit before perf series
./gradlew :common:build :worker:build :backend:build
./gradlew :worker:bootRun &
./gradlew :backend:bootRun &
# ... wait ...

python3 scripts/perf/measure_latency.py measure \
  --base-url http://localhost:8080 \
  --token "$JWT" \
  --slug <slug> --language java --source-file solution.java \
  --runs 10 --label before --out before.json
```

**Step 3 — compare**

```bash
python3 scripts/perf/measure_latency.py compare before.json after.json
```

Output shows side-by-side stats plus a delta line per percentile:

```
=== delta (before -> after) ===
  min_s   :   5.821s ->   1.234s  ( -78.8%, 4.72x)
  p50_s   :   6.103s ->   1.412s  ( -76.9%, 4.32x)
  p95_s   :   7.214s ->   1.788s  ( -75.2%, 4.04x)
  ...
```

**Step 4 — clean up**

```bash
git checkout master
./gradlew :common:build :worker:build :backend:build
```

### Interpreting results

Expected ranges based on the latency analysis (10-test-case submission, Judge0 on LAN):

| Metric | Before (pre-fix) | After (master) | Improvement |
|---|---|---|---|
| p50 | ~6–9s | ~1–2s | ~5x |
| p95 | tail >10s | ~2–3s | ~4x |

If the **after** numbers are still high (e.g. p50 > 3s), the bottleneck is not in the code we changed — it is almost certainly Judge0 itself. Verify on the Judge0 host:

```bash
ssh <judge0-host>
docker stats              # are Judge0 workers CPU-saturated?
docker logs judge0-workers --tail=100 | grep -i 'queue\|wait'
```

If the **before/after delta is tiny**, the measurement is probably not actually hitting different code paths (worker didn't restart, wrong commit, etc.). Re-check that the worker process is on the right commit (`ps` + check the jar timestamp).

### Flags worth knowing

- `--poll-interval 0.05` — how often the script polls the GET endpoint. 50ms is tight (~20 QPS per pending submission) to avoid the script's own polling cadence adding noise. Increase to 0.5 if you want to mimic the frontend.
- `--between 0.5` — sleep between runs to avoid hot worker queue / Kafka batching from skewing samples. Increase if you see suspicious clustering.
- `--runs 20` — more runs = tighter percentiles. 10 is enough for a quick eyeball; 20–30 for a confident p95.

### Notes on what this measures

- **Backend → DB write time only** (worker side). The frontend's 500ms polling tail (#9) is not included.
- Network from this script to `localhost:8080` is loopback, negligible.
- Judge0 host load is **not** controlled — repeated runs may warm caches or saturate workers. The `--between` knob mitigates but doesn't eliminate.
