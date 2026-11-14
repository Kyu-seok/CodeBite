-- V500: valid-brackets restated, title unchanged. The parameter tape (a theme leftover) is now
-- brackets, and the rule now also says a closer needs an open opener (hidden cases "]" and
-- "}{"). Sample 3 "(]" is now Example 3. Starter method verifyJobNesting -> isValidBrackets,
-- parameter tape -> brackets, in all 4 Starter Codes and Drivers. Examples match the sample
-- test cases, which are unchanged.

UPDATE problems SET
    description = $$Given a string `brackets` made of the characters `(`, `)`, `[`, `]`, `{` and `}`, return `true` if the brackets are properly nested, and `false` otherwise.

The brackets are properly nested when:

- every closer closes the most recent opener that is still open, and it is of the same type (so inner brackets close before outer ones);
- no closer appears while no opener is open;
- no opener is still open at the end.

**Example 1:**
```
Input: brackets = "{[()]}"
Output: true
Explanation: `(` closes first, then `[`, then `{`: each closer matches the most recent open bracket.
```

**Example 2:**
```
Input: brackets = "{[(])}"
Output: false
Explanation: The `]` arrives while `(` is the most recent open bracket, so `(` would close after `[`.
```

**Example 3:**
```
Input: brackets = "(]"
Output: false
Explanation: `(` is closed by `]`, a closer of a different type.
```$$,
    constraints = $$- `1 <= brackets.length <= 2 * 10^3`
- `brackets` consists only of the characters `'('`, `')'`, `'['`, `']'`, `'{'` and `'}'`.$$
WHERE slug = $$valid-brackets$$;

UPDATE problem_translations SET
    description = $$`(`, `)`, `[`, `]`, `{`, `}` 문자로만 이루어진 문자열 `brackets`가 주어집니다. 괄호가 올바르게 중첩되어 있으면 `true`, 그렇지 않으면 `false`를 반환하세요.

괄호가 올바르게 중첩되었다는 것은 다음을 모두 만족한다는 뜻입니다.

- 모든 닫는 괄호는 아직 열려 있는 여는 괄호 중 가장 최근 것을 닫으며, 그 괄호와 종류가 같습니다(따라서 안쪽 괄호가 바깥쪽 괄호보다 먼저 닫힙니다).
- 열려 있는 괄호가 하나도 없을 때 닫는 괄호가 나오지 않습니다.
- 끝까지 읽었을 때 열린 채로 남은 괄호가 없습니다.

**예시 1:**
```
입력: brackets = "{[()]}"
출력: true
설명: `(`가 먼저 닫히고, 이어서 `[`, 마지막으로 `{`가 닫힙니다. 모든 닫는 괄호가 가장 최근에 열린 괄호와 짝이 맞습니다.
```

**예시 2:**
```
입력: brackets = "{[(])}"
출력: false
설명: 가장 최근에 열린 괄호가 `(`인데 `]`가 나오므로, `(`가 `[`보다 늦게 닫히게 됩니다.
```

**예시 3:**
```
입력: brackets = "(]"
출력: false
설명: `(`가 종류가 다른 닫는 괄호 `]`로 닫힙니다.
```$$,
    constraints = $$- `1 <= brackets.length <= 2 * 10^3`
- `brackets`는 문자 `'('`, `')'`, `'['`, `']'`, `'{'`, `'}'`로만 이루어져 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$valid-brackets$$);
