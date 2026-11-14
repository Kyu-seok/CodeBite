-- V431: chat-ring-buffer restated, Slug and title unchanged. "keeps only the most recent
-- messages" (Korean: 가장 최근 메시지만을) implied that a push overwrites the oldest message,
-- while every case has push fail on a full ring; and Example 1's "wraps around" described
-- storage, not what a caller sees. Both languages now say: a fixed-capacity queue, push
-- fails when full, pull fails when empty, nothing is overwritten; each Example is traced
-- call by call in a table. Class and method names stay: the Test Cases name them. Examples
-- match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$A party chat holds its messages in a queue of fixed capacity `k`. Implement `FixedRing`, that queue: messages leave in the order they arrived, `push` fails when the queue is full, and `pull` fails when it is empty. A message is never overwritten.

- `FixedRing(int k)` creates an empty queue that holds at most `k` messages.
- `boolean push(int value)` adds message `value` at the rear and returns `true`, or returns `false` and changes nothing if the queue is full.
- `boolean pull()` removes the front message and returns `true`, or returns `false` if the queue is empty.
- `int front()` returns the front message without removing it, or `-1` if the queue is empty.
- `int rear()` returns the rear message without removing it, or `-1` if the queue is empty.
- `boolean isEmpty()` returns `true` when the queue holds no messages.
- `boolean isFull()` returns `true` when the queue holds `k` messages.

**Example 1:**
```
Input:
["FixedRing","push","push","push","push","rear","isFull","pull","push","rear"]
[[3],[1],[2],[3],[4],[],[],[],[4],[]]
Output: [null,true,true,true,false,3,true,true,true,4]
```

| Call | Queue (front → rear) | Returns |
|---|---|---|
| `FixedRing(3)` | `[]` | `null` |
| `push(1)` | `[1]` | `true` |
| `push(2)` | `[1, 2]` | `true` |
| `push(3)` | `[1, 2, 3]` | `true` |
| `push(4)` | `[1, 2, 3]` | `false` (full) |
| `rear()` | `[1, 2, 3]` | `3` |
| `isFull()` | `[1, 2, 3]` | `true` |
| `pull()` | `[2, 3]` | `true` |
| `push(4)` | `[2, 3, 4]` | `true` |
| `rear()` | `[2, 3, 4]` | `4` |

**Example 2:**
```
Input:
["FixedRing","push","pull","front","pull"]
[[2],[5],[],[],[]]
Output: [null,true,true,-1,false]
```

| Call | Queue (front → rear) | Returns |
|---|---|---|
| `FixedRing(2)` | `[]` | `null` |
| `push(5)` | `[5]` | `true` |
| `pull()` | `[]` | `true` |
| `front()` | `[]` | `-1` (empty) |
| `pull()` | `[]` | `false` (empty) |$$
WHERE slug = $$chat-ring-buffer$$;

UPDATE problem_translations SET
    description = $$파티 채팅은 메시지를 용량이 `k`로 고정된 큐에 보관합니다. 이 큐인 `FixedRing`을 구현하세요. 메시지는 들어온 순서대로 나가고, 큐가 가득 차 있으면 `push`가, 비어 있으면 `pull`이 실패합니다. 메시지를 덮어쓰는 일은 없습니다.

- `FixedRing(int k)` — 메시지를 최대 `k`개까지 담는 빈 큐를 만듭니다.
- `boolean push(int value)` — 메시지 `value`를 맨 뒤에 넣고 `true`를 반환합니다. 큐가 가득 차 있으면 아무것도 바꾸지 않고 `false`를 반환합니다.
- `boolean pull()` — 맨 앞 메시지를 꺼내고 `true`를 반환합니다. 큐가 비어 있으면 `false`를 반환합니다.
- `int front()` — 맨 앞 메시지를 꺼내지 않고 반환합니다. 큐가 비어 있으면 `-1`을 반환합니다.
- `int rear()` — 맨 뒤 메시지를 꺼내지 않고 반환합니다. 큐가 비어 있으면 `-1`을 반환합니다.
- `boolean isEmpty()` — 큐에 메시지가 하나도 없으면 `true`를 반환합니다.
- `boolean isFull()` — 큐에 메시지가 `k`개 있으면 `true`를 반환합니다.

**예시 1:**
```
입력:
["FixedRing","push","push","push","push","rear","isFull","pull","push","rear"]
[[3],[1],[2],[3],[4],[],[],[],[4],[]]
출력: [null,true,true,true,false,3,true,true,true,4]
```

| 호출 | 큐 (앞 → 뒤) | 반환 |
|---|---|---|
| `FixedRing(3)` | `[]` | `null` |
| `push(1)` | `[1]` | `true` |
| `push(2)` | `[1, 2]` | `true` |
| `push(3)` | `[1, 2, 3]` | `true` |
| `push(4)` | `[1, 2, 3]` | `false` (가득 참) |
| `rear()` | `[1, 2, 3]` | `3` |
| `isFull()` | `[1, 2, 3]` | `true` |
| `pull()` | `[2, 3]` | `true` |
| `push(4)` | `[2, 3, 4]` | `true` |
| `rear()` | `[2, 3, 4]` | `4` |

**예시 2:**
```
입력:
["FixedRing","push","pull","front","pull"]
[[2],[5],[],[],[]]
출력: [null,true,true,-1,false]
```

| 호출 | 큐 (앞 → 뒤) | 반환 |
|---|---|---|
| `FixedRing(2)` | `[]` | `null` |
| `push(5)` | `[5]` | `true` |
| `pull()` | `[]` | `true` |
| `front()` | `[]` | `-1` (비어 있음) |
| `pull()` | `[]` | `false` (비어 있음) |$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$chat-ring-buffer$$);
