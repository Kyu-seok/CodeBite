-- V420: count-coupon-ways restated, title unchanged. Sample 3 and hidden case 5 have
-- amount = 0 return 1 (the empty combination), a rule the statement never gave: it said only
-- "Return 0 if no combination works". Now stated, with sample 3 as Example 3, and the cafe
-- story cut to one line. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$You have store-credit coupons in the values listed in `coupons`, as many of each value as you like. Return the number of different combinations of coupons whose values add up to exactly `amount`.

Order doesn't matter: `1+3` and `3+1` are the same combination. Spending `0` has exactly one combination, using no coupons, so `amount = 0` returns `1`. If no combination adds up to `amount`, return `0`.

**Example 1:**
```
Input: amount = 8, coupons = [1,3,4]
Output: 6
Explanation: The six combinations are 1+1+1+1+1+1+1+1, 1+1+1+1+1+3, 1+1+3+3, 1+1+1+1+4, 1+3+4, and 4+4.
```

**Example 2:**
```
Input: amount = 4, coupons = [5]
Output: 0
Explanation: A 5-won coupon alone can never add up to 4.
```

**Example 3:**
```
Input: amount = 0, coupons = [1,2]
Output: 1
Explanation: Using no coupons at all adds up to 0, and that is the only way.
```$$,
    constraints = $$- `1 <= coupons.length <= 300`
- `1 <= coupons[i] <= 5000`
- All values in `coupons` are distinct.
- `0 <= amount <= 5000`$$
WHERE slug = $$count-coupon-ways$$;

UPDATE problem_translations SET
    description = $$`coupons`에 적힌 액면가의 스토어 크레딧 쿠폰이 있고, 액면가마다 원하는 만큼 쓸 수 있습니다. 액면가의 합이 정확히 `amount`가 되는 서로 다른 쿠폰 조합의 개수를 반환하세요.

순서는 고려하지 않습니다. `1+3`과 `3+1`은 같은 조합입니다. `0`을 쓰는 방법은 쿠폰을 하나도 쓰지 않는 한 가지뿐이므로 `amount = 0`이면 `1`을 반환합니다. 합이 `amount`가 되는 조합이 없으면 `0`을 반환합니다.

**예시 1:**
```
입력: amount = 8, coupons = [1,3,4]
출력: 6
설명: 가능한 6가지 조합은 1+1+1+1+1+1+1+1, 1+1+1+1+1+3, 1+1+3+3, 1+1+1+1+4, 1+3+4, 4+4 입니다.
```

**예시 2:**
```
입력: amount = 4, coupons = [5]
출력: 0
설명: 5원짜리 쿠폰만으로는 합이 4가 될 수 없습니다.
```

**예시 3:**
```
입력: amount = 0, coupons = [1,2]
출력: 1
설명: 쿠폰을 하나도 쓰지 않으면 합이 0이 되고, 그것이 유일한 방법입니다.
```$$,
    constraints = $$- `1 <= coupons.length <= 300`
- `1 <= coupons[i] <= 5000`
- `coupons`의 값은 모두 서로 다릅니다.
- `0 <= amount <= 5000`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-coupon-ways$$);
