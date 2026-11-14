-- V393: space-cookie-bakes, text restated. One sentence now says what the title's cookies
-- are: each letter is a batch, and two batches of the same kind can't go in back to back.
-- Starter method orderRecipeBakes -> spaceBakes, the title's words. Examples match the
-- sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Each letter of `cookies` is one batch of cookies waiting for the oven, and the letter is its kind. Two batches of the same kind must never be baked back to back.

Rearrange the letters of `cookies` into a baking order where no two adjacent letters are equal, and return it. Any such order is accepted. If no such order exists, return `""`.

**Example 1:**
```
Input: cookies = "bread"
Output: "brade"
Explanation: All five kinds differ, so many orders work, such as "brade" or "dabre".
```

**Example 2:**
```
Input: cookies = "aaaab"
Output: ""
Explanation: Kind 'a' has 4 batches out of 5, so two 'a' batches always end up back to back.
```

**Example 3:**
```
Input: cookies = "flour"
Output: "flour"
Explanation: No kind repeats, so the given order already works.
```$$
WHERE slug = $$space-cookie-bakes$$;

UPDATE problem_translations SET
    description = $$`cookies`의 각 글자는 오븐을 기다리는 쿠키 한 판이고, 글자는 그 쿠키의 종류입니다. 같은 종류의 쿠키를 연달아 구우면 안 됩니다.

`cookies`의 글자를 재배열해 인접한 두 글자가 같지 않은 굽는 순서를 만들어 반환하세요. 그런 순서라면 어느 것이든 정답으로 인정합니다. 그런 순서가 없으면 `""`를 반환하세요.

**예시 1:**
```
입력: cookies = "bread"
출력: "brade"
설명: 다섯 판의 종류가 모두 달라서 "brade"나 "dabre"처럼 여러 순서가 가능합니다.
```

**예시 2:**
```
입력: cookies = "aaaab"
출력: ""
설명: 다섯 판 중 4판이 'a' 종류라서, 어떻게 배열해도 'a' 두 판이 연달아 구워집니다.
```

**예시 3:**
```
입력: cookies = "flour"
출력: "flour"
설명: 겹치는 종류가 없으므로 주어진 순서가 이미 정답입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$space-cookie-bakes$$);
