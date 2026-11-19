-- V511: find-rotated-low-score restated, Slug and title unchanged. "Rotated between 1 and n
-- times" never said what one rotation is: the statement now defines it (the last element moves
-- to the front) and every example names its rotation; Example 3 is the n-rotation case, not "no
-- rotation". Starter method locateTerminus -> findLowestScore in all 4 Starter Codes and
-- Drivers. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given an array `scores` of distinct integers that was sorted in ascending order and then rotated between `1` and `n` times, return its smallest value.

One rotation moves the last element to the front: `[2,5,7,9,12]` rotated once is `[12,2,5,7,9]`. Rotating `n` times gives back the sorted array.

Run in `O(log n)` time.

**Example 1:**
```
Input: scores = [7,9,12,2,5]
Output: 2
Explanation: The sorted array [2,5,7,9,12] rotated 3 times is [7,9,12,2,5]. Its smallest value is 2.
```

**Example 2:**
```
Input: scores = [15,20,24,31,3,8,12]
Output: 3
Explanation: The sorted array [3,8,12,15,20,24,31] rotated 4 times is [15,20,24,31,3,8,12].
```

**Example 3:**
```
Input: scores = [21,33,45,58]
Output: 21
Explanation: Rotated 4 times (n = 4), the array is back in sorted order, so its first value is the smallest.
```$$,
    constraints = $$- `n == scores.length`
- `1 <= n <= 6000`
- `|scores[i]| <= 10^8`
- All values in `scores` are unique.
- `scores` is an ascending array rotated between `1` and `n` times.$$
WHERE slug = $$find-rotated-low-score$$;

UPDATE problem_translations SET
    description = $$서로 다른 정수로 이루어진 배열 `scores`는 오름차순으로 정렬된 뒤 `1`번에서 `n`번 사이의 횟수만큼 회전되었습니다. 이 배열에서 가장 작은 값을 반환하세요.

한 번 회전하면 마지막 원소가 맨 앞으로 옵니다. 예를 들어 `[2,5,7,9,12]`를 한 번 회전하면 `[12,2,5,7,9]`가 됩니다. `n`번 회전하면 정렬된 배열로 돌아옵니다.

`O(log n)` 시간 안에 동작해야 합니다.

**예시 1:**
```
입력: scores = [7,9,12,2,5]
출력: 2
설명: 정렬된 배열 [2,5,7,9,12]를 3번 회전하면 [7,9,12,2,5]가 됩니다. 가장 작은 값은 2입니다.
```

**예시 2:**
```
입력: scores = [15,20,24,31,3,8,12]
출력: 3
설명: 정렬된 배열 [3,8,12,15,20,24,31]을 4번 회전하면 [15,20,24,31,3,8,12]가 됩니다.
```

**예시 3:**
```
입력: scores = [21,33,45,58]
출력: 21
설명: 4번(n = 4) 회전하면 정렬된 배열로 돌아오므로 첫 번째 값이 가장 작습니다.
```$$,
    constraints = $$- `n == scores.length`
- `1 <= n <= 6000`
- `|scores[i]| <= 10^8`
- `scores`의 모든 값은 서로 다릅니다.
- `scores`는 오름차순 배열을 `1`번에서 `n`번 사이 회전시킨 결과입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$find-rotated-low-score$$);
