-- V200: the Tutorial Problem (docs/adr/0007), Piggy Bank Total, numbered 0.
-- Published, with no tags and no roadmap category: it belongs to no curation and
-- is never recommended. Every test case is a plain a + b with no traps; inputs stay
-- small so no language overflows. Drivers and Starter Code are filed under
-- drivers/piggy-bank-total/ and starters/piggy-bank-total/.

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    $$Piggy Bank Total$$,
    $$piggy-bank-total$$,
    $$You have two piggy banks. The first holds `firstBank` coins and the second holds `secondBank` coins. Return the total number of coins in both banks.

**Example 1:**
```
Input: firstBank = 3, secondBank = 5
Output: 8
Explanation: 3 + 5 = 8.
```

**Example 2:**
```
Input: firstBank = 10, secondBank = 0
Output: 10
Explanation: An empty bank adds nothing.
```$$,
    'EASY',
    $$- `0 <= firstBank <= 1000`
- `0 <= secondBank <= 1000`$$,
    0,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
SELECT p.id, t.input, t.expected, t.sample, t.ord
FROM problems p, (VALUES
    ($$3
5$$, '8', TRUE, 1),
    ($$10
0$$, '10', TRUE, 2),
    ($$0
0$$, '0', FALSE, 3),
    ($$7
7$$, '14', FALSE, 4),
    ($$1
999$$, '1000', FALSE, 5),
    ($$123
456$$, '579', FALSE, 6),
    ($$1000
1000$$, '2000', FALSE, 7)
) AS t(input, expected, sample, ord)
WHERE p.slug = $$piggy-bank-total$$;

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT p.id, 'en', p.title, p.description, p.constraints
FROM problems p
WHERE p.slug = $$piggy-bank-total$$;

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$piggy-bank-total$$),
    'ko',
    $$저금통 합계$$,
    $$저금통이 두 개 있습니다. 첫 번째 저금통에는 동전이 `firstBank`개, 두 번째 저금통에는 `secondBank`개 들어 있습니다. 두 저금통에 든 동전의 총 개수를 반환하세요.

**예시 1:**
```
입력: firstBank = 3, secondBank = 5
출력: 8
설명: 3 + 5 = 8 입니다.
```

**예시 2:**
```
입력: firstBank = 10, secondBank = 0
출력: 10
설명: 빈 저금통은 아무것도 더하지 않습니다.
```$$,
    $$- `0 <= firstBank <= 1000`
- `0 <= secondBank <= 1000`$$
);
