-- V241: restate kth-top-score-stream (#192, part of #168). The Korean constraints kept
-- LeetCode's bounds where the English state CodeBite's (`10^4` for `8000`, `|scores[i]|` and
-- `|val|` within `10^4` for `10^8`); the Korean bullets keep their prose and carry the English
-- constraints' code spans exactly. Only the Korean constraints change; Slug, title,
-- description, English text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= k <= 8000`
- `0 <= scores.length <= 8000`
- `-10^8 <= scores[i] <= 10^8`
- `-10^8 <= val <= 10^8`
- 최대 `8000`번까지 `record`가 호출됩니다.
- `record`가 호출될 때 합쳐진 스트림에는 적어도 `k`개의 점수가 들어 있도록 보장됩니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$kth-top-score-stream$$);
