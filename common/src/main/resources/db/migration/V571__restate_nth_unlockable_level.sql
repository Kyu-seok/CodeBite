-- V571: nth-unlockable-level restated, title unchanged. The first sentence now states the
-- task, the English says a level number is a positive integer (the Korean already did), and
-- Example 3 (sample 3) shows that 1 is the first unlockable level. Starter method
-- nthSmoothBatch -> nthUnlockableLevel in all 4 Starter Codes and Drivers. Examples match the
-- sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Return the `n`-th unlockable level (1-indexed). A level is **unlockable** when its number is a positive integer whose only prime factors are `2`, `3` and `5`; `1`, which has no prime factors, is unlockable too. In order, the unlockable levels are `1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, ...` (`7` is skipped).

**Example 1:**
```
Input: n = 7
Output: 8
Explanation: The first seven unlockable levels are 1, 2, 3, 4, 5, 6, 8, so the 7th is 8.
```

**Example 2:**
```
Input: n = 12
Output: 16
Explanation: The first twelve unlockable levels are 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, so the 12th is 16.
```

**Example 3:**
```
Input: n = 1
Output: 1
Explanation: 1 is the first unlockable level.
```$$
WHERE slug = $$nth-unlockable-level$$;

UPDATE problem_translations SET
    description = $$`n`번째(1-인덱스) 해금 가능 레벨을 반환하세요. 레벨 번호가 소인수로 `2`, `3`, `5`만 가지는 양의 정수이면 그 레벨은 **해금 가능**합니다. 소인수가 없는 `1`도 해금 가능합니다. 해금 가능한 레벨을 작은 순서대로 늘어놓으면 `1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, ...`이 됩니다(`7`은 빠집니다).

**예시 1:**
```
입력: n = 7
출력: 8
설명: 처음 일곱 개의 해금 가능 레벨은 1, 2, 3, 4, 5, 6, 8이므로 7번째는 8입니다.
```

**예시 2:**
```
입력: n = 12
출력: 16
설명: 처음 열두 개의 해금 가능 레벨은 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16이므로 12번째는 16입니다.
```

**예시 3:**
```
입력: n = 1
출력: 1
설명: 첫 번째 해금 가능 레벨은 1입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$nth-unlockable-level$$);
