-- V530: peak-combo-window restated, title unchanged. The task now comes first and the
-- result's length, n - k + 1, is stated. Starter method peakFlowPerStretch ->
-- peakComboPerWindow in all 4 Starter Codes and Drivers. Examples match the sample test
-- cases, which are unchanged.

UPDATE problems SET
    description = $$Given `combo`, where `combo[i]` is the combo count at beat `i` of a rhythm-game replay, return the peak combo of every window of `k` consecutive beats.

The window starts at beat `0` and slides one beat at a time to the end, so the result holds `n - k + 1` values: the `i`-th is the largest of `combo[i]` through `combo[i + k - 1]`.

**Example 1:**
```
Input: combo = [4,2,8,5,1,7,9,3], k = 4
Output: [8,8,8,9,9]
Explanation:
Window                         Peak
[4  2  8  5]  1  7  9  3        8
 4 [2  8  5  1] 7  9  3         8
 4  2 [8  5  1  7] 9  3         8
 4  2  8 [5  1  7  9] 3         9
 4  2  8  5 [1  7  9  3]        9
```

**Example 2:**
```
Input: combo = [6,6,6], k = 2
Output: [6,6]
Explanation: There are 3 - 2 + 1 = 2 windows, [6,6] and [6,6], and each peaks at 6.
```$$,
    constraints = $$- `n == combo.length`
- `1 <= n <= 2 * 10^5`
- `-8000 <= combo[i] <= 8000`
- `1 <= k <= n`$$
WHERE slug = $$peak-combo-window$$;

UPDATE problem_translations SET
    description = $$리듬 게임 리플레이에서 `combo[i]`는 비트 `i`의 콤보 수치입니다. 연속한 `k`개 비트로 이루어진 모든 윈도마다 가장 높은 콤보를 반환하세요.

윈도는 비트 `0`에서 시작해 끝까지 한 비트씩 밀리므로 결과에는 값이 `n - k + 1`개 들어가며, `i`번째 값은 `combo[i]`부터 `combo[i + k - 1]`까지 중 가장 큰 값입니다.

**예시 1:**
```
입력: combo = [4,2,8,5,1,7,9,3], k = 4
출력: [8,8,8,9,9]
설명:
윈도                            최댓값
[4  2  8  5]  1  7  9  3        8
 4 [2  8  5  1] 7  9  3         8
 4  2 [8  5  1  7] 9  3         8
 4  2  8 [5  1  7  9] 3         9
 4  2  8  5 [1  7  9  3]        9
```

**예시 2:**
```
입력: combo = [6,6,6], k = 2
출력: [6,6]
설명: 윈도는 3 - 2 + 1 = 2개로 [6,6]과 [6,6]이며, 둘 다 최댓값이 6입니다.
```$$,
    constraints = $$- `n == combo.length`
- `1 <= n <= 2 * 10^5`
- `-8000 <= combo[i] <= 8000`
- `1 <= k <= n`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$peak-combo-window$$);
