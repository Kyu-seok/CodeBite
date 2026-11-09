-- V288: restate populating-next-pointers (#220, part of #193). The Examples showed
-- LeetCode's data (`[1,2,3,4,5,6,7]` and the empty tree, which the constraints rule out)
-- while the sample Test Cases are CodeBite's own; Example 1 and 2 now show samples 1 and 2
-- in both languages, the Diagram is redrawn to Example 1's tree and each Explanation
-- follows the new data. Only the descriptions change; Slug, title, constraints, Test
-- Cases, Starter Code and Drivers are unchanged.

UPDATE problems SET
    description = $$You are given the `root` of a **perfect** binary tree where every parent has two children and every leaf sits at the same depth. Each node has fields `val`, `left`, `right`, and `next`. Initially every `next` pointer is null.

Set every `next` pointer to point to the node immediately to its right on the same level. If no such node exists (the rightmost on its level), leave `next` as null. Return the modified `root`.

**Example 1:**
```
Input: root = [10,20,30,40,50,60,70]
Output: [10,#,20,30,#,40,50,60,70,#]
Explanation: The "#" markers separate levels in the level-order serialization with next pointers attached. 10 has no right neighbor; 20 → 30, 40 → 50 → 60 → 70.
```

```diagram-tree
nodes: [10, 20, 30, 40, 50, 60, 70]
```

**Example 2:**
```
Input: root = [9]
Output: [9,#]
Explanation: The single node is alone on its level, so its `next` stays null.
```$$
WHERE slug = $$populating-next-pointers$$;

UPDATE problem_translations SET
    description = $$**완전한** 이진 트리(perfect binary tree)의 `root`가 주어집니다. 모든 부모는 두 자식을 가지며, 모든 잎은 같은 깊이에 있습니다. 각 노드는 `val`, `left`, `right`, `next` 필드를 갖고, 처음에는 모든 `next`가 null입니다.

각 노드의 `next`가 같은 레벨에서 바로 오른쪽에 있는 노드를 가리키도록 설정하세요. 같은 레벨에 오른쪽 노드가 없으면(레벨의 가장 오른쪽 노드면) `next`는 null로 남깁니다. 변경된 `root`를 반환합니다.

**예시 1:**
```
입력: root = [10,20,30,40,50,60,70]
출력: [10,#,20,30,#,40,50,60,70,#]
설명: "#" 표시는 next 포인터가 붙은 레벨 순서 직렬화에서 각 레벨의 끝을 구분합니다. 10은 오른쪽 이웃이 없고, 20 → 30, 40 → 50 → 60 → 70으로 next가 이어집니다.
```

```diagram-tree
nodes: [10, 20, 30, 40, 50, 60, 70]
```

**예시 2:**
```
입력: root = [9]
출력: [9,#]
설명: 노드가 하나뿐이면 같은 레벨에 오른쪽 노드가 없으므로 `next`는 null로 남습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$populating-next-pointers$$);
