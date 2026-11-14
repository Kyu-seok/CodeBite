-- V471: shortest-cookie-span restated. The statement mixed trays and slots ("each slot",
-- "the whole tray") and Example 2 fell "short of the order", an order never introduced;
-- each entry of trays is now one tray throughout and Example 2 falls short of target. The
-- Korean said a span must exceed target, where reaching it is enough. Starter method
-- shortestBakeSpan -> shortestCookieSpan in all 4 Starter Codes and Drivers. Examples
-- match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Cookie trays stand in a row, and `trays[i]` is the number of cookies on tray `i`. Return the length of the shortest run of consecutive trays that hold at least `target` cookies in total, or `0` if no run does.

**Example 1:**
```
Input: trays = [3,1,4,1,5,9,2,6], target = 15
Output: 3
Explanation: The trays [1,5,9] hold 15 cookies, and no two consecutive trays reach 15.
```

**Example 2:**
```
Input: trays = [2,2,2], target = 10
Output: 0
Explanation: All three trays together hold only 6 cookies, short of target.
```

**Example 3:**
```
Input: trays = [8,3,2], target = 8
Output: 1
Explanation: The first tray alone holds 8 cookies.
```$$,
    constraints = $$- `1 <= trays.length <= 2 * 10^5`
- `1 <= trays[i] <= 8000`
- `1 <= target <= 10^8`$$
WHERE slug = $$shortest-cookie-span$$;

UPDATE problem_translations SET
    description = $$쿠키 트레이가 한 줄로 놓여 있고, `trays[i]`는 `i`번 트레이에 담긴 쿠키 개수입니다. 쿠키를 모두 합해 `target`개 이상 담고 있는 연속된 트레이 구간 중 가장 짧은 구간의 길이를 반환하세요. 그런 구간이 없으면 `0`을 반환합니다.

**예시 1:**
```
입력: trays = [3,1,4,1,5,9,2,6], target = 15
출력: 3
설명: 트레이 [1,5,9]에 쿠키가 15개 있고, 연속된 트레이 두 개로는 15개에 닿지 않습니다.
```

**예시 2:**
```
입력: trays = [2,2,2], target = 10
출력: 0
설명: 세 트레이를 모두 합쳐도 쿠키가 6개뿐이라 target에 못 미칩니다.
```

**예시 3:**
```
입력: trays = [8,3,2], target = 8
출력: 1
설명: 첫 번째 트레이 하나에 이미 쿠키가 8개 있습니다.
```$$,
    constraints = $$- `1 <= trays.length <= 2 * 10^5`
- `1 <= trays[i] <= 8000`
- `1 <= target <= 10^8`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$shortest-cookie-span$$);
