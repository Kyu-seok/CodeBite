-- V550: majority-boss-vote -> majority-vote, retitled "Majority Vote" ("과반 득표 찾기"). "Boss" was
-- never explained and "Return that id" named ids the statement never introduced: the statement now
-- asks for the value that appears more than n / 2 times. Starter method majorityHeadline ->
-- majorityVote in all 4 Starter Codes and Drivers. Drivers and Starter Code directories and the
-- Walkthrough are renamed in the same commit. Examples match the sample test cases, which are
-- unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$majority-boss-vote$$, id FROM problems WHERE slug = $$majority-boss-vote$$;

UPDATE problems SET
    slug = $$majority-vote$$,
    title = $$Majority Vote$$,
    description = $$Given an array `votes` of `n` votes, return the value that appears more than `n / 2` times. Such a value always exists.

**Example 1:**
```
Input: votes = [4,7,4]
Output: 4
Explanation: 4 appears 2 times out of 3, which is more than half.
```

**Example 2:**
```
Input: votes = [5,5,6,6,6,5,6]
Output: 6
Explanation: 6 appears 4 times out of 7, which is more than half.
```

**Example 3:**
```
Input: votes = [9]
Output: 9
Explanation: A single vote is a majority on its own.
```$$,
    constraints = $$- `1 <= votes.length <= 2 * 10^5`
- `-10^8 <= votes[i] <= 10^8`
- One value appears more than `votes.length / 2` times.$$
WHERE slug = $$majority-boss-vote$$;

UPDATE problem_translations SET
    title = $$과반 득표 찾기$$,
    description = $$`n`개의 표가 담긴 배열 `votes`가 주어질 때, `n / 2`번보다 많이 등장하는 값을 반환하세요. 그런 값은 항상 존재합니다.

**예시 1:**
```
입력: votes = [4,7,4]
출력: 4
설명: 4는 3표 중 2번 등장하며, 이는 절반보다 많습니다.
```

**예시 2:**
```
입력: votes = [5,5,6,6,6,5,6]
출력: 6
설명: 6은 7표 중 4번 등장하며, 이는 절반보다 많습니다.
```

**예시 3:**
```
입력: votes = [9]
출력: 9
설명: 표가 하나뿐이면 그 표 하나가 과반입니다.
```$$,
    constraints = $$- `1 <= votes.length <= 2 * 10^5`
- `-10^8 <= votes[i] <= 10^8`
- 한 값이 `votes.length / 2`번보다 많이 등장합니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$majority-vote$$);
