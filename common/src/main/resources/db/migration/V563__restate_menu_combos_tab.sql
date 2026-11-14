-- V563: menu-combos-tab restated, Slug and title unchanged. The first sentence now states the
-- task without naming the method, and the statement says to return an empty list when no combo
-- sums to tab (a hidden case expects []) and that combos and their prices may come in any order
-- (every Driver sorts them). Examples 1 and 2 are explained. Starter method listQuotaBatches ->
-- listTabCombos in all 4 Starter Codes and Drivers, and the Drivers' candidates/target locals
-- are now pastries/tab. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given an array `pastries` of pastry prices (a price may repeat) and an integer `tab`, return every distinct combo of pastries whose prices sum to exactly `tab`.

Each pastry can be used at most once in a combo. Two combos with the same prices count as one, so return each only once. Return the combos in any order, each combo's prices in any order, or an empty list when no combo sums to `tab`.

**Example 1:**
```
Input: pastries = [2,3,6,1,3,4], tab = 7
Output: [[1,2,4],[1,3,3],[1,6],[3,4]]
Explanation: [1,3,3] uses both 3s. Either 3 can pair with 4, but [3,4] is listed once.
```

**Example 2:**
```
Input: pastries = [4,2,1,2,3], tab = 5
Output: [[1,2,2],[1,4],[2,3]]
Explanation: [1,2,2] uses both 2s, and [2,3] is listed once.
```

**Example 3:**
```
Input: pastries = [8,8,8], tab = 16
Output: [[8,8]]
Explanation: 8 appears three times, but only a pair of 8s adds to 16.
```$$
WHERE slug = $$menu-combos-tab$$;

UPDATE problem_translations SET
    description = $$페이스트리 가격 배열 `pastries`(같은 가격이 여러 번 나올 수 있음)와 정수 `tab`이 주어질 때, 가격의 합이 정확히 `tab`이 되는 서로 다른 페이스트리 조합을 모두 반환하세요.

각 페이스트리는 한 조합에서 최대 한 번만 쓸 수 있습니다. 가격 구성이 같은 두 조합은 하나로 치므로 한 번만 반환합니다. 조합의 순서와 각 조합 안의 가격 순서는 자유이며, 합이 `tab`인 조합이 없으면 빈 리스트를 반환합니다.

**예시 1:**
```
입력: pastries = [2,3,6,1,3,4], tab = 7
출력: [[1,2,4],[1,3,3],[1,6],[3,4]]
설명: [1,3,3]은 3 두 개를 모두 씁니다. 두 3 중 어느 것이든 4와 짝을 이룰 수 있지만 [3,4]는 한 번만 나옵니다.
```

**예시 2:**
```
입력: pastries = [4,2,1,2,3], tab = 5
출력: [[1,2,2],[1,4],[2,3]]
설명: [1,2,2]는 2 두 개를 모두 쓰고, [2,3]은 한 번만 나옵니다.
```

**예시 3:**
```
입력: pastries = [8,8,8], tab = 16
출력: [[8,8]]
설명: 8이 세 번 나오지만, 합이 16이 되는 조합은 8 두 개로 이루어진 짝뿐입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$menu-combos-tab$$);
