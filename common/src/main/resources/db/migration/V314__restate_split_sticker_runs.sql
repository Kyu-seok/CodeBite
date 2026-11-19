-- V314: split-sticker-runs restated. "Into the fewest consecutive chunks" was wrong
-- in both languages: the fewest is always one, and the cases ("abcdef" ->
-- [1,1,1,1,1,1]) want as many as possible. Both languages now ask for the most runs,
-- call the pieces runs as the title does, and explain sample 3 as Example 3. Starter
-- method splitZoneRuns -> splitStickerRuns. Examples match the sample test cases,
-- which are unchanged.

UPDATE problems SET
    description = $$Split the string `stickers` into as many consecutive runs as possible so that each letter appears in only one run, and return the length of each run from left to right.

Joined in order, the runs give back `stickers`. A letter may appear several times, but all of its appearances must fall in the same run.

**Example 1:**
```
Input: stickers = "abacbcd"
Output: [6,1]
Explanation: 'a', 'b' and 'c' last appear by index 5, so the first run must reach index 5: "abacbc", 6 stickers. 'd' appears only at index 6 and makes a run of its own.
```

**Example 2:**
```
Input: stickers = "rsrsr"
Output: [5]
Explanation: 'r' appears at both ends, so every sticker falls in one run.
```

**Example 3:**
```
Input: stickers = "abcdef"
Output: [1,1,1,1,1,1]
Explanation: Every letter appears once, so each sticker is a run of its own: 6 runs of length 1.
```$$
WHERE slug = $$split-sticker-runs$$;

UPDATE problem_translations SET
    description = $$문자열 `stickers`를 각 글자가 한 구간에만 나타나도록 연속된 구간으로 나누되, 구간의 수가 최대한 많도록 나누고, 왼쪽부터 각 구간의 길이를 반환하세요.

구간들을 순서대로 이으면 원래의 `stickers`가 됩니다. 같은 글자가 여러 번 나타날 수 있지만, 그 글자가 나타나는 모든 위치는 같은 구간 안에 있어야 합니다.

**예시 1:**
```
입력: stickers = "abacbcd"
출력: [6,1]
설명: 'a', 'b', 'c'가 마지막으로 나타나는 위치는 모두 인덱스 5 이하이므로 첫 구간은 인덱스 5까지인 "abacbc", 스티커 6장이어야 합니다. 'd'는 인덱스 6에만 나타나므로 혼자 한 구간이 됩니다.
```

**예시 2:**
```
입력: stickers = "rsrsr"
출력: [5]
설명: 'r'이 양 끝에 모두 나타나므로 모든 스티커가 한 구간에 들어갑니다.
```

**예시 3:**
```
입력: stickers = "abcdef"
출력: [1,1,1,1,1,1]
설명: 모든 글자가 한 번씩만 나타나므로 스티커 하나하나가 각각 한 구간이 됩니다: 길이 1인 구간 6개입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$split-sticker-runs$$);
