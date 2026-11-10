-- V281: restate largest-rectangle-histogram (#213, part of #193). The examples showed
-- LeetCode's data ([2,1,5,6,2,3] -> 10, [2,4] -> 4) instead of the sample Test Cases;
-- they now show samples 1 and 2 in both languages, with explanations for the new data.
-- Only the descriptions change; Slug, title, constraints, Test Cases, Starter Code and
-- Drivers are unchanged.

UPDATE problems SET
    description = $$A histogram is described by an array `heights`, where `heights[i]` is the height of the `i`-th bar and every bar is one unit wide. Find the area of the largest rectangle that fits entirely inside the histogram, possibly spanning several adjacent bars.

A rectangle covering bars `i..j` has height `min(heights[i..j])` and width `j - i + 1`.

**Example 1:**
```
Input: heights = [3,1,4,5,2,3]
Output: 8
Explanation: The bars at indices 2 and 3 (heights 4 and 5) together support a 2×4 rectangle of area 8.
```

**Example 2:**
```
Input: heights = [4,2,6,3,7,5,3]
Output: 15
Explanation: The bars at indices 2 through 6 (heights 6, 3, 7, 5 and 3) are all at least 3 tall, so they support a 5×3 rectangle of area 15.
```$$
WHERE slug = $$largest-rectangle-histogram$$;

UPDATE problem_translations SET
    description = $$히스토그램이 배열 `heights`로 주어집니다. `heights[i]`는 `i`번째 막대의 높이이고, 모든 막대의 너비는 1입니다. 히스토그램 안에 완전히 들어가는 (여러 인접 막대에 걸쳐 있어도 됩니다) 가장 큰 직사각형의 넓이를 구하세요.

`i..j` 구간을 덮는 직사각형의 높이는 `min(heights[i..j])`, 너비는 `j - i + 1`입니다.

**예시 1:**
```
입력: heights = [3,1,4,5,2,3]
출력: 8
설명: 인덱스 2와 3에 있는 막대(높이 4와 5)가 함께 2×4 크기의 직사각형을 받쳐, 넓이는 8이 됩니다.
```

**예시 2:**
```
입력: heights = [4,2,6,3,7,5,3]
출력: 15
설명: 인덱스 2부터 6까지의 막대(높이 6, 3, 7, 5, 3)는 모두 높이가 3 이상이므로 5×3 크기의 직사각형을 받쳐, 넓이는 15가 됩니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$largest-rectangle-histogram$$);
