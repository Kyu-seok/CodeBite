-- V541: count-voice-parties restated, title unchanged. The statement named
-- tallyDeviceMeshes, left over from another theme, and the Python Starter Code had
-- count_components; both become countParties. The task now comes first.
-- Starter method tallyDeviceMeshes / count_components -> countParties in all 4 Starter
-- Codes and Drivers. Examples and the Diagram match the sample test cases, which are
-- unchanged.

UPDATE problems SET
    description = $$Given `n` players labelled `0` to `n - 1` and a list of voice relays between them, return the number of separate parties.

Each `relays[i] = [a, b]` means players `a` and `b` can hear each other directly. Two players are in the same party when a chain of relays connects them, and a player with no relays is a party of one.

**Example 1:**
```
Input: n = 6, relays = [[0,1],[2,3],[3,4]]
Output: 3
Explanation: Players 0 and 1 share a relay, players 2, 3 and 4 are chained, and player 5 is alone: three parties.
```

```diagram-graph
edges: [[0,1],[2,3],[3,4]]
nodes: [0,1,2,3,4,5]
directed: false
```

**Example 2:**
```
Input: n = 7, relays = [[0,1],[1,2],[2,3],[3,4],[4,5],[5,6]]
Output: 1
Explanation: The relays chain every player to every other, so there is one party.
```$$,
    constraints = $$- `1 <= n <= 2000`
- `0 <= relays.length <= 5000`
- `relays[i] = [a, b]` with `0 <= a, b < n` and `a != b`
- No pair of players appears in `relays` more than once.$$
WHERE slug = $$count-voice-parties$$;

UPDATE problem_translations SET
    description = $$`0`번부터 `n - 1`번까지 번호가 붙은 플레이어 `n`명과 그들 사이의 음성 릴레이 목록이 주어질 때, 서로 분리된 파티의 개수를 반환하세요.

`relays[i] = [a, b]`는 플레이어 `a`와 `b`가 서로 직접 들을 수 있다는 뜻입니다. 두 플레이어가 릴레이의 사슬로 이어져 있으면 같은 파티이고, 릴레이가 하나도 없는 플레이어는 혼자서 한 파티입니다.

**예시 1:**
```
입력: n = 6, relays = [[0,1],[2,3],[3,4]]
출력: 3
설명: 플레이어 0과 1은 릴레이 하나를 공유하고, 플레이어 2, 3, 4는 사슬로 이어져 있으며, 플레이어 5는 혼자입니다. 파티는 3개입니다.
```

```diagram-graph
edges: [[0,1],[2,3],[3,4]]
nodes: [0,1,2,3,4,5]
directed: false
```

**예시 2:**
```
입력: n = 7, relays = [[0,1],[1,2],[2,3],[3,4],[4,5],[5,6]]
출력: 1
설명: 릴레이가 모든 플레이어를 사슬로 잇고 있으므로 파티는 하나입니다.
```$$,
    constraints = $$- `1 <= n <= 2000`
- `0 <= relays.length <= 5000`
- `relays[i] = [a, b]`, `0 <= a, b < n`, `a != b`
- `relays`에 같은 플레이어 쌍이 두 번 이상 나타나지 않습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-voice-parties$$);
