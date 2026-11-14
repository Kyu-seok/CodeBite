-- V572: count-hint-matches restated, title unchanged. The hint is no longer called "short"
-- (target may be up to 900 letters), the statement says a target longer than notes gives 0,
-- and Example 3 (sample 3) shows overlapping matches. Starter method countFilterMatches ->
-- countHintMatches in all 4 Starter Codes and Drivers. Examples match the sample test cases,
-- which are unchanged.

UPDATE problems SET
    description = $$Given lecture `notes` and a hint `target`, return how many times `target` appears in `notes` as a subsequence. A subsequence picks letters from `notes` in order, skipping any you like. Different choices of positions count separately, even if the kept letters look the same. When `target` is longer than `notes`, the answer is `0`.

The answer fits in a 64-bit signed integer.

**Example 1:**
```
Input: notes = "ggrrg", target = "grg"
Output: 4
Explanation: Each match picks a g, then a later r, then a later g. Among the g positions (0, 1, 4) and r positions (2, 3), the valid (i, j, k) triples are (0,2,4), (0,3,4), (1,2,4), (1,3,4).
```

**Example 2:**
```
Input: notes = "uvuvu", target = "uu"
Output: 3
Explanation: The u positions are 0, 2, and 4, and choosing any ordered pair gives a match: (0,2), (0,4), (2,4).
```

**Example 3:**
```
Input: notes = "xxxx", target = "xx"
Output: 6
Explanation: Any two of the four x positions make a match: (0,1), (0,2), (0,3), (1,2), (1,3), (2,3).
```$$
WHERE slug = $$count-hint-matches$$;

UPDATE problem_translations SET
    description = $$강의 노트 문자열 `notes`와 힌트 문자열 `target`이 주어질 때, `notes` 안에서 `target`이 부분수열로 등장하는 횟수를 반환하세요. 부분수열은 `notes`에서 글자를 순서대로 골라 만들되 원하는 글자는 건너뛸 수 있고, 고른 글자가 같아 보여도 위치가 다르면 서로 다른 매칭으로 칩니다. `target`이 `notes`보다 길면 답은 `0`입니다.

답은 64비트 부호 있는 정수 범위 안에 들어갑니다.

**예시 1:**
```
입력: notes = "ggrrg", target = "grg"
출력: 4
설명: 매칭마다 g 하나, 그 뒤의 r 하나, 다시 그 뒤의 g 하나를 골라야 합니다. g 위치 (0, 1, 4)와 r 위치 (2, 3) 중에서 유효한 (i, j, k) 세 쌍은 (0,2,4), (0,3,4), (1,2,4), (1,3,4) 입니다.
```

**예시 2:**
```
입력: notes = "uvuvu", target = "uu"
출력: 3
설명: u의 위치는 0, 2, 4입니다. 두 자리를 순서대로 고르는 경우 (0,2), (0,4), (2,4) 모두 매칭이 됩니다.
```

**예시 3:**
```
입력: notes = "xxxx", target = "xx"
출력: 6
설명: 네 개의 x 위치 중 아무 두 자리를 고르면 매칭이 됩니다: (0,1), (0,2), (0,3), (1,2), (1,3), (2,3).
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-hint-matches$$);
