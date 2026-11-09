-- V273: restate binary-tree-level-order (#205, part of #193). The Examples showed trees no
-- sample Test Case holds ([3,9,20,null,null,15,7], [1], []); each now shows its sample's input
-- and expected output, in English and Korean, the Example 1 Diagram is redrawn to the sample's
-- tree and the Korean explanations follow the new data. The English constraints lose a stale
-- "guild tree" left from an earlier theme. Slug, Test Cases, Starter Code and Drivers are
-- unchanged.

UPDATE problems SET
    description = $$Given the `root` of a binary tree, return its level-order traversal: a list where the i-th entry contains all node values at depth `i`, read left to right.

An empty tree returns an empty list.

**Example 1:**
```
Input: root = [10,5,15,null,null,12,20]
Output: [[10],[5,15],[12,20]]
```

```diagram-tree
nodes: [10, 5, 15, null, null, 12, 20]
```

**Example 2:**
```
Input: root = [42]
Output: [[42]]
```

**Example 3:**
```
Input: root = [7]
Output: [[7]]
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[0, 2 * 10^3]`.
- `-1000 <= Node.val <= 1000`$$
WHERE slug = $$binary-tree-level-order$$;

UPDATE problem_translations SET
    description = $$이진 트리의 `root`가 주어졌을 때, 레벨 순서 순회를 반환하세요. 결과의 `i`번째 원소는 깊이 `i`에 있는 노드 값들을 왼쪽에서 오른쪽 순서로 나열한 리스트입니다.

빈 트리는 빈 리스트를 반환합니다.

**예시 1:**
```
입력: root = [10,5,15,null,null,12,20]
출력: [[10],[5,15],[12,20]]
설명: 깊이 0에는 `10`, 깊이 1에는 `5`와 `15`, 깊이 2에는 `12`와 `20`이 왼쪽부터 차례로 놓여 있습니다.
```

```diagram-tree
nodes: [10, 5, 15, null, null, 12, 20]
```

**예시 2:**
```
입력: root = [42]
출력: [[42]]
설명: 노드가 하나뿐이므로 깊이 0에 `42` 한 개만 들어 있는 리스트가 결과입니다.
```

**예시 3:**
```
입력: root = [7]
출력: [[7]]
설명: 마찬가지로 노드가 `7` 하나뿐인 트리의 결과는 깊이 0의 리스트 하나입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$binary-tree-level-order$$);
