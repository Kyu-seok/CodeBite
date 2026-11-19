-- V461: trapping-rain-water restated, title unchanged. The constraint 1 <= n was false: hidden
-- case 3 is [] (expected 0), so n may be 0 and an empty map traps 0. height[i] <= 10^8 let the
-- answer pass the int return type (2 * 10^5 bars of 10^8); the bound is now 10^4, which every
-- case meets. maxLeft and maxRight now include the bar itself, so the formula never goes
-- negative, and Example 2 says where its 8 units sit. Names unchanged. Examples match the
-- sample test cases, which are unchanged.

UPDATE problems SET
    description = $$An elevation map is given as `height`, where `height[i]` is the height of the `i`-th bar and every bar is one unit wide. After it rains, water collects in the dips between taller bars. Return the total amount of water trapped.

The water above bar `i` is `min(maxLeft, maxRight) - height[i]`, where `maxLeft` is the tallest bar at or to the left of `i` and `maxRight` the tallest bar at or to the right of `i`. So a bar with no taller bar on one side holds no water. An empty map traps `0`.

**Example 1:**
```
Input: height = [0,2,0,3,1,0,2,4,1,2,0,1]
Output: 10
Explanation: 2 units sit between the bars of heights 2 and 3, 6 between 3 and 4, 1 between 4 and 2, and 1 between 2 and 1, for 10 in total.
```

**Example 2:**
```
Input: height = [3,1,0,2,1,4]
Output: 8
Explanation: The four bars between the walls of heights 3 and 4 fill up to height 3, holding 2 + 3 + 1 + 2 = 8 units.
```$$,
    constraints = $$- `n == height.length`
- `0 <= n <= 2 * 10^5`
- `0 <= height[i] <= 10^4`$$
WHERE slug = $$trapping-rain-water$$;

UPDATE problem_translations SET
    description = $$높이 지도가 `height` 배열로 주어집니다. `height[i]`는 `i`번째 막대의 높이이고, 모든 막대의 너비는 1입니다. 비가 내린 뒤 더 높은 막대들 사이의 움푹한 곳에 물이 고이는데, 갇힌 물의 총량을 구하세요.

`i`번째 막대 위에 고이는 물은 `min(maxLeft, maxRight) - height[i]`입니다. 여기서 `maxLeft`는 `i`와 그 왼쪽에서 가장 높은 막대의 높이, `maxRight`는 `i`와 그 오른쪽에서 가장 높은 막대의 높이입니다. 따라서 한쪽에 더 높은 막대가 없는 막대 위에는 물이 고이지 않습니다. 빈 지도는 `0`을 가둡니다.

**예시 1:**
```
입력: height = [0,2,0,3,1,0,2,4,1,2,0,1]
출력: 10
설명: 높이 2와 3인 막대 사이에 2칸, 3과 4 사이에 6칸, 4와 2 사이에 1칸, 2와 1 사이에 1칸, 모두 10칸의 물이 고입니다.
```

**예시 2:**
```
입력: height = [3,1,0,2,1,4]
출력: 8
설명: 높이 3과 4인 양쪽 벽 사이의 막대 네 개 위로 물이 높이 3까지 차서, 2 + 3 + 1 + 2 = 8칸이 고입니다.
```$$,
    constraints = $$- `n == height.length`
- `0 <= n <= 2 * 10^5`
- `0 <= height[i] <= 10^4`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$trapping-rain-water$$);
