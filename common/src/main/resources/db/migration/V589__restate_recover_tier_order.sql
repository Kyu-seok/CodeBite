-- V589: recover-tier-order, text only. "Ranks higher" left the direction to guess, and "exactly
-- one order fits" read as a consequence of the rules, while it is a promise about the input
-- (statement cold-read, #350).

UPDATE problems SET
    description = $$A friend ranked the lowercase letters in a secret tier order, then sorted a list of tags by that order, the way a dictionary sorts words: compare two tags at the first position where they differ, and the tag whose letter comes earlier in the tier order comes first; when one tag is a prefix of the other, the shorter one comes first. Given the sorted list `tags`, return the tier order of the letters that appear in `tags`, as one string.

- Only letters that appear in `tags` are in the answer, each once.
- If no tier order could produce the list, return `""`. That happens when a longer tag comes right before its own prefix, or when the order the tags require goes in a cycle (`a` before `b` and `b` before `a`).
- Otherwise the input guarantees that exactly one order of those letters fits the list, so the answer is unique.

**Example 1:**
```
Input: tags = ["ab","ba","bc","cb","cd","dc"]
Output: "abcd"
Explanation: "ab" before "ba" puts a before b; "ba" before "bc" puts a before c; "bc" before "cb" puts b before c; "cb" before "cd" puts b before d; "cd" before "dc" puts c before d. The only order of a, b, c, d that fits is "abcd".
```

**Example 2:**
```
Input: tags = ["studio","stud"]
Output: ""
Explanation: "stud" is a prefix of "studio" but comes after it, which no tier order allows.
```$$
WHERE slug = $$recover-tier-order$$;

UPDATE problem_translations SET
    description = $$친구가 영어 소문자에 자기만의 티어 순서를 매기고, 그 순서로 태그 목록을 사전처럼 정렬했습니다. 두 태그를 처음으로 다른 글자에서 비교해, 티어 순서에서 앞선 글자를 가진 태그가 먼저 옵니다. 한 태그가 다른 태그의 접두사이면 짧은 쪽이 먼저 옵니다. 정렬된 목록 `tags`가 주어질 때, `tags`에 등장하는 글자들의 티어 순서를 문자열 하나로 반환하세요.

- 답에는 `tags`에 등장하는 글자만 한 번씩 들어갑니다.
- 어떤 티어 순서로도 이 목록이 나올 수 없으면 `""`를 반환합니다. 긴 태그가 바로 뒤에 오는 자신의 접두사보다 먼저 오거나, 태그들이 요구하는 순서가 순환할 때(`a`가 `b`보다 앞이고 `b`가 `a`보다 앞) 그렇습니다.
- 그렇지 않은 경우, 목록에 맞는 글자 순서가 정확히 하나인 입력만 주어지므로 답은 하나로 정해집니다.

**예시 1:**
```
입력: tags = ["ab","ba","bc","cb","cd","dc"]
출력: "abcd"
설명: "ab"가 "ba"보다 앞이니 a가 b보다 앞, "ba"가 "bc"보다 앞이니 a가 c보다 앞, "bc"가 "cb"보다 앞이니 b가 c보다 앞, "cb"가 "cd"보다 앞이니 b가 d보다 앞, "cd"가 "dc"보다 앞이니 c가 d보다 앞입니다. 이를 모두 만족하는 a, b, c, d의 순서는 "abcd" 하나뿐입니다.
```

**예시 2:**
```
입력: tags = ["studio","stud"]
출력: ""
설명: "stud"는 "studio"의 접두사인데 뒤에 나오므로, 어떤 티어 순서로도 이렇게 정렬될 수 없습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$recover-tier-order$$);
