-- V265: restate trending-chat-topics (#192, part of #168). The English span `[1, number of
-- distinct topics]` embedded prose no translation can carry, so the bound on `k` is reworded
-- in both languages with the same spans; the Korean bullets keep their prose and carry the
-- English constraints' code spans exactly. Only the constraints change, English and Korean;
-- Slug, title, description, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problems SET
    constraints = $$- `1 <= topics.length <= 2 * 10^3`
- `1 <= topics[i].length <= 10`
- `topics[i]` consists of lowercase English letters
- `k` is at least `1` and at most the number of distinct strings in `topics`
- The answer is guaranteed to be unique$$
WHERE slug = $$trending-chat-topics$$;

UPDATE problem_translations SET
    constraints = $$- `1 <= topics.length <= 2 * 10^3`
- `1 <= topics[i].length <= 10`
- `topics[i]`는 영어 소문자로만 이루어져 있습니다.
- `k`는 `1` 이상, `topics`의 서로 다른 문자열 개수 이하입니다.
- 정답은 유일함이 보장됩니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$trending-chat-topics$$);
