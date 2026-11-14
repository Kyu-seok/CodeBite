-- V555: zigzag-yearbook-order restated, Slug and title unchanged. The yearbook-photo opening came
-- before the task and had to be read back as tree levels: the statement now starts with the task,
-- and sample 3 (the empty tree) becomes Example 3. Starter method alternateWardSweep (wards,
-- from an earlier theme) -> zigzagRows in all 4 Starter Codes and Drivers. Examples match the sample
-- test cases, which are unchanged, and Example 1 keeps its Diagram.

UPDATE problems SET
    description = $$Given the `root` of a binary tree, return its node values level by level in zigzag order: the top level left to right, the next level right to left, and so on, alternating. Each level is an inner list, and the outer list runs from the top level down. An empty tree has no levels, so the result is an empty list.

**Example 1:**
```
Input: root = [5,3,7,2,9,6,8]
Output: [[5],[7,3],[2,9,6,8]]
Explanation: Level 0 reads left to right as [5], level 1 right to left as [7,3], and level 2 left to right as [2,9,6,8].
```

```diagram-tree
nodes: [5, 3, 7, 2, 9, 6, 8]
```

**Example 2:**
```
Input: root = [4]
Output: [[4]]
Explanation: A single node is a level of its own.
```

**Example 3:**
```
Input: root = []
Output: []
Explanation: An empty tree has no levels.
```$$
WHERE slug = $$zigzag-yearbook-order$$;

UPDATE problem_translations SET
    description = $$이진 트리의 루트 `root`가 주어질 때, 노드 값을 레벨별로 지그재그 순서로 읽어 반환하세요. 맨 위 레벨은 왼쪽에서 오른쪽으로, 다음 레벨은 오른쪽에서 왼쪽으로 읽으며 방향을 번갈아 바꿉니다. 각 레벨은 내부 리스트이고 바깥 리스트는 맨 위 레벨부터 아래로 진행합니다. 빈 트리에는 레벨이 없으므로 빈 리스트를 반환합니다.

**예시 1:**
```
입력: root = [5,3,7,2,9,6,8]
출력: [[5],[7,3],[2,9,6,8]]
설명: 0번 레벨은 왼쪽에서 오른쪽으로 [5], 1번 레벨은 오른쪽에서 왼쪽으로 [7,3], 2번 레벨은 다시 왼쪽에서 오른쪽으로 [2,9,6,8]이 됩니다.
```

```diagram-tree
nodes: [5, 3, 7, 2, 9, 6, 8]
```

**예시 2:**
```
입력: root = [4]
출력: [[4]]
설명: 노드가 하나뿐이면 그 노드만으로 한 레벨이 됩니다.
```

**예시 3:**
```
입력: root = []
출력: []
설명: 빈 트리에는 레벨이 없습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$zigzag-yearbook-order$$);
