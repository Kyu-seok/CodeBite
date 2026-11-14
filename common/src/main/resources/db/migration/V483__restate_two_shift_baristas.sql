-- V483: two-shift-baristas restated, Slug, title and names unchanged. "Split into exactly
-- two shifts" implied both shifts are non-empty, while [[]] (one barista) expects true,
-- and n was never tied to conflicts.length. The statement now says n = conflicts.length
-- and that a shift may be empty. Examples match the sample test cases, which are
-- unchanged.

UPDATE problems SET
    description = $$A café has `n` baristas, numbered `0` to `n - 1`, where `n = conflicts.length`. `conflicts[i]` lists the baristas who can't work a shift with barista `i`; conflicts go both ways, and they may form several separate groups.

Return `true` if the baristas can be split into two shifts so that no two conflicting baristas share a shift, and `false` otherwise. A shift may be left empty, and baristas with no conflicts can go on either shift.

**Example 1:**
```
Input: conflicts = [[1],[0,2],[1,3],[2]]
Output: true
Explanation: Baristas 0 and 2 take one shift and 1 and 3 the other; every conflict is between the two shifts.
```

```diagram-graph
edges: [[0,1],[1,2],[2,3]]
directed: false
```

**Example 2:**
```
Input: conflicts = [[1,2],[0,2],[0,1]]
Output: false
Explanation: Baristas 0, 1 and 2 all conflict with each other, so any split puts two of them on the same shift.
```$$,
    constraints = $$- `1 <= conflicts.length <= 150`
- `0 <= conflicts[i].length < conflicts.length`
- `conflicts[i]` does not contain `i`.
- If `conflicts[i]` contains `j`, then `conflicts[j]` contains `i`.$$
WHERE slug = $$two-shift-baristas$$;

UPDATE problem_translations SET
    description = $$카페에 `0`부터 `n - 1`까지 번호가 매겨진 바리스타 `n`명이 있고, `n = conflicts.length`입니다. `conflicts[i]`에는 바리스타 `i`와 같은 교대에서 일할 수 없는 바리스타들의 번호가 들어 있으며, 충돌 관계는 양방향이고 여러 개의 분리된 무리를 이룰 수 있습니다.

충돌하는 두 바리스타가 같은 교대에 들어가지 않도록 바리스타들을 두 교대로 나눌 수 있으면 `true`, 없으면 `false`를 반환하세요. 한 교대가 비어 있어도 되고, 충돌이 없는 바리스타는 어느 교대에 들어가도 됩니다.

**예시 1:**
```
입력: conflicts = [[1],[0,2],[1,3],[2]]
출력: true
설명: 바리스타 0과 2가 한 교대, 1과 3이 다른 교대를 맡으면 모든 충돌이 서로 다른 교대 사이에 놓입니다.
```

```diagram-graph
edges: [[0,1],[1,2],[2,3]]
directed: false
```

**예시 2:**
```
입력: conflicts = [[1,2],[0,2],[0,1]]
출력: false
설명: 바리스타 0, 1, 2가 서로 모두 충돌하므로 어떻게 나누어도 둘은 같은 교대에 들어갑니다.
```$$,
    constraints = $$- `1 <= conflicts.length <= 150`
- `0 <= conflicts[i].length < conflicts.length`
- `conflicts[i]`는 `i`를 포함하지 않습니다.
- `conflicts[i]`에 `j`가 있으면 `conflicts[j]`에도 `i`가 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$two-shift-baristas$$);
