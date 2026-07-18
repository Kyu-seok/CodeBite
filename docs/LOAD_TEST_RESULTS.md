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

## Round 3 — Java OpenJ9 실험 (2026-07-18)

Round 2에서 Java smoke 기준 wall time 7.5s 중 JVM cold start가 ~3.5s를 차지한다고 분석.  
IBM Semeru OpenJ9 17 (AOT 클래스 캐시로 HotSpot 대비 40~60% 빠른 시작 주장)을 Judge0 커스텀 이미지에 탑재하여 재측정.

### 구현 내용

- `infra/judge0/Dockerfile`: `judge0/judge0:1.13.1` 기반에 IBM Semeru OpenJ9 17 설치 + 빌드 시점 AOT 캐시(`/var/cache/openj9`) 사전 생성
- `languages` 테이블에 ID 90 (`Java (IBM Semeru OpenJ9 17)`) 추가
- run_cmd: `/usr/local/semeru17/bin/java -Xshareclasses:name=judge0cache,cacheDir=/var/cache/openj9 -Xms8m -Xmx256m Main`

### 실험 결과: 실패

| 지표 | HotSpot (기존) | OpenJ9 + `-Xtune:virtualized` |
|------|:-----------:|:-----:|
| submission_duration avg | 7.5s | **13.33s** ❌ |
| submission_duration p95 | 7.8s | **13.93s** ❌ |
| checks 통과율 | 100% | 100% |

### 원인 분석

1. **isolate sandbox와 mlock 호환성 문제**  
   OpenJ9은 `FlushProcessWriteBuffers.cpp:85`에서 `mlock()` syscall의 반환값이 0임을 단언(assert). Judge0 isolate 샌드박스는 `mlock`을 허용하지 않아 assertion fail → JVM crash. `compile_output`에 아래 오류 출력:
   ```
   ** ASSERTION FAILED ** at FlushProcessWriteBuffers.cpp:85: ((0 == mlockrc))
   JVMDUMP039I Processing dump event "traceassert"...
   ```

2. **`-Xtune:virtualized`로 mlock 우회 시 성능 역전**  
   OpenJ9의 컨테이너 최적화 플래그 `-Xtune:virtualized`를 추가하면 JVM이 기동되지만, JIT 공격성이 낮아져 **HotSpot보다 78% 느림** (7.5s → 13.33s).

3. **AOT 캐시가 isolate 샌드박스 안에서 동작 불가**  
   isolate는 `cgroup` + 네임스페이스 기반 파일시스템 격리를 적용. 호스트의 `/var/cache/openj9` 캐시 파일이 샌드박스 내부에서 보이지 않아 `-Xshareclasses` 효과 없음. (컨테이너 외부에서 측정한 JVM 시작 단축 5× 효과는 이 경우 무의미.)

### 결론

OpenJ9의 이점(AOT 캐시 + 빠른 cold start)은 **장수 JVM 프로세스**에서 발휘됨. Judge0의 short-lived isolate 실행 모델과 근본적으로 맞지 않으며, mlock 의존성이 isolate의 syscall 제한과 충돌. **HotSpot(language_id=62)으로 복귀.**

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
