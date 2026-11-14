-- V352: lonely-candy restated, title unchanged. The story is candy flavors but the array was
-- `frames`, a leftover of another theme; it is now `candies`, one flavor number per candy.
-- Starter method findUnpairedFrame -> findLonelyCandy, parameter frames -> candies, in all 4
-- Starter Codes and Drivers; the Walkthrough is regenerated with the new name. Examples match
-- the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$You dumped a bag of candies on the table. `candies[i]` is the flavor of candy `i`, as a number. Every flavor appears exactly twice except one, which appears once: return that lonely flavor.

Use O(n) time and O(1) extra space.

**Example 1:**
```
Input: candies = [5,5,3]
Output: 3
Explanation: 5 appears twice; 3 appears only once.
```

**Example 2:**
```
Input: candies = [8,2,6,2,6]
Output: 8
Explanation: 2 and 6 each appear twice; 8 appears only once.
```$$,
    constraints = $$- `1 <= candies.length <= 8 * 10^4`
- `|candies[i]| <= 10^8`
- Every value in `candies` appears exactly twice, except one value that appears exactly once.$$
WHERE slug = $$lonely-candy$$;

UPDATE problem_translations SET
    description = $$사탕 한 봉지를 식탁에 쏟았습니다. `candies[i]`는 사탕 `i`의 맛을 나타내는 수입니다. 모든 맛은 정확히 두 번씩 나오는데 한 맛만 한 번 나옵니다. 그 외톨이 맛을 반환하세요.

O(n) 시간과 O(1) 추가 공간을 사용하세요.

**예시 1:**
```
입력: candies = [5,5,3]
출력: 3
설명: 5는 두 번, 3은 한 번만 나옵니다.
```

**예시 2:**
```
입력: candies = [8,2,6,2,6]
출력: 8
설명: 2와 6은 두 번씩 나오고, 8만 한 번 나옵니다.
```$$,
    constraints = $$- `1 <= candies.length <= 8 * 10^4`
- `|candies[i]| <= 10^8`
- `candies`의 값은 정확히 한 번 나오는 값 하나를 빼고 모두 정확히 두 번씩 나옵니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$lonely-candy$$);
