/**
 * CodeBite Submission Load Test
 *
 * Measures end-to-end submission latency under concurrent load.
 * Each VU submits code, then polls until the submission is no longer PENDING.
 *
 * Prerequisites:
 *   1. Backend + worker + infra running (docker-compose + Spring apps in dev profile)
 *   2. tokens.json generated: python3 scripts/perf/setup-test-users.py
 *
 * Run scenarios:
 *   # Smoke (verify script works)
 *   k6 run --env SCENARIO=smoke scripts/perf/k6-submission-load.js
 *
 *   # Load (5 VUs, then 10 VUs)
 *   k6 run --env SCENARIO=load scripts/perf/k6-submission-load.js
 *
 *   # Stress (ramp up to 20 VUs)
 *   k6 run --env SCENARIO=stress scripts/perf/k6-submission-load.js
 *
 *   # With Grafana (Prometheus remote write)
 *   K6_PROMETHEUS_RW_SERVER_URL=http://localhost:9090/api/v1/write \
 *   k6 run --out experimental-prometheus-rw --env SCENARIO=load \
 *     scripts/perf/k6-submission-load.js
 *
 * Env vars:
 *   BASE_URL   Backend URL (default: http://localhost:8080)
 *   SLUG       Problem slug to submit to (default: two-sum)
 *   LANGUAGE   Language to use (default: python)
 *   SCENARIO   smoke | load | stress (default: smoke)
 */

import http from "k6/http";
import { check, sleep } from "k6";
import { Trend } from "k6/metrics";
import { SharedArray } from "k6/data";

// ── Configuration ──────────────────────────────────────────────────────────
const BASE_URL = __ENV.BASE_URL || "http://localhost:8080";
const SLUG = __ENV.SLUG || "two-sum";
const LANGUAGE = __ENV.LANGUAGE || "python";
const SCENARIO = __ENV.SCENARIO || "smoke";

// ── Token pool ─────────────────────────────────────────────────────────────
const tokenPool = new SharedArray("tokens", function () {
  return JSON.parse(open("./tokens.json")).map((t) => t.token);
});

// ── Source code per language ───────────────────────────────────────────────
// Minimal accepted solutions — keep short to avoid source-size variance.
const SOURCE_CODE = {
  python: `
def solution(nums, target):
    seen = {}
    for i, n in enumerate(nums):
        if target - n in seen:
            return [seen[target - n], i]
        seen[n] = i
    return []
`.trim(),
  java: `
public static int[] solution(int[] nums, int target) {
    java.util.Map<Integer,Integer> map = new java.util.HashMap<>();
    for (int i = 0; i < nums.length; i++) {
        int diff = target - nums[i];
        if (map.containsKey(diff)) return new int[]{map.get(diff), i};
        map.put(nums[i], i);
    }
    return new int[]{};
}
`.trim(),
  javascript: `
function solution(nums, target) {
  const seen = {};
  for (let i = 0; i < nums.length; i++) {
    const diff = target - nums[i];
    if (diff in seen) return [seen[diff], i];
    seen[nums[i]] = i;
  }
  return [];
}
`.trim(),
  cpp: `
#include <vector>
#include <unordered_map>
std::vector<int> solution(std::vector<int>& nums, int target) {
    std::unordered_map<int,int> m;
    for (int i = 0; i < (int)nums.size(); i++) {
        int d = target - nums[i];
        if (m.count(d)) return {m[d], i};
        m[nums[i]] = i;
    }
    return {};
}
`.trim(),
};

// ── Custom metrics ─────────────────────────────────────────────────────────
const submissionDuration = new Trend("submission_duration", true); // ms, report in ms

// ── Scenarios ──────────────────────────────────────────────────────────────
const SCENARIOS = {
  smoke: {
    executor: "per-vu-iterations",
    vus: 1,
    iterations: 5,
    maxDuration: "3m",
  },
  load: {
    executor: "ramping-vus",
    startVUs: 1,
    stages: [
      { duration: "30s", target: 5 },   // ramp to 5
      { duration: "3m", target: 5 },    // hold 5 VUs
      { duration: "30s", target: 10 },  // ramp to 10
      { duration: "3m", target: 10 },   // hold 10 VUs
      { duration: "30s", target: 0 },   // ramp down
    ],
  },
  stress: {
    executor: "ramping-vus",
    startVUs: 1,
    stages: [
      { duration: "1m", target: 20 },   // ramp to 20
      { duration: "3m", target: 20 },   // hold
      { duration: "30s", target: 0 },
    ],
  },
};

// ── k6 options ─────────────────────────────────────────────────────────────
export const options = {
  scenarios: { [SCENARIO]: SCENARIOS[SCENARIO] },
  thresholds: {
    // 95% of submissions should resolve within 60s
    submission_duration: ["p(95)<60000"],
    // Overall check pass rate > 90%
    checks: ["rate>0.9"],
  },
};

// ── Main VU function ────────────────────────────────────────────────────────
export default function () {
  const token = tokenPool[__VU % tokenPool.length];
  const headers = {
    Authorization: `Bearer ${token}`,
    "Content-Type": "application/json",
  };

  const submitPayload = JSON.stringify({
    language: LANGUAGE,
    sourceCode: SOURCE_CODE[LANGUAGE] || SOURCE_CODE.python,
  });

  // 1. Submit
  const submitRes = http.post(
    `${BASE_URL}/api/problems/${SLUG}/submit`,
    submitPayload,
    { headers, tags: { name: "submit" } }
  );

  const submitOk = check(submitRes, {
    "submit: status 201": (r) => r.status === 201,
    "submit: has id": (r) => r.json("id") !== null,
  });

  if (!submitOk) {
    console.error(`Submit failed [VU${__VU}]: ${submitRes.status} — ${submitRes.body}`);
    return;
  }

  const submissionId = submitRes.json("id");
  const startMs = Date.now();

  // 2. Poll until non-PENDING (max 90s)
  let finalStatus = "PENDING";
  let pollCount = 0;
  while (Date.now() - startMs < 90_000) {
    sleep(0.5);
    const pollRes = http.get(
      `${BASE_URL}/api/submissions/${submissionId}`,
      { headers, tags: { name: "poll" } }
    );
    if (pollRes.status !== 200) {
      console.warn(`Poll ${pollCount} failed [VU${__VU}]: ${pollRes.status}`);
      break;
    }
    finalStatus = pollRes.json("status");
    pollCount++;
    if (finalStatus !== "PENDING") break;
  }

  const durationMs = Date.now() - startMs;
  submissionDuration.add(durationMs);

  check(finalStatus, {
    "resolved (not PENDING/timeout)": (s) => s !== "PENDING",
    "accepted or deterministic result": (s) =>
      ["ACCEPTED", "WRONG_ANSWER", "COMPILATION_ERROR",
       "RUNTIME_ERROR", "TIME_LIMIT_EXCEEDED"].includes(s),
  });

  console.log(
    `VU${__VU} iter${__ITER}: id=${submissionId} status=${finalStatus} ` +
    `duration=${(durationMs / 1000).toFixed(2)}s polls=${pollCount}`
  );

  // Brief pause between iterations to avoid rate limiter (10 req/user)
  sleep(1);
}
