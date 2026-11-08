-- V250: restate micro-feed (#192, part of #168). The Korean constraints listed the methods
-- before their combined call limit, so the two languages' code spans ran in different orders;
-- the Korean bullets keep their prose and carry the English constraints' code spans exactly.
-- Only the Korean constraints change; Slug, title, description, English text, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= userId, followerId, followeeId <= 500`
- `0 <= messageId <= 8000`
- 합쳐서 최대 `20000`번까지 `publishPost`, `latestFeed`, `subscribe`, `unsubscribe`가 호출됩니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$micro-feed$$);
