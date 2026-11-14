-- V521: pick-snack-haul restated, Slug and title unchanged. The fuse-and-wiring story
-- stood in for "no two adjacent machines": the task is now stated plainly. The method
-- was named pickPlotHaul, left over from another theme: renamed maxSnackHaul in the
-- Starter Code and Drivers. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$A hallway has a row of vending machines, and `snacks[i]` is the number of snacks in machine `i`. Pick machines, never two adjacent ones, to maximise the total of `snacks`.

Implement `maxSnackHaul(snacks)` to return that maximum total.

**Example 1:**
```
Input: snacks = [4,1,1,9,1,3]
Output: 16
Explanation: Picking machines 0, 3 and 5 gives 4 + 9 + 3 = 16. No other choice without two adjacent machines totals more.
```

**Example 2:**
```
Input: snacks = [5,5,10,100,10,5]
Output: 110
Explanation: Picking machines 1, 3 and 5 gives 5 + 100 + 5 = 110. Any choice that skips machine 3 totals at most 5 + 10 + 10 = 25.
```$$
WHERE slug = $$pick-snack-haul$$;

UPDATE problem_translations SET
    description = $$복도에 자판기들이 한 줄로 늘어서 있고, `snacks[i]`는 자판기 `i`에 든 간식의 개수입니다. 이웃한 두 자판기는 함께 고르지 않으면서 자판기들을 골라, 고른 `snacks`의 합을 최대로 만드세요.

그 최대 합을 반환하는 `maxSnackHaul(snacks)`를 구현하세요.

**예시 1:**
```
입력: snacks = [4,1,1,9,1,3]
출력: 16
설명: 자판기 0, 3, 5번을 고르면 4 + 9 + 3 = 16입니다. 이웃한 두 자판기를 고르지 않는 다른 어떤 선택도 이보다 크지 않습니다.
```

**예시 2:**
```
입력: snacks = [5,5,10,100,10,5]
출력: 110
설명: 자판기 1, 3, 5번을 고르면 5 + 100 + 5 = 110입니다. 자판기 3번을 고르지 않는 선택은 많아야 5 + 10 + 10 = 25입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$pick-snack-haul$$);
