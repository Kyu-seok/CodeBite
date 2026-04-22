-- V131: Simplify shelf-stock-pair description to plain, direct CS prose while
-- keeping a light domain flavor via the parameter name (`stock` instead of the
-- generic `nums`). V123 introduced a heavier "warehouse widget count" framing
-- that felt indirect; this pass strips the narrative down to a one-sentence
-- task statement with two worked examples.
--
-- The parameter rename is coordinated with the starter templates under
-- backend/src/main/resources/starters/shelf-stock-pair/ (java/python/cpp/js),
-- which were updated in the same commit. Driver harnesses pass positionally,
-- so no driver change is required. Sample test_cases (raw-array inputs) are
-- also unchanged since they don't reference the parameter name.

UPDATE problems SET description = $$
Given an integer array `stock` and an integer `target`, return the indices of two different elements in `stock` whose values add up to `target`.

Each input has exactly one valid pair, and you may return the two indices in any order.

**Example 1:**
```
Input: stock = [4, 11, 19, 23], target = 30
Output: [1, 2]
Explanation: stock[1] + stock[2] = 11 + 19 = 30.
```

**Example 2:**
```
Input: stock = [8, 14, 6], target = 14
Output: [0, 2]
Explanation: stock[0] + stock[2] = 8 + 6 = 14.
```
$$
WHERE slug = 'shelf-stock-pair';

UPDATE problems SET constraints = $$
- `2 <= stock.length <= 80000`
- `-10^8 <= stock[i] <= 10^8`
- `-10^8 <= target <= 10^8`
- Exactly one pair of indices satisfies the request.
$$
WHERE slug = 'shelf-stock-pair';

-- Refresh the Korean translation to match: plain prose, `stock` variable,
-- same two examples.
DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = 'shelf-stock-pair');

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'shelf-stock-pair'),
    'ko',
    $KO$선반 재고 짝 찾기$KO$,
    $KO$정수 배열 `stock`과 정수 `target`이 주어집니다. 값의 합이 `target`이 되는 서로 다른 두 원소의 인덱스를 반환하세요.

각 입력에는 정답이 되는 짝이 정확히 하나 존재하며, 두 인덱스는 어떤 순서로 반환해도 됩니다.

**예시 1:**
```
Input: stock = [4, 11, 19, 23], target = 30
Output: [1, 2]
Explanation: stock[1] + stock[2] = 11 + 19 = 30.
```

**예시 2:**
```
Input: stock = [8, 14, 6], target = 14
Output: [0, 2]
Explanation: stock[0] + stock[2] = 8 + 6 = 14.
```$KO$,
    $KO$- `2 <= stock.length <= 80000`
- `-10^8 <= stock[i] <= 10^8`
- `-10^8 <= target <= 10^8`
- 정답 짝이 정확히 하나 존재합니다.$KO$
);
