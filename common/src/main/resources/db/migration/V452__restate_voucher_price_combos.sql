-- V452: voucher-price-combos, text restated. Hidden cases use the price 1, though the
-- constraints said `2 <= prices[i]`: the bound is loosened to 1. The statement now says
-- the prices inside a basket may be in any order (every Driver sorts them) and that no
-- matching basket gives an empty list (a hidden case expects `[]`). Examples match the
-- sample test cases, which are unchanged.

UPDATE problems SET
    description = $$`prices` lists the distinct prices of a cafe's items, and you may pick each item any number of times. Return every basket of items whose prices add up to exactly `voucher`.

- A basket is the list of its items' prices, repeats included.
- Two baskets are different when some price appears in them a different number of times.
- The prices inside a basket, and the baskets themselves, may be in any order.
- When no basket adds up to `voucher`, return an empty list.

**Example 1:**
```
Input: prices = [2,4,5], voucher = 9
Output: [[2,2,5],[4,5]]
Explanation: 2 + 2 + 5 = 9 and 4 + 5 = 9 are the only two matching baskets.
```

**Example 2:**
```
Input: prices = [3,4,7], voucher = 10
Output: [[3,3,4],[3,7]]
Explanation: 3 + 3 + 4 = 10 and 3 + 7 = 10 are the only two matching baskets.
```$$,
    constraints = $$- `1 <= prices.length <= 30`
- `1 <= prices[i] <= 40`
- All elements of `prices` are distinct.
- `1 <= voucher <= 40`$$
WHERE slug = $$voucher-price-combos$$;

UPDATE problem_translations SET
    description = $$`prices`는 카페 메뉴들의 서로 다른 가격 목록이며, 각 메뉴는 몇 번이든 골라 담을 수 있습니다. 가격 합이 정확히 `voucher`가 되는 모든 장바구니를 반환하세요.

- 장바구니는 담은 메뉴들의 가격 리스트이며, 같은 가격이 여러 번 들어갈 수 있습니다.
- 어느 한 가격이라도 등장 횟수가 다르면 서로 다른 장바구니입니다.
- 장바구니 안의 가격 순서와 장바구니들의 순서는 상관없습니다.
- 가격 합이 `voucher`가 되는 장바구니가 없으면 빈 리스트를 반환하세요.

**예시 1:**
```
입력: prices = [2,4,5], voucher = 9
출력: [[2,2,5],[4,5]]
설명: `2 + 2 + 5 = 9`와 `4 + 5 = 9`만 쿠폰 금액과 정확히 일치하는 두 장바구니입니다.
```

**예시 2:**
```
입력: prices = [3,4,7], voucher = 10
출력: [[3,3,4],[3,7]]
설명: `3 + 3 + 4 = 10`과 `3 + 7 = 10`이 쿠폰 금액과 정확히 일치하는 두 장바구니입니다.
```$$,
    constraints = $$- `1 <= prices.length <= 30`
- `1 <= prices[i] <= 40`
- `prices`의 모든 원소는 서로 다릅니다.
- `1 <= voucher <= 40`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$voucher-price-combos$$);
