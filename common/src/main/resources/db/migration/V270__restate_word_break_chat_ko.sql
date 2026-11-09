-- V270: restate word-break-chat (#192, part of #168). The Korean constraints kept LeetCode's
-- bounds where the English state CodeBite's (`headline.length <= 300` for `400`,
-- `topics.length <= 1000` for `1500`, `topics[i].length <= 20` for `25`); the Korean bullets
-- keep their prose and carry the English constraints' code spans exactly. Only the Korean
-- constraints change; Slug, title, description, English text, Test Cases, Starter Code and
-- Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= headline.length <= 400`
- `1 <= topics.length <= 1500`
- `1 <= topics[i].length <= 25`
- `headline`과 `topics[i]`는 영어 소문자로만 이루어져 있습니다.
- `topics`의 모든 문자열은 서로 다릅니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$word-break-chat$$);
