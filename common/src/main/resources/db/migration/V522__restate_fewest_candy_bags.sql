-- V522: fewest-candy-bags restated, Slug and title unchanged. The method was named
-- fewestBagSizes, as if it returned sizes, while it returns a count of bags: renamed
-- fewestBags in the Starter Code and Drivers (Driver locals coins/amount renamed
-- bagSizes/quota). A quota of 0 needs 0 bags, which sample case 3 expects, is now
-- stated and is Example 3; Example 1 no longer mentions an unintroduced "catalog".
-- Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$You're packing candy for movie night. `bagSizes` lists the bag sizes in the pantry, each holding an exact number of pieces, and you can use any number of bags of each size. Pack exactly `quota` pieces using the fewest bags.

Implement `fewestBags(bagSizes, quota)` to return the minimum number of bags whose sizes sum to `quota`, or `-1` if no combination works. A quota of `0` needs `0` bags.

**Example 1:**
```
Input: bagSizes = [2,4,7], quota = 15
Output: 3
Explanation: Bags of size 4, 4 and 7 hold 15 pieces. No two bag sizes sum to 15, so three bags is the minimum.
```

**Example 2:**
```
Input: bagSizes = [3,5], quota = 4
Output: -1
Explanation: No combination of bags of size 3 and 5 sums to exactly 4.
```

**Example 3:**
```
Input: bagSizes = [1], quota = 0
Output: 0
Explanation: Nothing needs packing, so no bags are used.
```$$
WHERE slug = $$fewest-candy-bags$$;

UPDATE problem_translations SET
    description = $$영화의 밤을 준비하며 사탕을 봉지에 나눠 담으려 합니다. `bagSizes`는 찬장에 있는 봉지 크기의 목록이고, 각 봉지에는 크기만큼의 사탕이 정확히 들어가며, 크기마다 봉지를 원하는 만큼 쓸 수 있어요. 정확히 `quota`개의 사탕을 담되, 봉지를 가장 적게 쓰세요.

크기의 합이 `quota`가 되는 최소 봉지 수를 반환하는 `fewestBags(bagSizes, quota)`를 구현하세요. 어떤 조합으로도 만들 수 없다면 `-1`을 반환합니다. `quota`가 `0`이면 봉지가 `0`개 필요합니다.

**예시 1:**
```
입력: bagSizes = [2,4,7], quota = 15
출력: 3
설명: 크기 4, 4, 7인 봉지 세 개에 사탕 15개가 들어갑니다. 봉지 두 개로 합이 15가 되는 조합은 없으므로 최소 개수는 3입니다.
```

**예시 2:**
```
입력: bagSizes = [3,5], quota = 4
출력: -1
설명: 크기가 3과 5인 봉지만으로는 합이 정확히 4가 되도록 만들 수 없습니다.
```

**예시 3:**
```
입력: bagSizes = [1], quota = 0
출력: 0
설명: 담을 사탕이 없으므로 봉지를 하나도 쓰지 않습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$fewest-candy-bags$$);
