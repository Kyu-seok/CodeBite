-- V330: best-skin-flip-day -> skin-resale-with-cooldown, retitled "Skin Resale With
-- Cooldown". "Best ... Day" suggested returning a day; the task returns the maximum
-- total profit over any number of trades. The statement now says so, and that you hold
-- at most one copy. Starter method bestTierResale -> maxProfit, parameter tierPrices ->
-- prices. Drivers and Starter Code directories are renamed in the same commit. Examples
-- match the sample test cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$best-skin-flip-day$$, id FROM problems WHERE slug = $$best-skin-flip-day$$;

UPDATE problems SET
    slug = $$skin-resale-with-cooldown$$,
    title = $$Skin Resale With Cooldown$$,
    description = $$Given `prices`, where `prices[i]` is the price of a game skin on day `i`, return the maximum total profit you can make by buying and reselling it.

You may trade as many times as you like, but you hold at most one copy at a time. Each day you do exactly one of:

- buy one copy, if you hold none;
- sell the copy you hold;
- do nothing.

After a sale, you must wait one day (the cooldown) before buying again: selling on day `i` means your next buy can be on day `i + 2` at the earliest. If no trade makes a profit, return `0`.

**Example 1:**
```
Input: prices = [3,8,5,1,6]
Output: 10
Explanation: Buy on day 0 at 3 and sell on day 1 at 8 (profit 5). Day 2 is the cooldown. Buy on day 3 at 1 and sell on day 4 at 6 (profit 5). Total 10.
```

**Example 2:**
```
Input: prices = [9,2,5]
Output: 3
Explanation: Skip day 0, buy on day 1 at 2 and sell on day 2 at 5, a profit of 3.
```$$,
    constraints = $$- `1 <= prices.length <= 2000`
- `0 <= prices[i] <= 900`$$
WHERE slug = $$best-skin-flip-day$$;

UPDATE problem_translations SET
    title = $$쿨다운이 있는 스킨 되팔기$$,
    description = $$`prices[i]`가 `i`일째 게임 스킨 가격인 배열 `prices`가 주어질 때, 스킨을 사고 되팔아 얻을 수 있는 최대 총 이익을 반환하세요.

거래는 몇 번이든 할 수 있지만, 한 번에 최대 한 개만 들고 있을 수 있습니다. 매일 다음 중 정확히 하나를 합니다.

- 들고 있는 게 없으면 한 개 사기
- 들고 있는 것을 팔기
- 아무것도 하지 않기

판매한 뒤에는 하루를 쉬어야(쿨다운) 다시 살 수 있습니다. 즉 `i`일에 팔았다면 다음 구매는 빨라야 `i + 2`일입니다. 이익을 내는 거래가 없으면 `0`을 반환하세요.

**예시 1:**
```
입력: prices = [3,8,5,1,6]
출력: 10
설명: 0일에 3에 사서 1일에 8에 팝니다(이익 5). 2일은 쿨다운입니다. 3일에 1에 사서 4일에 6에 팝니다(이익 5). 합계 10.
```

**예시 2:**
```
입력: prices = [9,2,5]
출력: 3
설명: 0일은 건너뛰고, 1일에 2에 사서 2일에 5에 팔면 이익 3입니다.
```$$,
    constraints = $$- `1 <= prices.length <= 2000`
- `0 <= prices[i] <= 900`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$skin-resale-with-cooldown$$);
