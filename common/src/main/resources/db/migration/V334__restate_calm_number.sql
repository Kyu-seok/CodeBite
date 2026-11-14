-- V334: calm-phone-number -> calm-number, retitled "Calm Number". The title named a
-- phone number the statement never uses. Starter method isCalmReading (is_joyful in
-- Python) -> isCalm, parameter n -> reading, the statement's words. Drivers and Starter
-- Code directories are renamed in the same commit. Examples match the sample test cases,
-- which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$calm-phone-number$$, id FROM problems WHERE slug = $$calm-phone-number$$;

UPDATE problems SET
    slug = $$calm-number$$,
    title = $$Calm Number$$,
    description = $$Given a positive integer `reading`, return `true` if it is **calm**, and `false` otherwise.

To test a number, repeatedly replace it with the sum of the squares of its digits. The number is calm if this process reaches `1`, and not calm if it instead loops forever through numbers other than `1`.

**Example 1:**
```
Input: reading = 7
Output: true
Explanation: 7 -> 49 -> 97 -> 130 -> 10 -> 1. For example, 49 becomes 4² + 9² = 97.
```

**Example 2:**
```
Input: reading = 4
Output: false
Explanation: 4 -> 16 -> 37 -> 58 -> 89 -> 145 -> 42 -> 20 -> 4, a loop that never reaches 1.
```$$,
    constraints = $$- `1 <= reading <= 2 * 10^8`$$
WHERE slug = $$calm-phone-number$$;

UPDATE problem_translations SET
    title = $$평온한 수$$,
    description = $$양의 정수 `reading`이 주어질 때, 이 수가 **평온하면** `true`, 아니면 `false`를 반환하세요.

수를 판정하려면, 그 수를 각 자리 숫자의 제곱 합으로 계속 바꿉니다. 이 과정이 `1`에 도달하면 평온한 수이고, `1`에 도달하지 못한 채 영원히 순환하면 평온하지 않은 수입니다.

**예시 1:**
```
입력: reading = 7
출력: true
설명: 7 -> 49 -> 97 -> 130 -> 10 -> 1. 예를 들어 49는 4² + 9² = 97이 됩니다.
```

**예시 2:**
```
입력: reading = 4
출력: false
설명: 4 -> 16 -> 37 -> 58 -> 89 -> 145 -> 42 -> 20 -> 4로 순환하며 1에 도달하지 못합니다.
```$$,
    constraints = $$- `1 <= reading <= 2 * 10^8`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$calm-number$$);
