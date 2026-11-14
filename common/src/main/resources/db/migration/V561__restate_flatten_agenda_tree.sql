-- V561: flatten-agenda-tree restated, Slug and English title unchanged. The first sentence
-- now states the task; Example 3 repeated Example 2 (a single node) and is dropped; "unrolling"
-- and "task" are gone, and the Korean title says agenda (안건) instead of schedule (일정).
-- Starter method unrollSchedule -> flattenAgenda in all 4 Starter Codes and Drivers.
-- Examples match the sample test cases, which are unchanged, and Example 1 keeps its Diagram.

UPDATE problems SET
    description = $$Given the root `root` of a binary tree that holds a meeting agenda, flatten the tree **in place** into a chain in **preorder**: every node's `left` becomes `null`, and its `right` points to the next node in preorder.

The function returns nothing: the grader follows the `right` pointers from `root` and lists the values it visits.

**Example 1:**
```
Input: root = [7,3,9,1,4,null,12]
Output: [7,3,1,4,9,12]
Explanation: Preorder visits 7, 3, 1, 4, 9, 12, so the chain links the nodes in that order through their right pointers.
```

```diagram-tree
nodes: [7, 3, 9, 1, 4, null, 12]
```

**Example 2:**
```
Input: root = [1]
Output: [1]
Explanation: A single node is already a one-node chain.
```$$
WHERE slug = $$flatten-agenda-tree$$;

UPDATE problem_translations SET
    title = $$안건 트리 펼치기$$,
    description = $$회의 안건을 담은 이진 트리의 루트 `root`가 주어질 때, 트리를 **제자리에서** **전위 순회** 순서의 사슬로 펼치세요. 모든 노드의 `left`는 `null`이 되고, `right`는 전위 순회에서 다음 노드를 가리켜야 합니다.

함수는 아무것도 반환하지 않습니다. 채점기는 `root`에서부터 `right` 포인터를 따라가며 방문한 값을 나열합니다.

**예시 1:**
```
입력: root = [7,3,9,1,4,null,12]
출력: [7,3,1,4,9,12]
설명: 전위 순회는 7, 3, 1, 4, 9, 12 순서로 방문하므로, 사슬은 right 포인터로 노드들을 이 순서대로 잇습니다.
```

```diagram-tree
nodes: [7, 3, 9, 1, 4, null, 12]
```

**예시 2:**
```
입력: root = [1]
출력: [1]
설명: 노드가 하나뿐이면 이미 한 노드짜리 사슬입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$flatten-agenda-tree$$);
