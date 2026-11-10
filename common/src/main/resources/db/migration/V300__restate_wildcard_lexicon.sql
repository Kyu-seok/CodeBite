-- V300: restate wildcard-lexicon (#232, part of #193). The description had no Example;
-- it now shows sample 1 as Example 1, with a call trace as its Explanation, in the
-- operations form, in both languages. The problem has a single sample, so there is no
-- Example 2 (showing a hidden Test Case would reveal it). Only the descriptions change; Slug, title,
-- constraints, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problems SET
    description = $$Build a cheat-word checker for a word-tile game. Players save favorite words and later test guesses, where `.` matches any single letter. A guess passes if some saved word has the same length and matches position-by-position.

Implement the `WildcardLexicon` class:

- `WildcardLexicon()` starts with no saved words.
- `void enroll(String word)` saves `word` (lowercase letters only). Saving the same word twice is fine.
- `boolean match(String word)` returns `true` if any saved word matches `word` under the wildcard rule, `false` otherwise (including when nothing is saved).

`match` inputs may mix lowercase letters and `.`; `enroll` inputs never contain `.`. Calls can interleave in any order, and `match` never modifies the saved set.

**Example 1:**
```
Input
["WildcardLexicon","enroll","enroll","enroll","match","match","match","match"]
[[],["bad"],["dad"],["mad"],["pad"],["bad"],[".ad"],["b.."]]
Output
[null,null,null,null,false,true,true,true]

Explanation
WildcardLexicon lexicon = new WildcardLexicon();
lexicon.enroll("bad");
lexicon.enroll("dad");
lexicon.enroll("mad");
lexicon.match("pad");  // returns false, no saved word starts with p
lexicon.match("bad");  // returns true, "bad" is saved
lexicon.match(".ad");  // returns true, "bad", "dad" and "mad" all fit
lexicon.match("b..");  // returns true, "bad" fits
```$$
WHERE slug = $$wildcard-lexicon$$;

UPDATE problem_translations SET
    description = $$단어 타일 게임을 위한 치트 단어 검사기를 만듭니다. 플레이어가 즐겨 쓰는 단어들을 저장해 두면, 나중에 추측한 단어를 검사할 수 있는데, 이때 `.`은 어떤 한 글자에도 매칭됩니다. 저장된 단어 중 길이가 같고 위치별로 모두 매칭되는 것이 있으면 추측이 통과합니다.

`WildcardLexicon` 클래스를 구현하세요.

- `WildcardLexicon()` — 저장된 단어가 없는 빈 사전으로 시작합니다.
- `void enroll(String word)` — `word`를 사전에 저장합니다(영어 소문자만). 같은 단어를 여러 번 저장해도 문제없습니다.
- `boolean match(String word)` — 와일드카드 규칙에 따라 `word`와 매칭되는 저장 단어가 하나라도 있으면 `true`, 그렇지 않으면 `false`를 반환합니다(아무 단어도 저장되지 않은 경우 포함).

`match`의 입력은 영어 소문자와 `.`이 섞여 있을 수 있고, `enroll`의 입력에는 절대 `.`이 들어 있지 않습니다. 두 메서드는 임의의 순서로 번갈아 호출될 수 있으며, `match`는 저장된 단어 집합을 변경하지 않습니다.

**예시 1:**
```
입력
["WildcardLexicon","enroll","enroll","enroll","match","match","match","match"]
[[],["bad"],["dad"],["mad"],["pad"],["bad"],[".ad"],["b.."]]
출력
[null,null,null,null,false,true,true,true]

설명
WildcardLexicon lexicon = new WildcardLexicon();
lexicon.enroll("bad");
lexicon.enroll("dad");
lexicon.enroll("mad");
lexicon.match("pad");  // false 반환, p로 시작하는 저장 단어가 없음
lexicon.match("bad");  // true 반환, "bad"가 저장되어 있음
lexicon.match(".ad");  // true 반환, "bad", "dad", "mad" 모두 매칭됨
lexicon.match("b..");  // true 반환, "bad"가 매칭됨
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$wildcard-lexicon$$);
