-- V308: restate longest-genre-window. Example 1 showed feed = "finance", a real word, which
-- reads as one genre rather than seven single-letter tags. Sample 1 is now the case that was
-- hidden at order_index 10, "tmmzuxt" (5), and "finance" (4) takes its place among the hidden
-- cases: the two rows swap is_sample and order_index, so every input and expected output stays,
-- and past submission_results keep pointing at the rows they graded. The description now says
-- outright that each character is one episode's tag and defines a window; Example 1 shows the new
-- sample. Constraints, Slug, title, Starter Code and Drivers are unchanged.

UPDATE test_cases SET is_sample = FALSE, order_index = 10
WHERE problem_id = (SELECT id FROM problems WHERE slug = $$longest-genre-window$$)
  AND is_sample = TRUE AND order_index = 1 AND input = $$finance$$;

UPDATE test_cases SET is_sample = TRUE, order_index = 1
WHERE problem_id = (SELECT id FROM problems WHERE slug = $$longest-genre-window$$)
  AND is_sample = FALSE AND order_index = 10 AND input = $$tmmzuxt$$;

UPDATE problems SET
    description = $$A watch queue is given as the string `feed`. Each character is the genre tag of one episode, in viewing order, so `feed` is a sequence of single-letter tags rather than a word. A **window** is a run of consecutive episodes. Return the length of the longest window in which no genre tag appears twice.

**Example 1:**
```
Input: feed = "tmmzuxt"
Output: 5
Explanation: The tags are t, m, m, z, u, x, t. The window "mzuxt" (episodes 3 to 7) has five different tags. Both windows of six episodes contain two "m"s, so no window is longer.
```

**Example 2:**
```
Input: feed = "zzzz"
Output: 1
Explanation: All four episodes have the tag "z", so any window of two or more episodes repeats it.
```

**Example 3:**
```
Input: feed = "xxxyz"
Output: 3
Explanation: The last three tags, "x", "y" and "z", are all different. Any longer window contains two "x"s.
```$$
WHERE slug = $$longest-genre-window$$;

UPDATE problem_translations SET
    description = $$시청 대기열이 문자열 `feed`로 주어집니다. 각 문자는 시청 순서대로 놓인 에피소드 하나의 장르 태그이므로, `feed`는 단어가 아니라 한 글자짜리 태그들의 나열입니다. **구간**은 연속으로 이어진 에피소드들을 말합니다. 같은 장르 태그가 두 번 나오지 않는 구간 중 가장 긴 구간의 길이를 반환하세요.

**예시 1:**
```
입력: feed = "tmmzuxt"
출력: 5
설명: 태그는 t, m, m, z, u, x, t 순서입니다. 구간 "mzuxt"(3번째부터 7번째 에피소드)는 서로 다른 태그 다섯 개로 이루어져 있습니다. 에피소드 여섯 개짜리 구간은 둘 다 "m"이 두 번 들어가므로, 이보다 긴 구간은 없습니다.
```

**예시 2:**
```
입력: feed = "zzzz"
출력: 1
설명: 네 에피소드 모두 태그가 "z"이므로, 에피소드가 두 개 이상인 구간에는 항상 같은 태그가 반복됩니다.
```

**예시 3:**
```
입력: feed = "xxxyz"
출력: 3
설명: 마지막 세 태그 "x", "y", "z"는 모두 다릅니다. 이보다 긴 구간에는 "x"가 두 번 들어갑니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-genre-window$$);
