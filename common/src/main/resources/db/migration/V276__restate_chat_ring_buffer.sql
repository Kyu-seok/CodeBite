-- V276: restate chat-ring-buffer (#208, part of #193). The one unnumbered Example was a call
-- trace with no Input and Output; it is now Example 1 in the operations form, showing sample 1
-- (the trace, with sample 1's isFull call added, becomes its Explanation), and Example 2 shows
-- sample 2, in English and Korean. Text only: Slug, title, constraints, Test Cases, Starter Code
-- and Drivers are unchanged.

UPDATE problems SET
    description = $$A party chat keeps only the most recent messages in a fixed-size circular buffer. Implement `FixedRing` to manage it.

- `FixedRing(int k)` — creates an empty ring with capacity `k`.
- `boolean push(int value)` — inserts `value` at the rear. Returns `true` on success, `false` if full.
- `boolean pull()` — removes the front message. Returns `true` on success, `false` if empty.
- `int front()` — returns the front message without removing it, or `-1` if empty.
- `int rear()` — returns the rear message without removing it, or `-1` if empty.
- `boolean isEmpty()` — returns `true` when the ring holds no messages.
- `boolean isFull()` — returns `true` when all `k` slots are filled.

**Example 1:**
```
Input
["FixedRing","push","push","push","push","rear","isFull","pull","push","rear"]
[[3],[1],[2],[3],[4],[],[],[],[4],[]]
Output
[null,true,true,true,false,3,true,true,true,4]

Explanation
FixedRing ring = new FixedRing(3);
ring.push(1);  // true
ring.push(2);  // true
ring.push(3);  // true, ring = [1, 2, 3]
ring.push(4);  // false, the ring is full
ring.rear();   // 3
ring.isFull(); // true
ring.pull();   // true, drops 1, ring = [2, 3]
ring.push(4);  // true, wraps around, ring = [2, 3, 4]
ring.rear();   // 4
```

**Example 2:**
```
Input
["FixedRing","push","pull","front","pull"]
[[2],[5],[],[],[]]
Output
[null,true,true,-1,false]

Explanation
FixedRing ring = new FixedRing(2);
ring.push(5);  // true
ring.pull();   // true, the ring is empty again
ring.front();  // -1, nothing to read
ring.pull();   // false, nothing to remove
```$$
WHERE slug = $$chat-ring-buffer$$;

UPDATE problem_translations SET
    description = $$파티 채팅에서는 가장 최근 메시지만을 고정된 크기의 원형 버퍼에 보관합니다. 이를 관리하는 `FixedRing`을 구현하세요.

- `FixedRing(int k)` — 용량 `k`(최대 보관 가능한 메시지 수)인 빈 링을 만듭니다.
- `boolean push(int value)` — 메시지 `value`를 뒤쪽에 추가합니다. 성공하면 `true`, 가득 차 있으면 `false`를 반환합니다.
- `boolean pull()` — 맨 앞 메시지를 제거합니다. 성공하면 `true`, 비어 있으면 `false`를 반환합니다.
- `int front()` — 맨 앞 메시지를 제거하지 않고 반환하며, 비어 있으면 `-1`을 반환합니다.
- `int rear()` — 맨 뒤 메시지를 제거하지 않고 반환하며, 비어 있으면 `-1`을 반환합니다.
- `boolean isEmpty()` — 링에 메시지가 하나도 없으면 `true`를 반환합니다.
- `boolean isFull()` — `k`개의 슬롯이 전부 차 있으면 `true`를 반환합니다.

**예시 1:**
```
입력
["FixedRing","push","push","push","push","rear","isFull","pull","push","rear"]
[[3],[1],[2],[3],[4],[],[],[],[4],[]]
출력
[null,true,true,true,false,3,true,true,true,4]

설명
FixedRing ring = new FixedRing(3);
ring.push(1);  // true
ring.push(2);  // true
ring.push(3);  // true, 링 = [1, 2, 3]
ring.push(4);  // false, 링이 가득 참
ring.rear();   // 3
ring.isFull(); // true
ring.pull();   // true, 1을 제거, 링 = [2, 3]
ring.push(4);  // true, 한 바퀴 돌아 들어감, 링 = [2, 3, 4]
ring.rear();   // 4
```

**예시 2:**
```
입력
["FixedRing","push","pull","front","pull"]
[[2],[5],[],[],[]]
출력
[null,true,true,-1,false]

설명
FixedRing ring = new FixedRing(2);
ring.push(5);  // true
ring.pull();   // true, 링이 다시 비어 있음
ring.front();  // -1, 읽을 메시지가 없음
ring.pull();   // false, 제거할 메시지가 없음
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$chat-ring-buffer$$);
