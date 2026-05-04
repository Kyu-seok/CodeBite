-- V132: Re-theme the shelf-stock-pair pilot with a casual, friendly domain
-- (sharing a snack drawer with a friend) and simplify the prose. This replaces
-- the V131 warehouse-flavored "stock" framing with a lighter everyday scenario.
--
-- The starter templates under backend/src/main/resources/starters/shelf-stock-pair/
-- were updated in the same commit to rename the array parameter from `stock`
-- to `snacks`. Drivers pass positionally so no harness change is needed.
-- Sample test_cases are unchanged (their inputs are raw arrays that don't
-- reference the parameter name).

UPDATE problems SET description = $$
You and a friend are digging through a shared snack drawer. The array `snacks` lists how many calories each snack has, and together you want to eat exactly `target` calories.

Pick two different snacks whose calories add up to `target`, and return their indices. Exactly one pair works, and the order doesn't matter.

**Example 1:**
```
Input: snacks = [4, 11, 19, 23], target = 30
Output: [1, 2]
Explanation: snacks[1] + snacks[2] = 11 + 19 = 30.
```

**Example 2:**
```
Input: snacks = [8, 14, 6], target = 14
Output: [0, 2]
Explanation: snacks[0] + snacks[2] = 8 + 6 = 14.
```
$$
WHERE slug = 'shelf-stock-pair';

UPDATE problems SET constraints = $$
- `2 <= snacks.length <= 80000`
- `-10^8 <= snacks[i] <= 10^8`
- `-10^8 <= target <= 10^8`
- Exactly one pair works.
$$
WHERE slug = 'shelf-stock-pair';

-- Refresh the Korean translation to match.
DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = 'shelf-stock-pair');

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'shelf-stock-pair'),
    'ko',
    $$간식 서랍 짝 찾기$$,
    $$친구와 함께 간식 서랍을 뒤지고 있습니다. 배열 `snacks`에는 각 간식의 칼로리가 들어 있고, 두 사람이 정확히 `target` 칼로리만큼 먹으려 합니다.

합이 `target`이 되는 서로 다른 두 간식을 골라 그 인덱스를 반환하세요. 정답 짝은 정확히 하나이고, 순서는 상관없습니다.

**예시 1:**
```
Input: snacks = [4, 11, 19, 23], target = 30
Output: [1, 2]
Explanation: snacks[1] + snacks[2] = 11 + 19 = 30.
```

**예시 2:**
```
Input: snacks = [8, 14, 6], target = 14
Output: [0, 2]
Explanation: snacks[0] + snacks[2] = 8 + 6 = 14.
```$$,
    $$- `2 <= snacks.length <= 80000`
- `-10^8 <= snacks[i] <= 10^8`
- `-10^8 <= target <= 10^8`
- 정답 짝이 정확히 하나 존재합니다.$$
);
