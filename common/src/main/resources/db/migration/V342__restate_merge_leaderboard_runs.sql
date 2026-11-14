-- V342: merge-leaderboard-runs restated. The method was combineOvenRotations, a
-- leftover from an oven theme; the examples spoke of friends never introduced; and the
-- Korean said lap times (랩 타임) where the English said run times. The task is now
-- stated first, the examples explain the merge without friends, and both languages
-- say run times (기록). Starter method combineOvenRotations -> mergeRuns. Examples match
-- the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Merge two sorted linked lists of run times, `runA` and `runB`, into one sorted list, and return its head.

Each list is sorted in non-decreasing order, and either may be empty (`null`). Build the result by relinking the existing nodes rather than creating new ones.

**Example 1:**
```
Input: runA = [2,5,9], runB = [3,4,7]
Output: [2,3,4,5,7,9]
Explanation: Taking the smaller of the two front times at each step gives 2, 3, 4, 5, 7, then the 9 left over.
```

**Example 2:**
```
Input: runA = [], runB = [2,4,6]
Output: [2,4,6]
Explanation: `runA` is empty, so the merged list is `runB` as it is.
```

**Example 3:**
```
Input: runA = [], runB = [3]
Output: [3]
Explanation: `runA` is empty and `runB` holds one time, so the merged list is that one node.
```$$,
    constraints = $$- The number of nodes in each list is in the range `[0, 60]`.
- `-100 <= Node.val <= 100`
- Both `runA` and `runB` are sorted in non-decreasing order.$$
WHERE slug = $$merge-leaderboard-runs$$;

UPDATE problem_translations SET
    description = $$정렬된 두 연결 리스트 `runA`와 `runB`에 담긴 기록을 하나의 정렬된 리스트로 합치고, 그 헤드를 반환하세요.

각 리스트는 비내림차순으로 정렬되어 있으며, 어느 쪽이든 비어 있을(`null`) 수 있습니다. 새 노드를 만들지 말고 기존 노드들을 다시 이어서 결과를 만드세요.

**예시 1:**
```
입력: runA = [2,5,9], runB = [3,4,7]
출력: [2,3,4,5,7,9]
설명: 매 단계 두 리스트의 맨 앞 기록 중 작은 것을 가져오면 2, 3, 4, 5, 7이 되고, 남은 9가 뒤에 붙습니다.
```

**예시 2:**
```
입력: runA = [], runB = [2,4,6]
출력: [2,4,6]
설명: `runA`가 비어 있으므로 합친 리스트는 `runB` 그대로입니다.
```

**예시 3:**
```
입력: runA = [], runB = [3]
출력: [3]
설명: `runA`는 비어 있고 `runB`에는 기록이 하나뿐이므로, 합친 리스트는 그 노드 하나입니다.
```$$,
    constraints = $$- 각 리스트의 노드 개수는 `[0, 60]` 범위 안에 있습니다.
- `-100 <= Node.val <= 100`
- `runA`와 `runB`는 모두 비내림차순으로 정렬되어 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$merge-leaderboard-runs$$);
