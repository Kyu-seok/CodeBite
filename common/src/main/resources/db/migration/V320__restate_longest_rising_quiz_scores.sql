-- V320: longest-quiz-streak -> longest-rising-quiz-scores, retitled "Longest Rising Quiz
-- Scores". "Streak" read as consecutive quizzes, but the task is a subsequence that may skip
-- quizzes; the statement now says what a subsequence is, that equal scores don't rise, and
-- explains sample 3 ([5,5,5,5] -> 1) as Example 3.
-- Starter method longestBrightRun(scores) -> longestRisingScores(scores). Drivers and Starter
-- Code directories are renamed in the same commit. Examples match the sample test cases,
-- which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$longest-quiz-streak$$, id FROM problems WHERE slug = $$longest-quiz-streak$$;

UPDATE problems SET
    slug = $$longest-rising-quiz-scores$$,
    title = $$Longest Rising Quiz Scores$$,
    description = $$Given your quiz scores in the order you took them as the integer array `scores`, return the length of the longest strictly increasing subsequence of `scores`.

A subsequence keeps some of the scores in their original order and skips the rest, so the quizzes you pick need not be next to each other. Strictly increasing means every picked score is greater than the one picked before it: equal scores do not rise.

**Example 1:**
```
Input: scores = [4,10,2,6,3,5,8,11]
Output: 5
Explanation: Skipping 4, 10 and 6 leaves [2,3,5,8,11] (indices 2, 4, 5, 6 and 7), which rises at every step. No rising subsequence of length 6 exists.
```

**Example 2:**
```
Input: scores = [9,2,7,4,6,8]
Output: 4
Explanation: [2,4,6,8] rises and has length 4. No rising subsequence of length 5 exists.
```

**Example 3:**
```
Input: scores = [5,5,5,5]
Output: 1
Explanation: Equal scores do not rise, so the longest rising subsequence is a single score.
```$$,
    constraints = $$- `1 <= scores.length <= 2000`
- `-5000 <= scores[i] <= 5000`$$
WHERE slug = $$longest-quiz-streak$$;

UPDATE problem_translations SET
    title = $$가장 긴 상승 퀴즈 점수$$,
    description = $$퀴즈를 본 순서대로 점수를 담은 정수 배열 `scores`가 주어질 때, `scores`에서 엄격하게 증가하는 가장 긴 부분수열의 길이를 반환하세요.

부분수열은 점수 일부를 원래 순서대로 고르고 나머지는 건너뛴 것이므로, 고른 퀴즈가 서로 붙어 있을 필요는 없습니다. 엄격하게 증가한다는 것은 고른 점수가 바로 앞에 고른 점수보다 항상 크다는 뜻입니다. 같은 점수는 증가로 보지 않습니다.

**예시 1:**
```
입력: scores = [4,10,2,6,3,5,8,11]
출력: 5
설명: 4, 10, 6을 건너뛰면 [2,3,5,8,11](인덱스 2, 4, 5, 6, 7)이 남고, 매 단계 증가합니다. 길이 6인 증가 부분수열은 없습니다.
```

**예시 2:**
```
입력: scores = [9,2,7,4,6,8]
출력: 4
설명: [2,4,6,8]은 증가하며 길이가 4입니다. 길이 5인 증가 부분수열은 없습니다.
```

**예시 3:**
```
입력: scores = [5,5,5,5]
출력: 1
설명: 같은 점수는 증가로 보지 않으므로, 가장 긴 증가 부분수열은 점수 하나입니다.
```$$,
    constraints = $$- `1 <= scores.length <= 2000`
- `-5000 <= scores[i] <= 5000`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-rising-quiz-scores$$);
