-- V296: trapping-rain-water, examples restated (#228, part of #193). Example N
-- now shows sample test case N, in English and Korean, with Example 1's
-- explanation rewritten for its data. Slug, title, constraints, Starter Code,
-- Drivers and Test Cases are unchanged.

UPDATE problems SET
    description = $$An elevation map is given as `height`, where `height[i]` is the height of the `i`-th bar and every bar is one unit wide. After it rains, water collects in the dips between taller bars. Return the total amount of water trapped.

A bar at index `i` traps water up to `min(maxLeft, maxRight) - height[i]`, where `maxLeft` and `maxRight` are the tallest bars to its left and right. If no taller bar exists on one side, that side cannot hold water.

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
```$$
WHERE slug = $$trapping-rain-water$$;

UPDATE problem_translations SET
    description = $$높이 지도가 `height` 배열로 주어집니다. `height[i]`는 `i`번째 막대의 높이이고, 모든 막대의 너비는 1입니다. 비가 내린 뒤 더 높은 막대들 사이의 움푹한 곳에 물이 고이는데, 갇힌 물의 총량을 구하세요.

`i`번째 위치는 `min(maxLeft, maxRight) - height[i]`만큼의 물을 가둡니다. 여기서 `maxLeft`, `maxRight`는 각각 `i`의 왼쪽과 오른쪽에서 가장 높은 막대의 높이입니다. 한쪽에 더 높은 막대가 없으면 그쪽으로 물이 새어나가서 가둘 수 없습니다.

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
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$trapping-rain-water$$);
