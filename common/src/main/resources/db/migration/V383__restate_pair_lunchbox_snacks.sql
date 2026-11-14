-- V383: pair-lunchbox-snacks restated, title unchanged. The parameter crates and method
-- pairCrates named crates, while the statement is about snacks in lunchboxes. Starter
-- method pairCrates -> minLunchboxes, parameter crates -> weights, in all 4 Starter Codes
-- and Drivers. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$You're packing snacks into lunchboxes. `weights[i]` is the weight of snack `i` in grams. Each lunchbox holds **at most two snacks** whose total weight is at most `capacity`, and every snack must be packed.

Return the **minimum number of lunchboxes** needed.

**Example 1:**
```
Input: weights = [2,4], capacity = 6
Output: 1
Explanation: The two snacks weigh 6 grams together, so they fit in one lunchbox.
```

**Example 2:**
```
Input: weights = [4,3,1,2], capacity = 4
Output: 3
Explanation: The 3 and the 1 share a lunchbox. The 4 and the 2 can't share one with anything left, so each goes alone: three lunchboxes.
```$$,
    constraints = $$- `1 <= weights.length <= 2 * 10^5`
- `1 <= weights[i] <= capacity <= 2 * 10^3`$$
WHERE slug = $$pair-lunchbox-snacks$$;

UPDATE problem_translations SET
    description = $$간식을 도시락에 담는 중입니다. `weights[i]`는 `i`번째 간식의 무게(그램)입니다. 도시락 한 개에는 **간식이 최대 두 개**까지, 총 무게 `capacity` 이하로만 들어가며, 모든 간식을 담아야 합니다.

필요한 **최소 도시락 개수**를 반환하세요.

**예시 1:**
```
입력: weights = [2,4], capacity = 6
출력: 1
설명: 두 간식이 합쳐 6그램이라 도시락 하나에 같이 들어갑니다.
```

**예시 2:**
```
입력: weights = [4,3,1,2], capacity = 4
출력: 3
설명: 3과 1을 한 도시락에 담습니다. 4와 2는 남은 간식 어느 것과도 같이 담을 수 없어 각각 따로 담으므로, 도시락은 세 개입니다.
```$$,
    constraints = $$- `1 <= weights.length <= 2 * 10^5`
- `1 <= weights[i] <= capacity <= 2 * 10^3`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$pair-lunchbox-snacks$$);
