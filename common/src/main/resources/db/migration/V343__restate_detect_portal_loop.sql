-- V343: detect-portal-loop restated. Both languages said to implement
-- detectTransferLoop(head, pos), while the Starter Code takes only `head`, then
-- explained `pos` as an argument the function doesn't use. The function is now
-- described as taking `head` alone, and `pos` only as how an example's input builds
-- the loop. The constraint names `ListNode.val`, the Starter Code's class, instead of
-- `Room.val`. Starter method detectTransferLoop -> hasPortalLoop. Examples match the
-- sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Return `true` if the dungeon's chain of rooms starting at `head` loops back on itself, and `false` if it ends.

The rooms form a linked list: each room's `next` pointer teleports you to the next room, and the last room's `next` is either `null` (the chain ends) or an earlier room (the chain loops forever). Your function receives only `head`.

The examples write a chain as `head`, the rooms' values in order, and `pos`, the index (from `0`) of the room the last room teleports back to, or `-1` when the chain ends. `pos` only builds the input; it is not passed to your function.

**Example 1:**
```
Input: head = [8,5,2,6,9], pos = 2
Output: true
Explanation: The last room (9) teleports back to the room at index 2 (value 2), so following `next` goes around 2, 6, 9 forever.
```

```diagram-linked-list
nodes: [8,5,2,6,9]
cycle_to: 2
```

**Example 2:**
```
Input: head = [4,7,3], pos = 0
Output: true
Explanation: The last room teleports back to the first, so the whole chain is one loop.
```

**Example 3:**
```
Input: head = [6,2], pos = -1
Output: false
Explanation: The last room's `next` is `null`, so the chain ends and there is no loop.
```$$,
    constraints = $$- The number of rooms is in the range `[0, 2 * 10^3]`.
- `-8 * 10^4 <= ListNode.val <= 8 * 10^4`
- `pos` is `-1` or a valid index into the chain.$$
WHERE slug = $$detect-portal-loop$$;

UPDATE problem_translations SET
    description = $$`head`에서 시작하는 던전 방들의 체인이 자기 자신으로 되돌아가는 루프를 이루면 `true`를, 끝이 있으면 `false`를 반환하세요.

방들은 연결 리스트를 이룹니다. 각 방의 `next` 포인터는 다음 방으로 순간이동시키며, 마지막 방의 `next`는 `null`(체인이 끝남)이거나 앞쪽의 어떤 방(체인이 영원히 돎)입니다. 함수에는 `head`만 주어집니다.

예시에서는 체인을 `head`와 `pos`로 적습니다. `head`는 방들의 값을 순서대로 적은 것이고, `pos`는 마지막 방이 되돌아가는 방의 인덱스(`0`부터 시작)이며 체인이 끝나면 `-1`입니다. `pos`는 입력을 만드는 데만 쓰이고 함수에는 전달되지 않습니다.

**예시 1:**
```
입력: head = [8,5,2,6,9], pos = 2
출력: true
설명: 마지막 방(9)이 인덱스 2의 방(값 2)으로 되돌아가므로, `next`를 따라가면 2, 6, 9를 영원히 돕니다.
```

```diagram-linked-list
nodes: [8,5,2,6,9]
cycle_to: 2
```

**예시 2:**
```
입력: head = [4,7,3], pos = 0
출력: true
설명: 마지막 방이 첫 번째 방으로 되돌아가므로 체인 전체가 하나의 루프입니다.
```

**예시 3:**
```
입력: head = [6,2], pos = -1
출력: false
설명: 마지막 방의 `next`가 `null`이므로 체인이 끝나고 루프가 없습니다.
```$$,
    constraints = $$- 방의 개수는 `[0, 2 * 10^3]` 범위 안에 있습니다.
- `-8 * 10^4 <= ListNode.val <= 8 * 10^4`
- `pos`는 `-1`이거나 체인 안의 유효한 인덱스입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$detect-portal-loop$$);
