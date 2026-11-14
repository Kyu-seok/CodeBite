-- V494: multiply-as-text, Korean description restated. "길이곱셈" was a typo for long
-- multiplication: it now reads "세로 곱셈", and the sentence on input size drops its casual
-- ending. Slug, titles, English text, constraints, Test Cases, Starter Code and Drivers are
-- unchanged.

UPDATE problem_translations SET
    description = $$아주 큰 음이 아닌 두 수가 숫자 문자열 `left`와 `right`로 주어집니다. 일반 `int`에는 담을 수 없을 만큼 길 수 있습니다. 두 수의 곱을 십진 문자열로 반환하세요.

두 입력을 숫자 타입으로 변환하거나, 큰 정수 라이브러리를 쓰거나, 임의 길이 곱셈을 해 주는 내장 함수를 호출하면 안 됩니다. 손으로 하는 세로 곱셈처럼 한 자리씩 직접 계산하세요.

**예시 1:**
```
입력: left = "12", right = "34"
출력: "408"
```

**예시 2:**
```
입력: left = "25", right = "13"
출력: "325"
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$multiply-as-text$$);
