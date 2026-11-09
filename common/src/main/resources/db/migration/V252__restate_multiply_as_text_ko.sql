-- V252: restate multiply-as-text (#192, part of #168). The Korean constraints put the value
-- `0` before `left` and `right`, so the two languages' code spans ran in different orders; the
-- Korean bullets keep their prose and carry the English constraints' code spans exactly. Only
-- the Korean constraints change; Slug, title, description, English text, Test Cases, Starter
-- Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= left.length, right.length <= 200`
- `left`와 `right`는 십진 숫자만으로 이루어집니다.
- `left`와 `right` 모두 값이 `0`인 경우를 제외하면 앞자리에 0이 오지 않습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$multiply-as-text$$);
