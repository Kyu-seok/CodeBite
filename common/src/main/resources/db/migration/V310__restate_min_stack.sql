-- V310: low-score-stack -> min-stack, retitled "Min Stack". The speedrun-score framing
-- added nothing to the task, so both languages now state it plainly and trace Example 1
-- call by call in a table. The constraint on pop/top/getMin now says "not empty", which
-- every case keeps. Class and method names stay: the Test Cases name them. Drivers and
-- Starter Code directories are renamed in the same commit. Examples match the sample
-- test cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$low-score-stack$$, id FROM problems WHERE slug = $$low-score-stack$$;

UPDATE problems SET
    slug = $$min-stack$$,
    title = $$Min Stack$$,
    description = $$Build a stack that can also tell you its smallest value at any moment.

Implement the `LowTrackStack` class:

- `LowTrackStack()` creates an empty stack.
- `void push(int val)` puts `val` on top of the stack.
- `void pop()` removes the top value.
- `int top()` returns the top value.
- `int getMin()` returns the smallest value in the stack.

Every method must run in `O(1)` time.

**Example 1:**
```
Input:
["LowTrackStack","push","push","push","getMin","pop","top","getMin"]
[[],[12],[6],[-2],[],[],[],[]]
Output: [null,null,null,null,-2,null,6,6]
```

| Call | Stack (bottom → top) | Returns |
|---|---|---|
| `LowTrackStack()` | `[]` | `null` |
| `push(12)` | `[12]` | `null` |
| `push(6)` | `[12, 6]` | `null` |
| `push(-2)` | `[12, 6, -2]` | `null` |
| `getMin()` | `[12, 6, -2]` | `-2` |
| `pop()` | `[12, 6]` | `null` |
| `top()` | `[12, 6]` | `6` |
| `getMin()` | `[12, 6]` | `6` |

Once `-2` is popped, `6` is the smallest value again.$$,
    constraints = $$- `-10^8 <= val <= 10^8`
- `pop`, `top`, and `getMin` are only called when the stack is not empty.
- At most `20000` calls in total.$$
WHERE slug = $$low-score-stack$$;

UPDATE problem_translations SET
    title = $$최솟값 스택$$,
    description = $$가장 작은 값을 언제든 바로 알려 주는 스택을 만드세요.

`LowTrackStack` 클래스를 구현하세요.

- `LowTrackStack()` — 빈 스택을 만듭니다.
- `void push(int val)` — `val`을 스택 맨 위에 올립니다.
- `void pop()` — 맨 위 값을 제거합니다.
- `int top()` — 맨 위 값을 반환합니다.
- `int getMin()` — 스택에서 가장 작은 값을 반환합니다.

모든 메서드는 `O(1)` 시간에 동작해야 합니다.

**예시 1:**
```
입력:
["LowTrackStack","push","push","push","getMin","pop","top","getMin"]
[[],[12],[6],[-2],[],[],[],[]]
출력: [null,null,null,null,-2,null,6,6]
```

| 호출 | 스택 (아래 → 위) | 반환 |
|---|---|---|
| `LowTrackStack()` | `[]` | `null` |
| `push(12)` | `[12]` | `null` |
| `push(6)` | `[12, 6]` | `null` |
| `push(-2)` | `[12, 6, -2]` | `null` |
| `getMin()` | `[12, 6, -2]` | `-2` |
| `pop()` | `[12, 6]` | `null` |
| `top()` | `[12, 6]` | `6` |
| `getMin()` | `[12, 6]` | `6` |

`-2`를 꺼내면 다시 `6`이 가장 작은 값이 됩니다.$$,
    constraints = $$- `-10^8 <= val <= 10^8`
- `pop`, `top`, `getMin`은 스택이 비어 있지 않을 때만 호출됩니다.
- 전체 호출은 최대 `20000`번입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$min-stack$$);
