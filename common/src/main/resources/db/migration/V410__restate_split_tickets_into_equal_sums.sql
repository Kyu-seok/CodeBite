-- V410: split-ticket-pile -> split-tickets-into-equal-sums, retitled "Split Tickets into
-- Equal Sums". The title and the garbled first sentence hid that the two groups must have
-- equal sums, and Example 1 split the pile between "Alice and Bob", who appear nowhere else.
-- Starter method canSplitLoads -> canSplitEqually in all 4 Starter Codes and Drivers.
-- Drivers and Starter Code directories are renamed in the same commit. Examples match the
-- sample test cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$split-ticket-pile$$, id FROM problems WHERE slug = $$split-ticket-pile$$;

UPDATE problems SET
    slug = $$split-tickets-into-equal-sums$$,
    title = $$Split Tickets into Equal Sums$$,
    description = $$Given an array `tickets` of point values, return `true` if the tickets can be split into two groups with equal sums, and `false` otherwise. Every ticket goes into exactly one of the two groups.

**Example 1:**
```
Input: tickets = [3,1,1,2,2,1]
Output: true
Explanation: The total is 10, so each group must sum to 5: {3, 2} and {1, 1, 2, 1}.
```

**Example 2:**
```
Input: tickets = [2,2,3,5]
Output: false
Explanation: The total is 12, so each group would have to sum to 6, but no subset of {2, 2, 3, 5} sums to 6.
```$$,
    constraints = $$- `1 <= tickets.length <= 200`
- `1 <= tickets[i] <= 100`$$
WHERE slug = $$split-ticket-pile$$;

UPDATE problem_translations SET
    title = $$티켓을 합이 같은 두 그룹으로 나누기$$,
    description = $$티켓의 점수 배열 `tickets`가 주어집니다. 티켓들을 합이 같은 두 그룹으로 나눌 수 있으면 `true`, 그렇지 않으면 `false`를 반환하세요. 모든 티켓은 두 그룹 중 정확히 한 곳에 들어갑니다.

**예시 1:**
```
입력: tickets = [3,1,1,2,2,1]
출력: true
설명: 합이 10이므로 각 그룹의 합은 5여야 합니다: {3, 2}와 {1, 1, 2, 1}.
```

**예시 2:**
```
입력: tickets = [2,2,3,5]
출력: false
설명: 합이 12이므로 각 그룹의 합은 6이어야 하지만, {2, 2, 3, 5}의 어떤 부분집합도 합이 6이 되지 않습니다.
```$$,
    constraints = $$- `1 <= tickets.length <= 200`
- `1 <= tickets[i] <= 100`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$split-tickets-into-equal-sums$$);
