-- V247: restate merge-duplicate-contacts (#192, part of #168). The Korean constraints put `j >
-- 0` before `accounts[i][j]`, so the two languages' code spans ran in different orders; the
-- Korean bullets keep their prose and carry the English constraints' code spans exactly. Only
-- the Korean constraints change; Slug, title, description, English text, Test Cases, Starter
-- Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= accounts.length <= 1500`
- `2 <= accounts[i].length <= 10`
- `1 <= accounts[i][j].length <= 30`
- `accounts[i][0]`은 영문자로 구성됩니다.
- `accounts[i][j]`는 `j > 0`일 때 유효한 이메일 주소입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$merge-duplicate-contacts$$);
