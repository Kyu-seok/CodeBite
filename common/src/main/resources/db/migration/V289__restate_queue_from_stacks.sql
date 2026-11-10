-- V289: restate queue-from-stacks (#221, part of #193). The unnumbered Example was a call
-- trace with no Input and Output; the description now shows samples 1 and 2 as Example 1
-- and Example 2 in the operations form, with the old trace as Example 1's Explanation, in
-- both languages. Only the descriptions change; Slug, title, constraints, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problems SET
    description = $$At your cafe's drink pickup counter, customers must be served in order, but your only trays are pushdown stacks where you can only touch the top cup. Build `QueueFromStacks` to behave as a FIFO queue using exactly two such stacks and nothing else (no arrays, lists, or deques). You may only push, pop, peek, or check emptiness on the two internal stacks.

- `QueueFromStacks()` starts an empty queue.
- `void push(int x)` adds order `x` to the back.
- `int pop()` removes and returns the front order.
- `int peek()` returns the front order without removing it.
- `boolean empty()` returns `true` if the queue is empty.

The caller will never call `pop` or `peek` on an empty queue.

**Example 1:**
```
Input
["QueueFromStacks","push","push","peek","pop","empty"]
[[],[1],[2],[],[],[]]
Output
[null,null,null,1,1,false]

Explanation
QueueFromStacks q = new QueueFromStacks();
q.push(1);  // queue = [1]
q.push(2);  // queue = [1, 2]
q.peek();   // returns 1, the front of the line
q.pop();    // returns 1, the front is served; queue = [2]
q.empty();  // returns false, 2 is still waiting
```

**Example 2:**
```
Input
["QueueFromStacks","push","push","push","pop","pop","peek","empty"]
[[],[10],[20],[30],[],[],[],[]]
Output
[null,null,null,null,10,20,30,false]
```$$
WHERE slug = $$queue-from-stacks$$;

UPDATE problem_translations SET
    description = $$카페 음료 픽업 카운터에서는 손님을 도착 순서대로 응대해야 하는데, 사용 가능한 트레이는 가장 위쪽 컵만 만질 수 있는 푸시다운 스택뿐입니다. 정확히 두 개의 그런 스택만 사용해 FIFO 큐처럼 동작하는 `QueueFromStacks`를 만드세요. 배열, 리스트, 데크 같은 다른 자료구조는 일절 쓸 수 없으며, 두 내부 스택에 대해서는 push, pop, peek, 비어 있는지 확인 외의 연산을 허용하지 않습니다.

- `QueueFromStacks()` — 빈 큐를 시작합니다.
- `void push(int x)` — 주문 `x`를 뒤쪽에 추가합니다.
- `int pop()` — 맨 앞 주문을 꺼내 반환합니다.
- `int peek()` — 맨 앞 주문을 꺼내지 않고 반환합니다.
- `boolean empty()` — 큐가 비어 있으면 `true`를 반환합니다.

호출자는 비어 있는 큐에 `pop`이나 `peek`을 부르지 않습니다.

**예시 1:**
```
입력
["QueueFromStacks","push","push","peek","pop","empty"]
[[],[1],[2],[],[],[]]
출력
[null,null,null,1,1,false]

설명
QueueFromStacks q = new QueueFromStacks();
q.push(1);  // 큐 = [1]
q.push(2);  // 큐 = [1, 2]
q.peek();   // 1 반환, 줄 맨 앞
q.pop();    // 1 반환, 맨 앞 손님 응대 완료; 큐 = [2]
q.empty();  // false 반환, 2번 주문이 아직 대기 중
```

**예시 2:**
```
입력
["QueueFromStacks","push","push","push","pop","pop","peek","empty"]
[[],[10],[20],[30],[],[],[],[]]
출력
[null,null,null,null,10,20,30,false]
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$queue-from-stacks$$);
