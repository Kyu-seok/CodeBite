-- V554: balanced-hamster-tree restated, Slug and title unchanged. The pet-shop family-tree opening
-- added nothing before the task: the statement now starts with it and says what a subtree's height
-- counts, which Example 2 relies on. Starter method checkHubEvenness -> isBalanced in all 4 Starter
-- Codes and Drivers. Examples match the sample test cases, which are unchanged, and Example 1 keeps
-- its Diagram.

UPDATE problems SET
    description = $$Given the `root` of a binary tree, return `true` if it is **balanced**: at every node, the heights of the left and right subtrees differ by at most one. A subtree's height is the number of nodes on its longest downward path, so an empty subtree has height `0`. An empty tree is balanced.

**Example 1:**
```
Input: root = [5,2,8,1,null,null,11]
Output: true
Explanation: Every node's left and right subtree heights differ by at most 1.
```

```diagram-tree
nodes: [5, 2, 8, 1, null, null, 11]
```

**Example 2:**
```
Input: root = [1,2,null,3,null,4]
Output: false
Explanation: The tree leans all the way left, 1 -> 2 -> 3 -> 4: the root's left subtree has height 3 while its right has height 0.
```

**Example 3:**
```
Input: root = [1,2]
Output: true
Explanation: The root's subtrees have heights 1 and 0, which differ by exactly one, so the tree is still balanced.
```$$
WHERE slug = $$balanced-hamster-tree$$;

UPDATE problem_translations SET
    description = $$이진 트리의 루트 `root`가 주어질 때, 트리가 **균형 잡혀** 있으면 `true`를 반환하세요. 균형 잡힌 트리란 모든 노드에서 왼쪽 서브트리와 오른쪽 서브트리의 높이 차가 1 이하인 트리입니다. 서브트리의 높이는 아래로 내려가는 가장 긴 경로 위의 노드 수이므로, 빈 서브트리의 높이는 `0`입니다. 빈 트리는 균형 잡힌 것으로 봅니다.

**예시 1:**
```
입력: root = [5,2,8,1,null,null,11]
출력: true
설명: 모든 노드에서 왼쪽과 오른쪽 서브트리의 높이 차가 1 이하입니다.
```

```diagram-tree
nodes: [5, 2, 8, 1, null, null, 11]
```

**예시 2:**
```
입력: root = [1,2,null,3,null,4]
출력: false
설명: 트리가 1 -> 2 -> 3 -> 4로 왼쪽으로만 늘어져 있어, 루트의 왼쪽 서브트리 높이는 3인데 오른쪽 서브트리 높이는 0입니다.
```

**예시 3:**
```
입력: root = [1,2]
출력: true
설명: 루트의 두 서브트리 높이가 1과 0으로 정확히 1 차이라서, 여전히 균형 잡혀 있습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$balanced-hamster-tree$$);
