-- V475: binary-tree-codec restated. "Node values may be any 32-bit integer" contradicted
-- the constraint -1000 <= Node.val <= 1000, which every case keeps: the sentence is gone.
-- The examples' level-order notation is now explained, and the English Example 2 gets the
-- explanation the Korean already had. Class and method names stay. Examples match the
-- sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Design a `Codec` class that turns a binary tree into a string and back:

- `String serialize(TreeNode root)` — convert a binary tree to a string.
- `TreeNode deserialize(String data)` — reconstruct a tree from such a string.

The serialization format is up to you. The judge calls `deserialize(serialize(root))` on each input tree and checks that the resulting tree is identical to the original, in shape and in every value. The tree may be empty (`root = null`).

The examples show trees in level order, with `null` for a missing child.

**Example 1:**
```
Input: root = [1,2,3,null,null,4,5]
Output: [1,2,3,null,null,4,5]
Explanation: The exact serialized string can differ; only the round-trip tree must match.
```

```diagram-tree
nodes: [1, 2, 3, null, null, 4, 5]
```

**Example 2:**
```
Input: root = []
Output: []
Explanation: An empty tree must come back as an empty tree.
```$$
WHERE slug = $$binary-tree-codec$$;

UPDATE problem_translations SET
    description = $$이진 트리를 문자열로 바꾸고 다시 트리로 되돌리는 `Codec` 클래스를 설계하세요.

- `String serialize(TreeNode root)` — 이진 트리를 문자열로 변환합니다.
- `TreeNode deserialize(String data)` — 그런 문자열에서 트리를 복원합니다.

직렬화 형식은 자유롭게 정해도 됩니다. 채점기는 각 입력 트리에 대해 `deserialize(serialize(root))`를 호출하고, 복원된 트리가 모양과 모든 값까지 원본과 같은지 확인합니다. 트리는 비어 있을 수도 있습니다(`root = null`).

예시의 트리는 레벨 순서로 적고, 없는 자식은 `null`로 표시합니다.

**예시 1:**
```
입력: root = [1,2,3,null,null,4,5]
출력: [1,2,3,null,null,4,5]
설명: 직렬화된 문자열의 형식은 자유롭게 달라질 수 있고, 왕복 후 복원된 트리만 원본과 일치하면 됩니다.
```

```diagram-tree
nodes: [1, 2, 3, null, null, 4, 5]
```

**예시 2:**
```
입력: root = []
출력: []
설명: 빈 트리는 그대로 빈 트리로 복원되어야 합니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$binary-tree-codec$$);
