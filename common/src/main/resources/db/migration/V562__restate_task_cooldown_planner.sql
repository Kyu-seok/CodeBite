-- V562: task-cooldown-planner restated, Slug and English title unchanged. "Within n slots of
-- each other" left the gap ambiguous: the statement now says two jobs with the same label need
-- at least n slots between them, and Example 3 (sample 3, n = 0) shows equal labels printed back
-- to back. The Korean title matches the English one. Starter method planStationRuns ->
-- minPrintSlots in all 4 Starter Codes and Drivers. Examples match the sample test cases, which
-- are unchanged.

UPDATE problems SET
    description = $$A shared office printer prints one job per time slot. Each job in `jobs` is labeled with an uppercase letter for the coworker who sent it, and two jobs with the same label need **at least `n` slots between them**. A slot may also sit idle, and the jobs can be printed in any order.

Return the minimum number of slots needed to print every job.

**Example 1:**
```
Input: jobs = ["P","P","P","P","Q","Q"], n = 3
Output: 13
Explanation: One shortest order is P, Q, idle, idle, P, Q, idle, idle, P, idle, idle, idle, P. Consecutive P jobs, and the two Q jobs, have 3 slots between them, for 13 slots in all.
```

**Example 2:**
```
Input: jobs = ["A","B","C","A","B","D"], n = 1
Output: 6
Explanation: In the given order, equal labels already have at least 1 slot between them, so no slot sits idle.
```

**Example 3:**
```
Input: jobs = ["R","R","S","S","T","T"], n = 0
Output: 6
Explanation: With n = 0, jobs with the same label may print back to back.
```$$
WHERE slug = $$task-cooldown-planner$$;

UPDATE problem_translations SET
    title = $$작업 쿨다운 플래너$$,
    description = $$사무실 공용 프린터는 한 슬롯에 작업을 하나씩 인쇄합니다. `jobs`의 각 작업에는 보낸 사람을 나타내는 영어 대문자 라벨이 붙어 있으며, 라벨이 같은 두 작업 사이에는 **최소 `n`개의 슬롯**이 있어야 합니다. 슬롯은 비워 둘 수도 있고, 작업은 어떤 순서로든 인쇄할 수 있습니다.

모든 작업을 인쇄하는 데 필요한 최소 슬롯 수를 반환하세요.

**예시 1:**
```
입력: jobs = ["P","P","P","P","Q","Q"], n = 3
출력: 13
설명: 가장 짧은 순서 중 하나는 P, Q, 빈칸, 빈칸, P, Q, 빈칸, 빈칸, P, 빈칸, 빈칸, 빈칸, P입니다. 이웃한 두 P 작업 사이와 두 Q 작업 사이에 슬롯이 3개씩 있으며, 모두 13 슬롯을 씁니다.
```

**예시 2:**
```
입력: jobs = ["A","B","C","A","B","D"], n = 1
출력: 6
설명: 주어진 순서에서 이미 같은 라벨 사이에 슬롯이 1개 이상 있으므로 빈 슬롯이 필요 없습니다.
```

**예시 3:**
```
입력: jobs = ["R","R","S","S","T","T"], n = 0
출력: 6
설명: `n`이 0이면 같은 라벨의 작업을 연달아 인쇄할 수 있습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$task-cooldown-planner$$);
