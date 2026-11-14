-- V323: unique-genre-window -> longest-window-with-at-most-k-genres, retitled "Longest Window
-- With At Most K Genres". "Unique" suggested a window of all-distinct tags (that is
-- longest-genre-window); the task allows up to k distinct genres. The statement now defines a
-- window and explains sample 3 ("qwerty", k = 1 -> 1) as Example 3.
-- Starter method countUniqueTopics / k_distinct_window (Python) -> longestKGenreWindow(queue, k).
-- Drivers, Starter Code and the Walkthrough are renamed in the same commit, and the Walkthrough
-- regenerated. Examples match the sample test cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$unique-genre-window$$, id FROM problems WHERE slug = $$unique-genre-window$$;

UPDATE problems SET
    slug = $$longest-window-with-at-most-k-genres$$,
    title = $$Longest Window With At Most K Genres$$,
    description = $$A watch queue is given as the string `queue`: each letter is the genre tag of one episode, in viewing order. A **window** is a run of consecutive episodes. Return the length of the longest window that contains at most `k` distinct genres. If `k` is `0`, no episode fits, so return `0`.

**Example 1:**
```
Input: queue = "yyxzxxz", k = 2
Output: 5
Explanation: The window "xzxxz" (indices 2 to 6) holds only the genres x and z. Every window of length 6 also holds a y, a third genre.
```

**Example 2:**
```
Input: queue = "rrrrrr", k = 1
Output: 6
Explanation: Every episode is genre r, so the whole queue is one window with one genre.
```

**Example 3:**
```
Input: queue = "qwerty", k = 1
Output: 1
Explanation: No two episodes share a genre, so a window with one genre holds one episode.
```$$,
    constraints = $$- `1 <= queue.length <= 8 * 10^4`
- `0 <= k <= 50`
- `queue` consists of lowercase English letters.$$
WHERE slug = $$unique-genre-window$$;

UPDATE problem_translations SET
    title = $$장르가 최대 K개인 가장 긴 구간$$,
    description = $$재생 큐가 문자열 `queue`로 주어집니다. 각 글자는 에피소드 하나의 장르 태그이며, 보는 순서대로 놓여 있습니다. **구간**은 연속한 에피소드들의 묶음입니다. 서로 다른 장르가 최대 `k`개 들어 있는 가장 긴 구간의 길이를 반환하세요. `k`가 `0`이면 어떤 에피소드도 들어갈 수 없으므로 `0`을 반환합니다.

**예시 1:**
```
입력: queue = "yyxzxxz", k = 2
출력: 5
설명: 구간 "xzxxz"(인덱스 2부터 6까지)에는 장르 x와 z만 있습니다. 길이 6인 구간에는 모두 세 번째 장르인 y가 들어 있습니다.
```

**예시 2:**
```
입력: queue = "rrrrrr", k = 1
출력: 6
설명: 모든 에피소드가 장르 r이므로, 큐 전체가 장르 하나뿐인 구간입니다.
```

**예시 3:**
```
입력: queue = "qwerty", k = 1
출력: 1
설명: 같은 장르인 에피소드가 없으므로, 장르가 하나뿐인 구간에는 에피소드가 하나만 들어갑니다.
```$$,
    constraints = $$- `1 <= queue.length <= 8 * 10^4`
- `0 <= k <= 50`
- `queue`는 영어 소문자로만 이루어져 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-window-with-at-most-k-genres$$);
