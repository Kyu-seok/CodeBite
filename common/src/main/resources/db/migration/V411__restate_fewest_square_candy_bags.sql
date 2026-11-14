-- V411: count-square-candy-bags -> fewest-square-candy-bags, retitled "Fewest Square Candy
-- Bags". The old title said "Count" though the task is the minimum number of bags, the
-- description named countExactTargets while the Python Starter Code had perfect_sum, and the
-- parameter `pages` meant a number of candies. Starter method countExactTargets (perfect_sum
-- in Python) -> fewestBags and parameter pages -> candies in all 4 Starter Codes and Drivers.
-- Drivers and Starter Code directories are renamed in the same commit. Examples match the
-- sample test cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$count-square-candy-bags$$, id FROM problems WHERE slug = $$count-square-candy-bags$$;

UPDATE problems SET
    slug = $$fewest-square-candy-bags$$,
    title = $$Fewest Square Candy Bags$$,
    description = $$A candy store sells bags only in perfect-square sizes: 1, 4, 9, 16, 25, and so on, and you can buy any size as many times as you want. Given an integer `candies`, return the fewest bags whose sizes add up to exactly `candies`.

**Example 1:**
```
Input: candies = 7
Output: 4
Explanation: 7 = 4 + 1 + 1 + 1. No 1, 2 or 3 perfect squares add up to 7.
```

**Example 2:**
```
Input: candies = 17
Output: 2
Explanation: 17 = 16 + 1.
```

**Example 3:**
```
Input: candies = 5
Output: 2
Explanation: 5 = 4 + 1.
```$$,
    constraints = $$- `1 <= candies <= 12000`$$
WHERE slug = $$count-square-candy-bags$$;

UPDATE problem_translations SET
    title = $$최소 제곱수 사탕 봉지$$,
    description = $$어느 사탕 가게는 1, 4, 9, 16, 25처럼 완전제곱수 크기의 봉지만 팔고, 어떤 크기든 원하는 만큼 살 수 있습니다. 정수 `candies`가 주어질 때, 크기의 합이 정확히 `candies`가 되는 봉지의 최소 개수를 반환하세요.

**예시 1:**
```
입력: candies = 7
출력: 4
설명: 7 = 4 + 1 + 1 + 1. 완전제곱수 1개, 2개, 3개로는 합이 7이 되지 않습니다.
```

**예시 2:**
```
입력: candies = 17
출력: 2
설명: 17 = 16 + 1.
```

**예시 3:**
```
입력: candies = 5
출력: 2
설명: 5 = 4 + 1.
```$$,
    constraints = $$- `1 <= candies <= 12000`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$fewest-square-candy-bags$$);
