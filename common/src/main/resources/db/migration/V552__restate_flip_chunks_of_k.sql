-- V552: flip-chunks-of-k restated, Slug and title unchanged. "A linked list of power-ups" was
-- theme the reader had to translate back, and the statement said "run" where the title says
-- "chunk": it now splits the list into chunks of k nodes. Starter method flipSorterSegments
-- (reverse_k_group in Python) -> flipChunks in all 4 Starter Codes and Drivers. Examples match the
-- sample test cases, which are unchanged, and Example 1 keeps its Diagram.

UPDATE problems SET
    description = $$Given the `head` of a linked list and an integer `k`, reverse the order of the nodes within each chunk of `k` consecutive nodes, counting from the head, and return the new head. A last chunk shorter than `k` stays as it is.

Rewire the `next` pointers only; do not change node values.

**Example 1:**
```
Input: head = [10,20,30,40,50,60,70], k = 3
Output: [30,20,10,60,50,40,70]
Explanation: The chunk (10,20,30) flips to (30,20,10) and the chunk (40,50,60) to (60,50,40); the last chunk, 70, is shorter than 3 and stays.
```

```diagram-linked-list
nodes: [10,20,30,40,50,60,70]
highlight: [0,1,2]
after: [30,20,10,60,50,40,70]
```

**Example 2:**
```
Input: head = [5,15,25,35], k = 4
Output: [35,25,15,5]
Explanation: The whole list is one chunk of 4 nodes, reversed in full.
```

**Example 3:**
```
Input: head = [2,4,6,8,10], k = 1
Output: [2,4,6,8,10]
Explanation: With k = 1 each chunk is a single node, so the list is unchanged.
```$$
WHERE slug = $$flip-chunks-of-k$$;

UPDATE problem_translations SET
    description = $$연결 리스트의 머리 `head`와 정수 `k`가 주어질 때, 머리부터 연속한 노드 `k`개씩 묶어 각 묶음 안의 노드 순서를 뒤집고, 새로운 머리를 반환하세요. 마지막 묶음이 `k`개보다 짧으면 그대로 둡니다.

노드 값은 바꾸지 말고 `next` 포인터만 다시 연결하세요.

**예시 1:**
```
입력: head = [10,20,30,40,50,60,70], k = 3
출력: [30,20,10,60,50,40,70]
설명: 묶음 (10,20,30)은 (30,20,10)으로, 묶음 (40,50,60)은 (60,50,40)으로 뒤집힙니다. 마지막 묶음 70은 3개보다 짧아 그대로 둡니다.
```

```diagram-linked-list
nodes: [10,20,30,40,50,60,70]
highlight: [0,1,2]
after: [30,20,10,60,50,40,70]
```

**예시 2:**
```
입력: head = [5,15,25,35], k = 4
출력: [35,25,15,5]
설명: 리스트 전체가 노드 4개짜리 묶음 하나라서 통째로 뒤집힙니다.
```

**예시 3:**
```
입력: head = [2,4,6,8,10], k = 1
출력: [2,4,6,8,10]
설명: k = 1이면 각 묶음이 노드 한 개라서, 리스트는 변하지 않습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$flip-chunks-of-k$$);
