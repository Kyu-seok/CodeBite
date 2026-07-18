# Submission Load Test Results

**날짜**: 2026-07-18  
**도구**: k6 v2.1.0  
**대상 문제**: `snack-drawer-pair` (Python 코드, 제출→결과 폴링 패턴)  
**환경**: 로컬 (MacBook, Judge0 LAN 연결)

---

## 시나리오별 결과

| 지표 | smoke (1 VU) | load (5→10 VUs) | stress (20 VUs) |
|------|:-----------:|:---------------:|:---------------:|
| submission_duration p50 | 2.0s | 8.3s | 28.0s |
| submission_duration p95 | 2.1s | 17.7s | 39.1s |
| submission_duration max | 2.6s | 23.2s | 44.9s |
| 처리량 (iter/s) | 0.33 | 0.65 | 0.62 |
| http_req_failed | 0% | 0% | 0% |
| checks 통과율 | 100% | 100% | 100% |
| 총 iterations | 5 | 294 | 179 |
| 소요 시간 | 14.6s | 7m 31s | 4m 48s |

> `submission_duration` = `POST /submit` 직후부터 `GET /submissions/{id}`가 non-PENDING 상태를 반환할 때까지의 벽시계 시간

---

## 시나리오 정의

### smoke
- 1 VU × 5 iterations
- 스크립트 동작 검증

### load
```
1 VU →(30s)→ 5 VUs →(3m hold)→ 10 VUs →(3m hold)→ 0
```

### stress
```
1 VU →(1m)→ 20 VUs →(3m hold)→ 0
```

---

## 분석

### 병목: Judge0

`http_req_duration` (백엔드 API 응답 시간)은 20 VU에서도 p95 **24ms**로 일정. 백엔드, Worker, Kafka, DB는 부하 없음.

`submission_duration`이 VU 증가에 따라 선형으로 늘어나는 것은 Judge0 워커 큐 대기 시간이 원인.

```
1 VU  → p95  2.1s   (Judge0 즉시 처리)
10 VU → p95 17.7s   (큐 대기 ~15s 추가)
20 VU → p95 39.1s   (큐 대기 ~37s 추가)
```

### 처리량 포화

10 VU→20 VU 구간에서 iter/s가 **0.65→0.62**로 수렴. Judge0 처리 속도 ~0.65 submit/s가 현재 시스템의 실질적 처리량 상한선.

### 시스템 안정성

20 VU / 44.9s max에서도 에러 0%, thresholds(p95 < 60s) 모두 통과. 코드 경로상 버그나 타임아웃 없음.

---

## 결론

현재 처리량 상한선은 코드나 인프라(Kafka/Worker/DB)가 아닌 **Judge0 워커 수**에 의해 결정된다. 처리량을 높이려면:

1. Judge0 호스트의 워커 수 증가 (`JUDGE0_WORKERS` 환경변수)
2. Worker 인스턴스를 복수로 띄우기 (Kafka 파티션 수 = 3이므로 최대 3개까지 병렬 소비 가능)

---

## 재현 방법

```bash
# 1. 토큰 풀 생성 (dev 프로파일 백엔드 기동 후)
python3 scripts/perf/setup-test-users.py --count 25

# 2. smoke
k6 run --env SCENARIO=smoke scripts/perf/k6-submission-load.js

# 3. load
k6 run --env SCENARIO=load scripts/perf/k6-submission-load.js

# 4. stress
k6 run --env SCENARIO=stress scripts/perf/k6-submission-load.js
```

자세한 k6 사용법 → `scripts/perf/README.md`
