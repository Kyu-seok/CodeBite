-- V360: interleave-clip-chain keeps its Slug and English title. The target order used an
-- undefined S and n, and the value constraint named a class (Shot) that doesn't exist: the
-- nodes are now L0..L(n-1), the order is written out, and the constraint reads Node.val.
-- The Korean title (trailer cuts) now matches the clip chain. Starter method
-- interleaveTrailerCuts (reorder_list in Python) -> interleaveClips in all 4 Languages.
-- Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given the `head` of a linked list of game clips `L0 -> L1 -> … -> L(n-1)`, reorder it in place so the earliest and latest clips alternate:

`L0 -> L(n-1) -> L1 -> L(n-2) -> L2 -> L(n-3) -> …`

Rewire only the `next` pointers; don't change any node's value. The method returns nothing: the list starting at `head` is checked after the call. When `n` is odd, the middle clip ends up last.

**Example 1:**
```
Input: head = [10,20,30,40,50,60]
Output: [10,60,20,50,30,40]
Explanation: Take the first, then the last, then the second, then the second to last, and so on.
```

```diagram-linked-list
nodes: [10,20,30,40,50,60]
after: [10,60,20,50,30,40]
```

**Example 2:**
```
Input: head = [1,3,5,7,9,11,13]
Output: [1,13,3,11,5,9,7]
Explanation: With 7 clips, the middle one, 7, ends up last.
```$$,
    constraints = $$- The number of nodes `n` is in the range `[1, 8 * 10^4]`.
- `1 <= Node.val <= 1000`$$
WHERE slug = $$interleave-clip-chain$$;

UPDATE problem_translations SET
    title = $$클립 체인 교차하기$$,
    description = $$게임 클립이 `L0 -> L1 -> … -> L(n-1)` 순서로 이어진 연결 리스트의 `head`가 주어질 때, 앞쪽 클립과 뒤쪽 클립이 번갈아 오도록 리스트를 제자리에서 재배치하세요.

`L0 -> L(n-1) -> L1 -> L(n-2) -> L2 -> L(n-3) -> …`

`next` 포인터만 다시 연결하고, 노드의 값은 바꾸지 마세요. 메서드는 아무것도 반환하지 않으며, 호출이 끝난 뒤 `head`부터 이어지는 리스트로 채점합니다. `n`이 홀수이면 가운데 클립이 맨 끝에 놓입니다.

**예시 1:**
```
입력: head = [10,20,30,40,50,60]
출력: [10,60,20,50,30,40]
설명: 첫 번째, 마지막, 두 번째, 끝에서 두 번째 순서로 계속 번갈아 가져옵니다.
```

```diagram-linked-list
nodes: [10,20,30,40,50,60]
after: [10,60,20,50,30,40]
```

**예시 2:**
```
입력: head = [1,3,5,7,9,11,13]
출력: [1,13,3,11,5,9,7]
설명: 클립이 7개이면 가운데 클립인 7이 맨 끝에 놓입니다.
```$$,
    constraints = $$- 노드 개수 `n`은 `[1, 8 * 10^4]` 범위 안에 있습니다.
- `1 <= Node.val <= 1000`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$interleave-clip-chain$$);
