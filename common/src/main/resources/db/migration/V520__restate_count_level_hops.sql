-- V520: count-level-hops restated, Slug and title unchanged. The method was named
-- countReservoirPaths, left over from another theme: renamed countHopSequences in the
-- Starter Code and Drivers. A hidden case has n = 45 while the constraint said n <= 40:
-- the bound is now 45 (the answer still fits an int). Example 2 lists its sequences.
-- Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$In a platformer, your character starts at level `0` and wants to reach level `n`. Each jump moves forward either 1 or 2 levels.

Implement `countHopSequences(n)` to return the number of distinct jump sequences that land exactly on level `n`.

**Example 1:**
```
Input: n = 4
Output: 5
Explanation: The valid sequences are 1+1+1+1, 1+1+2, 1+2+1, 2+1+1, and 2+2.
```

**Example 2:**
```
Input: n = 5
Output: 8
Explanation: 1+1+1+1+1 is one sequence, three 1s and one 2 can be ordered 4 ways, and one 1 and two 2s 3 ways: 1 + 4 + 3 = 8.
```$$,
    constraints = $$- `1 <= n <= 45`$$
WHERE slug = $$count-level-hops$$;

UPDATE problem_translations SET
    description = $$플랫포머 게임에서 캐릭터는 레벨 `0`에 서 있고 목표 레벨 정수 `n`까지 가야 합니다. 한 번의 점프로 1레벨 또는 2레벨 앞으로 나아갈 수 있어요.

레벨 `n`에 정확히 도착하는 서로 다른 점프 순서의 개수를 반환하는 `countHopSequences(n)`을 구현하세요.

**예시 1:**
```
입력: n = 4
출력: 5
설명: 합이 4가 되는 1·2 점프 순서는 `1+1+1+1`, `1+1+2`, `1+2+1`, `2+1+1`, `2+2`로 모두 다섯 가지입니다.
```

**예시 2:**
```
입력: n = 5
출력: 8
설명: `1+1+1+1+1`이 한 가지, 1 세 번과 2 한 번을 늘어놓는 순서가 네 가지, 1 한 번과 2 두 번을 늘어놓는 순서가 세 가지라서 1 + 4 + 3 = 8입니다.
```$$,
    constraints = $$- `1 <= n <= 45`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-level-hops$$);
