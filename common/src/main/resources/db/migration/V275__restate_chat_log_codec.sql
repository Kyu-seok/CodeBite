-- V275: restate chat-log-codec (#207, part of #193). The description had no Example;
-- it gains Examples 1 and 2 showing samples 1 and 2 (a round trip of ["hello","world"]
-- and of [""]) in both languages. Slug, title, constraints, Test Cases, Starter Code
-- and Drivers are unchanged.

UPDATE problems SET
    description = $$Design a codec for a co-op game's chat log. The sender has a list of messages and can only hand the receiver a single string, which must later unpack into the same list.

Implement the `ListCoder` class with two methods:

- `String pack(List<String> messages)` — encodes the list into one string. Messages may contain any characters, including any marker you choose, so a plain join on a reserved character won't work.
- `List<String> unpack(String blob)` — decodes a string produced by `pack` back into the original list with the same order, length, and contents, including empty messages.

The codec must be stateless: `unpack` uses only the string `pack` emitted. A round trip must reproduce the input exactly, even when the list is empty, contains empty messages, or contains messages made entirely of marker-like characters.

**Example 1:**
```
Input: messages = ["hello","world"]
Output: ["hello","world"]
```
Explanation: `pack(messages)` returns one string, and `unpack` of that string returns the two messages in their original order.

**Example 2:**
```
Input: messages = [""]
Output: [""]
```
Explanation: The list holds one empty message. The round trip must return a list with that one empty message, not an empty list.$$
WHERE slug = $$chat-log-codec$$;

UPDATE problem_translations SET
    description = $$협동 게임의 채팅 로그를 위한 코덱을 설계합니다. 보내는 쪽에는 메시지 리스트가 있고, 받는 쪽에는 단 하나의 문자열만 건네줄 수 있으며, 그 문자열로부터 원래 메시지 리스트를 다시 그대로 복원해야 합니다.

다음 두 메서드를 가진 `ListCoder` 클래스를 구현하세요.

- `String pack(List<String> messages)` — 문자열 리스트 `messages`를 하나의 문자열로 인코딩합니다. 각 메시지에는 여러분이 구분자로 고른 문자를 포함해 어떤 문자든 들어갈 수 있으므로, 특정 문자로 단순히 이어 붙이는 방식은 통하지 않습니다.
- `List<String> unpack(String blob)` — `pack`이 만든 문자열 `blob`을 받아 원래 리스트와 순서·길이·내용이 모두 같은 문자열 리스트로 디코딩합니다. 빈 메시지도 그대로 살려야 합니다.

코덱은 상태를 가지지 않아야 합니다. 즉, `unpack`은 오직 `pack`이 내놓은 문자열만 사용해야 하며, 리스트가 비어 있거나 빈 메시지를 포함하거나 구분자처럼 보이는 문자들로만 이루어진 메시지가 있더라도 왕복 변환이 입력을 정확히 재현해야 합니다.

**예시 1:**
```
입력: messages = ["hello","world"]
출력: ["hello","world"]
```
설명: `pack(messages)`는 하나의 문자열을 반환하고, 그 문자열을 `unpack`하면 두 메시지가 원래 순서대로 돌아옵니다.

**예시 2:**
```
입력: messages = [""]
출력: [""]
```
설명: 리스트에는 빈 메시지 하나가 들어 있습니다. 왕복 변환은 빈 리스트가 아니라 빈 메시지 하나를 담은 리스트를 돌려줘야 합니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$chat-log-codec$$);
