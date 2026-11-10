-- V292: restate running-median-timer (#224, part of #193). The one Example was a call trace
-- with no Input and Output; Examples 1 and 2 now show sample test cases 1 and 2 in the
-- operations form, the trace moving under Example 1's Explanation, in both languages. Only the
-- descriptions change; Slug, title, constraints, Test Cases, Starter Code and Drivers are
-- unchanged.

UPDATE problems SET
    description = $$Your speedrun timer logs the seconds of each attempt, and you want the median run time on demand as new attempts stream in. Build `StreamMedian` to track runs and report the median so far. For an even count, the median is the average of the two middle values; otherwise it's the single middle value. Both are returned as doubles.

Implement the `StreamMedian` class:

- `StreamMedian()` starts with no runs logged.
- `void record(int num)` logs a new run time `num`.
- `double median()` returns the median of all runs logged so far. Only called after at least one `record`.

**Example 1:**
```
Input
["StreamMedian","record","median","record","median","record","median"]
[[],[1],[],[2],[],[3],[]]
Output
[null,null,1.0,null,1.5,null,2.0]

Explanation
StreamMedian collector = new StreamMedian();
collector.record(1);
collector.median();    // 1.0
collector.record(2);
collector.median();    // (1 + 2) / 2 = 1.5
collector.record(3);
collector.median();    // middle of [1, 2, 3] = 2.0
```

**Example 2:**
```
Input
["StreamMedian","record","record","record","record","median"]
[[],[4],[2],[5],[3],[]]
Output
[null,null,null,null,null,3.5]

Explanation
After recording 4, 2, 5 and 3 the runs sorted are [2, 3, 4, 5], so the median is (3 + 4) / 2 = 3.5.
```$$
WHERE slug = $$running-median-timer$$;

UPDATE problem_translations SET
    description = $$스피드런 타이머는 시도할 때마다 완주한 초를 기록합니다. 새로운 시도가 실시간으로 쌓이는 상황에서도, 원할 때마다 지금까지의 완주 시간 중앙값을 바로 얻고 싶습니다. 기록을 추적하면서 누적 중앙값을 알려주는 `StreamMedian`을 만드세요. 기록 개수가 짝수면 중앙값은 가운데 두 값의 평균이고, 홀수면 가운데 한 값입니다. 두 경우 모두 `double`로 반환합니다.

`StreamMedian` 클래스를 구현하세요.

- `StreamMedian()` — 기록이 하나도 없는 상태에서 시작합니다.
- `void record(int num)` — 새 시도의 완주 시간 `num`을 기록합니다.
- `double median()` — 지금까지 기록된 모든 시도의 중앙값을 반환합니다. `record`가 최소 한 번 호출된 뒤에만 불립니다.

**예시 1:**
```
입력
["StreamMedian","record","median","record","median","record","median"]
[[],[1],[],[2],[],[3],[]]
출력
[null,null,1.0,null,1.5,null,2.0]

설명
StreamMedian collector = new StreamMedian();
collector.record(1);
collector.median();    // 1.0
collector.record(2);
collector.median();    // (1 + 2) / 2 = 1.5
collector.record(3);
collector.median();    // [1, 2, 3]의 가운데 값 = 2.0
```

**예시 2:**
```
입력
["StreamMedian","record","record","record","record","median"]
[[],[4],[2],[5],[3],[]]
출력
[null,null,null,null,null,3.5]

설명
4, 2, 5, 3을 기록하면 정렬된 기록은 [2, 3, 4, 5]이므로 중앙값은 (3 + 4) / 2 = 3.5입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$running-median-timer$$);
