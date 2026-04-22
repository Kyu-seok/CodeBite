-- V130: Refresh Korean translation for the Phase 2 pilot (shelf-stock-pair).
--
-- V123 rewrote the English description + constraints + sample test cases for
-- shelf-stock-pair (formerly pair-sum). V126 rebounded its constraints. The
-- stale ko row inserted by V77 still references the pair-sum canonical
-- [2,7,11,15] sample, so replace it with a matching shelf-stock-pair
-- translation.

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = 'shelf-stock-pair');

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'shelf-stock-pair'),
    'ko',
    $KO$선반 재고 짝 찾기$KO$,
    $KO$창고 재고 시스템은 각 선반에 놓인 부품 수를 배열 `nums`로 관리합니다. 정확히 `target`개의 부품을 요구하는 재보충 요청이 들어오면, 피커는 합이 요청량과 같아지는 **서로 다른 두 선반**을 조합해야 합니다.

부품 수 합이 `target`이 되는 두 선반의 인덱스를 반환하세요. 각 요청은 유효한 짝이 정확히 하나 존재함이 보장되며, 같은 선반에서 두 번 뽑을 수는 없습니다. 두 인덱스는 어떤 순서로 반환해도 됩니다.

**예시 1:**
```
Input: nums = [4, 11, 19, 23], target = 30
Output: [1, 2]
Explanation: nums[1] + nums[2] = 11 + 19 = 30.
```

**예시 2:**
```
Input: nums = [8, 14, 6], target = 14
Output: [0, 2]
Explanation: nums[0] + nums[2] = 8 + 6 = 14.
```$KO$,
    $KO$- `2 <= nums.length <= 80000`
- `-10^8 <= nums[i] <= 10^8`
- `-10^8 <= target <= 10^8`
- 요청을 충족하는 선반 짝이 정확히 하나 존재합니다.$KO$
);
