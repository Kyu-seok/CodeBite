-- V331: validate-homework-id -> match-dot-star-pattern, retitled "Match Dot-Star
-- Pattern". The title read like checking an ID's format, and the homework/ID theme was
-- never used again; the task is matching a whole string against a pattern of letters,
-- `.` and `*`. Starter method validatePartStream -> isMatch. Drivers and Starter Code
-- directories are renamed in the same commit. Examples match the sample test cases,
-- which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$validate-homework-id$$, id FROM problems WHERE slug = $$validate-homework-id$$;

UPDATE problems SET
    slug = $$match-dot-star-pattern$$,
    title = $$Match Dot-Star Pattern$$,
    description = $$Given a string `s` and a pattern `p`, return `true` if `p` matches all of `s`, and `false` otherwise.

The pattern is made of lowercase letters and two special characters:

- `.` matches any single character.
- `*` matches zero or more copies of the character right before it (`a*` matches `""`, `"a"`, `"aa"`, …; `.*` matches any string).

The match must cover the whole of `s`, from its first character to its last, not just a prefix or a part in the middle.

**Example 1:**
```
Input: s = "bbbc", p = "b*c"
Output: true
Explanation: `b*` matches the three b's at the start, then `c` matches the final c, covering all of s.
```

**Example 2:**
```
Input: s = "xyzw", p = "x.y"
Output: false
Explanation: The pattern has no `*`, so it matches exactly three characters and cannot cover the four characters of s.
```$$,
    constraints = $$- `1 <= s.length <= 24`
- `1 <= p.length <= 24`
- `s` consists of lowercase English letters.
- `p` consists of lowercase English letters, `.` and `*`.
- Every `*` in `p` follows a letter or `.` (`p` never starts with `*` and has no two `*` in a row).$$
WHERE slug = $$validate-homework-id$$;

UPDATE problem_translations SET
    title = $$점·별 패턴 매칭$$,
    description = $$문자열 `s`와 패턴 `p`가 주어질 때, `p`가 `s` 전체와 매치되면 `true`, 아니면 `false`를 반환하세요.

패턴은 영어 소문자와 두 가지 특수 문자로 이루어집니다.

- `.`은 임의의 글자 하나와 매치됩니다.
- `*`는 바로 앞 글자가 0번 이상 반복된 것과 매치됩니다(`a*`는 `""`, `"a"`, `"aa"`, …와 매치되고, `.*`는 어떤 문자열과도 매치됩니다).

매치는 `s`의 앞부분이나 가운데 일부가 아니라, 첫 글자부터 마지막 글자까지 `s` 전체를 덮어야 합니다.

**예시 1:**
```
입력: s = "bbbc", p = "b*c"
출력: true
설명: `b*`가 앞쪽 b 세 개와 매치되고, 이어서 `c`가 마지막 c와 매치되어 s 전체를 덮습니다.
```

**예시 2:**
```
입력: s = "xyzw", p = "x.y"
출력: false
설명: 패턴에 `*`가 없으므로 정확히 세 글자와만 매치되어, 네 글자인 s 전체를 덮을 수 없습니다.
```$$,
    constraints = $$- `1 <= s.length <= 24`
- `1 <= p.length <= 24`
- `s`는 영어 소문자로 이루어져 있습니다.
- `p`는 영어 소문자와 `.`, `*`로 이루어져 있습니다.
- 모든 `*`는 `p`에서 글자나 `.` 바로 뒤에 옵니다(`p`는 `*`로 시작하지 않고, `*`가 연달아 두 번 오지도 않습니다).$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$match-dot-star-pattern$$);
