-- V502: zero-sum-trio restated, title unchanged. The task now comes first and says plainly
-- that a trio takes three different positions while its values may repeat ([-2,1,1]), that a
-- trio of the same values counts once, and that no trio gives []. The score-delta flavour is
-- one sentence. Starter method triageZeroPriority -> zeroSumTrios in all 4 Starter Codes and
-- Drivers. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given an integer array `deltas`, return every trio `[deltas[i], deltas[j], deltas[k]]` whose values sum to exactly `0`, where `i`, `j` and `k` are three different positions. The values may repeat: `[-2,1,1]` is a trio when `1` appears at two positions.

Trios with the same values count once, whichever positions they come from. Return the trios, and the values inside each trio, in any order. If no trio sums to `0`, return `[]`.

Each `deltas[i]` is one player's score change in a co-op game.

**Example 1:**
```
Input: deltas = [-3,1,2,-2,0,-1,1]
Output: [[-3,1,2],[-2,0,2],[-2,1,1],[-1,0,1]]
Explanation: `[-2,1,1]` takes the `1`s at positions 1 and 6. `[-1,0,1]` can use either `1`, but is listed once.
```

**Example 2:**
```
Input: deltas = [2,3,4]
Output: []
Explanation: Every value is positive, so no trio sums to 0.
```

**Example 3:**
```
Input: deltas = [0,0,0,0]
Output: [[0,0,0]]
Explanation: Any three of the four zeros make `[0,0,0]`, which is listed once.
```$$
WHERE slug = $$zero-sum-trio$$;

UPDATE problem_translations SET
    description = $$정수 배열 `deltas`가 주어집니다. 서로 다른 세 위치 `i`, `j`, `k`의 값을 더해 정확히 `0`이 되는 모든 삼인방 `[deltas[i], deltas[j], deltas[k]]`를 반환하세요. 값은 겹쳐도 됩니다. `1`이 두 위치에 있으면 `[-2,1,1]`도 삼인방입니다.

값이 같은 삼인방은 어느 위치에서 나왔든 한 번만 셉니다. 삼인방들의 순서와 각 삼인방 안의 값 순서는 자유입니다. 합이 `0`인 삼인방이 없으면 `[]`를 반환하세요.

각 `deltas[i]`는 협동 게임에서 한 플레이어의 점수 변화입니다.

**예시 1:**
```
입력: deltas = [-3,1,2,-2,0,-1,1]
출력: [[-3,1,2],[-2,0,2],[-2,1,1],[-1,0,1]]
설명: `[-2,1,1]`은 위치 1과 6의 `1`을 씁니다. `[-1,0,1]`은 어느 `1`로도 만들 수 있지만 한 번만 들어갑니다.
```

**예시 2:**
```
입력: deltas = [2,3,4]
출력: []
설명: 모든 값이 양수라서 합이 0이 되는 삼인방이 없습니다.
```

**예시 3:**
```
입력: deltas = [0,0,0,0]
출력: [[0,0,0]]
설명: 네 개의 0 중 아무 세 개나 `[0,0,0]`이 되며, 한 번만 들어갑니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$zero-sum-trio$$);
