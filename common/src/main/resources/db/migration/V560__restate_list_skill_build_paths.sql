-- V560: list-skill-build-paths restated, Slug and title unchanged. The first sentence now
-- states the task, the examples say "path" where they said "branch", and the statement says
-- the paths come back in any order (every Driver sorts them) and an empty list when none sums
-- to target. Starter method listRuntimeBranches -> listBuildPaths in all 4 Starter Codes and
-- Drivers. Examples match the sample test cases, which are unchanged, and Example 1 keeps its
-- Diagram.

UPDATE problems SET
    description = $$Given the root `root` of an RPG skill tree, where each node holds an XP value, and an integer `target`, return every **build path**: a path from the root down to a leaf whose node values sum to exactly `target`.

Each path is the list of its node values from the root down. A **leaf** is a node with no children. Return the paths in any order, or an empty list when no path sums to `target`.

**Example 1:**
```
Input: root = [10,6,9,3,null,4,5,null,null,8,2], target = 19
Output: [[10,6,3]]
Explanation: The only root-to-leaf path summing to 19 is 10 -> 6 -> 3.
```

```diagram-tree
nodes: [10, 6, 9, 3, null, 4, 5, null, null, 8, 2]
```

**Example 2:**
```
Input: root = [7,2,4,null,5,1,3], target = 14
Output: [[7,2,5],[7,4,3]]
Explanation: Two paths reach 14: 7 + 2 + 5 and 7 + 4 + 3.
```$$
WHERE slug = $$list-skill-build-paths$$;

UPDATE problem_translations SET
    description = $$각 노드에 XP 값이 들어 있는 RPG 스킬 트리의 루트 `root`와 정수 `target`이 주어질 때, 모든 **빌드 경로**를 반환하세요. 빌드 경로는 루트에서 리프까지 내려가는 경로 중 노드 값의 합이 정확히 `target`인 경로입니다.

각 경로는 루트부터 아래로 노드 값을 담은 리스트입니다. **리프**는 자식이 없는 노드입니다. 경로는 어떤 순서로 반환해도 되며, 합이 `target`인 경로가 없으면 빈 리스트를 반환합니다.

**예시 1:**
```
입력: root = [10,6,9,3,null,4,5,null,null,8,2], target = 19
출력: [[10,6,3]]
설명: 합이 19가 되는 루트-리프 경로는 10 -> 6 -> 3 하나뿐입니다.
```

```diagram-tree
nodes: [10, 6, 9, 3, null, 4, 5, null, null, 8, 2]
```

**예시 2:**
```
입력: root = [7,2,4,null,5,1,3], target = 14
출력: [[7,2,5],[7,4,3]]
설명: 합이 14가 되는 경로는 7 + 2 + 5와 7 + 4 + 3, 두 개입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$list-skill-build-paths$$);
