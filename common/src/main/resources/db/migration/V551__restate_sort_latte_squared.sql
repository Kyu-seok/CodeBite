-- V551: sort-latte-squared restated, Slug and title unchanged. The statement opened with the latte
-- backstory before the task: it now starts with what goes in and what comes out. Starter method
-- orderTankDeviations (tanks, from an earlier theme) -> sortedSquaredDrifts in all 4 Starter Codes
-- and Drivers. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given an array `drifts` sorted in non-decreasing order, return the square of each drift, also in non-decreasing order. Each drift is a latte's temperature difference from the target: negative when it is too cold, positive when it is too hot.

Aim for O(n), without a general-purpose sort.

**Example 1:**
```
Input: drifts = [-5,-2,0,4,9]
Output: [0,4,16,25,81]
Explanation: The squares are 25, 4, 0, 16 and 81; sorted, they read 0, 4, 16, 25, 81.
```

**Example 2:**
```
Input: drifts = [-6,-4,1,3,8]
Output: [1,9,16,36,64]
Explanation: -6 and -4 square to 36 and 16, which land among the squares of 1, 3 and 8.
```

**Example 3:**
```
Input: drifts = [2,3,5,7]
Output: [4,9,25,49]
Explanation: Every value is non-negative, so squaring keeps the order.
```$$
WHERE slug = $$sort-latte-squared$$;

UPDATE problem_translations SET
    description = $$비내림차순으로 정렬된 배열 `drifts`가 주어질 때, 각 값을 제곱한 결과를 비내림차순으로 반환하세요. 각 값은 라떼의 목표 온도 대비 편차로, 너무 차가우면 음수, 너무 뜨거우면 양수입니다.

일반 정렬 알고리즘 없이 O(n)에 처리하는 것을 목표로 합니다.

**예시 1:**
```
입력: drifts = [-5,-2,0,4,9]
출력: [0,4,16,25,81]
설명: 제곱하면 25, 4, 0, 16, 81이고, 정렬하면 0, 4, 16, 25, 81입니다.
```

**예시 2:**
```
입력: drifts = [-6,-4,1,3,8]
출력: [1,9,16,36,64]
설명: -6과 -4의 제곱 36과 16이 1, 3, 8의 제곱 사이로 들어갑니다.
```

**예시 3:**
```
입력: drifts = [2,3,5,7]
출력: [4,9,25,49]
설명: 모든 값이 음이 아니라서, 제곱해도 순서가 그대로 유지됩니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$sort-latte-squared$$);
