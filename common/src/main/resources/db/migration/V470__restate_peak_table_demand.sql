-- V470: peak-table-demand restated. The constraint 1 <= visits.length was false, since a
-- hidden case is [] (expected 0): it now allows no visits and says that needs 0 tables.
-- Starter method findPeakGates (min_meeting_rooms in Python) -> minTables in all 4 Starter
-- Codes and Drivers. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$A cafe wants to know how many tables it needs at its busiest. `visits[i] = [arrive, leave]` is the minute a group sits down and the minute it leaves. A group occupies a table for the half-open interval `[arrive, leave)`, so a new group may take the same table the minute the previous one leaves.

Return the **minimum** number of tables needed so every group has a seat for its full stay. With no visits, no tables are needed: return `0`.

**Example 1:**
```
Input: visits = [[60,180],[90,150],[120,240],[200,300]]
Output: 3
Explanation: Between minute 120 and 150, three groups are seated at once, so three tables are required.
```

```diagram-intervals
intervals: [[60,180],[90,150],[120,240],[200,300]]
```

**Example 2:**
```
Input: visits = [[500,600],[100,200]]
Output: 1
Explanation: The two groups never overlap, so one table is enough.
```$$,
    constraints = $$- `0 <= visits.length <= 8000`
- `0 <= arrive < leave <= 2 * 10^5`$$
WHERE slug = $$peak-table-demand$$;

UPDATE problem_translations SET
    description = $$카페에서 가장 붐빌 때 테이블이 몇 개 필요한지 알고 싶습니다. `visits[i] = [arrive, leave]`는 어떤 팀이 자리에 앉은 시각과 일어선 시각(분)을 뜻합니다. 한 팀은 테이블을 반열린 구간 `[arrive, leave)` 동안 점유하므로, 이전 팀이 떠난 바로 그 분에 새 팀이 같은 테이블을 쓸 수 있습니다.

모든 팀이 머무는 동안 각자 자리를 차지할 수 있도록, 필요한 테이블의 **최소** 개수를 반환하세요. 방문한 팀이 없으면 테이블이 필요 없으므로 `0`을 반환합니다.

**예시 1:**
```
입력: visits = [[60,180],[90,150],[120,240],[200,300]]
출력: 3
설명: 120분과 150분 사이에는 세 팀이 동시에 앉아 있으므로 테이블이 세 개 필요합니다.
```

```diagram-intervals
intervals: [[60,180],[90,150],[120,240],[200,300]]
```

**예시 2:**
```
입력: visits = [[500,600],[100,200]]
출력: 1
설명: 두 팀의 시간대가 전혀 겹치지 않으므로 테이블 한 개면 충분합니다.
```$$,
    constraints = $$- `0 <= visits.length <= 8000`
- `0 <= arrive < leave <= 2 * 10^5`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$peak-table-demand$$);
