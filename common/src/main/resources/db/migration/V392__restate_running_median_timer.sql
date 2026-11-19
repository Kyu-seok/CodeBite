-- V392: running-median-timer, text restated. The task comes first; the speedrun timer now
-- logs each attempt against a target time, so negative values make sense. The num bound was
-- false (a hidden case records 100000): now 10^5. Call-by-call tables explain the
-- examples. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Build a structure that takes integers one at a time and can report the median of every integer recorded so far.

Picture a speedrun timer: after each attempt it records how many seconds the run took compared with your target time (negative when you beat it), and you can ask at any moment for the median of all attempts so far.

Implement the `StreamMedian` class:

- `StreamMedian()` starts with nothing recorded.
- `void record(int num)` records `num`.
- `double median()` returns the median of every number recorded so far: the middle value when the count is odd, or the average of the two middle values when it is even. It is only called after at least one `record`.

**Example 1:**
```
Input:
["StreamMedian","record","median","record","median","record","median"]
[[],[1],[],[2],[],[3],[]]
Output: [null,null,1.0,null,1.5,null,2.0]
```

| Call | Recorded (sorted) | Returns |
|---|---|---|
| `StreamMedian()` | `[]` | `null` |
| `record(1)` | `[1]` | `null` |
| `median()` | `[1]` | `1.0` |
| `record(2)` | `[1, 2]` | `null` |
| `median()` | `[1, 2]` | `1.5`, the average of `1` and `2` |
| `record(3)` | `[1, 2, 3]` | `null` |
| `median()` | `[1, 2, 3]` | `2.0`, the middle value |

**Example 2:**
```
Input:
["StreamMedian","record","record","record","record","median"]
[[],[4],[2],[5],[3],[]]
Output: [null,null,null,null,null,3.5]
```

| Call | Recorded (sorted) | Returns |
|---|---|---|
| `StreamMedian()` | `[]` | `null` |
| `record(4)` | `[4]` | `null` |
| `record(2)` | `[2, 4]` | `null` |
| `record(5)` | `[2, 4, 5]` | `null` |
| `record(3)` | `[2, 3, 4, 5]` | `null` |
| `median()` | `[2, 3, 4, 5]` | `3.5`, the average of `3` and `4` |$$,
    constraints = $$- `-10^5 <= num <= 10^5`
- At most `40000` calls to `record` and `median` in total.
- `median` is never called before the first `record`.$$
WHERE slug = $$running-median-timer$$;

UPDATE problem_translations SET
    description = $$정수를 하나씩 받으면서, 지금까지 기록된 모든 정수의 중앙값을 언제든 알려 주는 구조를 만드세요.

스피드런 타이머를 떠올려 보세요. 시도할 때마다 목표 시간보다 몇 초 더 걸렸는지 기록하고(목표보다 빠르면 음수), 언제든 지금까지 모든 시도의 중앙값을 물어볼 수 있습니다.

`StreamMedian` 클래스를 구현하세요.

- `StreamMedian()` — 아무것도 기록되지 않은 상태에서 시작합니다.
- `void record(int num)` — `num`을 기록합니다.
- `double median()` — 지금까지 기록된 모든 수의 중앙값을 반환합니다. 개수가 홀수면 가운데 값, 짝수면 가운데 두 값의 평균입니다. `record`가 최소 한 번 호출된 뒤에만 불립니다.

**예시 1:**
```
입력:
["StreamMedian","record","median","record","median","record","median"]
[[],[1],[],[2],[],[3],[]]
출력: [null,null,1.0,null,1.5,null,2.0]
```

| 호출 | 기록된 값 (정렬) | 반환값 |
|---|---|---|
| `StreamMedian()` | `[]` | `null` |
| `record(1)` | `[1]` | `null` |
| `median()` | `[1]` | `1.0` |
| `record(2)` | `[1, 2]` | `null` |
| `median()` | `[1, 2]` | `1.5`, `1`과 `2`의 평균 |
| `record(3)` | `[1, 2, 3]` | `null` |
| `median()` | `[1, 2, 3]` | `2.0`, 가운데 값 |

**예시 2:**
```
입력:
["StreamMedian","record","record","record","record","median"]
[[],[4],[2],[5],[3],[]]
출력: [null,null,null,null,null,3.5]
```

| 호출 | 기록된 값 (정렬) | 반환값 |
|---|---|---|
| `StreamMedian()` | `[]` | `null` |
| `record(4)` | `[4]` | `null` |
| `record(2)` | `[2, 4]` | `null` |
| `record(5)` | `[2, 4, 5]` | `null` |
| `record(3)` | `[2, 3, 4, 5]` | `null` |
| `median()` | `[2, 3, 4, 5]` | `3.5`, `3`과 `4`의 평균 |$$,
    constraints = $$- `-10^5 <= num <= 10^5`
- 최대 `40000`번까지 `record`와 `median`이 합쳐서 호출됩니다.
- `median`은 첫 번째 `record` 이전에는 호출되지 않습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$running-median-timer$$);
