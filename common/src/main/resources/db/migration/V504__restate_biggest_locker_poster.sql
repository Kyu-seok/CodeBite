-- V504: biggest-locker-poster restated, title unchanged. The stated bound
-- lockers[i] <= 8 * 10^4 let the answer reach 8 * 10^4 * (2 * 10^5 - 1), past the int the
-- Starter Code returns; the largest height in any case is 10000, so the bound is now 10^4
-- (largest area under 2 * 10^9). The task now comes first and Example 2 is explained.
-- Starter method frameLargestBale -> largestPosterArea in all 4 Starter Codes and Drivers.
-- Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Lockers stand in a row, and locker `i` is `lockers[i]` tall. Return the largest area of a rectangular poster you can tape between two of them.

The poster's height is the shorter of the two lockers, and its width is the distance between their indices.

**Example 1:**
```
Input: lockers = [2,6,4,1,5,3,6,2,8]
Output: 42
Explanation: Lockers at index 1 (height 6) and index 8 (height 8) frame a poster of width 7 and height 6, giving 42.
```

**Example 2:**
```
Input: lockers = [2,3]
Output: 2
Explanation: The only two lockers are 1 apart, and the shorter is 2 tall, so the area is 1 × 2 = 2.
```$$,
    constraints = $$- `n == lockers.length`
- `2 <= n <= 2 * 10^5`
- `0 <= lockers[i] <= 10^4`$$
WHERE slug = $$biggest-locker-poster$$;

UPDATE problem_translations SET
    description = $$사물함이 한 줄로 서 있고, `i`번 사물함의 높이는 `lockers[i]`입니다. 두 사물함 사이에 붙일 수 있는 직사각형 포스터의 최대 넓이를 반환하세요.

포스터의 높이는 두 사물함 중 더 낮은 쪽의 높이이고, 너비는 두 사물함의 인덱스 차이입니다.

**예시 1:**
```
입력: lockers = [2,6,4,1,5,3,6,2,8]
출력: 42
설명: 인덱스 1번 사물함(높이 6)과 인덱스 8번 사물함(높이 8) 사이에는 너비 7, 높이 6의 포스터를 붙일 수 있어 넓이가 42입니다.
```

**예시 2:**
```
입력: lockers = [2,3]
출력: 2
설명: 두 사물함 사이의 너비는 1이고 높이는 더 낮은 쪽인 2이므로 넓이는 1 × 2 = 2입니다.
```$$,
    constraints = $$- `n == lockers.length`
- `2 <= n <= 2 * 10^5`
- `0 <= lockers[i] <= 10^4`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$biggest-locker-poster$$);
