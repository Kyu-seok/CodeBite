-- V485: redundant-friendship restated, Slug, title and names unchanged. Example 2 said
-- "Both [3,4] and [2,5] belong to it", while [2,3] and [4,5] are on the cycle too; it now
-- names every edge of the cycle and why [2,5] is the answer. The description states the
-- rule once: removing any edge of the cycle leaves a tree, and the answer is the cycle
-- edge that appears last in links. Examples match the sample test cases, which are
-- unchanged.

UPDATE problems SET
    description = $$`n` students labeled `1` to `n` are linked by `n` undirected friendships, `links[i] = [a, b]`. The friendships were meant to form a tree, but one extra friendship was added, so the graph is connected and has exactly one cycle.

Removing any friendship on the cycle turns the graph back into a tree. Return the one of them that appears **last** in `links`.

**Example 1:**
```
Input: links = [[1,2],[1,3],[2,3]]
Output: [2,3]
Explanation: The cycle is 1 - 2 - 3 - 1, so [1,2], [1,3] and [2,3] could each go. [2,3] appears last in links.
```

```diagram-graph
edges: [[1,2],[1,3],[2,3]]
directed: false
highlight_path: [2,3]
```

**Example 2:**
```
Input: links = [[1,2],[2,3],[3,4],[4,5],[2,5],[1,6]]
Output: [2,5]
Explanation: The cycle is 2 - 3 - 4 - 5 - 2, so [2,3], [3,4], [4,5] and [2,5] could each go. [2,5] appears last of them in links; [1,6] comes later but is not on the cycle.
```$$,
    constraints = $$- `n == links.length`
- `3 <= n <= 1200`
- `links[i].length == 2`
- `1 <= links[i][0], links[i][1] <= n`
- `links[i][0] != links[i][1]`
- No two links describe the same pair.
- The graph is connected and contains exactly one cycle.$$
WHERE slug = $$redundant-friendship$$;

UPDATE problem_translations SET
    description = $$`1`부터 `n`까지 번호가 매겨진 학생 `n`명이 방향 없는 친구 관계 `n`개, `links[i] = [a, b]`로 이어져 있습니다. 친구 관계는 원래 트리를 이루어야 했지만 하나가 더 추가되어, 지금 그래프는 연결되어 있고 순환이 정확히 하나 있습니다.

순환 위의 친구 관계 중 아무거나 하나를 없애면 그래프는 다시 트리가 됩니다. 그중 `links`에서 **가장 나중에** 나오는 것을 반환하세요.

**예시 1:**
```
입력: links = [[1,2],[1,3],[2,3]]
출력: [2,3]
설명: 순환은 1 - 2 - 3 - 1이므로 [1,2], [1,3], [2,3] 중 어느 것을 없애도 됩니다. links에서 가장 나중에 나오는 것은 [2,3]입니다.
```

```diagram-graph
edges: [[1,2],[1,3],[2,3]]
directed: false
highlight_path: [2,3]
```

**예시 2:**
```
입력: links = [[1,2],[2,3],[3,4],[4,5],[2,5],[1,6]]
출력: [2,5]
설명: 순환은 2 - 3 - 4 - 5 - 2이므로 [2,3], [3,4], [4,5], [2,5] 중 어느 것을 없애도 됩니다. 이 중 links에서 가장 나중에 나오는 것은 [2,5]입니다. [1,6]은 더 뒤에 있지만 순환 위에 있지 않습니다.
```$$,
    constraints = $$- `n == links.length`
- `3 <= n <= 1200`
- `links[i].length == 2`
- `1 <= links[i][0], links[i][1] <= n`
- `links[i][0] != links[i][1]`
- 같은 쌍을 나타내는 친구 관계는 두 번 나오지 않습니다.
- 그래프는 연결되어 있고 순환을 정확히 하나 포함합니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$redundant-friendship$$);
