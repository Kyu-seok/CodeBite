-- V422: balance-print-queue -> balance-brackets-with-wildcards, retitled "Balance Brackets
-- with Wildcards". The print-queue story made the reader map batches back to brackets, and
-- "every opener matches a later closer" left out that every `)` needs an earlier `(` (sample
-- 3, ")(", is false). Now stated as brackets, sample 3 is Example 3. Starter method
-- canBalanceJobs -> canBalance, parameter tags -> brackets, in all 4 Starter Codes and
-- Drivers, whose directories are renamed in the same commit. Examples match the sample test
-- cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$balance-print-queue$$, id FROM problems WHERE slug = $$balance-print-queue$$;

UPDATE problems SET
    slug = $$balance-brackets-with-wildcards$$,
    title = $$Balance Brackets with Wildcards$$,
    description = $$You are given a string `brackets` of `(`, `)` and `*`. Each `*` is a wildcard: you may turn it into `(`, into `)`, or remove it.

Return `true` if some choice for the wildcards makes `brackets` balanced, and `false` otherwise. A string is balanced when every `(` is closed by a `)` later in the string and every `)` closes a `(` earlier in the string. A string left empty after removing wildcards is balanced.

**Example 1:**
```
Input: brackets = "((*)"
Output: true
Explanation: Turning the * into ) gives "(())", which is balanced.
```

**Example 2:**
```
Input: brackets = "(("
Output: false
Explanation: There are no wildcards, and nothing closes the two (.
```

**Example 3:**
```
Input: brackets = ")("
Output: false
Explanation: The ) comes before any ( it could close.
```$$,
    constraints = $$- `1 <= brackets.length <= 120`
- Each character of `brackets` is `'('`, `')'` or `'*'`.$$
WHERE slug = $$balance-print-queue$$;

UPDATE problem_translations SET
    title = $$와일드카드가 있는 괄호 균형 맞추기$$,
    description = $$`(`, `)`, `*`로 이루어진 문자열 `brackets`가 주어집니다. 각 `*`는 와일드카드로, `(`나 `)`로 바꾸거나 지울 수 있습니다.

와일드카드를 적절히 정해서 `brackets`의 균형을 맞출 수 있으면 `true`를, 아니면 `false`를 반환하세요. 균형이 맞는다는 것은 모든 `(`가 문자열 뒤쪽의 `)`로 닫히고, 모든 `)`가 문자열 앞쪽의 `(`를 닫는다는 뜻입니다. 와일드카드를 지운 뒤 빈 문자열이 되면 균형이 맞는 것으로 봅니다.

**예시 1:**
```
입력: brackets = "((*)"
출력: true
설명: *를 )로 바꾸면 "(())"가 되어 균형이 맞습니다.
```

**예시 2:**
```
입력: brackets = "(("
출력: false
설명: 와일드카드가 없고, 두 (를 닫을 )가 없습니다.
```

**예시 3:**
```
입력: brackets = ")("
출력: false
설명: )가 닫을 수 있는 ( 보다 먼저 나옵니다.
```$$,
    constraints = $$- `1 <= brackets.length <= 120`
- `brackets`의 각 문자는 `'('`, `')'`, `'*'` 중 하나입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$balance-brackets-with-wildcards$$);
