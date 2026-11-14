-- V363: wildcard-lexicon keeps its Slug and title. The cheat-word framing is gone: the
-- statement opens with the task and traces Example 1 call by call in a table. The
-- Korean constraints read word for word; both languages now say "the word passed to
-- enroll". Python Starter method add_word -> enroll, the name the statement and the Test
-- Cases use. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Store words and answer wildcard queries, where `.` matches any single letter.

Implement the `WildcardLexicon` class:

- `WildcardLexicon()` creates an empty word list.
- `void enroll(String word)` saves `word`. Saving a word that is already saved changes nothing.
- `boolean match(String word)` returns `true` if some saved word has the same length as `word` and agrees with it at every position, where a `.` in `word` agrees with any letter; otherwise `false`, including when no word is saved.

`enroll` and `match` may be called in any order.

**Example 1:**
```
Input:
["WildcardLexicon","enroll","enroll","enroll","match","match","match","match"]
[[],["bad"],["dad"],["mad"],["pad"],["bad"],[".ad"],["b.."]]
Output: [null,null,null,null,false,true,true,true]
```

| Call | Saved words | Returns |
|---|---|---|
| `WildcardLexicon()` | none | `null` |
| `enroll("bad")` | bad | `null` |
| `enroll("dad")` | bad, dad | `null` |
| `enroll("mad")` | bad, dad, mad | `null` |
| `match("pad")` | bad, dad, mad | `false`: no saved word starts with `p` |
| `match("bad")` | bad, dad, mad | `true`: `bad` is saved |
| `match(".ad")` | bad, dad, mad | `true`: `bad`, `dad` and `mad` all fit |
| `match("b..")` | bad, dad, mad | `true`: `bad` fits |$$,
    constraints = $$- `1 <= word.length <= 25`
- Every `enroll` call's `word` consists of lowercase English letters.
- Every `match` call's `word` consists of lowercase English letters and `.`.
- `enroll` and `match` are called at most `8000` times in total.$$
WHERE slug = $$wildcard-lexicon$$;

UPDATE problem_translations SET
    title = $$와일드카드 단어 사전$$,
    description = $$단어를 저장하고, `.`이 아무 글자 하나와 일치하는 와일드카드 검색에 답하세요.

`WildcardLexicon` 클래스를 구현하세요.

- `WildcardLexicon()` — 빈 단어 목록을 만듭니다.
- `void enroll(String word)` — `word`를 저장합니다. 이미 저장된 단어를 다시 저장해도 달라지는 것은 없습니다.
- `boolean match(String word)` — 저장된 단어 중 `word`와 길이가 같고 모든 위치에서 일치하는 단어가 있으면 `true`, 없으면 `false`를 반환합니다. `word`의 `.`은 어떤 글자와도 일치합니다. 저장된 단어가 없으면 `false`입니다.

`enroll`과 `match`는 어떤 순서로든 호출될 수 있습니다.

**예시 1:**
```
입력:
["WildcardLexicon","enroll","enroll","enroll","match","match","match","match"]
[[],["bad"],["dad"],["mad"],["pad"],["bad"],[".ad"],["b.."]]
출력: [null,null,null,null,false,true,true,true]
```

| 호출 | 저장된 단어 | 반환 |
|---|---|---|
| `WildcardLexicon()` | 없음 | `null` |
| `enroll("bad")` | bad | `null` |
| `enroll("dad")` | bad, dad | `null` |
| `enroll("mad")` | bad, dad, mad | `null` |
| `match("pad")` | bad, dad, mad | `false`: `p`로 시작하는 저장 단어가 없음 |
| `match("bad")` | bad, dad, mad | `true`: `bad`가 저장되어 있음 |
| `match(".ad")` | bad, dad, mad | `true`: `bad`, `dad`, `mad` 모두 일치 |
| `match("b..")` | bad, dad, mad | `true`: `bad`가 일치 |$$,
    constraints = $$- `1 <= word.length <= 25`
- `enroll`에 넘기는 `word`는 영어 소문자로만 이루어져 있습니다.
- `match`에 넘기는 `word`는 영어 소문자와 `.`으로 이루어져 있습니다.
- `enroll`과 `match` 호출은 합쳐서 최대 `8000`번입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$wildcard-lexicon$$);
