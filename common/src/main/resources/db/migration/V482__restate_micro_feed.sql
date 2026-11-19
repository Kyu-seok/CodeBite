-- V482: micro-feed restated, Slug, title and names unchanged. "Each messageId is globally
-- unique and arrives in post order" left open whether recency is the id's value or the
-- call order; it is now stated as the order of publishPost calls. The English examples'
-- explanations sat outside their blocks with no trace of who follows whom: each Example
-- now has a call-by-call table in both languages. Examples match the sample test cases,
-- which are unchanged.

UPDATE problems SET
    description = $$Implement `MicroFeed`, a board where players post messages, follow each other, and read a feed of the newest messages from themselves and the players they follow.

- `MicroFeed()` starts an empty board.
- `void publishPost(int userId, int messageId)` posts message `messageId` by player `userId`. Every `messageId` is distinct.
- `List<Integer> latestFeed(int userId)` returns the IDs of the 10 most recent messages posted by `userId` or by a player `userId` follows, newest first, or all of them when there are fewer than 10. A message is more recent when its `publishPost` call came later, whatever its ID.
- `void subscribe(int followerId, int followeeId)` makes `followerId` follow `followeeId`. Nothing happens when the two IDs are equal or the follow already exists.
- `void unsubscribe(int followerId, int followeeId)` makes `followerId` stop following `followeeId`. Nothing happens when `followerId` doesn't follow `followeeId`.

**Example 1:**
```
Input: ["MicroFeed","publishPost","publishPost","latestFeed"]
       [[],[1,10],[1,20],[1]]
Output: [null,null,null,[20,10]]
```

| Call | Follows | Returns |
|---|---|---|
| `MicroFeed()` | none | `null` |
| `publishPost(1, 10)` | none | `null` |
| `publishPost(1, 20)` | none | `null` |
| `latestFeed(1)` | none | `[20, 10]`: player 1's own messages, newest first |

**Example 2:**
```
Input: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed"]
       [[],[1,10],[2,20],[1,2],[1]]
Output: [null,null,null,null,[20,10]]
```

| Call | Follows | Returns |
|---|---|---|
| `MicroFeed()` | none | `null` |
| `publishPost(1, 10)` | none | `null` |
| `publishPost(2, 20)` | none | `null` |
| `subscribe(1, 2)` | 1 → 2 | `null` |
| `latestFeed(1)` | 1 → 2 | `[20, 10]`: player 2's message was posted later |

**Example 3:**
```
Input: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed","unsubscribe","latestFeed"]
       [[],[1,10],[2,20],[1,2],[1],[1,2],[1]]
Output: [null,null,null,null,[20,10],null,[10]]
```

| Call | Follows | Returns |
|---|---|---|
| `MicroFeed()` | none | `null` |
| `publishPost(1, 10)` | none | `null` |
| `publishPost(2, 20)` | none | `null` |
| `subscribe(1, 2)` | 1 → 2 | `null` |
| `latestFeed(1)` | 1 → 2 | `[20, 10]` |
| `unsubscribe(1, 2)` | none | `null` |
| `latestFeed(1)` | none | `[10]`: player 2's message leaves player 1's feed |$$
WHERE slug = $$micro-feed$$;

UPDATE problem_translations SET
    description = $$플레이어가 메시지를 올리고, 서로 팔로우하고, 자신과 팔로우하는 플레이어들의 최신 메시지를 피드로 읽는 보드인 `MicroFeed`를 구현하세요.

- `MicroFeed()` — 빈 보드로 시작합니다.
- `void publishPost(int userId, int messageId)` — 플레이어 `userId`가 메시지 `messageId`를 올립니다. `messageId`는 모두 서로 다릅니다.
- `List<Integer> latestFeed(int userId)` — `userId` 본인이나 `userId`가 팔로우하는 플레이어가 올린 메시지 중 가장 최근 10개의 id를 최신순으로 반환합니다. 10개보다 적으면 모두 반환합니다. 메시지의 id와 상관없이, `publishPost` 호출이 나중일수록 더 최근 메시지입니다.
- `void subscribe(int followerId, int followeeId)` — `followerId`가 `followeeId`를 팔로우합니다. 두 id가 같거나 이미 팔로우 중이면 아무 일도 일어나지 않습니다.
- `void unsubscribe(int followerId, int followeeId)` — `followerId`가 `followeeId` 팔로우를 끊습니다. 팔로우 중이 아니면 아무 일도 일어나지 않습니다.

**예시 1:**
```
입력: ["MicroFeed","publishPost","publishPost","latestFeed"]
      [[],[1,10],[1,20],[1]]
출력: [null,null,null,[20,10]]
```

| 호출 | 팔로우 | 반환 |
|---|---|---|
| `MicroFeed()` | 없음 | `null` |
| `publishPost(1, 10)` | 없음 | `null` |
| `publishPost(1, 20)` | 없음 | `null` |
| `latestFeed(1)` | 없음 | `[20, 10]`: 플레이어 1 자신의 메시지를 최신순으로 |

**예시 2:**
```
입력: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed"]
      [[],[1,10],[2,20],[1,2],[1]]
출력: [null,null,null,null,[20,10]]
```

| 호출 | 팔로우 | 반환 |
|---|---|---|
| `MicroFeed()` | 없음 | `null` |
| `publishPost(1, 10)` | 없음 | `null` |
| `publishPost(2, 20)` | 없음 | `null` |
| `subscribe(1, 2)` | 1 → 2 | `null` |
| `latestFeed(1)` | 1 → 2 | `[20, 10]`: 플레이어 2의 메시지가 나중에 올라왔습니다 |

**예시 3:**
```
입력: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed","unsubscribe","latestFeed"]
      [[],[1,10],[2,20],[1,2],[1],[1,2],[1]]
출력: [null,null,null,null,[20,10],null,[10]]
```

| 호출 | 팔로우 | 반환 |
|---|---|---|
| `MicroFeed()` | 없음 | `null` |
| `publishPost(1, 10)` | 없음 | `null` |
| `publishPost(2, 20)` | 없음 | `null` |
| `subscribe(1, 2)` | 1 → 2 | `null` |
| `latestFeed(1)` | 1 → 2 | `[20, 10]` |
| `unsubscribe(1, 2)` | 없음 | `null` |
| `latestFeed(1)` | 없음 | `[10]`: 플레이어 2의 메시지가 1의 피드에서 빠집니다 |$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$micro-feed$$);
