-- V307: restate longest-genre-window. The Netflix framing gives way to a plain
-- watch queue, and the constraints now describe the Test Cases: every case has at
-- least one tag (the Drivers cannot read an empty line) and only lowercase letters
-- (the Drivers trim the line, so spaces were never readable). The method is renamed
-- from longestFreshFeed to longestGenreWindow to match the title; the parameter
-- `feed` stays. Slug and title are unchanged. Examples match the sample test cases,
-- which are unchanged.

UPDATE problems SET
    description = $$A watch queue is given as the string `feed`, where each character is the genre tag of one episode, in viewing order. Return the length of the longest window of consecutive episodes in which no genre tag appears twice.

**Example 1:**
```
Input: feed = "finance"
Output: 4
Explanation: "fina" and "ance" each have four distinct tags; every window of five tags repeats "n".
```

**Example 2:**
```
Input: feed = "zzzz"
Output: 1
Explanation: Every tag is the same, so a window holds only one episode.
```

**Example 3:**
```
Input: feed = "xxxyz"
Output: 3
Explanation: The last three tags, "xyz", are distinct; any longer window includes two "x"s.
```$$,
    constraints = $$- `1 <= feed.length <= 8 * 10^4`
- `feed` consists of lowercase English letters.$$
WHERE slug = $$longest-genre-window$$;

UPDATE problem_translations SET
    description = $$시청 대기열이 문자열 `feed`로 주어집니다. 각 문자는 시청 순서대로 놓인 에피소드 하나의 장르 태그입니다. 같은 장르 태그가 두 번 나오지 않는, 연속된 에피소드 구간 중 가장 긴 구간의 길이를 반환하세요.

**예시 1:**
```
입력: feed = "finance"
출력: 4
설명: "fina"와 "ance"는 각각 서로 다른 태그 네 개로 이루어져 있고, 길이 5인 구간에는 모두 "n"이 두 번 들어갑니다.
```

**예시 2:**
```
입력: feed = "zzzz"
출력: 1
설명: 모든 태그가 같으므로 한 구간에는 에피소드 하나만 들어갈 수 있습니다.
```

**예시 3:**
```
입력: feed = "xxxyz"
출력: 3
설명: 마지막 세 태그 "xyz"는 서로 다르고, 이보다 긴 구간에는 "x"가 두 번 들어갑니다.
```$$,
    constraints = $$- `1 <= feed.length <= 8 * 10^4`
- `feed`는 영어 소문자로만 이루어져 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-genre-window$$);
