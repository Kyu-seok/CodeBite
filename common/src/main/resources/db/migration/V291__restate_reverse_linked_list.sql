-- V291: restate reverse-linked-list (#223, part of #193). The Examples showed LeetCode's
-- original lists ([1,2,3,4,5], [1,2], []) while the sample Test Cases are CodeBite's own;
-- Example N now shows sample N's input and expected output in both languages, the Diagram
-- under Example 1 is redrawn to the new data, and the Korean explanations follow it. Only
-- the descriptions change; Slug, titles, constraints, Test Cases, Starter Code and Drivers
-- are unchanged.

UPDATE problems SET
    description = $$Given the `head` of a singly linked list, reverse the list and return its new head. The reversal must rewire the existing nodes in place — do not allocate a fresh list.

**Example 1:**
```
Input: head = [8,3,12,5,9]
Output: [9,5,12,3,8]
```

```diagram-linked-list
nodes: [8,3,12,5,9]
after: [9,5,12,3,8]
```

**Example 2:**
```
Input: head = [4,7]
Output: [7,4]
```

**Example 3:**
```
Input: head = [1]
Output: [1]
```$$
WHERE slug = $$reverse-linked-list$$;

UPDATE problem_translations SET
    description = $$단일 연결 리스트의 헤드 `head`가 주어졌을 때, 리스트를 뒤집은 뒤 새 헤드를 반환하세요. 새 리스트를 새로 만들지 말고, 기존 노드들을 **제자리에서** 다시 연결해야 합니다.

**예시 1:**
```
입력: head = [8,3,12,5,9]
출력: [9,5,12,3,8]
설명: 노드 `8`에서 `9`까지 이어지던 리스트가 뒤집혀 `9`에서 `8` 방향으로 연결됩니다.
```

```diagram-linked-list
nodes: [8,3,12,5,9]
after: [9,5,12,3,8]
```

**예시 2:**
```
입력: head = [4,7]
출력: [7,4]
설명: 두 노드짜리 리스트의 순서가 뒤바뀌어 `7`이 새 헤드가 됩니다.
```

**예시 3:**
```
입력: head = [1]
출력: [1]
설명: 노드가 하나뿐인 리스트는 뒤집어도 그대로입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$reverse-linked-list$$);
