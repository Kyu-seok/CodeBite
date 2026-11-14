-- V350: word-break-chat restated, title unchanged. The names fought the story: the chat
-- message was `headline`, the slang words `topics`, and the Starter method followed a third
-- (news headline) theme. Example 3's explanation now walks through why "breakingnews" fails,
-- and the Korean title, 헤드라인 토큰 나누기, now matches the English one.
-- Starter method splitHeadlineTokens -> canSplitMessage, parameters headline -> message,
-- topics -> words, in all 4 Starter Codes and Drivers. Examples match the sample test cases,
-- which are unchanged.

UPDATE problems SET
    description = $$A chat message `message` was sent with all its spaces removed, and `words` lists the slang words the chat knows.

Return `true` if `message` can be split into a sequence of one or more words from `words`, and `false` otherwise. A word may be used any number of times.

**Example 1:**
```
Input: message = "morningwire", words = ["morning","wire"]
Output: true
Explanation: "morningwire" splits into "morning" + "wire".
```

**Example 2:**
```
Input: message = "topstoryalert", words = ["top","story","alert"]
Output: true
Explanation: "topstoryalert" splits into "top" + "story" + "alert".
```

**Example 3:**
```
Input: message = "breakingnews", words = ["break","breaking","new","ing"]
Output: false
Explanation: "breaking" and "break" + "ing" both leave "news". "new" covers its first three letters, but no word covers the final "s".
```$$,
    constraints = $$- `1 <= message.length <= 400`
- `1 <= words.length <= 1500`
- `1 <= words[i].length <= 25`
- `message` and each `words[i]` consist only of lowercase English letters.
- All strings in `words` are distinct.$$
WHERE slug = $$word-break-chat$$;

UPDATE problem_translations SET
    title = $$채팅 메시지 단어 나누기$$,
    description = $$채팅 메시지 `message`가 공백이 모두 빠진 채로 전송되었고, `words`에는 채팅방에서 쓰는 슬랭 단어들이 들어 있습니다.

`message`를 `words`의 단어 하나 이상으로 나눌 수 있으면 `true`, 없으면 `false`를 반환하세요. 같은 단어를 여러 번 써도 됩니다.

**예시 1:**
```
입력: message = "morningwire", words = ["morning","wire"]
출력: true
설명: "morningwire"는 "morning" + "wire"로 나뉩니다.
```

**예시 2:**
```
입력: message = "topstoryalert", words = ["top","story","alert"]
출력: true
설명: "topstoryalert"는 "top" + "story" + "alert"로 나뉩니다.
```

**예시 3:**
```
입력: message = "breakingnews", words = ["break","breaking","new","ing"]
출력: false
설명: "breaking"으로 나누든 "break" + "ing"로 나누든 "news"가 남습니다. "new"로 앞 세 글자는 덮을 수 있지만, 마지막 "s"를 덮는 단어가 없습니다.
```$$,
    constraints = $$- `1 <= message.length <= 400`
- `1 <= words.length <= 1500`
- `1 <= words[i].length <= 25`
- `message`와 각 `words[i]`는 영어 소문자로만 이루어져 있습니다.
- `words`의 문자열은 모두 서로 다릅니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$word-break-chat$$);
