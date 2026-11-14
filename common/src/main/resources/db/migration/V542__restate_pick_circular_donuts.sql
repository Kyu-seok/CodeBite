-- V542: pick-circular-donuts restated, title unchanged. The parameter yields and the
-- method pickCircuitTargets were left over from another theme; they become tastiness and
-- maxTastiness. The statement now says a lone donut can be taken (a hidden case is [1]).
-- Starter method pickCircuitTargets -> maxTastiness and parameter yields -> tastiness in
-- all 4 Starter Codes and Drivers. Examples match the sample test cases, which are
-- unchanged.

UPDATE problems SET
    description = $$Donuts sit in a circle on a tray, and donut `i` has tastiness `tastiness[i]`. Return the largest total tastiness you can collect without taking two donuts that sit next to each other.

The tray is round, so the first and last donuts are neighbors too. A tray with a single donut has no neighbors, so that donut can be taken.

**Example 1:**
```
Input: tastiness = [4,1,5,6,2]
Output: 10
Explanation: Take donuts 0 and 3 for 4 + 6 = 10. Donut 4 can't be added, since it sits next to donut 0.
```

**Example 2:**
```
Input: tastiness = [3,8,2,7,1,9]
Output: 24
Explanation: Take donuts 1, 3 and 5 for 8 + 7 + 9 = 24. Donut 0 is left out, since it sits next to donut 5.
```$$,
    constraints = $$- `1 <= tastiness.length <= 2 * 10^3`
- `0 <= tastiness[i] <= 5000`$$
WHERE slug = $$pick-circular-donuts$$;

UPDATE problem_translations SET
    description = $$원형 트레이 위에 도넛이 둥글게 놓여 있고, `i`번 도넛의 맛 점수는 `tastiness[i]`입니다. 바로 옆에 붙어 있는 두 도넛을 함께 고르지 않으면서 모을 수 있는 맛 점수 합의 최댓값을 반환하세요.

트레이가 원형이므로 첫 번째 도넛과 마지막 도넛도 이웃입니다. 도넛이 하나뿐이면 이웃이 없으므로 그 도넛을 고를 수 있습니다.

**예시 1:**
```
입력: tastiness = [4,1,5,6,2]
출력: 10
설명: 0번과 3번 도넛을 골라 4 + 6 = 10을 얻습니다. 4번 도넛은 0번 도넛 옆에 있어서 더할 수 없습니다.
```

**예시 2:**
```
입력: tastiness = [3,8,2,7,1,9]
출력: 24
설명: 1번, 3번, 5번 도넛을 골라 8 + 7 + 9 = 24를 얻습니다. 0번 도넛은 5번 도넛 옆에 있어서 빠집니다.
```$$,
    constraints = $$- `1 <= tastiness.length <= 2 * 10^3`
- `0 <= tastiness[i] <= 5000`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$pick-circular-donuts$$);
