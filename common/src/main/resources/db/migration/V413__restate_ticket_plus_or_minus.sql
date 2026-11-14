-- V413: ticket-plus-or-minus restated, title unchanged. The statement left implicit that the
-- total starts at 0, and never said that a ticket worth 0 gives two assignments (+0 and -0)
-- counted separately, which hidden case 4 ([0,0,0,0,0], 0 -> 32) depends on. Both are now
-- stated. Starter method partitionTankDoses (tank doses) -> countSignAssignments in all 4
-- Starter Codes and Drivers. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given an array `tickets` of point values and an integer `target`, put a `+` or a `-` in front of every value and add them all up. Return how many of these sign assignments give a total of exactly `target`.

Two assignments are different when some ticket gets a different sign, even if the two tickets have equal values. So a ticket worth `0` gives two assignments, `+0` and `-0`, counted separately.

**Example 1:**
```
Input: tickets = [2,2,2,2], target = 4
Output: 4
Explanation: The total is 4 when three tickets get + and one gets -: -2+2+2+2, +2-2+2+2, +2+2-2+2 and +2+2+2-2.
```

**Example 2:**
```
Input: tickets = [4,6,8], target = 10
Output: 1
Explanation: Only -4+6+8 gives 10.
```$$
WHERE slug = $$ticket-plus-or-minus$$;

UPDATE problem_translations SET
    description = $$점수 배열 `tickets`와 정수 `target`이 주어집니다. 모든 값 앞에 `+` 또는 `-`를 붙인 뒤 전부 더할 때, 합이 정확히 `target`이 되는 부호 배정의 개수를 반환하세요.

어떤 티켓의 부호가 하나라도 다르면 서로 다른 배정입니다. 두 티켓의 값이 같아도 마찬가지입니다. 따라서 값이 `0`인 티켓은 `+0`과 `-0` 두 가지 배정으로 따로 셉니다.

**예시 1:**
```
입력: tickets = [2,2,2,2], target = 4
출력: 4
설명: 티켓 세 장에 +, 한 장에 -를 붙이면 합이 4가 됩니다: -2+2+2+2, +2-2+2+2, +2+2-2+2, +2+2+2-2.
```

**예시 2:**
```
입력: tickets = [4,6,8], target = 10
출력: 1
설명: -4+6+8만 합이 10이 됩니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$ticket-plus-or-minus$$);
