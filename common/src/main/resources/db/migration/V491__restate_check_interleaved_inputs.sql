-- V491: check-interleaved-inputs restated, title unchanged. The rule hidden case 11 depends on
-- (merged uses every letter of both strings exactly once, so a length mismatch is false) is
-- now stated outright, as is sample 3's (three empty strings give true). Korean title
-- "입력 합쳐쓰기 검사" -> "두 입력 교차 병합 검사". Method checkMergedQueue -> isInterleaving in
-- all 4 Starter Codes and Drivers. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given strings `controllerA`, `controllerB` and `merged`, return `true` if `merged` is an interleaving of `controllerA` and `controllerB`, and `false` otherwise.

In a rhythm game, two controllers each press a fixed sequence of button letters, and the screen logs every press in one merged sequence. `merged` is an interleaving when:

- it uses every letter of `controllerA` and `controllerB` exactly once and nothing else, so its length is the sum of theirs, and
- the letters from each controller keep that controller's order.

Any of the three strings may be empty: when all three are, the answer is `true`.

**Example 1:**
```
Input: controllerA = "cat", controllerB = "dog", merged = "cdoagt"
Output: true
Explanation: Take c from A, then d and o from B, then a from A, then g from B, then t from A. Both controllers' orders are kept.
```

**Example 2:**
```
Input: controllerA = "abc", controllerB = "xyz", merged = "axbzyc"
Output: false
Explanation: After a and x, B's next letter must be y, but merged shows z before y, breaking B's order.
```$$,
    constraints = $$- `0 <= controllerA.length, controllerB.length <= 120`
- `0 <= merged.length <= 240`
- `controllerA`, `controllerB`, and `merged` consist of lowercase English letters.$$
WHERE slug = $$check-interleaved-inputs$$;

UPDATE problem_translations SET
    title = $$두 입력 교차 병합 검사$$,
    description = $$문자열 `controllerA`, `controllerB`, `merged`가 주어집니다. `merged`가 `controllerA`와 `controllerB`를 교차 병합(인터리브)한 결과이면 `true`, 아니면 `false`를 반환하세요.

리듬 게임에서 두 컨트롤러가 각자 정해진 순서로 버튼 글자를 누르고, 화면에는 모든 입력이 하나로 합쳐진 기록이 남습니다. 다음 두 조건을 모두 만족하면 `merged`는 교차 병합입니다.

- `controllerA`와 `controllerB`의 모든 글자를 정확히 한 번씩만 쓰고 다른 글자는 없습니다. 따라서 길이가 두 문자열 길이의 합과 같습니다.
- 각 컨트롤러에서 온 글자들은 그 컨트롤러의 순서를 그대로 지킵니다.

세 문자열 모두 빈 문자열일 수 있으며, 셋 다 비어 있으면 답은 `true`입니다.

**예시 1:**
```
입력: controllerA = "cat", controllerB = "dog", merged = "cdoagt"
출력: true
설명: A에서 c, B에서 d와 o, A에서 a, B에서 g, A에서 t를 차례로 가져옵니다. 두 컨트롤러의 순서가 모두 지켜집니다.
```

**예시 2:**
```
입력: controllerA = "abc", controllerB = "xyz", merged = "axbzyc"
출력: false
설명: a와 x 다음에 B의 다음 글자는 y여야 하는데, merged에는 y보다 z가 먼저 나와 B의 순서가 깨집니다.
```$$,
    constraints = $$- `0 <= controllerA.length, controllerB.length <= 120`
- `0 <= merged.length <= 240`
- `controllerA`, `controllerB`, `merged`는 영어 소문자로 이루어져 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$check-interleaved-inputs$$);
