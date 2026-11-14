-- V390: merged-price-median, text restated. The task comes first, and the lists are price
-- changes, so the negative values in the hidden cases fit the theme. Starter parameters
-- zonesA/zonesB -> pricesA/pricesB and method mergedZoneMedian -> mergedPriceMedian, the
-- statement's words. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given two lists `pricesA` and `pricesB`, each sorted in non-decreasing order, return the median of all their values together: the middle value when the total count is odd, or the average of the two middle values when it is even.

Each list is one barista's log of today's drink price changes, so a value can be negative (a discount).

Your solution must run in `O(log(m + n))` time, where `m = pricesA.length` and `n = pricesB.length`.

**Example 1:**
```
Input: pricesA = [2,5], pricesB = [4]
Output: 4.0
Explanation: The merged list is [2,4,5]; the middle value is 4.
```

**Example 2:**
```
Input: pricesA = [3,8], pricesB = [5,11]
Output: 6.5
Explanation: The merged list is [3,5,8,11]; the median is (5 + 8) / 2 = 6.5.
```

**Example 3:**
```
Input: pricesA = [], pricesB = [12]
Output: 12.0
Explanation: One list can be empty. The merged list is [12], so the median is 12.
```$$,
    constraints = $$- `0 <= pricesA.length, pricesB.length <= 1500`
- `1 <= pricesA.length + pricesB.length <= 3000`
- `|pricesA[i]|, |pricesB[i]| <= 10^7`
- Both lists are sorted in non-decreasing order.$$
WHERE slug = $$merged-price-median$$;

UPDATE problem_translations SET
    description = $$비내림차순으로 정렬된 두 목록 `pricesA`와 `pricesB`가 주어질 때, 두 목록의 값을 모두 합친 것의 중앙값을 반환하세요. 전체 개수가 홀수면 가운데 값, 짝수면 가운데 두 값의 평균입니다.

각 목록은 바리스타 한 명이 기록한 오늘의 음료 가격 변동이라서, 값이 음수(할인)일 수도 있습니다.

`m = pricesA.length`, `n = pricesB.length`라 할 때, 풀이는 `O(log(m + n))` 시간에 동작해야 합니다.

**예시 1:**
```
입력: pricesA = [2,5], pricesB = [4]
출력: 4.0
설명: 합친 목록은 [2,4,5]이고, 가운데 값은 4입니다.
```

**예시 2:**
```
입력: pricesA = [3,8], pricesB = [5,11]
출력: 6.5
설명: 합친 목록은 [3,5,8,11]이고, 중앙값은 (5 + 8) / 2 = 6.5입니다.
```

**예시 3:**
```
입력: pricesA = [], pricesB = [12]
출력: 12.0
설명: 한 목록은 비어 있을 수 있습니다. 합친 목록은 [12]이므로 중앙값은 12입니다.
```$$,
    constraints = $$- `0 <= pricesA.length, pricesB.length <= 1500`
- `1 <= pricesA.length + pricesB.length <= 3000`
- `|pricesA[i]|, |pricesB[i]| <= 10^7`
- 두 목록 모두 비내림차순으로 정렬되어 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$merged-price-median$$);
