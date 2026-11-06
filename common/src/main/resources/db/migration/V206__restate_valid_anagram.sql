-- V206: valid-anagram keeps its Slug, title and Starter Code names. Its examples
-- showed "anagram"/"nagaram" and "rat"/"car" while the sample test cases have
-- been "butter"/"bruett" and "yeast"/"toast" since V124, and the English
-- constraints still named mixA and mixB from the snack-mix theme. The
-- statement is rewritten as a direct one in English and Korean, with examples
-- that match the sample test cases (order_index 1 and 2), which are unchanged.

UPDATE problems SET
    description = $$Given two strings `s` and `t`, return `true` if `t` is an anagram of `s`, and `false` otherwise.

`t` is an anagram of `s` when it uses exactly the same letters as `s`, each the same number of times, in any order. Two strings of different lengths are never anagrams.

**Example 1:**
```
Input: s = "butter", t = "bruett"
Output: true
Explanation: Both strings have one b, one u, one e, one r and two t's.
```

**Example 2:**
```
Input: s = "yeast", t = "toast"
Output: false
Explanation: s has a y and an e that t doesn't have.
```$$,
    constraints = $$- `1 <= s.length, t.length <= 5 * 10^4`
- `s` and `t` consist of lowercase English letters.$$
WHERE slug = $$valid-anagram$$;

UPDATE problem_translations SET
    description = $$두 문자열 `s`와 `t`가 주어집니다. `t`가 `s`의 애너그램이면 `true`를, 아니면 `false`를 반환하세요.

`t`가 `s`의 애너그램이라는 것은 `t`가 `s`와 똑같은 글자들을 각각 같은 개수만큼, 순서만 다르게 사용한다는 뜻입니다. 길이가 다른 두 문자열은 애너그램이 될 수 없습니다.

**예시 1:**
```
입력: s = "butter", t = "bruett"
출력: true
설명: 두 문자열 모두 b, u, e, r을 하나씩, t를 두 개 가지고 있습니다.
```

**예시 2:**
```
입력: s = "yeast", t = "toast"
출력: false
설명: s에는 t에 없는 y와 e가 있습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$valid-anagram$$);
