-- V231: restate drop-nth-reservation (#192, part of #168). The Korean constraints named
-- `Node.val` where the English constraints name `Booking.val`; the Korean bullets keep their
-- prose and carry the English constraints' code spans exactly. Only the Korean constraints
-- change; Slug, title, description, English text, Test Cases, Starter Code and Drivers are
-- unchanged.

UPDATE problem_translations SET
    constraints = $$- 리스트의 예약 개수는 `sz`입니다.
- `1 <= sz <= 40`
- `0 <= Booking.val <= 100`
- `1 <= n <= sz`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$drop-nth-reservation$$);
