-- V394: snack-combo-picks, text restated. The task comes first, without the ticket layer:
-- return every distinct sub-multiset of snacks, the empty one included, in any order and
-- with any order inside a combo (the Driver sorts both). Starter method listMontageScenes
-- -> listSnackCombos, the statement's words. Examples match the sample test cases, which
-- are unchanged.

UPDATE problems SET
    description = $$Each number in `snacks` is the flavor of one snack, and a flavor can appear more than once. A combo is any selection of these snacks, from none of them to all of them.

Return every distinct combo. Two combos are the same when they hold the same flavors the same number of times, so each must appear only once. Include the empty combo.

Return the combos in any order, with the flavors inside each combo in any order. The examples list each combo in ascending order and the combos sorted.

**Example 1:**
```
Input: snacks = [2,5,5]
Output: [[],[2],[2,5],[2,5,5],[5],[5,5]]
Explanation: Picking the first 5 or the second 5 gives the same combo, so [2,5] and [5] appear once each.
```

**Example 2:**
```
Input: snacks = [5]
Output: [[],[5]]
```

**Example 3:**
```
Input: snacks = [2,2,2,1,2]
Output: [[],[1],[1,2],[1,2,2],[1,2,2,2],[1,2,2,2,2],[2],[2,2],[2,2,2],[2,2,2,2]]
Explanation: Flavor 1 can be taken 0 or 1 times and flavor 2 from 0 to 4 times: 2 × 5 = 10 combos.
```$$
WHERE slug = $$snack-combo-picks$$;

UPDATE problem_translations SET
    description = $$`snacks`의 각 수는 간식 하나의 맛이며, 같은 맛이 여러 번 나올 수 있습니다. 조합은 이 간식들 중 몇 개를 고른 것으로, 하나도 고르지 않을 수도 있고 전부 고를 수도 있습니다.

서로 다른 조합을 모두 반환하세요. 같은 맛을 같은 개수만큼 담은 두 조합은 같은 조합이므로 한 번만 들어가야 합니다. 빈 조합도 포함합니다.

조합의 순서와 각 조합 안의 맛 순서는 상관없습니다. 예시에서는 각 조합을 오름차순으로, 조합들을 정렬된 순서로 보여 줍니다.

**예시 1:**
```
입력: snacks = [2,5,5]
출력: [[],[2],[2,5],[2,5,5],[5],[5,5]]
설명: 첫 번째 5를 고르든 두 번째 5를 고르든 같은 조합이므로, [2,5]와 [5]는 한 번씩만 나옵니다.
```

**예시 2:**
```
입력: snacks = [5]
출력: [[],[5]]
```

**예시 3:**
```
입력: snacks = [2,2,2,1,2]
출력: [[],[1],[1,2],[1,2,2],[1,2,2,2],[1,2,2,2,2],[2],[2,2],[2,2,2],[2,2,2,2]]
설명: 맛 1은 0개나 1개, 맛 2는 0개부터 4개까지 고를 수 있으므로 2 × 5 = 10가지 조합입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$snack-combo-picks$$);
