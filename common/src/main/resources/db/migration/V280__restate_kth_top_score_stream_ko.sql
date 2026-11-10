-- V280: restate kth-top-score-stream (#212, part of #193). The Korean Example 1 showed
-- LeetCode's data (k = 3, [4, 5, 8, 2]) instead of the sample Test Case the English Example
-- already shows; it now shows that sample, with the Explanation rewritten for it. Only the
-- Korean description changes; Slug, title, constraints, English text, Test Cases, Starter
-- Code and Drivers are unchanged.

UPDATE problem_translations SET
    description = $$길드가 레이드 점수를 한 번에 하나씩 게시합니다. 새 점수가 들어올 때마다 현재까지의 점수 중 정수 `k`번째로 큰 값을 추적하세요. 같은 값이 여러 번 나와도 각각 자기 자리를 차지하므로, `k`번째로 큰 값은 정렬된 목록에서 위치 `k`에 있는 값을 의미합니다.

`TopKStream` 클래스를 구현하세요.

- `TopKStream(int k, int[] scores)` — 추적기에 순위 `k`와 처음 받은 레이드 점수 배열 `scores`를 넣어 초기화합니다.
- `int record(int val)` — 새 점수 `val`을 스트림에 추가하고, 지금까지의 스트림에서 `k`번째로 큰 점수를 반환합니다.

**예시 1:**
```
입력:
["TopKStream", "record", "record", "record"]
[[2, [100, 50]], [75], [120], [60]]
출력: [null, 75, 100, 100]

설명:
TopKStream tracker = new TopKStream(2, [100, 50]);
tracker.record(75);   // 스트림이 [100,50,75]; 2번째로 큰 값은 75
tracker.record(120);  // 스트림이 [100,50,75,120]; 2번째로 큰 값은 100
tracker.record(60);   // 스트림이 [100,50,75,120,60]; 2번째로 큰 값은 100
```

리더보드는 끊임없이 갱신되므로, 점수가 들어올 때마다 전체를 다시 정렬하는 방식으로는 속도를 따라잡을 수 없습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$kth-top-score-stream$$);
