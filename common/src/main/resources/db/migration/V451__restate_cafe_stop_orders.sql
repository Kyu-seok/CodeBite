-- V451: cafe-stop-orders, text restated. A hidden case passes an empty `stops` and expects
-- `[[]]` though the constraints said `1 <= stops.length`: the bound is loosened to 0 and
-- the statement says an empty list has one order, the empty one. Starter method
-- listStationOrders -> listVisitOrders (the statement visits cafes, not stations).
-- Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$`stops` is a list of distinct cafe IDs you plan to visit once each. Implement `listVisitOrders` to return every possible order of visiting them, each order a list of the IDs. The orders may be returned in any order. An empty `stops` has exactly one order, the empty one, so the answer is `[[]]`.

**Example 1:**
```
Input: stops = [4,7,2]
Output: [[2,4,7],[2,7,4],[4,2,7],[4,7,2],[7,2,4],[7,4,2]]
Explanation: Three distinct cafes give 3! = 6 possible visit orders.
```

**Example 2:**
```
Input: stops = [5,9]
Output: [[5,9],[9,5]]
Explanation: With two cafes you visit 5 then 9, or 9 then 5.
```$$,
    constraints = $$- `0 <= stops.length <= 6`
- `-10 <= stops[i] <= 10`
- All entries of `stops` are distinct.$$
WHERE slug = $$cafe-stop-orders$$;

UPDATE problem_translations SET
    description = $$`stops`는 한 번씩 들를 서로 다른 카페 ID들의 리스트입니다. 이 카페들을 방문할 수 있는 모든 순서를 각각 ID 리스트로 만들어 반환하는 `listVisitOrders`를 구현하세요. 순서들은 어떤 차례로 반환해도 됩니다. `stops`가 비어 있으면 가능한 순서는 빈 순서 하나뿐이므로 답은 `[[]]`입니다.

**예시 1:**
```
입력: stops = [4,7,2]
출력: [[2,4,7],[2,7,4],[4,2,7],[4,7,2],[7,2,4],[7,4,2]]
설명: 서로 다른 카페가 3개이므로 가능한 방문 순서는 `3! = 6`가지입니다.
```

**예시 2:**
```
입력: stops = [5,9]
출력: [[5,9],[9,5]]
설명: 카페가 두 곳뿐이므로 가능한 순서는 `5 → 9`와 `9 → 5` 두 가지입니다.
```$$,
    constraints = $$- `0 <= stops.length <= 6`
- `-10 <= stops[i] <= 10`
- `stops`의 모든 원소는 서로 다릅니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$cafe-stop-orders$$);
