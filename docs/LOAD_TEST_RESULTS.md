# Submission Load Test Results

**도구**: k6 v2.1.0  
**대상 문제**: `snack-drawer-pair`  
**환경**: 로컬 MacBook → Judge0 LAN (192.168.219.200), 호스트 RAM 15.37GiB

> `submission_duration` = `POST /submit` 직후부터 `GET /submissions/{id}`가 non-PENDING 상태를 반환할 때까지의 벽시계 시간

---

## Round 1 — Python (2026-07-18)

Python은 실행 시간이 짧아 Judge0 컨테이너 스폰 오버헤드 + 워커 큐가 주 병목일 것이라 가정하고 실시.

| 지표 | smoke (1 VU) | load (5→10 VUs) | stress (20 VUs) |
|------|:-----------:|:---------------:|:---------------:|
| submission_duration p50 | 2.0s | 8.3s | 28.0s |
| submission_duration p95 | 2.1s | 17.7s | 39.1s |
| submission_duration max | 2.6s | 23.2s | 44.9s |
| 처리량 (iter/s) | 0.33 | 0.65 | 0.62 |
| http_req_failed | 0% | 0% | 0% |
| checks 통과율 | 100% | 100% | 100% |
| 총 iterations | 5 | 294 | 179 |

### 관찰

- `http_req_duration` p95 = 24ms(20 VU) → 백엔드/Worker/Kafka/DB는 부하 없음
- 10 VU→20 VU 구간에서 처리량이 0.65→0.62로 수렴 → Judge0 처리 속도가 상한선
- 초기 분석: **Judge0 워커 큐 깊이**가 병목으로 추정

---

## Round 2 — Java (2026-07-18)

Python 결과 검토 후 "병목이 CPU 아니냐"는 의문이 제기됨. Java는 컴파일 단계가 있어 CPU를 실제로 소비하므로, 더 현실적인 지표를 얻기 위해 Java로 재측정. **stress 테스트 중 SSH로 Judge0 호스트의 CPU%를 10초 간격으로 수집.**

### Judge0 호스트 CPU 모니터링 (stress 20 VUs 중)

| 시각 | judge0-workers CPU% |
|------|:-------------------:|
| 15:47:51 | 362% |
| 15:48:03 | 377% |
| 15:48:16 | 215% |
| 15:48:29 | 246% |
| 15:48:41 | 367% |
| 15:48:54 | 211% |
| 15:49:06 | 374% |
| 15:49:19 | 376% |
| 15:49:32 | 298% |
| 15:49:44 | 375% |
| 15:50:09 | 237% |
| 15:50:22 | 377% |
| 15:50:35 | 365% |
| 15:51:00 | 362% |
| 15:51:13 | 381% |
| 15:51:26 | 212% |
| 15:51:38 | 374% |
| 15:51:51 | 365% |
| 15:52:16 | 354% |
| 15:52:29 | 378% |
| **평균** | **~320%** |
| **피크** | **381%** |

> `docker stats` CPU%는 코어 수 × 100% 기준. 380% = 4코어 풀가동 = **CPU 완전 포화**

### 시나리오별 결과

| 지표 | smoke (1 VU) | stress (20 VUs) |
|------|:-----------:|:---------------:|
| submission_duration p50 | 7.5s | 90s (타임아웃) |
| submission_duration p95 | 7.8s | **90s** ❌ |
| 90초 폴링 타임아웃 초과 | 0건 | **35건** |
| http_req_failed | 0% | 0% |
| checks 통과율 | 100% | **71.5%** ❌ |
| 총 iterations | 5 | 53 (+ 17 interrupted) |

> smoke 1 VU 기준 Java(7.8s) vs Python(2.1s) → Java가 **3.7배** 더 오래 걸림 (컴파일 오버헤드)

---

## 결론

### Python과 Java 비교

| | Python stress | Java stress |
|--|:--:|:--:|
| CPU 포화 여부 | 미확인 | **확인 (평균 320%)** |
| 타임아웃 발생 | 0건 | 35건 |
| checks 통과율 | 100% | 71.5% |

### 병목 확정: CPU (Java 기준)

Round 1에서 추정한 "워커 큐 깊이"가 아닌, **Judge0 호스트 CPU 자체**가 실질적 상한선.  
Java 컴파일이 CPU를 소비하는 상황에서 `JUDGE0_WORKERS`를 늘리면 코어 경쟁만 심해져 오히려 역효과.

### 백엔드/인프라는 무관

두 라운드 모두 `http_req_duration` p95 < 60ms. Kafka, Worker, DB, Spring 코드에는 개선 여지 없음.

### 처리량을 높이려면

1. **Judge0 호스트에 CPU 코어 추가** — 근본적 해결
2. **더 많은 코어를 가진 머신으로 Judge0 이전** — 근본적 해결
3. **언어별 제출 rate limit 차등 적용** — Java/C++ 제출은 더 공격적으로 제한하여 CPU 포화 방지

---

## 재현 방법

```bash
# 1. 토큰 풀 생성 (dev 프로파일 백엔드 기동 후)
python3 scripts/perf/setup-test-users.py --count 25

# 2. smoke (Java)
k6 run --env SCENARIO=smoke scripts/perf/k6-submission-load.js

# 3. stress + CPU 모니터링 동시 실행
k6 run --env SCENARIO=stress scripts/perf/k6-submission-load.js &
K6_PID=$!
for i in $(seq 1 25); do
  echo "[$(date '+%H:%M:%S')] $(ssh 192.168.219.200 \
    "docker stats --no-stream --format '{{.Name}}\t{{.CPUPerc}}' | grep judge0-workers")"
  sleep 10
done
wait $K6_PID
```

자세한 k6 사용법 → `scripts/perf/README.md`
