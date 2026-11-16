-- V585: drop-nth-reservation, text only. The constraints named a `Booking` type the Starter
-- Code doesn't have; its node class is `ListNode` (statement cold-read, #350).

UPDATE problems SET
    constraints = $$- The number of bookings in the list is `sz`.
- `1 <= sz <= 40`
- `0 <= ListNode.val <= 100`
- `1 <= n <= sz`$$
WHERE slug = $$drop-nth-reservation$$;

UPDATE problem_translations SET
    constraints = $$- 리스트의 예약 개수는 `sz`입니다.
- `1 <= sz <= 40`
- `0 <= ListNode.val <= 100`
- `1 <= n <= sz`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$drop-nth-reservation$$);
