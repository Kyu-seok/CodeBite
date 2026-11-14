-- V341: find-locker-number restated. Locker numbers sat in an array named `shelf`, the
-- text and constraints named `query` while the Starter Code took `target`, and the
-- method was a library's locateCallNumber: three themes for one binary search. The
-- array is now `lockers` and the number `target` in text, constraints and Starter Code.
-- Starter method locateCallNumber -> findLocker, parameter shelf -> lockers. Examples
-- match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Return the position of locker number `target` in the sorted array `lockers`, or `-1` if no locker has that number.

`lockers` holds distinct locker numbers in ascending order, and positions count from `0`. Your solution must run in `O(log n)` time, where `n` is the length of `lockers`.

**Example 1:**
```
Input: lockers = [102,145,201,247,318,402,510,633], target = 318
Output: 4
Explanation: `lockers[4] = 318`, so locker 318 is at position 4.
```

**Example 2:**
```
Input: lockers = [102,145,201,247,318,402,510,633], target = 200
Output: -1
Explanation: No locker is numbered 200 (it would come between 145 and 201), so the answer is `-1`.
```$$,
    constraints = $$- `1 <= lockers.length <= 2 * 10^5`
- `|lockers[i]| <= 10^8`
- `|target| <= 10^8`
- All numbers in `lockers` are distinct.
- `lockers` is sorted in strictly ascending order.$$
WHERE slug = $$find-locker-number$$;

UPDATE problem_translations SET
    description = $$오름차순으로 정렬된 배열 `lockers`에서 사물함 번호 `target`의 위치를 반환하고, 그 번호의 사물함이 없으면 `-1`을 반환하세요.

`lockers`에는 서로 다른 사물함 번호가 오름차순으로 담겨 있으며, 위치는 `0`부터 셉니다. `n`이 `lockers`의 길이일 때 `O(log n)` 시간에 동작해야 합니다.

**예시 1:**
```
입력: lockers = [102,145,201,247,318,402,510,633], target = 318
출력: 4
설명: `lockers[4] = 318`이므로 318번 사물함은 4번 위치에 있습니다.
```

**예시 2:**
```
입력: lockers = [102,145,201,247,318,402,510,633], target = 200
출력: -1
설명: 200번 사물함은 없으므로(있다면 145와 201 사이에 옵니다) `-1`을 반환합니다.
```$$,
    constraints = $$- `1 <= lockers.length <= 2 * 10^5`
- `|lockers[i]| <= 10^8`
- `|target| <= 10^8`
- `lockers`의 모든 번호는 서로 다릅니다.
- `lockers`는 엄격히 오름차순으로 정렬되어 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$find-locker-number$$);
