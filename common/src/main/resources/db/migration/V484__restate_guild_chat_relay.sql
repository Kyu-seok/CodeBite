-- V484: guild-chat-relay restated, Slug and title unchanged. The constraint
-- "1 <= links.length" was false: hidden case 5 has no links (n = 1, answer 0); it is now
-- 0 <= links.length. The method propagateAlertWave, left from an earlier theme, is renamed
-- minutesToReachAll in all 4 Starter Codes and Drivers, whose local edges is now links.
-- Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$A guild has `n` players labeled `1` to `n`. Each `links[i] = [source, target, minutes]` is a one-way relay: once player `source` has the message, it reaches player `target` `minutes` minutes later. Every player passes the message on through all their relays the moment they first receive it.

Player `src` has the message at minute `0`. Return the minute at which the last player receives it (`0` when `src` is the only player), or `-1` if some player never does.

**Example 1:**
```
Input: links = [[1,2,4],[1,3,2],[3,2,1],[2,4,3],[3,4,7]], n = 4, src = 1
Output: 6
Explanation: Player 3 gets it at minute 2, player 2 at minute 3 (via 1 -> 3 -> 2, sooner than the direct 4), and player 4 last, at minute 6 (via 1 -> 3 -> 2 -> 4).
```

```diagram-graph
edges: [[1,2],[1,3],[3,2],[2,4],[3,4]]
directed: true
highlight_path: [1,3,2,4]
```

**Example 2:**
```
Input: links = [[1,2,5]], n = 3, src = 1
Output: -1
Explanation: No relay reaches player 3.
```$$,
    constraints = $$- `1 <= n <= 120`
- `0 <= links.length <= 6500`
- `links[i].length == 3`
- `1 <= source, target <= n` and `source != target`
- `1 <= minutes <= 120`
- Every `(source, target)` pair is unique.
- `1 <= src <= n`$$
WHERE slug = $$guild-chat-relay$$;

UPDATE problem_translations SET
    description = $$길드에 `1`부터 `n`까지 번호가 매겨진 플레이어 `n`명이 있습니다. 각 `links[i] = [source, target, minutes]`는 한 방향 중계로, 플레이어 `source`에게 메시지가 오면 `minutes`분 뒤 플레이어 `target`에게도 도착한다는 뜻입니다. 모든 플레이어는 메시지를 처음 받는 순간 자기의 모든 중계로 메시지를 전달합니다.

플레이어 `src`는 `0`분에 메시지를 가지고 있습니다. 마지막 플레이어가 메시지를 받는 시각(분)을 반환하세요. `src`가 유일한 플레이어면 `0`입니다. 끝내 받지 못하는 플레이어가 있으면 `-1`을 반환합니다.

**예시 1:**
```
입력: links = [[1,2,4],[1,3,2],[3,2,1],[2,4,3],[3,4,7]], n = 4, src = 1
출력: 6
설명: 플레이어 3은 2분에, 플레이어 2는 3분에(1 -> 3 -> 2 경로로, 직접 가는 4분보다 빠름), 플레이어 4는 마지막으로 6분에(1 -> 3 -> 2 -> 4 경로) 메시지를 받습니다.
```

```diagram-graph
edges: [[1,2],[1,3],[3,2],[2,4],[3,4]]
directed: true
highlight_path: [1,3,2,4]
```

**예시 2:**
```
입력: links = [[1,2,5]], n = 3, src = 1
출력: -1
설명: 플레이어 3에게 가는 중계가 없습니다.
```$$,
    constraints = $$- `1 <= n <= 120`
- `0 <= links.length <= 6500`
- `links[i].length == 3`
- `1 <= source, target <= n`이고 `source != target`
- `1 <= minutes <= 120`
- 모든 `(source, target)` 쌍은 서로 다릅니다.
- `1 <= src <= n`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$guild-chat-relay$$);
