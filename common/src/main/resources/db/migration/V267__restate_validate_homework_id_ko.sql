-- V267: restate validate-homework-id (#192, part of #168). The Korean constraints put `p`
-- before the first `*`, so the two languages' code spans ran in different orders; the Korean
-- bullets keep their prose and carry the English constraints' code spans exactly. Only the
-- Korean constraints change; Slug, title, description, English text, Test Cases, Starter Code
-- and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= s.length <= 24`
- `1 <= p.length <= 24`
- `s`는 영어 소문자로 이루어져 있습니다.
- `p`는 영어 소문자와 `.`, `*`로 이루어져 있습니다.
- 모든 `*`는 `p` 안에서 앞에 유효한 문자가 하나 있습니다(맨 앞에 `*`가 올 수 없고, `*`가 연달아 두 번 오지도 않습니다).$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$validate-homework-id$$);
