-- V262: restate timestamp-value-store (#192, part of #168). The Korean constraints had a
-- bullet on the characters of `key` and `value` the English lack, and set `timestamp` in
-- backticks where the English don't; the Korean bullets keep their prose and carry the English
-- constraints' code spans exactly. Only the Korean constraints change; Slug, title,
-- description, English text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= key.length, value.length <= 100`
- `1 <= timestamp <= 10^7`
- `write`에 전달되는 timestamp는 같은 `key`에 대해 엄격히 증가합니다.
- `write`와 `readAt` 호출은 합쳐서 최대 `2 * 10^5`번입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$timestamp-value-store$$);
