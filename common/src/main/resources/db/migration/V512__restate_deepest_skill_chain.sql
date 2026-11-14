-- V512: deepest-skill-chain restated, Slug and title unchanged. The opening line about perks
-- unlocking deeper skills was filler before the task: the statement now starts with it, and the
-- examples count nodes instead of "perks deep". Starter method deepestZoneChain -> maxSkillDepth
-- in all 4 Starter Codes and Drivers. Examples match the sample test cases, which are unchanged,
-- and Example 1 keeps its Diagram.

UPDATE problems SET
    description = $$Given the `root` of a skill tree (a binary tree), return its **maximum depth**: the number of nodes on the longest path from `root` down to a leaf. An empty tree has depth `0`.

**Example 1:**
```
Input: root = [8,5,12,null,null,9,17]
Output: 3
Explanation: The longest paths, 8 -> 12 -> 9 and 8 -> 12 -> 17, each have 3 nodes.
```

```diagram-tree
nodes: [8, 5, 12, null, null, 9, 17]
```

**Example 2:**
```
Input: root = [4,null,2,null,7]
Output: 3
Explanation: The only path, 4 -> 2 -> 7, has 3 nodes.
```$$
WHERE slug = $$deepest-skill-chain$$;

UPDATE problem_translations SET
    description = $$스킬 트리(이진 트리)의 루트 `root`가 주어질 때, 트리의 **최대 깊이**, 즉 `root`에서 리프까지 내려가는 가장 긴 경로 위의 노드 수를 반환하세요. 빈 트리의 깊이는 `0`입니다.

**예시 1:**
```
입력: root = [8,5,12,null,null,9,17]
출력: 3
설명: 가장 긴 경로인 8 -> 12 -> 9와 8 -> 12 -> 17은 둘 다 노드가 3개입니다.
```

```diagram-tree
nodes: [8, 5, 12, null, null, 9, 17]
```

**예시 2:**
```
입력: root = [4,null,2,null,7]
출력: 3
설명: 유일한 경로 4 -> 2 -> 7의 노드가 3개입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$deepest-skill-chain$$);
