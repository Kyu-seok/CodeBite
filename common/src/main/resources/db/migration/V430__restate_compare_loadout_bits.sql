-- V430: compare-loadout-bits restated, Slug and title unchanged. The statement named the
-- masks leftFlags and rightFlags while every Starter Code called them x and y, and the
-- constraint <= 2.1 * 10^9 was false: a hidden case holds 2147483647. The constraint is now
-- 0 <= leftFlags, rightFlags <= 2^31 - 1, and the first sentence states the task.
-- Starter parameters x, y -> leftFlags, rightFlags in all 4 Starter Codes and Drivers.
-- Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given two teammates' loadout bitmasks `leftFlags` and `rightFlags`, return the number of bit positions where the two values differ. Each bit is one perk slot, so the answer is how many perk slots the two teammates disagree on.

**Example 1:**
```
Input: leftFlags = 10, rightFlags = 5
Output: 4
Explanation: 10 is 1010 and 5 is 0101 in binary; all four low bits differ.
```

**Example 2:**
```
Input: leftFlags = 14, rightFlags = 9
Output: 3
Explanation: 14 is 1110 and 9 is 1001 in binary; bits 0, 1 and 2 differ, bit 3 is 1 in both.
```$$,
    constraints = $$- `0 <= leftFlags, rightFlags <= 2^31 - 1`$$
WHERE slug = $$compare-loadout-bits$$;

UPDATE problem_translations SET
    description = $$두 팀원의 로드아웃 비트마스크 `leftFlags`와 `rightFlags`가 주어질 때, 두 값의 비트가 서로 다른 자리의 개수를 반환하세요. 비트 하나가 퍽 슬롯 하나이므로, 답은 두 팀원의 선택이 엇갈리는 퍽 슬롯의 수입니다.

**예시 1:**
```
입력: leftFlags = 10, rightFlags = 5
출력: 4
설명: 이진수로 10은 1010, 5는 0101이라 하위 네 비트가 모두 다릅니다.
```

**예시 2:**
```
입력: leftFlags = 14, rightFlags = 9
출력: 3
설명: 이진수로 14는 1110, 9는 1001이라 0, 1, 2번 비트가 다르고 3번 비트는 둘 다 1입니다.
```$$,
    constraints = $$- `0 <= leftFlags, rightFlags <= 2^31 - 1`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$compare-loadout-bits$$);
