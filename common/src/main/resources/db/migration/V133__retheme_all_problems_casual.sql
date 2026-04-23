-- V133: Re-theme all 199 problems with casual everyday scenarios and simpler prose.
-- Updates English title/description/constraints on `problems` and refreshes the
-- Korean translation in `problem_translations`. Starter parameter names were
-- renamed in the same commit via scripts/apply_param_renames.py.
-- The already-piloted `shelf-stock-pair` problem was handled in V132 and is not
-- re-applied here.

-- active-sensor-mask
UPDATE problems SET
    title = $$Active Sensor Mask$$,
    description = $$Your co-op party's status bar packs which teammates are online into one integer `sensorMask`, with each set bit meaning a friend is logged in. You just want the headcount.

Implement `countActiveSensors(sensorMask)` to return the number of `1` bits in the binary form of `sensorMask`. Treat it as an unsigned value.

**Example 1:**
```
Input: sensorMask = 29
Output: 4
Explanation: 29 is 11101 in binary, which has four set bits.
```

**Example 2:**
```
Input: sensorMask = 256
Output: 1
Explanation: 256 is 100000000 in binary; only one friend is online.
```$$,
    constraints = $$- `1 <= sensorMask <= 2.1 * 10^9`$$
WHERE slug = $$active-sensor-mask$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$active-sensor-mask$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$active-sensor-mask$$),
    'ko',
    $KO$켜져 있는 센서 세기$KO$,
    $KO$협동 파티 상태바에서 어떤 팀원이 접속 중인지를 정수 하나 `sensorMask`에 비트로 담아두고 있습니다. 켜져 있는 비트는 친구가 로그인했다는 뜻이고, 지금은 그냥 몇 명인지 머릿수만 세고 싶습니다.

`countActiveSensors(sensorMask)`를 구현해서 `sensorMask`를 이진수로 봤을 때 `1` 비트가 몇 개인지 반환하세요. 값은 부호 없는 정수로 간주합니다.

**예시 1:**
```
Input: sensorMask = 29
Output: 4
Explanation: 29 is 11101 in binary, which has four set bits.
```

**예시 2:**
```
Input: sensorMask = 256
Output: 1
Explanation: 256 is 100000000 in binary; only one friend is online.
```$KO$,
    $KO$- `1 <= sensorMask <= 2.1 * 10^9`$KO$
);

-- alternate-ward-sweep
UPDATE problems SET
    title = $$Alternate Ward Sweep$$,
    description = $$Your class lined up for a yearbook photo in a binary-tree arrangement, and the photographer reads names row by row but keeps flipping direction for fun. Given `root`, return the node values grouped by level in zigzag order: the top row left-to-right, the next row right-to-left, and so on.

Each level is an inner list, the outer list runs top-down, and an empty tree yields an empty list.

**Example 1:**
```
Input: root = [5,3,7,2,9,6,8]
Output: [[5],[7,3],[2,9,6,8]]
Explanation: Row 0 left-to-right gives [5]; row 1 right-to-left gives [7,3]; row 2 left-to-right gives [2,9,6,8].
```

**Example 2:**
```
Input: root = [4]
Output: [[4]]
Explanation: A single student gets their own row.
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[0, 1800]`.
- `-100 <= Node.val <= 100`$$
WHERE slug = $$alternate-ward-sweep$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$alternate-ward-sweep$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$alternate-ward-sweep$$),
    'ko',
    $KO$지그재그로 줄 서기$KO$,
    $KO$반 친구들이 졸업 앨범 사진을 찍으려고 이진 트리 모양으로 줄을 섰는데, 사진사가 장난삼아 줄마다 방향을 번갈아 바꾸며 이름을 부릅니다. `root`가 주어지면, 노드 값을 레벨별로 묶어 지그재그 순서로 반환하세요: 맨 윗줄은 왼쪽에서 오른쪽으로, 다음 줄은 오른쪽에서 왼쪽으로, 그 다음 줄은 다시 왼쪽에서 오른쪽으로, 이런 식입니다.

각 레벨은 안쪽 리스트, 바깥 리스트는 위에서 아래로 진행하며, 빈 트리면 빈 리스트를 반환합니다.

**예시 1:**
```
Input: root = [5,3,7,2,9,6,8]
Output: [[5],[7,3],[2,9,6,8]]
Explanation: Row 0 left-to-right gives [5]; row 1 right-to-left gives [7,3]; row 2 left-to-right gives [2,9,6,8].
```

**예시 2:**
```
Input: root = [4]
Output: [[4]]
Explanation: A single student gets their own row.
```$KO$,
    $KO$- 트리의 노드 수는 `[0, 1800]` 범위입니다.
- `-100 <= Node.val <= 100`$KO$
);

-- assemble-script-breakdown
UPDATE problems SET
    title = $$Assemble Script Breakdown$$,
    description = $$Your video-game save corrupted its boss-fight tree, but two old log files survived: one recorded in **preorder** (node, then left, then right) and one in **inorder** (left, node, right). Rebuild the tree from those two logs.

Given integer arrays `preorder` and `inorder` containing the same node ids in those traversal orders, implement `assembleBreakdown(preorder, inorder)` and return the reconstructed tree. All ids are unique.

**Example 1:**
```
Input: preorder = [10,5,3,7,20,15], inorder = [3,5,7,10,15,20]
Output: [10,5,20,3,7,15]
Explanation: 10 is the root. Inorder splits into [3,5,7] (left) and [15,20] (right), giving left = (5, left 3, right 7) and right = (20, left 15).
```

**Example 2:**
```
Input: preorder = [42], inorder = [42]
Output: [42]
Explanation: A single node is the whole tree.
```$$,
    constraints = $$- `1 <= preorder.length <= 2 * 10^3`
- `inorder.length == preorder.length`
- `-10^8 <= preorder[i], inorder[i] <= 10^8`
- All ids are unique.
- Every value in `inorder` also appears in `preorder`.
- `preorder` is a valid preorder traversal of the tree.
- `inorder` is a valid inorder traversal of the same tree.$$
WHERE slug = $$assemble-script-breakdown$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$assemble-script-breakdown$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$assemble-script-breakdown$$),
    'ko',
    $KO$보스전 트리 복원$KO$,
    $KO$비디오 게임 세이브 파일이 손상되어 보스전 트리가 깨졌지만, 예전 로그 파일 두 개는 살아남았습니다. 하나는 **전위 순회**(노드, 왼쪽, 오른쪽) 순서로, 다른 하나는 **중위 순회**(왼쪽, 노드, 오른쪽) 순서로 기록되어 있습니다. 이 두 로그를 가지고 트리를 다시 복원하세요.

같은 노드 id들이 각 순회 순서대로 들어 있는 정수 배열 `preorder`와 `inorder`가 주어졌을 때, `assembleBreakdown(preorder, inorder)`를 구현해 복원된 트리를 반환합니다. 모든 id는 서로 다릅니다.

**예시 1:**
```
Input: preorder = [10,5,3,7,20,15], inorder = [3,5,7,10,15,20]
Output: [10,5,20,3,7,15]
Explanation: 10 is the root. Inorder splits into [3,5,7] (left) and [15,20] (right), giving left = (5, left 3, right 7) and right = (20, left 15).
```

**예시 2:**
```
Input: preorder = [42], inorder = [42]
Output: [42]
Explanation: A single node is the whole tree.
```$KO$,
    $KO$- `1 <= preorder.length <= 2 * 10^3`
- `inorder.length == preorder.length`
- `-10^8 <= preorder[i], inorder[i] <= 10^8`
- 모든 id는 서로 다릅니다.
- `inorder`에 있는 모든 값은 `preorder`에도 있습니다.
- `preorder`는 트리의 올바른 전위 순회 결과입니다.
- `inorder`는 같은 트리의 올바른 중위 순회 결과입니다.$KO$
);

-- balance-print-jobs
UPDATE problems SET
    title = $$Balance Print Jobs$$,
    description = $$Your coworker left a queue of print jobs tagged as a string: `(` opens a batch, `)` closes one, and `*` is a flexible slot that can act as `(`, `)`, or be dropped.

Given the queue string `tags`, return `true` if some reading of the flexible slots makes every opener match a later closer.

**Example 1:**
```
Input: tags = "((*)"
Output: true
Explanation: Treating the flexible slot as ')' yields "(())", which is balanced.
```

**Example 2:**
```
Input: tags = "())"
Output: false
Explanation: A closing tag has no opener to match, and there's no flexible slot to fix it.
```$$,
    constraints = $$- `1 <= tags.length <= 120`
- Each character of `tags` is `'('`, `')'`, or `'*'`$$
WHERE slug = $$balance-print-jobs$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$balance-print-jobs$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$balance-print-jobs$$),
    'ko',
    $KO$인쇄 작업 균형 맞추기$KO$,
    $KO$동료가 인쇄 작업 큐를 문자열로 남겨두고 갔습니다. `(`는 배치 시작, `)`는 배치 종료이고, `*`는 `(`, `)`, 또는 그냥 비워두기 중 어느 쪽으로도 쓸 수 있는 유연한 슬롯입니다.

큐 문자열 `tags`가 주어졌을 때, 유연한 슬롯들을 적절히 해석해서 모든 시작 괄호가 뒤쪽의 종료 괄호와 짝을 이루게 만들 수 있으면 `true`를 반환하세요.

**예시 1:**
```
Input: tags = "((*)"
Output: true
Explanation: Treating the flexible slot as ')' yields "(())", which is balanced.
```

**예시 2:**
```
Input: tags = "())"
Output: false
Explanation: A closing tag has no opener to match, and there's no flexible slot to fix it.
```$KO$,
    $KO$- `1 <= tags.length <= 120`
- `tags`의 각 문자는 `'('`, `')'`, 또는 `'*'`입니다.$KO$
);

-- batch-quota-combos
UPDATE problems SET
    title = $$Menu Combos For The Tab$$,
    description = $$A cafe lists its pastry prices in the array `pastries`, and a customer wants every distinct combo of pastries that totals exactly `tab` dollars. Prices can repeat, but each pastry on the shelf can be used at most once per combo.

Implement `listQuotaBatches` to return every unique multiset of prices summing to `tab`. Combos with the same multiset count once; return them in any order.

**Example 1:**
```
Input: pastries = [2,3,6,1,3,4], tab = 7
Output: [[1,2,4],[1,3,3],[1,6],[3,4]]
```

**Example 2:**
```
Input: pastries = [4,2,1,2,3], tab = 5
Output: [[1,2,2],[1,4],[2,3]]
```

**Example 3:**
```
Input: pastries = [8,8,8], tab = 16
Output: [[8,8]]
Explanation: 8 appears three times, but only a pair of 8s adds to 16.
```$$,
    constraints = $$- `1 <= pastries.length <= 100`
- `1 <= pastries[i] <= 50`
- `1 <= tab <= 30`$$
WHERE slug = $$batch-quota-combos$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$batch-quota-combos$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$batch-quota-combos$$),
    'ko',
    $KO$계산서에 딱 맞는 메뉴 조합$KO$,
    $KO$한 카페의 페이스트리 가격이 배열 `pastries`에 적혀 있고, 어떤 손님이 합계가 정확히 `tab` 달러가 되는 모든 서로 다른 조합을 찾고 싶어 합니다. 가격은 중복될 수 있지만, 진열대에 있는 각 페이스트리는 한 조합에서 최대 한 번만 사용할 수 있습니다.

`listQuotaBatches`를 구현해서 합이 `tab`이 되는 가격들의 서로 다른 모든 중복집합을 반환하세요. 같은 중복집합은 한 번만 세고, 반환 순서는 상관없습니다.

**예시 1:**
```
Input: pastries = [2,3,6,1,3,4], tab = 7
Output: [[1,2,4],[1,3,3],[1,6],[3,4]]
```

**예시 2:**
```
Input: pastries = [4,2,1,2,3], tab = 5
Output: [[1,2,2],[1,4],[2,3]]
```

**예시 3:**
```
Input: pastries = [8,8,8], tab = 16
Output: [[8,8]]
Explanation: 8 appears three times, but only a pair of 8s adds to 16.
```$KO$,
    $KO$- `1 <= pastries.length <= 100`
- `1 <= pastries[i] <= 50`
- `1 <= tab <= 30`$KO$
);

-- best-bake-order
UPDATE problems SET
    title = $$Best Balloon Pop Order$$,
    description = $$You and a friend are popping a row of helium balloons left over from a birthday party, and each balloon has a number scribbled on it. You pop them one at a time in any order.

Popping balloon `i` earns you `balloons[i - 1] * balloons[i] * balloons[i + 1]` points, where the neighbors are whatever balloons are still next to `i` at that moment. When a side has no balloon (off the end, or already popped), treat the missing neighbor as `1`. Return the maximum total points you can collect after popping all of them.

**Example 1:**
```
Input: balloons = [2,4,1,6]
Output: 90
Explanation: One good order pops 1, then 4, then 2, then 6: 4*1*6 + 2*4*6 + 1*2*6 + 1*6*1 = 24 + 48 + 12 + 6 = 90.
```

**Example 2:**
```
Input: balloons = [3,5]
Output: 20
Explanation: Pop 3 first (1*3*5 = 15), then 5 (1*5*1 = 5). Total = 20.
```$$,
    constraints = $$- `1 <= balloons.length <= 300`
- `0 <= balloons[i] <= 100`$$
WHERE slug = $$best-bake-order$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$best-bake-order$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$best-bake-order$$),
    'ko',
    $KO$최고의 풍선 터뜨리기 순서$KO$,
    $KO$생일 파티가 끝나고 남은 헬륨 풍선 한 줄을 친구와 함께 터뜨리고 있습니다. 풍선마다 숫자가 적혀 있고, 아무 순서로나 하나씩 터뜨릴 수 있습니다.

풍선 `i`를 터뜨리면 `balloons[i - 1] * balloons[i] * balloons[i + 1]` 만큼 점수를 얻는데, 여기서 이웃은 그 순간 `i` 옆에 남아 있는 풍선들입니다. 한쪽에 풍선이 없으면(끝을 벗어났거나 이미 터진 경우) 그쪽 이웃은 `1`로 간주합니다. 모든 풍선을 다 터뜨렸을 때 얻을 수 있는 최대 총 점수를 반환하세요.

**예시 1:**
```
Input: balloons = [2,4,1,6]
Output: 90
Explanation: One good order pops 1, then 4, then 2, then 6: 4*1*6 + 2*4*6 + 1*2*6 + 1*6*1 = 24 + 48 + 12 + 6 = 90.
```

**예시 2:**
```
Input: balloons = [3,5]
Output: 20
Explanation: Pop 3 first (1*3*5 = 15), then 5 (1*5*1 = 5). Total = 20.
```$KO$,
    $KO$- `1 <= balloons.length <= 300`
- `0 <= balloons[i] <= 100`$KO$
);

-- best-flow-streak
UPDATE problems SET
    title = $$Best Flow Streak$$,
    description = $$You're tallying the hourly foot traffic at a boba shop, where positives are customers walking in, negatives are walkouts, and zero means the door was closed. Given the array `traffic`, return the largest **product** of any contiguous non-empty slice.

The product of any subarray fits in a signed 32-bit integer.

**Example 1:**
```
Input: traffic = [3,-1,4,-2,5]
Output: 120
Explanation: The whole slice [3,-1,4,-2,5] multiplies to 120, the best you can get.
```

**Example 2:**
```
Input: traffic = [-3,0,2,-4]
Output: 2
Explanation: Any slice crossing the zero collapses to 0, so the best non-crossing pick is [2].
```$$,
    constraints = $$- `1 <= traffic.length <= 2 * 10^3`
- `-10 <= traffic[i] <= 10`
- The product of any contiguous subarray of `traffic` fits in a signed 32-bit integer.$$
WHERE slug = $$best-flow-streak$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$best-flow-streak$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$best-flow-streak$$),
    'ko',
    $KO$최고의 손님 흐름 구간$KO$,
    $KO$버블티 가게의 시간대별 출입 인원을 기록하고 있습니다. 양수는 들어온 손님, 음수는 나간 손님, 0은 문을 닫았다는 뜻입니다. 배열 `traffic`이 주어질 때, 비어 있지 않은 연속 구간 중 **곱이 가장 큰** 값을 반환하세요.

어떤 부분 배열의 곱이든 부호 있는 32비트 정수 범위에 들어갑니다.

**예시 1:**
```
Input: traffic = [3,-1,4,-2,5]
Output: 120
Explanation: The whole slice [3,-1,4,-2,5] multiplies to 120, the best you can get.
```

**예시 2:**
```
Input: traffic = [-3,0,2,-4]
Output: 2
Explanation: Any slice crossing the zero collapses to 0, so the best non-crossing pick is [2].
```$KO$,
    $KO$- `1 <= traffic.length <= 2 * 10^3`
- `-10 <= traffic[i] <= 10`
- `traffic`의 어떤 연속 부분 배열의 곱도 부호 있는 32비트 정수 범위에 들어갑니다.$KO$
);

-- best-scene-branch
UPDATE problems SET
    title = $$Best Scene Branch$$,
    description = $$Your co-op party's skill tree is a binary tree where each node has a score that can be positive or negative, and you want to pick the best contiguous chain to spec into.

A **branch** is a sequence of nodes connected by edges with no repeats, and it doesn't have to include the root. Given the `root` of the tree, return the largest sum of scores along any non-empty branch.

**Example 1:**
```
Input: root = [4,5,6]
Output: 15
Explanation: The best branch is 5 -> 4 -> 6, totaling 5 + 4 + 6 = 15.
```

**Example 2:**
```
Input: root = [-8,11,25,null,null,13,9]
Output: 47
Explanation: The best branch is 13 -> 25 -> 9, totaling 13 + 25 + 9 = 47. Including the root drags things down because of the -8.
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[1, 8 * 10^4]`.
- `-1000 <= Node.val <= 1000`$$
WHERE slug = $$best-scene-branch$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$best-scene-branch$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$best-scene-branch$$),
    'ko',
    $KO$최고의 스킬 트리 가지$KO$,
    $KO$협동 파티의 스킬 트리가 이진 트리 형태이고, 각 노드에는 양수 또는 음수가 될 수 있는 점수가 적혀 있습니다. 이 중 가장 좋은 연속된 가지를 골라 찍으려고 합니다.

**가지**란 간선으로 이어진 노드들의 수열로, 같은 노드가 반복되지 않으면 되고 루트를 꼭 포함할 필요는 없습니다. 트리의 `root`가 주어졌을 때, 비어 있지 않은 가지 중 점수 합이 가장 큰 값을 반환하세요.

**예시 1:**
```
Input: root = [4,5,6]
Output: 15
Explanation: The best branch is 5 -> 4 -> 6, totaling 5 + 4 + 6 = 15.
```

**예시 2:**
```
Input: root = [-8,11,25,null,null,13,9]
Output: 47
Explanation: The best branch is 13 -> 25 -> 9, totaling 13 + 25 + 9 = 47. Including the root drags things down because of the -8.
```$KO$,
    $KO$- 트리의 노드 수는 `[1, 8 * 10^4]` 범위입니다.
- `-1000 <= Node.val <= 1000`$KO$
);

-- best-tier-resale
UPDATE problems SET
    title = $$Best Tier Resale$$,
    description = $$You're flipping a rare skin on a game marketplace, and the daily price swings each day. You can buy one copy if you aren't holding any, sell the one you hold, or idle — and after every sale you must sit out the next day before buying again.

Given `tierPrices` where `tierPrices[i]` is the price on day `i`, return the maximum total profit you can lock in.

**Example 1:**
```
Input: tierPrices = [3,8,5,1,6]
Output: 10
Explanation: Buy day 0 at 3, sell day 1 at 8 (profit 5). Day 2 is the forced cooldown. Buy day 3 at 1, sell day 4 at 6 (profit 5). Total 10.
```

**Example 2:**
```
Input: tierPrices = [9,2,5]
Output: 3
Explanation: Skip the 9, buy day 1 at 2, sell day 2 at 5 for a profit of 3.
```$$,
    constraints = $$- `1 <= tierPrices.length <= 2000`
- `0 <= tierPrices[i] <= 900`$$
WHERE slug = $$best-tier-resale$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$best-tier-resale$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$best-tier-resale$$),
    'ko',
    $KO$최고의 스킨 되팔이$KO$,
    $KO$게임 거래소에서 희귀 스킨을 되팔고 있는데, 가격이 매일 오르락내리락 합니다. 보유 중인 게 없을 때만 한 개를 살 수 있고, 들고 있는 걸 팔거나 그냥 쉬는 것도 됩니다. 그리고 팔고 난 바로 다음 날은 무조건 하루 쉬고 나서야 다시 살 수 있습니다.

`tierPrices[i]`가 `i`일째 가격인 배열 `tierPrices`가 주어졌을 때, 확보 가능한 최대 총 이익을 반환하세요.

**예시 1:**
```
Input: tierPrices = [3,8,5,1,6]
Output: 10
Explanation: Buy day 0 at 3, sell day 1 at 8 (profit 5). Day 2 is the forced cooldown. Buy day 3 at 1, sell day 4 at 6 (profit 5). Total 10.
```

**예시 2:**
```
Input: tierPrices = [9,2,5]
Output: 3
Explanation: Skip the 9, buy day 1 at 2, sell day 2 at 5 for a profit of 3.
```$KO$,
    $KO$- `1 <= tierPrices.length <= 2000`
- `0 <= tierPrices[i] <= 900`$KO$
);

-- biggest-clear-bay
UPDATE problems SET
    title = $$Biggest Clear Bay$$,
    description = $$Your classroom floor is a grid of tiles where `"1"` means clear carpet and `"0"` means a desk is in the way, and the teacher wants the biggest square spot for the reading circle. Given `floor`, return the area (side length squared) of the largest axis-aligned square made entirely of `"1"` tiles. If there's no clear tile at all, return `0`.

**Example 1:**
```
Input: floor = [["1","1","0","1"],["1","1","1","1"],["0","1","1","1"],["1","1","1","1"]]
Output: 9
Explanation: The bottom-right 3x3 block is entirely clear, so the biggest square has side length 3 and area 9.
```

**Example 2:**
```
Input: floor = [["0","0","0"],["0","1","1"],["0","1","1"]]
Output: 4
Explanation: The 2x2 block in the bottom-right corner is all clear, giving area 4.
```$$,
    constraints = $$- `m == floor.length`
- `n == floor[i].length`
- `1 <= m, n <= 300`
- `floor[i][j]` is `'0'` or `'1'`$$
WHERE slug = $$biggest-clear-bay$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$biggest-clear-bay$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$biggest-clear-bay$$),
    'ko',
    $KO$가장 큰 빈 공간$KO$,
    $KO$교실 바닥이 타일로 이뤄진 격자로 표현되는데, `"1"`은 비어 있는 카펫 칸이고 `"0"`은 책상이 막고 있는 칸입니다. 선생님이 독서 모임을 위해 가장 큰 정사각형 자리를 잡으려고 합니다. 격자 `floor`가 주어졌을 때, 전부 `"1"` 칸으로 이뤄진 가장 큰 축에 정렬된 정사각형의 넓이(한 변 길이의 제곱)를 반환하세요. 빈 칸이 하나도 없으면 `0`을 반환합니다.

**예시 1:**
```
Input: floor = [["1","1","0","1"],["1","1","1","1"],["0","1","1","1"],["1","1","1","1"]]
Output: 9
Explanation: The bottom-right 3x3 block is entirely clear, so the biggest square has side length 3 and area 9.
```

**예시 2:**
```
Input: floor = [["0","0","0"],["0","1","1"],["0","1","1"]]
Output: 4
Explanation: The 2x2 block in the bottom-right corner is all clear, giving area 4.
```$KO$,
    $KO$- `m == floor.length`
- `n == floor[i].length`
- `1 <= m, n <= 300`
- `floor[i][j]`는 `'0'` 또는 `'1'`입니다.$KO$
);

-- bridge-label-chain
UPDATE problems SET
    title = $$Bridge Label Chain$$,
    description = $$You're rewriting a lowercase spawn code in a co-op game, but each tick only one letter may change and the new code has to exist in the `codeBank` of allowed spawn tags. Given a starting tag `startCode` and a goal tag `targetCode` of the same length, return the number of tags in the shortest chain from `startCode` to `targetCode` that changes exactly one letter per step and keeps every intermediate tag in `codeBank`. `startCode` doesn't have to appear in `codeBank`, but `targetCode` must; return `0` if no chain works.

**Example 1:**
```
Input: startCode = "pet", targetCode = "pot", codeBank = ["pit","pot","pat"]
Output: 3
Explanation: pet -> pit -> pot changes one letter per step and every stop is in codeBank.
```

**Example 2:**
```
Input: startCode = "pet", targetCode = "pot", codeBank = ["pit","pat"]
Output: 0
Explanation: "pot" isn't in codeBank, so no chain can end there.
```$$,
    constraints = $$- `1 <= startCode.length <= 10`
- `targetCode.length == startCode.length`
- `1 <= codeBank.length <= 4500`
- `codeBank[i].length == startCode.length`
- `startCode`, `targetCode`, and each `codeBank[i]` consist of lowercase English letters
- `startCode != targetCode`$$
WHERE slug = $$bridge-label-chain$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$bridge-label-chain$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$bridge-label-chain$$),
    'ko',
    $KO$스폰 코드 연쇄$KO$,
    $KO$협동 게임에서 소문자로 된 스폰 코드를 바꾸고 있는데, 한 번에 글자 하나만 바꿀 수 있고, 새 코드는 허용된 스폰 태그 모음 `codeBank` 안에 있어야 합니다. 시작 태그 `startCode`와 같은 길이의 목표 태그 `targetCode`가 주어졌을 때, 한 단계에 정확히 한 글자만 바꾸고 중간 태그가 모두 `codeBank` 안에 있는 가장 짧은 연쇄의 길이(태그 개수)를 반환하세요. `startCode`는 `codeBank`에 없어도 되지만 `targetCode`는 반드시 있어야 합니다. 가능한 연쇄가 없으면 `0`을 반환합니다.

**예시 1:**
```
Input: startCode = "pet", targetCode = "pot", codeBank = ["pit","pot","pat"]
Output: 3
Explanation: pet -> pit -> pot changes one letter per step and every stop is in codeBank.
```

**예시 2:**
```
Input: startCode = "pet", targetCode = "pot", codeBank = ["pit","pat"]
Output: 0
Explanation: "pot" isn't in codeBank, so no chain can end there.
```$KO$,
    $KO$- `1 <= startCode.length <= 10`
- `targetCode.length == startCode.length`
- `1 <= codeBank.length <= 4500`
- `codeBank[i].length == startCode.length`
- `startCode`, `targetCode`, 그리고 각 `codeBank[i]`는 영어 소문자로 이뤄져 있습니다.
- `startCode != targetCode`$KO$
);

-- brightest-observed-targets
UPDATE problems SET
    title = $$Top Scorer Lookup$$,
    description = $$Your guild just wrapped a raid and you have everyone's damage numbers in `scores`. You want the `k`-th highest score, counting ties — so within `[8, 3, 5, 5]` the 1st is `8` and the 2nd is `5`.

Implement `findBrightestTargets(scores, k)` so it returns the value sitting in the `k`-th spot after sorting `scores` in descending order.

**Example 1:**
```
Input: scores = [7,2,9,4,9,6,3], k = 3
Output: 7
Explanation: Sorted descending: [9,9,7,6,4,3,2]. The 3rd entry is 7.
```

**Example 2:**
```
Input: scores = [12,5,8,5,8,15,3,11], k = 4
Output: 8
Explanation: Sorted descending: [15,12,11,8,8,5,5,3]. The 4th entry is 8.
```$$,
    constraints = $$- `1 <= k <= scores.length <= 2 * 10^5`
- `|scores[i]| <= 10^8`$$
WHERE slug = $$brightest-observed-targets$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$brightest-observed-targets$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$brightest-observed-targets$$),
    'ko',
    $KO$상위 점수 조회$KO$,
    $KO$길드가 방금 레이드를 끝냈고, 모두의 데미지 수치가 `scores`에 들어 있습니다. 공동 순위를 그대로 인정한 상태에서 `k`번째로 높은 점수를 알고 싶습니다. 예를 들어 `[8, 3, 5, 5]`에서 1등은 `8`, 2등은 `5`입니다.

`scores`를 내림차순으로 정렬했을 때 `k`번째 자리에 있는 값을 반환하는 `findBrightestTargets(scores, k)`를 구현하세요.

**예시 1:**
```
Input: scores = [7,2,9,4,9,6,3], k = 3
Output: 7
Explanation: Sorted descending: [9,9,7,6,4,3,2]. The 3rd entry is 7.
```

**예시 2:**
```
Input: scores = [12,5,8,5,8,15,3,11], k = 4
Output: 8
Explanation: Sorted descending: [15,12,11,8,8,5,5,3]. The 4th entry is 8.
```$KO$,
    $KO$- `1 <= k <= scores.length <= 2 * 10^5`
- `|scores[i]| <= 10^8`$KO$
);

-- build-mirror-length
UPDATE problems SET
    title = $$Build Mirror Length$$,
    description = $$Your classmate is doodling a single word `word` in the margin of her notebook and wants to know the longest stretch inside it that reads the same forwards and backwards.

Implement `buildMirrorLength(word)` to return the length of the longest palindromic contiguous substring of `word`. Every single character counts as a mirror of length 1.

**Example 1:**
```
Input: word = "levelled"
Output: 5
Explanation: The slice "level" is a palindrome of length 5, and nothing longer mirrors itself.
```

**Example 2:**
```
Input: word = "barrel"
Output: 2
Explanation: The slice "rr" is a palindrome of length 2, and no longer mirror exists.
```$$,
    constraints = $$- `1 <= word.length <= 1200`
- `word` consists of only lowercase English letters.$$
WHERE slug = $$build-mirror-length$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$build-mirror-length$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$build-mirror-length$$),
    'ko',
    $KO$거울처럼 읽히는 구간 길이$KO$,
    $KO$반 친구가 노트 여백에 단어 `word` 하나를 끄적이면서, 그 안에서 앞으로 읽으나 뒤로 읽으나 똑같이 읽히는 가장 긴 구간이 얼마나 되는지 알고 싶어합니다.

`word`에서 가장 긴 팰린드롬 연속 부분 문자열의 길이를 반환하는 `buildMirrorLength(word)`를 구현하세요. 글자 하나하나는 길이 1짜리 대칭으로 칩니다.

**예시 1:**
```
Input: word = "levelled"
Output: 5
Explanation: The slice "level" is a palindrome of length 5, and nothing longer mirrors itself.
```

**예시 2:**
```
Input: word = "barrel"
Output: 2
Explanation: The slice "rr" is a palindrome of length 2, and no longer mirror exists.
```$KO$,
    $KO$- `1 <= word.length <= 1200`
- `word`는 영어 소문자로만 이루어져 있습니다.$KO$
);

-- bump-parcel-code
UPDATE problems SET
    title = $$Bump Parcel Code$$,
    description = $$You're numbering the take-out boxes stacked by the front door, and each box's number is stored as its decimal digits with `digits[0]` as the most significant. You need to bump the count by one and write the new digit array, carrying as needed (so `9,9` rolls to `1,0,0`).

The input has no leading zero except when the whole number is `0` (written `[0]`). Return the bumped digits.

**Example 1:**
```
Input: digits = [4,5,6]
Output: [4,5,7]
Explanation: 456 + 1 = 457.
```

**Example 2:**
```
Input: digits = [2,9,9]
Output: [3,0,0]
Explanation: 299 + 1 = 300, which keeps the same length but rewrites the trailing digits.
```$$,
    constraints = $$- `1 <= digits.length <= 100`
- `0 <= digits[i] <= 9`
- The input array has no leading zeros except for the code `0` itself$$
WHERE slug = $$bump-parcel-code$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$bump-parcel-code$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$bump-parcel-code$$),
    'ko',
    $KO$택배 번호 하나 올리기$KO$,
    $KO$현관 옆에 쌓아 둔 포장 박스들에 번호를 매기고 있는데, 각 박스 번호는 `digits[0]`이 가장 큰 자리인 십진수 자리들로 저장돼 있습니다. 번호를 하나 올려 새 자리 배열을 써야 하는데, 필요하면 자리올림도 해야 합니다(예: `9,9`는 `1,0,0`이 됩니다).

입력은 전체 숫자가 `0`일 때(`[0]`) 외에는 선행 0이 없습니다. 하나 올린 자리 배열을 반환하세요.

**예시 1:**
```
Input: digits = [4,5,6]
Output: [4,5,7]
Explanation: 456 + 1 = 457.
```

**예시 2:**
```
Input: digits = [2,9,9]
Output: [3,0,0]
Explanation: 299 + 1 = 300, which keeps the same length but rewrites the trailing digits.
```$KO$,
    $KO$- `1 <= digits.length <= 100`
- `0 <= digits[i] <= 9`
- 입력 배열은 코드 `0` 자체를 나타내는 경우를 빼면 선행 0을 갖지 않습니다.$KO$
);

-- busiest-machines-list
UPDATE problems SET
    title = $$Busiest Machines List$$,
    description = $$A cafe tracks every espresso machine used during the morning rush in `checkIns`, where each number is a machine id. The manager wants to post the `k` most-used machines on the break-room whiteboard so the baristas know which ones need a deep clean.

Implement `busiestMachines` to return the `k` machine ids that appear most often in `checkIns`, in any order. The top `k` is guaranteed to be unique.

**Example 1:**
```
Input: checkIns = [4,4,4,7,7,5], k = 2
Output: [4,7]
Explanation: Machine 4 was used 3 times, machine 7 twice, machine 5 once. The top 2 are 4 and 7.
```

**Example 2:**
```
Input: checkIns = [9], k = 1
Output: [9]
```$$,
    constraints = $$- `1 <= checkIns.length <= 2 * 10^5`
- `|checkIns[i]| <= 10^8`
- `k` is in the range `[1, the number of distinct machine ids in checkIns]`.
- The answer is guaranteed to be unique.$$
WHERE slug = $$busiest-machines-list$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$busiest-machines-list$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$busiest-machines-list$$),
    'ko',
    $KO$가장 바빴던 머신 목록$KO$,
    $KO$카페에서 아침 러시 동안 사용된 에스프레소 머신을 전부 `checkIns`에 기록합니다. 각 숫자는 머신 id예요. 매니저는 어떤 머신을 청소해야 할지 바리스타들이 알 수 있도록, 가장 많이 쓰인 머신 `k`개를 휴게실 화이트보드에 적어두고 싶어 해요.

`checkIns`에서 가장 자주 등장하는 머신 id `k`개를 돌려주는 `busiestMachines`를 구현합니다. 반환 순서는 상관없고, 상위 `k`개는 유일하다고 보장됩니다.

**예시 1:**
```
Input: checkIns = [4,4,4,7,7,5], k = 2
Output: [4,7]
Explanation: 머신 4는 3번, 7은 2번, 5는 1번 사용됐습니다. 상위 2개는 4와 7입니다.
```

**예시 2:**
```
Input: checkIns = [9], k = 1
Output: [9]
```$KO$,
    $KO$- `1 <= checkIns.length <= 2 * 10^5`
- `|checkIns[i]| <= 10^8`
- `k`는 `checkIns`에 등장하는 서로 다른 머신 id 개수 범위 `[1, 개수]` 안의 값입니다.
- 정답은 유일하다고 보장됩니다.$KO$
);

-- calm-sensor-reading
UPDATE problems SET
    title = $$Calm Phone Number$$,
    description = $$You and a friend are playing a silly number game with a phone number `reading`: keep replacing it with the sum of the squares of its digits, and call it **calm** if you eventually hit `1`, or **not calm** if it loops forever without reaching `1`.

Given a positive integer `reading`, return `true` when the process lands on `1`, and `false` when it falls into a cycle.

**Example 1:**
```
Input: reading = 7
Output: true
Explanation: 7 -> 49 -> 97 -> 130 -> 10 -> 1.
```

**Example 2:**
```
Input: reading = 4
Output: false
Explanation: 4 -> 16 -> 37 -> 58 -> 89 -> 145 -> 42 -> 20 -> 4, a cycle that never hits 1.
```$$,
    constraints = $$- `1 <= reading <= 2 * 10^8`$$
WHERE slug = $$calm-sensor-reading$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$calm-sensor-reading$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$calm-sensor-reading$$),
    'ko',
    $KO$평온한 전화번호$KO$,
    $KO$친구와 전화번호 `reading`으로 실없는 숫자 놀이를 합니다. 매번 각 자리 숫자의 제곱 합으로 숫자를 바꾸고, 결국 `1`에 도달하면 **평온**, `1`에 못 닿고 계속 같은 값만 돌면 **안 평온**이라고 부릅니다.

양의 정수 `reading`이 주어질 때, 과정이 `1`에 도달하면 `true`, 순환에 빠지면 `false`를 반환하세요.

**예시 1:**
```
Input: reading = 7
Output: true
Explanation: 7 -> 49 -> 97 -> 130 -> 10 -> 1.
```

**예시 2:**
```
Input: reading = 4
Output: false
Explanation: 4 -> 16 -> 37 -> 58 -> 89 -> 145 -> 42 -> 20 -> 4, 1에 절대 닿지 못하는 순환입니다.
```$KO$,
    $KO$- `1 <= reading <= 2 * 10^8`$KO$
);

-- carrier-street-sweep
UPDATE problems SET
    title = $$Carrier Street Sweep$$,
    description = $$Your dog insists on walking every street in the neighborhood once, and every walk has to start at home (zone `"HUB"`). You're given `routes`, a list of one-way street segments `[from, to]` that must each be walked exactly once.

Return a single walk that uses every segment, starting at `"HUB"`. If multiple walks are valid, return the one that is lexicographically smallest compared zone-by-zone. The input guarantees at least one valid walk exists.

**Example 1:**
```
Input: routes = [["ELM","HUB"],["HUB","BIR"],["BIR","ELM"],["HUB","CED"]]
Output: ["HUB","BIR","ELM","HUB","CED"]
Explanation: HUB -> BIR -> ELM -> HUB -> CED uses all four segments. Going to CED first would strand the dog before BIR and ELM.
```

**Example 2:**
```
Input: routes = [["HUB","NOR"],["HUB","SOU"],["NOR","SOU"],["SOU","HUB"],["SOU","NOR"]]
Output: ["HUB","NOR","SOU","HUB","SOU","NOR"]
Explanation: Taking NOR before SOU from the hub gives the lex-smallest walk that still finishes every segment.
```$$,
    constraints = $$- `1 <= routes.length <= 320`
- `routes[i].length == 2`
- Each `from` and `to` is a three-letter uppercase zone code.
- `from != to` within any single segment.
- The segments admit at least one valid walk starting at `"HUB"`.$$
WHERE slug = $$carrier-street-sweep$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$carrier-street-sweep$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$carrier-street-sweep$$),
    'ko',
    $KO$동네 길 한 번씩 돌기$KO$,
    $KO$강아지가 동네 모든 길을 딱 한 번씩 지나며 산책해야 직성이 풀리고, 모든 산책은 집(구역 `"HUB"`)에서 시작해야 합니다. 일방통행 길 구간들이 `routes`로 주어지고 `[from, to]` 형식이며, 각 구간은 정확히 한 번씩 지나야 해요.

`"HUB"`에서 출발해 모든 구간을 쓰는 경로 하나를 반환하세요. 가능한 경로가 여러 개라면, 구역을 한 칸씩 비교해 사전식으로 가장 작은 것을 반환합니다. 입력에는 유효한 경로가 최소 하나 존재한다고 보장됩니다.

**예시 1:**
```
Input: routes = [["ELM","HUB"],["HUB","BIR"],["BIR","ELM"],["HUB","CED"]]
Output: ["HUB","BIR","ELM","HUB","CED"]
Explanation: HUB -> BIR -> ELM -> HUB -> CED로 네 구간을 모두 씁니다. CED를 먼저 가면 BIR과 ELM을 처리하지 못한 채 갇힙니다.
```

**예시 2:**
```
Input: routes = [["HUB","NOR"],["HUB","SOU"],["NOR","SOU"],["SOU","HUB"],["SOU","NOR"]]
Output: ["HUB","NOR","SOU","HUB","SOU","NOR"]
Explanation: 허브에서 SOU보다 NOR을 먼저 고르면 모든 구간을 마무리하면서 사전식으로 가장 작은 경로가 됩니다.
```$KO$,
    $KO$- `1 <= routes.length <= 320`
- `routes[i].length == 2`
- 각 `from`과 `to`는 세 글자의 대문자 구역 코드입니다.
- 한 구간 안에서 `from != to`.
- 구간들은 `"HUB"`에서 시작하는 유효한 경로를 적어도 하나는 허용합니다.$KO$
);

-- chart-block-route
UPDATE problems SET
    title = $$Chart Block Route$$,
    description = $$You're playing a grid dungeon where `board` is `n x n`, each tile is `0` (walkable) or `1` (blocked), and your hero can step to any of the 8 surrounding tiles per turn. You want the shortest walkable path from the top-left `(0, 0)` to the bottom-right `(n - 1, n - 1)`.

Return the number of tiles on that shortest path, counting both ends. Every tile on the path must be `0`; if either corner is blocked or no path exists, return `-1`.

**Example 1:**
```
Input: board = [[0,0],[0,0]]
Output: 2
Explanation: One diagonal step from (0,0) to (1,1) covers 2 walkable tiles.
```

**Example 2:**
```
Input: board = [[0,1,0],[0,0,0],[1,0,0]]
Output: 3
Explanation: The path (0,0) -> (1,1) -> (2,2) visits 3 walkable tiles.
```$$,
    constraints = $$- `n == board.length`
- `n == board[i].length`
- `1 <= n <= 120`
- Each `board[i][j]` is `0` or `1`$$
WHERE slug = $$chart-block-route$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$chart-block-route$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$chart-block-route$$),
    'ko',
    $KO$최단 던전 경로$KO$,
    $KO$`n x n` 격자 던전을 플레이하는데, 각 칸은 `0`(걸을 수 있음) 또는 `1`(막힘)이고 히어로는 한 턴에 주변 8칸 중 아무 데로나 갈 수 있습니다. 좌상단 `(0, 0)`에서 우하단 `(n - 1, n - 1)`까지 가장 짧은 통과 가능 경로를 찾고 싶어요.

그 최단 경로에 포함된 칸 수(양 끝 포함)를 반환하세요. 경로의 모든 칸은 `0`이어야 합니다. 양 끝 중 하나가 막혀 있거나 경로가 없으면 `-1`을 반환합니다.

**예시 1:**
```
Input: board = [[0,0],[0,0]]
Output: 2
Explanation: (0,0)에서 (1,1)로 대각선 한 번에 가며 통과 가능한 2칸을 덮습니다.
```

**예시 2:**
```
Input: board = [[0,1,0],[0,0,0],[1,0,0]]
Output: 3
Explanation: (0,0) -> (1,1) -> (2,2) 경로가 3칸을 거칩니다.
```$KO$,
    $KO$- `n == board.length`
- `n == board[i].length`
- `1 <= n <= 120`
- 각 `board[i][j]`는 `0` 또는 `1`.$KO$
);

-- check-key-reachability
UPDATE problems SET
    title = $$Check Key Reachability$$,
    description = $$In a dungeon-crawler game you have `n` locked rooms numbered `0..n-1`. Each room stashes keys that unlock **other** rooms. Every room starts locked except room `0`, which is open when you spawn.

When you enter a room, you pick up every key inside it and may use any collected key later to unlock the matching room. Given `rooms`, where `rooms[i]` lists the ids of keys stored in room `i`, return `true` if you can eventually visit every room, or `false` otherwise.

**Example 1:**
```
Input: rooms = [[2,1],[4],[3],[],[3,0]]
Output: true
Explanation: Start in room 0 and grab keys 2 and 1. Room 1 gives key 4; room 2 gives key 3. Visiting 3 and 4 covers all five rooms.
```

**Example 2:**
```
Input: rooms = [[2],[3],[],[4],[1]]
Output: false
Explanation: Room 0 only yields key 2, and room 2 is empty. The keys for rooms 1, 3, and 4 are trapped inside those rooms.
```$$,
    constraints = $$- `1 <= n <= 1000`
- `0 <= rooms[i].length <= n`
- `0 <= rooms[i][j] < n`
- All values in `rooms[i]` are unique.$$
WHERE slug = $$check-key-reachability$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$check-key-reachability$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$check-key-reachability$$),
    'ko',
    $KO$모든 방 열 수 있는지$KO$,
    $KO$던전 크롤 게임에 `0..n-1`로 번호 붙은 잠긴 방이 `n`개 있습니다. 각 방에는 **다른 방을** 여는 열쇠가 들어 있어요. 처음에는 모든 방이 잠겨 있지만, 스폰 시점에 방 `0`만 열려 있습니다.

어떤 방에 들어가면 그 안의 열쇠를 모두 주울 수 있고, 수집한 열쇠는 언제든 대응하는 방을 열 때 쓸 수 있어요. `rooms[i]`가 방 `i`에 있는 열쇠들의 id 목록이라고 할 때, 결국 모든 방을 방문할 수 있으면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: rooms = [[2,1],[4],[3],[],[3,0]]
Output: true
Explanation: 방 0에서 열쇠 2, 1을 얻고, 방 1에서 열쇠 4를, 방 2에서 열쇠 3을 얻어 방 3과 4까지 모두 방문할 수 있습니다.
```

**예시 2:**
```
Input: rooms = [[2],[3],[],[4],[1]]
Output: false
Explanation: 방 0에서는 열쇠 2만 얻을 수 있고, 방 2는 비어 있어 방 1, 3, 4의 열쇠가 각 방 안에 갇혀 버립니다.
```$KO$,
    $KO$- `1 <= n <= 1000`
- `0 <= rooms[i].length <= n`
- `0 <= rooms[i][j] < n`
- `rooms[i]`의 값은 모두 서로 다릅니다.$KO$
);

-- check-merged-queue
UPDATE problems SET
    title = $$Check Merged Queue$$,
    description = $$In a rhythm game you hit inputs from two controllers, each with its own fixed sequence of button letters. The screen logs a merged sequence of every press. A merge is legit only if it's a true interleave of the two controllers: every press appears once, and within each controller the original order is preserved.

Given `controllerA`, `controllerB`, and `merged` (each character is one press), return `true` when `merged` is a valid interleave of the two controllers, or `false` otherwise.

**Example 1:**
```
Input: controllerA = "cat", controllerB = "dog", merged = "cdoagt"
Output: true
Explanation: Pull c from A, then d and o from B, then a from A, then g from B, then t from A. Both controller orders are preserved.
```

**Example 2:**
```
Input: controllerA = "abc", controllerB = "xyz", merged = "axbzyc"
Output: false
Explanation: After a then x, the next press from B would have to be y, but the merged stream shows z before y, violating B's order.
```$$,
    constraints = $$- `0 <= controllerA.length, controllerB.length <= 120`
- `0 <= merged.length <= 240`
- `controllerA`, `controllerB`, and `merged` consist of lowercase English letters.$$
WHERE slug = $$check-merged-queue$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$check-merged-queue$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$check-merged-queue$$),
    'ko',
    $KO$입력 합쳐쓰기 검사$KO$,
    $KO$리듬 게임에서 두 컨트롤러로 입력을 누르고 있어요. 각 컨트롤러는 자기만의 고정된 버튼 글자 순서가 있고, 화면에는 모든 입력이 합쳐진 기록이 남습니다. 이 합쳐진 기록이 두 컨트롤러의 진짜 인터리브가 되려면, 모든 입력이 정확히 한 번씩 나오고 각 컨트롤러 내부의 원래 순서가 유지되어야 해요.

`controllerA`, `controllerB`, `merged`(각 문자는 입력 하나)가 주어질 때, `merged`가 두 컨트롤러의 유효한 인터리브이면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: controllerA = "cat", controllerB = "dog", merged = "cdoagt"
Output: true
Explanation: A에서 c, B에서 d와 o, A에서 a, B에서 g, A에서 t. 두 컨트롤러의 순서 모두 보존됩니다.
```

**예시 2:**
```
Input: controllerA = "abc", controllerB = "xyz", merged = "axbzyc"
Output: false
Explanation: a 뒤 x가 나온 뒤 B에서 다음 입력은 y여야 하는데 합쳐진 기록은 y보다 z가 먼저 나와 B의 순서가 깨집니다.
```$KO$,
    $KO$- `0 <= controllerA.length, controllerB.length <= 120`
- `0 <= merged.length <= 240`
- `controllerA`, `controllerB`, `merged`는 영어 소문자로 이루어져 있습니다.$KO$
);

-- choose-start-station
UPDATE problems SET
    title = $$Choose Start Station$$,
    description = $$You're picking which outlet to start your phone-charging road trip from on a loop with `n` rest stops. Stop `i` tops you up by `energy[i]` units, and driving to the next stop drains `drain[i]` units. Your phone starts empty and must never hit zero charge as you complete one full clockwise loop.

Return the index of a valid starting stop, or `-1` if no choice lets you finish the loop. If a valid start exists, it is unique.

**Example 1:**
```
Input: energy = [4,6,1,3,5], drain = [3,5,2,2,6]
Output: 0
```

**Example 2:**
```
Input: energy = [5,2,8], drain = [6,4,7]
Output: -1
```$$,
    constraints = $$- `n == energy.length == drain.length`
- `1 <= n <= 2 * 10^5`
- `0 <= energy[i], drain[i] <= 8000`$$
WHERE slug = $$choose-start-station$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$choose-start-station$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$choose-start-station$$),
    'ko',
    $KO$출발 충전소 고르기$KO$,
    $KO$휴게소 `n`개가 원형으로 연결된 로드 트립에서 휴대폰 충전을 어디서 시작할지 고르고 있습니다. 휴게소 `i`에서는 `energy[i]`만큼 충전되고, 다음 휴게소까지 가는 동안 `drain[i]`만큼 소모됩니다. 휴대폰은 처음에 완전히 비어 있고, 시계 방향으로 한 바퀴 도는 내내 충전량이 0 아래로 내려가면 안 됩니다.

한 바퀴를 완주할 수 있는 출발 휴게소의 인덱스를 반환하세요. 그런 출발점이 없으면 `-1`을 반환합니다. 가능한 출발점이 존재한다면 유일합니다.

**예시 1:**
```
Input: energy = [4,6,1,3,5], drain = [3,5,2,2,6]
Output: 0
```

**예시 2:**
```
Input: energy = [5,2,8], drain = [6,4,7]
Output: -1
```$KO$,
    $KO$- `n == energy.length == drain.length`
- `1 <= n <= 2 * 10^5`
- `0 <= energy[i], drain[i] <= 8000`$KO$
);

-- clear-defect-rows
UPDATE problems SET
    title = $$Clear Defect Rows$$,
    description = $$You're cleaning up a grid-based puzzle game where any tile showing a `0` triggers a full row-and-column wipe. Given an `m x n` grid `board`, rewrite it **in-place** so every cell that shares a row or column with an original zero becomes `0`.

Cells whose row and column had no zeros keep their original value.

**Example 1:**
```
Input: board = [[2,3],[4,5]]
Output: [[2,3],[4,5]]
Explanation: No zero tiles, so the board is unchanged.
```

**Example 2:**
```
Input: board = [[4,6,8],[2,0,5],[7,9,3]]
Output: [[4,0,8],[0,0,0],[7,0,3]]
Explanation: The zero is at row 1, column 1, so row 1 and column 1 are wiped.
```$$,
    constraints = $$- `m == board.length`
- `n == board[0].length`
- `1 <= m, n <= 200`
- `|board[i][j]| <= 10^8`$$
WHERE slug = $$clear-defect-rows$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$clear-defect-rows$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$clear-defect-rows$$),
    'ko',
    $KO$불량 줄 싹 지우기$KO$,
    $KO$격자 퍼즐 게임을 정리 중인데, `0`이 적힌 타일이 하나라도 있으면 그 행과 열이 통째로 날아갑니다. `m x n` 격자 `board`가 주어지면, 원래 0이었던 칸과 같은 행 또는 열에 있는 모든 칸을 `0`으로 바꿔 **제자리에서** 수정하세요.

행과 열 모두 0이 없었던 칸은 원래 값을 유지합니다.

**예시 1:**
```
Input: board = [[2,3],[4,5]]
Output: [[2,3],[4,5]]
Explanation: No zero tiles, so the board is unchanged.
```

**예시 2:**
```
Input: board = [[4,6,8],[2,0,5],[7,9,3]]
Output: [[4,0,8],[0,0,0],[7,0,3]]
Explanation: The zero is at row 1, column 1, so row 1 and column 1 are wiped.
```$KO$,
    $KO$- `m == board.length`
- `n == board[0].length`
- `1 <= m, n <= 200`
- `|board[i][j]| <= 10^8`$KO$
);

-- click-counter
UPDATE problems SET
    title = $$Click Tally Window$$,
    description = $$You're tracking how often your friend spams the reload button on a multiplayer lobby. Build `ClickTally` to record each click's timestamp and, on demand, report how many clicks happened in the last five minutes (inclusive on both ends).

- `ClickTally()` — starts a fresh tally.
- `void record(int timestamp)` — logs one click at second `timestamp`. Multiple clicks can share a second.
- `int countSince(int timestamp)` — returns how many clicks fall in `[timestamp - 299, timestamp]`.

Calls arrive in non-decreasing timestamp order.

**Example 1:**
```
Input: ["ClickTally","record","record","record","countSince","record","countSince","countSince"] / [[],[1],[2],[3],[4],[300],[300],[301]]
Output: [null,null,null,null,3,null,4,3]
```
At second 4, the clicks at 1, 2, and 3 are all inside the window. At second 300 the click at 1 still counts, so four clicks show up. One tick later it slips out and the count drops to three.

**Example 2:**
```
Input: ["ClickTally","record","record","record","countSince"] / [[],[100],[100],[100],[100]]
Output: [null,null,null,null,3]
```
Three clicks in the same second all count.

**Example 3:**
```
Input: ["ClickTally","countSince","record","countSince"] / [[],[1],[2],[300]]
Output: [null,0,null,1]
```
Querying before any click arrives returns zero; the later click still falls in the window at second 300.$$,
    constraints = $$- `1 <= timestamp <= 2 * 10^9`
- Each `timestamp` is greater than or equal to the previous one across all calls.
- At most 250 total calls are made to `record` and `countSince` combined.$$
WHERE slug = $$click-counter$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$click-counter$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$click-counter$$),
    'ko',
    $KO$클릭 집계 창$KO$,
    $KO$멀티플레이 로비에서 친구가 새로고침 버튼을 얼마나 자주 연타하는지 추적하고 있습니다. `ClickTally`를 만들어 클릭할 때마다 타임스탬프를 기록하고, 요청이 들어오면 최근 5분(양쪽 끝 포함) 동안 몇 번 클릭했는지 알려주세요.

- `ClickTally()` — 새 집계를 시작합니다.
- `void record(int timestamp)` — `timestamp` 초에 클릭 한 번을 기록합니다. 같은 초에 여러 번 클릭될 수도 있습니다.
- `int countSince(int timestamp)` — `[timestamp - 299, timestamp]` 구간에 들어오는 클릭 수를 반환합니다.

호출은 타임스탬프가 감소하지 않는 순서로 들어옵니다.

**예시 1:**
```
Input: ["ClickTally","record","record","record","countSince","record","countSince","countSince"] / [[],[1],[2],[3],[4],[300],[300],[301]]
Output: [null,null,null,null,3,null,4,3]
```
4초 시점에는 1, 2, 3초의 클릭이 모두 구간 안에 들어옵니다. 300초 시점에도 1초의 클릭이 아직 포함되므로 네 번이 잡힙니다. 1초 뒤에는 그 클릭이 구간 밖으로 빠지면서 세 번으로 줄어듭니다.

**예시 2:**
```
Input: ["ClickTally","record","record","record","countSince"] / [[],[100],[100],[100],[100]]
Output: [null,null,null,null,3]
```
같은 초에 찍힌 클릭 세 번이 모두 집계됩니다.

**예시 3:**
```
Input: ["ClickTally","countSince","record","countSince"] / [[],[1],[2],[300]]
Output: [null,0,null,1]
```
클릭이 하나도 기록되기 전에 조회하면 0이 나오고, 나중에 기록된 클릭은 300초 시점의 구간 안에 들어옵니다.$KO$,
    $KO$- `1 <= timestamp <= 2 * 10^9`
- 모든 호출에 걸쳐 각 `timestamp`는 직전 타임스탬프보다 작지 않습니다.
- `record`와 `countSince`의 총 호출 횟수는 최대 250번입니다.$KO$
);

-- cluster-barrel-signatures
UPDATE problems SET
    title = $$Cluster Drink Labels$$,
    description = $$The barista scribbled drink-name labels on cups all morning, and some are just anagrams of each other. Given an array `labels` of lowercase strings, group the cups whose labels are permutations of the same letters.

Implement `clusterBarrels` so each inner list is sorted lexicographically and the outer list is sorted lexicographically by each group's first label.

**Example 1:**
```
Input: labels = ["oakvanilla","vanillaoak","plum","lump","berrytannin","tanninberry","oak"]
Output: [["berrytannin","tanninberry"],["lump","plum"],["oak"],["oakvanilla","vanillaoak"]]
```

**Example 2:**
```
Input: labels = ["merlot"]
Output: [["merlot"]]
```$$,
    constraints = $$- `1 <= labels.length <= 8 * 10^3`
- `0 <= labels[i].length <= 100`
- `labels[i]` consists of lowercase English letters.$$
WHERE slug = $$cluster-barrel-signatures$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$cluster-barrel-signatures$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$cluster-barrel-signatures$$),
    'ko',
    $KO$음료 라벨 묶기$KO$,
    $KO$바리스타가 오전 내내 컵에 음료 이름 라벨을 휘갈겨 적었는데, 그중 몇몇은 서로 철자만 뒤섞인 같은 글자 구성입니다. 소문자 문자열 배열 `labels`가 주어졌을 때, 글자 구성이 같은 라벨끼리 묶어주세요.

`clusterBarrels`를 구현하되, 각 안쪽 리스트는 사전순으로 정렬하고, 바깥 리스트는 각 그룹의 첫 라벨을 기준으로 사전순 정렬해서 반환합니다.

**예시 1:**
```
Input: labels = ["oakvanilla","vanillaoak","plum","lump","berrytannin","tanninberry","oak"]
Output: [["berrytannin","tanninberry"],["lump","plum"],["oak"],["oakvanilla","vanillaoak"]]
```

**예시 2:**
```
Input: labels = ["merlot"]
Output: [["merlot"]]
```$KO$,
    $KO$- `1 <= labels.length <= 8 * 10^3`
- `0 <= labels[i].length <= 100`
- `labels[i]`는 영어 소문자로만 이루어져 있습니다.$KO$
);

-- combine-counter-readings
UPDATE problems SET
    title = $$Combine Counter Readings$$,
    description = $$You're modding an old handheld game where the hardware only exposes bitwise ops (AND, OR, XOR, NOT, shifts) on its two kill-counter registers. You still need to add them up without using `+` or `-`.

Given two integers `firstCount` and `secondCount`, implement `combineCounters` to return their sum using only bitwise operations. XOR gives you the carry-less sum, and AND plus left shift gives you the carries, so loop until the carry settles to zero.

**Example 1:**
```
Input: firstCount = 12, secondCount = 9
Output: 21
```

**Example 2:**
```
Input: firstCount = -15, secondCount = 4
Output: -11
```$$,
    constraints = $$- `-1500 <= firstCount, secondCount <= 1500`$$
WHERE slug = $$combine-counter-readings$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$combine-counter-readings$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$combine-counter-readings$$),
    'ko',
    $KO$카운터 합산하기$KO$,
    $KO$오래된 휴대용 게임기를 개조하고 있는데, 이 하드웨어는 두 개의 킬 카운터 레지스터에 대해 비트 연산(AND, OR, XOR, NOT, 시프트)만 지원합니다. 그래도 `+`나 `-` 없이 둘을 더해야 합니다.

두 정수 `firstCount`와 `secondCount`가 주어졌을 때, 비트 연산만 사용해서 두 수의 합을 반환하는 `combineCounters`를 구현하세요. XOR는 올림 없이 더한 값을 주고, AND에 왼쪽 시프트를 더하면 올림이 되므로, 올림이 0이 될 때까지 반복하면 됩니다.

**예시 1:**
```
Input: firstCount = 12, secondCount = 9
Output: 21
```

**예시 2:**
```
Input: firstCount = -15, secondCount = 4
Output: -11
```$KO$,
    $KO$- `-1500 <= firstCount, secondCount <= 1500`$KO$
);

-- combine-oven-rotations
UPDATE problems SET
    title = $$Merge Leaderboard Runs$$,
    description = $$Two friends each kept a linked list of run times from a racing game, both sorted non-decreasingly. You want one combined list, still sorted, so you can scroll through a single leaderboard.

Implement `combineOvenRotations(runA, runB)` to splice the existing nodes from both lists into one sorted chain and return its head.

**Example 1:**
```
Input: runA = [2,5,9], runB = [3,4,7]
Output: [2,3,4,5,7,9]
Explanation: The times interleave into one sorted leaderboard.
```

**Example 2:**
```
Input: runA = [], runB = []
Output: []
Explanation: Neither friend has a run recorded.
```

**Example 3:**
```
Input: runA = [], runB = [3]
Output: [3]
Explanation: Only the second friend has a time.
```$$,
    constraints = $$- The number of nodes in each list is in the range `[0, 60]`.
- `-100 <= Node.val <= 100`
- Both `runA` and `runB` are sorted in non-decreasing order.$$
WHERE slug = $$combine-oven-rotations$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$combine-oven-rotations$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$combine-oven-rotations$$),
    'ko',
    $KO$리더보드 기록 합치기$KO$,
    $KO$친구 두 명이 각자 레이싱 게임의 랩 타임을 연결 리스트로 정리해 두었는데, 둘 다 오름차순으로 정렬되어 있습니다. 이걸 하나로 합쳐서 정렬된 상태를 유지하는 리더보드를 만들어, 한 번에 쭉 훑어보고 싶습니다.

두 리스트의 기존 노드들을 이어 붙여 정렬된 하나의 체인으로 만드는 `combineOvenRotations(runA, runB)`를 구현하고, 그 헤드를 반환하세요.

**예시 1:**
```
Input: runA = [2,5,9], runB = [3,4,7]
Output: [2,3,4,5,7,9]
Explanation: The times interleave into one sorted leaderboard.
```

**예시 2:**
```
Input: runA = [], runB = []
Output: []
Explanation: Neither friend has a run recorded.
```

**예시 3:**
```
Input: runA = [], runB = [3]
Output: [3]
Explanation: Only the second friend has a time.
```$KO$,
    $KO$- 각 리스트의 노드 개수는 `[0, 60]` 범위 안에 있습니다.
- `-100 <= Node.val <= 100`
- `runA`와 `runB` 모두 오름차순으로 정렬되어 있습니다.$KO$
);

-- compact-shelved-copies
UPDATE problems SET
    title = $$Compact Shelved Copies$$,
    description = $$You're tidying a row of textbooks on a classroom shelf where duplicates sit next to each other in sorted order. You want each title to show up just once at the front of the shelf; what's past that point doesn't matter.

Given a sorted integer array `books`, overwrite the front of `books` with the unique values in their original order and return `k`, the number of uniques. Positions from index `k` onward aren't checked.

**Example 1:**
```
Input: books = [2,2,5]
Output: 2, books = [2,5,_]
Explanation: Return k = 2. The front reads 2 then 5.
```

**Example 2:**
```
Input: books = [1,1,2,2,3,4,4,6,6,6]
Output: 5, books = [1,2,3,4,6,_,_,_,_,_]
Explanation: Five distinct values sit at the front in order.
```

**Example 3:**
```
Input: books = [8]
Output: 1, books = [8]
Explanation: A single-copy shelf is already compact.
```$$,
    constraints = $$- `1 <= books.length <= 2 * 10^5`
- `-100 <= books[i] <= 100`
- `books` is sorted in non-decreasing order.$$
WHERE slug = $$compact-shelved-copies$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$compact-shelved-copies$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$compact-shelved-copies$$),
    'ko',
    $KO$책꽂이 중복 정리$KO$,
    $KO$교실 책꽂이에 같은 제목의 교과서들이 정렬된 순서로 나란히 꽂혀 있습니다. 각 제목이 앞쪽에 한 번씩만 보이도록 정리하려 하고, 그 뒤쪽이 어떻게 되든 상관없습니다.

정렬된 정수 배열 `books`가 주어지면, 원래 순서를 유지한 채 고유한 값들로 `books`의 앞쪽을 덮어쓰고 고유한 값의 개수 `k`를 반환하세요. 인덱스 `k` 이후의 값은 확인하지 않습니다.

**예시 1:**
```
Input: books = [2,2,5]
Output: 2, books = [2,5,_]
Explanation: Return k = 2. The front reads 2 then 5.
```

**예시 2:**
```
Input: books = [1,1,2,2,3,4,4,6,6,6]
Output: 5, books = [1,2,3,4,6,_,_,_,_,_]
Explanation: Five distinct values sit at the front in order.
```

**예시 3:**
```
Input: books = [8]
Output: 1, books = [8]
Explanation: A single-copy shelf is already compact.
```$KO$,
    $KO$- `1 <= books.length <= 2 * 10^5`
- `-100 <= books[i] <= 100`
- `books`는 비내림차순으로 정렬되어 있습니다.$KO$
);

-- compare-pallet-flags
UPDATE problems SET
    title = $$Compare Pallet Flags$$,
    description = $$Two teammates each have a loadout bitmask where each bit is one perk turned on or off. You want to know how many perk slots they disagree on.

Given non-negative integers `leftFlags` and `rightFlags`, return the number of bit positions where the two differ.

**Example 1:**
```
Input: leftFlags = 10, rightFlags = 5
Output: 4
Explanation: 10 is 1010 and 5 is 0101; all four low bits disagree.
```

**Example 2:**
```
Input: leftFlags = 14, rightFlags = 9
Output: 3
Explanation: 14 is 1110 and 9 is 1001; positions 0, 1, and 2 disagree.
```$$,
    constraints = $$- `0 <= leftFlags, rightFlags <= 2.1 * 10^9`$$
WHERE slug = $$compare-pallet-flags$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$compare-pallet-flags$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$compare-pallet-flags$$),
    'ko',
    $KO$장비 플래그 비교하기$KO$,
    $KO$두 팀원이 각자 로드아웃 비트마스크를 가지고 있고, 각 비트는 특정 퍽이 켜졌는지 꺼졌는지를 나타냅니다. 두 사람이 서로 다르게 설정한 퍽 슬롯이 몇 개인지 알고 싶습니다.

음이 아닌 정수 `leftFlags`와 `rightFlags`가 주어지면, 두 값이 서로 다른 비트 위치의 개수를 반환하세요.

**예시 1:**
```
Input: leftFlags = 10, rightFlags = 5
Output: 4
Explanation: 10 is 1010 and 5 is 0101; all four low bits disagree.
```

**예시 2:**
```
Input: leftFlags = 14, rightFlags = 9
Output: 3
Explanation: 14 is 1110 and 9 is 1001; positions 0, 1, and 2 disagree.
```$KO$,
    $KO$- `0 <= leftFlags, rightFlags <= 2.1 * 10^9`$KO$
);

-- contains-topic-branch
UPDATE problems SET
    title = $$Contains Topic Branch$$,
    description = $$Your study group keeps its mind map of class topics as a tree, and a friend hands you a tiny sub-map and asks if it's already tucked inside the big one.

Given the main map `root` and the reference sub-map `subRoot`, return `true` if some node in `root` has a subtree that matches `subRoot` in both shape and values. The entire `root` tree counts as one of its own subtrees. Otherwise return `false`.

**Example 1:**
```
Input: root = [9,6,7,2,4], subRoot = [6,2,4]
Output: true
Explanation: The left child of root is 6, and its subtree [6,2,4] matches subRoot exactly.
```

**Example 2:**
```
Input: root = [1,8,3,null,5], subRoot = [8,5]
Output: false
Explanation: Node 8 appears in root, but its child 5 hangs on the right, while subRoot has 5 on the left, so the shapes don't line up.
```$$,
    constraints = $$- The number of nodes in the `root` tree is in the range `[1, 2000]`.
- The number of nodes in the `subRoot` tree is in the range `[1, 900]`.
- `-8000 <= root.val <= 8000`
- `-8000 <= subRoot.val <= 8000`$$
WHERE slug = $$contains-topic-branch$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$contains-topic-branch$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$contains-topic-branch$$),
    'ko',
    $KO$주제 가지 포함 확인$KO$,
    $KO$스터디 그룹이 수업 주제를 마인드맵으로 정리해 두는데, 친구가 작은 서브맵을 들고 와서 "이게 큰 맵 안에 이미 들어 있어?"라고 물어봅니다.

메인 맵 `root`와 참고용 서브맵 `subRoot`가 주어졌을 때, `root`의 어떤 노드에서 시작한 서브트리가 모양과 값 모두 `subRoot`와 일치하면 `true`를 반환하세요. `root` 트리 전체도 자기 자신의 서브트리로 칩니다. 그 외에는 `false`를 반환합니다.

**예시 1:**
```
Input: root = [9,6,7,2,4], subRoot = [6,2,4]
Output: true
Explanation: The left child of root is 6, and its subtree [6,2,4] matches subRoot exactly.
```

**예시 2:**
```
Input: root = [1,8,3,null,5], subRoot = [8,5]
Output: false
Explanation: Node 8 appears in root, but its child 5 hangs on the right, while subRoot has 5 on the left, so the shapes don't line up.
```$KO$,
    $KO$- `root` 트리의 노드 개수는 `[1, 2000]` 범위 안에 있습니다.
- `subRoot` 트리의 노드 개수는 `[1, 900]` 범위 안에 있습니다.
- `-8000 <= root.val <= 8000`
- `-8000 <= subRoot.val <= 8000`$KO$
);

-- count-assembly-orders
UPDATE problems SET
    title = $$Count Assembly Orders$$,
    description = $$Your group project has `n` sub-tasks numbered `0` through `n - 1`, and each one (except task 0) has one prerequisite task that must be finished first. The dependencies form a tree with `parent[0] = -1` at the root.

Only one person works at a time, so tasks are completed one by one. Return the number of valid finish orders for all `n` tasks, taken modulo `10^8 + 7`.

**Example 1:**
```
Input: parent = [-1,0,0,2,2]
Output: 8
Explanation: Task 0 goes first. Below it, task 1 is a leaf and tasks 3, 4 hang off task 2. Interleaving the two branches yields 8 distinct orders.
```

**Example 2:**
```
Input: parent = [-1,0,1,2,3]
Output: 1
Explanation: The chain 0 -> 1 -> 2 -> 3 -> 4 has only one valid order.
```

**Example 3:**
```
Input: parent = [-1,0,0,0,0]
Output: 24
Explanation: After task 0, the four children can go in any order, giving 4! = 24 sequences.
```$$,
    constraints = $$- `1 <= n <= 2 * 10^5`
- `parent.length == n`
- `parent[0] == -1`
- `0 <= parent[i] < n` for `i >= 1`
- The input is guaranteed to describe a valid rooted tree.$$
WHERE slug = $$count-assembly-orders$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-assembly-orders$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$count-assembly-orders$$),
    'ko',
    $KO$조립 순서 세기$KO$,
    $KO$조별 과제에 `0`부터 `n - 1`까지 번호가 매겨진 `n`개의 세부 과제가 있는데, 과제 0을 제외한 각 과제는 먼저 끝내야 하는 선행 과제 하나를 가집니다. 의존 관계는 `parent[0] = -1`을 루트로 하는 트리를 이룹니다.

한 번에 한 사람만 작업하므로 과제는 하나씩 차례로 마무리됩니다. `n`개 과제에 대해 가능한 완료 순서의 수를 `10^8 + 7`로 나눈 나머지로 반환하세요.

**예시 1:**
```
Input: parent = [-1,0,0,2,2]
Output: 8
Explanation: Task 0 goes first. Below it, task 1 is a leaf and tasks 3, 4 hang off task 2. Interleaving the two branches yields 8 distinct orders.
```

**예시 2:**
```
Input: parent = [-1,0,1,2,3]
Output: 1
Explanation: The chain 0 -> 1 -> 2 -> 3 -> 4 has only one valid order.
```

**예시 3:**
```
Input: parent = [-1,0,0,0,0]
Output: 24
Explanation: After task 0, the four children can go in any order, giving 4! = 24 sequences.
```$KO$,
    $KO$- `1 <= n <= 2 * 10^5`
- `parent.length == n`
- `parent[0] == -1`
- `i >= 1`에 대해 `0 <= parent[i] < n`
- 입력은 유효한 루트 트리를 나타내는 것이 보장됩니다.$KO$
);

-- count-coupon-combos
UPDATE problems SET
    title = $$Count Coupon Combos$$,
    description = $$Your favorite cafe gave you a stack of store-credit coupons in fixed denominations, and you want to hit exactly `amount` won on your next order using any mix of them. Given `amount` and `coupons`, return how many distinct combinations add up to exactly `amount`, where each coupon value may be reused any number of times and order doesn't matter. If no combination works, return `0`.

**Example 1:**
```
Input: amount = 8, coupons = [1,3,4]
Output: 6
Explanation: The six combinations are 1+1+1+1+1+1+1+1, 1+1+1+1+1+3, 1+1+3+3, 1+1+1+1+4, 1+3+4, and 4+4.
```

**Example 2:**
```
Input: amount = 4, coupons = [5]
Output: 0
Explanation: A 5-won coupon alone can never total 4 won.
```$$,
    constraints = $$- `1 <= coupons.length <= 300`
- `1 <= coupons[i] <= 5000`
- All values in `coupons` are distinct
- `0 <= amount <= 5000`$$
WHERE slug = $$count-coupon-combos$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-coupon-combos$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$count-coupon-combos$$),
    'ko',
    $KO$쿠폰 조합 세기$KO$,
    $KO$단골 카페에서 고정 액면가의 스토어 크레딧 쿠폰 뭉치를 받았고, 다음 주문에서 이것들을 아무 조합으로나 써서 정확히 `amount`원을 맞추고 싶습니다. `amount`와 `coupons`가 주어졌을 때, 각 쿠폰 가치를 원하는 만큼 반복 사용할 수 있고 순서가 상관없을 때 정확히 `amount`가 되는 서로 다른 조합의 개수를 반환하세요. 어떤 조합도 맞추지 못하면 `0`을 반환합니다.

**예시 1:**
```
Input: amount = 8, coupons = [1,3,4]
Output: 6
Explanation: The six combinations are 1+1+1+1+1+1+1+1, 1+1+1+1+1+3, 1+1+3+3, 1+1+1+1+4, 1+3+4, and 4+4.
```

**예시 2:**
```
Input: amount = 4, coupons = [5]
Output: 0
Explanation: A 5-won coupon alone can never total 4 won.
```$KO$,
    $KO$- `1 <= coupons.length <= 300`
- `1 <= coupons[i] <= 5000`
- `coupons`의 값은 모두 서로 다릅니다.
- `0 <= amount <= 5000`$KO$
);

-- count-exact-page-quotas
UPDATE problems SET
    title = $$Count Exact Page Quotas$$,
    description = $$Your bulk candy store only sells bags in perfect-square sizes: 1, 4, 9, 16, 25, and so on, and you're willing to buy the same size as many times as you need. Implement `countExactTargets(pages)` to return the fewest bags whose sizes sum to exactly `pages`.

**Example 1:**
```
Input: pages = 7
Output: 4
Explanation: One size-4 bag plus three size-1 bags totals 7. No combo of 1, 2, or 3 square-sized bags hits 7.
```

**Example 2:**
```
Input: pages = 17
Output: 2
Explanation: 17 = 16 + 1.
```

**Example 3:**
```
Input: pages = 5
Output: 2
Explanation: 5 = 4 + 1.
```$$,
    constraints = $$- `1 <= pages <= 12000`$$
WHERE slug = $$count-exact-page-quotas$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-exact-page-quotas$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$count-exact-page-quotas$$),
    'ko',
    $KO$딱 맞는 봉지 개수 세기$KO$,
    $KO$단골 벌크 사탕 가게는 완전제곱 크기의 봉지(1, 4, 9, 16, 25...)만 팝니다. 같은 크기를 몇 번이든 사는 건 자유입니다. 크기를 더해서 정확히 `pages`가 되도록 하는 최소 봉지 개수를 반환하는 `countExactTargets(pages)`를 구현하세요.

**예시 1:**
```
Input: pages = 7
Output: 4
Explanation: One size-4 bag plus three size-1 bags totals 7. No combo of 1, 2, or 3 square-sized bags hits 7.
```

**예시 2:**
```
Input: pages = 17
Output: 2
Explanation: 17 = 16 + 1.
```

**예시 3:**
```
Input: pages = 5
Output: 2
Explanation: 5 = 4 + 1.
```$KO$,
    $KO$- `1 <= pages <= 12000`$KO$
);

-- count-filter-matches
UPDATE problems SET
    title = $$Count Note Matches$$,
    description = $$Your classmate scribbles a long string of letters `notes` during lecture and wants to know how many ways a short hint `target` hides inside it as a subsequence — picking letters in order while skipping any you like. Different choices of skipped positions count as different matches, even if the kept letters look the same.

Given `notes` and `target`, implement `countFilterMatches` to return the total number of subsequence matches. The answer fits in a 64-bit signed integer.

**Example 1:**
```
Input: notes = "ggrrg", target = "grg"
Output: 4
Explanation: Each match picks a g, then a later r, then a later g. Among the g positions (0, 1, 4) and r positions (2, 3), the valid (i, j, k) triples are (0,2,4), (0,3,4), (1,2,4), (1,3,4).
```

**Example 2:**
```
Input: notes = "uvuvu", target = "uu"
Output: 3
Explanation: The u positions are 0, 2, and 4, and choosing any ordered pair gives a match: (0,2), (0,4), (2,4).
```$$,
    constraints = $$- `1 <= notes.length <= 900`
- `1 <= target.length <= 900`
- `notes` and `target` consist of lowercase English letters$$
WHERE slug = $$count-filter-matches$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-filter-matches$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$count-filter-matches$$),
    'ko',
    $KO$노트 매칭 개수 세기$KO$,
    $KO$반 친구가 수업 중 긴 글자 문자열 `notes`를 끄적이다가, 짧은 힌트 `target`이 그 안에 부분수열로 — 순서대로 글자를 고르되 원하는 건 건너뛰면서 — 몇 가지 방법으로 숨어 있는지 알고 싶어합니다. 고른 글자들이 겉보기엔 같더라도, 건너뛴 위치가 다르면 서로 다른 매칭으로 칩니다.

`notes`와 `target`이 주어졌을 때, 총 부분수열 매칭 개수를 반환하는 `countFilterMatches`를 구현하세요. 답은 64비트 부호 있는 정수 범위 안에 들어갑니다.

**예시 1:**
```
Input: notes = "ggrrg", target = "grg"
Output: 4
Explanation: Each match picks a g, then a later r, then a later g. Among the g positions (0, 1, 4) and r positions (2, 3), the valid (i, j, k) triples are (0,2,4), (0,3,4), (1,2,4), (1,3,4).
```

**예시 2:**
```
Input: notes = "uvuvu", target = "uu"
Output: 3
Explanation: The u positions are 0, 2, and 4, and choosing any ordered pair gives a match: (0,2), (0,4), (2,4).
```$KO$,
    $KO$- `1 <= notes.length <= 900`
- `1 <= target.length <= 900`
- `notes`와 `target`은 영어 소문자로 이루어져 있습니다.$KO$
);

-- count-gate-routes
UPDATE problems SET
    title = $$Count Gate Routes$$,
    description = $$You're playing a tile-based dungeon game on a grid with `rows` rows and `cols` columns. Your character starts at the top-left tile and needs to reach the treasure at the bottom-right, and the game only lets you step one tile down or one tile right each turn.

Implement `countGateRoutes` to return the number of distinct paths from start to treasure.

**Example 1:**
```
Input: rows = 4, cols = 5
Output: 35
Explanation: Every path uses exactly 3 down-steps and 4 right-steps in some order, so the count is the number of ways to arrange those 7 moves.
```

**Example 2:**
```
Input: rows = 2, cols = 6
Output: 6
Explanation: With a single down-step required, the path is fully determined by which of the 6 columns that down-step happens in.
```$$,
    constraints = $$- `1 <= rows, cols <= 80`$$
WHERE slug = $$count-gate-routes$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-gate-routes$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$count-gate-routes$$),
    'ko',
    $KO$경로 수 세기$KO$,
    $KO$`rows`행 `cols`열의 격자 위에서 진행되는 타일 기반 던전 게임을 하고 있습니다. 캐릭터는 좌상단 타일에서 출발해 우하단의 보물에 도달해야 하는데, 한 턴에 한 칸 아래로 가거나 한 칸 오른쪽으로만 갈 수 있습니다.

출발지에서 보물까지의 서로 다른 경로 수를 반환하는 `countGateRoutes`를 구현하세요.

**예시 1:**
```
Input: rows = 4, cols = 5
Output: 35
Explanation: Every path uses exactly 3 down-steps and 4 right-steps in some order, so the count is the number of ways to arrange those 7 moves.
```

**예시 2:**
```
Input: rows = 2, cols = 6
Output: 6
Explanation: With a single down-step required, the path is fully determined by which of the 6 columns that down-step happens in.
```$KO$,
    $KO$- `1 <= rows, cols <= 80`$KO$
);

-- count-longest-bake-trail
UPDATE problems SET
    title = $$Count Longest Bake Trail$$,
    description = $$Your friend is pulling cookies off a baking tray and rating each browning as she goes; the ratings land in an array `scores`. She wants to know how many different "best streaks" of strictly-improving ratings she could pick out of that order (skipping cookies is fine, reordering is not).

Return the count of distinct index-sets that form a strictly increasing subsequence of the maximum possible length.

**Example 1:**
```
Input: scores = [2,6,4,5,8]
Output: 1
Explanation: The longest strictly increasing subsequence has length 4: [2,4,5,8]. No other length-4 trail exists.
```

**Example 2:**
```
Input: scores = [3,3,3]
Output: 3
Explanation: No two entries are strictly ordered, so the longest trail has length 1. Each of the three entries alone is a distinct length-1 trail.
```$$,
    constraints = $$- `1 <= scores.length <= 2 * 10^3`
- `-8 * 10^5 <= scores[i] <= 8 * 10^5`$$
WHERE slug = $$count-longest-bake-trail$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-longest-bake-trail$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$count-longest-bake-trail$$),
    'ko',
    $KO$가장 긴 굽기 순서 개수$KO$,
    $KO$친구가 오븐 트레이에서 쿠키를 하나씩 꺼내며 구운 정도를 점수로 매기고, 그 순서가 배열 `scores`에 담깁니다. 친구는 이 순서에서 점수가 계속 엄격히 오르는 "최고의 연속"을 몇 가지 방식으로 뽑을 수 있는지 궁금해합니다. 중간을 건너뛰는 건 되지만, 순서를 바꿀 수는 없어요.

가능한 가장 긴 엄격 증가 부분수열을 이루는 서로 다른 인덱스 집합의 개수를 반환하세요.

**예시 1:**
```
Input: scores = [2,6,4,5,8]
Output: 1
Explanation: 가장 긴 엄격 증가 부분수열은 길이 4짜리 [2,4,5,8]뿐입니다.
```

**예시 2:**
```
Input: scores = [3,3,3]
Output: 3
Explanation: 엄격하게 오르는 쌍이 전혀 없어서 최장 길이는 1입니다. 각 원소 하나하나가 서로 다른 길이-1 경로가 됩니다.
```$KO$,
    $KO$- `1 <= scores.length <= 2 * 10^3`
- `-8 * 10^5 <= scores[i] <= 8 * 10^5`$KO$
);

-- count-mirror-spans
UPDATE problems SET
    title = $$Count Mirror Spans$$,
    description = $$You're bored in class and doodling letters in your notebook as a string `code`. A **mirror span** is any contiguous chunk of `code` that reads the same forwards and backwards — and yes, every single letter counts too.

Implement `countMirrorSpans(code)` to return how many mirror spans `code` contains. Same text at different positions counts as separate spans.

**Example 1:**
```
Input: code = "klmn"
Output: 4
Explanation: No two neighboring letters match, so only the 4 single letters qualify.
```

**Example 2:**
```
Input: code = "rrrr"
Output: 10
Explanation: Every contiguous chunk of the run is a mirror span. Length 4 gives 4 + 3 + 2 + 1 = 10.
```$$,
    constraints = $$- `1 <= code.length <= 1500`
- `code` consists of lowercase English letters.$$
WHERE slug = $$count-mirror-spans$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-mirror-spans$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$count-mirror-spans$$),
    'ko',
    $KO$거울 구간 세기$KO$,
    $KO$수업이 지루해서 공책에 낙서로 글자를 적다 보니 문자열 `code`가 만들어졌습니다. **거울 구간**은 `code`의 연속된 부분 중 앞으로 읽으나 뒤로 읽으나 똑같은 조각을 말합니다. 글자 하나짜리도 당연히 포함돼요.

`code`에 포함된 거울 구간의 개수를 돌려주는 `countMirrorSpans(code)`를 구현하세요. 같은 내용이어도 위치가 다르면 다른 구간으로 셉니다.

**예시 1:**
```
Input: code = "klmn"
Output: 4
Explanation: 이웃한 글자가 서로 다르므로 글자 4개만 조건을 만족합니다.
```

**예시 2:**
```
Input: code = "rrrr"
Output: 10
Explanation: 연속된 모든 조각이 거울 구간입니다. 길이 4짜리 문자열에서 4 + 3 + 2 + 1 = 10개가 나옵니다.
```$KO$,
    $KO$- `1 <= code.length <= 1500`
- `code`는 영어 소문자로만 이루어져 있습니다.$KO$
);

-- count-reservoir-paths
UPDATE problems SET
    title = $$Count Level Hops$$,
    description = $$In a platformer, your character stands at level `0` and needs to reach level `n`, and each jump can cover either 1 level or 2 levels forward. You're curious how many distinct jump sequences land exactly on level `n`.

Implement `countReservoirPaths(n)` to return the count of distinct jump sequences from level `0` to level `n`.

**Example 1:**
```
Input: n = 4
Output: 5
Explanation: The valid sequences are 1+1+1+1, 1+1+2, 1+2+1, 2+1+1, and 2+2.
```

**Example 2:**
```
Input: n = 5
Output: 8
Explanation: There are 8 distinct 1/2 hop sequences that sum to 5.
```$$,
    constraints = $$- `1 <= n <= 40`$$
WHERE slug = $$count-reservoir-paths$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-reservoir-paths$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$count-reservoir-paths$$),
    'ko',
    $KO$레벨 뛰는 경우의 수$KO$,
    $KO$플랫포머 게임에서 캐릭터는 레벨 `0`에 서 있고 레벨 `n`까지 가야 합니다. 한 번의 점프로 1레벨 또는 2레벨 앞으로 나아갈 수 있어요. 레벨 `n`에 정확히 도착하는 서로 다른 점프 순서가 몇 가지인지 궁금합니다.

레벨 `0`에서 레벨 `n`까지의 서로 다른 점프 순서 개수를 반환하는 `countReservoirPaths(n)`을 구현하세요.

**예시 1:**
```
Input: n = 4
Output: 5
Explanation: 1+1+1+1, 1+1+2, 1+2+1, 2+1+1, 2+2.
```

**예시 2:**
```
Input: n = 5
Output: 8
Explanation: 합이 5가 되는 1/2 점프 순서가 8가지 있습니다.
```$KO$,
    $KO$- `1 <= n <= 40`$KO$
);

-- count-scan-decodings
UPDATE problems SET
    title = $$Count Scan Decodings$$,
    description = $$You're playing a retro cipher game where every letter card `A..Z` maps to a number `1..26`, and your friend hands you a string of digits `scan` to decode. Digit groups starting with `0` are invalid since no card has an id like `05`.

Return how many distinct ways you can split `scan` left-to-right into valid ids from `1..26`. The answer is guaranteed to fit in a 32-bit signed integer.

**Example 1:**
```
Input: scan = "1234"
Output: 3
Explanation: Valid splits: (1,2,3,4), (12,3,4), (1,23,4). "1234" as one id is too big, and "12,34" fails because 34 > 26.
```

**Example 2:**
```
Input: scan = "100"
Output: 0
Explanation: The second digit is 0, so it can't start an id, and the trailing 0 has no valid id either.
```$$,
    constraints = $$- `1 <= scan.length <= 120`
- `scan` contains only decimal digits and may include leading or interior zeros.$$
WHERE slug = $$count-scan-decodings$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-scan-decodings$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$count-scan-decodings$$),
    'ko',
    $KO$디코딩 방법 개수$KO$,
    $KO$레트로 암호 게임을 하는 중이고, 글자 카드 `A..Z`가 각각 숫자 `1..26`에 대응합니다. 친구가 숫자 문자열 `scan`을 건네주면 이를 해독해야 해요. `0`으로 시작하는 숫자 묶음은 `05` 같은 id가 없으므로 무효입니다.

`scan`을 왼쪽에서 오른쪽으로 `1..26` 범위의 유효한 id들로 쪼개는 서로 다른 방법의 수를 반환하세요. 답은 32비트 부호 있는 정수에 들어간다고 보장됩니다.

**예시 1:**
```
Input: scan = "1234"
Output: 3
Explanation: 유효한 분할: (1,2,3,4), (12,3,4), (1,23,4). "1234"를 한 id로 보기에는 너무 크고, "12,34"는 34 > 26이라 실패합니다.
```

**예시 2:**
```
Input: scan = "100"
Output: 0
Explanation: 두 번째 자릿수가 0이라 id를 시작할 수 없고, 끝의 0도 유효한 id가 되지 못합니다.
```$KO$,
    $KO$- `1 <= scan.length <= 120`
- `scan`은 십진 숫자로만 이루어져 있으며, 앞이나 중간에 0이 올 수 있습니다.$KO$
);

-- cover-watering-windows
UPDATE problems SET
    title = $$Cover Aquarium Zones$$,
    description = $$You're feeding fish in a long tank, and each species hangs out in a 1D stretch `[start, end]` (inclusive) where its pellets must land. A single pellet dropped at position `x` feeds every species whose zone covers `x`.

Given a list `zones` of these stretches, return the minimum number of pellets needed so every species gets fed at least once.

**Example 1:**
```
Input: zones = [[5,11],[3,9],[8,14],[12,18],[20,25]]
Output: 3
Explanation: Pellets at 9, 18, and 25 work. Position 9 feeds [3,9], [5,11], and [8,14]; 18 feeds [12,18]; 25 feeds [20,25].
```

**Example 2:**
```
Input: zones = [[1,5],[6,10],[11,15]]
Output: 3
Explanation: No two zones overlap, so each needs its own pellet.
```$$,
    constraints = $$- `1 <= zones.length <= 2 * 10^5`
- `zones[i].length == 2`
- `-10^8 <= start <= end <= 10^8`$$
WHERE slug = $$cover-watering-windows$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$cover-watering-windows$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$cover-watering-windows$$),
    'ko',
    $KO$수조 구역 덮기$KO$,
    $KO$길쭉한 수조에서 물고기에게 먹이를 주는 중인데, 각 종은 1차원 구간 `[start, end]`(양 끝 포함)에 머물러서 그 구간 안에 알갱이가 떨어져야 먹습니다. 위치 `x`에 알갱이 하나를 떨어뜨리면 `x`를 포함하는 구간을 가진 모든 종이 먹이를 얻어요.

구간 목록 `zones`가 주어질 때, 모든 종이 최소 한 번은 먹이를 받도록 하는 데 필요한 최소 알갱이 수를 반환하세요.

**예시 1:**
```
Input: zones = [[5,11],[3,9],[8,14],[12,18],[20,25]]
Output: 3
Explanation: 9, 18, 25에 떨어뜨리면 됩니다. 9는 [3,9], [5,11], [8,14]를 덮고, 18은 [12,18], 25는 [20,25]를 덮습니다.
```

**예시 2:**
```
Input: zones = [[1,5],[6,10],[11,15]]
Output: 3
Explanation: 겹치는 구간이 없어 각자 알갱이가 하나씩 필요합니다.
```$KO$,
    $KO$- `1 <= zones.length <= 2 * 10^5`
- `zones[i].length == 2`
- `-10^8 <= start <= end <= 10^8`$KO$
);

-- crush-heaviest-bales
UPDATE problems SET
    title = $$Crush Heaviest Bales$$,
    description = $$In an arcade crush game the machine keeps slamming the two heaviest blocks together. If they weigh `x` and `y` with `x <= y`:

- If `x == y`, both blocks are pulverized.
- If `x != y`, the lighter block is destroyed and the heavier one is reduced to `y - x`.

Repeat until at most one block remains. Given the array `blocks`, return the weight of the last surviving block, or `0` if the pile is empty.

**Example 1:**
```
Input: blocks = [3,6,4,9,5,2]
Output: 1
Explanation:
Crush 9 and 6 -> 3; pile becomes [3,4,5,2,3].
Crush 5 and 4 -> 1; pile becomes [3,2,3,1].
Crush 3 and 3 -> both destroyed; pile becomes [2,1].
Crush 2 and 1 -> 1; pile becomes [1].
```

**Example 2:**
```
Input: blocks = [9]
Output: 9
```$$,
    constraints = $$- `1 <= blocks.length <= 40`
- `1 <= blocks[i] <= 1500`$$
WHERE slug = $$crush-heaviest-bales$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$crush-heaviest-bales$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$crush-heaviest-bales$$),
    'ko',
    $KO$가장 무거운 블록 부수기$KO$,
    $KO$아케이드 크러시 게임에서 기계가 계속 가장 무거운 블록 두 개를 들이박습니다. 두 블록 무게가 `x`, `y` (`x <= y`)일 때,

- `x == y`이면 둘 다 산산조각 납니다.
- `x != y`이면 가벼운 쪽이 파괴되고 무거운 쪽은 `y - x`로 줄어듭니다.

블록이 많아야 하나 남을 때까지 이 과정을 반복합니다. 배열 `blocks`가 주어지면, 마지막까지 남은 블록의 무게를 반환하고 더미가 비면 `0`을 반환하세요.

**예시 1:**
```
Input: blocks = [3,6,4,9,5,2]
Output: 1
Explanation:
9와 6을 부딪쳐 3 -> 더미 [3,4,5,2,3].
5와 4를 부딪쳐 1 -> 더미 [3,2,3,1].
3과 3을 부딪쳐 둘 다 파괴 -> 더미 [2,1].
2와 1을 부딪쳐 1 -> 더미 [1].
```

**예시 2:**
```
Input: blocks = [9]
Output: 9
```$KO$,
    $KO$- `1 <= blocks.length <= 40`
- `1 <= blocks[i] <= 1500`$KO$
);

-- days-to-upgrade
UPDATE problems SET
    title = $$Days To Upgrade$$,
    description = $$You're tracking the daily high temperature on your phone's widget. Given the array `readings` indexed by day, you want to know for each day how many days you have to wait for a **strictly warmer** reading.

Return an array `wait` of the same length where `wait[i]` is the number of days after day `i` until a strictly warmer reading. If no later day is warmer, set `wait[i]` to `0`.

**Example 1:**
```
Input: readings = [55,58,52,50,54,60]
Output: [1,4,2,1,1,0]
Explanation: Day 1 (58) is the next warmer day after day 0. Day 5 (60) is the next warmer day after day 1. No day is warmer than day 5.
```

**Example 2:**
```
Input: readings = [45,45,45,50]
Output: [3,2,1,0]
Explanation: Each of the first three days must wait for day 3 (50), the next strictly warmer reading.
```$$,
    constraints = $$- `1 <= readings.length <= 2 * 10^5`
- `30 <= readings[i] <= 110`$$
WHERE slug = $$days-to-upgrade$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$days-to-upgrade$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$days-to-upgrade$$),
    'ko',
    $KO$기온이 오를 때까지 며칠?$KO$,
    $KO$휴대폰 위젯에 찍히는 일일 최고기온을 기록하고 있습니다. 날짜별로 인덱싱된 배열 `readings`가 주어질 때, 각 날짜에서 **엄격히 더 따뜻한** 기온이 나올 때까지 며칠을 기다려야 하는지 알고 싶습니다.

같은 길이의 배열 `wait`를 반환하세요. `wait[i]`는 `i`일 이후로 엄격히 더 따뜻한 기온이 나올 때까지 지나야 하는 날수이고, 이후에 더 따뜻한 날이 없으면 `wait[i]`를 `0`으로 둡니다.

**예시 1:**
```
Input: readings = [55,58,52,50,54,60]
Output: [1,4,2,1,1,0]
Explanation: Day 1 (58) is the next warmer day after day 0. Day 5 (60) is the next warmer day after day 1. No day is warmer than day 5.
```

**예시 2:**
```
Input: readings = [45,45,45,50]
Output: [3,2,1,0]
Explanation: Each of the first three days must wait for day 3 (50), the next strictly warmer reading.
```$KO$,
    $KO$- `1 <= readings.length <= 2 * 10^5`
- `30 <= readings[i] <= 110`$KO$
);

-- decode-zone-numeral
UPDATE problems SET
    title = $$Decode Zone Numeral$$,
    description = $$Your favorite retro RPG labels its dungeon floors with Roman numerals, and you want to convert a floor tag back into a plain integer. The symbols map:

- `I` = 1, `V` = 5, `X` = 10, `L` = 50, `C` = 100, `D` = 500, `M` = 1000

Symbols read largest-to-smallest left-to-right. When a smaller symbol sits directly before a larger one, the pair subtracts (so `IV` = 4 and `IX` = 9). The valid subtractive pairs are `IV`, `IX`, `XL`, `XC`, `CD`, `CM`.

Given a numeral string `numeral`, return its integer value.

**Example 1:**
```
Input: numeral = "XIV"
Output: 14
Explanation: X + IV = 10 + 4 = 14.
```

**Example 2:**
```
Input: numeral = "CDXLII"
Output: 442
Explanation: CD + XL + II = 400 + 40 + 2 = 442.
```$$,
    constraints = $$- `1 <= numeral.length <= 15`
- `numeral` contains only the characters `I`, `V`, `X`, `L`, `C`, `D`, `M`
- `numeral` is guaranteed to be a valid Roman numeral in the range `[1, 3999]`$$
WHERE slug = $$decode-zone-numeral$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$decode-zone-numeral$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$decode-zone-numeral$$),
    'ko',
    $KO$던전 층수 해독하기$KO$,
    $KO$즐겨 하는 레트로 RPG는 던전 층을 로마 숫자로 표시하는데, 층 태그를 다시 일반 정수로 바꿔보고 싶습니다. 기호 대응은 다음과 같습니다:

- `I` = 1, `V` = 5, `X` = 10, `L` = 50, `C` = 100, `D` = 500, `M` = 1000

기호는 왼쪽에서 오른쪽으로 갈수록 큰 값부터 작은 값 순서로 읽습니다. 작은 기호가 더 큰 기호 바로 앞에 오면 그 쌍은 빼기로 처리됩니다 (즉 `IV`는 4, `IX`는 9). 유효한 빼기 쌍은 `IV`, `IX`, `XL`, `XC`, `CD`, `CM`입니다.

로마 숫자 문자열 `numeral`이 주어지면, 해당 정수 값을 반환하세요.

**예시 1:**
```
Input: numeral = "XIV"
Output: 14
Explanation: X + IV = 10 + 4 = 14.
```

**예시 2:**
```
Input: numeral = "CDXLII"
Output: 442
Explanation: CD + XL + II = 400 + 40 + 2 = 442.
```$KO$,
    $KO$- `1 <= numeral.length <= 15`
- `numeral`은 `I`, `V`, `X`, `L`, `C`, `D`, `M` 문자만 포함합니다
- `numeral`은 `[1, 3999]` 범위의 유효한 로마 숫자임이 보장됩니다$KO$
);

-- deepest-zone-chain
UPDATE problems SET
    title = $$Deepest Zone Chain$$,
    description = $$You're staring at a skill tree in your favorite RPG, where `root` is the starting perk and each branch unlocks deeper skills. You want to know how far the longest chain of unlocks goes.

Return the **maximum depth** of the tree — the number of nodes on the longest path from `root` down to any leaf. An empty tree has depth `0`.

**Example 1:**
```
Input: root = [8,5,12,null,null,9,17]
Output: 3
Explanation: The longest chain runs three perks deep: 8 -> 12 -> 9 or 8 -> 12 -> 17.
```

**Example 2:**
```
Input: root = [4,null,2,null,7]
Output: 3
Explanation: The chain 4 -> 2 -> 7 is three perks deep.
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[0, 8000]`.
- `-100 <= Node.val <= 100`$$
WHERE slug = $$deepest-zone-chain$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$deepest-zone-chain$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$deepest-zone-chain$$),
    'ko',
    $KO$가장 깊은 스킬 체인$KO$,
    $KO$좋아하는 RPG의 스킬 트리를 보고 있습니다. `root`는 시작 퍼크이고 각 가지는 더 깊은 스킬을 해금합니다. 이 해금이 이어지는 가장 긴 체인이 얼마나 깊은지 알고 싶습니다.

트리의 **최대 깊이**, 즉 `root`에서 어떤 리프까지 내려가는 가장 긴 경로 위의 노드 수를 반환하세요. 빈 트리의 깊이는 `0`입니다.

**예시 1:**
```
Input: root = [8,5,12,null,null,9,17]
Output: 3
Explanation: The longest chain runs three perks deep: 8 -> 12 -> 9 or 8 -> 12 -> 17.
```

**예시 2:**
```
Input: root = [4,null,2,null,7]
Output: 3
Explanation: The chain 4 -> 2 -> 7 is three perks deep.
```$KO$,
    $KO$- 트리의 노드 수는 `[0, 8000]` 범위입니다.
- `-100 <= Node.val <= 100`$KO$
);

-- detect-callnumber-clash
UPDATE problems SET
    title = $$Spot the Duplicate Locker$$,
    description = $$You're handing out locker numbers to a homeroom class and want to catch any duplicate assignment before the day starts. Given an integer array `lockers` of the numbers written on each slip, implement `detectClash` to return `true` if any number repeats, else `false`.

**Example 1:**
```
Input: lockers = [7,2,9,7]
Output: true
Explanation: The number 7 shows up at index 0 and index 3.
```

**Example 2:**
```
Input: lockers = [11,22,33,44]
Output: false
Explanation: Every locker number is distinct.
```$$,
    constraints = $$- `1 <= lockers.length <= 2 * 10^5`
- `-10^8 <= lockers[i] <= 10^8`$$
WHERE slug = $$detect-callnumber-clash$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$detect-callnumber-clash$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$detect-callnumber-clash$$),
    'ko',
    $KO$사물함 번호 중복 찾기$KO$,
    $KO$담임 반 학생들에게 사물함 번호를 나눠주려는데, 하루가 시작되기 전에 번호가 중복 배정되었는지 확인하고 싶습니다. 각 쪽지에 적힌 번호를 담은 정수 배열 `lockers`가 주어졌을 때, 같은 번호가 한 번이라도 반복되면 `true`, 아니면 `false`를 반환하도록 `detectClash`를 구현하세요.

**예시 1:**
```
Input: lockers = [7,2,9,7]
Output: true
Explanation: The number 7 shows up at index 0 and index 3.
```

**예시 2:**
```
Input: lockers = [11,22,33,44]
Output: false
Explanation: Every locker number is distinct.
```$KO$,
    $KO$- `1 <= lockers.length <= 2 * 10^5`
- `-10^8 <= lockers[i] <= 10^8`$KO$
);

-- detect-flow-value
UPDATE problems SET
    title = $$Find The Price On The Menu$$,
    description = $$The cafe menu is printed as an `m x n` grid `menu` where prices are sorted: every row goes left-to-right ascending, and each row's first price is bigger than the previous row's last price. Read row by row and you get one sorted list.

Given a price `target`, return `true` if some cell on the menu shows exactly that price, `false` otherwise. Finish in `O(log(m * n))` time so the register doesn't lag.

**Example 1:**
```
Input: menu = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 22
Output: true
Explanation: Row 1, column 2 holds the value 22.
```

**Example 2:**
```
Input: menu = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 9
Output: false
Explanation: No cell shows a price of 9.
```$$,
    constraints = $$- `m == menu.length`
- `n == menu[i].length`
- `1 <= m, n <= 120`
- `|menu[i][j]| <= 10^8`
- `|target| <= 10^8`$$
WHERE slug = $$detect-flow-value$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$detect-flow-value$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$detect-flow-value$$),
    'ko',
    $KO$메뉴판에서 가격 찾기$KO$,
    $KO$카페 메뉴판이 `m x n` 격자 `menu` 형태로 인쇄되어 있고, 가격이 정렬돼 있습니다. 각 행은 왼쪽에서 오른쪽으로 오름차순이고, 어느 행의 첫 가격은 이전 행의 마지막 가격보다 큽니다. 행을 따라 이어 읽으면 하나의 정렬된 목록이 됩니다.

가격 `target`이 주어졌을 때, 메뉴판의 어떤 칸에 정확히 그 가격이 적혀 있으면 `true`, 아니면 `false`를 반환하세요. 계산기가 버벅이지 않도록 `O(log(m * n))` 시간 안에 끝내야 합니다.

**예시 1:**
```
Input: menu = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 22
Output: true
Explanation: Row 1, column 2 holds the value 22.
```

**예시 2:**
```
Input: menu = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 9
Output: false
Explanation: No cell shows a price of 9.
```$KO$,
    $KO$- `m == menu.length`
- `n == menu[i].length`
- `1 <= m, n <= 120`
- `|menu[i][j]| <= 10^8`
- `|target| <= 10^8`$KO$
);

-- detect-transfer-loop
UPDATE problems SET
    title = $$Detect Map Loop$$,
    description = $$In an RPG dungeon, each room points to the next room you get teleported to, and you're worried some portal loops back to an earlier room forever.

Implement `detectTransferLoop(head, pos)` to return `true` when following `next` pointers from `head` ever revisits a room, and `false` otherwise. `pos` is the 0-based index the tail links to (`-1` means no loop); it only helps build the test input and is **not** used by the function.

**Example 1:**
```
Input: head = [8,5,2,6,9], pos = 2
Output: true
Explanation: The tail's next pointer loops back to the room at index 2.
```

**Example 2:**
```
Input: head = [4,7,3], pos = 0
Output: true
Explanation: The last room teleports to the head, forming a full loop.
```

**Example 3:**
```
Input: head = [6,2], pos = -1
Output: false
Explanation: The chain ends cleanly; there's no loop.
```$$,
    constraints = $$- The number of rooms is in the range `[0, 2 * 10^3]`.
- `-8 * 10^4 <= Room.val <= 8 * 10^4`
- `pos` is `-1` or a valid 0-based index into the chain.$$
WHERE slug = $$detect-transfer-loop$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$detect-transfer-loop$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$detect-transfer-loop$$),
    'ko',
    $KO$맵 루프 감지하기$KO$,
    $KO$RPG 던전에서 각 방은 순간이동해서 넘어갈 다음 방을 가리키고 있는데, 어떤 포털이 예전 방으로 영원히 되돌아가는 건 아닐까 걱정됩니다.

`head`부터 `next` 포인터를 따라갔을 때 어떤 방을 다시 방문하게 되면 `true`를, 그렇지 않으면 `false`를 반환하는 `detectTransferLoop(head, pos)`를 구현하세요. `pos`는 꼬리가 연결된 0부터 시작하는 인덱스이며(`-1`이면 루프가 없음), 테스트 입력을 구성할 때만 쓰이고 함수 안에서는 **사용하지 않습니다**.

**예시 1:**
```
Input: head = [8,5,2,6,9], pos = 2
Output: true
Explanation: The tail's next pointer loops back to the room at index 2.
```

**예시 2:**
```
Input: head = [4,7,3], pos = 0
Output: true
Explanation: The last room teleports to the head, forming a full loop.
```

**예시 3:**
```
Input: head = [6,2], pos = -1
Output: false
Explanation: The chain ends cleanly; there's no loop.
```$KO$,
    $KO$- 방의 개수는 `[0, 2 * 10^3]` 범위 안에 있습니다.
- `-8 * 10^4 <= Room.val <= 8 * 10^4`
- `pos`는 `-1`이거나 체인 안의 유효한 0부터 시작하는 인덱스입니다.$KO$
);

-- dock-edge-silhouette
UPDATE problems SET
    title = $$Right-Side View$$,
    description = $$You're staring at a video-game skill tree from the right edge of the screen, and at every tier only the rightmost visible node peeks out — everything behind it is hidden.

Given the `root` of the skill tree, return the value of the rightmost node on each tier, top to bottom. If the tree is empty, return an empty list.

**Example 1:**
```
Input: root = [7,8,9,null,6,null,3]
Output: [7,9,3]
Explanation: Tier 0 shows 7. Tier 1 shows 8 and 9, with 9 on the right. Tier 2 shows 6 and 3, with 3 on the right.
```

**Example 2:**
```
Input: root = [2,null,5]
Output: [2,5]
```

**Example 3:**
```
Input: root = []
Output: []
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[0, 100]`.
- `-100 <= Node.val <= 100`$$
WHERE slug = $$dock-edge-silhouette$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$dock-edge-silhouette$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$dock-edge-silhouette$$),
    'ko',
    $KO$오른쪽에서 본 스킬 트리$KO$,
    $KO$게임 스킬 트리를 화면 오른쪽 끝에서 바라보고 있습니다. 각 단계마다 제일 오른쪽에 있는 노드만 보이고, 그 뒤에 가려진 것들은 안 보입니다.

스킬 트리의 `root`가 주어질 때, 위에서 아래로 각 단계의 가장 오른쪽 노드 값을 반환하세요. 트리가 비어 있으면 빈 리스트를 반환합니다.

**예시 1:**
```
Input: root = [7,8,9,null,6,null,3]
Output: [7,9,3]
Explanation: Tier 0 shows 7. Tier 1 shows 8 and 9, with 9 on the right. Tier 2 shows 6 and 3, with 3 on the right.
```

**예시 2:**
```
Input: root = [2,null,5]
Output: [2,5]
```

**예시 3:**
```
Input: root = []
Output: []
```$KO$,
    $KO$- 트리의 노드 개수는 `[0, 100]` 범위에 있습니다.
- `-100 <= Node.val <= 100`$KO$
);

-- drop-class-conflicts
UPDATE problems SET
    title = $$Drop Class Conflicts$$,
    description = $$You're picking classes for next semester but only one body to sit in them. The list `classes` has each candidate class as `[start, end]` minutes, and two classes conflict only if their windows actually overlap — one ending right when the next starts is fine.

Return the **minimum** number of classes to drop so every class you keep fits without overlap.

**Example 1:**
```
Input: classes = [[1,3],[2,4],[3,5],[1,5]]
Output: 2
Explanation: Keep [1,3] and [3,5]; drop [2,4] and [1,5] to clear every overlap.
```

**Example 2:**
```
Input: classes = [[5,6],[5,6]]
Output: 1
Explanation: Two classes in the same slot — one has to go.
```

**Example 3:**
```
Input: classes = [[1,2],[2,3]]
Output: 0
Explanation: They touch but don't overlap, so you can take both.
```$$,
    constraints = $$- `1 <= classes.length <= 2 * 10^5`
- `classes[i].length == 2`
- `-8 * 10^4 <= start < end <= 8 * 10^4`$$
WHERE slug = $$drop-class-conflicts$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$drop-class-conflicts$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$drop-class-conflicts$$),
    'ko',
    $KO$겹치는 수업 정리하기$KO$,
    $KO$다음 학기 수업을 고르고 있는데 몸은 하나뿐입니다. 리스트 `classes`에는 각 후보 수업이 `[start, end]` 분 단위로 들어 있고, 두 수업은 시간대가 실제로 겹쳐야만 충돌합니다 — 한 수업이 끝나는 순간 바로 다음 수업이 시작되는 건 괜찮습니다.

남긴 모든 수업이 겹치지 않도록 하려면 **최소** 몇 개의 수업을 빼야 하는지 반환하세요.

**예시 1:**
```
Input: classes = [[1,3],[2,4],[3,5],[1,5]]
Output: 2
Explanation: Keep [1,3] and [3,5]; drop [2,4] and [1,5] to clear every overlap.
```

**예시 2:**
```
Input: classes = [[5,6],[5,6]]
Output: 1
Explanation: Two classes in the same slot — one has to go.
```

**예시 3:**
```
Input: classes = [[1,2],[2,3]]
Output: 0
Explanation: They touch but don't overlap, so you can take both.
```$KO$,
    $KO$- `1 <= classes.length <= 2 * 10^5`
- `classes[i].length == 2`
- `-8 * 10^4 <= start < end <= 8 * 10^4`$KO$
);

-- drop-tail-booking
UPDATE problems SET
    title = $$Drop Tail Booking$$,
    description = $$Your favorite cafe tracks today's table reservations as a linked list in the order they were booked, and a regular wants to cancel the `n`-th reservation counted from the end.

Given the `head` of the list and an integer `n`, remove that one booking node and return the updated head.

**Example 1:**
```
Input: head = [10,20,30,40,50,60], n = 3
Output: [10,20,30,50,60]
Explanation: Counting from the end, booking 40 is 3rd; after removing it the list is 10 -> 20 -> 30 -> 50 -> 60.
```

**Example 2:**
```
Input: head = [7], n = 1
Output: []
Explanation: The only booking is cancelled, so the schedule is empty.
```

**Example 3:**
```
Input: head = [4,9], n = 2
Output: [9]
Explanation: The 2nd from the end is the very first booking, so it gets dropped.
```$$,
    constraints = $$- The number of bookings in the list is `sz`.
- `1 <= sz <= 40`
- `0 <= Booking.val <= 100`
- `1 <= n <= sz`$$
WHERE slug = $$drop-tail-booking$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$drop-tail-booking$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$drop-tail-booking$$),
    'ko',
    $KO$뒤에서 N번째 예약 취소$KO$,
    $KO$단골 카페가 오늘의 테이블 예약을 들어온 순서대로 연결 리스트로 관리하는데, 한 단골이 **뒤에서부터** `n`번째 예약을 취소하고 싶어 합니다.

리스트의 `head`와 정수 `n`이 주어졌을 때, 해당 예약 노드 하나를 제거하고 갱신된 헤드를 반환하세요.

**예시 1:**
```
Input: head = [10,20,30,40,50,60], n = 3
Output: [10,20,30,50,60]
Explanation: Counting from the end, booking 40 is 3rd; after removing it the list is 10 -> 20 -> 30 -> 50 -> 60.
```

**예시 2:**
```
Input: head = [7], n = 1
Output: []
Explanation: The only booking is cancelled, so the schedule is empty.
```

**예시 3:**
```
Input: head = [4,9], n = 2
Output: [9]
Explanation: The 2nd from the end is the very first booking, so it gets dropped.
```$KO$,
    $KO$- 리스트의 예약 개수는 `sz`입니다.
- `1 <= sz <= 40`
- `0 <= Booking.val <= 100`
- `1 <= n <= sz`$KO$
);

-- duplicate-catalog-link
UPDATE problems SET
    title = $$Duplicate Catalog Link$$,
    description = $$Your class's friendship map over `n` students labeled `1` through `n` was supposed to be a tree, but somebody added one extra friendship edge and now there's exactly one cycle. The edges are given as `links`, where each `links[i] = [a, b]` is an undirected friendship.

Return the one edge to remove so the graph becomes a tree again. If more than one edge could break the cycle, return the one that appears **last** in `links`.

**Example 1:**
```
Input: links = [[1,2],[2,3],[1,3]]
Output: [1,3]
Explanation: Students 1, 2, and 3 form the cycle 1 - 2 - 3 - 1. Dropping [1,3] leaves the tree 1 - 2 - 3.
```

**Example 2:**
```
Input: links = [[1,2],[2,3],[3,4],[4,5],[2,5],[1,6]]
Output: [2,5]
Explanation: The cycle is 2 - 3 - 4 - 5 - 2. Both [3,4] and [2,5] belong to it, but [2,5] appears later, so it's the one to drop.
```$$,
    constraints = $$- `n == links.length`
- `3 <= n <= 1200`
- `links[i].length == 2`
- `1 <= links[i][0], links[i][1] <= n`
- `links[i][0] != links[i][1]`
- No two links describe the same pair
- The friendship graph is connected and contains exactly one cycle$$
WHERE slug = $$duplicate-catalog-link$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$duplicate-catalog-link$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$duplicate-catalog-link$$),
    'ko',
    $KO$중복된 친구 관계$KO$,
    $KO$`1`부터 `n`까지 번호가 매겨진 `n`명의 학생에 대한 반 친구 관계도는 원래 트리여야 했는데, 누군가 친구 관계 간선을 하나 더 넣어버려서 지금은 정확히 하나의 순환이 생겼습니다. 간선은 `links`로 주어지며, 각 `links[i] = [a, b]`는 방향이 없는 친구 관계입니다.

다시 트리가 되도록 제거해야 할 간선 하나를 반환하세요. 순환을 끊을 수 있는 간선이 여러 개면 `links`에서 **가장 나중에** 등장하는 간선을 반환하세요.

**예시 1:**
```
Input: links = [[1,2],[2,3],[1,3]]
Output: [1,3]
Explanation: Students 1, 2, and 3 form the cycle 1 - 2 - 3 - 1. Dropping [1,3] leaves the tree 1 - 2 - 3.
```

**예시 2:**
```
Input: links = [[1,2],[2,3],[3,4],[4,5],[2,5],[1,6]]
Output: [2,5]
Explanation: The cycle is 2 - 3 - 4 - 5 - 2. Both [3,4] and [2,5] belong to it, but [2,5] appears later, so it's the one to drop.
```$KO$,
    $KO$- `n == links.length`
- `3 <= n <= 1200`
- `links[i].length == 2`
- `1 <= links[i][0], links[i][1] <= n`
- `links[i][0] != links[i][1]`
- 같은 쌍을 가리키는 간선은 없습니다.
- 친구 관계 그래프는 연결되어 있고 정확히 하나의 순환을 가집니다.$KO$
);

-- duplicate-topic-web
UPDATE problems SET
    title = $$Duplicate Topic Web$$,
    description = $$Your guild's quest log is a linked chain of missions where each entry has a `next` pointer to the following mission and a `related` pointer that jumps to another mission in the log (or is `null`). You want a clean backup copy of the whole log so you can mess with it freely.

Given the head of the list, return the head of a deep copy. The copy must have exactly `n` brand-new nodes, and every `next` and `related` pointer must reference nodes inside the copy only.

The stdin input is an array of pairs `[val, related_index]`, where `related_index` is the 0-based index of the mission the `related` pointer targets, or `null`.

**Example 1:**
```
Input: head = [[9,2],[4,null],[6,0],[2,1]]
Output: [[9,2],[4,null],[6,0],[2,1]]
Explanation: Four missions are cloned; each related pointer is rewired to the matching copy.
```

**Example 2:**
```
Input: head = [[5,0]]
Output: [[5,0]]
Explanation: The single node's related pointer loops back to itself in the clone.
```

**Example 3:**
```
Input: head = [[3,null],[7,null]]
Output: [[3,null],[7,null]]
```$$,
    constraints = $$- `0 <= n <= 1200`
- `-8 * 10^4 <= Node.val <= 8 * 10^4`
- `Node.related` is either `null` or a pointer to some node in the web.$$
WHERE slug = $$duplicate-topic-web$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$duplicate-topic-web$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$duplicate-topic-web$$),
    'ko',
    $KO$퀘스트 로그 복제$KO$,
    $KO$길드 퀘스트 로그는 미션 체인으로 이어져 있고, 각 항목에는 다음 미션을 가리키는 `next` 포인터와 로그 안의 다른 미션으로 점프하는 `related` 포인터가 있습니다(`null`일 수도 있음). 로그 전체를 자유롭게 갖고 놀 수 있도록 깔끔한 백업 사본을 만들고 싶습니다.

리스트의 헤드가 주어졌을 때, 깊은 복사본의 헤드를 반환하세요. 사본은 정확히 `n`개의 완전히 새로운 노드를 가져야 하고, 모든 `next`와 `related` 포인터는 오직 사본 안의 노드만 가리켜야 합니다.

표준 입력은 `[val, related_index]` 쌍의 배열이며, `related_index`는 `related` 포인터가 가리키는 미션의 0부터 시작하는 인덱스이거나 `null`입니다.

**예시 1:**
```
Input: head = [[9,2],[4,null],[6,0],[2,1]]
Output: [[9,2],[4,null],[6,0],[2,1]]
Explanation: Four missions are cloned; each related pointer is rewired to the matching copy.
```

**예시 2:**
```
Input: head = [[5,0]]
Output: [[5,0]]
Explanation: The single node's related pointer loops back to itself in the clone.
```

**예시 3:**
```
Input: head = [[3,null],[7,null]]
Output: [[3,null],[7,null]]
```$KO$,
    $KO$- `0 <= n <= 1200`
- `-8 * 10^4 <= Node.val <= 8 * 10^4`
- `Node.related`는 `null`이거나 웹 안의 어떤 노드를 가리키는 포인터입니다.$KO$
);

-- enumerate-barrel-blends
UPDATE problems SET
    title = $$Enumerate Barrel Blends$$,
    description = $$You and your friends are mixing up custom trail-mix jars and want to list every possible combo you could scoop from a set of distinctly numbered cereal bins. Every subset counts, including the empty scoop and the full dump of all bins.

Given an array `barrels` of distinct bin IDs, return every possible combo. The outer list can be in any order, but each inner combo must keep the relative order from `barrels`.

**Example 1:**
```
Input: barrels = [2,5,8]
Output: [[],[2],[2,5],[2,5,8],[2,8],[5],[5,8],[8]]
Explanation: With 3 bins there are 2^3 = 8 combos.
```

**Example 2:**
```
Input: barrels = [7]
Output: [[],[7]]
```$$,
    constraints = $$- `1 <= barrels.length <= 10`
- `-10 <= barrels[i] <= 10`
- All entries of `barrels` are distinct.$$
WHERE slug = $$enumerate-barrel-blends$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$enumerate-barrel-blends$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$enumerate-barrel-blends$$),
    'ko',
    $KO$시리얼 조합 나열하기$KO$,
    $KO$친구들과 맞춤 트레일 믹스 병을 만들고 있는데, 서로 다른 번호가 붙은 시리얼 통들에서 퍼낼 수 있는 모든 조합을 나열하고 싶습니다. 아무것도 안 퍼내는 빈 조합도, 전부 다 퍼내는 조합도 포함해서 모든 부분집합을 셉니다.

서로 다른 통 ID들의 배열 `barrels`가 주어졌을 때, 가능한 모든 조합을 반환하세요. 바깥 리스트의 순서는 상관없지만, 각 안쪽 조합은 `barrels`에서의 상대 순서를 유지해야 합니다.

**예시 1:**
```
Input: barrels = [2,5,8]
Output: [[],[2],[2,5],[2,5,8],[2,8],[5],[5,8],[8]]
Explanation: With 3 bins there are 2^3 = 8 combos.
```

**예시 2:**
```
Input: barrels = [7]
Output: [[],[7]]
```$KO$,
    $KO$- `1 <= barrels.length <= 10`
- `-10 <= barrels[i] <= 10`
- `barrels`의 모든 값은 서로 다릅니다.$KO$
);

-- event-window-tally
UPDATE problems SET
    title = $$Battery Window Tally$$,
    description = $$You logged your phone's hourly battery swings in `readings` — positive when it gained charge, negative when it drained, zero when it held steady. You're curious how many contiguous stretches net out to exactly `k`.

Given the array `readings` and integer `k`, implement `countWindowTallies` to return the number of contiguous subarrays whose values sum to `k`. Since readings may be negative, a plain sliding window won't cut it.

**Example 1:**
```
Input: readings = [2,2,2], k = 4
Output: 2
Explanation: The windows readings[0..1] and readings[1..2] each sum to 4.
```

**Example 2:**
```
Input: readings = [3,1,2,4], k = 6
Output: 2
Explanation: The windows [3,1,2] and [2,4] both sum to 6.
```

**Example 3:**
```
Input: readings = [4,-4,0], k = 0
Output: 3
Explanation: [4,-4], [4,-4,0], and [0] each sum to 0.
```$$,
    constraints = $$- `1 <= readings.length <= 2 * 10^5`
- `-1000 <= readings[i] <= 1000`
- `-10^7 <= k <= 10^7`$$
WHERE slug = $$event-window-tally$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$event-window-tally$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$event-window-tally$$),
    'ko',
    $KO$배터리 변동 구간 세기$KO$,
    $KO$휴대폰 배터리의 시간별 변동을 `readings`에 기록해 두었습니다. 양수면 충전, 음수면 방전, `0`이면 그대로입니다. 값을 다 더했을 때 정확히 `k`가 되는 연속 구간이 몇 개나 되는지 궁금합니다.

배열 `readings`와 정수 `k`가 주어졌을 때, 값의 합이 `k`인 연속 부분 배열의 개수를 반환하는 `countWindowTallies`를 구현하세요. 값이 음수일 수 있기 때문에 단순 슬라이딩 윈도우로는 안 됩니다.

**예시 1:**
```
Input: readings = [2,2,2], k = 4
Output: 2
Explanation: The windows readings[0..1] and readings[1..2] each sum to 4.
```

**예시 2:**
```
Input: readings = [3,1,2,4], k = 6
Output: 2
Explanation: The windows [3,1,2] and [2,4] both sum to 6.
```

**예시 3:**
```
Input: readings = [4,-4,0], k = 0
Output: 3
Explanation: [4,-4], [4,-4,0], and [0] each sum to 0.
```$KO$,
    $KO$- `1 <= readings.length <= 2 * 10^5`
- `-1000 <= readings[i] <= 1000`
- `-10^7 <= k <= 10^7`$KO$
);

-- fanout-responder-reach
UPDATE problems SET
    title = $$Fanout Feeder Reach$$,
    description = $$Your apartment complex has a grid of rooms where some rooms host cat feeders and the hungry strays want to know how far each room is from the nearest one. The `m x n` grid `grid` holds one of three values per room:

- `-1` — a **locked room** (cats can't pass through)
- `0` — a **feeder room** (food is here)
- `2147483647` — an **open room** waiting to be measured

Replace each open room with the number of 4-directional steps to the nearest feeder, moving only up, down, left, or right across open rooms. If an open room can't reach any feeder, leave it at `2147483647`. Update `grid` in place and return it.

**Example 1:**
```
Input: grid = [[2147483647,0,-1,2147483647],[2147483647,2147483647,2147483647,2147483647],[-1,2147483647,0,2147483647],[2147483647,2147483647,2147483647,-1]]
Output: [[1,0,-1,3],[2,1,1,2],[-1,2,0,1],[3,2,1,-1]]
Explanation: Feeders sit at (0,1) and (2,2). Each open room gets its step count to the closer feeder; (0,3) is three steps from (0,1) because (0,2) is locked.
```

**Example 2:**
```
Input: grid = [[0,2147483647,2147483647],[-1,2147483647,-1],[2147483647,2147483647,0]]
Output: [[0,1,2],[-1,2,-1],[2,1,0]]
Explanation: The locked rooms in the middle row force a detour, but every open room still reaches a feeder.
```$$,
    constraints = $$- `1 <= m, n <= 250`
- `grid[i][j]` is `-1`, `0`, or `2147483647`.$$
WHERE slug = $$fanout-responder-reach$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$fanout-responder-reach$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$fanout-responder-reach$$),
    'ko',
    $KO$급식대까지 최소 거리$KO$,
    $KO$아파트 단지의 방들이 격자로 놓여 있고, 몇몇 방에는 고양이 급식대가 있고 배고픈 길냥이들은 각 방이 가장 가까운 급식대에서 몇 걸음 떨어져 있는지 알고 싶어합니다. `m x n` 격자 `grid`의 각 방은 세 값 중 하나입니다.

- `-1` — **잠긴 방**(고양이가 지나갈 수 없음)
- `0` — **급식대 방**(먹이가 여기 있음)
- `2147483647` — 아직 측정되지 않은 **열린 방**

각 열린 방을 가장 가까운 급식대까지 상하좌우 4방향으로 이동한 걸음 수로 바꾸세요. 이동은 오직 열린 방들을 통해서만 가능합니다. 어떤 급식대에도 닿을 수 없는 열린 방은 `2147483647` 그대로 둡니다. `grid`를 제자리에서 갱신하고 반환하세요.

**예시 1:**
```
Input: grid = [[2147483647,0,-1,2147483647],[2147483647,2147483647,2147483647,2147483647],[-1,2147483647,0,2147483647],[2147483647,2147483647,2147483647,-1]]
Output: [[1,0,-1,3],[2,1,1,2],[-1,2,0,1],[3,2,1,-1]]
Explanation: Feeders sit at (0,1) and (2,2). Each open room gets its step count to the closer feeder; (0,3) is three steps from (0,1) because (0,2) is locked.
```

**예시 2:**
```
Input: grid = [[0,2147483647,2147483647],[-1,2147483647,-1],[2147483647,2147483647,0]]
Output: [[0,1,2],[-1,2,-1],[2,1,0]]
Explanation: The locked rooms in the middle row force a detour, but every open room still reaches a feeder.
```$KO$,
    $KO$- `1 <= m, n <= 250`
- `grid[i][j]`는 `-1`, `0`, 또는 `2147483647`입니다.$KO$
);

-- feed-designer
UPDATE problems SET
    title = $$Short-Post Feed$$,
    description = $$You and your gaming friends share short in-game status posts on a hangout board. Build the `MicroFeed` class so players can post, follow each other, and pull up a newest-first list of posts they care about.

- `MicroFeed()` — starts an empty board with no players, follows, or posts.
- `publishPost(int userId, int messageId)` — player `userId` posts snippet `messageId`. Every `messageId` is globally unique and arrives in post order.
- `List<Integer> latestFeed(int userId)` — returns up to the ten most recent message IDs visible to `userId`: their own posts plus anyone they currently follow, newest first.
- `subscribe(int followerId, int followeeId)` — `followerId` starts following `followeeId`. If the IDs match, it's a no-op.
- `unsubscribe(int followerId, int followeeId)` — `followerId` stops following `followeeId`. If the IDs match or the follow isn't active, it's a no-op.

**Example 1:**
```
Input: ["MicroFeed","publishPost","publishPost","latestFeed"]
       [[],[1,10],[1,20],[1]]
Output: [null,null,null,[20,10]]
```
Player 1 posts twice and sees them newest-first.

**Example 2:**
```
Input: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed"]
       [[],[1,10],[2,20],[1,2],[1]]
Output: [null,null,null,null,[20,10]]
```
Once player 1 follows player 2, player 2's post shows up.

**Example 3:**
```
Input: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed","unsubscribe","latestFeed"]
       [[],[1,10],[2,20],[1,2],[1],[1,2],[1]]
Output: [null,null,null,null,[20,10],null,[10]]
```
Unfollowing immediately drops player 2's post from player 1's feed.$$,
    constraints = $$- `1 <= userId, followerId, followeeId <= 500`
- `0 <= messageId <= 8000`
- At most `20000` calls total will be made across `publishPost`, `latestFeed`, `subscribe`, and `unsubscribe`.$$
WHERE slug = $$feed-designer$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$feed-designer$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$feed-designer$$),
    'ko',
    $KO$짧은 글 피드$KO$,
    $KO$당신과 게임 친구들은 소소한 게임 상태 글을 친목 보드에 올립니다. 플레이어들이 글을 쓰고, 서로 팔로우하고, 관심 있는 글만 최신순으로 볼 수 있도록 `MicroFeed` 클래스를 만들어 주세요.

- `MicroFeed()` — 플레이어도 팔로우도 글도 없는 빈 보드로 시작합니다.
- `publishPost(int userId, int messageId)` — 플레이어 `userId`가 `messageId`라는 짧은 글을 올립니다. `messageId`는 전역에서 유일하고 호출 순서대로 들어옵니다.
- `List<Integer> latestFeed(int userId)` — `userId`가 볼 수 있는 최신 메시지 id를 최대 10개까지 최신순으로 반환합니다. 본인 글과 지금 팔로우 중인 사람들의 글이 섞여 들어갑니다.
- `subscribe(int followerId, int followeeId)` — `followerId`가 `followeeId`를 팔로우합니다. 두 id가 같으면 아무 일도 하지 않습니다.
- `unsubscribe(int followerId, int followeeId)` — `followerId`가 `followeeId` 팔로우를 끊습니다. 두 id가 같거나 원래 팔로우 상태가 아니었다면 아무 일도 하지 않습니다.

**예시 1:**
```
Input: ["MicroFeed","publishPost","publishPost","latestFeed"]
       [[],[1,10],[1,20],[1]]
Output: [null,null,null,[20,10]]
```
플레이어 1이 두 번 글을 올리고, 자기 글을 최신순으로 봅니다.

**예시 2:**
```
Input: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed"]
       [[],[1,10],[2,20],[1,2],[1]]
Output: [null,null,null,null,[20,10]]
```
플레이어 1이 플레이어 2를 팔로우하면, 2의 글이 바로 보이기 시작합니다.

**예시 3:**
```
Input: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed","unsubscribe","latestFeed"]
       [[],[1,10],[2,20],[1,2],[1],[1,2],[1]]
Output: [null,null,null,null,[20,10],null,[10]]
```
언팔하자마자 플레이어 2의 글은 1의 피드에서 사라집니다.$KO$,
    $KO$- `1 <= userId, followerId, followeeId <= 500`
- `0 <= messageId <= 8000`
- `publishPost`, `latestFeed`, `subscribe`, `unsubscribe` 호출은 전체 합쳐 최대 `20000`번 일어납니다.$KO$
);

-- fewest-bag-sizes
UPDATE problems SET
    title = $$Fewest Bag Sizes$$,
    description = $$You're packing candy for a movie night and the pantry has a few bag sizes on the shelf, each holding an exact number of pieces. You want to hand out exactly `quota` pieces using the fewest bags, grabbing unlimited bags of any size.

Implement `fewestBagSizes(bagSizes, quota)` to return the minimum number of bags that sum to `quota`, or `-1` if no combination works.

**Example 1:**
```
Input: bagSizes = [2,4,7], quota = 15
Output: 3
Explanation: Using bags of size 4, 4, and 7 totals 15 pieces with three bags. No pair of bags from the catalog sums to 15, so three is the minimum.
```

**Example 2:**
```
Input: bagSizes = [3,5], quota = 4
Output: -1
Explanation: No combination of bags with capacities 3 and 5 sums to exactly 4 pieces.
```$$,
    constraints = $$- `1 <= bagSizes.length <= 12`
- `1 <= bagSizes[i] <= 10^8`
- `0 <= quota <= 8000`$$
WHERE slug = $$fewest-bag-sizes$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$fewest-bag-sizes$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$fewest-bag-sizes$$),
    'ko',
    $KO$최소 봉지 수$KO$,
    $KO$영화의 밤을 위해 사탕을 나눠 담으려는데, 찬장에 크기가 정해진 봉지 몇 종류가 쌓여 있습니다. 봉지 종류별 갯수는 무제한이고, 정확히 `quota`개의 사탕을 담을 때 봉지를 가장 적게 쓰고 싶어요.

`bagSizes`의 봉지들로 합이 `quota`가 되도록 만드는 최소 봉지 수를 반환하는 `fewestBagSizes(bagSizes, quota)`를 구현하세요. 만들 수 없으면 `-1`을 반환합니다.

**예시 1:**
```
Input: bagSizes = [2,4,7], quota = 15
Output: 3
Explanation: 4, 4, 7 크기 봉지 세 개로 15개를 맞춥니다. 두 봉지로 15를 만들 수는 없으므로 3이 최소입니다.
```

**예시 2:**
```
Input: bagSizes = [3,5], quota = 4
Output: -1
Explanation: 3과 5 크기 봉지의 어떤 조합으로도 4를 만들 수 없습니다.
```$KO$,
    $KO$- `1 <= bagSizes.length <= 12`
- `1 <= bagSizes[i] <= 10^8`
- `0 <= quota <= 8000`$KO$
);

-- fewest-van-hops
UPDATE problems SET
    title = $$Fewest Van Hops$$,
    description = $$You're playing a platformer with `n` tiles numbered `0` through `n - 1`, and your character starts on tile `0`. The array `fuel` tells you the max forward jump from each tile: from tile `i` you can land on any tile in `[i + 1, i + fuel[i]]`.

Write `minVanHops(fuel)` that returns the fewest jumps needed to reach tile `n - 1`. The level is guaranteed beatable, so you never have to report failure.

**Example 1:**
```
Input: fuel = [1,4,2,1,3,1,2]
Output: 3
Explanation: Jump from tile 0 to tile 1. From tile 1 you can reach tile 5, so jump to tile 4. From tile 4 you can reach tile 6, the goal.
```

**Example 2:**
```
Input: fuel = [3,1,1,4,2,1]
Output: 2
Explanation: Jump from tile 0 straight to tile 3 (within reach 3). From tile 3 you can reach tile 7, which covers tile 5.
```$$,
    constraints = $$- `1 <= fuel.length <= 2 * 10^3`
- `0 <= fuel[i] <= 1000`
- The final tile is guaranteed to be reachable from tile `0`.$$
WHERE slug = $$fewest-van-hops$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$fewest-van-hops$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$fewest-van-hops$$),
    'ko',
    $KO$최소 점프 횟수$KO$,
    $KO$`n`개의 타일이 `0`부터 `n - 1`까지 번호 붙어 있는 플랫포머를 플레이 중이고, 캐릭터는 타일 `0`에서 출발합니다. `fuel` 배열은 각 타일에서 앞으로 최대 몇 칸까지 뛸 수 있는지를 알려줘요. 타일 `i`에서는 `[i + 1, i + fuel[i]]` 범위의 타일 중 아무 데로나 착지할 수 있습니다.

타일 `n - 1`에 도달하는 최소 점프 횟수를 반환하는 `minVanHops(fuel)`을 작성하세요. 레벨은 반드시 클리어 가능하다고 보장되므로 실패 처리는 필요 없습니다.

**예시 1:**
```
Input: fuel = [1,4,2,1,3,1,2]
Output: 3
Explanation: 타일 0에서 1로 점프. 타일 1에서는 타일 5까지 닿으니 타일 4로 뜁니다. 타일 4에서는 타일 6(목표)까지 닿습니다.
```

**예시 2:**
```
Input: fuel = [3,1,1,4,2,1]
Output: 2
Explanation: 타일 0에서 타일 3까지 한 번에 점프(사정거리 3). 타일 3에서는 타일 7까지 닿으니 타일 5를 덮습니다.
```$KO$,
    $KO$- `1 <= fuel.length <= 2 * 10^3`
- `0 <= fuel[i] <= 1000`
- 마지막 타일은 타일 `0`에서 도달 가능하다고 보장됩니다.$KO$
);

-- finish-assembly-line
UPDATE problems SET
    title = $$Finish the Level$$,
    description = $$You're speedrunning a platformer level made of `n` tiles, starting on tile `0`, where `slack[i]` is the max jump length from tile `i`. A `0` means that tile is a pit and you can't jump anywhere from there.

Write `canFinishLine(slack)` that returns `true` if you can reach the final tile `n - 1` from tile `0`, and `false` otherwise.

**Example 1:**
```
Input: slack = [2,1,3,1,1,2]
Output: true
Explanation: Route 0 -> 2 (jump 2), 2 -> 5 (jump 3). Tile 5 is the final tile.
```

**Example 2:**
```
Input: slack = [2,0,0,1,3]
Output: false
Explanation: From tile 0 you can only reach tiles 1 or 2, both pits. Tile 3 is unreachable.
```$$,
    constraints = $$- `1 <= slack.length <= 2 * 10^5`
- `0 <= slack[i] <= 8 * 10^4`$$
WHERE slug = $$finish-assembly-line$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$finish-assembly-line$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$finish-assembly-line$$),
    'ko',
    $KO$레벨 클리어 가능?$KO$,
    $KO$`n`개의 타일로 이루어진 플랫포머 레벨을 스피드런 중입니다. 타일 `0`에서 시작하고, `slack[i]`는 타일 `i`에서 뛸 수 있는 최대 점프 길이예요. `0`은 그 타일이 구덩이여서 거기서는 뛸 수 없다는 뜻입니다.

타일 `0`에서 마지막 타일 `n - 1`에 닿을 수 있으면 `true`, 아니면 `false`를 반환하는 `canFinishLine(slack)`을 작성하세요.

**예시 1:**
```
Input: slack = [2,1,3,1,1,2]
Output: true
Explanation: 경로 0 -> 2(점프 2), 2 -> 5(점프 3). 타일 5가 마지막 타일입니다.
```

**예시 2:**
```
Input: slack = [2,0,0,1,3]
Output: false
Explanation: 타일 0에서는 타일 1이나 2로만 갈 수 있는데 둘 다 구덩이라 타일 3에 닿지 못합니다.
```$KO$,
    $KO$- `1 <= slack.length <= 2 * 10^5`
- `0 <= slack[i] <= 8 * 10^4`$KO$
);

-- flag-material-codes
UPDATE problems SET
    title = $$Flag Material Codes$$,
    description = $$You're playing a word-search game on an `m x n` letter `board`, and you've got a list of `targetWords` to hunt down. A word counts as found if its letters appear along a path of horizontally or vertically adjacent cells, and the path never reuses the same cell twice.

Return every word from `targetWords` that can be traced on the board, sorted in lexicographic order. Each word appears at most once in the result even if it can be traced in multiple ways.

**Example 1:**
```
Input: board = [["c","o","d","e"],["h","a","t","s"],["i","r","n","m"],["p","u","a","l"]], targetWords = ["code","chat","maze","nail"]
Output: ["chat","code"]
```

**Example 2:**
```
Input: board = [["p","a"],["g","c"]], targetWords = ["pcg"]
Output: []
```$$,
    constraints = $$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 12`
- `board[i][j]` is a lowercase English letter.
- `1 <= targetWords.length <= 8 * 10^4`
- `1 <= targetWords[i].length <= 10`
- `targetWords[i]` consists of lowercase English letters.
- All the strings in `targetWords` are unique.$$
WHERE slug = $$flag-material-codes$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$flag-material-codes$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$flag-material-codes$$),
    'ko',
    $KO$단어 찾기 목록$KO$,
    $KO$`m x n` 글자판 `board` 위에서 단어 찾기 게임을 하며, 사냥할 단어 리스트 `targetWords`가 있습니다. 어떤 단어의 글자들이 가로 또는 세로로 인접한 칸을 잇는 경로 위에 나타나고, 같은 칸을 두 번 이상 쓰지 않는다면 그 단어는 찾은 것으로 칩니다.

`targetWords` 중 보드에서 추적 가능한 단어들을 사전식 오름차순으로 반환하세요. 같은 단어가 여러 경로로 추적되어도 결과에는 한 번만 들어갑니다.

**예시 1:**
```
Input: board = [["c","o","d","e"],["h","a","t","s"],["i","r","n","m"],["p","u","a","l"]], targetWords = ["code","chat","maze","nail"]
Output: ["chat","code"]
```

**예시 2:**
```
Input: board = [["p","a"],["g","c"]], targetWords = ["pcg"]
Output: []
```$KO$,
    $KO$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 12`
- `board[i][j]`는 영어 소문자입니다.
- `1 <= targetWords.length <= 8 * 10^4`
- `1 <= targetWords[i].length <= 10`
- `targetWords[i]`는 영어 소문자로 이루어져 있습니다.
- `targetWords`의 모든 문자열은 서로 다릅니다.$KO$
);

-- flights-by-tier
UPDATE problems SET
    title = $$Group By Level$$,
    description = $$Your RPG guild is stored as a binary tree, with the guildmaster at the root and ranks branching downward. You want to print each rank as its own row, top rank first.

Given the `root` of the guild tree, implement `groupByTier` to return the values level by level, each inner list ordered from left to right. Return an empty list if the tree is empty.

**Example 1:**
```
Input: root = [10,5,15,null,null,12,20]
Output: [[10],[5,15],[12,20]]
Explanation: Rank 0 has 10. Rank 1 has 5 and 15. Rank 2 has 12 and 20.
```

**Example 2:**
```
Input: root = [42]
Output: [[42]]
Explanation: A lone guildmaster makes a single row.
```

**Example 3:**
```
Input: root = []
Output: []
```$$,
    constraints = $$- The number of nodes in the guild tree is in the range `[0, 2 * 10^3]`.
- `-1000 <= Node.val <= 1000`$$
WHERE slug = $$flights-by-tier$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$flights-by-tier$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$flights-by-tier$$),
    'ko',
    $KO$계급별 모으기$KO$,
    $KO$RPG 길드가 이진 트리로 표현되고, 길드 마스터가 루트에 있고 계급은 아래로 가지를 뻗습니다. 각 계급을 한 줄씩, 최상위 계급부터 출력하고 싶어요.

길드 트리의 `root`가 주어질 때, 계급별로 값을 반환하는 `groupByTier`를 구현하세요. 각 내부 리스트는 왼쪽에서 오른쪽 순서여야 합니다. 트리가 비어 있으면 빈 리스트를 반환합니다.

**예시 1:**
```
Input: root = [10,5,15,null,null,12,20]
Output: [[10],[5,15],[12,20]]
Explanation: 계급 0은 10, 계급 1은 5와 15, 계급 2는 12와 20입니다.
```

**예시 2:**
```
Input: root = [42]
Output: [[42]]
Explanation: 길드 마스터 혼자뿐이라 한 줄짜리 결과입니다.
```

**예시 3:**
```
Input: root = []
Output: []
```$KO$,
    $KO$- 길드 트리의 노드 수는 `[0, 2 * 10^3]` 범위입니다.
- `-1000 <= Node.val <= 1000`$KO$
);

-- flip-sorter-segments
UPDATE problems SET
    title = $$Flip Sorter Segments$$,
    description = $$You have a linked list of power-ups and want to flip it in chunks of `k`. Take consecutive runs of length `k` and **reverse each run end-for-end** in place; any trailing chunk shorter than `k` is left alone.

Return the head of the reworked list. Node values must not be mutated — only the `next` pointers may be rewired.

**Example 1:**
```
Input: head = [10,20,30,40,50,60,70], k = 3
Output: [30,20,10,60,50,40,70]
Explanation: The first run (10,20,30) flips to (30,20,10); the next run (40,50,60) flips to (60,50,40); the trailing 70 stands alone.
```

**Example 2:**
```
Input: head = [5,15,25,35], k = 4
Output: [35,25,15,5]
Explanation: Exactly one run of length 4 is reversed in full.
```

**Example 3:**
```
Input: head = [2,4,6,8,10], k = 1
Output: [2,4,6,8,10]
Explanation: With k = 1 each run is a single node, so the list is unchanged.
```$$,
    constraints = $$- The number of nodes in the list is `n`.
- `1 <= k <= n <= 6000`
- `0 <= Node.val <= 1000`$$
WHERE slug = $$flip-sorter-segments$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$flip-sorter-segments$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$flip-sorter-segments$$),
    'ko',
    $KO$구간별로 뒤집기$KO$,
    $KO$파워업 아이템이 연결 리스트로 이어져 있고, 이걸 `k`개 단위 덩어리로 잘라 뒤집으려고 합니다. 길이 `k`짜리 연속된 구간들을 **앞뒤로 뒤집되** 제자리에서 처리하고, 끝에 `k`보다 짧은 덩어리가 남으면 그대로 둡니다.

재구성된 리스트의 head를 반환하세요. 노드의 값은 바꾸면 안 되고, `next` 포인터만 다시 이어주어야 합니다.

**예시 1:**
```
Input: head = [10,20,30,40,50,60,70], k = 3
Output: [30,20,10,60,50,40,70]
Explanation: The first run (10,20,30) flips to (30,20,10); the next run (40,50,60) flips to (60,50,40); the trailing 70 stands alone.
```

**예시 2:**
```
Input: head = [5,15,25,35], k = 4
Output: [35,25,15,5]
Explanation: Exactly one run of length 4 is reversed in full.
```

**예시 3:**
```
Input: head = [2,4,6,8,10], k = 1
Output: [2,4,6,8,10]
Explanation: With k = 1 each run is a single node, so the list is unchanged.
```$KO$,
    $KO$- 리스트의 노드 수는 `n`입니다.
- `1 <= k <= n <= 6000`
- `0 <= Node.val <= 1000`$KO$
);

-- flooded-corridor-crossing
UPDATE problems SET
    title = $$Flooded Corridor Crossing$$,
    description = $$In a 2D adventure game you move across an `n x n` grid as the water level rises. The matrix `elevation[r][c]` gives the tile height at row `r`, column `c`. At time `t`, every tile with elevation `<= t` is walkable; everything else is flooded.

You start at `(0, 0)` and need to reach `(n - 1, n - 1)`. From any walkable tile you may move to a 4-neighbor that is also walkable. Return the minimum water level `t` at which such a route first exists.

**Example 1:**
```
Input: elevation = [[1,0],[2,3]]
Output: 3
Explanation: The destination itself has height 3, so no route can exist before t = 3. At t = 3 every tile is walkable.
```

**Example 2:**
```
Input: elevation = [[0,3,1,2],[7,4,5,8],[11,13,15,12],[6,9,10,14]]
Output: 14
Explanation: The lowest peak along the best route (0,0) -> (1,0) -> (2,0) -> (3,0) -> (3,1) -> (3,2) -> (3,3) is 14, the destination's height.
```$$,
    constraints = $$- `n == elevation.length == elevation[i].length`
- `1 <= n <= 60`
- `0 <= elevation[r][c] < n * n`
- Every height in `elevation` is distinct.$$
WHERE slug = $$flooded-corridor-crossing$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$flooded-corridor-crossing$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$flooded-corridor-crossing$$),
    'ko',
    $KO$물에 잠기는 통로 건너기$KO$,
    $KO$2D 어드벤처 게임에서 수위가 점점 높아지는 `n x n` 격자 위를 이동합니다. 행렬 `elevation[r][c]`는 행 `r`, 열 `c` 타일의 높이를 나타냅니다. 시각 `t`에는 높이가 `<= t`인 모든 타일을 걸을 수 있고, 나머지는 물에 잠깁니다.

`(0, 0)`에서 출발해 `(n - 1, n - 1)`까지 도달해야 합니다. 걸을 수 있는 타일에서는 상하좌우 인접한 걸을 수 있는 타일로 이동할 수 있습니다. 그런 경로가 처음으로 존재하게 되는 최소 수위 `t`를 반환하세요.

**예시 1:**
```
Input: elevation = [[1,0],[2,3]]
Output: 3
Explanation: The destination itself has height 3, so no route can exist before t = 3. At t = 3 every tile is walkable.
```

**예시 2:**
```
Input: elevation = [[0,3,1,2],[7,4,5,8],[11,13,15,12],[6,9,10,14]]
Output: 14
Explanation: The lowest peak along the best route (0,0) -> (1,0) -> (2,0) -> (3,0) -> (3,1) -> (3,2) -> (3,3) is 14, the destination's height.
```$KO$,
    $KO$- `n == elevation.length == elevation[i].length`
- `1 <= n <= 60`
- `0 <= elevation[r][c] < n * n`
- `elevation`의 모든 높이는 서로 다릅니다.$KO$
);

-- fold-bale-ops
UPDATE problems SET
    title = $$Fold Bale Ops$$,
    description = $$Your math teacher scribbled a postfix expression on the board and wants the final value. The tape `baleTape` is an array of tokens, each either a signed integer or one of `+`, `-`, `*`, `/`. Each operator pops the top two numbers off the stack, combines them, and pushes the result.

Division truncates toward zero. The tape is a valid postfix program that leaves exactly one number on the stack with no division by zero. Return that integer.

**Example 1:**
```
Input: baleTape = ["5","3","-","2","*"]
Output: 4
Explanation: (5 - 3) * 2 = 4.
```

**Example 2:**
```
Input: baleTape = ["8","2","/","7","+","3","*"]
Output: 33
Explanation: ((8 / 2) + 7) * 3 = 33.
```$$,
    constraints = $$- `1 <= baleTape.length <= 2 * 10^3`
- `baleTape[i]` is either an operator in `{"+", "-", "*", "/"}` or a signed integer with `|baleTape[i]| <= 250`.$$
WHERE slug = $$fold-bale-ops$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$fold-bale-ops$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$fold-bale-ops$$),
    'ko',
    $KO$후위 표기식 계산$KO$,
    $KO$수학 선생님이 칠판에 후위 표기식을 갈겨 쓰고 최종 값을 원합니다. 테이프 `baleTape`는 토큰 배열로, 각 토큰은 부호 있는 정수이거나 `+`, `-`, `*`, `/` 중 하나입니다. 연산자는 스택에서 위쪽 두 수를 꺼내 계산한 결과를 다시 스택에 넣습니다.

나눗셈은 0 방향으로 버림합니다. 테이프는 올바른 후위 표기 프로그램이라서 스택에는 정확히 수 하나만 남고, 0으로 나누는 경우도 없습니다. 그 정수를 반환하세요.

**예시 1:**
```
Input: baleTape = ["5","3","-","2","*"]
Output: 4
Explanation: (5 - 3) * 2 = 4.
```

**예시 2:**
```
Input: baleTape = ["8","2","/","7","+","3","*"]
Output: 33
Explanation: ((8 / 2) + 7) * 3 = 33.
```$KO$,
    $KO$- `1 <= baleTape.length <= 2 * 10^3`
- `baleTape[i]`는 `{"+", "-", "*", "/"}` 중 하나의 연산자이거나 `|baleTape[i]| <= 250`인 부호 있는 정수입니다.$KO$
);

-- forecast-step-factor
UPDATE problems SET
    title = $$Forecast Step Factor$$,
    description = $$Your phone battery drains by a steady factor `base` every hour, and you want to know how much is left after `step` hours. Compute `base` raised to the `step`-th power.

A negative `step` means `1 / base^|step|` (for instance, `2.0^-3 = 0.125`). Return the result rounded to 5 decimal places; `|step|` can be huge, so a plain loop will time out.

**Example 1:**
```
Input: base = 3.00000, step = 4
Output: 81.00000
```

**Example 2:**
```
Input: base = 2.00000, step = -3
Output: 0.12500
Explanation: 2.0^-3 = 1 / (2.0^3) = 1/8 = 0.125.
```$$,
    constraints = $$- `-100.0 < base < 100.0`
- `-2 * 10^8 <= step <= 2 * 10^8`
- `step` is an integer
- Either `base` is not zero or `step > 0`
- `|base^step| <= 8 * 10^4`$$
WHERE slug = $$forecast-step-factor$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$forecast-step-factor$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$forecast-step-factor$$),
    'ko',
    $KO$배터리 소모율 예측$KO$,
    $KO$휴대폰 배터리가 한 시간마다 일정한 배율 `base`만큼 줄어드는데, `step` 시간 뒤에 얼마나 남아 있을지 알고 싶습니다. `base`의 `step` 제곱을 계산하세요.

`step`이 음수면 `1 / base^|step|`을 의미합니다(예: `2.0^-3 = 0.125`). 결과는 소수점 다섯째 자리까지 반올림해서 반환하세요. `|step|`이 매우 클 수 있어서 단순 반복문으로는 시간 초과가 납니다.

**예시 1:**
```
Input: base = 3.00000, step = 4
Output: 81.00000
```

**예시 2:**
```
Input: base = 2.00000, step = -3
Output: 0.12500
Explanation: 2.0^-3 = 1 / (2.0^3) = 1/8 = 0.125.
```$KO$,
    $KO$- `-100.0 < base < 100.0`
- `-2 * 10^8 <= step <= 2 * 10^8`
- `step`은 정수입니다.
- `base`가 0이 아니거나 `step > 0`입니다.
- `|base^step| <= 8 * 10^4`$KO$
);

-- form-bale-triple
UPDATE problems SET
    title = $$Stack Grocery Bags$$,
    description = $$You're packing groceries and each bag has three readings `[produce, dairy, frozen]` for how much of each category is inside. You want to pick a subset of bags that, when laid on top of each other, have a channel-wise max matching `target` exactly. A bag is only usable if none of its readings exceed `target` on any channel.

Write `canBuildBales(bags, target)` that returns `true` if some subset of usable bags matches `target` channel-wise, else `false`.

**Example 1:**
```
Input: bags = [[3,2,1],[1,6,4],[3,1,7],[2,5,2]], target = [3,6,7]
Output: true
Explanation: Stack [3,2,1], [1,6,4], and [3,1,7]. The per-channel maxima are [3,6,7].
```

**Example 2:**
```
Input: bags = [[2,3,4],[4,2,1]], target = [2,3,5]
Output: false
Explanation: The second bag overshoots channel 0 (4 > 2) so it's out. The first alone gives [2,3,4], and nothing can lift channel 2 to 5.
```$$,
    constraints = $$- `1 <= bags.length <= 2 * 10^5`
- `bags[i].length == 3`
- `1 <= bags[i][j], target[j] <= 1000`$$
WHERE slug = $$form-bale-triple$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$form-bale-triple$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$form-bale-triple$$),
    'ko',
    $KO$장바구니 쌓기$KO$,
    $KO$장을 본 물건들을 봉투에 나눠 담고 있는데, 각 봉투에는 `[produce, dairy, frozen]` 세 가지 수치가 붙어 있어서 카테고리별 내용물 양을 알려줍니다. 몇 개의 봉투를 골라 겹쳐 쌓았을 때, 채널별 최댓값이 `target`과 정확히 같아지도록 만들고 싶습니다. 단, 어느 채널이라도 수치가 `target`을 넘는 봉투는 쓸 수 없습니다.

사용 가능한 봉투 중 일부로 채널별로 `target`과 딱 맞출 수 있으면 `true`, 아니면 `false`를 반환하는 `canBuildBales(bags, target)`을 작성하세요.

**예시 1:**
```
Input: bags = [[3,2,1],[1,6,4],[3,1,7],[2,5,2]], target = [3,6,7]
Output: true
Explanation: Stack [3,2,1], [1,6,4], and [3,1,7]. The per-channel maxima are [3,6,7].
```

**예시 2:**
```
Input: bags = [[2,3,4],[4,2,1]], target = [2,3,5]
Output: false
Explanation: The second bag overshoots channel 0 (4 > 2) so it's out. The first alone gives [2,3,4], and nothing can lift channel 2 to 5.
```$KO$,
    $KO$- `1 <= bags.length <= 2 * 10^5`
- `bags[i].length == 3`
- `1 <= bags[i][j], target[j] <= 1000`$KO$
);

-- frame-largest-bale
UPDATE problems SET
    title = $$Biggest Locker Poster$$,
    description = $$A row of lockers lines the school hallway, and locker `i` stands `lockers[i]` tall. You want to tape a rectangular poster between two lockers; its height is capped by the shorter locker and its width is the gap between their positions.

Given the array `lockers` of length `n`, return the largest poster area (width times limiting height) any pair of lockers can hold up.

**Example 1:**
```
Input: lockers = [2,6,4,1,5,3,6,2,8]
Output: 42
Explanation: Lockers at index 1 (height 6) and index 8 (height 8) frame a poster of width 7 and height 6, giving 42.
```

**Example 2:**
```
Input: lockers = [2,3]
Output: 2
```$$,
    constraints = $$- `n == lockers.length`
- `2 <= n <= 2 * 10^5`
- `0 <= lockers[i] <= 8 * 10^4`$$
WHERE slug = $$frame-largest-bale$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$frame-largest-bale$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$frame-largest-bale$$),
    'ko',
    $KO$가장 큰 사물함 포스터$KO$,
    $KO$학교 복도에 사물함이 한 줄로 서 있는데, 사물함 `i`의 높이는 `lockers[i]`입니다. 사물함 두 개 사이에 직사각형 포스터를 테이프로 붙이고 싶은데, 높이는 더 낮은 사물함에 맞춰지고, 너비는 두 사물함의 거리만큼 벌어집니다.

길이 `n`인 배열 `lockers`가 주어졌을 때, 사물함 두 개로 지탱할 수 있는 포스터의 최대 넓이(너비 곱하기 제한된 높이)를 반환하세요.

**예시 1:**
```
Input: lockers = [2,6,4,1,5,3,6,2,8]
Output: 42
Explanation: Lockers at index 1 (height 6) and index 8 (height 8) frame a poster of width 7 and height 6, giving 42.
```

**예시 2:**
```
Input: lockers = [2,3]
Output: 2
```$KO$,
    $KO$- `n == lockers.length`
- `2 <= n <= 2 * 10^5`
- `0 <= lockers[i] <= 8 * 10^4`$KO$
);

-- group-oven-bakes
UPDATE problems SET
    title = $$Group Study Cards$$,
    description = $$A study group has a pile of numbered flashcards and wants to deal them into groups of `groupSize` cards whose numbers are consecutive (like `{7,8,9}` when `groupSize = 3`). Every card has to land in exactly one group.

Given the integer array `cards` and the integer `groupSize`, return `true` if the pile can be split into groups of consecutive numbers, and `false` otherwise.

**Example 1:**
```
Input: cards = [2,3,4,5,6,7], groupSize = 3
Output: true
Explanation: Deal the cards as [2,3,4] then [5,6,7].
```

**Example 2:**
```
Input: cards = [1,2,3,5], groupSize = 2
Output: false
Explanation: After [1,2], the leftover cards 3 and 5 aren't consecutive.
```$$,
    constraints = $$- `1 <= cards.length <= 2 * 10^5`
- `0 <= cards[i] <= 10^8`
- `1 <= groupSize <= cards.length`$$
WHERE slug = $$group-oven-bakes$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$group-oven-bakes$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$group-oven-bakes$$),
    'ko',
    $KO$스터디 카드 묶기$KO$,
    $KO$스터디 그룹에 숫자가 적힌 플래시 카드 한 무더기가 있고, 이걸 `groupSize`장씩 묶어 연속된 숫자 그룹(예: `groupSize = 3`이면 `{7,8,9}`)으로 나누려 합니다. 모든 카드는 정확히 한 그룹에 들어가야 합니다.

정수 배열 `cards`와 정수 `groupSize`가 주어질 때, 카드를 연속된 숫자 그룹으로 나눌 수 있으면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: cards = [2,3,4,5,6,7], groupSize = 3
Output: true
Explanation: Deal the cards as [2,3,4] then [5,6,7].
```

**예시 2:**
```
Input: cards = [1,2,3,5], groupSize = 2
Output: false
Explanation: After [1,2], the leftover cards 3 and 5 aren't consecutive.
```$KO$,
    $KO$- `1 <= cards.length <= 2 * 10^5`
- `0 <= cards[i] <= 10^8`
- `1 <= groupSize <= cards.length`$KO$
);

-- group-train-packs
UPDATE problems SET
    title = $$Group Car Packs$$,
    description = $$A bunch of cars are cruising down a one-lane road toward a toll booth at kilometer `target`. Car `i` starts at `position[i]` with cruising speed `speed[i]`, and faster cars can't overtake — when one catches up, it just hangs behind at the slower pace. A **pack** is any group of cars traveling together.

Return how many packs reach the toll booth.

**Example 1:**
```
Input: target = 20, position = [0,3,7,14], speed = [5,3,2,1]
Output: 2
Explanation: The car at km 14 reaches alone (6h). The cars at km 7, 3, and 0 all catch up to the km-7 car before the booth, forming one pack. Two packs total.
```

**Example 2:**
```
Input: target = 15, position = [5], speed = [2]
Output: 1
```$$,
    constraints = $$- `n == position.length == speed.length`
- `1 <= n <= 2 * 10^5`
- `0 <= position[i] < target <= 10^8`
- `1 <= speed[i] <= 2 * 10^5`
- All values in `position` are distinct.$$
WHERE slug = $$group-train-packs$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$group-train-packs$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$group-train-packs$$),
    'ko',
    $KO$차량 무리 묶기$KO$,
    $KO$여러 대의 차가 1차선 도로를 따라 `target` 킬로미터 지점의 톨게이트를 향해 달리고 있습니다. `i`번째 차는 `position[i]`에서 출발해 `speed[i]`의 속도로 움직이며, 빠른 차는 앞차를 추월할 수 없습니다 — 앞차를 따라잡으면 그 뒤에 붙어서 느린 속도로 같이 가게 됩니다. **무리**는 함께 이동하는 차들의 묶음을 말합니다.

톨게이트에 도착하는 무리의 개수를 반환하세요.

**예시 1:**
```
Input: target = 20, position = [0,3,7,14], speed = [5,3,2,1]
Output: 2
Explanation: The car at km 14 reaches alone (6h). The cars at km 7, 3, and 0 all catch up to the km-7 car before the booth, forming one pack. Two packs total.
```

**예시 2:**
```
Input: target = 15, position = [5], speed = [2]
Output: 1
```$KO$,
    $KO$- `n == position.length == speed.length`
- `1 <= n <= 2 * 10^5`
- `0 <= position[i] < target <= 10^8`
- `1 <= speed[i] <= 2 * 10^5`
- `position`의 값들은 모두 서로 다릅니다.$KO$
);

-- hash-table
UPDATE problems SET
    title = $$Chained Key-Value Map$$,
    description = $$You're running a tiny vending machine and need to track how many of each snack are left. The built-in dictionary library is off-limits, so build your own little lookup table from scratch.

Implement the `ChainedMap` class so the vending-machine keeps counts current as snacks are restocked and sold:

- `ChainedMap()` — starts an empty machine with no snacks tracked.
- `void set(int key, int value)` — records that snack `key` now has quantity `value`, overwriting any previous count.
- `int lookup(int key)` — returns the quantity for snack `key`, or `-1` if it isn't tracked.
- `void erase(int key)` — removes snack `key` entirely; a no-op if it wasn't there.

**Example 1:**
```
Input: ["ChainedMap","set","set","lookup","lookup","set","lookup","erase","lookup"] / [[],[1,10],[2,20],[1],[3],[2,30],[2],[2],[2]]
Output: [null,null,null,10,-1,null,30,null,-1]
```
After recording `(1,10)` and `(2,20)`, snack 1 returns its count and snack 3 returns `-1`. Overwriting snack 2 with 30 is reflected next read, and erasing it makes the follow-up return `-1`.

**Example 2:**
```
Input: ["ChainedMap","set","set","set","lookup","lookup","lookup"] / [[],[5,50],[10,100],[15,150],[5],[10],[15]]
Output: [null,null,null,null,50,100,150]
```
Three separate snacks are stored and each one reads back its own count.

**Example 3:**
```
Input: ["ChainedMap","lookup","erase","lookup"] / [[],[7],[7],[7]]
Output: [null,-1,null,-1]
```
Lookups and erases for a snack that was never added do no harm.$$,
    constraints = $$- `0 <= key, value <= 800000`
- At most `8000` calls will be made across `set`, `lookup`, and `erase`.$$
WHERE slug = $$hash-table$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$hash-table$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$hash-table$$),
    'ko',
    $KO$체인형 키-값 맵$KO$,
    $KO$작은 자판기를 운영하면서 각 간식의 재고가 얼마나 남았는지 추적해야 하는데, 기본 사전 라이브러리는 쓸 수 없어서 직접 조회 테이블을 만들어야 합니다.

자판기가 간식을 채우고 팔 때마다 재고를 정확히 반영하도록 `ChainedMap` 클래스를 구현하세요.

- `ChainedMap()` — 추적 중인 간식이 없는 빈 자판기를 시작합니다.
- `void set(int key, int value)` — 간식 `key`의 수량이 이제 `value`가 되도록 기록하고, 이전 값이 있다면 덮어씁니다.
- `int lookup(int key)` — 간식 `key`의 수량을 반환하고, 추적 중이 아니면 `-1`을 반환합니다.
- `void erase(int key)` — 간식 `key`를 완전히 제거합니다. 없으면 아무 일도 일어나지 않습니다.

**예시 1:**
```
Input: ["ChainedMap","set","set","lookup","lookup","set","lookup","erase","lookup"] / [[],[1,10],[2,20],[1],[3],[2,30],[2],[2],[2]]
Output: [null,null,null,10,-1,null,30,null,-1]
```
`(1,10)`과 `(2,20)`을 기록한 뒤, 간식 1은 수량을 돌려주고 간식 3은 `-1`을 돌려줍니다. 간식 2를 30으로 덮어쓰면 다음 조회에 반영되고, 지우고 나면 다시 `-1`이 됩니다.

**예시 2:**
```
Input: ["ChainedMap","set","set","set","lookup","lookup","lookup"] / [[],[5,50],[10,100],[15,150],[5],[10],[15]]
Output: [null,null,null,null,50,100,150]
```
서로 다른 세 간식이 저장되고, 각각 자신의 수량을 돌려줍니다.

**예시 3:**
```
Input: ["ChainedMap","lookup","erase","lookup"] / [[],[7],[7],[7]]
Output: [null,-1,null,-1]
```
추가된 적 없는 간식에 대한 조회와 삭제는 아무 문제 없이 지나갑니다.$KO$,
    $KO$- `0 <= key, value <= 800000`
- `set`, `lookup`, `erase` 호출은 통틀어 최대 `8000`번 일어납니다.$KO$
);

-- headline-majority-pick
UPDATE problems SET
    title = $$Headline Majority Pick$$,
    description = $$Your guild voted on which boss to fight next and you want the winner. The array `votes` has `n` entries, and one choice got strictly more than half the votes.

Return the id that appears more than `n / 2` times. A dominant choice is guaranteed to exist.

**Example 1:**
```
Input: votes = [4,7,4]
Output: 4
```

**Example 2:**
```
Input: votes = [5,5,6,6,6,5,6]
Output: 6
Explanation: 6 shows up 4 times out of 7, which is more than half.
```

**Example 3:**
```
Input: votes = [9]
Output: 9
```$$,
    constraints = $$- `1 <= votes.length <= 2 * 10^5`
- `-10^8 <= votes[i] <= 10^8`
- A dominant choice always exists.$$
WHERE slug = $$headline-majority-pick$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$headline-majority-pick$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$headline-majority-pick$$),
    'ko',
    $KO$대세 픽 고르기$KO$,
    $KO$길드에서 다음에 잡을 보스를 투표로 정했고, 누가 이겼는지 알고 싶습니다. 배열 `votes`에는 `n`개의 항목이 있고, 한 선택지는 전체 표의 절반을 엄격히 초과하는 표를 받았습니다.

`n / 2`번보다 많이 등장하는 id를 반환하세요. 대세 선택지는 반드시 존재합니다.

**예시 1:**
```
Input: votes = [4,7,4]
Output: 4
```

**예시 2:**
```
Input: votes = [5,5,6,6,6,5,6]
Output: 6
Explanation: 6 shows up 4 times out of 7, which is more than half.
```

**예시 3:**
```
Input: votes = [9]
Output: 9
```$KO$,
    $KO$- `1 <= votes.length <= 2 * 10^5`
- `-10^8 <= votes[i] <= 10^8`
- 대세 선택지는 항상 존재합니다.$KO$
);

-- hub-evenness-check
UPDATE problems SET
    title = $$Hub Evenness Check$$,
    description = $$Your friend's pet-shop family tree of hamsters is stored as a binary tree, and they want to know if the family is balanced so the cage chart looks neat.

Given the `root` of the tree, return `true` if for every node the heights of its left and right subtrees differ by at most one. An empty tree counts as balanced.

**Example 1:**
```
Input: root = [5,2,8,1,null,null,11]
Output: true
Explanation: Every node's left and right subtree heights differ by at most 1.
```

**Example 2:**
```
Input: root = [1,2,null,3,null,4]
Output: false
Explanation: The tree leans all the way left into 1->2->3->4; the root's left subtree has height 3 while its right has height 0.
```

**Example 3:**
```
Input: root = []
Output: true
Explanation: An empty family is balanced by default.
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[0, 2 * 10^3]`.
- `-10^8 <= Node.val <= 10^8`$$
WHERE slug = $$hub-evenness-check$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$hub-evenness-check$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$hub-evenness-check$$),
    'ko',
    $KO$햄스터 가계도 균형 검사$KO$,
    $KO$친구네 펫샵 햄스터 가계도가 이진 트리로 저장돼 있는데, 친구는 우리 차트가 깔끔하게 나오도록 가계가 균형 잡혀 있는지 알고 싶어합니다.

트리의 `root`가 주어졌을 때, 모든 노드에서 왼쪽과 오른쪽 서브트리 높이 차이가 최대 1이면 `true`를 반환하세요. 빈 트리는 균형 잡힌 것으로 칩니다.

**예시 1:**
```
Input: root = [5,2,8,1,null,null,11]
Output: true
Explanation: Every node's left and right subtree heights differ by at most 1.
```

**예시 2:**
```
Input: root = [1,2,null,3,null,4]
Output: false
Explanation: The tree leans all the way left into 1->2->3->4; the root's left subtree has height 3 while its right has height 0.
```

**예시 3:**
```
Input: root = []
Output: true
Explanation: An empty family is balanced by default.
```$KO$,
    $KO$- 트리의 노드 개수는 `[0, 2 * 10^3]` 범위 안에 있습니다.
- `-10^8 <= Node.val <= 10^8`$KO$
);

-- interleave-trailer-cuts
UPDATE problems SET
    title = $$Interleave Trailer Cuts$$,
    description = $$Your buddy is editing a montage of their best game clips into a linked chain from earliest to latest, and they want to interleave early and late clips so the highlight reel stays punchy.

Given `head` of the chain, rearrange the links in place so the order becomes `S0 -> Sn -> S1 -> Sn-1 -> S2 -> Sn-2 -> ...`. Only rewire `next` pointers — don't change any node values.

**Example 1:**
```
Input: head = [10,20,30,40,50,60]
Output: [10,60,20,50,30,40]
Explanation: Early and late clips are woven together: 10, 60, 20, 50, and so on.
```

**Example 2:**
```
Input: head = [1,3,5,7,9,11,13]
Output: [1,13,3,11,5,9,7]
Explanation: With an odd length the middle clip lands at the end.
```$$,
    constraints = $$- The number of clips in the chain is in the range `[1, 8 * 10^4]`.
- `1 <= Shot.val <= 1000`$$
WHERE slug = $$interleave-trailer-cuts$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$interleave-trailer-cuts$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$interleave-trailer-cuts$$),
    'ko',
    $KO$트레일러 컷 교차하기$KO$,
    $KO$친구가 게임 하이라이트 영상을 가장 이른 것부터 가장 늦은 것까지 연결 체인으로 편집하고 있는데, 앞쪽과 뒤쪽 클립을 교차해서 리듬감 있게 만들고 싶어합니다.

체인의 `head`가 주어졌을 때, 순서가 `S0 -> Sn -> S1 -> Sn-1 -> S2 -> Sn-2 -> ...`이 되도록 제자리에서 연결을 재배치하세요. `next` 포인터만 다시 연결하고, 노드 값은 바꾸지 않습니다.

**예시 1:**
```
Input: head = [10,20,30,40,50,60]
Output: [10,60,20,50,30,40]
Explanation: Early and late clips are woven together: 10, 60, 20, 50, and so on.
```

**예시 2:**
```
Input: head = [1,3,5,7,9,11,13]
Output: [1,13,3,11,5,9,7]
Explanation: With an odd length the middle clip lands at the end.
```$KO$,
    $KO$- 체인의 클립 개수는 `[1, 8 * 10^4]` 범위 안에 있습니다.
- `1 <= Shot.val <= 1000`$KO$
);

-- irrigation-pipe-plan
UPDATE problems SET
    title = $$Pet Path Plan$$,
    description = $$Your apartment complex is adding water bowls for the neighborhood cats at known coordinates, and you want to connect them with the least total hose. You are given `bowls`, where each `bowls[i] = [xi, yi]` marks a bowl's spot, and the hose between bowls `i` and `j` runs along the grid so it costs `|xi - xj| + |yi - yj|` meters.

Return the minimum total hose length needed so every bowl is reachable from every other bowl, possibly through intermediate bowls.

**Example 1:**
```
Input: bowls = [[4,4],[4,3],[6,7],[10,2]]
Output: 13
Explanation: Laying hoses [4,4]-[4,3] (length 1), [4,4]-[6,7] (length 5), and [4,3]-[10,2] (length 7) connects every bowl for a total of 13 meters.
```

**Example 2:**
```
Input: bowls = [[0,0],[2,0]]
Output: 2
Explanation: Only one hose of length 2 is needed to join the two bowls.
```$$,
    constraints = $$- `1 <= bowls.length <= 1200`
- `-10^8 <= xi, yi <= 10^8`
- All bowl coordinates are distinct$$
WHERE slug = $$irrigation-pipe-plan$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$irrigation-pipe-plan$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$irrigation-pipe-plan$$),
    'ko',
    $KO$반려동물 급수대 연결$KO$,
    $KO$아파트 단지에 동네 고양이들을 위한 물그릇을 좌표가 정해진 자리들에 놓으려고 하는데, 전체 호스 길이를 최소로 해서 서로 연결하고 싶습니다. `bowls`가 주어지는데, `bowls[i] = [xi, yi]`는 물그릇 하나의 위치이고, 물그릇 `i`와 `j` 사이를 잇는 호스는 격자 모양으로 지나가기 때문에 `|xi - xj| + |yi - yj|` 미터가 듭니다.

모든 물그릇이 다른 모든 물그릇에서 도달 가능하도록(중간 물그릇을 거쳐도 됨) 필요한 최소 총 호스 길이를 반환하세요.

**예시 1:**
```
Input: bowls = [[4,4],[4,3],[6,7],[10,2]]
Output: 13
Explanation: Laying hoses [4,4]-[4,3] (length 1), [4,4]-[6,7] (length 5), and [4,3]-[10,2] (length 7) connects every bowl for a total of 13 meters.
```

**예시 2:**
```
Input: bowls = [[0,0],[2,0]]
Output: 2
Explanation: Only one hose of length 2 is needed to join the two bowls.
```$KO$,
    $KO$- `1 <= bowls.length <= 1200`
- `-10^8 <= xi, yi <= 10^8`
- 모든 물그릇 좌표는 서로 다릅니다.$KO$
);

-- is-acyclic-network
UPDATE problems SET
    title = $$Is Acyclic Network$$,
    description = $$Your neighborhood dog-walk planner models `n` pet cafes labeled `0` to `n - 1`, with each entry `[u, v]` in `lanes` a two-way walking path between cafe `u` and cafe `v`. For a tidy map you want every cafe reachable from every other one and zero loops that send a walker back where they started.

Return `true` if `n` and `lanes` form one fully connected, loop-free structure, and `false` otherwise.

**Example 1:**
```
Input: n = 6, lanes = [[0,1],[0,2],[1,3],[1,4],[2,5]]
Output: true
Explanation: All 6 cafes are reachable from cafe 0, and the 5 paths never form a loop.
```

**Example 2:**
```
Input: n = 4, lanes = [[0,1],[1,2],[2,0],[0,3]]
Output: false
Explanation: Cafes 0, 1, and 2 form a loop, so the map isn't loop-free.
```$$,
    constraints = $$- `1 <= n <= 2 * 10^3`
- `0 <= lanes.length <= 4500`
- `lanes[i].length == 2`
- `0 <= lanes[i][0], lanes[i][1] < n`
- No self-loops and no duplicate lanes$$
WHERE slug = $$is-acyclic-network$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$is-acyclic-network$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$is-acyclic-network$$),
    'ko',
    $KO$무순환 네트워크 판별$KO$,
    $KO$동네 강아지 산책 플래너가 `0`부터 `n - 1`까지 번호가 매겨진 `n`개의 펫 카페를 모델링하는데, `lanes`의 각 항목 `[u, v]`는 카페 `u`와 카페 `v` 사이의 양방향 산책로입니다. 지도를 깔끔하게 유지하려고, 모든 카페가 서로 도달 가능하면서 산책을 하다가 같은 자리로 돌아오는 루프가 하나도 없게 하고 싶습니다.

`n`과 `lanes`가 완전히 연결되어 있고 루프가 없는 구조를 이루면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: n = 6, lanes = [[0,1],[0,2],[1,3],[1,4],[2,5]]
Output: true
Explanation: All 6 cafes are reachable from cafe 0, and the 5 paths never form a loop.
```

**예시 2:**
```
Input: n = 4, lanes = [[0,1],[1,2],[2,0],[0,3]]
Output: false
Explanation: Cafes 0, 1, and 2 form a loop, so the map isn't loop-free.
```$KO$,
    $KO$- `1 <= n <= 2 * 10^3`
- `0 <= lanes.length <= 4500`
- `lanes[i].length == 2`
- `0 <= lanes[i][0], lanes[i][1] < n`
- 자기 자신과 이어지는 간선이나 중복된 산책로는 없습니다.$KO$
);

-- keypad-device-codes
UPDATE problems SET
    title = $$Keypad Letter Codes$$,
    description = $$Your grandma still types messages on her old flip phone, where each digit stands for multiple letters, and you want to list every possible letter combo for the digits she pressed. The digit-to-letter mapping is:

- `2`: `abc`
- `3`: `def`
- `4`: `ghi`
- `5`: `jkl`
- `6`: `mno`
- `7`: `pqrs`
- `8`: `tuv`
- `9`: `wxyz`

Given a string `digits` drawn from `2`-`9`, implement `mapKeypadCodes` to return every letter combo the digits could spell. Any order is fine. If `digits` is empty, return an empty list.

**Example 1:**
```
Input: digits = "45"
Output: ["gj","gk","gl","hj","hk","hl","ij","ik","il"]
Explanation: Digit 4 maps to "ghi" and digit 5 maps to "jkl"; every pairing of one letter from each slot is included.
```

**Example 2:**
```
Input: digits = ""
Output: []
```$$,
    constraints = $$- `0 <= digits.length <= 4`
- Every character of `digits` is a digit in the range `'2'`-`'9'`.$$
WHERE slug = $$keypad-device-codes$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$keypad-device-codes$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$keypad-device-codes$$),
    'ko',
    $KO$키패드 문자 조합$KO$,
    $KO$할머니가 아직도 옛날 폴더폰으로 문자를 치는데, 각 숫자 키가 여러 글자를 나타내서 당신은 할머니가 누른 숫자들로 만들 수 있는 문자 조합을 전부 뽑아보려고 합니다. 숫자-문자 대응은 다음과 같습니다.

- `2`: `abc`
- `3`: `def`
- `4`: `ghi`
- `5`: `jkl`
- `6`: `mno`
- `7`: `pqrs`
- `8`: `tuv`
- `9`: `wxyz`

`2`-`9` 사이의 문자로만 이루어진 문자열 `digits`가 주어지면, 만들 수 있는 모든 글자 조합을 반환하는 `mapKeypadCodes`를 구현합니다. 순서는 상관없습니다. `digits`가 비어 있으면 빈 리스트를 반환합니다.

**예시 1:**
```
Input: digits = "45"
Output: ["gj","gk","gl","hj","hk","hl","ij","ik","il"]
Explanation: 숫자 4는 "ghi", 숫자 5는 "jkl"에 대응하고, 두 칸에서 한 글자씩 고른 모든 쌍이 포함됩니다.
```

**예시 2:**
```
Input: digits = ""
Output: []
```$KO$,
    $KO$- `0 <= digits.length <= 4`
- `digits`의 모든 문자는 `'2'`-`'9'` 범위의 숫자입니다.$KO$
);

-- kth-largest-stream
UPDATE problems SET
    title = $$K-th Highest Running Value$$,
    description = $$Your guild is posting new raid scores one at a time, and you want to watch the `k`-th highest score update live. Duplicates keep their own rank, so the `k`-th largest is just the value at position `k` in the sorted list.

Build `TopKStream` to track it as each score comes in:

- `TopKStream(int k, int[] scores)` seeds the tracker with rank `k` and a starting batch of raid scores.
- `int record(int val)` adds `val` to the stream and returns the current `k`-th largest score overall.

**Example 1:**
```
Input:
["TopKStream", "record", "record", "record", "record", "record"]
[[3, [4, 5, 8, 2]], [3], [5], [10], [9], [4]]
Output: [null, 4, 5, 5, 8, 8]

Explanation:
TopKStream tracker = new TopKStream(3, [4, 5, 8, 2]);
tracker.record(3);   // stream becomes [4,5,8,2,3]; 3rd largest is 4
tracker.record(5);   // stream becomes [4,5,8,2,3,5]; 3rd largest is 5
tracker.record(10);  // stream becomes [4,5,8,2,3,5,10]; 3rd largest is 5
tracker.record(9);   // stream becomes [4,5,8,2,3,5,10,9]; 3rd largest is 8
tracker.record(4);   // stream becomes [4,5,8,2,3,5,10,9,4]; 3rd largest is 8
```

The leaderboard refreshes constantly, so re-sorting everything on each post won't keep up.$$,
    constraints = $$- `1 <= k <= 8000`
- `0 <= scores.length <= 8000`
- `-10^8 <= scores[i] <= 10^8`
- `-10^8 <= val <= 10^8`
- At most `8000` calls will be made to `record`.
- When `record` is called, the combined stream is guaranteed to contain at least `k` scores.$$
WHERE slug = $$kth-largest-stream$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$kth-largest-stream$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$kth-largest-stream$$),
    'ko',
    $KO$실시간 K번째 최고 점수$KO$,
    $KO$길드가 새 레이드 점수를 하나씩 올리고 있고, 당신은 `k`번째로 높은 점수를 실시간으로 보고 싶어 합니다. 중복 점수도 각자 자기 순위를 차지하므로, `k`번째 최대는 정렬된 리스트에서 위치 `k`에 있는 값과 같습니다.

점수가 들어올 때마다 이를 추적하는 `TopKStream`을 만들어 주세요.

- `TopKStream(int k, int[] scores)` — 순위 `k`와 초기 레이드 점수 배치를 받아 트래커를 초기화합니다.
- `int record(int val)` — `val`을 스트림에 추가하고 현재 스트림 전체에서 `k`번째로 큰 점수를 반환합니다.

**예시 1:**
```
Input:
["TopKStream", "record", "record", "record", "record", "record"]
[[3, [4, 5, 8, 2]], [3], [5], [10], [9], [4]]
Output: [null, 4, 5, 5, 8, 8]

Explanation:
TopKStream tracker = new TopKStream(3, [4, 5, 8, 2]);
tracker.record(3);   // 스트림 [4,5,8,2,3]; 3번째 최대는 4
tracker.record(5);   // 스트림 [4,5,8,2,3,5]; 3번째 최대는 5
tracker.record(10);  // 스트림 [4,5,8,2,3,5,10]; 3번째 최대는 5
tracker.record(9);   // 스트림 [4,5,8,2,3,5,10,9]; 3번째 최대는 8
tracker.record(4);   // 스트림 [4,5,8,2,3,5,10,9,4]; 3번째 최대는 8
```

리더보드가 쉴 새 없이 갱신되므로, 매번 전체를 다시 정렬하는 방법으로는 따라갈 수 없습니다.$KO$,
    $KO$- `1 <= k <= 8000`
- `0 <= scores.length <= 8000`
- `-10^8 <= scores[i] <= 10^8`
- `-10^8 <= val <= 10^8`
- `record`는 최대 `8000`번 호출됩니다.
- `record` 호출 시점에 스트림에는 최소 `k`개 이상의 점수가 있다고 보장됩니다.$KO$
);

-- label-lane-scans
UPDATE problems SET
    title = $$Label Round Counts$$,
    description = $$You're writing the scoreboard for a silly party game where every round number gets a nickname, and you need the first `n` labels ready before the stream starts. Given a positive integer `n`, return a list of labels for each round from `1` to `n` using these rules:

- If the round is divisible by both 3 and 5, label it `"FizzBuzz"`.
- If the round is divisible by 3 only, label it `"Fizz"`.
- If the round is divisible by 5 only, label it `"Buzz"`.
- Otherwise, the label is the round number written as a decimal string.

Return the resulting list in order.

**Example 1:**
```
Input: n = 4
Output: ["1","2","Fizz","4"]
```

**Example 2:**
```
Input: n = 6
Output: ["1","2","Fizz","4","Buzz","Fizz"]
```$$,
    constraints = $$- `1 <= n <= 15000`$$
WHERE slug = $$label-lane-scans$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$label-lane-scans$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$label-lane-scans$$),
    'ko',
    $KO$라운드 이름 붙이기$KO$,
    $KO$바보 같은 파티 게임의 스코어보드를 만드는 중인데, 라운드 번호마다 별명이 있어서 방송 시작 전에 처음 `n`개의 라벨을 준비해 둬야 합니다. 양의 정수 `n`이 주어지면, `1`부터 `n`까지 각 라운드 라벨을 다음 규칙으로 만들어 돌려주세요.

- 라운드가 3과 5 둘 다의 배수면 `"FizzBuzz"`.
- 3의 배수인데 5의 배수는 아니면 `"Fizz"`.
- 5의 배수인데 3의 배수는 아니면 `"Buzz"`.
- 아니면 그 라운드 번호를 십진수 문자열로.

순서대로 담긴 리스트를 반환하세요.

**예시 1:**
```
Input: n = 4
Output: ["1","2","Fizz","4"]
```

**예시 2:**
```
Input: n = 6
Output: ["1","2","Fizz","4","Buzz","Fizz"]
```$KO$,
    $KO$- `1 <= n <= 15000`$KO$
);

-- list-runtime-branches
UPDATE problems SET
    title = $$List Runtime Branches$$,
    description = $$Your RPG's skill tree branches out from a `root` node, and each node holds an XP value; a full build is any path from the root down to a leaf. You want every build whose XP values add up to exactly `target`.

Return each matching root-to-leaf path as its list of node values top-down. A **leaf** is a node with no children. List paths in the order a left-first DFS discovers them.

**Example 1:**
```
Input: root = [10,6,9,3,null,4,5,null,null,8,2], target = 19
Output: [[10,6,3]]
Explanation: The only root-to-leaf branch summing to 19 is 10 -> 6 -> 3.
```

**Example 2:**
```
Input: root = [7,2,4,null,5,1,3], target = 14
Output: [[7,2,5],[7,4,3]]
Explanation: Two branches reach 14: 7 + 2 + 5 and 7 + 4 + 3.
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[0, 4500]`.
- `-1000 <= Node.val <= 1000`
- `-1000 <= target <= 1000`$$
WHERE slug = $$list-runtime-branches$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$list-runtime-branches$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$list-runtime-branches$$),
    'ko',
    $KO$스킬 빌드 경로$KO$,
    $KO$RPG의 스킬 트리가 `root` 노드에서 가지를 치고, 각 노드에는 XP 값이 있어요. 완성된 빌드는 루트에서 잎까지 내려가는 경로입니다. XP 합이 정확히 `target`이 되는 모든 빌드를 알고 싶습니다.

조건을 만족하는 루트에서 잎까지의 경로들을 각각 위에서 아래로의 노드 값 리스트로 반환하세요. **잎**은 자식이 없는 노드입니다. 경로들은 왼쪽 우선 DFS가 발견하는 순서로 나열합니다.

**예시 1:**
```
Input: root = [10,6,9,3,null,4,5,null,null,8,2], target = 19
Output: [[10,6,3]]
Explanation: 합이 19가 되는 루트-잎 경로는 10 -> 6 -> 3뿐입니다.
```

**예시 2:**
```
Input: root = [7,2,4,null,5,1,3], target = 14
Output: [[7,2,5],[7,4,3]]
Explanation: 14가 되는 경로는 7 + 2 + 5와 7 + 4 + 3 두 개입니다.
```$KO$,
    $KO$- 트리에 있는 노드 수는 `[0, 4500]` 범위입니다.
- `-1000 <= Node.val <= 1000`
- `-1000 <= target <= 1000`$KO$
);

-- list-slate-sequences
UPDATE problems SET
    title = $$List Slate Sequences$$,
    description = $$For a math club warm-up, your teacher wants every valid way to pair `pairCount` opening and closing brackets so that every `(` eventually closes with a `)` and no `)` ever shows up early.

Given the integer `pairCount`, return all such well-formed strings. Any order is fine — the grader sorts before comparing.

**Example 1:**
```
Input: pairCount = 2
Output: ["(())","()()"]
Explanation: The two valid bracket layouts using two pairs.
```

**Example 2:**
```
Input: pairCount = 4
Output: ["(((())))","((()()))","((())())","((()))()","(()(()))","(()()())","(()())()","(())(())","(())()()","()((()))","()(()())","()(())()","()()(())","()()()()"]
```$$,
    constraints = $$- `1 <= pairCount <= 9`$$
WHERE slug = $$list-slate-sequences$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$list-slate-sequences$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$list-slate-sequences$$),
    'ko',
    $KO$괄호 짝 만들기$KO$,
    $KO$수학 동아리의 워밍업으로, 선생님이 여는 괄호와 닫는 괄호 `pairCount`쌍을 모든 유효한 방식으로 배치해 보라고 합니다. 모든 `(`는 결국 `)`로 닫혀야 하고, `)`가 먼저 나타나면 안 돼요.

정수 `pairCount`가 주어질 때, 그런 잘 형성된 문자열을 모두 반환하세요. 순서는 자유롭습니다 — 채점기가 비교 전에 정렬해 줍니다.

**예시 1:**
```
Input: pairCount = 2
Output: ["(())","()()"]
Explanation: 두 쌍으로 만들 수 있는 유효한 괄호 배열 두 가지.
```

**예시 2:**
```
Input: pairCount = 4
Output: ["(((())))","((()()))","((())())","((()))()","(()(()))","(()()())","(()())()","(())(())","(())()()","()((()))","()(()())","()(())()","()()(())","()()()()"]
```$KO$,
    $KO$- `1 <= pairCount <= 9`$KO$
);

-- locate-call-number
UPDATE problems SET
    title = $$Locate Locker Number$$,
    description = $$The school posts locker assignments as a sorted list `shelf` of unique locker numbers, and you need to find where your friend's locker `query` sits in the row. Return its 0-indexed position in `shelf`, or `-1` if the number isn't on the list.

Do this in `O(log n)` time so you can answer before homeroom starts.

**Example 1:**
```
Input: shelf = [102,145,201,247,318,402,510,633], query = 318
Output: 4
Explanation: Locker 318 sits at position 4 in the row.
```

**Example 2:**
```
Input: shelf = [102,145,201,247,318,402,510,633], query = 200
Output: -1
Explanation: No locker 200 exists in the list.
```$$,
    constraints = $$- `1 <= shelf.length <= 2 * 10^5`
- `|shelf[i]| <= 10^8`
- `|query| <= 10^8`
- All locker numbers in `shelf` are unique.
- `shelf` is sorted in strictly ascending order.$$
WHERE slug = $$locate-call-number$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$locate-call-number$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$locate-call-number$$),
    'ko',
    $KO$사물함 위치 찾기$KO$,
    $KO$학교가 사물함 배정표를 서로 다른 사물함 번호들의 정렬된 리스트 `shelf`로 붙여두었고, 친구의 사물함 `query`가 몇 번째에 있는지 찾아야 합니다. `shelf`에서의 0-인덱스 위치를 반환하고, 리스트에 없으면 `-1`을 반환하세요.

조회는 `O(log n)` 시간에 끝내서 조회 시간이 조례 시작 전에 나올 수 있게 해야 합니다.

**예시 1:**
```
Input: shelf = [102,145,201,247,318,402,510,633], query = 318
Output: 4
Explanation: 사물함 318은 줄에서 4번 자리에 있습니다.
```

**예시 2:**
```
Input: shelf = [102,145,201,247,318,402,510,633], query = 200
Output: -1
Explanation: 200번 사물함이 리스트에 없습니다.
```$KO$,
    $KO$- `1 <= shelf.length <= 2 * 10^5`
- `|shelf[i]| <= 10^8`
- `|query| <= 10^8`
- `shelf`의 모든 사물함 번호는 서로 다릅니다.
- `shelf`는 엄격히 오름차순으로 정렬되어 있습니다.$KO$
);

-- locate-terminus-station
UPDATE problems SET
    title = $$Locate Terminus Station$$,
    description = $$Your game's high-score leaderboard was stored sorted ascending, but somebody rotated the array between `1` and `n` times overnight. You're given the rotated array `scores` of distinct values and want the lowest score, which identifies the terminus slot.

Return the smallest value in `scores`. Your routine must run in `O(log n)` time.

**Example 1:**
```
Input: scores = [7,9,12,2,5]
Output: 2
Explanation: The sorted list was [2,5,7,9,12] rotated 3 times, so 2 is the smallest.
```

**Example 2:**
```
Input: scores = [15,20,24,31,3,8,12]
Output: 3
```

**Example 3:**
```
Input: scores = [21,33,45,58]
Output: 21
Explanation: No rotation was applied, so the first entry is the smallest.
```$$,
    constraints = $$- `n == scores.length`
- `1 <= n <= 6000`
- `|scores[i]| <= 10^8`
- All values in `scores` are unique.
- `scores` is an ascending list rotated between `1` and `n` times.$$
WHERE slug = $$locate-terminus-station$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$locate-terminus-station$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$locate-terminus-station$$),
    'ko',
    $KO$최저 점수 찾기$KO$,
    $KO$게임 최고 점수 리더보드를 오름차순으로 정렬해 저장해 뒀는데, 밤사이 누군가 배열을 `1`번에서 `n`번 사이 횟수만큼 회전시켜 놨습니다. 서로 다른 값들로 이뤄진 회전된 배열 `scores`가 주어질 때, 종점 자리에 해당하는 가장 낮은 점수를 찾고 싶습니다.

`scores`에서 가장 작은 값을 반환하세요. 이 루틴은 `O(log n)` 시간에 동작해야 합니다.

**예시 1:**
```
Input: scores = [7,9,12,2,5]
Output: 2
Explanation: The sorted list was [2,5,7,9,12] rotated 3 times, so 2 is the smallest.
```

**예시 2:**
```
Input: scores = [15,20,24,31,3,8,12]
Output: 3
```

**예시 3:**
```
Input: scores = [21,33,45,58]
Output: 21
Explanation: No rotation was applied, so the first entry is the smallest.
```$KO$,
    $KO$- `n == scores.length`
- `1 <= n <= 6000`
- `|scores[i]| <= 10^8`
- `scores`의 모든 값은 서로 다릅니다.
- `scores`는 오름차순 리스트를 `1`번에서 `n`번 사이 회전시킨 결과입니다.$KO$
);

-- locate-vacant-callslot
UPDATE problems SET
    title = $$Locate Empty Locker$$,
    description = $$The gym teacher hands out lockers `0, 1, 2, ..., n`, then tells you which `n` lockers are already claimed. Exactly one number from `[0, n]` never got picked and that's yours.

Given the list `lockers` of claimed numbers, return the single missing locker. The answer is guaranteed to exist and be unique.

**Example 1:**
```
Input: lockers = [4,2,0,1]
Output: 3
Explanation: The list has length 4, so the full range is [0..4]. Only 3 is missing.
```

**Example 2:**
```
Input: lockers = [5,3,1,0,2]
Output: 4
Explanation: The full range is [0..5]; 4 isn't on the list.
```$$,
    constraints = $$- `1 <= lockers.length <= 2 * 10^5`
- `0 <= lockers[i] <= lockers.length`
- Every value in `lockers` is distinct$$
WHERE slug = $$locate-vacant-callslot$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$locate-vacant-callslot$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$locate-vacant-callslot$$),
    'ko',
    $KO$비어 있는 사물함 찾기$KO$,
    $KO$체육 선생님이 사물함 `0, 1, 2, ..., n`을 나눠 주고, 그중 `n`개가 이미 누군가의 것이 되었다고 알려줍니다. `[0, n]` 범위에서 딱 하나의 번호만 아무도 안 가져갔는데, 그게 바로 당신 몫입니다.

이미 주인이 정해진 번호들의 리스트 `lockers`가 주어지면, 빠져 있는 하나의 사물함 번호를 반환하세요. 답은 존재하며 유일함이 보장됩니다.

**예시 1:**
```
Input: lockers = [4,2,0,1]
Output: 3
Explanation: The list has length 4, so the full range is [0..4]. Only 3 is missing.
```

**예시 2:**
```
Input: lockers = [5,3,1,0,2]
Output: 4
Explanation: The full range is [0..5]; 4 isn't on the list.
```$KO$,
    $KO$- `1 <= lockers.length <= 2 * 10^5`
- `0 <= lockers[i] <= lockers.length`
- `lockers`의 모든 값은 서로 다릅니다$KO$
);

-- longest-bright-run
UPDATE problems SET
    title = $$Longest Bright Run$$,
    description = $$You're tracking your weekly quiz scores in the order you took them. Given the integer array `scores`, you want the length of the longest strictly increasing **subsequence** — quizzes may be skipped, but the order along the timeline is preserved.

Return the length of the longest strictly increasing subsequence of `scores`. Consecutive picks must satisfy `scores[i] < scores[j]`.

**Example 1:**
```
Input: scores = [4,10,2,6,3,5,8,11]
Output: 5
Explanation: The subsequence [2,3,5,8,11] (from indices 2,4,5,6,7) is strictly increasing and has length 5.
```

**Example 2:**
```
Input: scores = [9,2,7,4,6,8]
Output: 4
Explanation: The subsequence [2,4,6,8] has length 4; no strictly increasing subsequence of length 5 exists.
```$$,
    constraints = $$- `1 <= scores.length <= 2 * 10^3`
- `-5000 <= scores[i] <= 5000`$$
WHERE slug = $$longest-bright-run$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-bright-run$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$longest-bright-run$$),
    'ko',
    $KO$가장 긴 상승 퀴즈 수열$KO$,
    $KO$이번 주 퀴즈 점수를 본 순서대로 기록하고 있습니다. 정수 배열 `scores`가 주어졌을 때, 가장 긴 **증가 부분 수열**의 길이를 구하세요. 퀴즈는 건너뛸 수 있지만, 시간순은 유지해야 합니다.

`scores`의 가장 긴 순증가 부분 수열의 길이를 반환합니다. 연달아 고른 원소는 `scores[i] < scores[j]`를 만족해야 합니다.

**예시 1:**
```
Input: scores = [4,10,2,6,3,5,8,11]
Output: 5
Explanation: The subsequence [2,3,5,8,11] (from indices 2,4,5,6,7) is strictly increasing and has length 5.
```

**예시 2:**
```
Input: scores = [9,2,7,4,6,8]
Output: 4
Explanation: The subsequence [2,4,6,8] has length 4; no strictly increasing subsequence of length 5 exists.
```$KO$,
    $KO$- `1 <= scores.length <= 2 * 10^3`
- `-5000 <= scores[i] <= 5000`$KO$
);

-- longest-clean-run
UPDATE problems SET
    title = $$Longest Clean Run$$,
    description = $$You're binging a buffet line and grabbing treats from trays as they roll by. The array `treats[i]` is the flavor code of the `i`-th piece. You can only tolerate a stretch that mixes **at most two distinct flavors** before your stomach forces a reset.

Return the length of the longest contiguous stretch of `treats` whose pieces use no more than two distinct flavors.

**Example 1:**
```
Input: treats = [4,4,7,4,7,2,7,2,2]
Output: 5
Explanation: The stretch [7,2,7,2,2] at the end uses only flavors 7 and 2 and has length 5. The opening stretch [4,4,7,4,7] also has length 5 using flavors 4 and 7.
```

**Example 2:**
```
Input: treats = [9,9,9]
Output: 3
Explanation: Every piece shares one flavor, so the entire run is clean.
```

**Example 3:**
```
Input: treats = [1,5,1,5,1,5]
Output: 6
Explanation: The whole row alternates between only two flavors, so the longest clean run spans everything.
```$$,
    constraints = $$- `1 <= treats.length <= 2 * 10^5`
- `0 <= treats[i] < treats.length`$$
WHERE slug = $$longest-clean-run$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-clean-run$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$longest-clean-run$$),
    'ko',
    $KO$가장 긴 깔끔한 구간$KO$,
    $KO$뷔페 라인에서 트레이를 따라 오는 간식을 집어먹고 있습니다. `treats[i]`는 `i`번째로 집은 조각의 맛 코드입니다. 속이 탈나기 전까지는 **서로 다른 두 가지 맛**까지만 섞어 먹을 수 있습니다.

서로 다른 맛이 둘을 넘지 않는 `treats`의 연속 구간 중 가장 긴 것의 길이를 반환하세요.

**예시 1:**
```
Input: treats = [4,4,7,4,7,2,7,2,2]
Output: 5
Explanation: The stretch [7,2,7,2,2] at the end uses only flavors 7 and 2 and has length 5. The opening stretch [4,4,7,4,7] also has length 5 using flavors 4 and 7.
```

**예시 2:**
```
Input: treats = [9,9,9]
Output: 3
Explanation: Every piece shares one flavor, so the entire run is clean.
```

**예시 3:**
```
Input: treats = [1,5,1,5,1,5]
Output: 6
Explanation: The whole row alternates between only two flavors, so the longest clean run spans everything.
```$KO$,
    $KO$- `1 <= treats.length <= 2 * 10^5`
- `0 <= treats[i] < treats.length`$KO$
);

-- longest-fresh-feed
UPDATE problems SET
    title = $$Longest Fresh Feed$$,
    description = $$You're scrolling your Netflix queue, where each show is tagged with a single-letter genre, and you want the longest streak with no genre repeating. The whole queue is the string `feed`.

Return the length of the longest contiguous substring of `feed` whose characters are all distinct.

**Example 1:**
```
Input: feed = "finance"
Output: 4
Explanation: The substring "ance" has four distinct characters; no longer run is unique.
```

**Example 2:**
```
Input: feed = "zzzz"
Output: 1
Explanation: Every tag is the same, so only length-one runs are distinct.
```

**Example 3:**
```
Input: feed = "xxxyz"
Output: 3
Explanation: The tail "xyz" has three distinct characters.
```$$,
    constraints = $$- `0 <= feed.length <= 8 * 10^4`
- `feed` consists of English letters, digits, symbols and spaces.$$
WHERE slug = $$longest-fresh-feed$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-fresh-feed$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$longest-fresh-feed$$),
    'ko',
    $KO$가장 긴 겹치지 않는 피드$KO$,
    $KO$넷플릭스 시청 대기열을 쭉 훑어보고 있는데, 각 작품에는 장르가 한 글자로 태그되어 있고, 같은 장르가 반복되지 않는 가장 긴 연속 구간을 찾고 싶습니다. 대기열 전체는 문자열 `feed`로 주어집니다.

모든 문자가 서로 다른 `feed`의 연속 부분 문자열 중 가장 긴 것의 길이를 반환하세요.

**예시 1:**
```
Input: feed = "finance"
Output: 4
Explanation: The substring "ance" has four distinct characters; no longer run is unique.
```

**예시 2:**
```
Input: feed = "zzzz"
Output: 1
Explanation: Every tag is the same, so only length-one runs are distinct.
```

**예시 3:**
```
Input: feed = "xxxyz"
Output: 3
Explanation: The tail "xyz" has three distinct characters.
```$KO$,
    $KO$- `0 <= feed.length <= 8 * 10^4`
- `feed`는 영문자, 숫자, 기호, 공백으로 이루어져 있습니다.$KO$
);

-- longest-seat-block
UPDATE problems SET
    title = $$Longest Seat Block$$,
    description = $$You're queuing up a co-op lobby and the array `seatIds` lists the still-free slot numbers, all jumbled together. You want the length of the **longest block of consecutive slots** so you can reserve them for your guild.

Return the length of the longest run of consecutive integers that can be formed from `seatIds`. Duplicates don't count, and your solution should run in O(n) time.

**Example 1:**
```
Input: seatIds = [42,7,41,40,9,8,43]
Output: 4
Explanation: The consecutive block 40, 41, 42, 43 has length 4.
```

**Example 2:**
```
Input: seatIds = [11,13,12,15,16,14,20,19,18]
Output: 6
Explanation: The block 11, 12, 13, 14, 15, 16 has length 6.
```$$,
    constraints = $$- `0 <= seatIds.length <= 2 * 10^5`
- `|seatIds[i]| <= 10^8`$$
WHERE slug = $$longest-seat-block$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-seat-block$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$longest-seat-block$$),
    'ko',
    $KO$가장 긴 좌석 블록$KO$,
    $KO$협동 플레이 로비를 꾸리는 중인데, 배열 `seatIds`에는 아직 비어 있는 슬롯 번호들이 뒤죽박죽 섞여 있습니다. 길드를 위해 자리를 예약할 수 있도록 **연속된 슬롯으로 이루어진 가장 긴 블록**의 길이를 알고 싶습니다.

`seatIds`로 만들 수 있는 연속된 정수들의 가장 긴 길이를 반환하세요. 중복은 세지 않으며, 해법은 O(n) 시간에 돌아가야 합니다.

**예시 1:**
```
Input: seatIds = [42,7,41,40,9,8,43]
Output: 4
Explanation: The consecutive block 40, 41, 42, 43 has length 4.
```

**예시 2:**
```
Input: seatIds = [11,13,12,15,16,14,20,19,18]
Output: 6
Explanation: The block 11, 12, 13, 14, 15, 16 has length 6.
```$KO$,
    $KO$- `0 <= seatIds.length <= 2 * 10^5`
- `|seatIds[i]| <= 10^8`$KO$
);

-- longest-vine-ascent
UPDATE problems SET
    title = $$Longest Level-Up Path$$,
    description = $$In your favorite puzzle game, the board is an `m x n` grid where each tile shows a score. You want to find the longest combo where each step moves to an adjacent tile (up, down, left, or right) with a **strictly higher** score.

Implement `longestVineAscent` to return the length of the longest strictly increasing path through `scores`.

**Example 1:**
```
Input: scores = [[2,5,8],[3,4,7],[1,6,9]]
Output: 5
Explanation: Starting from the 1 in the bottom-left, 1 -> 3 -> 4 -> 7 -> 9 visits 5 tiles, each higher than the last.
```

**Example 2:**
```
Input: scores = [[4,2,1],[5,6,3]]
Output: 5
Explanation: The combo 1 -> 2 -> 4 -> 5 -> 6 threads through five adjacent tiles with strictly increasing scores.
```$$,
    constraints = $$- `m == scores.length`
- `n == scores[i].length`
- `1 <= m, n <= 200`
- `0 <= scores[i][j] <= 10^8`$$
WHERE slug = $$longest-vine-ascent$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-vine-ascent$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$longest-vine-ascent$$),
    'ko',
    $KO$가장 긴 레벨업 경로$KO$,
    $KO$좋아하는 퍼즐 게임의 보드는 각 타일에 점수가 적힌 `m x n` 격자입니다. 인접한 타일(상, 하, 좌, 우)로 이동할 때마다 점수가 **엄격히 증가**하도록 하는 가장 긴 콤보를 찾고 싶습니다.

`scores` 위에서 엄격히 증가하는 가장 긴 경로의 길이를 반환하는 `longestVineAscent`를 구현하세요.

**예시 1:**
```
Input: scores = [[2,5,8],[3,4,7],[1,6,9]]
Output: 5
Explanation: Starting from the 1 in the bottom-left, 1 -> 3 -> 4 -> 7 -> 9 visits 5 tiles, each higher than the last.
```

**예시 2:**
```
Input: scores = [[4,2,1],[5,6,3]]
Output: 5
Explanation: The combo 1 -> 2 -> 4 -> 5 -> 6 threads through five adjacent tiles with strictly increasing scores.
```$KO$,
    $KO$- `m == scores.length`
- `n == scores[i].length`
- `1 <= m, n <= 200`
- `0 <= scores[i][j] <= 10^8`$KO$
);

-- lowest-missing-target
UPDATE problems SET
    title = $$Missing Laundry Number$$,
    description = $$You dumped a pile of numbered socks into the laundry basket, listed in `socks`, and you want the smallest positive number that's missing from the pile. Zeros and negatives are just mystery lint, ignore them.

Implement `lowestMissingTarget` to return the smallest positive integer absent from `socks`. The array is unsorted and may repeat. Aim for O(n) time and O(1) extra space.

**Example 1:**
```
Input: socks = [2,3,1,5]
Output: 4
Explanation: 1, 2, 3 are all there. 4 is the smallest positive number missing.
```

**Example 2:**
```
Input: socks = [6,-2,8,10]
Output: 1
Explanation: No sock numbered 1 appears, so 1 is the first missing one.
```$$,
    constraints = $$- `1 <= socks.length <= 2 * 10^5`
- `|socks[i]| <= 10^8`$$
WHERE slug = $$lowest-missing-target$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$lowest-missing-target$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$lowest-missing-target$$),
    'ko',
    $KO$사라진 빨래 번호$KO$,
    $KO$번호가 매겨진 양말들을 빨래 바구니에 던져 넣었고, 그 목록이 `socks`에 담겨 있습니다. 이 더미에서 빠져 있는 가장 작은 양의 정수를 찾으려고 합니다. 0이나 음수는 정체불명의 먼지 같은 거라 무시하세요.

`socks`에 없는 가장 작은 양의 정수를 반환하도록 `lowestMissingTarget`을 구현하세요. 배열은 정렬되어 있지 않고 중복이 있을 수 있습니다. 시간 복잡도 O(n), 추가 공간 O(1)을 목표로 하세요.

**예시 1:**
```
Input: socks = [2,3,1,5]
Output: 4
Explanation: 1, 2, 3 are all there. 4 is the smallest positive number missing.
```

**예시 2:**
```
Input: socks = [6,-2,8,10]
Output: 1
Explanation: No sock numbered 1 appears, so 1 is the first missing one.
```$KO$,
    $KO$- `1 <= socks.length <= 2 * 10^5`
- `|socks[i]| <= 10^8`$KO$
);

-- match-recipe-ingredients
UPDATE problems SET
    title = $$Same Snack Mix$$,
    description = $$Two trail-mix bags are considered the same if they use the exact same letters with the exact same counts, no matter the order. Each letter is one ingredient.

Given two ingredient strings `mixA` and `mixB` of lowercase letters, implement `matchRecipe` to return `true` when the two mixes are the same multiset of ingredients, and `false` otherwise. Different lengths means an instant `false`.

**Example 1:**
```
Input: mixA = "butter", mixB = "bruett"
Output: true
Explanation: Both bags use one 'b', one 'u', one 'e', one 'r', and two 't'.
```

**Example 2:**
```
Input: mixA = "yeast", mixB = "toast"
Output: false
Explanation: `mixA` has 'y' and 'e' that `mixB` doesn't, so the mixes differ.
```$$,
    constraints = $$- `1 <= mixA.length, mixB.length <= 4 * 10^4`
- `mixA` and `mixB` consist of lowercase English letters.$$
WHERE slug = $$match-recipe-ingredients$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$match-recipe-ingredients$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$match-recipe-ingredients$$),
    'ko',
    $KO$같은 간식 믹스$KO$,
    $KO$트레일 믹스 두 봉지가 같은 글자들을 같은 개수만큼 쓰고 있다면, 순서에 상관없이 같은 믹스로 봅니다. 각 글자는 재료 하나에 해당합니다.

소문자로 된 재료 문자열 `mixA`와 `mixB`가 주어졌을 때, 두 믹스가 재료의 다중집합으로 동일하면 `true`, 아니면 `false`를 반환하는 `matchRecipe`를 구현하세요. 길이가 다르면 곧바로 `false`입니다.

**예시 1:**
```
Input: mixA = "butter", mixB = "bruett"
Output: true
Explanation: Both bags use one 'b', one 'u', one 'e', one 'r', and two 't'.
```

**예시 2:**
```
Input: mixA = "yeast", mixB = "toast"
Output: false
Explanation: `mixA` has 'y' and 'e' that `mixB` doesn't, so the mixes differ.
```$KO$,
    $KO$- `1 <= mixA.length, mixB.length <= 4 * 10^4`
- `mixA`와 `mixB`는 영어 소문자로 이루어져 있습니다.$KO$
);

-- matching-catalog-layouts
UPDATE problems SET
    title = $$Matching Skill Trees$$,
    description = $$Two players each exported their character's skill tree as a binary tree, and you want to check that the two exports are identical — same shape, same node values everywhere.

Given the roots of two skill trees `p` and `q`, return `true` if they match node for node, or `false` otherwise. Either tree may be empty.

**Example 1:**
```
Input: p = [8,4,12], q = [8,4,12]
Output: true
Explanation: Same shape and same values at every node.
```

**Example 2:**
```
Input: p = [3,5], q = [3,null,5]
Output: false
Explanation: In p, 5 is a left child; in q, it's a right child. Shapes differ.
```

**Example 3:**
```
Input: p = [6,2,9], q = [6,9,2]
Output: false
Explanation: The left and right children are swapped, so the trees don't match.
```$$,
    constraints = $$- The number of nodes in each tree is in the range `[0, 2 * 10^3]`.
- `-10^8 <= Node.val <= 10^8`$$
WHERE slug = $$matching-catalog-layouts$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$matching-catalog-layouts$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$matching-catalog-layouts$$),
    'ko',
    $KO$같은 스킬 트리 확인$KO$,
    $KO$두 플레이어가 각자 캐릭터의 스킬 트리를 이진 트리로 내보냈는데, 두 내보낸 파일이 완전히 같은지 — 모양도 같고 각 노드 값도 같은지 — 확인하고 싶습니다.

두 스킬 트리의 루트 `p`와 `q`가 주어졌을 때, 모든 노드에서 일치하면 `true`, 아니면 `false`를 반환하세요. 둘 중 한 쪽이 비어 있을 수도 있습니다.

**예시 1:**
```
Input: p = [8,4,12], q = [8,4,12]
Output: true
Explanation: Same shape and same values at every node.
```

**예시 2:**
```
Input: p = [3,5], q = [3,null,5]
Output: false
Explanation: In p, 5 is a left child; in q, it's a right child. Shapes differ.
```

**예시 3:**
```
Input: p = [6,2,9], q = [6,9,2]
Output: false
Explanation: The left and right children are swapped, so the trees don't match.
```$KO$,
    $KO$- 각 트리의 노드 개수는 `[0, 2 * 10^3]` 범위 안에 있습니다.
- `-10^8 <= Node.val <= 10^8`$KO$
);

-- merge-flight-rosters
UPDATE problems SET
    title = $$Merge Cafe Queues$$,
    description = $$A busy cafe has several order queues, each already sorted by pickup time as a linked list. The barista wants them woven into one sorted queue.

Given `k` sorted linked-list heads in `queues`, return the head of the single merged sorted list built by re-linking the existing nodes.

**Example 1:**
```
Input: queues = [[2,5,8],[1,3,7],[4,6]]
Output: [1,2,3,4,5,6,7,8]
Explanation: Three pre-sorted queues weave into one.
```

**Example 2:**
```
Input: queues = []
Output: []
Explanation: No queues, nothing to merge.
```

**Example 3:**
```
Input: queues = [[]]
Output: []
Explanation: One empty queue merges to empty.
```$$,
    constraints = $$- `k == queues.length`
- `0 <= k <= 2 * 10^3`
- `0 <= queues[i].length <= 500`
- `-8 * 10^4 <= queues[i][j] <= 8 * 10^4`
- Each `queues[i]` is sorted in ascending order.
- The total number of order nodes across all queues does not exceed `2 * 10^3`.$$
WHERE slug = $$merge-flight-rosters$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$merge-flight-rosters$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$merge-flight-rosters$$),
    'ko',
    $KO$카페 주문 큐 합치기$KO$,
    $KO$바쁜 카페에는 여러 주문 큐가 있는데, 각 큐는 이미 픽업 시간순으로 정렬된 연결 리스트입니다. 바리스타는 이걸 하나의 정렬된 큐로 엮고 싶어합니다.

`queues`에 담긴 `k`개의 정렬된 연결 리스트 헤드가 주어졌을 때, 기존 노드들을 다시 이어 붙여 만든 하나의 합쳐진 정렬 리스트의 헤드를 반환하세요.

**예시 1:**
```
Input: queues = [[2,5,8],[1,3,7],[4,6]]
Output: [1,2,3,4,5,6,7,8]
Explanation: Three pre-sorted queues weave into one.
```

**예시 2:**
```
Input: queues = []
Output: []
Explanation: No queues, nothing to merge.
```

**예시 3:**
```
Input: queues = [[]]
Output: []
Explanation: One empty queue merges to empty.
```$KO$,
    $KO$- `k == queues.length`
- `0 <= k <= 2 * 10^3`
- `0 <= queues[i].length <= 500`
- `-8 * 10^4 <= queues[i][j] <= 8 * 10^4`
- 각 `queues[i]`는 오름차순으로 정렬되어 있습니다.
- 모든 큐의 주문 노드 총 개수는 `2 * 10^3`을 넘지 않습니다.$KO$
);

-- merge-reservation-windows
UPDATE problems SET
    title = $$Merge Reservation Windows$$,
    description = $$The host at your brunch spot tracks seatings as `[start, end]` pairs, and any two that touch — even just at one endpoint — should be fused into a single block on the floor plan.

Given `seatings` where `seatings[i] = [start_i, end_i]`, return the shortest list of non-overlapping windows that still covers every original seating, sorted by start time.

**Example 1:**
```
Input: seatings = [[2,5],[4,7],[9,11],[14,16]]
Output: [[2,7],[9,11],[14,16]]
Explanation: [2,5] and [4,7] share minutes 4 and 5, so they merge into [2,7]. The other two stay separate.
```

**Example 2:**
```
Input: seatings = [[1,3],[3,8],[10,12]]
Output: [[1,8],[10,12]]
Explanation: [1,3] and [3,8] touch at minute 3, which still counts as overlap, so they fuse into [1,8].
```$$,
    constraints = $$- `1 <= seatings.length <= 2 * 10^5`
- `seatings[i].length == 2`
- `0 <= start_i <= end_i <= 10^8`$$
WHERE slug = $$merge-reservation-windows$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$merge-reservation-windows$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$merge-reservation-windows$$),
    'ko',
    $KO$예약 창 합치기$KO$,
    $KO$브런치 가게 호스트가 착석을 `[start, end]` 쌍으로 관리하는데, 두 쌍이 한 끝점에서라도 닿기만 하면 플로어 플랜에서는 하나의 블록으로 합쳐야 합니다.

`seatings[i] = [start_i, end_i]`인 `seatings`가 주어졌을 때, 겹치지 않으면서 원래의 모든 착석을 여전히 덮는 가장 짧은 창들의 리스트를 시작 시각 기준 오름차순으로 반환하세요.

**예시 1:**
```
Input: seatings = [[2,5],[4,7],[9,11],[14,16]]
Output: [[2,7],[9,11],[14,16]]
Explanation: [2,5] and [4,7] share minutes 4 and 5, so they merge into [2,7]. The other two stay separate.
```

**예시 2:**
```
Input: seatings = [[1,3],[3,8],[10,12]]
Output: [[1,8],[10,12]]
Explanation: [1,3] and [3,8] touch at minute 3, which still counts as overlap, so they fuse into [1,8].
```$KO$,
    $KO$- `1 <= seatings.length <= 2 * 10^5`
- `seatings[i].length == 2`
- `0 <= start_i <= end_i <= 10^8`$KO$
);

-- merged-zone-median
UPDATE problems SET
    title = $$Merged Zone Median$$,
    description = $$Two baristas at your cafe each keep a sorted list of the drink prices they rang up today, and the manager wants the median of the combined sales. Given the two sorted lists `zonesA` and `zonesB`, return the median of the merged list — the middle value, or the average of the two middles when the total count is even.

Your merge must run in `O(log(m + n))` time, where `m = zonesA.length` and `n = zonesB.length`.

**Example 1:**
```
Input: zonesA = [2,5], zonesB = [4]
Output: 4.0
Explanation: The merged list is [2,4,5]; the middle value is 4.
```

**Example 2:**
```
Input: zonesA = [3,8], zonesB = [5,11]
Output: 6.5
Explanation: The merged list is [3,5,8,11]; the median is (5 + 8) / 2 = 6.5.
```

**Example 3:**
```
Input: zonesA = [], zonesB = [12]
Output: 12.0
Explanation: Only one value, so the median is that value.
```$$,
    constraints = $$- `0 <= zonesA.length, zonesB.length <= 1500`
- `1 <= zonesA.length + zonesB.length <= 3000`
- `|zonesA[i]|, |zonesB[i]| <= 10^7`
- Both lists are sorted in non-decreasing order.$$
WHERE slug = $$merged-zone-median$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$merged-zone-median$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$merged-zone-median$$),
    'ko',
    $KO$합쳐진 매출 중간값$KO$,
    $KO$카페의 바리스타 두 명이 오늘 결제한 음료 가격을 각각 정렬된 리스트로 보관하고 있고, 매니저는 둘을 합친 전체 매출의 중앙값을 보고 싶어합니다. 정렬된 두 리스트 `zonesA`와 `zonesB`가 주어졌을 때, 합쳐진 리스트의 중앙값 — 전체 개수가 홀수면 가운데 값, 짝수면 가운데 두 값의 평균 — 을 반환하세요.

합치는 과정은 `O(log(m + n))` 시간 안에 돌아가야 합니다. 여기서 `m = zonesA.length`, `n = zonesB.length`입니다.

**예시 1:**
```
Input: zonesA = [2,5], zonesB = [4]
Output: 4.0
Explanation: The merged list is [2,4,5]; the middle value is 4.
```

**예시 2:**
```
Input: zonesA = [3,8], zonesB = [5,11]
Output: 6.5
Explanation: The merged list is [3,5,8,11]; the median is (5 + 8) / 2 = 6.5.
```

**예시 3:**
```
Input: zonesA = [], zonesB = [12]
Output: 12.0
Explanation: Only one value, so the median is that value.
```$KO$,
    $KO$- `0 <= zonesA.length, zonesB.length <= 1500`
- `1 <= zonesA.length + zonesB.length <= 3000`
- `|zonesA[i]|, |zonesB[i]| <= 10^7`
- 두 리스트 모두 오름차순으로 정렬되어 있습니다.$KO$
);

-- min-wait-route
UPDATE problems SET
    title = $$Min Wait Route$$,
    description = $$You're driving across town and your maps app shows the wait in minutes at every intersection on a grid, and you want the cheapest path from home (top-left) to your friend's place (bottom-right). From any intersection you can only go one block east or one block south.

Given `grid`, return the smallest total wait along any valid route, counting every intersection you pass through including both endpoints.

**Example 1:**
```
Input: grid = [[2,1,4],[5,3,2],[1,2,1]]
Output: 9
Explanation: The route 2 -> 1 -> 3 -> 2 -> 1 sums to 9 minutes, the best achievable.
```

**Example 2:**
```
Input: grid = [[3,1],[2,4],[1,5]]
Output: 11
Explanation: The route 3 -> 2 -> 1 -> 5 sums to 11 minutes; the alternative 3 -> 1 -> 4 -> 5 totals 13.
```$$,
    constraints = $$- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 200`
- `0 <= grid[i][j] <= 200`$$
WHERE slug = $$min-wait-route$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$min-wait-route$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$min-wait-route$$),
    'ko',
    $KO$최소 대기 경로$KO$,
    $KO$시내를 운전하는 중인데, 지도 앱이 격자 위 모든 교차로의 대기 시간(분)을 보여줍니다. 집(좌상단)에서 친구네(우하단)까지 가장 비용이 적게 드는 경로를 찾고 싶습니다. 어떤 교차로에서든 동쪽 한 블록 또는 남쪽 한 블록으로만 갈 수 있습니다.

`grid`가 주어졌을 때, 시작과 끝 지점을 포함해 지나는 모든 교차로를 합산한 가장 작은 총 대기 시간을 반환하세요.

**예시 1:**
```
Input: grid = [[2,1,4],[5,3,2],[1,2,1]]
Output: 9
Explanation: The route 2 -> 1 -> 3 -> 2 -> 1 sums to 9 minutes, the best achievable.
```

**예시 2:**
```
Input: grid = [[3,1],[2,4],[1,5]]
Output: 11
Explanation: The route 3 -> 2 -> 1 -> 5 sums to 11 minutes; the alternative 3 -> 1 -> 4 -> 5 totals 13.
```$KO$,
    $KO$- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 200`
- `0 <= grid[i][j] <= 200`$KO$
);

-- min-zone-code-edits
UPDATE problems SET
    title = $$Min Zone Code Edits$$,
    description = $$You're retyping a lowercase cheat code one letter at a time so it matches a new version in your game wiki. Each keystroke can insert a letter, delete a letter, or swap one letter for a different one.

Given the old code `source` and the new code `target`, return the fewest keystrokes needed to turn `source` into `target`.

**Example 1:**
```
Input: source = "coral", target = "carol"
Output: 2
Explanation: Replace the 'o' at index 1 with 'a', then replace the 'a' at index 3 with 'o'.
```

**Example 2:**
```
Input: source = "sunset", target = "sunrise"
Output: 3
Explanation: Delete the trailing 't' (sunset -> sunse), insert 'r' after the 'n' (sunse -> sunrse), then insert 'i' after that 'r' (sunrse -> sunrise).
```$$,
    constraints = $$- `0 <= source.length, target.length <= 500`
- `source` and `target` consist of lowercase English letters.$$
WHERE slug = $$min-zone-code-edits$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$min-zone-code-edits$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$min-zone-code-edits$$),
    'ko',
    $KO$최소 편집 횟수$KO$,
    $KO$게임 위키에 올라온 새 버전에 맞추려고, 소문자 치트 코드를 한 글자씩 고쳐 치고 있습니다. 키 하나로 글자를 끼워 넣거나, 지우거나, 다른 글자로 바꿀 수 있어요.

옛 코드 `source`와 새 코드 `target`이 주어질 때, `source`를 `target`으로 바꾸는 데 필요한 최소 키 입력 횟수를 반환하세요.

**예시 1:**
```
Input: source = "coral", target = "carol"
Output: 2
Explanation: 인덱스 1의 'o'를 'a'로 바꾸고, 인덱스 3의 'a'를 'o'로 바꿉니다.
```

**예시 2:**
```
Input: source = "sunset", target = "sunrise"
Output: 3
Explanation: 끝의 't'를 지우고 (sunset -> sunse), 'n' 뒤에 'r'을 끼우고 (sunse -> sunrse), 그 'r' 뒤에 'i'를 끼웁니다 (sunrse -> sunrise).
```$KO$,
    $KO$- `0 <= source.length, target.length <= 500`
- `source`와 `target`은 영어 소문자로만 이루어져 있습니다.$KO$
);

-- minimum-stack
UPDATE problems SET
    title = $$Low-Score Tracking Stack$$,
    description = $$You're building a speedrun tool that logs each attempt's score onto a stack, and a side panel should always show the lowest score still on the stack.

Build `LowTrackStack` so `push`, `pop`, `top`, and `getMin` all run in `O(1)`:

- `LowTrackStack()` starts with an empty stack.
- `void push(int val)` adds attempt score `val` on top.
- `void pop()` removes the top score.
- `int top()` returns the top score without removing it.
- `int getMin()` returns the smallest score currently on the stack.

**Example 1:**
```
Input:
["LowTrackStack","push","push","push","getMin","pop","top","getMin"]
[[],[12],[6],[-2],[],[],[],[]]
Output: [null,null,null,null,-2,null,6,6]
```
Three scores (12, 6, -2) are pushed. `getMin` returns `-2`. After a pop the stack is `[12, 6]`; `top` returns `6` and `getMin` returns `6` since the previous minimum is gone.

`pop`, `top`, and `getMin` are only called when at least one score has been pushed.$$,
    constraints = $$- `-10^8 <= val <= 10^8`
- `pop`, `top`, and `getMin` are only invoked after at least one element has been pushed.
- At most `20000` calls will be made across `push`, `pop`, `top`, and `getMin` combined.$$
WHERE slug = $$minimum-stack$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$minimum-stack$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$minimum-stack$$),
    'ko',
    $KO$최저값 추적 스택$KO$,
    $KO$스피드런 도구를 만드는데, 각 시도의 점수를 스택에 쌓으면서 사이드 패널에는 스택에 남아 있는 가장 낮은 점수를 항상 보여줘야 합니다.

`push`, `pop`, `top`, `getMin`이 모두 `O(1)`에 동작하도록 `LowTrackStack`을 구현하세요.

- `LowTrackStack()` — 빈 스택으로 시작합니다.
- `void push(int val)` — 시도 점수 `val`을 맨 위에 얹습니다.
- `void pop()` — 맨 위 점수를 제거합니다.
- `int top()` — 맨 위 점수를 제거하지 않고 반환합니다.
- `int getMin()` — 스택에 현재 남아 있는 점수 중 가장 작은 값을 반환합니다.

**예시 1:**
```
Input:
["LowTrackStack","push","push","push","getMin","pop","top","getMin"]
[[],[12],[6],[-2],[],[],[],[]]
Output: [null,null,null,null,-2,null,6,6]
```
점수 세 개 (12, 6, -2)를 올리면 `getMin`은 `-2`를 반환합니다. `pop` 한 번 뒤 스택은 `[12, 6]`이 되어 `top`은 `6`, 이전 최소값이 사라졌으므로 `getMin`도 `6`을 반환합니다.

`pop`, `top`, `getMin`은 적어도 한 번 `push`가 된 뒤에만 호출됩니다.$KO$,
    $KO$- `-10^8 <= val <= 10^8`
- `pop`, `top`, `getMin`은 적어도 한 번 `push`된 후에만 호출됩니다.
- `push`, `pop`, `top`, `getMin`은 합쳐서 최대 `20000`번 호출됩니다.$KO$
);

-- mirror-headline-splits
UPDATE problems SET
    title = $$Mirror Menu Splits$$,
    description = $$The barista is chalking today's special onto the board as a single lowercase string `menu`, and wants to split it into chunks that each read the same forwards and backwards. A chunk can be a single letter.

Given `menu`, implement `splitMirrorPhrases` to return every ordered split of `menu` where each piece is a palindrome. The split must cover the whole string left to right. Outer list order doesn't matter.

**Example 1:**
```
Input: menu = "dbbc"
Output: [["d","b","b","c"],["d","bb","c"]]
Explanation: Two valid splits. Every piece - "d", "b", "bb", "c" - is a palindrome.
```

**Example 2:**
```
Input: menu = "ef"
Output: [["e","f"]]
Explanation: "ef" is not a palindrome, so the only valid split is letter-by-letter.
```$$,
    constraints = $$- `1 <= menu.length <= 16`
- `menu` consists of lowercase English letters only.$$
WHERE slug = $$mirror-headline-splits$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$mirror-headline-splits$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$mirror-headline-splits$$),
    'ko',
    $KO$팰린드롬 조각으로 쪼개기$KO$,
    $KO$바리스타가 오늘의 스페셜을 소문자 문자열 `menu` 하나로 보드에 적는데, 이걸 앞뒤로 똑같이 읽히는 조각들로 쪼개고 싶어 합니다. 조각은 글자 하나짜리여도 괜찮아요.

`menu`가 주어질 때, 각 조각이 팰린드롬이 되도록 왼쪽에서 오른쪽으로 문자열 전체를 덮는 모든 분할을 반환하는 `splitMirrorPhrases`를 구현하세요. 바깥 리스트의 순서는 상관없습니다.

**예시 1:**
```
Input: menu = "dbbc"
Output: [["d","b","b","c"],["d","bb","c"]]
Explanation: 두 가지 분할이 유효합니다. "d", "b", "bb", "c" 모두 팰린드롬입니다.
```

**예시 2:**
```
Input: menu = "ef"
Output: [["e","f"]]
Explanation: "ef"가 팰린드롬이 아니므로 글자별로 쪼개는 것만 가능합니다.
```$KO$,
    $KO$- `1 <= menu.length <= 16`
- `menu`는 영어 소문자로만 이루어져 있습니다.$KO$
);

-- montage-scene-picks
UPDATE problems SET
    title = $$Snack Combo Picks$$,
    description = $$You're staring at a handful of snack-pack tickets `snacks`, each with a flavor code, and you want to write down every unique combo you could grab from the pile. Some flavors repeat because the vending machine always drops multiples.

Given the integer array `snacks`, implement `listMontageScenes` to return every distinct multiset of tickets as a list of lists, including the empty combo. Any order is fine.

**Example 1:**
```
Input: snacks = [2,5,5]
Output: [[],[2],[2,5],[2,5,5],[5],[5,5]]
```

**Example 2:**
```
Input: snacks = [5]
Output: [[],[5]]
```

**Example 3:**
```
Input: snacks = [2,2,2,1,2]
Output: [[],[1],[1,2],[1,2,2],[1,2,2,2],[1,2,2,2,2],[2],[2,2],[2,2,2],[2,2,2,2]]
Explanation: The flavor 2 appears four times and 1 appears once; each distinct multiset shows up exactly once.
```$$,
    constraints = $$- `1 <= snacks.length <= 10`
- `-10 <= snacks[i] <= 10`$$
WHERE slug = $$montage-scene-picks$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$montage-scene-picks$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$montage-scene-picks$$),
    'ko',
    $KO$간식 조합 뽑기$KO$,
    $KO$손에 쥔 간식팩 티켓 `snacks`를 보며, 이 더미에서 집을 수 있는 서로 다른 조합을 전부 적어두고 싶어요. 자판기가 항상 여러 개를 떨구니까 같은 맛이 반복해서 나옵니다.

정수 배열 `snacks`가 주어질 때, 빈 조합까지 포함해 티켓의 서로 다른 중복집합(multiset)을 전부 리스트의 리스트로 반환하는 `listMontageScenes`를 구현하세요. 순서는 상관없습니다.

**예시 1:**
```
Input: snacks = [2,5,5]
Output: [[],[2],[2,5],[2,5,5],[5],[5,5]]
```

**예시 2:**
```
Input: snacks = [5]
Output: [[],[5]]
```

**예시 3:**
```
Input: snacks = [2,2,2,1,2]
Output: [[],[1],[1,2],[1,2,2],[1,2,2,2],[1,2,2,2,2],[2],[2,2],[2,2,2],[2,2,2,2]]
Explanation: 맛 2가 네 번, 맛 1이 한 번 나오고, 서로 다른 중복집합이 각각 정확히 한 번씩 등장합니다.
```$KO$,
    $KO$- `1 <= snacks.length <= 10`
- `-10 <= snacks[i] <= 10`$KO$
);

-- nearest-depot-stops
UPDATE problems SET
    title = $$Nearest Cafe Stops$$,
    description = $$You're a barista planning a morning delivery run; every shop you supply sits at an `[x, y]` coordinate with your cafe at the origin. You want the `k` shops closest to the cafe so you can load the first bike with short-hop orders.

Distance is Euclidean, `sqrt(x^2 + y^2)`. Return the `k` nearest stops in any order; the answer is unique up to ordering.

**Example 1:**
```
Input: stops = [[2,4],[7,7]], k = 1
Output: [[2,4]]
Explanation: sqrt(2^2 + 4^2) ≈ 4.47 is less than sqrt(7^2 + 7^2) ≈ 9.90, so (2, 4) is the nearest stop.
```

**Example 2:**
```
Input: stops = [[5,5],[1,2],[-3,1],[4,-4]], k = 2
Output: [[-3,1],[1,2]]
Explanation: The closest two stops are (-3, 1) at sqrt(10) and (1, 2) at sqrt(5).
```$$,
    constraints = $$- `1 <= k <= stops.length <= 2 * 10^3`
- `|x|, |y| <= 10^8`$$
WHERE slug = $$nearest-depot-stops$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$nearest-depot-stops$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$nearest-depot-stops$$),
    'ko',
    $KO$가까운 카페 배달지$KO$,
    $KO$당신은 아침 배달을 계획하는 바리스타입니다. 납품처는 `[x, y]` 좌표에 있고, 카페는 원점에 있어요. 첫 배달 자전거에 짧은 동선의 주문을 실으려면, 카페에서 가장 가까운 `k`개의 납품처를 고르면 됩니다.

거리는 유클리드 거리 `sqrt(x^2 + y^2)`입니다. 가장 가까운 `k`개의 배달지를 임의의 순서로 반환하세요. 답은 순서를 제외하면 유일합니다.

**예시 1:**
```
Input: stops = [[2,4],[7,7]], k = 1
Output: [[2,4]]
Explanation: sqrt(2^2 + 4^2) ≈ 4.47이 sqrt(7^2 + 7^2) ≈ 9.90보다 작아 (2, 4)가 가장 가깝습니다.
```

**예시 2:**
```
Input: stops = [[5,5],[1,2],[-3,1],[4,-4]], k = 2
Output: [[-3,1],[1,2]]
Explanation: 가장 가까운 두 곳은 sqrt(10)의 (-3, 1)과 sqrt(5)의 (1, 2)입니다.
```$KO$,
    $KO$- `1 <= k <= stops.length <= 2 * 10^3`
- `|x|, |y| <= 10^8`$KO$
);

-- next-shot-order
UPDATE problems SET
    title = $$Next Shot Order$$,
    description = $$Your office runs a daily standup in a rotating order stored as integer ids in `shotOrder`. Every morning the organizer bumps the lineup to the next lexicographically greater arrangement of the same ids; if today's lineup is already the very last one, he resets to the first arrangement.

Implement `advanceShotOrder` to rearrange `shotOrder` **in place** to the next greater permutation, or the smallest permutation if none exists. Use only constant extra memory.

**Example 1:**
```
Input: shotOrder = [2,3,4]
Output: [2,4,3]
Explanation: The next arrangement after [2,3,4] is [2,4,3].
```

**Example 2:**
```
Input: shotOrder = [5,4,3,2]
Output: [2,3,4,5]
Explanation: [5,4,3,2] is the largest arrangement, so the lineup resets to ascending order.
```$$,
    constraints = $$- `1 <= shotOrder.length <= 100`
- `0 <= shotOrder[i] <= 100`$$
WHERE slug = $$next-shot-order$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$next-shot-order$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$next-shot-order$$),
    'ko',
    $KO$다음 발표 순서$KO$,
    $KO$사무실의 일일 스탠드업은 정수 id들의 순서 `shotOrder`로 돌아갑니다. 매일 아침 주관자는 같은 id들로 만들 수 있는 사전식으로 바로 다음 더 큰 배열로 라인업을 바꾸고, 오늘이 이미 가장 마지막 배열이라면 가장 처음 배열로 되돌립니다.

`shotOrder`를 **그 자리에서** 다음으로 큰 순열로 재배치하거나, 그런 순열이 없으면 가장 작은 순열로 바꾸는 `advanceShotOrder`를 구현하세요. 추가 메모리는 상수만 써야 합니다.

**예시 1:**
```
Input: shotOrder = [2,3,4]
Output: [2,4,3]
Explanation: [2,3,4] 다음 배열은 [2,4,3]입니다.
```

**예시 2:**
```
Input: shotOrder = [5,4,3,2]
Output: [2,3,4,5]
Explanation: [5,4,3,2]가 가장 큰 배열이므로 오름차순으로 되돌아갑니다.
```$KO$,
    $KO$- `1 <= shotOrder.length <= 100`
- `0 <= shotOrder[i] <= 100`$KO$
);

-- nth-dimmest-target
UPDATE problems SET
    title = $$Nth Best Score$$,
    description = $$Your party's score board is stored as a binary search tree keyed by score, so an in-order walk lists scores from lowest to highest. You want to pull out the `k`-th lowest score for the weekly rankings.

Given the `root` of the tree and a 1-indexed position `k`, implement `pickNthTarget` to return the `k`-th score in ascending order. Assume `k` is between `1` and the total number of scores in the tree.

**Example 1:**
```
Input: root = [8,4,12,2,6,10,14], k = 4
Output: 8
Explanation: In-order traversal yields [2,4,6,8,10,12,14]. The 4th entry is 8.
```

**Example 2:**
```
Input: root = [20,10,30,5,15,25,35,null,7], k = 2
Output: 7
Explanation: In-order traversal yields [5,7,10,15,20,25,30,35]. The 2nd entry is 7.
```$$,
    constraints = $$- The number of scores in the tree is `n`.
- `1 <= k <= n <= 8 * 10^4`
- `0 <= Node.val <= 10^8`
- The tree is a valid binary search tree.$$
WHERE slug = $$nth-dimmest-target$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$nth-dimmest-target$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$nth-dimmest-target$$),
    'ko',
    $KO$N번째 낮은 점수$KO$,
    $KO$파티의 점수판이 점수를 키로 하는 이진 탐색 트리에 저장돼 있어서 중위 순회를 하면 점수가 낮은 것부터 높은 것까지 차례로 나옵니다. 주간 랭킹을 뽑기 위해 `k`번째로 낮은 점수를 꺼내고 싶습니다.

트리의 `root`와 1부터 세는 위치 `k`가 주어질 때, `pickNthTarget`을 구현해서 오름차순으로 `k`번째 점수를 반환하세요. `k`는 `1` 이상이고 트리에 있는 점수 개수 이하라고 가정합니다.

**예시 1:**
```
Input: root = [8,4,12,2,6,10,14], k = 4
Output: 8
Explanation: In-order traversal yields [2,4,6,8,10,12,14]. The 4th entry is 8.
```

**예시 2:**
```
Input: root = [20,10,30,5,15,25,35,null,7], k = 2
Output: 7
Explanation: In-order traversal yields [5,7,10,15,20,25,30,35]. The 2nd entry is 7.
```$KO$,
    $KO$- 트리에 들어 있는 점수 개수는 `n`입니다.
- `1 <= k <= n <= 8 * 10^4`
- `0 <= Node.val <= 10^8`
- 트리는 올바른 이진 탐색 트리입니다.$KO$
);

-- nth-smooth-batch
UPDATE problems SET
    title = $$Nth Smooth Batch$$,
    description = $$In a retro puzzle game, a level is only unlockable if its number's prime factors come from `{2, 3, 5}`. By convention `1` is also unlockable (it has no prime factors). The first few unlockable levels are `1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, ...` (notice `7` is skipped).

Return the `n`-th unlockable level in ascending order (`1`-indexed).

**Example 1:**
```
Input: n = 7
Output: 8
Explanation: The first seven unlockable levels are 1, 2, 3, 4, 5, 6, 8, so the 7th is 8.
```

**Example 2:**
```
Input: n = 12
Output: 16
Explanation: The first twelve unlockable levels are 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, so the 12th is 16.
```$$,
    constraints = $$- `1 <= n <= 1500`$$
WHERE slug = $$nth-smooth-batch$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$nth-smooth-batch$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$nth-smooth-batch$$),
    'ko',
    $KO$N번째 해금 레벨$KO$,
    $KO$레트로 퍼즐 게임에서 레벨 번호의 소인수가 모두 `{2, 3, 5}` 안에 들어가야만 해당 레벨이 해금됩니다. 관례상 `1`도 해금 가능한 레벨로 칩니다(소인수가 아예 없으니까요). 처음 몇 개의 해금 레벨은 `1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, ...`입니다 (`7`은 빠져 있는 점에 주목하세요).

오름차순으로 `n`번째 해금 레벨을 반환하세요 (`1`부터 세기).

**예시 1:**
```
Input: n = 7
Output: 8
Explanation: The first seven unlockable levels are 1, 2, 3, 4, 5, 6, 8, so the 7th is 8.
```

**예시 2:**
```
Input: n = 12
Output: 16
Explanation: The first twelve unlockable levels are 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, so the 12th is 16.
```$KO$,
    $KO$- `1 <= n <= 1500`$KO$
);

-- order-tank-deviations
UPDATE problems SET
    title = $$Sort Latte Temperatures$$,
    description = $$Your cafe's thermometer logs each latte's temperature difference from the target, stored in `drifts` sorted non-decreasingly (cold pours negative, hot pours positive). For a quality report you want the **squared** drift of every cup, listed from smallest to largest.

Return the squared drifts in non-decreasing order. Aim for an O(n) pass — no general-purpose sort.

**Example 1:**
```
Input: drifts = [-5,-2,0,4,9]
Output: [0,4,16,25,81]
```

**Example 2:**
```
Input: drifts = [-6,-4,1,3,8]
Output: [1,9,16,36,64]
```

**Example 3:**
```
Input: drifts = [2,3,5,7]
Output: [4,9,25,49]
Explanation: Every value is non-negative, so squaring keeps the order.
```$$,
    constraints = $$- `1 <= drifts.length <= 2 * 10^5`
- `-8 * 10^3 <= drifts[i] <= 8 * 10^3`
- `drifts` is sorted in non-decreasing order.$$
WHERE slug = $$order-tank-deviations$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$order-tank-deviations$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$order-tank-deviations$$),
    'ko',
    $KO$라떼 온도 편차 정렬$KO$,
    $KO$카페 온도계가 라떼마다 목표 온도에서 얼마나 벗어났는지 기록하고, 그 값이 비감소 순으로 `drifts`에 들어 있습니다(차가우면 음수, 뜨거우면 양수). 품질 리포트용으로 모든 잔의 편차를 **제곱**해 작은 순서부터 큰 순서로 나열하려 합니다.

제곱한 편차를 비감소 순으로 반환하세요. 일반 정렬을 쓰지 말고 O(n)에 한 번 훑는 방식으로 풀어 보세요.

**예시 1:**
```
Input: drifts = [-5,-2,0,4,9]
Output: [0,4,16,25,81]
```

**예시 2:**
```
Input: drifts = [-6,-4,1,3,8]
Output: [1,9,16,36,64]
```

**예시 3:**
```
Input: drifts = [2,3,5,7]
Output: [4,9,25,49]
Explanation: Every value is non-negative, so squaring keeps the order.
```$KO$,
    $KO$- `1 <= drifts.length <= 2 * 10^5`
- `-8 * 10^3 <= drifts[i] <= 8 * 10^3`
- `drifts`는 비감소 순으로 정렬되어 있습니다.$KO$
);

-- order-ticket-holders
UPDATE problems SET
    title = $$Order Ticket Holders$$,
    description = $$You're rebuilding the queue at a video-game tournament. Each player is described by a pair `[h, k]`, where `h` is their height and `k` is the number of players **ahead** of them whose height is at least `h`. The queue is currently scrambled.

Given `players`, return the reordered queue as a list of `[h, k]` pairs from front to back. A valid ordering is guaranteed to exist.

**Example 1:**
```
Input: players = [[8,0],[6,0],[8,1],[4,2],[6,2]]
Output: [[6,0],[8,0],[4,2],[6,2],[8,1]]
```

**Example 2:**
```
Input: players = [[5,0],[4,1],[5,1],[3,2]]
Output: [[5,0],[4,1],[3,2],[5,1]]
```$$,
    constraints = $$- `1 <= players.length <= 2 * 10^3`
- `0 <= h <= 8 * 10^5`
- `0 <= k < players.length`
- A valid queue ordering is guaranteed to exist.$$
WHERE slug = $$order-ticket-holders$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$order-ticket-holders$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$order-ticket-holders$$),
    'ko',
    $KO$참가자 줄 세우기$KO$,
    $KO$게임 토너먼트 대기줄을 다시 세우는 중입니다. 각 참가자는 `[h, k]` 쌍으로 표현되는데, `h`는 키, `k`는 자기 **앞**에 서 있는 사람 중 키가 `h` 이상인 사람의 수입니다. 지금은 줄이 뒤죽박죽이 되어 있습니다.

`players`가 주어졌을 때, 맨 앞부터 맨 뒤까지 `[h, k]` 쌍의 리스트로 정렬된 줄을 반환하세요. 유효한 줄 배치가 반드시 존재한다고 보장됩니다.

**예시 1:**
```
Input: players = [[8,0],[6,0],[8,1],[4,2],[6,2]]
Output: [[6,0],[8,0],[4,2],[6,2],[8,1]]
```

**예시 2:**
```
Input: players = [[5,0],[4,1],[5,1],[3,2]]
Output: [[5,0],[4,1],[3,2],[5,1]]
```$KO$,
    $KO$- `1 <= players.length <= 2 * 10^3`
- `0 <= h <= 8 * 10^5`
- `0 <= k < players.length`
- 유효한 줄 배치가 반드시 존재합니다.$KO$
);

-- outward-shelf-walk
UPDATE problems SET
    title = $$Outward Shelf Walk$$,
    description = $$Your game character walks a rectangular grid in an outward spiral: across the top row, down the rightmost column, back along the bottom row, up the leftmost column, then inward and repeat. Given an `m x n` grid `board` where each cell holds an item value, return the values in the order your character visits them. Each cell is visited exactly once.

**Example 1:**
```
Input: board = [[1,2],[3,4]]
Output: [1,2,4,3]
```

**Example 2:**
```
Input: board = [[5,6,7],[8,9,10],[11,12,13],[14,15,16]]
Output: [5,6,7,10,13,16,15,14,11,8,9,12]
```$$,
    constraints = $$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 10`
- `-100 <= board[i][j] <= 100`$$
WHERE slug = $$outward-shelf-walk$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$outward-shelf-walk$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$outward-shelf-walk$$),
    'ko',
    $KO$바깥쪽 선반 돌기$KO$,
    $KO$게임 속 캐릭터가 직사각형 격자를 바깥쪽부터 나선 모양으로 걷습니다. 맨 윗줄을 가로지른 뒤, 오른쪽 끝 열을 따라 내려가고, 다시 맨 아랫줄을 되짚은 다음, 왼쪽 끝 열을 타고 올라가고, 안쪽으로 한 칸 들어가서 같은 패턴을 반복합니다. 각 칸에 아이템 값이 들어 있는 `m x n` 격자 `board`가 주어졌을 때, 캐릭터가 방문하는 순서대로 값을 반환하세요. 모든 칸은 정확히 한 번씩 방문합니다.

**예시 1:**
```
Input: board = [[1,2],[3,4]]
Output: [1,2,4,3]
```

**예시 2:**
```
Input: board = [[5,6,7],[8,9,10],[11,12,13],[14,15,16]]
Output: [5,6,7,10,13,16,15,14,11,8,9,12]
```$KO$,
    $KO$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 10`
- `-100 <= board[i][j] <= 100`$KO$
);

-- pair-crates-for-order
UPDATE problems SET
    title = $$Pair Crates For Order$$,
    description = $$You and a friend are packing lunchboxes for a picnic. Each lunchbox fits **at most two snacks** and can't exceed `capacity` grams total, and every snack has to go in some lunchbox.

Given an integer array `crates` where `crates[i]` is snack `i`'s weight, return the **minimum number of lunchboxes** you need.

**Example 1:**
```
Input: crates = [2,4], capacity = 6
Output: 1
Explanation: Both snacks weigh 6 grams together, which fits one lunchbox.
```

**Example 2:**
```
Input: crates = [4,3,1,2], capacity = 4
Output: 3
Explanation: Pair the 3 with the 1 in one lunchbox. The 2 goes alone, the 4 goes alone — three lunchboxes.
```$$,
    constraints = $$- `1 <= crates.length <= 2 * 10^5`
- `1 <= crates[i] <= capacity <= 2 * 10^3`$$
WHERE slug = $$pair-crates-for-order$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$pair-crates-for-order$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$pair-crates-for-order$$),
    'ko',
    $KO$도시락 상자 짝짓기$KO$,
    $KO$친구와 함께 피크닉에 가져갈 도시락을 싸고 있습니다. 도시락 하나에는 **간식이 최대 두 개**까지 들어가고, 총 무게는 `capacity` 그램을 넘을 수 없으며, 모든 간식은 어떤 도시락에든 반드시 담겨야 합니다.

`crates[i]`가 간식 `i`의 무게인 정수 배열 `crates`가 주어졌을 때, 필요한 **최소 도시락 개수**를 반환하세요.

**예시 1:**
```
Input: crates = [2,4], capacity = 6
Output: 1
Explanation: Both snacks weigh 6 grams together, which fits one lunchbox.
```

**예시 2:**
```
Input: crates = [4,3,1,2], capacity = 4
Output: 3
Explanation: Pair the 3 with the 1 in one lunchbox. The 2 goes alone, the 4 goes alone — three lunchboxes.
```$KO$,
    $KO$- `1 <= crates.length <= 2 * 10^5`
- `1 <= crates[i] <= capacity <= 2 * 10^3`$KO$
);

-- pair-tiers-budget
UPDATE problems SET
    title = $$Pair Tiers Within Budget$$,
    description = $$You're at the cafe reading a **1-indexed** menu `menuPrice` sorted in non-decreasing order and your wallet has exactly `budget` to spend. Pick two different menu items whose prices add up to `budget` and return their menu numbers as `[item1, item2]` with `1 <= item1 < item2 <= menuPrice.length`.

Exactly one pair works, and you must use only constant extra space beyond the input.

**Example 1:**
```
Input: menuPrice = [12,30,45,58,70,85], budget = 100
Output: [2,5]
Explanation: Item 2 costs 30 and item 5 costs 70, which together match the 100 budget.
```

**Example 2:**
```
Input: menuPrice = [5,14,22,40], budget = 54
Output: [2,4]
Explanation: Item 2 is 14 and item 4 is 40; 14 + 40 = 54.
```$$,
    constraints = $$- `2 <= menuPrice.length <= 2 * 10^5`
- `-10^8 <= menuPrice[i] <= 10^8`
- `menuPrice` is sorted in non-decreasing order.
- `-2 * 10^8 <= budget <= 2 * 10^8`
- The input is generated so that exactly one valid pair exists.$$
WHERE slug = $$pair-tiers-budget$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$pair-tiers-budget$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$pair-tiers-budget$$),
    'ko',
    $KO$예산 맞춰 두 메뉴 고르기$KO$,
    $KO$카페에서 비내림차순으로 정렬된 **1-인덱스** 메뉴판 `menuPrice`를 보고 있고, 지갑에는 정확히 `budget`만큼이 있습니다. 가격의 합이 `budget`이 되는 서로 다른 두 메뉴를 골라 그 메뉴 번호를 `[item1, item2]` 형태로 반환하세요. 조건은 `1 <= item1 < item2 <= menuPrice.length`입니다.

정답 짝은 정확히 하나이고, 입력 외에는 상수 크기의 추가 공간만 써야 합니다.

**예시 1:**
```
Input: menuPrice = [12,30,45,58,70,85], budget = 100
Output: [2,5]
Explanation: Item 2 costs 30 and item 5 costs 70, which together match the 100 budget.
```

**예시 2:**
```
Input: menuPrice = [5,14,22,40], budget = 54
Output: [2,4]
Explanation: Item 2 is 14 and item 4 is 40; 14 + 40 = 54.
```$KO$,
    $KO$- `2 <= menuPrice.length <= 2 * 10^5`
- `-10^8 <= menuPrice[i] <= 10^8`
- `menuPrice`는 비내림차순으로 정렬되어 있습니다.
- `-2 * 10^8 <= budget <= 2 * 10^8`
- 입력은 유효한 짝이 정확히 하나 존재하도록 만들어져 있습니다.$KO$
);

-- partition-tank-doses
UPDATE problems SET
    title = $$Assign Plus-or-Minus Tickets$$,
    description = $$Your team is grinding through a backlog where each ticket has a point value, and for every ticket you either **add** or **subtract** its points from the team's daily score. Given an array `tickets` of point values and an integer `target` equal to the desired net score, count how many plus/minus assignments produce exactly `target`.

Implement `partitionTankDoses` to return the number of valid assignments.

**Example 1:**
```
Input: tickets = [2,2,2,2], target = 4
Output: 4
Explanation: Net +4 means 3 tickets added and 1 subtracted; 4 choices for which is subtracted.
```

**Example 2:**
```
Input: tickets = [4,6,8], target = 10
Output: 1
Explanation: The only net +10 assignment is -4 + 6 + 8 = 10.
```$$,
    constraints = $$- `1 <= tickets.length <= 22`
- `0 <= tickets[i] <= 900`
- `-900 <= target <= 900`$$
WHERE slug = $$partition-tank-doses$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$partition-tank-doses$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$partition-tank-doses$$),
    'ko',
    $KO$티켓에 플러스·마이너스 붙이기$KO$,
    $KO$팀이 백로그에 쌓인 티켓들을 처리하고 있는데, 각 티켓에는 포인트 값이 매겨져 있습니다. 매 티켓마다 그 포인트를 팀의 일일 점수에 **더하거나** **빼서** 반영합니다. 포인트 값이 들어 있는 배열 `tickets`와 원하는 순점수에 해당하는 정수 `target`이 주어졌을 때, `target`을 정확히 만들어내는 플러스/마이너스 배정이 몇 가지인지 세어 보세요.

유효한 배정의 수를 반환하도록 `partitionTankDoses`를 구현하세요.

**예시 1:**
```
Input: tickets = [2,2,2,2], target = 4
Output: 4
Explanation: Net +4 means 3 tickets added and 1 subtracted; 4 choices for which is subtracted.
```

**예시 2:**
```
Input: tickets = [4,6,8], target = 10
Output: 1
Explanation: The only net +10 assignment is -4 + 6 + 8 = 10.
```$KO$,
    $KO$- `1 <= tickets.length <= 22`
- `0 <= tickets[i] <= 900`
- `-900 <= target <= 900`$KO$
);

-- peak-flow-stretch
UPDATE problems SET
    title = $$Peak Combo Stretch$$,
    description = $$You're reviewing a rhythm-game replay where `combo[i]` is the combo count at beat `i`, and `k` is the length of the clip window the highlights reel uses. For every window of `k` consecutive beats sliding from start to end, you want the highest combo seen inside it.

Implement `peakFlowPerStretch` so its `i`-th output is the max of `combo[i..i+k-1]`.

**Example 1:**
```
Input: combo = [4,2,8,5,1,7,9,3], k = 4
Output: [8,8,8,9,9]
Explanation:
Window                         Peak
[4  2  8  5]  1  7  9  3        8
 4 [2  8  5  1] 7  9  3         8
 4  2 [8  5  1  7] 9  3         8
 4  2  8 [5  1  7  9] 3         9
 4  2  8  5 [1  7  9  3]        9
```

**Example 2:**
```
Input: combo = [6,6,6], k = 2
Output: [6,6]
Explanation: Every two-beat window has the same peak combo.
```$$,
    constraints = $$- `1 <= combo.length <= 2 * 10^5`
- `-8000 <= combo[i] <= 8000`
- `1 <= k <= combo.length`$$
WHERE slug = $$peak-flow-stretch$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$peak-flow-stretch$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$peak-flow-stretch$$),
    'ko',
    $KO$구간 최고 콤보$KO$,
    $KO$리듬 게임 리플레이를 돌려보는 중인데, `combo[i]`는 `i`번째 비트 시점의 콤보 수이고, `k`는 하이라이트 영상에서 쓰는 클립 창의 길이입니다. 처음부터 끝까지 `k`개의 연속된 비트로 창을 한 칸씩 밀 때마다, 그 창 안에서 본 가장 큰 콤보를 알고 싶습니다.

`peakFlowPerStretch`를 구현해서, `i`번째 출력이 `combo[i..i+k-1]`의 최댓값이 되도록 하세요.

**예시 1:**
```
Input: combo = [4,2,8,5,1,7,9,3], k = 4
Output: [8,8,8,9,9]
Explanation:
Window                         Peak
[4  2  8  5]  1  7  9  3        8
 4 [2  8  5  1] 7  9  3         8
 4  2 [8  5  1  7] 9  3         8
 4  2  8 [5  1  7  9] 3         9
 4  2  8  5 [1  7  9  3]        9
```

**예시 2:**
```
Input: combo = [6,6,6], k = 2
Output: [6,6]
Explanation: Every two-beat window has the same peak combo.
```$KO$,
    $KO$- `1 <= combo.length <= 2 * 10^5`
- `-8000 <= combo[i] <= 8000`
- `1 <= k <= combo.length`$KO$
);

-- peak-gate-demand
UPDATE problems SET
    title = $$Peak Table Demand$$,
    description = $$A cafe wants to know the most tables it needs at once. You are given `visits`, where `visits[i] = [arrive, leave]` is the minute a group sits down and the minute they leave. A table seats one group at a time, and a group occupies the table for the half-open interval `[arrive, leave)` — a new group may take the same table the minute the previous one leaves.

Return the **minimum** number of tables the cafe needs so every group has a seat for their whole stay.

**Example 1:**
```
Input: visits = [[60,180],[90,150],[120,240],[200,300]]
Output: 3
Explanation: Between minute 120 and 150, three groups are seated at once, so three tables are required.
```

**Example 2:**
```
Input: visits = [[500,600],[100,200]]
Output: 1
Explanation: The two groups never overlap, so one table is enough.
```$$,
    constraints = $$- `1 <= visits.length <= 8000`
- `0 <= arrive < leave <= 2 * 10^5`$$
WHERE slug = $$peak-gate-demand$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$peak-gate-demand$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$peak-gate-demand$$),
    'ko',
    $KO$피크 타임 테이블 수요$KO$,
    $KO$카페에서 동시에 필요한 테이블 수가 최대 몇 개인지 알고 싶습니다. `visits`가 주어지는데, `visits[i] = [arrive, leave]`는 어떤 팀이 앉은 시각과 일어선 시각(영업 시작으로부터의 분)입니다. 한 테이블에는 한 번에 한 팀만 앉을 수 있고, 한 팀은 테이블을 반열린 구간 `[arrive, leave)` 동안 점유합니다. 이전 팀이 떠난 바로 그 분에 새 팀이 같은 테이블을 바로 쓸 수 있습니다.

모든 팀이 머무는 내내 자리를 가질 수 있도록 카페에 필요한 **최소** 테이블 수를 반환하세요.

**예시 1:**
```
Input: visits = [[60,180],[90,150],[120,240],[200,300]]
Output: 3
Explanation: Between minute 120 and 150, three groups are seated at once, so three tables are required.
```

**예시 2:**
```
Input: visits = [[500,600],[100,200]]
Output: 1
Explanation: The two groups never overlap, so one table is enough.
```$KO$,
    $KO$- `1 <= visits.length <= 8000`
- `0 <= arrive < leave <= 2 * 10^5`$KO$
);

-- peak-reading-window
UPDATE problems SET
    title = $$Peak Score Streak$$,
    description = $$You're scrolling through a rhythm game's per-note score log, where each entry is how many points that note gained or lost. You want to find the hottest streak: the contiguous, non-empty window of notes with the largest sum.

Return that maximum sum for `scores`.

**Example 1:**
```
Input: scores = [3,-2,5,-1,2,-8,4,3]
Output: 7
Explanation: The window [3,-2,5,-1,2] sums to 7, the max.
```

**Example 2:**
```
Input: scores = [2,1,-3,6,4]
Output: 10
Explanation: The window [6,4] sums to 10. The whole array also sums to 10.
```$$,
    constraints = $$- `1 <= scores.length <= 2 * 10^5`
- `|scores[i]| <= 10^8`$$
WHERE slug = $$peak-reading-window$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$peak-reading-window$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$peak-reading-window$$),
    'ko',
    $KO$최고 점수 구간$KO$,
    $KO$리듬 게임에서 노트별 점수 로그를 살펴보고 있는데, 각 항목은 그 노트로 얻거나 잃은 점수입니다. 연속된 비어 있지 않은 노트 구간 중 합이 가장 큰 "핫한" 구간을 찾고 싶습니다.

`scores`에 대해 그 최대 합을 반환하세요.

**예시 1:**
```
Input: scores = [3,-2,5,-1,2,-8,4,3]
Output: 7
Explanation: The window [3,-2,5,-1,2] sums to 7, the max.
```

**예시 2:**
```
Input: scores = [2,1,-3,6,4]
Output: 10
Explanation: The window [6,4] sums to 10. The whole array also sums to 10.
```$KO$,
    $KO$- `1 <= scores.length <= 2 * 10^5`
- `|scores[i]| <= 10^8`$KO$
);

-- peak-temp-swing
UPDATE problems SET
    title = $$Peak Temperature Swing$$,
    description = $$You logged your apartment's thermostat every hour and want to know the biggest jump from any earlier reading to a later one. Given the array `readings`, return the largest `readings[j] - readings[i]` with `i < j`.

If the temperature only ever drops, return `0`.

**Example 1:**
```
Input: readings = [14,9,11,8,12,15,10]
Output: 7
Explanation: Index 3 dips to 8, then index 5 climbs to 15 — a swing of 7.
```

**Example 2:**
```
Input: readings = [20,18,15,11]
Output: 0
Explanation: Only going down, so no positive swing.
```$$,
    constraints = $$- `1 <= readings.length <= 2 * 10^5`
- `0 <= readings[i] <= 8000`$$
WHERE slug = $$peak-temp-swing$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$peak-temp-swing$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$peak-temp-swing$$),
    'ko',
    $KO$최대 온도 변동$KO$,
    $KO$아파트 온도계를 한 시간마다 기록해 두었고, 어느 이른 시점의 값에서 그보다 늦은 시점의 값으로의 가장 큰 상승폭을 알고 싶습니다. 배열 `readings`가 주어졌을 때, `i < j`를 만족하는 가장 큰 `readings[j] - readings[i]`를 반환하세요.

온도가 계속 내려가기만 했다면 `0`을 반환합니다.

**예시 1:**
```
Input: readings = [14,9,11,8,12,15,10]
Output: 7
Explanation: Index 3 dips to 8, then index 5 climbs to 15 — a swing of 7.
```

**예시 2:**
```
Input: readings = [20,18,15,11]
Output: 0
Explanation: Only going down, so no positive swing.
```$KO$,
    $KO$- `1 <= readings.length <= 2 * 10^5`
- `0 <= readings[i] <= 8000`$KO$
);

-- pick-circuit-targets
UPDATE problems SET
    title = $$Pick Circuit Targets$$,
    description = $$You and your roommates arrange `n` donuts on a circular tray, and the tastiness of each donut is in the array `yields`. House rule: you can't grab two donuts that sit next to each other, and since the tray wraps, the first and last donuts count as neighbors.

Return the most total tastiness you can collect while obeying the no-neighbors rule.

**Example 1:**
```
Input: yields = [4,1,5,6,2]
Output: 10
Explanation: Take yields[0]=4 and yields[3]=6 for a total of 10. You can't also take yields[4]=2 because it sits next to yields[0].
```

**Example 2:**
```
Input: yields = [3,8,2,7,1,9]
Output: 24
Explanation: Taking yields[1]=8, yields[3]=7, yields[5]=9 totals 24. That only works because you skipped yields[0], which is a neighbor of yields[5].
```$$,
    constraints = $$- `1 <= yields.length <= 2 * 10^3`
- `0 <= yields[i] <= 5000`$$
WHERE slug = $$pick-circuit-targets$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$pick-circuit-targets$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$pick-circuit-targets$$),
    'ko',
    $KO$원형 도넛 고르기$KO$,
    $KO$룸메이트들과 함께 원형 쟁반에 `n`개의 도넛을 올려놨고, 각 도넛의 맛있음 점수는 배열 `yields`에 들어 있습니다. 집 규칙상 바로 옆에 붙은 두 도넛은 같이 집을 수 없고, 쟁반이 원형이라서 첫 번째 도넛과 마지막 도넛도 서로 이웃입니다.

이웃 금지 규칙을 지키면서 모을 수 있는 최대 맛있음 합을 반환하세요.

**예시 1:**
```
Input: yields = [4,1,5,6,2]
Output: 10
Explanation: Take yields[0]=4 and yields[3]=6 for a total of 10. You can't also take yields[4]=2 because it sits next to yields[0].
```

**예시 2:**
```
Input: yields = [3,8,2,7,1,9]
Output: 24
Explanation: Taking yields[1]=8, yields[3]=7, yields[5]=9 totals 24. That only works because you skipped yields[0], which is a neighbor of yields[5].
```$KO$,
    $KO$- `1 <= yields.length <= 2 * 10^3`
- `0 <= yields[i] <= 5000`$KO$
);

-- pick-least-effort-circuit
UPDATE problems SET
    title = $$Pick Least Effort Circuit$$,
    description = $$A platformer level has `n` checkpoints numbered `0` through `n-1`, and each one charges you `effort[i]` stamina when you land on it. You can start at checkpoint `0` or `1`, and from any checkpoint you can hop one or two tiles forward after paying its cost.

Return the minimum total stamina needed to step past the last checkpoint (position `n`).

**Example 1:**
```
Input: effort = [4,2,8,3,5,6]
Output: 10
Explanation: Start at checkpoint 1 (pay 2), hop to checkpoint 3 (pay 3), then to checkpoint 5 (pay 5) and step off. Total 2 + 3 + 5 = 10.
```

**Example 2:**
```
Input: effort = [7,1,7,1,7]
Output: 2
Explanation: Start at checkpoint 1 (pay 1), hop two to checkpoint 3 (pay 1), then hop two more to finish. Total 2.
```$$,
    constraints = $$- `2 <= effort.length <= 2 * 10^3`
- `0 <= effort[i] <= 800`$$
WHERE slug = $$pick-least-effort-circuit$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$pick-least-effort-circuit$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$pick-least-effort-circuit$$),
    'ko',
    $KO$체력 최소 소모 코스$KO$,
    $KO$플랫포머 스테이지에 `0`부터 `n-1`까지 번호가 매겨진 `n`개의 체크포인트가 있고, 각 체크포인트에 내려서면 `effort[i]`만큼 체력을 씁니다. 체크포인트 `0` 또는 `1`에서 시작할 수 있고, 어떤 체크포인트에서든 비용을 낸 뒤 한 칸 또는 두 칸 앞으로 뛸 수 있습니다.

마지막 체크포인트 너머(위치 `n`)로 벗어나기까지 드는 최소 총 체력을 반환하세요.

**예시 1:**
```
Input: effort = [4,2,8,3,5,6]
Output: 10
Explanation: Start at checkpoint 1 (pay 2), hop to checkpoint 3 (pay 3), then to checkpoint 5 (pay 5) and step off. Total 2 + 3 + 5 = 10.
```

**예시 2:**
```
Input: effort = [7,1,7,1,7]
Output: 2
Explanation: Start at checkpoint 1 (pay 1), hop two to checkpoint 3 (pay 1), then hop two more to finish. Total 2.
```$KO$,
    $KO$- `2 <= effort.length <= 2 * 10^3`
- `0 <= effort[i] <= 800`$KO$
);

-- pick-plot-haul
UPDATE problems SET
    title = $$Pick Snack Haul$$,
    description = $$A row of vending machines lines the hallway, each stocked with a known number of snacks, but the old wiring trips a fuse if you hit two neighboring machines on the same run. Given `snacks` where `snacks[i]` is the haul at machine `i`, return the maximum total snacks you can grab without ever picking two adjacent machines.

**Example 1:**
```
Input: snacks = [4,1,1,9,1,3]
Output: 16
Explanation: Hitting machines 0, 3, and 5 yields 4 + 9 + 3 = 16. No other no-adjacent selection scores higher.
```

**Example 2:**
```
Input: snacks = [5,5,10,100,10,5]
Output: 110
Explanation: Hitting machines 1, 3, and 5 yields 5 + 100 + 5 = 110. Taking machine 3 alone scores 100, and any selection that skips machine 3 cannot catch up.
```$$,
    constraints = $$- `1 <= snacks.length <= 100`
- `0 <= snacks[i] <= 400`$$
WHERE slug = $$pick-plot-haul$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$pick-plot-haul$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$pick-plot-haul$$),
    'ko',
    $KO$간식 털이 최대화$KO$,
    $KO$복도에 자판기들이 한 줄로 서 있고, 각 자판기에 들어 있는 간식 개수는 이미 알고 있습니다. 다만 전선이 낡아서, 한 번의 순회에서 이웃한 자판기 둘을 연달아 치면 퓨즈가 나갑니다. `snacks[i]`가 자판기 `i`에 있는 간식 수라고 할 때, 이웃한 자판기를 절대 같이 털지 않으면서 얻을 수 있는 간식의 최대 합을 반환하세요.

**예시 1:**
```
Input: snacks = [4,1,1,9,1,3]
Output: 16
Explanation: 자판기 0, 3, 5를 골라 4 + 9 + 3 = 16. 이웃하지 않도록 고른 다른 어떤 조합도 이 값을 넘지 못합니다.
```

**예시 2:**
```
Input: snacks = [5,5,10,100,10,5]
Output: 110
Explanation: 자판기 1, 3, 5를 골라 5 + 100 + 5 = 110. 자판기 3 하나만 골라도 100이지만, 3을 건너뛰는 어떤 조합도 이를 넘길 수 없습니다.
```$KO$,
    $KO$- `1 <= snacks.length <= 100`
- `0 <= snacks[i] <= 400`$KO$
);

-- pinpoint-peak-reading
UPDATE problems SET
    title = $$Pinpoint Peak Reading$$,
    description = $$Your phone's battery-level log for the afternoon lives in `readings`, and you want to spot a moment where the battery briefly topped out. A **peak reading** is strictly greater than both neighbors; treat the spots just outside the array as `-infinity`, so edge readings only need to beat their one neighbor.

Return the index of any peak in `readings`. If several exist, any one works. The log is huge, so your routine must run in `O(log n)` time.

**Example 1:**
```
Input: readings = [11,18,22,19,15]
Output: 2
Explanation: readings[2] = 22 beats both neighbors (18 and 19).
```

**Example 2:**
```
Input: readings = [3,7,12,25,20,14,9]
Output: 3
Explanation: readings[3] = 25 beats readings[2] = 12 and readings[4] = 20.
```$$,
    constraints = $$- `1 <= readings.length <= 2 * 10^3`
- `|readings[i]| <= 10^8`
- `readings[i] != readings[i + 1]` for every valid `i`.$$
WHERE slug = $$pinpoint-peak-reading$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$pinpoint-peak-reading$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$pinpoint-peak-reading$$),
    'ko',
    $KO$정점 값 찾기$KO$,
    $KO$오후 내내 찍힌 휴대폰 배터리 레벨 로그가 `readings`에 담겨 있습니다. 배터리가 잠깐 정점을 찍은 순간을 찾고 싶어요. **정점 읽기**는 양 이웃보다 엄격히 큰 값을 말합니다. 배열 바깥은 `-무한`으로 취급하므로, 양 끝 값은 하나뿐인 이웃만 이기면 됩니다.

`readings`의 정점 인덱스 하나를 반환하세요. 여러 개가 있다면 아무거나 돼요. 로그가 방대하므로 `O(log n)` 시간에 동작해야 합니다.

**예시 1:**
```
Input: readings = [11,18,22,19,15]
Output: 2
Explanation: readings[2] = 22는 양 이웃 18, 19보다 큽니다.
```

**예시 2:**
```
Input: readings = [3,7,12,25,20,14,9]
Output: 3
Explanation: readings[3] = 25는 readings[2] = 12, readings[4] = 20보다 큽니다.
```$KO$,
    $KO$- `1 <= readings.length <= 2 * 10^3`
- `|readings[i]| <= 10^8`
- 모든 유효한 `i`에 대해 `readings[i] != readings[i + 1]`.$KO$
);

-- pool-between-walls
UPDATE problems SET
    title = $$Puddle Between Fences$$,
    description = $$Your neighbor's row of hamster cages has fences of different heights lined up side by side, one meter wide each, and you're given `wallHeight` where `wallHeight[i]` is the fence height at position `i`. After a leaky water bottle spill, water pools in the dips up to the shorter of the taller fences on either side.

Return the total volume of water (in unit cells) the row traps once everything settles.

**Example 1:**
```
Input: wallHeight = [0,2,0,3,1,0,2,4,1,2,0,1]
Output: 10
Explanation: The tallest flanking fences cap each dip. Summing trapped depth above every plot gives 10 unit cells.
```

**Example 2:**
```
Input: wallHeight = [3,1,0,2,1,4]
Output: 8
Explanation: Water pools between the leftmost fence of height 3 and the rightmost of height 4, trapping 8 unit cells in the dip.
```$$,
    constraints = $$- `n == wallHeight.length`
- `1 <= n <= 2 * 10^5`
- `0 <= wallHeight[i] <= 10^8`$$
WHERE slug = $$pool-between-walls$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$pool-between-walls$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$pool-between-walls$$),
    'ko',
    $KO$울타리 사이 물웅덩이$KO$,
    $KO$이웃의 햄스터 케이지가 나란히 놓여 있고, 울타리들이 각기 다른 높이로 한 칸씩 서 있습니다. `wallHeight`는 각 위치 `i`의 울타리 높이를 담고 있어요. 물병이 새는 바람에 물이 쏟아졌고, 양쪽에서 울타리가 둘러싼 골마다 물이 두 울타리 중 낮은 쪽 높이까지 고입니다.

물이 가라앉은 뒤 갇힌 물의 총 부피(단위 칸 수)를 반환하세요.

**예시 1:**
```
Input: wallHeight = [0,2,0,3,1,0,2,4,1,2,0,1]
Output: 10
Explanation: 각 골의 양옆에서 가장 높은 울타리가 수위를 정합니다. 위치마다 갇히는 깊이를 모두 더하면 10칸이 됩니다.
```

**예시 2:**
```
Input: wallHeight = [3,1,0,2,1,4]
Output: 8
Explanation: 왼쪽 끝 높이 3과 오른쪽 끝 높이 4 울타리 사이에 물이 고여 8칸이 갇힙니다.
```$KO$,
    $KO$- `n == wallHeight.length`
- `1 <= n <= 2 * 10^5`
- `0 <= wallHeight[i] <= 10^8`$KO$
);

-- prefix-tree
UPDATE problems SET
    title = $$Prefix Index$$,
    description = $$You're building the autocomplete for a video game's username registry. Usernames go in one letter at a time, and the UI needs to answer two questions fast: does this exact name exist, and does anything start with this prefix?

Implement `PrefixIndex`:

- `PrefixIndex()` — creates an empty index.
- `void insert(String word)` — registers `word` as a full username. Re-inserting is harmless.
- `boolean search(String word)` — returns `true` only if `word` was inserted as a complete username.
- `boolean startsWith(String prefix)` — returns `true` if any inserted username begins with `prefix`.

**Example 1:**
```
Input:
["PrefixIndex", "insert", "search", "search", "startsWith", "insert", "search"]
[[], ["apple"], ["apple"], ["app"], ["app"], ["app"], ["app"]]
Output: [null, null, true, false, true, null, true]
```

After inserting `"apple"`, `search("apple")` is `true` but `search("app")` is `false` because `"app"` is only a prefix so far. `startsWith("app")` is `true`. Once `"app"` itself is inserted, `search("app")` becomes `true`.$$,
    constraints = $$- `1 <= word.length, prefix.length <= 2000`
- `word` and `prefix` consist only of lowercase English letters.
- At most `20000` calls total will be made across `insert`, `search`, and `startsWith`.$$
WHERE slug = $$prefix-tree$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$prefix-tree$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$prefix-tree$$),
    'ko',
    $KO$접두어 색인$KO$,
    $KO$비디오 게임 유저명 등록부의 자동완성을 만들려고 해요. 유저명은 한 글자씩 들어오고, UI는 두 가지 질문에 빠르게 답해야 합니다. 이 이름이 등록돼 있는가? 이 접두어로 시작하는 이름이 있는가?

`PrefixIndex`를 구현하세요.

- `PrefixIndex()` — 빈 색인을 생성합니다.
- `void insert(String word)` — `word`를 완전한 유저명으로 등록합니다. 다시 넣어도 문제없어요.
- `boolean search(String word)` — `word`가 완전한 유저명으로 등록됐을 때만 `true`를 반환합니다.
- `boolean startsWith(String prefix)` — 등록된 유저명 중 `prefix`로 시작하는 게 있으면 `true`를 반환합니다.

**예시 1:**
```
Input:
["PrefixIndex", "insert", "search", "search", "startsWith", "insert", "search"]
[[], ["apple"], ["apple"], ["app"], ["app"], ["app"], ["app"]]
Output: [null, null, true, false, true, null, true]
```

`"apple"`을 넣고 나면 `search("apple")`은 `true`이지만, `"app"`은 아직 접두어일 뿐이라 `search("app")`은 `false`입니다. `startsWith("app")`은 `true`예요. `"app"` 자체를 등록하면 `search("app")`도 `true`가 됩니다.$KO$,
    $KO$- `1 <= word.length, prefix.length <= 2000`
- `word`와 `prefix`는 영어 소문자로만 이루어져 있습니다.
- `insert`, `search`, `startsWith` 호출은 합쳐서 최대 `20000`번 일어납니다.$KO$
);

-- probe-sugar-reading
UPDATE problems SET
    title = $$Menu Board Lookup$$,
    description = $$Your favorite cafe posts its calorie chart as an `m x n` grid `menu` where every row is sorted left to right ascending and every column is sorted top to bottom ascending. Rows can overlap, though — the first value of one row may be smaller than the last value of the row above.

Given a value `target`, return `true` if some cell on the board shows exactly `target`, and `false` otherwise.

**Example 1:**
```
Input: menu = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 14
Output: true
```

**Example 2:**
```
Input: menu = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 24
Output: false
```

**Example 3:**
```
Input: menu = [[-4,-1],[3,5]], target = -1
Output: true
Explanation: -1 sits in the first row, second column.
```$$,
    constraints = $$- `m == menu.length`
- `n == menu[i].length`
- `1 <= m, n <= 250`
- `|menu[i][j]| <= 10^8`
- `|target| <= 10^8`$$
WHERE slug = $$probe-sugar-reading$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$probe-sugar-reading$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$probe-sugar-reading$$),
    'ko',
    $KO$메뉴 보드 탐색$KO$,
    $KO$즐겨 찾는 카페의 칼로리 차트가 `m x n` 격자 `menu`에 적혀 있고, 모든 행은 왼쪽에서 오른쪽으로 오름차순, 모든 열은 위에서 아래로 오름차순으로 정렬되어 있어요. 다만 행들이 겹칠 수 있어서, 한 행의 첫 값이 위 행의 마지막 값보다 작을 수도 있습니다.

값 `target`이 주어질 때, 보드의 어느 칸이든 정확히 `target`을 보여주는 곳이 있으면 `true`, 없으면 `false`를 반환하세요.

**예시 1:**
```
Input: menu = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 14
Output: true
```

**예시 2:**
```
Input: menu = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 24
Output: false
```

**예시 3:**
```
Input: menu = [[-4,-1],[3,5]], target = -1
Output: true
Explanation: -1은 첫 번째 행의 두 번째 열에 있습니다.
```$KO$,
    $KO$- `m == menu.length`
- `n == menu[i].length`
- `1 <= m, n <= 250`
- `|menu[i][j]| <= 10^8`
- `|target| <= 10^8`$KO$
);

-- product-as-text
UPDATE problems SET
    title = $$Product As Text$$,
    description = $$Your math homework has two huge non-negative numbers written as digit strings `left` and `right`, way too long for a regular `int`. Compute their product and return it as a decimal string.

You can't cast either input to a numeric type, use a big-integer library, or call any built-in helper for arbitrary-length multiplication — just simulate long multiplication digit by digit.

**Example 1:**
```
Input: left = "12", right = "34"
Output: "408"
```

**Example 2:**
```
Input: left = "25", right = "13"
Output: "325"
```$$,
    constraints = $$- `1 <= left.length, right.length <= 200`
- `left` and `right` consist of decimal digits only
- Neither `left` nor `right` has leading zeros, except the value `0` itself$$
WHERE slug = $$product-as-text$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$product-as-text$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$product-as-text$$),
    'ko',
    $KO$문자열로 곱셈$KO$,
    $KO$수학 숙제에 아주 큰 음이 아닌 두 수가 숫자 문자열 `left`, `right`로 적혀 있는데, 일반 `int`에 안 들어갈 만큼 깁니다. 두 수의 곱을 계산해서 십진 문자열로 반환하세요.

입력을 숫자 타입으로 변환하거나, 빅 정수 라이브러리를 쓰거나, 임의 길이 곱셈을 해주는 내장 함수에 의존하면 안 됩니다. 자릿수별로 길이곱셈을 직접 흉내 내야 해요.

**예시 1:**
```
Input: left = "12", right = "34"
Output: "408"
```

**예시 2:**
```
Input: left = "25", right = "13"
Output: "325"
```$KO$,
    $KO$- `1 <= left.length, right.length <= 200`
- `left`와 `right`는 십진 숫자로만 이루어져 있습니다.
- `left`와 `right`는 선행 0을 갖지 않습니다(값 `0` 자체는 예외).$KO$
);

-- quad-tray-demand
UPDATE problems SET
    title = $$Quad Tray Demand$$,
    description = $$You're sorting leftover cookie trays after a bake sale, and each tray in `trays` has a signed count (positive = extras, negative = short). You want to find groups of four different trays whose counts add up to exactly `demand` so you can bundle them into a matching order.

Given `trays` and `demand`, return every **unique quadruplet** `[trays[a], trays[b], trays[c], trays[d]]` of four distinct indices whose values sum to `demand`. No duplicate quadruplets; any order is fine.

**Example 1:**
```
Input: trays = [1,-1,2,-2,3,-3], demand = 0
Output: [[-3,-2,2,3],[-3,-1,1,3],[-2,-1,1,2]]
Explanation: Three different foursomes of trays cancel out to zero.
```

**Example 2:**
```
Input: trays = [3,3,3,3,3], demand = 12
Output: [[3,3,3,3]]
Explanation: Every tray has 3 extras, and any four of them bundle to 12.
```$$,
    constraints = $$- `1 <= trays.length <= 2 * 10^3`
- `|trays[i]| <= 10^8`
- `|demand| <= 10^8`$$
WHERE slug = $$quad-tray-demand$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$quad-tray-demand$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$quad-tray-demand$$),
    'ko',
    $KO$네 트레이 합 맞추기$KO$,
    $KO$베이크 세일이 끝난 뒤 남은 쿠키 트레이를 정리하고 있는데, `trays`의 각 트레이에는 부호 있는 개수가 적혀 있습니다(양수는 여분, 음수는 부족분). 합이 정확히 `demand`가 되도록 서로 다른 트레이 네 개씩 묶어서 주문에 맞춰 포장하고 싶습니다.

`trays`와 `demand`가 주어질 때, 서로 다른 네 인덱스의 값을 더해 `demand`가 되는 **유일한 네 쌍** `[trays[a], trays[b], trays[c], trays[d]]`를 모두 반환하세요. 중복되는 네 쌍은 없어야 하고, 순서는 상관없습니다.

**예시 1:**
```
Input: trays = [1,-1,2,-2,3,-3], demand = 0
Output: [[-3,-2,2,3],[-3,-1,1,3],[-2,-1,1,2]]
Explanation: Three different foursomes of trays cancel out to zero.
```

**예시 2:**
```
Input: trays = [3,3,3,3,3], demand = 12
Output: [[3,3,3,3]]
Explanation: Every tray has 3 extras, and any four of them bundle to 12.
```$KO$,
    $KO$- `1 <= trays.length <= 2 * 10^3`
- `|trays[i]| <= 10^8`
- `|demand| <= 10^8`$KO$
);

-- random-set
UPDATE problems SET
    title = $$Random-Pick Bag$$,
    description = $$Your gaming group uses a loot bag of distinct card numbers and wants to pull one at random on demand. Build `RandomBag` so every currently-held card has the same chance of being drawn, and so adds, removes, and draws all run in average constant time.

- `RandomBag()` starts with an empty bag.
- `boolean insert(int val)` drops card `val` in. Returns `true` if it wasn't already there, `false` if it was.
- `boolean remove(int val)` takes card `val` out. Returns `true` if it was present, `false` otherwise.
- `int drawRandom()` returns one card uniformly at random from the current bag. Only called when the bag is non-empty.

**Example:**
```
Calls:  ["RandomBag","insert","insert","remove","drawRandom"]
Args:   [[],[1],[2],[1],[]]
Result: [null,true,true,true,2]
```
Cards `1` and `2` go in, then `1` is pulled out. Only `2` remains, so the draw returns `2`.$$,
    constraints = $$- `-10^8 <= val <= 10^8`
- At most `2 * 10^5` combined calls to `insert`, `remove`, and `drawRandom`
- The bag is guaranteed to be non-empty whenever `drawRandom` is invoked$$
WHERE slug = $$random-set$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$random-set$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$random-set$$),
    'ko',
    $KO$무작위 뽑기 가방$KO$,
    $KO$게임 모임에서 서로 다른 카드 번호가 담긴 뽑기 가방을 쓰는데, 원할 때마다 그 안에서 한 장을 무작위로 뽑고 싶습니다. 지금 가방에 들어 있는 카드라면 모두 같은 확률로 뽑히고, 추가·제거·뽑기 모두 평균 상수 시간에 끝나도록 `RandomBag`을 만드세요.

- `RandomBag()`은 빈 가방으로 시작합니다.
- `boolean insert(int val)`은 카드 `val`을 가방에 넣습니다. 원래 없었다면 `true`, 이미 있었다면 `false`를 반환합니다.
- `boolean remove(int val)`은 카드 `val`을 꺼냅니다. 있었다면 `true`, 없었다면 `false`를 반환합니다.
- `int drawRandom()`은 현재 가방에서 균등 확률로 카드 한 장을 반환합니다. 가방이 비어 있지 않을 때만 호출됩니다.

**예시:**
```
Calls:  ["RandomBag","insert","insert","remove","drawRandom"]
Args:   [[],[1],[2],[1],[]]
Result: [null,true,true,true,2]
```
카드 `1`과 `2`를 넣은 뒤 `1`을 다시 뺍니다. `2`만 남아 있으므로 뽑기는 `2`를 반환합니다.$KO$,
    $KO$- `-10^8 <= val <= 10^8`
- `insert`, `remove`, `drawRandom`의 총 호출 횟수는 최대 `2 * 10^5`회
- `drawRandom`이 호출될 때 가방은 비어 있지 않음이 보장됩니다$KO$
);

-- recent-cache
UPDATE problems SET
    title = $$Recent Save Slots$$,
    description = $$Your handheld console only holds a fixed number of quick-save slots, so old saves get bumped when you make new ones. Build `RecentRegistry` to track saves by slot key and kick out the one you haven't touched in the longest.

- `RecentRegistry(int capacity)` — starts an empty save table that holds up to `capacity` slots.
- `int lookup(int key)` — returns the value stored under `key`, or `-1` if nothing is there. A successful lookup marks that slot as most recently used.
- `void store(int key, int value)` — writes `value` at `key`. If `key` already exists, its value is overwritten and it becomes most recently used. If `key` is new and the table is full, the least recently used slot is evicted first.

Both `lookup` and `store` must run in average `O(1)` time.

**Example:**
```
registry = new RecentRegistry(2)
registry.store(1, 10)   // {1=10}
registry.store(2, 20)   // {1=10, 2=20}
registry.lookup(1)      // returns 10; 1 is now most recent
registry.store(3, 30)   // evicts key 2 -> {1=10, 3=30}
registry.lookup(2)      // returns -1
```$$,
    constraints = $$- `1 <= capacity <= 3000`
- `0 <= key <= 8000`
- `0 <= value <= 80000`
- At most `2 * 10^5` combined calls to `lookup` and `store`$$
WHERE slug = $$recent-cache$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$recent-cache$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$recent-cache$$),
    'ko',
    $KO$최근 세이브 슬롯$KO$,
    $KO$휴대용 게임기에는 퀵 세이브 슬롯이 정해진 개수만큼만 있어서 새로 저장할 때마다 오래된 세이브가 밀려납니다. `RecentRegistry`를 만들어 슬롯 키별로 세이브를 관리하고, 가장 오래 안 건드린 슬롯을 비우세요.

- `RecentRegistry(int capacity)` — 최대 `capacity`개의 슬롯을 담을 수 있는 빈 세이브 테이블을 만듭니다.
- `int lookup(int key)` — `key`에 저장된 값을 반환합니다. 아무것도 없으면 `-1`. 조회에 성공하면 그 슬롯을 가장 최근 사용으로 표시합니다.
- `void store(int key, int value)` — `key`에 `value`를 씁니다. 이미 `key`가 있다면 값만 덮어쓰고 가장 최근 사용으로 갱신합니다. `key`가 새것인데 테이블이 꽉 찼다면 가장 오래 안 쓴 슬롯부터 쫓아냅니다.

`lookup`과 `store` 모두 평균 `O(1)` 시간에 동작해야 합니다.

**예시:**
```
registry = new RecentRegistry(2)
registry.store(1, 10)   // {1=10}
registry.store(2, 20)   // {1=10, 2=20}
registry.lookup(1)      // returns 10; 1 is now most recent
registry.store(3, 30)   // evicts key 2 -> {1=10, 3=30}
registry.lookup(2)      // returns -1
```$KO$,
    $KO$- `1 <= capacity <= 3000`
- `0 <= key <= 8000`
- `0 <= value <= 80000`
- `lookup`과 `store` 호출은 합쳐서 최대 `2 * 10^5`번$KO$
);

-- reflect-blend-profile
UPDATE problems SET
    title = $$Mirror the Menu Tree$$,
    description = $$Your cafe's menu is laid out as a binary tree of drinks, with the left child as the chill option and the right as the bold option, and today you want to flip the whole board so lefts and rights swap at every level.

Given the `root` of the menu tree, implement `reflectBlend` to swap each node's left and right children recursively and return the mirrored root.

**Example 1:**
```
Input: root = [5,3,8,2,4,7,9]
Output: [5,8,3,9,7,4,2]
Explanation: Every left/right pair is swapped at every level.
```

**Example 2:**
```
Input: root = [6,4,11]
Output: [6,11,4]
```

**Example 3:**
```
Input: root = []
Output: []
```$$,
    constraints = $$- The number of drinks in the tree is in the range `[0, 100]`.
- `-100 <= Node.val <= 100`$$
WHERE slug = $$reflect-blend-profile$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$reflect-blend-profile$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$reflect-blend-profile$$),
    'ko',
    $KO$메뉴 트리 뒤집기$KO$,
    $KO$카페 메뉴가 이진 트리로 배치되어 있는데, 왼쪽 자식은 순한 옵션, 오른쪽 자식은 진한 옵션입니다. 오늘은 모든 계층에서 왼쪽과 오른쪽을 바꿔서 메뉴판 전체를 뒤집고 싶습니다.

메뉴 트리의 `root`가 주어졌을 때, 각 노드의 왼쪽과 오른쪽 자식을 재귀적으로 맞바꾸고 거울처럼 뒤집힌 루트를 반환하도록 `reflectBlend`를 구현하세요.

**예시 1:**
```
Input: root = [5,3,8,2,4,7,9]
Output: [5,8,3,9,7,4,2]
Explanation: Every left/right pair is swapped at every level.
```

**예시 2:**
```
Input: root = [6,4,11]
Output: [6,11,4]
```

**예시 3:**
```
Input: root = []
Output: []
```$KO$,
    $KO$- 트리에 담긴 음료의 수는 `[0, 100]` 범위입니다.
- `-100 <= Node.val <= 100`$KO$
);

-- repeat-tracking-codes
UPDATE problems SET
    title = $$Repeat Tracking Codes$$,
    description = $$Your classroom's attendance sheet has `n` students numbered `1..n`, and the integer array `codes` of length `n` records each scan of a student id card. Some students accidentally scanned their card twice; the rest scanned exactly once.

Return every id that was scanned exactly twice. The result may be in any order. Aim for linear time and only constant extra memory beyond the output list.

**Example 1:**
```
Input: codes = [5,2,6,3,2,1,4,6]
Output: [2,6]
Explanation: Code 2 appears at indices 1 and 4; code 6 appears at indices 2 and 7.
```

**Example 2:**
```
Input: codes = [3,3,1,2]
Output: [3]
```$$,
    constraints = $$- `n == codes.length`
- `1 <= n <= 2 * 10^5`
- `1 <= codes[i] <= n`
- Each code appears either once or twice.$$
WHERE slug = $$repeat-tracking-codes$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$repeat-tracking-codes$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$repeat-tracking-codes$$),
    'ko',
    $KO$두 번 찍힌 출석 코드$KO$,
    $KO$반 출석부에는 `1..n`으로 번호가 매겨진 학생이 `n`명 있고, 길이 `n`의 정수 배열 `codes`에는 학생증 스캔 기록이 담겨 있습니다. 몇몇 학생이 실수로 카드를 두 번 찍었고, 나머지는 정확히 한 번만 찍었습니다.

정확히 두 번 찍힌 모든 번호를 반환하세요. 순서는 상관없습니다. 선형 시간과 출력 리스트 외에 상수 크기의 추가 메모리만 쓰도록 해보세요.

**예시 1:**
```
Input: codes = [5,2,6,3,2,1,4,6]
Output: [2,6]
Explanation: Code 2 appears at indices 1 and 4; code 6 appears at indices 2 and 7.
```

**예시 2:**
```
Input: codes = [3,3,1,2]
Output: [3]
```$KO$,
    $KO$- `n == codes.length`
- `1 <= n <= 2 * 10^5`
- `1 <= codes[i] <= n`
- 각 코드는 한 번 또는 두 번 등장합니다.$KO$
);

-- resolve-lane-crashes
UPDATE problems SET
    title = $$Resolve Lane Crashes$$,
    description = $$In a side-scrolling brawler, a lineup of fighters is set loose at once along a single lane. The array `fighters` gives each one's signed power: magnitude is strength, sign is direction (positive moves right, negative moves left). Same-direction fighters never meet; when opposite ones collide the weaker is knocked out and the stronger keeps going, and equal powers knock each other out.

Return the lineup still standing after all collisions settle, in original left-to-right order.

**Example 1:**
```
Input: fighters = [3,7,-8]
Output: [-8]
Explanation: -8 knocks out 7, then knocks out 3, leaving only -8.
```

**Example 2:**
```
Input: fighters = [-3,4,-4,2]
Output: [-3,2]
Explanation: 4 and -4 cancel out; -3 and 2 never meet an opposite.
```$$,
    constraints = $$- `2 <= fighters.length <= 2 * 10^3`
- `-1200 <= fighters[i] <= 1200`
- `fighters[i] != 0`$$
WHERE slug = $$resolve-lane-crashes$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$resolve-lane-crashes$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$resolve-lane-crashes$$),
    'ko',
    $KO$레인 충돌 정리하기$KO$,
    $KO$횡스크롤 격투 게임에서 한 줄로 늘어선 파이터들이 동시에 같은 레인에 풀려납니다. 배열 `fighters`는 각 파이터의 부호 있는 파워를 담고 있는데, 크기는 힘, 부호는 방향입니다(양수면 오른쪽, 음수면 왼쪽). 같은 방향으로 가는 파이터끼리는 절대 만나지 않고, 반대 방향이 부딪히면 약한 쪽이 쓰러지고 강한 쪽은 계속 가며, 파워가 같으면 서로 함께 쓰러집니다.

모든 충돌이 정리된 뒤 남은 파이터들을 원래의 왼쪽에서 오른쪽 순서대로 반환하세요.

**예시 1:**
```
Input: fighters = [3,7,-8]
Output: [-8]
Explanation: -8 knocks out 7, then knocks out 3, leaving only -8.
```

**예시 2:**
```
Input: fighters = [-3,4,-4,2]
Output: [-3,2]
Explanation: 4 and -4 cancel out; -3 and 2 never meet an opposite.
```$KO$,
    $KO$- `2 <= fighters.length <= 2 * 10^3`
- `-1200 <= fighters[i] <= 1200`
- `fighters[i] != 0`$KO$
);

-- resolve-price-ratios
UPDATE problems SET
    title = $$Resolve Price Ratios$$,
    description = $$Your cafe posts hand-written ratio signs comparing drink prices: `ratios[i] = [Ai, Bi]` with `values[i]` means one `Ai` costs `values[i]` times one `Bi`. You want to answer a list of new price-ratio questions from these signs.

For every `queries[i] = [Ci, Di]`, return the value of `Ci / Di` implied by the known ratios. If the two drinks cannot be connected through a chain of ratios — or one of them never appears — return `-1.0`. Note that if `A / B = k` is known, then `B / A = 1 / k`, and `A / A = 1.0` for any drink that appears in at least one ratio.

**Example 1:**
```
Input: ratios = [["milk","bread"],["bread","eggs"]], values = [4.0,2.0], queries = [["milk","eggs"],["eggs","bread"],["bread","milk"],["milk","milk"],["soap","milk"]]
Output: [8.00000,0.50000,0.25000,1.00000,-1.00000]
Explanation: milk/eggs = (milk/bread) * (bread/eggs) = 4.0 * 2.0 = 8.0; eggs/bread = 1/2.0 = 0.5; bread/milk = 1/4.0 = 0.25; milk/milk = 1.0; soap never appears so its query is -1.0.
```

**Example 2:**
```
Input: ratios = [["apple","pear"],["pear","plum"],["kiwi","lime"]], values = [3.0,4.0,2.0], queries = [["apple","plum"],["plum","apple"],["kiwi","lime"],["apple","kiwi"]]
Output: [12.00000,0.08333,2.00000,-1.00000]
Explanation: Apple and plum link through pear, giving 3.0 * 4.0 = 12.0 and the reciprocal. Kiwi and lime form a separate component, so kiwi/lime is known but apple/kiwi is not.
```$$,
    constraints = $$- `1 <= ratios.length <= 25`
- `ratios[i].length == 2`
- `1 <= ratios[i][0].length, ratios[i][1].length <= 8`
- `values.length == ratios.length`
- `0.0 < values[i] <= 25.0`
- `1 <= queries.length <= 25`
- `queries[i].length == 2`
- `1 <= queries[i][0].length, queries[i][1].length <= 8`
- Item codes consist of lowercase English letters and digits.$$
WHERE slug = $$resolve-price-ratios$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$resolve-price-ratios$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$resolve-price-ratios$$),
    'ko',
    $KO$가격 비율 계산하기$KO$,
    $KO$카페에서 음료 가격 비율이 적힌 손글씨 팻말을 붙여 둡니다. `ratios[i] = [Ai, Bi]`와 `values[i]`는 `Ai` 하나의 가격이 `Bi` 하나의 가격의 `values[i]`배라는 뜻입니다. 이 팻말들로 새로운 가격 비율 질문들에 답하려 합니다.

각 `queries[i] = [Ci, Di]`에 대해, 알려진 비율들로부터 유도되는 `Ci / Di`의 값을 반환하세요. 두 음료가 비율 체인으로 연결되지 않거나 둘 중 하나가 한 번도 등장하지 않으면 `-1.0`을 반환합니다. `A / B = k`를 알고 있으면 `B / A = 1 / k`이고, 적어도 한 번이라도 비율에 등장한 음료라면 `A / A = 1.0`입니다.

**예시 1:**
```
Input: ratios = [["milk","bread"],["bread","eggs"]], values = [4.0,2.0], queries = [["milk","eggs"],["eggs","bread"],["bread","milk"],["milk","milk"],["soap","milk"]]
Output: [8.00000,0.50000,0.25000,1.00000,-1.00000]
Explanation: milk/eggs = (milk/bread) * (bread/eggs) = 4.0 * 2.0 = 8.0; eggs/bread = 1/2.0 = 0.5; bread/milk = 1/4.0 = 0.25; milk/milk = 1.0; soap never appears so its query is -1.0.
```

**예시 2:**
```
Input: ratios = [["apple","pear"],["pear","plum"],["kiwi","lime"]], values = [3.0,4.0,2.0], queries = [["apple","plum"],["plum","apple"],["kiwi","lime"],["apple","kiwi"]]
Output: [12.00000,0.08333,2.00000,-1.00000]
Explanation: Apple and plum link through pear, giving 3.0 * 4.0 = 12.0 and the reciprocal. Kiwi and lime form a separate component, so kiwi/lime is known but apple/kiwi is not.
```$KO$,
    $KO$- `1 <= ratios.length <= 25`
- `ratios[i].length == 2`
- `1 <= ratios[i][0].length, ratios[i][1].length <= 8`
- `values.length == ratios.length`
- `0.0 < values[i] <= 25.0`
- `1 <= queries.length <= 25`
- `queries[i].length == 2`
- `1 <= queries[i][0].length, queries[i][1].length <= 8`
- 항목 코드는 영어 소문자와 숫자로 이루어져 있습니다.$KO$
);

-- responder-relay-cost
UPDATE problems SET
    title = $$Responder Relay Cost$$,
    description = $$A delivery-tracking tool routes orders between `n` cafes labeled `0..n-1` via one-way courier links. Each entry `links[i] = [from, to, minutes]` is a courier leg that forwards a package from cafe `from` to cafe `to` costing `minutes` minutes.

Given a source cafe `src`, a destination cafe `dst`, and a maximum of `maxHops` intermediate cafes allowed, return the **minimum total minutes** to deliver from `src` to `dst`. If no sequence fits within `maxHops` intermediate cafes, return `-1`.

**Example 1:**
```
Input: n = 5, links = [[0,1,50],[1,2,40],[0,2,200],[2,3,30],[3,4,20],[1,3,150]], src = 0, dst = 4, maxHops = 2
Output: 220
Explanation: The chain 0 -> 1 -> 3 -> 4 (cost 50 + 150 + 20 = 220) uses 2 intermediate cafes. The cheaper chain 0 -> 1 -> 2 -> 3 -> 4 would need 3 intermediates and is rejected.
```

**Example 2:**
```
Input: n = 4, links = [[0,1,80],[1,2,40],[0,2,300],[2,3,90],[0,3,400]], src = 0, dst = 3, maxHops = 0
Output: 400
Explanation: With maxHops = 0 only the direct link 0 -> 3 at 400 minutes qualifies, even though 0 -> 1 -> 2 -> 3 would total 210.
```$$,
    constraints = $$- `1 <= n <= 120`
- `0 <= links.length <= n * (n - 1) / 2`
- `links[i].length == 3`
- `0 <= from, to < n` and `from != to`
- `1 <= minutes <= 8000`
- `0 <= src, dst, maxHops < n`
- `src != dst`$$
WHERE slug = $$responder-relay-cost$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$responder-relay-cost$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$responder-relay-cost$$),
    'ko',
    $KO$배송 릴레이 비용$KO$,
    $KO$배송 추적 툴이 `0..n-1`로 번호 매겨진 `n`개의 카페 사이를 단방향 배달 링크로 연결해 주문을 전달합니다. `links[i] = [from, to, minutes]`는 카페 `from`에서 카페 `to`로 `minutes`분을 들여 패키지를 전달하는 한 구간을 의미합니다.

출발 카페 `src`, 도착 카페 `dst`, 그리고 중간에 허용되는 경유 카페의 최대 개수 `maxHops`가 주어졌을 때, `src`에서 `dst`까지 배달하는 **최소 총 소요 분**을 반환하세요. `maxHops` 이하의 경유로 도달할 방법이 없다면 `-1`을 반환합니다.

**예시 1:**
```
Input: n = 5, links = [[0,1,50],[1,2,40],[0,2,200],[2,3,30],[3,4,20],[1,3,150]], src = 0, dst = 4, maxHops = 2
Output: 220
Explanation: The chain 0 -> 1 -> 3 -> 4 (cost 50 + 150 + 20 = 220) uses 2 intermediate cafes. The cheaper chain 0 -> 1 -> 2 -> 3 -> 4 would need 3 intermediates and is rejected.
```

**예시 2:**
```
Input: n = 4, links = [[0,1,80],[1,2,40],[0,2,300],[2,3,90],[0,3,400]], src = 0, dst = 3, maxHops = 0
Output: 400
Explanation: With maxHops = 0 only the direct link 0 -> 3 at 400 minutes qualifies, even though 0 -> 1 -> 2 -> 3 would total 210.
```$KO$,
    $KO$- `1 <= n <= 120`
- `0 <= links.length <= n * (n - 1) / 2`
- `links[i].length == 3`
- `0 <= from, to < n`이며 `from != to`
- `1 <= minutes <= 8000`
- `0 <= src, dst, maxHops < n`
- `src != dst`$KO$
);

-- reverse-printer-flags
UPDATE problems SET
    title = $$Reverse Printer Flags$$,
    description = $$Your handheld console reads save-file flags in the opposite bit order from your PC emulator, so you need to mirror the 32-bit status word before comparing them.

Given a 32-bit unsigned integer `statusWord`, implement `reversePrinterFlags(statusWord)` that returns the value you get by reversing all 32 bits — bit 0 goes to position 31, bit 1 to position 30, and so on. Return it as a `long` in `[0, 2^32 - 1]`.

**Example 1:**
```
Input: statusWord = 8
Output: 268435456
Explanation: 8 has bit 3 set. After reversing, that bit lands at position 28, giving 2^28 = 268435456.
```

**Example 2:**
```
Input: statusWord = 6
Output: 1610612736
Explanation: 6 has bits 1 and 2 set. Reversed, they become bits 30 and 29, giving 2^30 + 2^29 = 1610612736.
```$$,
    constraints = $$- `statusWord` is a 32-bit unsigned integer (`0 <= statusWord <= 4294967295`)$$
WHERE slug = $$reverse-printer-flags$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$reverse-printer-flags$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$reverse-printer-flags$$),
    'ko',
    $KO$프린터 플래그 뒤집기$KO$,
    $KO$휴대용 콘솔은 세이브 파일 플래그의 비트 순서를 PC 에뮬레이터와 반대로 읽기 때문에, 비교하기 전에 32비트 상태 워드를 뒤집어야 합니다.

32비트 부호 없는 정수 `statusWord`가 주어졌을 때, 32비트를 모두 뒤집은 값을 반환하는 `reversePrinterFlags(statusWord)`를 구현하세요. 비트 0은 31번 자리로, 비트 1은 30번 자리로, 이런 식으로 옮겨갑니다. 반환은 `[0, 2^32 - 1]` 범위의 `long` 형입니다.

**예시 1:**
```
Input: statusWord = 8
Output: 268435456
Explanation: 8 has bit 3 set. After reversing, that bit lands at position 28, giving 2^28 = 268435456.
```

**예시 2:**
```
Input: statusWord = 6
Output: 1610612736
Explanation: 6 has bits 1 and 2 set. Reversed, they become bits 30 and 29, giving 2^30 + 2^29 = 1610612736.
```$KO$,
    $KO$- `statusWord`는 32비트 부호 없는 정수입니다(`0 <= statusWord <= 4294967295`).$KO$
);

-- reversible-call-number
UPDATE problems SET
    title = $$Reversible Call Number$$,
    description = $$You're idly checking whether today's Netflix episode number looks the same backwards, because little symmetries are satisfying. Given an integer `code`, return `true` when `code` reads the same forwards and backwards, and `false` otherwise.

Any negative `code` is automatically not symmetric, since the minus sign has no match on the right.

**Example 1:**
```
Input: code = 929
Output: true
Explanation: 929 reversed is still 929.
```

**Example 2:**
```
Input: code = 20
Output: false
Explanation: 20 reversed reads 02, which does not match 20.
```$$,
    constraints = $$- `-2 * 10^8 <= code <= 2 * 10^8`$$
WHERE slug = $$reversible-call-number$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$reversible-call-number$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$reversible-call-number$$),
    'ko',
    $KO$뒤집어도 같은 번호$KO$,
    $KO$오늘의 넷플릭스 에피소드 번호가 뒤집어도 같은지 궁금해서 심심풀이로 확인해 봅니다. 작은 대칭을 보는 건 기분 좋으니까요. 정수 `code`가 주어졌을 때, 앞으로 읽어도 뒤로 읽어도 같은 값이면 `true`, 아니면 `false`를 반환하세요.

음수 `code`는 자동으로 대칭이 아닙니다. 왼쪽의 마이너스 기호에 대응되는 기호가 오른쪽에 없기 때문입니다.

**예시 1:**
```
Input: code = 929
Output: true
Explanation: 929 reversed is still 929.
```

**예시 2:**
```
Input: code = 20
Output: false
Explanation: 20 reversed reads 02, which does not match 20.
```$KO$,
    $KO$- `-2 * 10^8 <= code <= 2 * 10^8`$KO$
);

-- rewind-conveyor-chain
UPDATE problems SET
    title = $$Reverse the Playlist$$,
    description = $$Your music playlist is stored as a linked list and you want to play it backwards tonight. Flip the whole chain so the last song becomes the first, reusing the same nodes.

Implement `rewindConveyorChain(head)` to reverse the list in place by rewiring `next` pointers, then return the new head.

**Example 1:**
```
Input: head = [8,3,12,5,9]
Output: [9,5,12,3,8]
Explanation: Song 9 is now first and song 8 is last.
```

**Example 2:**
```
Input: head = [4,7]
Output: [7,4]
Explanation: A two-song playlist swaps order.
```

**Example 3:**
```
Input: head = []
Output: []
Explanation: Empty playlist, nothing to flip.
```$$,
    constraints = $$- The number of songs in the list is in the range `[0, 6000]`.
- `-6000 <= Song.val <= 6000`$$
WHERE slug = $$rewind-conveyor-chain$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$rewind-conveyor-chain$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$rewind-conveyor-chain$$),
    'ko',
    $KO$플레이리스트 뒤집기$KO$,
    $KO$내 음악 플레이리스트가 연결 리스트로 저장돼 있고, 오늘 밤은 역순으로 틀어두고 싶습니다. 체인 전체를 뒤집어서 마지막 곡이 맨 앞으로 오도록 기존 노드를 그대로 재활용해 주세요.

`next` 포인터들을 다시 연결해 리스트를 제자리에서 뒤집고, 새 헤드를 반환하는 `rewindConveyorChain(head)`를 구현하세요.

**예시 1:**
```
Input: head = [8,3,12,5,9]
Output: [9,5,12,3,8]
Explanation: Song 9 is now first and song 8 is last.
```

**예시 2:**
```
Input: head = [4,7]
Output: [7,4]
Explanation: A two-song playlist swaps order.
```

**예시 3:**
```
Input: head = []
Output: []
Explanation: Empty playlist, nothing to flip.
```$KO$,
    $KO$- 리스트의 곡 개수는 `[0, 6000]` 범위 안에 있습니다.
- `-6000 <= Song.val <= 6000`$KO$
);

-- ring-buffer
UPDATE problems SET
    title = $$Fixed-Length Ring Buffer$$,
    description = $$Your party chat in a co-op game only keeps a fixed number of recent messages, and when it fills up the oldest one drops off as new ones come in. Build `FixedRing` to track messages in a circular buffer.

- `FixedRing(int k)` — starts an empty ring with room for up to `k` messages.
- `boolean push(int value)` — adds `value` at the rear. Returns `true` on success, or `false` if the ring is full.
- `boolean pull()` — drops the message at the front. Returns `true` on success, or `false` if the ring is empty.
- `int front()` — returns the front message without removing it, or `-1` if empty.
- `int rear()` — returns the rear message without removing it, or `-1` if empty.
- `boolean isEmpty()` — returns `true` when no messages are buffered.
- `boolean isFull()` — returns `true` when all `k` slots are filled.

**Example:**
```
ring = new FixedRing(3)
ring.push(1); ring.push(2); ring.push(3)   // all succeed
ring.push(4)                               // false, ring full
ring.rear()                                // 3
ring.pull()                                // true, drops 1
ring.push(4)                               // true, wraps around
ring.rear()                                // 4
```$$,
    constraints = $$- `1 <= k <= 1000`
- `0 <= value <= 1000`
- At most `3000` combined calls to `push`, `pull`, `front`, `rear`, `isEmpty`, and `isFull`$$
WHERE slug = $$ring-buffer$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$ring-buffer$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$ring-buffer$$),
    'ko',
    $KO$고정 크기 링 버퍼$KO$,
    $KO$협동 게임의 파티 채팅은 최근 메시지를 정해진 개수만큼만 보관하고, 꽉 찼을 때 새 메시지가 들어오면 가장 오래된 게 밀려나갑니다. 순환 버퍼로 메시지를 관리하는 `FixedRing`을 구현하세요.

- `FixedRing(int k)` — 최대 `k`개의 메시지를 담을 수 있는 빈 링을 시작합니다.
- `boolean push(int value)` — 뒤쪽에 `value`를 넣습니다. 성공하면 `true`, 링이 꽉 차 있으면 `false`를 반환합니다.
- `boolean pull()` — 앞쪽 메시지를 꺼내 버립니다. 성공하면 `true`, 비어 있으면 `false`를 반환합니다.
- `int front()` — 앞쪽 메시지를 제거하지 않고 반환하고, 비어 있으면 `-1`을 반환합니다.
- `int rear()` — 뒤쪽 메시지를 제거하지 않고 반환하고, 비어 있으면 `-1`을 반환합니다.
- `boolean isEmpty()` — 버퍼에 메시지가 하나도 없을 때 `true`를 반환합니다.
- `boolean isFull()` — 모든 `k`개 슬롯이 차 있으면 `true`를 반환합니다.

**예시:**
```
ring = new FixedRing(3)
ring.push(1); ring.push(2); ring.push(3)   // all succeed
ring.push(4)                               // false, ring full
ring.rear()                                // 3
ring.pull()                                // true, drops 1
ring.push(4)                               // true, wraps around
ring.rear()                                // 4
```$KO$,
    $KO$- `1 <= k <= 1000`
- `0 <= value <= 1000`
- `push`, `pull`, `front`, `rear`, `isEmpty`, `isFull`에 대한 호출은 통틀어 최대 `3000`번입니다.$KO$
);

-- rotate-park-map
UPDATE problems SET
    title = $$Rotate Pet Cafe Map$$,
    description = $$You sketched the pet cafe's seating grid on your tablet, but the photo saved sideways and the tablet is too cramped to keep a second copy. You need to turn it 90 degrees clockwise in place.

Given an `n x n` integer grid `cafeMap`, implement `rotateParkMap` to rotate it 90 degrees clockwise in-place. Mutate `cafeMap` directly, no second `n x n` grid allowed.

**Example 1:**
```
Input: cafeMap = [[2,4,6],[8,1,3],[5,7,9]]
Output: [[5,8,2],[7,1,4],[9,3,6]]
```

**Example 2:**
```
Input: cafeMap = [[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]
Output: [[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]
```$$,
    constraints = $$- `n == cafeMap.length == cafeMap[i].length`
- `1 <= n <= 20`
- `-1000 <= cafeMap[i][j] <= 1000`$$
WHERE slug = $$rotate-park-map$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$rotate-park-map$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$rotate-park-map$$),
    'ko',
    $KO$펫 카페 지도 회전$KO$,
    $KO$태블릿에 펫 카페 좌석 격자를 스케치해 뒀는데, 사진이 옆으로 저장되어 버렸습니다. 태블릿이 좁아서 사본을 하나 더 만들 수도 없으니, 제자리에서 시계 방향으로 90도 돌려야 합니다.

`n x n` 정수 격자 `cafeMap`이 주어졌을 때, 제자리에서 시계 방향으로 90도 회전하는 `rotateParkMap`을 구현하세요. `cafeMap`을 직접 변경해야 하고, 두 번째 `n x n` 격자를 쓸 수 없습니다.

**예시 1:**
```
Input: cafeMap = [[2,4,6],[8,1,3],[5,7,9]]
Output: [[5,8,2],[7,1,4],[9,3,6]]
```

**예시 2:**
```
Input: cafeMap = [[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]
Output: [[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]
```$KO$,
    $KO$- `n == cafeMap.length == cafeMap[i].length`
- `1 <= n <= 20`
- `-1000 <= cafeMap[i][j] <= 1000`$KO$
);

-- running-median
UPDATE problems SET
    title = $$Running Median Tracker$$,
    description = $$Your speedrun timer logs the seconds you finish each attempt at, and you want to know the median run time on demand as new attempts keep coming in. Build `StreamMedian` to track runs and report the median of everything logged so far. When there's an even number of runs, the median is the average of the two middle values; otherwise it's the single middle value. Both are returned as doubles.

Implement the `StreamMedian` class:

- `StreamMedian()` starts with no runs logged.
- `void record(int num)` logs a new run time `num`.
- `double median()` returns the median of every run logged so far. Only called after at least one `record`.

**Example:**
```
collector = new StreamMedian()
collector.record(1)
collector.median()    // 1.0
collector.record(2)
collector.median()    // (1 + 2) / 2 = 1.5
collector.record(3)
collector.median()    // middle of [1, 2, 3] = 2.0
```$$,
    constraints = $$- `-80000 <= num <= 80000`
- At most `40000` combined calls to `record` and `median`
- `median` is never called before the first `record`$$
WHERE slug = $$running-median$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$running-median$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$running-median$$),
    'ko',
    $KO$실시간 중앙값 추적$KO$,
    $KO$스피드런 타이머가 시도마다 완주한 초를 기록하고, 새 시도가 계속 쌓이는 동안 지금까지 기록된 완주 시간의 중앙값을 요청할 때마다 알고 싶습니다. 시도 기록을 추적하면서 지금까지의 모든 기록에 대한 중앙값을 알려주는 `StreamMedian`을 만드세요. 기록 개수가 짝수면 중앙값은 가운데 두 값의 평균, 홀수면 가운데 한 값입니다. 둘 다 `double`로 반환됩니다.

`StreamMedian` 클래스를 구현하세요.

- `StreamMedian()`은 기록이 없는 상태로 시작합니다.
- `void record(int num)`은 새 시도 시간 `num`을 기록합니다.
- `double median()`은 지금까지 기록된 모든 시도의 중앙값을 반환합니다. `record`가 최소 한 번 호출된 뒤에만 호출됩니다.

**예시:**
```
collector = new StreamMedian()
collector.record(1)
collector.median()    // 1.0
collector.record(2)
collector.median()    // (1 + 2) / 2 = 1.5
collector.record(3)
collector.median()    // middle of [1, 2, 3] = 2.0
```$KO$,
    $KO$- `-80000 <= num <= 80000`
- `record`와 `median` 호출은 통틀어 최대 `40000`번입니다.
- `median`은 첫 `record` 전에 호출되지 않습니다.$KO$
);

-- scene-shoot-order
UPDATE problems SET
    title = $$Recover Tier List Order$$,
    description = $$A friend sorted a list of lowercase hero tags using a custom tier order — some unknown permutation of the 26 letters. You're given `tags`, the already-sorted list, and you need to recover that tier ordering as a single string.

If two adjacent tags contradict any possible ordering (like a longer tag appearing before a shorter tag that's its prefix), return `""`. When a valid ordering exists, the input is designed so exactly one ordering works for the letters in `tags`.

**Example 1:**
```
Input: tags = ["ab","ba","bc","cb","cd","dc"]
Output: "abcd"
Explanation: The adjacent pairs force a before b, b before c, and c before d, giving a -> b -> c -> d.
```

**Example 2:**
```
Input: tags = ["studio","stud"]
Output: ""
Explanation: "stud" is a prefix of "studio" but comes after it, which no ordering can justify.
```$$,
    constraints = $$- `tags` contains at least one tag
- Each tag is a non-empty string of lowercase English letters
- When a valid ordering exists, the test inputs are shaped so that exactly one ordering of the letters appearing in `tags` is consistent with all adjacent-pair constraints$$
WHERE slug = $$scene-shoot-order$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$scene-shoot-order$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$scene-shoot-order$$),
    'ko',
    $KO$티어 순서 복원$KO$,
    $KO$친구가 소문자 영웅 태그 목록을 자기만의 티어 순서(알파벳 26글자의 어떤 순열)로 정렬해 놨습니다. 이미 정렬된 리스트 `tags`가 주어지면, 그 티어 순서를 하나의 문자열로 복원하세요.

이웃한 두 태그가 어떤 순서로도 설명이 안 되면(예: 긴 태그가 자신을 접두사로 가진 짧은 태그보다 앞에 나오는 경우) `""`를 반환합니다. 유효한 순서가 존재하는 경우, `tags`에 등장하는 글자들에 대해 오직 하나의 순서만 맞도록 입력이 설계되어 있습니다.

**예시 1:**
```
Input: tags = ["ab","ba","bc","cb","cd","dc"]
Output: "abcd"
Explanation: 이웃 쌍들이 a<b, b<c, c<d를 강제하므로 a -> b -> c -> d 순서가 나옵니다.
```

**예시 2:**
```
Input: tags = ["studio","stud"]
Output: ""
Explanation: "stud"는 "studio"의 접두사인데 뒤에 놓여 있어서, 어떤 순서로도 이를 설명할 수 없습니다.
```$KO$,
    $KO$- `tags`에는 최소 한 개의 태그가 들어 있습니다.
- 각 태그는 비어 있지 않은 영어 소문자 문자열입니다.
- 유효한 순서가 존재하는 경우, `tags`에 등장하는 글자들에 대해 모든 이웃 쌍 조건과 일관된 글자 순서가 정확히 하나만 존재하도록 입력이 구성됩니다.$KO$
);

-- schedule-observing-window
UPDATE problems SET
    title = $$Slot a Meeting In$$,
    description = $$The team calendar already has a list of meetings `slots`, each `[start, end]`, sorted by `start` and non-overlapping. Someone just booked a new meeting `newSlot = [start, end]` and you need to slot it in.

Insert `newSlot` into `slots` so the result is still sorted and non-overlapping. Merge anything that touches or overlaps `newSlot` into a single entry, and return the updated list.

**Example 1:**
```
Input: slots = [[1,4],[7,10]], newSlot = [3,6]
Output: [[1,6],[7,10]]
Explanation: newSlot overlaps [1,4], merging into [1,6]. [7,10] is untouched.
```

**Example 2:**
```
Input: slots = [[2,4],[6,8],[10,12],[14,18]], newSlot = [5,11]
Output: [[2,4],[5,12],[14,18]]
Explanation: newSlot swallows [6,8] and [10,12] to form [5,12].
```$$,
    constraints = $$- `0 <= slots.length <= 8000`
- `slots[i].length == 2`
- `0 <= start <= end <= 8 * 10^4`
- `slots` is sorted by `start` in ascending order and contains no overlaps.
- `newSlot.length == 2`$$
WHERE slug = $$schedule-observing-window$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$schedule-observing-window$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$schedule-observing-window$$),
    'ko',
    $KO$일정 끼워 넣기$KO$,
    $KO$팀 캘린더에는 회의 목록 `slots`가 있고, 각 항목은 `[start, end]` 형식에 `start` 오름차순으로 정렬되어 있으며 서로 겹치지 않습니다. 누군가 새 회의 `newSlot = [start, end]`을 잡아서 이걸 끼워 넣어야 해요.

`newSlot`을 `slots`에 추가해 여전히 정렬되고 서로 겹치지 않도록 만들고, `newSlot`과 맞닿거나 겹치는 항목들은 하나로 합친 뒤 결과 리스트를 반환하세요.

**예시 1:**
```
Input: slots = [[1,4],[7,10]], newSlot = [3,6]
Output: [[1,6],[7,10]]
Explanation: newSlot이 [1,4]와 겹쳐 [1,6]으로 합쳐지고, [7,10]은 그대로입니다.
```

**예시 2:**
```
Input: slots = [[2,4],[6,8],[10,12],[14,18]], newSlot = [5,11]
Output: [[2,4],[5,12],[14,18]]
Explanation: newSlot이 [6,8]과 [10,12]를 삼켜 [5,12]가 됩니다.
```$KO$,
    $KO$- `0 <= slots.length <= 8000`
- `slots[i].length == 2`
- `0 <= start <= end <= 8 * 10^4`
- `slots`는 `start` 오름차순으로 정렬되어 있고 서로 겹치지 않습니다.
- `newSlot.length == 2`$KO$
);

-- seize-enclosed-zones
UPDATE problems SET
    title = $$Seize Enclosed Zones$$,
    description = $$You're playing a territory game on a grid where `'X'` is your tile and `'O'` is an enemy tile. Any enemy region that can walk up/down/left/right to the map's border stays alive; enemy regions fully boxed in by your tiles get captured.

Modify `board` **in place**, flipping every fully surrounded `'O'` to `'X'` while leaving any `'O'` connected to the perimeter alone. Return the modified board.

**Example 1:**
```
Input: board = [["X","X","X","X"],["X","O","X","X"],["X","X","O","X"],["X","X","X","O"]]
Output: [["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","X","X","O"]]
Explanation: The `'O'` at (1,1) and (2,2) are boxed in, so they flip. The `'O'` at (3,3) sits on the border and survives.
```

**Example 2:**
```
Input: board = [["O","X"],["O","X"]]
Output: [["O","X"],["O","X"]]
Explanation: Both `'O'` cells are on the first column, already touching the edge, so nothing changes.
```$$,
    constraints = $$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 180`
- `board[i][j]` is `'X'` or `'O'`.$$
WHERE slug = $$seize-enclosed-zones$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$seize-enclosed-zones$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$seize-enclosed-zones$$),
    'ko',
    $KO$갇힌 영역 점령$KO$,
    $KO$영토 게임을 격자에서 합니다. `'X'`는 내 타일, `'O'`는 적 타일이에요. 적 영역이 상/하/좌/우로 이어져 맵 테두리까지 닿을 수 있으면 살아남고, 내 타일로 완전히 둘러싸인 적 영역은 점령됩니다.

`board`를 **그 자리에서** 수정하세요. 완전히 둘러싸인 `'O'`는 `'X'`로 뒤집고, 테두리와 연결된 `'O'`는 그대로 둡니다. 수정된 보드를 반환합니다.

**예시 1:**
```
Input: board = [["X","X","X","X"],["X","O","X","X"],["X","X","O","X"],["X","X","X","O"]]
Output: [["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","X","X","O"]]
Explanation: (1,1)과 (2,2)의 `'O'`는 갇혀 있어서 뒤집힙니다. (3,3)의 `'O'`는 테두리에 걸쳐 살아남습니다.
```

**예시 2:**
```
Input: board = [["O","X"],["O","X"]]
Output: [["O","X"],["O","X"]]
Explanation: `'O'` 둘 다 이미 첫 번째 열 테두리에 닿아 있어 변하지 않습니다.
```$KO$,
    $KO$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 180`
- `board[i][j]`는 `'X'` 또는 `'O'`.$KO$
);

-- sequence-assembly-steps
UPDATE problems SET
    title = $$Sequence Assembly Steps$$,
    description = $$Your group project has `numSteps` tasks labelled `0` to `numSteps - 1`, and some tasks can't start until another is done. Each entry `prereqs[i] = [a, b]` means task `b` must finish before task `a` begins.

Return an order that gets every task done while respecting the prereqs. Any valid order is fine, and if the requirements form a cycle so no order works, return an empty array.

**Example 1:**
```
Input: numSteps = 3, prereqs = [[2,0],[1,0]]
Output: [0,1,2]
Explanation: Task 0 has no prereqs so it runs first. Tasks 1 and 2 can then run in any order; [0,1,2] works.
```

**Example 2:**
```
Input: numSteps = 5, prereqs = [[1,0],[2,1],[3,1],[4,2],[4,3]]
Output: [0,1,2,3,4]
Explanation: 0 must come before 1, which must come before 2 and 3, which both must come before 4. [0,1,2,3,4] respects every edge.
```$$,
    constraints = $$- `1 <= numSteps <= 2000`
- `0 <= prereqs.length <= numSteps * (numSteps - 1)`
- `prereqs[i].length == 2`
- `0 <= a, b < numSteps`
- `a != b`
- All pairs `[a, b]` in `prereqs` are distinct.$$
WHERE slug = $$sequence-assembly-steps$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$sequence-assembly-steps$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$sequence-assembly-steps$$),
    'ko',
    $KO$과제 수행 순서$KO$,
    $KO$그룹 프로젝트에 `0`부터 `numSteps - 1`까지 라벨이 붙은 `numSteps`개의 과제가 있고, 어떤 과제는 다른 과제가 끝나야만 시작할 수 있어요. 각 항목 `prereqs[i] = [a, b]`는 과제 `b`가 끝난 뒤에야 과제 `a`가 시작할 수 있다는 뜻입니다.

선행 조건을 지키면서 모든 과제를 끝내는 순서 하나를 반환하세요. 유효한 순서는 여러 개여도 괜찮고, 요구 사항이 순환을 이뤄 어떤 순서도 불가능하면 빈 배열을 반환합니다.

**예시 1:**
```
Input: numSteps = 3, prereqs = [[2,0],[1,0]]
Output: [0,1,2]
Explanation: 과제 0은 선행이 없어 먼저 실행됩니다. 과제 1과 2는 순서가 자유로우며, [0,1,2]가 유효합니다.
```

**예시 2:**
```
Input: numSteps = 5, prereqs = [[1,0],[2,1],[3,1],[4,2],[4,3]]
Output: [0,1,2,3,4]
Explanation: 0 -> 1 -> {2, 3} -> 4 순서의 모든 간선을 만족합니다.
```$KO$,
    $KO$- `1 <= numSteps <= 2000`
- `0 <= prereqs.length <= numSteps * (numSteps - 1)`
- `prereqs[i].length == 2`
- `0 <= a, b < numSteps`
- `a != b`
- `prereqs`의 모든 `[a, b]` 쌍은 서로 다릅니다.$KO$
);

-- shared-assembly-lookup
UPDATE problems SET
    title = $$Shared Assembly Lookup$$,
    description = $$Your school library's topic catalog is stored as a **binary search tree** where each node holds a topic ID, smaller IDs go left and larger IDs go right. Given the `root` and two specific topics `p` and `q`, return the deepest topic whose subtree still contains both.

A node counts as its own descendant, so if one topic is already an ancestor of the other, return that one. Both `p` and `q` are guaranteed to be in the tree and distinct.

**Example 1:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 8, q = 12
Output: 10
Explanation: 8 sits under the left side of 10 (via 5), and 12 sits under the right side of 10 (via 15). 10 is the deepest topic containing both.
```

**Example 2:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 25, q = 40
Output: 30
Explanation: Both topics sit in the right subtree of 20. Their lowest shared ancestor is 30.
```

**Example 3:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 10, q = 15
Output: 10
Explanation: 15 lives beneath 10, so 10 is itself the shared ancestor.
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[2, 2 * 10^5]`.
- `-10^8 <= Node.val <= 10^8`
- All topic IDs are unique.
- `p != q`
- Both `p` and `q` exist in the tree.$$
WHERE slug = $$shared-assembly-lookup$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$shared-assembly-lookup$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$shared-assembly-lookup$$),
    'ko',
    $KO$공통 조상 주제 찾기$KO$,
    $KO$학교 도서관의 주제 카탈로그는 **이진 탐색 트리**로 저장돼 있고, 각 노드에는 주제 ID가 있으며 작은 ID는 왼쪽, 큰 ID는 오른쪽으로 갑니다. `root`와 특정 주제 `p`, `q`가 주어질 때, 서브트리가 두 주제를 모두 포함하는 가장 깊은 주제를 반환하세요.

노드는 자기 자신도 자손으로 치므로, 한 주제가 이미 다른 주제의 조상이면 그 주제를 반환합니다. `p`와 `q`는 둘 다 트리에 있으며 서로 다르다고 보장됩니다.

**예시 1:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 8, q = 12
Output: 10
Explanation: 8은 10의 왼쪽(5를 거쳐) 아래, 12는 10의 오른쪽(15를 거쳐) 아래에 있습니다. 두 노드를 모두 포함하는 가장 깊은 주제는 10입니다.
```

**예시 2:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 25, q = 40
Output: 30
Explanation: 두 주제 모두 20의 오른쪽 서브트리에 있고, 가장 낮은 공통 조상은 30입니다.
```

**예시 3:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 10, q = 15
Output: 10
Explanation: 15가 10 아래에 있으므로 10 자체가 공통 조상입니다.
```$KO$,
    $KO$- 트리의 노드 수는 `[2, 2 * 10^5]` 범위입니다.
- `-10^8 <= Node.val <= 10^8`
- 모든 주제 ID는 서로 다릅니다.
- `p != q`
- `p`와 `q`는 트리에 모두 존재합니다.$KO$
);

-- shared-dispatch-hub
UPDATE problems SET
    title = $$Shared Party Node$$,
    description = $$Your MMO guild's hierarchy is a tree where the root is the guild master, children are officers, and deeper nodes are squad leaders down to individual members. When two members `p` and `q` want the closest shared captain who oversees them both, you need the deepest node whose subtree contains both.

Given `root`, `p`, and `q`, return that **lowest common ancestor** node. A node is considered an ancestor of itself, so if `p` is already above `q` (or vice versa), that upper node is the answer. All node values are unique and both `p` and `q` exist in the tree.

**Example 1:**
```
Input: root = [12,7,20,4,9,16,25,null,null,8,11], p = 4, q = 11
Output: 7
Explanation: Member 4 sits under officer 7, and member 11 sits under squad leader 9 which sits under officer 7, so 7 is the deepest shared captain.
```

**Example 2:**
```
Input: root = [12,7,20,4,9,16,25,null,null,8,11], p = 9, q = 7
Output: 7
Explanation: Node 9 is already under node 7, so 7 is its own lowest common ancestor with 9.
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[2, 9000]`.
- `|Node.val| <= 10^8`
- All `Node.val` are unique.
- `p != q`
- Both `p` and `q` are present in the tree.$$
WHERE slug = $$shared-dispatch-hub$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$shared-dispatch-hub$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$shared-dispatch-hub$$),
    'ko',
    $KO$공통 팀장 찾기$KO$,
    $KO$MMO 길드의 계층은 트리 구조입니다. 루트는 길드 마스터, 자식들은 간부, 더 깊은 노드는 분대장과 일반 멤버예요. 두 멤버 `p`와 `q`를 함께 관리하는 가장 가까운 공통 팀장을 찾으려면, 서브트리에 두 노드를 모두 포함하는 가장 깊은 노드를 구해야 합니다.

`root`, `p`, `q`가 주어질 때 그 **최소 공통 조상** 노드를 반환하세요. 노드는 자기 자신도 조상으로 칩니다. 즉, `p`가 이미 `q`의 상위에 있거나 반대라면 그 상위 노드가 답입니다. 모든 노드 값은 서로 다르고 `p`와 `q`는 모두 트리에 존재합니다.

**예시 1:**
```
Input: root = [12,7,20,4,9,16,25,null,null,8,11], p = 4, q = 11
Output: 7
Explanation: 멤버 4는 간부 7 아래에 있고, 멤버 11은 7 아래의 분대장 9 아래에 있어서 7이 가장 깊은 공통 팀장입니다.
```

**예시 2:**
```
Input: root = [12,7,20,4,9,16,25,null,null,8,11], p = 9, q = 7
Output: 7
Explanation: 노드 9가 이미 7 아래에 있으므로 9와의 최소 공통 조상은 7 자신입니다.
```$KO$,
    $KO$- 트리의 노드 수는 `[2, 9000]` 범위입니다.
- `|Node.val| <= 10^8`
- 모든 `Node.val`은 서로 다릅니다.
- `p != q`
- `p`와 `q`는 트리에 모두 존재합니다.$KO$
);

-- shelf-overlap-length
UPDATE problems SET
    title = $$Shelf Overlap Length$$,
    description = $$You and your desk-mate each wrote out your class notes as a string of single-letter subject codes, and you want to see the longest stretch of letters that shows up in both in the same order (with extra letters allowed between them).

A **subsequence** is what you get by deleting any letters without reordering. Given note strings `left` and `right`, return the length of the longest common subsequence, or `0` if nothing matches.

**Example 1:**
```
Input: left = "history", right = "mystery"
Output: 4
Explanation: One longest common subsequence is "stry" (length 4).
```

**Example 2:**
```
Input: left = "ocean", right = "canoe"
Output: 3
Explanation: One longest common subsequence is "can": positions 1-3-4 of left and 0-1-2 of right.
```$$,
    constraints = $$- `1 <= left.length, right.length <= 1000`
- `left` and `right` consist of lowercase English letters.$$
WHERE slug = $$shelf-overlap-length$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$shelf-overlap-length$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$shelf-overlap-length$$),
    'ko',
    $KO$겹치는 필기 길이$KO$,
    $KO$짝꿍과 각자 수업 필기를 과목 한 글자짜리 코드 문자열로 적어 놨는데, 두 사람 모두의 필기에 같은 순서로 등장하는 글자들의 가장 긴 구간을 찾고 싶습니다(중간에 다른 글자가 끼어 있어도 괜찮습니다).

**부분 수열**은 순서를 바꾸지 않고 글자들을 골라내서 얻는 것입니다. 필기 문자열 `left`와 `right`가 주어질 때, 가장 긴 공통 부분 수열의 길이를 반환하세요. 겹치는 게 없으면 `0`을 반환합니다.

**예시 1:**
```
Input: left = "history", right = "mystery"
Output: 4
Explanation: One longest common subsequence is "stry" (length 4).
```

**예시 2:**
```
Input: left = "ocean", right = "canoe"
Output: 3
Explanation: One longest common subsequence is "can": positions 1-3-4 of left and 0-1-2 of right.
```$KO$,
    $KO$- `1 <= left.length, right.length <= 1000`
- `left`와 `right`는 영어 소문자로만 이뤄져 있습니다.$KO$
);

-- shift-unscannable-letters
UPDATE problems SET
    title = $$Longest Combo Run$$,
    description = $$Your rhythm game shows the sequence of button letters you hit as an uppercase string `code`, and before scoring you're allowed to **overwrite up to `k`** of them to any letter you want. You want the longest stretch that ends up as a single letter.

Return the length of the longest contiguous run in `code` that can be made all one letter after at most `k` overwrites.

**Example 1:**
```
Input: code = "PQPQ", k = 2
Output: 4
Explanation: Overwrite both P's to Q to get "QQQQ", a run of length 4.
```

**Example 2:**
```
Input: code = "XXYXYYX", k = 1
Output: 4
Explanation: Overwrite the Y at index 2 to X to get the run "XXXX" from indices 0..3.
```$$,
    constraints = $$- `1 <= code.length <= 2 * 10^5`
- `code` consists of only uppercase English letters.
- `0 <= k <= code.length`$$
WHERE slug = $$shift-unscannable-letters$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$shift-unscannable-letters$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$shift-unscannable-letters$$),
    'ko',
    $KO$최장 콤보 구간$KO$,
    $KO$리듬 게임에서 누른 버튼 글자들을 대문자 문자열 `code`로 보여주는데, 점수 계산 전에 그중 **최대 `k`개**를 원하는 글자로 덮어쓸 수 있습니다. 최종적으로 한 글자만 이어지는 가장 긴 구간을 만들고 싶습니다.

최대 `k`번의 덮어쓰기로 `code`에서 전부 같은 글자로 만들 수 있는 가장 긴 연속 구간의 길이를 반환하세요.

**예시 1:**
```
Input: code = "PQPQ", k = 2
Output: 4
Explanation: Overwrite both P's to Q to get "QQQQ", a run of length 4.
```

**예시 2:**
```
Input: code = "XXYXYYX", k = 1
Output: 4
Explanation: Overwrite the Y at index 2 to X to get the run "XXXX" from indices 0..3.
```$KO$,
    $KO$- `1 <= code.length <= 2 * 10^5`
- `code`는 대문자 영어 알파벳으로만 이루어져 있습니다.
- `0 <= k <= code.length`$KO$
);

-- shortest-bake-span
UPDATE problems SET
    title = $$Shortest Cookie Span$$,
    description = $$You're grabbing cookies from a fresh tray at the cafe, and `trays` lists how many cookies each slot holds left to right. You need at least `target` cookies for the group, and you want to scoop up one contiguous run of slots that's as short as possible.

Implement `shortestBakeSpan` to return the length of the shortest contiguous span of `trays` whose sum is at least `target`. Return `0` if no span can hit the target.

**Example 1:**
```
Input: trays = [3,1,4,1,5,9,2,6], target = 15
Output: 3
Explanation: The span [1,5,9] sums to 15, and no shorter span reaches 15.
```

**Example 2:**
```
Input: trays = [2,2,2], target = 10
Output: 0
Explanation: The whole tray only gives 6 cookies, short of the order.
```

**Example 3:**
```
Input: trays = [8,3,2], target = 8
Output: 1
Explanation: The first slot already meets the target by itself.
```$$,
    constraints = $$- `1 <= trays.length <= 2 * 10^5`
- `1 <= trays[i] <= 8000`
- `1 <= target <= 10^8`$$
WHERE slug = $$shortest-bake-span$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$shortest-bake-span$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$shortest-bake-span$$),
    'ko',
    $KO$가장 짧은 쿠키 구간$KO$,
    $KO$카페에서 갓 구워져 나온 쟁반에서 쿠키를 집으려 합니다. `trays`에는 왼쪽에서 오른쪽 순서로 각 칸에 남은 쿠키 수가 들어 있습니다. 일행을 위해 최소 `target`개가 필요하고, 연속된 칸을 한 번에 싹 쓸어 담되 그 길이를 최대한 짧게 하고 싶습니다.

`shortestBakeSpan`을 구현해 `trays`의 연속 구간 중 합이 `target` 이상이면서 길이가 가장 짧은 구간의 길이를 반환하세요. 어떤 구간도 `target`에 도달하지 못하면 `0`을 반환합니다.

**예시 1:**
```
Input: trays = [3,1,4,1,5,9,2,6], target = 15
Output: 3
Explanation: The span [1,5,9] sums to 15, and no shorter span reaches 15.
```

**예시 2:**
```
Input: trays = [2,2,2], target = 10
Output: 0
Explanation: The whole tray only gives 6 cookies, short of the order.
```

**예시 3:**
```
Input: trays = [8,3,2], target = 8
Output: 1
Explanation: The first slot already meets the target by itself.
```$KO$,
    $KO$- `1 <= trays.length <= 2 * 10^5`
- `1 <= trays[i] <= 8000`
- `1 <= target <= 10^8`$KO$
);

-- shortest-shelf-span
UPDATE problems SET
    title = $$Shortest Shelf Span$$,
    description = $$You're grabbing books off a classroom shelf for a group project and need a contiguous run of shelves that covers every letter-tag on your list. You're given a shelf string `shelf` (one letter per volume in shelving order) and a requirements string `needed`, counted with multiplicity — two `'O'`s in `needed` means you need at least two `'O'` volumes.

Return the shortest contiguous substring of `shelf` that covers every letter in `needed` with the right counts, or `""` if none works. On ties, return the earliest one.

**Example 1:**
```
Input: shelf = "FINDTHEBOOKSNOW", needed = "BOK"
Output: "BOOK"
Explanation: The span "BOOK" contains a 'B', an 'O', and a 'K', and no shorter span covers all three tags.
```

**Example 2:**
```
Input: shelf = "XY", needed = "Y"
Output: "Y"
Explanation: The single volume tagged 'Y' already covers the requirement.
```

**Example 3:**
```
Input: shelf = "Q", needed = "QQ"
Output: ""
Explanation: The requirement asks for two 'Q'-tagged volumes, but the shelf only holds one.
```$$,
    constraints = $$- `m == shelf.length`
- `n == needed.length`
- `1 <= m, n <= 2 * 10^5`
- `shelf` and `needed` consist of uppercase and lowercase English letters.$$
WHERE slug = $$shortest-shelf-span$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$shortest-shelf-span$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$shortest-shelf-span$$),
    'ko',
    $KO$가장 짧은 책장 구간$KO$,
    $KO$조별 과제 때문에 교실 책장에서 책을 집어오는데, 필요한 글자 태그를 모두 덮는 연속된 책장 구간이 있어야 합니다. 책장 문자열 `shelf`(꽂힌 순서대로 권당 한 글자)와 필요한 태그를 개수까지 반영한 문자열 `needed`가 주어집니다. 예를 들어 `needed`에 `'O'`가 두 개라면 `'O'` 태그 책이 최소 두 권 필요합니다.

`needed`의 모든 글자를 필요한 개수만큼 포함하는 `shelf`의 가장 짧은 연속 부분 문자열을 반환하고, 그런 구간이 없으면 `""`를 반환하세요. 길이가 같다면 가장 앞쪽 구간을 반환합니다.

**예시 1:**
```
Input: shelf = "FINDTHEBOOKSNOW", needed = "BOK"
Output: "BOOK"
Explanation: The span "BOOK" contains a 'B', an 'O', and a 'K', and no shorter span covers all three tags.
```

**예시 2:**
```
Input: shelf = "XY", needed = "Y"
Output: "Y"
Explanation: The single volume tagged 'Y' already covers the requirement.
```

**예시 3:**
```
Input: shelf = "Q", needed = "QQ"
Output: ""
Explanation: The requirement asks for two 'Q'-tagged volumes, but the shelf only holds one.
```$KO$,
    $KO$- `m == shelf.length`
- `n == needed.length`
- `1 <= m, n <= 2 * 10^5`
- `shelf`와 `needed`는 영어 대소문자로 이루어져 있습니다.$KO$
);

-- single-species-tank
UPDATE problems SET
    title = $$Single Species Tank$$,
    description = $$Your friend runs a little fish shop and only keeps a tank if the fish count is `1`, `2`, `4`, `8`, `16`, ... — a power of two — because that's how the broods split. Any other number (zero, negative, or in between) means the tank is mixed.

Given an integer `specimenCount`, implement `isSoloSpecies(specimenCount)` that returns `true` when `specimenCount == 2^k` for some non-negative integer `k`, and `false` otherwise.

**Example 1:**
```
Input: specimenCount = 32
Output: true
Explanation: 32 = 2^5.
```

**Example 2:**
```
Input: specimenCount = 12
Output: false
Explanation: 12 sits between 2^3 = 8 and 2^4 = 16, so it's not a power of two.
```$$,
    constraints = $$- `-2.1 * 10^9 <= specimenCount <= 2.1 * 10^9`$$
WHERE slug = $$single-species-tank$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$single-species-tank$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$single-species-tank$$),
    'ko',
    $KO$단일 어종 수조$KO$,
    $KO$친구가 작은 열대어 가게를 운영하는데, 물고기 수가 `1`, `2`, `4`, `8`, `16`, ... 같은 2의 거듭제곱일 때만 수조를 유지합니다. 알이 그렇게 갈라져 번식하기 때문이죠. 그 외의 숫자(0, 음수, 혹은 애매한 수)면 수조가 섞인 것으로 봅니다.

정수 `specimenCount`가 주어졌을 때, 어떤 음이 아닌 정수 `k`에 대해 `specimenCount == 2^k`이면 `true`, 아니면 `false`를 반환하는 `isSoloSpecies(specimenCount)`를 구현하세요.

**예시 1:**
```
Input: specimenCount = 32
Output: true
Explanation: 32 = 2^5.
```

**예시 2:**
```
Input: specimenCount = 12
Output: false
Explanation: 12 sits between 2^3 = 8 and 2^4 = 16, so it's not a power of two.
```$KO$,
    $KO$- `-2.1 * 10^9 <= specimenCount <= 2.1 * 10^9`$KO$
);

-- slowest-conveyor-speed
UPDATE problems SET
    title = $$Slowest Snack Rate$$,
    description = $$You have `piles` of leftover Halloween candy to polish off, where `piles[i]` is the piece count of pile `i`, and you've given yourself `hours` hours to finish everything before your dentist appointment. Each hour you pick one pile and eat up to `k` pieces from it; if the pile has fewer than `k` left you just clear it and the rest of that hour is lazy chewing.

Return the smallest integer eating rate `k` that still lets you finish every pile within `hours` hours.

**Example 1:**
```
Input: piles = [5,8,12,20], hours = 9
Output: 6
Explanation: At rate 6 the hours per pile are ceil(5/6)=1, ceil(8/6)=2, ceil(12/6)=2, ceil(20/6)=4, totaling 9.
```

**Example 2:**
```
Input: piles = [40,25,18,33,12], hours = 5
Output: 40
Explanation: With 5 piles and only 5 hours, every pile must clear in a single hour.
```

**Example 3:**
```
Input: piles = [40,25,18,33,12], hours = 7
Output: 25
```$$,
    constraints = $$- `1 <= piles.length <= 2 * 10^5`
- `piles.length <= hours <= 10^8`
- `1 <= piles[i] <= 10^8`$$
WHERE slug = $$slowest-conveyor-speed$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$slowest-conveyor-speed$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$slowest-conveyor-speed$$),
    'ko',
    $KO$가장 느린 간식 속도$KO$,
    $KO$핼러윈이 끝나고 남은 사탕 더미 `piles`를 다 먹어치워야 하는데, `piles[i]`는 더미 `i`의 개수이고, 치과 예약 전에 전부 해치우기 위해 `hours`시간을 잡아뒀습니다. 한 시간마다 한 더미를 골라 거기서 사탕을 최대 `k`개까지 먹는데, 남은 개수가 `k`보다 적으면 그냥 그 더미를 비우고 남는 시간에는 여유롭게 우물거리기만 하면 됩니다.

`hours`시간 안에 모든 더미를 비울 수 있는 가장 작은 정수 먹는 속도 `k`를 반환하세요.

**예시 1:**
```
Input: piles = [5,8,12,20], hours = 9
Output: 6
Explanation: At rate 6 the hours per pile are ceil(5/6)=1, ceil(8/6)=2, ceil(12/6)=2, ceil(20/6)=4, totaling 9.
```

**예시 2:**
```
Input: piles = [40,25,18,33,12], hours = 5
Output: 40
Explanation: With 5 piles and only 5 hours, every pile must clear in a single hour.
```

**예시 3:**
```
Input: piles = [40,25,18,33,12], hours = 7
Output: 25
```$KO$,
    $KO$- `1 <= piles.length <= 2 * 10^5`
- `piles.length <= hours <= 10^8`
- `1 <= piles[i] <= 10^8`$KO$
);

-- smallest-flow-rate
UPDATE problems SET
    title = $$Smallest Flow Rate$$,
    description = $$A cafe has to brew and ship every drink in a pre-arranged queue `volumes` within `days` days, and the drinks must be brewed in the given left-to-right order (the machine's queue is append-only). Each day the barista commits to a single integer flow-rate capacity: drinks are packed consecutively into the day until adding the next one would exceed that capacity, and the day ends.

Return the smallest daily capacity that still lets every drink ship within `days` days.

**Example 1:**
```
Input: volumes = [2,4,5,7,9,11,13,16,18,20], days = 5
Output: 27
Explanation: Capacity 27 ships in 5 days: [2,4,5,7,9], [11,13], [16], [18], [20].
```

**Example 2:**
```
Input: volumes = [4,3,3,5,2,5], days = 3
Output: 8
Explanation: Capacity 8 ships in 3 days: [4,3], [3,5], [2,5].
```

**Example 3:**
```
Input: volumes = [2,3,4,2,2], days = 4
Output: 4
Explanation: Capacity 4 ships in 4 days: [2], [3], [4], [2,2].
```$$,
    constraints = $$- `1 <= days <= volumes.length <= 8 * 10^4`
- `1 <= volumes[i] <= 600`$$
WHERE slug = $$smallest-flow-rate$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$smallest-flow-rate$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$smallest-flow-rate$$),
    'ko',
    $KO$최소 하루 제조 용량$KO$,
    $KO$카페에서 미리 정해진 대기열 `volumes`에 들어 있는 모든 음료를 `days`일 안에 제조해서 출고해야 합니다. 음료는 주어진 왼쪽부터 오른쪽 순서 그대로 만들어야 합니다(기계 대기열에 뒤로만 추가됩니다). 바리스타는 매일 정수 하나의 제조 용량을 정하고, 그날은 다음 음료를 더 넣었을 때 용량을 넘지 않는 한 계속 연속해서 담고, 넘으면 그 날을 마무리합니다.

모든 음료를 `days`일 안에 출고할 수 있게 하는 가장 작은 하루 제조 용량을 반환하세요.

**예시 1:**
```
Input: volumes = [2,4,5,7,9,11,13,16,18,20], days = 5
Output: 27
Explanation: Capacity 27 ships in 5 days: [2,4,5,7,9], [11,13], [16], [18], [20].
```

**예시 2:**
```
Input: volumes = [4,3,3,5,2,5], days = 3
Output: 8
Explanation: Capacity 8 ships in 3 days: [4,3], [3,5], [2,5].
```

**예시 3:**
```
Input: volumes = [2,3,4,2,2], days = 4
Output: 4
Explanation: Capacity 4 ships in 4 days: [2], [3], [4], [2,2].
```$KO$,
    $KO$- `1 <= days <= volumes.length <= 8 * 10^4`
- `1 <= volumes[i] <= 600`$KO$
);

-- snapshot-mesh-layout
UPDATE problems SET
    title = $$Snapshot the Map$$,
    description = $$Before testing a risky mod, you want a private copy of your MMO's town map so the live world stays untouched. You're handed one `node` from a connected undirected graph of town spots; each spot has an integer `val` and a list of `neighbors` it connects to.

Return a **deep copy** of the entire connected map reachable from the given spot. Every node in the copy must be a freshly allocated object with the same `val` and the same neighbor structure, and no node may be shared with the original.

The graph is passed in as an adjacency list, where index `i` (0-based) holds the neighbors of the node with `val = i + 1`. The entry point always has `val = 1` when the graph is non-empty.

**Example 1:**
```
Input: adjList = [[2,3],[1,4],[1,5],[2,5],[3,4]]
Output: [[2,3],[1,4],[1,5],[2,5],[3,4]]
Explanation: Spot 1 connects to 2 and 3; spot 2 connects to 1 and 4. The copy mirrors every edge with new node objects.
```

**Example 2:**
```
Input: adjList = [[2],[1,3],[2]]
Output: [[2],[1,3],[2]]
Explanation: A three-spot line is cloned edge-for-edge.
```$$,
    constraints = $$- The number of spots in the map is in the range `[0, 100]`.
- `1 <= node.val <= 100`
- `node.val` is unique per node.
- The graph has no self-loops and no repeated edges.$$
WHERE slug = $$snapshot-mesh-layout$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$snapshot-mesh-layout$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$snapshot-mesh-layout$$),
    'ko',
    $KO$맵 스냅샷 뜨기$KO$,
    $KO$위험한 모드를 테스트해 보기 전에, 실제 월드를 건드리지 않도록 MMO 마을 맵의 개인 복사본을 하나 따로 뽑아 두려고 합니다. 연결된 무방향 그래프에서 마을 장소 하나를 가리키는 `node`가 주어지며, 각 장소에는 정수 `val`과 연결된 `neighbors` 리스트가 있습니다.

주어진 장소에서 도달 가능한 **연결된 맵 전체를 깊은 복사**해서 반환하세요. 복사본의 모든 노드는 동일한 `val`과 동일한 이웃 구조를 가진, 새로 할당된 객체여야 하며 어떤 노드도 원본과 공유해서는 안 됩니다.

그래프는 인접 리스트로 전달되고, 인덱스 `i` (0부터 시작)에는 `val = i + 1`인 노드의 이웃들이 들어 있습니다. 그래프가 비어 있지 않다면 진입점 노드의 `val`은 항상 `1`입니다.

**예시 1:**
```
Input: adjList = [[2,3],[1,4],[1,5],[2,5],[3,4]]
Output: [[2,3],[1,4],[1,5],[2,5],[3,4]]
Explanation: Spot 1 connects to 2 and 3; spot 2 connects to 1 and 4. The copy mirrors every edge with new node objects.
```

**예시 2:**
```
Input: adjList = [[2],[1,3],[2]]
Output: [[2],[1,3],[2]]
Explanation: A three-spot line is cloned edge-for-edge.
```$KO$,
    $KO$- 맵의 장소 수는 `[0, 100]` 범위입니다.
- `1 <= node.val <= 100`
- `node.val`은 노드마다 유일합니다.
- 그래프에는 자기 자신으로 가는 간선이나 중복 간선이 없습니다.$KO$
);

-- sort-material-bins
UPDATE problems SET
    title = $$Sort Material Bins$$,
    description = $$Your classroom's bin labels got mixed up and you need to re-sort supplies into three ordered groups: `0` for paper, `1` for plastic, `2` for metal. Given an integer array `supplies` containing only these three codes, rearrange it **in place** so all paper codes come first, then plastic, then metal.

Do not call any library sort. The function returns nothing; the caller inspects `supplies` after.

**Example 1:**
```
Input: supplies = [1,2,0,2,1,0,1]
Output: [0,0,1,1,1,2,2]
Explanation: Two paper codes, three plastic codes, then two metal codes.
```

**Example 2:**
```
Input: supplies = [2,1,0]
Output: [0,1,2]
```$$,
    constraints = $$- `1 <= supplies.length <= 2 * 10^3`
- `supplies[i]` is `0`, `1`, or `2`.$$
WHERE slug = $$sort-material-bins$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$sort-material-bins$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$sort-material-bins$$),
    'ko',
    $KO$재활용 수거함 정리$KO$,
    $KO$교실 수거함 라벨이 뒤섞여서 준비물을 세 그룹 순서대로 다시 정리해야 합니다. `0`은 종이, `1`은 플라스틱, `2`는 금속입니다. 이 세 코드만 들어 있는 정수 배열 `supplies`가 주어졌을 때, 종이가 먼저, 그 다음 플라스틱, 마지막에 금속이 오도록 **제자리에서** 재배치하세요.

라이브러리 정렬 함수는 쓰지 마세요. 이 함수는 아무 값도 반환하지 않고, 호출한 쪽이 나중에 `supplies`를 직접 확인합니다.

**예시 1:**
```
Input: supplies = [1,2,0,2,1,0,1]
Output: [0,0,1,1,1,2,2]
Explanation: Two paper codes, three plastic codes, then two metal codes.
```

**예시 2:**
```
Input: supplies = [2,1,0]
Output: [0,1,2]
```$KO$,
    $KO$- `1 <= supplies.length <= 2 * 10^3`
- `supplies[i]`는 `0`, `1`, 또는 `2`입니다.$KO$
);

-- space-recipe-bakes
UPDATE problems SET
    title = $$Space Recipe Bakes$$,
    description = $$You're baking a tray of cookies and laying them on a cooling rack, but no two adjacent cookies may share the same flavor letter. Given the string `cookies`, return any arrangement of its letters such that no two adjacent letters are equal. If no such arrangement exists, return `""`.

**Example 1:**
```
Input: cookies = "bread"
Output: "brade"
Explanation: Any arrangement with no two equal adjacent letters is accepted — e.g. "brade" or "dabre".
```

**Example 2:**
```
Input: cookies = "aaaab"
Output: ""
Explanation: The letter 'a' appears 4 times in a length-5 string, so any arrangement must place two 'a's next to each other.
```

**Example 3:**
```
Input: cookies = "flour"
Output: "flour"
Explanation: All letters are distinct, so the input itself is valid.
```$$,
    constraints = $$- `1 <= cookies.length <= 800`
- `cookies` consists of lowercase English letters only.$$
WHERE slug = $$space-recipe-bakes$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$space-recipe-bakes$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$space-recipe-bakes$$),
    'ko',
    $KO$쿠키 사이 간격 두기$KO$,
    $KO$쿠키 한 판을 구워서 식힘망 위에 하나씩 놓으려는데, 맛 글자가 같은 쿠키가 나란히 붙으면 안 됩니다. 문자열 `cookies`가 주어졌을 때, 인접한 두 글자가 같지 않도록 글자를 재배열한 결과 하나를 반환하세요. 그런 배열이 불가능하면 `""`를 반환합니다.

**예시 1:**
```
Input: cookies = "bread"
Output: "brade"
Explanation: Any arrangement with no two equal adjacent letters is accepted — e.g. "brade" or "dabre".
```

**예시 2:**
```
Input: cookies = "aaaab"
Output: ""
Explanation: The letter 'a' appears 4 times in a length-5 string, so any arrangement must place two 'a's next to each other.
```

**예시 3:**
```
Input: cookies = "flour"
Output: "flour"
Explanation: All letters are distinct, so the input itself is valid.
```$KO$,
    $KO$- `1 <= cookies.length <= 800`
- `cookies`는 영어 소문자로만 이루어져 있습니다.$KO$
);

-- species-grid-validator
UPDATE problems SET
    title = $$Species Grid Validator$$,
    description = $$You're double-checking a classmate's number puzzle before they turn it in. The 9x9 `grid` is split into nine 3x3 boxes, and each cell holds a digit `1`-`9` or `.` for blank. The rule: no digit may repeat inside any row, column, or box — blanks are fine.

Return `true` if every filled cell obeys all three rules, else `false`. The puzzle doesn't have to be solvable; only the filled cells get checked.

**Example 1:**
```
Input: grid =
[[".",".",".",".",".",".",".",".","."]
,[".","1",".",".","2",".",".","3","."]
,[".",".",".",".",".",".",".",".","."]
,[".",".",".",".",".",".",".",".","."]
,[".","4",".",".","5",".",".","6","."]
,[".",".",".",".",".",".",".",".","."]
,[".",".",".",".",".",".",".",".","."]
,[".","7",".",".","8",".",".","9","."]
,[".",".",".",".",".",".",".",".","."]]
Output: true
Explanation: Every row, column, and box holds at most one of each digit, so the grid is valid.
```

**Example 2:**
```
Input: grid =
[[".",".",".",".",".",".",".",".","."]
,[".","1",".",".","2",".",".","1","."]
,[".",".",".",".",".",".",".",".","."]
,[".",".",".",".",".",".",".",".","."]
,[".","4",".",".","5",".",".","6","."]
,[".",".",".",".",".",".",".",".","."]
,[".",".",".",".",".",".",".",".","."]
,[".","7",".",".","8",".",".","9","."]
,[".",".",".",".",".",".",".",".","."]]
Output: false
Explanation: Row 1 has `1` in two columns, which breaks the uniqueness rule.
```$$,
    constraints = $$- `grid.length == 9`
- `grid[i].length == 9`
- Each `grid[i][j]` is a digit `1`-`9` or the character `'.'`.$$
WHERE slug = $$species-grid-validator$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$species-grid-validator$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$species-grid-validator$$),
    'ko',
    $KO$숫자 퍼즐 격자 검사$KO$,
    $KO$반 친구가 과제를 내기 전에 숫자 퍼즐을 검토해 주고 있습니다. 9x9 `grid`는 9개의 3x3 박스로 나뉘고, 각 칸에는 `1`~`9` 중 하나의 숫자 또는 빈 칸을 뜻하는 `.`이 들어 있습니다. 규칙은 간단합니다. 어떤 행, 열, 박스 안에서도 같은 숫자가 두 번 나오면 안 됩니다. 빈 칸은 상관없습니다.

채워진 모든 칸이 세 가지 규칙을 모두 지키면 `true`, 아니면 `false`를 반환하세요. 퍼즐이 풀리는지 여부는 중요하지 않고, 이미 채워진 칸들만 검사합니다.

**예시 1:**
```
Input: grid =
[[".",".",".",".",".",".",".",".","."]
,[".","1",".",".","2",".",".","3","."]
,[".",".",".",".",".",".",".",".","."]
,[".",".",".",".",".",".",".",".","."]
,[".","4",".",".","5",".",".","6","."]
,[".",".",".",".",".",".",".",".","."]
,[".",".",".",".",".",".",".",".","."]
,[".","7",".",".","8",".",".","9","."]
,[".",".",".",".",".",".",".",".","."]]
Output: true
Explanation: Every row, column, and box holds at most one of each digit, so the grid is valid.
```

**예시 2:**
```
Input: grid =
[[".",".",".",".",".",".",".",".","."]
,[".","1",".",".","2",".",".","1","."]
,[".",".",".",".",".",".",".",".","."]
,[".",".",".",".",".",".",".",".","."]
,[".","4",".",".","5",".",".","6","."]
,[".",".",".",".",".",".",".",".","."]
,[".",".",".",".",".",".",".",".","."]
,[".","7",".",".","8",".",".","9","."]
,[".",".",".",".",".",".",".",".","."]]
Output: false
Explanation: Row 1 has `1` in two columns, which breaks the uniqueness rule.
```$KO$,
    $KO$- `grid.length == 9`
- `grid[i].length == 9`
- 각 `grid[i][j]`는 숫자 `1`~`9` 또는 문자 `'.'`입니다.$KO$
);

-- split-headline-tokens
UPDATE problems SET
    title = $$Split Headline Tokens$$,
    description = $$Your phone ate the spaces out of a group-chat message `headline` and you only know the slang words everyone uses, listed in `topics`. Return `true` if `headline` can be split into a sequence of one or more words from `topics` (reusing any word freely), and `false` otherwise.

**Example 1:**
```
Input: headline = "morningwire", topics = ["morning","wire"]
Output: true
Explanation: "morningwire" splits into "morning wire".
```

**Example 2:**
```
Input: headline = "topstoryalert", topics = ["top","story","alert"]
Output: true
Explanation: "topstoryalert" splits into "top story alert".
```

**Example 3:**
```
Input: headline = "breakingnews", topics = ["break","breaking","new","ing"]
Output: false
Explanation: Every prefix match leaves a suffix that can't be fully covered — "news" never appears as a prefix of any word, and neither does a trailing "s".
```$$,
    constraints = $$- `1 <= headline.length <= 400`
- `1 <= topics.length <= 1500`
- `1 <= topics[i].length <= 25`
- `headline` and each `topics[i]` consist only of lowercase English letters.
- All strings in `topics` are distinct.$$
WHERE slug = $$split-headline-tokens$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$split-headline-tokens$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$split-headline-tokens$$),
    'ko',
    $KO$헤드라인 토큰 나누기$KO$,
    $KO$휴대폰이 단체 채팅 메시지 `headline`에서 공백을 다 먹어버렸는데, 다들 쓰는 은어들은 `topics` 목록에 들어 있습니다. `headline`이 `topics`에 있는 단어(원하는 만큼 반복 사용 가능)를 하나 이상 이어 붙여서 만들어질 수 있으면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: headline = "morningwire", topics = ["morning","wire"]
Output: true
Explanation: "morningwire" splits into "morning wire".
```

**예시 2:**
```
Input: headline = "topstoryalert", topics = ["top","story","alert"]
Output: true
Explanation: "topstoryalert" splits into "top story alert".
```

**예시 3:**
```
Input: headline = "breakingnews", topics = ["break","breaking","new","ing"]
Output: false
Explanation: Every prefix match leaves a suffix that can't be fully covered — "news" never appears as a prefix of any word, and neither does a trailing "s".
```$KO$,
    $KO$- `1 <= headline.length <= 400`
- `1 <= topics.length <= 1500`
- `1 <= topics[i].length <= 25`
- `headline`과 각 `topics[i]`는 영어 소문자로만 이뤄져 있습니다.
- `topics`의 모든 문자열은 서로 다릅니다.$KO$
);

-- split-into-two-shifts
UPDATE problems SET
    title = $$Split Baristas Into Two Shifts$$,
    description = $$The cafe manager wants to split baristas into exactly two shifts. Baristas are indexed `0` to `n - 1`, and `conflicts[i]` lists coworkers who can't share a shift with barista `i`. The relation is symmetric and may have several disjoint clusters.

Implement `splitIntoTwoShifts(conflicts)` to return `true` if every barista can be placed on one of two shifts with no conflicting pair on the same shift, else `false`.

**Example 1:**
```
Input: conflicts = [[1],[0,2],[1,3],[2]]
Output: true
Explanation: Put baristas 0 and 2 on morning and 1 and 3 on evening; every conflict crosses shifts.
```

**Example 2:**
```
Input: conflicts = [[1,2],[0,2],[0,1]]
Output: false
Explanation: Baristas 0, 1, and 2 all conflict, so any two-shift split forces two of them together.
```$$,
    constraints = $$- `1 <= conflicts.length <= 150`
- `0 <= conflicts[i].length < conflicts.length`
- `conflicts[i]` does not contain `i`
- If `conflicts[i]` contains `j`, then `conflicts[j]` contains `i`
- The conflict graph may be disconnected$$
WHERE slug = $$split-into-two-shifts$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$split-into-two-shifts$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$split-into-two-shifts$$),
    'ko',
    $KO$바리스타 두 교대 나누기$KO$,
    $KO$카페 매니저는 바리스타들을 정확히 두 교대로 나누고 싶어합니다. 바리스타는 `0`부터 `n - 1`까지 번호가 매겨져 있고, `conflicts[i]`에는 바리스타 `i`와 같은 교대를 할 수 없는 동료들이 들어 있습니다. 이 관계는 대칭이며, 서로 분리된 여러 무리가 섞여 있을 수 있습니다.

모든 바리스타를 두 교대 중 하나에 배치하되 같은 교대에 충돌 관계인 쌍이 한 쌍도 남지 않게 할 수 있으면 `true`, 아니면 `false`를 반환하는 `splitIntoTwoShifts(conflicts)`를 구현하세요.

**예시 1:**
```
Input: conflicts = [[1],[0,2],[1,3],[2]]
Output: true
Explanation: Put baristas 0 and 2 on morning and 1 and 3 on evening; every conflict crosses shifts.
```

**예시 2:**
```
Input: conflicts = [[1,2],[0,2],[0,1]]
Output: false
Explanation: Baristas 0, 1, and 2 all conflict, so any two-shift split forces two of them together.
```$KO$,
    $KO$- `1 <= conflicts.length <= 150`
- `0 <= conflicts[i].length < conflicts.length`
- `conflicts[i]`에는 `i`가 들어 있지 않습니다.
- `conflicts[i]`에 `j`가 있으면 `conflicts[j]`에도 `i`가 있습니다.
- 충돌 그래프는 연결되어 있지 않을 수 있습니다.$KO$
);

-- split-reading-for-product
UPDATE problems SET
    title = $$Split The Candy Bar$$,
    description = $$You have a single candy bar `span` squares long and want to snap it into two or more contiguous chunks (each at least one square). Your score for a split is the chunk lengths multiplied together.

Implement `splitProductMax(span)` to return the maximum product over all valid splits of `span` into two or more positive integer lengths that sum to `span`.

**Example 1:**
```
Input: span = 5
Output: 6
Explanation: The best split is 5 = 2 + 3, giving 2 * 3 = 6. All other splits (1+4, 1+1+3, 1+2+2, 1+1+1+2, 1+1+1+1+1) score lower.
```

**Example 2:**
```
Input: span = 11
Output: 54
Explanation: The best split is 11 = 3 + 3 + 3 + 2, giving 3 * 3 * 3 * 2 = 54. Splits like 3+4+4 yield 48 and 3+3+5 yield 45.
```$$,
    constraints = $$- `2 <= span <= 60`$$
WHERE slug = $$split-reading-for-product$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$split-reading-for-product$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$split-reading-for-product$$),
    'ko',
    $KO$막대 쪼개서 곱 최대화$KO$,
    $KO$길이가 `span` 칸인 캔디 바가 있고, 이걸 연속된 조각 두 개 이상(각 조각 최소 한 칸)으로 쪼개려 합니다. 점수는 조각 길이들의 곱입니다.

합이 `span`이 되는 두 개 이상의 양의 정수 길이로 쪼개는 모든 분할 중 최대 곱을 반환하는 `splitProductMax(span)`을 구현하세요.

**예시 1:**
```
Input: span = 5
Output: 6
Explanation: The best split is 5 = 2 + 3, giving 2 * 3 = 6. All other splits (1+4, 1+1+3, 1+2+2, 1+1+1+2, 1+1+1+1+1) score lower.
```

**예시 2:**
```
Input: span = 11
Output: 54
Explanation: The best split is 11 = 3 + 3 + 3 + 2, giving 3 * 3 * 3 * 2 = 54. Splits like 3+4+4 yield 48 and 3+3+5 yield 45.
```$KO$,
    $KO$- `2 <= span <= 60`$KO$
);

-- split-shift-loads
UPDATE problems SET
    title = $$Split The Ticket Pile$$,
    description = $$Your team has a pile of support tickets, each with an integer effort score in `tickets[i]`. You want to deal every ticket to either Alice or Bob so both end up doing the same total effort — no one gets to slack.

Implement `canSplitLoads(tickets)` that returns `true` if the pile can be split into two disjoint groups with equal total effort, and `false` otherwise.

**Example 1:**
```
Input: tickets = [3,1,1,2,2,1]
Output: true
Explanation: Total is 10, so each person needs 5. One split: {3, 2} for Alice and {1, 1, 2, 1} for Bob.
```

**Example 2:**
```
Input: tickets = [2,2,3,5]
Output: false
Explanation: Total is 12, so each would need 6, but no subset of {2, 2, 3, 5} sums to 6.
```$$,
    constraints = $$- `1 <= tickets.length <= 200`
- `1 <= tickets[i] <= 100`$$
WHERE slug = $$split-shift-loads$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$split-shift-loads$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$split-shift-loads$$),
    'ko',
    $KO$업무량 똑같이 나누기$KO$,
    $KO$팀에 지원 티켓이 잔뜩 쌓였고, 각 티켓에는 정수형 작업량 점수가 `tickets[i]`로 매겨져 있습니다. 이 티켓들을 Alice와 Bob에게 전부 배분해서, 두 사람의 총 작업량이 똑같아지게 하고 싶어요. 아무도 놀 수 없습니다.

배열을 두 개의 서로 겹치지 않는 그룹으로 나눠 합을 같게 만들 수 있으면 `true`, 아니면 `false`를 반환하는 `canSplitLoads(tickets)`를 구현합니다.

**예시 1:**
```
Input: tickets = [3,1,1,2,2,1]
Output: true
Explanation: 합이 10이니 각자 5가 필요합니다. 한 가지 방법: Alice에게 {3, 2}, Bob에게 {1, 1, 2, 1}.
```

**예시 2:**
```
Input: tickets = [2,2,3,5]
Output: false
Explanation: 합이 12라 각자 6이 필요하지만, {2, 2, 3, 5}의 어떤 부분집합도 6이 되지 않습니다.
```$KO$,
    $KO$- `1 <= tickets.length <= 200`
- `1 <= tickets[i] <= 100`$KO$
);

-- split-zone-codes
UPDATE problems SET
    title = $$Split Zone Codes$$,
    description = $$Your roommate wrote down the Wi-Fi's IP as one long blob of digits, and you want to recover every way those digits could form a valid address. An address has exactly four segments separated by dots, each between `0` and `255`, and a segment can't have a leading zero unless it's just `"0"`.

Given a string `digits` of decimal digits, return every valid address by inserting exactly three dots. Return the list sorted lexicographically; return an empty list if none are valid.

**Example 1:**
```
Input: digits = "19216811"
Output: ["1.92.168.11","19.2.168.11","19.21.68.11","19.216.8.11","19.216.81.1","192.1.68.11","192.16.8.11","192.16.81.1","192.168.1.1"]
```

**Example 2:**
```
Input: digits = "0202"
Output: ["0.2.0.2"]
Explanation: Single `"0"` is fine, but a two-digit segment can't start with `0`.
```$$,
    constraints = $$- `1 <= digits.length <= 20`
- `digits` consists of decimal digits only.$$
WHERE slug = $$split-zone-codes$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$split-zone-codes$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$split-zone-codes$$),
    'ko',
    $KO$IP 주소로 쪼개기$KO$,
    $KO$룸메이트가 Wi-Fi의 IP를 숫자만 쭉 이어 적어 놨고, 이 숫자들이 유효한 주소가 될 수 있는 모든 방법을 복원하려 합니다. 주소는 점으로 구분된 네 조각으로 이루어지고, 각 조각은 `0`부터 `255` 사이의 값이며, 조각이 `"0"` 자체가 아니라면 선행 0을 가질 수 없습니다.

십진 숫자로만 이루어진 문자열 `digits`가 주어지면, 점을 정확히 세 개 찍어 만들 수 있는 유효한 주소를 전부 반환하세요. 사전식 오름차순으로 정렬하고, 유효한 주소가 없으면 빈 리스트를 반환합니다.

**예시 1:**
```
Input: digits = "19216811"
Output: ["1.92.168.11","19.2.168.11","19.21.68.11","19.216.8.11","19.216.81.1","192.1.68.11","192.16.8.11","192.16.81.1","192.168.1.1"]
```

**예시 2:**
```
Input: digits = "0202"
Output: ["0.2.0.2"]
Explanation: 한 글자 `"0"`은 괜찮지만, 두 자리 조각은 `0`으로 시작할 수 없습니다.
```$KO$,
    $KO$- `1 <= digits.length <= 20`
- `digits`는 십진 숫자로만 이루어져 있습니다.$KO$
);

-- split-zone-runs
UPDATE problems SET
    title = $$Split Zone Runs$$,
    description = $$You're sorting a long strip of sticker letters into the fewest consecutive chunks you can, with one rule: every distinct letter has to stay inside exactly one chunk. Given the strip `stickers`, the chunks glued back together must equal the original strip.

Return the length of each chunk in order.

**Example 1:**
```
Input: stickers = "mnopmpoqrqrts"
Output: [7,4,1,1]
Explanation: 'm', 'n', 'o', 'p' all live inside the first 7 characters. 'q' and 'r' fill positions 7..10. 't' and 's' each appear once.
```

**Example 2:**
```
Input: stickers = "xyzzyx"
Output: [6]
Explanation: 'x' bookends the strip, pulling 'y' and 'z' into the same chunk, so it's all one piece.
```$$,
    constraints = $$- `1 <= stickers.length <= 500`
- `stickers` consists of lowercase English letters.$$
WHERE slug = $$split-zone-runs$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$split-zone-runs$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$split-zone-runs$$),
    'ko',
    $KO$스티커 문자열 구간 분할$KO$,
    $KO$긴 스티커 글자 띠를 가능한 한 연속 조각 수가 적게 쪼개려고 합니다. 규칙 하나: 서로 다른 글자는 하나의 조각 안에 완전히 들어 있어야 해요. 주어진 띠 `stickers`를 분할했을 때 조각들을 이어 붙이면 원래 띠와 같아야 합니다.

각 조각의 길이를 순서대로 반환하세요.

**예시 1:**
```
Input: stickers = "mnopmpoqrqrts"
Output: [7,4,1,1]
Explanation: 'm', 'n', 'o', 'p'는 전부 앞쪽 7글자 안에 있습니다. 'q'와 'r'은 위치 7..10에 들어갑니다. 't'와 's'는 각각 한 번만 나타납니다.
```

**예시 2:**
```
Input: stickers = "xyzzyx"
Output: [6]
Explanation: 'x'가 양 끝에 있어서 'y'와 'z'를 같은 조각에 끌어들이므로 전체가 한 조각입니다.
```$KO$,
    $KO$- `1 <= stickers.length <= 500`
- `stickers`는 영어 소문자로 이루어져 있습니다.$KO$
);

-- spot-catalog-target
UPDATE problems SET
    title = $$Spot Catalog Target$$,
    description = $$Your RPG's item catalog is normally sorted by ID, but tonight the game patched the starting index so the list was rotated around some pivot — e.g. `[10,14,18,22,25,28,33]` might open as `[25,28,33,10,14,18,22]`.

Given the rotated `catalog` and a `target` ID, return the index where `target` lives in `catalog`, or `-1` if it isn't there. Your routine must run in `O(log n)` time.

**Example 1:**
```
Input: catalog = [12,18,24,31,3,7,9], target = 3
Output: 4
Explanation: The catalog stores 3 at index 4 after the rotation.
```

**Example 2:**
```
Input: catalog = [12,18,24,31,3,7,9], target = 15
Output: -1
Explanation: No entry matches 15.
```

**Example 3:**
```
Input: catalog = [8], target = 3
Output: -1
```$$,
    constraints = $$- `1 <= catalog.length <= 6000`
- `|catalog[i]| <= 10^8`
- All values in `catalog` are unique.
- `catalog` is an ascending list rotated at some unknown pivot.
- `|target| <= 10^8`$$
WHERE slug = $$spot-catalog-target$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$spot-catalog-target$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$spot-catalog-target$$),
    'ko',
    $KO$회전된 카탈로그 탐색$KO$,
    $KO$RPG의 아이템 카탈로그는 원래 ID 순으로 정렬되어 있지만, 오늘 게임이 시작 인덱스를 바꿔버려 어떤 축 기준으로 회전되어 있어요. 예를 들어 `[10,14,18,22,25,28,33]`이 `[25,28,33,10,14,18,22]`로 열릴 수 있습니다.

회전된 `catalog`와 찾으려는 ID `target`이 주어지면, `catalog`에서 `target`의 인덱스를 반환하고 없으면 `-1`을 반환하세요. 알고리즘은 `O(log n)` 시간에 동작해야 합니다.

**예시 1:**
```
Input: catalog = [12,18,24,31,3,7,9], target = 3
Output: 4
Explanation: 회전된 카탈로그에서 3은 인덱스 4에 있습니다.
```

**예시 2:**
```
Input: catalog = [12,18,24,31,3,7,9], target = 15
Output: -1
Explanation: 15에 해당하는 항목이 없습니다.
```

**예시 3:**
```
Input: catalog = [8], target = 3
Output: -1
```$KO$,
    $KO$- `1 <= catalog.length <= 6000`
- `|catalog[i]| <= 10^8`
- `catalog`의 값은 모두 서로 다릅니다.
- `catalog`는 오름차순으로 정렬된 뒤 알 수 없는 지점에서 회전된 리스트입니다.
- `|target| <= 10^8`$KO$
);

-- spread-contamination-wave
UPDATE problems SET
    title = $$Spread Contamination Wave$$,
    description = $$Your office kitchen has an `m x n` grid of donuts on a shared tray, and each cell is one of three states:

- `0` — an **empty slot** (no donut)
- `1` — a **fresh donut**
- `2` — a **stale donut**

Each minute, any fresh donut that shares a 4-directional edge with a stale one also goes stale. Return the minimum minutes until no fresh donuts remain, or `-1` if some fresh donut can never be reached.

**Example 1:**
```
Input: ward = [[2,1,1],[1,0,1],[1,1,1]]
Output: 4
Explanation: Starting from the single stale donut at (0,0), the last fresh one at (2,2) goes stale after four minutes.
```

**Example 2:**
```
Input: ward = [[2,0,1],[0,0,1],[1,1,1]]
Output: -1
Explanation: The stale donut at (0,0) is walled off by empty slots, so the fresh ones never get reached.
```

**Example 3:**
```
Input: ward = [[0,0,2],[0,0,0]]
Output: 0
Explanation: There are no fresh donuts, so zero minutes pass.
```$$,
    constraints = $$- `m == ward.length`
- `n == ward[i].length`
- `1 <= m, n <= 10`
- `ward[i][j]` is `0`, `1`, or `2`.$$
WHERE slug = $$spread-contamination-wave$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$spread-contamination-wave$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$spread-contamination-wave$$),
    'ko',
    $KO$도넛 상함 전파$KO$,
    $KO$사무실 휴게실에 놓인 공용 쟁반은 `m x n` 격자이고, 각 칸은 세 상태 중 하나입니다.

- `0` — **빈 자리** (도넛 없음)
- `1` — **신선한 도넛**
- `2` — **상한 도넛**

매 분마다, 상한 도넛과 상하좌우로 맞닿은 신선한 도넛도 상해 갑니다. 신선한 도넛이 하나도 남지 않을 때까지의 최소 시간(분)을 반환하고, 끝까지 닿지 못하는 신선한 도넛이 있으면 `-1`을 반환하세요.

**예시 1:**
```
Input: ward = [[2,1,1],[1,0,1],[1,1,1]]
Output: 4
Explanation: (0,0)의 상한 도넛에서 시작해, (2,2)의 마지막 신선한 도넛이 4분 뒤에 상합니다.
```

**예시 2:**
```
Input: ward = [[2,0,1],[0,0,1],[1,1,1]]
Output: -1
Explanation: (0,0)의 상한 도넛이 빈 자리에 막혀 있어 신선한 도넛에 결코 닿지 못합니다.
```

**예시 3:**
```
Input: ward = [[0,0,2],[0,0,0]]
Output: 0
Explanation: 신선한 도넛이 없으므로 0분이 지납니다.
```$KO$,
    $KO$- `m == ward.length`
- `n == ward[i].length`
- `1 <= m, n <= 10`
- `ward[i][j]`는 `0`, `1`, `2` 중 하나입니다.$KO$
);

-- stack-queue
UPDATE problems SET
    title = $$Queue Built from Stacks$$,
    description = $$Your cafe has a drink pickup counter that should serve customers in the order they ordered, but the only trays you have are the pushdown kind where you can only touch the top cup. Build `QueueFromStacks` so it behaves as a FIFO line while internally using exactly two such trays and nothing else (no arrays, lists, or deques). You may only push, pop, peek, or check emptiness on the two internal trays.

- `QueueFromStacks()` starts an empty line.
- `void push(int x)` adds order `x` to the back of the line.
- `int pop()` removes and returns the order at the front.
- `int peek()` returns the front order without removing it.
- `boolean empty()` returns `true` if nothing is queued.

The caller promises never to call `pop` or `peek` on an empty line.

**Example:**
```
q = new QueueFromStacks()
q.push(1)
q.push(2)
q.peek()   // 1  -- front of the line
q.pop()    // 1  -- front is served
q.empty()  // false -- 2 still waiting
```$$,
    constraints = $$- `1 <= x <= 9`
- At most `100` combined calls to `push`, `pop`, `peek`, and `empty`
- `pop` and `peek` are only invoked when the line is non-empty$$
WHERE slug = $$stack-queue$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$stack-queue$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$stack-queue$$),
    'ko',
    $KO$스택으로 큐 만들기$KO$,
    $KO$카페의 음료 픽업대는 주문 순서대로 내주어야 하는데, 쓸 수 있는 트레이는 맨 위 컵만 만질 수 있는 푸시다운 방식 두 개뿐이에요. 내부적으로 정확히 이 두 트레이만 쓰고(배열, 리스트, 덱 금지) 외부에서 보기엔 FIFO 줄처럼 동작하는 `QueueFromStacks`를 만들어 주세요. 두 내부 트레이에 대해서는 push, pop, peek, 비었는지 확인만 쓸 수 있습니다.

- `QueueFromStacks()` — 빈 줄로 시작합니다.
- `void push(int x)` — 주문 `x`를 줄 맨 뒤에 추가합니다.
- `int pop()` — 줄 맨 앞 주문을 빼서 반환합니다.
- `int peek()` — 제거하지 않고 맨 앞 주문을 반환합니다.
- `boolean empty()` — 대기 중인 주문이 없으면 `true`를 반환합니다.

호출자는 빈 줄에서는 `pop`이나 `peek`를 호출하지 않기로 약속합니다.

**예시:**
```
q = new QueueFromStacks()
q.push(1)
q.push(2)
q.peek()   // 1 -- 줄 맨 앞
q.pop()    // 1 -- 맨 앞 처리
q.empty()  // false -- 2가 아직 대기 중
```$KO$,
    $KO$- `1 <= x <= 9`
- `push`, `pop`, `peek`, `empty` 호출은 합쳐서 최대 `100`번입니다.
- `pop`과 `peek`는 줄이 비어 있지 않을 때만 호출됩니다.$KO$
);

-- state-snapshots
UPDATE problems SET
    title = $$Versioned Cell Array$$,
    description = $$You're building a save-file tool for a sandbox game: the world is a row of numeric cells you can edit, and every so often you freeze the whole row as a snapshot to revisit later. All cells start at `0`, and snapshot ids count up from `0`.

Implement the `VersionedCells` class:

- `VersionedCells(int length)` creates a row of `length` cells, all initialized to `0`, with no snapshots yet taken.
- `void set(int index, int val)` overwrites the live value at position `index` with `val`. Previously committed snapshots are untouched.
- `int commit()` freezes the current live row as a new snapshot and returns its id. The first call returns `0`, the second `1`, and so on.
- `int readAt(int index, int snapId)` returns the value that cell `index` held in the snapshot identified by `snapId`.

**Example:**
```
cells = new VersionedCells(3)
cells.set(0, 5)
cells.commit()        // returns 0; snapshot 0 is [5, 0, 0]
cells.set(0, 6)       // live row is now [6, 0, 0]
cells.readAt(0, 0)    // 5 -- value of cell 0 in snapshot 0
```$$,
    constraints = $$- `1 <= length <= 50000`
- `0 <= index < length`
- `0 <= val <= 10^8`
- `0 <= snapId` and `snapId` is strictly less than the number of `commit` calls made so far
- At most `50000` combined calls to `set`, `commit`, and `readAt`$$
WHERE slug = $$state-snapshots$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$state-snapshots$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$state-snapshots$$),
    'ko',
    $KO$버전 관리되는 셀 배열$KO$,
    $KO$샌드박스 게임용 세이브파일 도구를 만들고 있습니다. 세상은 숫자 셀이 한 줄로 늘어선 모양이고, 언제든 값을 바꿀 수 있으며, 가끔 전체 줄을 통째로 얼려서 스냅샷으로 저장해 두고 나중에 다시 볼 수 있습니다. 모든 셀은 `0`으로 시작하고, 스냅샷 id는 `0`부터 올라갑니다.

`VersionedCells` 클래스를 구현하세요:

- `VersionedCells(int length)`는 `length`개의 셀을 모두 `0`으로 초기화한 줄을 만들고, 스냅샷은 아직 없습니다.
- `void set(int index, int val)`은 위치 `index`의 현재 값을 `val`로 덮어씁니다. 이미 저장된 스냅샷은 영향을 받지 않습니다.
- `int commit()`은 현재 줄을 새 스냅샷으로 얼리고 그 id를 반환합니다. 첫 호출은 `0`, 두 번째는 `1`, 이런 식입니다.
- `int readAt(int index, int snapId)`는 `snapId`로 지정된 스냅샷에서 셀 `index`가 가지고 있던 값을 반환합니다.

**예시:**
```
cells = new VersionedCells(3)
cells.set(0, 5)
cells.commit()        // returns 0; snapshot 0 is [5, 0, 0]
cells.set(0, 6)       // live row is now [6, 0, 0]
cells.readAt(0, 0)    // 5 -- value of cell 0 in snapshot 0
```$KO$,
    $KO$- `1 <= length <= 50000`
- `0 <= index < length`
- `0 <= val <= 10^8`
- `0 <= snapId`이며 `snapId`는 지금까지 호출된 `commit` 횟수보다 엄격히 작습니다.
- `set`, `commit`, `readAt` 호출은 합쳐서 최대 `50000`번입니다.$KO$
);

-- station-run-planner
UPDATE problems SET
    title = $$Task Cooldown Planner$$,
    description = $$Your office runs a single shared printer, and each print job is labeled by the coworker who sent it, but the printer refuses to handle back-to-back jobs from the same person within `n` cooldown slots. Each slot the queue either prints one job or sits idle, and jobs can be reordered freely.

Given `jobs` and `n`, return the minimum number of slots needed to print every job while respecting the cooldown.

**Example 1:**
```
Input: jobs = ["P","P","P","P","Q","Q"], n = 3
Output: 13
Explanation: One valid schedule is P -> Q -> idle -> idle -> P -> Q -> idle -> idle -> P -> idle -> idle -> idle -> P, using 13 slots.
```

**Example 2:**
```
Input: jobs = ["A","B","C","A","B","D"], n = 1
Output: 6
Explanation: The order A -> B -> C -> A -> B -> D already separates identical labels by at least 1 slot, so no idle slots are needed.
```$$,
    constraints = $$- `1 <= jobs.length <= 2 * 10^3`
- `jobs[i]` is an uppercase English letter
- `0 <= n <= 100`$$
WHERE slug = $$station-run-planner$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$station-run-planner$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$station-run-planner$$),
    'ko',
    $KO$작업 쿨다운 스케줄러$KO$,
    $KO$사무실에서 공용 프린터 한 대를 같이 쓰는데, 각 인쇄 작업은 보낸 사람의 이름으로 표시되고 프린터는 같은 사람의 작업을 `n` 슬롯의 쿨다운이 지나기 전에는 연속으로 받지 않습니다. 슬롯마다 큐는 작업을 하나 인쇄하거나 그냥 쉬고, 작업 순서는 자유롭게 바꿔도 됩니다.

`jobs`와 `n`이 주어지면, 쿨다운을 지키면서 모든 작업을 인쇄하는 데 필요한 최소 슬롯 수를 반환하세요.

**예시 1:**
```
Input: jobs = ["P","P","P","P","Q","Q"], n = 3
Output: 13
Explanation: One valid schedule is P -> Q -> idle -> idle -> P -> Q -> idle -> idle -> P -> idle -> idle -> idle -> P, using 13 slots.
```

**예시 2:**
```
Input: jobs = ["A","B","C","A","B","D"], n = 1
Output: 6
Explanation: The order A -> B -> C -> A -> B -> D already separates identical labels by at least 1 slot, so no idle slots are needed.
```$KO$,
    $KO$- `1 <= jobs.length <= 2 * 10^3`
- `jobs[i]`는 대문자 영어 알파벳입니다
- `0 <= n <= 100`$KO$
);

-- station-throughput-shares
UPDATE problems SET
    title = $$Station Throughput Shares$$,
    description = $$Your cafe's morning shift has several baristas in a row and `rates[i]` is how many drinks barista `i` pumps out per cycle. For a manager's report, each barista's **share** is the product of every other barista's rate.

Given `rates`, return an array `shares` of the same length where `shares[i]` equals the product of `rates[j]` for all `j != i`. Any prefix or suffix product of `rates` fits in a signed 32-bit integer. Solve without division and in linear time.

**Example 1:**
```
Input: rates = [2,3,5,4]
Output: [60,40,24,30]
Explanation: For barista 0: 3*5*4 = 60. For barista 1: 2*5*4 = 40. And so on.
```

**Example 2:**
```
Input: rates = [-2,1,0,4,-1]
Output: [0,0,8,0,0]
Explanation: Every share except index 2 multiplies through the zero at barista 2. The share for barista 2 is (-2)*1*4*(-1) = 8.
```$$,
    constraints = $$- `2 <= rates.length <= 2 * 10^5`
- `-30 <= rates[i] <= 30`
- The product of any prefix or suffix of `rates` fits in a signed 32-bit integer.$$
WHERE slug = $$station-throughput-shares$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$station-throughput-shares$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$station-throughput-shares$$),
    'ko',
    $KO$바리스타 처리량 지분$KO$,
    $KO$카페 아침 교대조에는 바리스타 여러 명이 한 줄로 서 있고, `rates[i]`는 바리스타 `i`가 한 사이클에 만드는 음료 수입니다. 매니저 리포트용으로 각 바리스타의 **지분**은 자신을 뺀 나머지 모든 바리스타 속도의 곱으로 정의합니다.

`rates`가 주어졌을 때, 같은 길이의 배열 `shares`를 반환하되 `shares[i]`는 모든 `j != i`에 대한 `rates[j]`의 곱과 같아야 합니다. `rates`의 어떤 접두/접미 곱도 부호 있는 32비트 정수 범위 안에 들어옵니다. 나눗셈을 쓰지 말고 선형 시간에 풀어 보세요.

**예시 1:**
```
Input: rates = [2,3,5,4]
Output: [60,40,24,30]
Explanation: For barista 0: 3*5*4 = 60. For barista 1: 2*5*4 = 40. And so on.
```

**예시 2:**
```
Input: rates = [-2,1,0,4,-1]
Output: [0,0,8,0,0]
Explanation: Every share except index 2 multiplies through the zero at barista 2. The share for barista 2 is (-2)*1*4*(-1) = 8.
```$KO$,
    $KO$- `2 <= rates.length <= 2 * 10^5`
- `-30 <= rates[i] <= 30`
- `rates`의 어떤 접두 곱이나 접미 곱도 부호 있는 32비트 정수 범위 안에 들어옵니다.$KO$
);

-- station-visit-orders
UPDATE problems SET
    title = $$Cafe Stop Orders$$,
    description = $$You're planning a weekend cafe crawl and have a list `stops` of distinct cafe IDs you want to hit, one visit each. You're curious about every possible order you could visit them in.

Implement `listStationOrders` to return every ordering of `stops`. Any order of the outer list works.

**Example 1:**
```
Input: stops = [4,7,2]
Output: [[4,7,2],[4,2,7],[7,4,2],[7,2,4],[2,4,7],[2,7,4]]
Explanation: Three distinct cafes give 3! = 6 possible visit orders.
```

**Example 2:**
```
Input: stops = [5,9]
Output: [[5,9],[9,5]]
```$$,
    constraints = $$- `1 <= stops.length <= 6`
- `-10 <= stops[i] <= 10`
- All entries of `stops` are distinct.$$
WHERE slug = $$station-visit-orders$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$station-visit-orders$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$station-visit-orders$$),
    'ko',
    $KO$카페 투어 순서 짜기$KO$,
    $KO$주말 카페 투어를 계획 중이고, 서로 다른 카페 ID가 담긴 리스트 `stops`를 한 번씩 다 방문하려 합니다. 어떤 순서로 갈 수 있는지 모든 경우가 궁금합니다.

`stops`의 모든 순열을 반환하도록 `listStationOrders`를 구현하세요. 바깥 리스트의 순서는 어떻게 되어 있어도 상관없습니다.

**예시 1:**
```
Input: stops = [4,7,2]
Output: [[4,7,2],[4,2,7],[7,4,2],[7,2,4],[2,4,7],[2,7,4]]
Explanation: Three distinct cafes give 3! = 6 possible visit orders.
```

**예시 2:**
```
Input: stops = [5,9]
Output: [[5,9],[9,5]]
```$KO$,
    $KO$- `1 <= stops.length <= 6`
- `-10 <= stops[i] <= 10`
- `stops`의 모든 원소는 서로 다릅니다.$KO$
);

-- string-codec
UPDATE problems SET
    title = $$Chat Log Codec$$,
    description = $$You're writing a save system for a co-op game's chat log: the sender has a list of player messages and can only hand the receiver one single string, which then has to be unpacked back into the exact same list.

Implement the `ListCoder` class with two methods:

- `String pack(List<String> messages)` takes a list of messages and returns a single string carrying enough structure to recover the list later. Messages can contain any characters, including whatever marker you pick, so a plain join on a reserved character won't work.
- `List<String> unpack(String blob)` takes a string previously produced by `pack` and returns the original list with the same order, length, and contents, including empty messages.

The codec must be stateless: everything `unpack` needs lives inside the string `pack` emitted. A round trip must reproduce the input list exactly, even when the list is empty, contains empty messages, or contains messages built entirely of marker-like characters.$$,
    constraints = $$- `0 <= messages.length <= 200`
- `0 <= messages[i].length <= 200`
- Each `messages[i]` may contain any Unicode code point, including characters the codec uses as delimiters or escapes.$$
WHERE slug = $$string-codec$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$string-codec$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$string-codec$$),
    'ko',
    $KO$채팅 로그 코덱$KO$,
    $KO$협동 게임의 채팅 로그를 저장하는 시스템을 만들고 있습니다. 보내는 쪽에는 플레이어 메시지 리스트가 있고, 받는 쪽에는 문자열 하나만 건네줄 수 있으며, 그걸 다시 원래 리스트로 정확히 복원해야 합니다.

다음 두 메서드를 가진 `ListCoder` 클래스를 구현하세요.

- `String pack(List<String> messages)`는 메시지 리스트를 받아서, 나중에 리스트를 복원할 수 있을 만큼 구조 정보를 담은 하나의 문자열을 반환합니다. 메시지에는 어떤 문자든(여러분이 고른 구분 문자 포함) 들어갈 수 있으므로, 특정 문자로 단순히 이어 붙이는 방식은 통하지 않습니다.
- `List<String> unpack(String blob)`은 이전에 `pack`이 만든 문자열을 받아서, 순서·길이·내용이 모두 같은 원래 리스트를 반환합니다. 빈 메시지도 그대로 살려야 합니다.

코덱은 상태를 가지지 않아야 합니다. `unpack`에 필요한 모든 정보는 `pack`이 내놓은 문자열 안에 들어 있어야 합니다. 리스트가 비어 있거나, 빈 메시지를 포함하거나, 구분 문자처럼 보이는 문자들로만 이루어진 메시지가 있어도 왕복 변환이 입력을 정확히 재현해야 합니다.$KO$,
    $KO$- `0 <= messages.length <= 200`
- `0 <= messages[i].length <= 200`
- 각 `messages[i]`에는 코덱이 구분자나 이스케이프로 쓰는 문자를 포함해 임의의 유니코드 코드 포인트가 들어 있을 수 있습니다.$KO$
);

-- sum-zone-codes
UPDATE problems SET
    title = $$Sum Skill Tree Codes$$,
    description = $$Your RPG stores each character's skill tree as a binary tree where every node holds a single digit (`0`-`9`). Walking from the root down to any leaf spells out a build code for that branch — just concatenate the digits along the way into one integer.

Given the `root` of the skill tree, implement `totalZoneCodes` to return the sum of every build code produced by a root-to-leaf walk.

**Example 1:**
```
Input: root = [2,5,8]
Output: 53
Explanation: Path 2 -> 5 spells 25 and path 2 -> 8 spells 28. Total = 25 + 28 = 53.
```

**Example 2:**
```
Input: root = [3,6,1,4,0]
Output: 755
Explanation: 3 -> 6 -> 4 = 364, 3 -> 6 -> 0 = 360, 3 -> 1 = 31. Total = 364 + 360 + 31 = 755.
```

**Example 3:**
```
Input: root = [9]
Output: 9
Explanation: A single node is both root and leaf, giving one code of 9.
```$$,
    constraints = $$- The number of nodes in the skill tree is in the range `[1, 1000]`.
- `0 <= Node.val <= 9`$$
WHERE slug = $$sum-zone-codes$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$sum-zone-codes$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$sum-zone-codes$$),
    'ko',
    $KO$스킬 트리 코드 합 구하기$KO$,
    $KO$당신의 RPG에서는 각 캐릭터의 스킬 트리를 한 자리 숫자(`0`~`9`)를 담은 이진 트리로 저장합니다. 루트에서 어떤 리프까지 내려가면서 그 경로의 숫자들을 이어 붙이면 그 분기의 빌드 코드 하나가 만들어지는데, 그냥 지나온 숫자들을 차례대로 붙여 하나의 정수로 만들면 됩니다.

스킬 트리의 `root`가 주어졌을 때, 루트에서 리프까지 내려가는 모든 경로가 만들어내는 빌드 코드의 합을 반환하는 `totalZoneCodes`를 구현하세요.

**예시 1:**
```
Input: root = [2,5,8]
Output: 53
Explanation: Path 2 -> 5 spells 25 and path 2 -> 8 spells 28. Total = 25 + 28 = 53.
```

**예시 2:**
```
Input: root = [3,6,1,4,0]
Output: 755
Explanation: 3 -> 6 -> 4 = 364, 3 -> 6 -> 0 = 360, 3 -> 1 = 31. Total = 364 + 360 + 31 = 755.
```

**예시 3:**
```
Input: root = [9]
Output: 9
Explanation: A single node is both root and leaf, giving one code of 9.
```$KO$,
    $KO$- 스킬 트리의 노드 개수는 `[1, 1000]` 범위 안에 있습니다.
- `0 <= Node.val <= 9`$KO$
);

-- swap-queue-partners
UPDATE problems SET
    title = $$Swap Queue Partners$$,
    description = $$The office print queue is a linked list of job ids, and once a week your coworker insists every two neighbors in the queue swap spots to "share the wait." If the queue has an odd number of jobs, the last job is left alone.

Implement `swapQueuePartners(head)` to relink `next` pointers so each adjacent pair is swapped, returning the new head. Don't change the values inside the nodes — only the links.

**Example 1:**
```
Input: head = [11,22,33,44]
Output: [22,11,44,33]
Explanation: Pairs (11,22) and (33,44) trade places.
```

**Example 2:**
```
Input: head = [8,3]
Output: [3,8]
Explanation: The single pair is swapped.
```

**Example 3:**
```
Input: head = [6,9,15]
Output: [9,6,15]
Explanation: The first pair swaps; job 15 has no partner and keeps its spot.
```$$,
    constraints = $$- `0 <= Number of jobs <= 120`
- `0 <= Job.val <= 100`$$
WHERE slug = $$swap-queue-partners$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$swap-queue-partners$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$swap-queue-partners$$),
    'ko',
    $KO$인쇄 대기열 짝 바꾸기$KO$,
    $KO$사무실 인쇄 대기열은 작업 id를 담은 연결 리스트인데, 매주 한 번씩 동료가 "기다리는 시간 공평하게 나누자"며 대기열에서 이웃한 두 작업끼리 자리를 바꾸자고 합니다. 작업 개수가 홀수면 마지막 작업은 그대로 둡니다.

`swapQueuePartners(head)`를 구현해 인접한 짝끼리 자리를 바꾸도록 `next` 포인터를 다시 연결하고, 새 헤드를 반환하세요. 노드 안의 값은 바꾸지 말고 링크만 바꿔야 합니다.

**예시 1:**
```
Input: head = [11,22,33,44]
Output: [22,11,44,33]
Explanation: Pairs (11,22) and (33,44) trade places.
```

**예시 2:**
```
Input: head = [8,3]
Output: [3,8]
Explanation: The single pair is swapped.
```

**예시 3:**
```
Input: head = [6,9,15]
Output: [9,6,15]
Explanation: The first pair swaps; job 15 has no partner and keeps its spot.
```$KO$,
    $KO$- `0 <= Number of jobs <= 120`
- `0 <= Job.val <= 100`$KO$
);

-- tally-device-meshes
UPDATE problems SET
    title = $$Tally Device Meshes$$,
    description = $$In a co-op game you have `n` players labelled `0` to `n - 1` who can only chat through voice-relays. Each entry `relays[i] = [a, b]` means player `a` and player `b` can hear each other directly, and two players are in the same party if a chain of relays connects them.

Implement `tallyDeviceMeshes(n, relays)` to return how many separate parties exist. A player with no relays still counts as their own party of one.

**Example 1:**
```
Input: n = 6, relays = [[0,1],[2,3],[3,4]]
Output: 3
Explanation: Players `{0,1}` share a relay, `{2,3,4}` are chained, and player `5` is alone — three parties total.
```

**Example 2:**
```
Input: n = 7, relays = [[0,1],[1,2],[2,3],[3,4],[4,5],[5,6]]
Output: 1
Explanation: Every player is reachable from every other through the relay chain, so one big party.
```$$,
    constraints = $$- `1 <= n <= 2000`
- `0 <= relays.length <= 5000`
- `relays[i].length == 2`
- `0 <= a, b < n`
- `a != b`
- No pair appears in `relays` more than once.$$
WHERE slug = $$tally-device-meshes$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$tally-device-meshes$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$tally-device-meshes$$),
    'ko',
    $KO$음성 릴레이 파티 세기$KO$,
    $KO$협동 게임에서 `0`부터 `n - 1`까지 번호가 매겨진 `n`명의 플레이어가 있는데, 이들은 오직 음성 릴레이를 통해서만 대화할 수 있습니다. `relays[i] = [a, b]`는 플레이어 `a`와 플레이어 `b`가 서로 직접 들을 수 있다는 뜻이고, 릴레이 체인으로 이어져 있는 두 플레이어는 같은 파티로 간주됩니다.

존재하는 서로 다른 파티의 수를 반환하도록 `tallyDeviceMeshes(n, relays)`를 구현하세요. 릴레이가 하나도 없는 플레이어도 혼자서 하나의 파티로 칩니다.

**예시 1:**
```
Input: n = 6, relays = [[0,1],[2,3],[3,4]]
Output: 3
Explanation: Players `{0,1}` share a relay, `{2,3,4}` are chained, and player `5` is alone — three parties total.
```

**예시 2:**
```
Input: n = 7, relays = [[0,1],[1,2],[2,3],[3,4],[4,5],[5,6]]
Output: 1
Explanation: Every player is reachable from every other through the relay chain, so one big party.
```$KO$,
    $KO$- `1 <= n <= 2000`
- `0 <= relays.length <= 5000`
- `relays[i].length == 2`
- `0 <= a, b < n`
- `a != b`
- `relays`에 같은 쌍이 두 번 이상 나오지 않습니다.$KO$
);

-- tally-dominant-blocks
UPDATE problems SET
    title = $$Tally Top Scores$$,
    description = $$In a dungeon-crawler, your party tree records each hero's damage number, and you call a hero **dominant** when nobody on the path from the root party leader down to them had a strictly higher number. The root leader always counts as dominant.

Given the `root` of the party tree, implement `tallyDominantBlocks(root)` to return how many dominant heroes the tree contains.

**Example 1:**
```
Input: root = [4,2,6,5,1,null,7]
Output: 4
Explanation: Hero 4 (root) is dominant. 5 beats its max ancestor 4. 6 beats its max ancestor 4. 7 beats its max ancestor 6. Hero 2 is overshadowed by 4, and hero 1 is overshadowed by 4.
```

**Example 2:**
```
Input: root = [5,3,5,2,4]
Output: 2
Explanation: The root 5 is dominant. The right child 5 ties with its ancestor 5 and still counts. The left subtree heroes (3, 2, 4) are all overshadowed by the root.
```

**Example 3:**
```
Input: root = [7]
Output: 1
Explanation: A single hero is always dominant.
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[1, 2 * 10^5]`.
- `-10^8 <= Node.val <= 10^8`$$
WHERE slug = $$tally-dominant-blocks$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$tally-dominant-blocks$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$tally-dominant-blocks$$),
    'ko',
    $KO$최고점 영웅 세기$KO$,
    $KO$던전 크롤러에서 파티 트리가 각 영웅의 피해 수치를 기록해 두는데, 루트 파티 리더부터 어떤 영웅까지 내려가는 경로에 그보다 더 큰 수치를 가진 영웅이 없으면 그 영웅을 **우세하다**고 부릅니다. 루트 리더는 항상 우세한 것으로 칩니다.

파티 트리의 `root`가 주어졌을 때, 우세한 영웅이 몇 명인지 반환하는 `tallyDominantBlocks(root)`를 구현하세요.

**예시 1:**
```
Input: root = [4,2,6,5,1,null,7]
Output: 4
Explanation: Hero 4 (root) is dominant. 5 beats its max ancestor 4. 6 beats its max ancestor 4. 7 beats its max ancestor 6. Hero 2 is overshadowed by 4, and hero 1 is overshadowed by 4.
```

**예시 2:**
```
Input: root = [5,3,5,2,4]
Output: 2
Explanation: The root 5 is dominant. The right child 5 ties with its ancestor 5 and still counts. The left subtree heroes (3, 2, 4) are all overshadowed by the root.
```

**예시 3:**
```
Input: root = [7]
Output: 1
Explanation: A single hero is always dominant.
```$KO$,
    $KO$- 트리의 노드 개수는 `[1, 2 * 10^5]` 범위 안에 있습니다.
- `-10^8 <= Node.val <= 10^8`$KO$
);

-- tally-pick-paths
UPDATE problems SET
    title = $$Tally Pick Paths$$,
    description = $$Your game stores each player's score as a linked list where the **ones digit sits at the head** and more significant digits follow. Two lists represent two scores you'd like to total into one consolidated number.

Return the combined total as a new linked list in the same reverse-digit layout. Neither input has a leading zero (except the single-node list representing `0`).

**Example 1:**
```
Input: score1 = [3,1,7], score2 = [4,8]
Output: [7,9,7]
Explanation: The inputs spell out 713 and 84. Their sum, 797, is written back ones-digit first.
```

**Example 2:**
```
Input: score1 = [9], score2 = [8]
Output: [7,1]
Explanation: 9 + 8 = 17, so the head node stores 7 and a carry node is appended for the tens digit.
```

**Example 3:**
```
Input: score1 = [1,8,6], score2 = [4,5]
Output: [5,3,7]
Explanation: 681 + 54 = 735.
```$$,
    constraints = $$- The number of nodes in each list is in the range `[1, 120]`.
- `0 <= Node.val <= 9`
- Neither list has a leading zero except the single-node list representing `0`.$$
WHERE slug = $$tally-pick-paths$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$tally-pick-paths$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$tally-pick-paths$$),
    'ko',
    $KO$점수 합산 연결 리스트$KO$,
    $KO$이 게임은 각 플레이어의 점수를 연결 리스트로 저장하는데, **일의 자리가 헤드에 오고** 그 뒤로 더 큰 자릿수가 이어집니다. 두 리스트는 합쳐서 하나의 합산 점수로 만들고 싶은 두 수를 나타냅니다.

합산된 값을 같은 "자릿수 뒤집힌" 배치의 새 연결 리스트로 반환하세요. 두 입력 모두 선행 0을 갖지 않습니다(값이 `0`인 한 노드짜리 리스트는 예외).

**예시 1:**
```
Input: score1 = [3,1,7], score2 = [4,8]
Output: [7,9,7]
Explanation: The inputs spell out 713 and 84. Their sum, 797, is written back ones-digit first.
```

**예시 2:**
```
Input: score1 = [9], score2 = [8]
Output: [7,1]
Explanation: 9 + 8 = 17, so the head node stores 7 and a carry node is appended for the tens digit.
```

**예시 3:**
```
Input: score1 = [1,8,6], score2 = [4,5]
Output: [5,3,7]
Explanation: 681 + 54 = 735.
```$KO$,
    $KO$- 각 리스트의 노드 개수는 `[1, 120]` 범위 안에 있습니다.
- `0 <= Node.val <= 9`
- `0`을 나타내는 한 노드짜리 리스트를 제외하면 선행 0은 없습니다.$KO$
);

-- tally-planted-regions
UPDATE problems SET
    title = $$Count Desk Clusters$$,
    description = $$The classroom seating chart is an `m x n` grid `board` where `"1"` means a desk is occupied and `"0"` means it's empty. A **cluster** is a maximal group of occupied desks that touch 4-directionally (up, down, left, right) — diagonals don't count.

Return the number of distinct clusters. Treat the area outside the grid as all empty.

**Example 1:**
```
Input: board = [["0","1","1","0","0","1"],["1","1","0","0","0","1"],["0","0","0","1","0","0"],["1","0","0","1","1","0"],["1","0","0","0","0","1"]]
Output: 5
Explanation: Five 4-connected clusters — the top-left L, the right column pair, the center patch near (2,3), the left pair at (3,0)/(4,0), and the lone desk at (4,5).
```

**Example 2:**
```
Input: board = [["1","1","0","0"],["0","1","0","1"],["0","0","0","1"]]
Output: 2
Explanation: One cluster in the upper-left, and a two-desk column on the right edge.
```$$,
    constraints = $$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 250`
- `board[i][j]` is `'0'` or `'1'`.$$
WHERE slug = $$tally-planted-regions$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$tally-planted-regions$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$tally-planted-regions$$),
    'ko',
    $KO$책상 그룹 세기$KO$,
    $KO$교실 좌석표가 `m x n` 격자 `board`로 주어지고, `"1"`은 책상이 차 있는 칸, `"0"`은 빈 칸입니다. **그룹**은 상하좌우로 맞닿은 책상들의 최대 묶음입니다. 대각선은 세지 않습니다.

서로 다른 그룹의 개수를 반환하세요. 격자 바깥은 전부 빈 칸으로 간주합니다.

**예시 1:**
```
Input: board = [["0","1","1","0","0","1"],["1","1","0","0","0","1"],["0","0","0","1","0","0"],["1","0","0","1","1","0"],["1","0","0","0","0","1"]]
Output: 5
Explanation: Five 4-connected clusters — the top-left L, the right column pair, the center patch near (2,3), the left pair at (3,0)/(4,0), and the lone desk at (4,5).
```

**예시 2:**
```
Input: board = [["1","1","0","0"],["0","1","0","1"],["0","0","0","1"]]
Output: 2
Explanation: One cluster in the upper-left, and a two-desk column on the right edge.
```$KO$,
    $KO$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 250`
- `board[i][j]`는 `'0'` 또는 `'1'`입니다.$KO$
);

-- tally-priority-flags
UPDATE problems SET
    title = $$Tally Priority Flags$$,
    description = $$In a retro game each level `0..upperId` has a completion bitmask, and you want a summary showing how many achievements (set bits) each level awards.

Given a non-negative integer `upperId`, return an array `flagCounts` of length `upperId + 1`, where `flagCounts[i]` is the number of set bits in the binary representation of `i`.

**Example 1:**
```
Input: upperId = 4
Output: [0,1,1,2,1]
Explanation: 0=0b0, 1=0b1, 2=0b10, 3=0b11, 4=0b100.
```

**Example 2:**
```
Input: upperId = 7
Output: [0,1,1,2,1,2,2,3]
Explanation: Binary forms through 7 are 0, 1, 10, 11, 100, 101, 110, 111.
```$$,
    constraints = $$- `0 <= upperId <= 8 * 10^4`$$
WHERE slug = $$tally-priority-flags$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$tally-priority-flags$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$tally-priority-flags$$),
    'ko',
    $KO$비트 플래그 개수 세기$KO$,
    $KO$레트로 게임에서 `0..upperId` 범위의 각 레벨마다 클리어 비트마스크가 붙어 있고, 레벨별로 몇 개의 업적(켜진 비트)을 주는지 한눈에 보고 싶습니다.

음이 아닌 정수 `upperId`가 주어졌을 때, 길이 `upperId + 1`의 배열 `flagCounts`를 반환하세요. 여기서 `flagCounts[i]`는 `i`의 이진 표현에서 켜진 비트의 개수입니다.

**예시 1:**
```
Input: upperId = 4
Output: [0,1,1,2,1]
Explanation: 0=0b0, 1=0b1, 2=0b10, 3=0b11, 4=0b100.
```

**예시 2:**
```
Input: upperId = 7
Output: [0,1,1,2,1,2,2,3]
Explanation: Binary forms through 7 are 0, 1, 10, 11, 100, 101, 110, 111.
```$KO$,
    $KO$- `0 <= upperId <= 8 * 10^4`$KO$
);

-- taxiway-aircraft-layout
UPDATE problems SET
    title = $$Taxiway Aircraft Layout$$,
    description = $$In a strategy game you must place `n` scouts on an `n x n` board (one scout per row) so that no two scouts can see each other. Two scouts conflict if they occupy the same column, the same NW-to-SE diagonal, or the same NE-to-SW diagonal.

Given the board size `n`, return every distinct conflict-free layout. Each layout is a list of `n` strings of length `n`, where `'Q'` marks a scout and `'.'` marks an empty cell. Return an empty list if no layout exists. Layouts may be returned in any order.

**Example 1:**
```
Input: n = 5
Output: [["Q....","..Q..","....Q",".Q...","...Q."],["Q....","...Q.",".Q...","....Q","..Q.."],[".Q...","...Q.","Q....","..Q..","....Q"],[".Q...","....Q","..Q..","Q....","...Q."],["..Q..","Q....","...Q.",".Q...","....Q"],["..Q..","....Q",".Q...","...Q.","Q...."],["...Q.","Q....","..Q..","....Q",".Q..."],["...Q.",".Q...","....Q","..Q..","Q...."],["....Q",".Q...","...Q.","Q....","..Q.."],["....Q","..Q..","Q....","...Q.",".Q..."]]
Explanation: Ten non-conflicting layouts exist on a 5 x 5 board.
```

**Example 2:**
```
Input: n = 3
Output: []
Explanation: No conflict-free layout exists on a 3 x 3 board.
```$$,
    constraints = $$- `1 <= n <= 10`$$
WHERE slug = $$taxiway-aircraft-layout$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$taxiway-aircraft-layout$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$taxiway-aircraft-layout$$),
    'ko',
    $KO$정찰병 배치 문제$KO$,
    $KO$전략 게임에서 `n x n` 보드 위에 `n`명의 정찰병을 서로 시야에 걸리지 않게 배치해야 합니다(한 행에 한 명). 같은 열, 같은 북서-남동 대각선, 같은 북동-남서 대각선 위에 있는 두 정찰병은 서로 시야에 걸리는 것으로 봅니다.

보드 크기 `n`이 주어졌을 때, 시야에 걸리지 않는 서로 다른 모든 배치를 반환하세요. 각 배치는 길이 `n`의 문자열 `n`개로 된 리스트이며, `'Q'`가 정찰병 자리이고 `'.'`가 빈 칸입니다. 가능한 배치가 없으면 빈 리스트를 반환합니다. 배치 순서는 상관없습니다.

**예시 1:**
```
Input: n = 5
Output: [["Q....","..Q..","....Q",".Q...","...Q."],["Q....","...Q.",".Q...","....Q","..Q.."],[".Q...","...Q.","Q....","..Q..","....Q"],[".Q...","....Q","..Q..","Q....","...Q."],["..Q..","Q....","...Q.",".Q...","....Q"],["..Q..","....Q",".Q...","...Q.","Q...."],["...Q.","Q....","..Q..","....Q",".Q..."],["...Q.",".Q...","....Q","..Q..","Q...."],["....Q",".Q...","...Q.","Q....","..Q.."],["....Q","..Q..","Q....","...Q.",".Q..."]]
Explanation: Ten non-conflicting layouts exist on a 5 x 5 board.
```

**예시 2:**
```
Input: n = 3
Output: []
Explanation: No conflict-free layout exists on a 3 x 3 board.
```$KO$,
    $KO$- `1 <= n <= 10`$KO$
);

-- tightest-or-booking
UPDATE problems SET
    title = $$Tightest Table Booking$$,
    description = $$Your cafe's reservation book lists every booked table as `bookings[i] = [start, end]` in inclusive minutes on a shared timeline. For each minute in `probes`, the barista wants to know the length of the **shortest** current booking covering that minute, where a booking's length is `end - start + 1`.

Return an array where the `i`-th entry is that tightest length, or `-1` if no booking covers `probes[i]`.

**Example 1:**
```
Input: bookings = [[2,5],[4,7],[1,9],[6,10]], probes = [3,6,9,11]
Output: [4,4,5,-1]
Explanation: Minute 3 sits in [2,5] (length 4) and [1,9] (length 9); tightest is 4. Minute 11 isn't in any booking.
```

**Example 2:**
```
Input: bookings = [[10,12],[8,20]], probes = [9,11,25]
Output: [13,3,-1]
Explanation: Minute 9 is only inside [8,20] (length 13). Minute 11 is in [10,12] (length 3) and [8,20] (length 13); tightest is 3. Minute 25 isn't covered.
```$$,
    constraints = $$- `1 <= bookings.length <= 2 * 10^5`
- `1 <= probes.length <= 2 * 10^5`
- `1 <= start <= end <= 10^8`
- `1 <= probes[i] <= 10^8`$$
WHERE slug = $$tightest-or-booking$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$tightest-or-booking$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$tightest-or-booking$$),
    'ko',
    $KO$가장 짧은 예약 찾기$KO$,
    $KO$카페의 예약 장부에 모든 테이블 예약이 `bookings[i] = [start, end]` 형태로(분 단위 포함 구간, 공유 타임라인 기준) 적혀 있습니다. `probes`의 각 분에 대해, 바리스타는 그 시각을 덮는 **가장 짧은** 예약의 길이를 알고 싶어합니다. 예약 하나의 길이는 `end - start + 1`입니다.

`i`번째 원소가 그 가장 짧은 길이이고, 어떤 예약도 `probes[i]`를 덮지 않으면 `-1`인 배열을 반환하세요.

**예시 1:**
```
Input: bookings = [[2,5],[4,7],[1,9],[6,10]], probes = [3,6,9,11]
Output: [4,4,5,-1]
Explanation: Minute 3 sits in [2,5] (length 4) and [1,9] (length 9); tightest is 4. Minute 11 isn't in any booking.
```

**예시 2:**
```
Input: bookings = [[10,12],[8,20]], probes = [9,11,25]
Output: [13,3,-1]
Explanation: Minute 9 is only inside [8,20] (length 13). Minute 11 is in [10,12] (length 3) and [8,20] (length 13); tightest is 3. Minute 25 isn't covered.
```$KO$,
    $KO$- `1 <= bookings.length <= 2 * 10^5`
- `1 <= probes.length <= 2 * 10^5`
- `1 <= start <= end <= 10^8`
- `1 <= probes[i] <= 10^8`$KO$
);

-- time-map
UPDATE problems SET
    title = $$Timestamped Value Store$$,
    description = $$Your guild's co-op game autosaves each player's status tag at timestamped checkpoints, and later you want to peek at what someone's tag said at a given moment. Build `TimestampedStore` to stash tagged snapshots and answer as-of queries.

- `TimestampedStore()` — starts an empty store.
- `void write(String key, String value, int timestamp)` — records `value` for `key` at `timestamp`. For any given `key`, timestamps on successive `write` calls are strictly increasing.
- `String readAt(String key, int timestamp)` — returns the latest value stored for `key` with timestamp `<= timestamp`, or `""` if none exists.

If the query lands between two writes, return the one from the most recent earlier write.$$,
    constraints = $$- `1 <= key.length, value.length <= 100`
- `1 <= timestamp <= 10^7`
- Timestamps passed to `write` are strictly increasing per `key`.
- The total number of `write` and `readAt` calls combined is at most `2 * 10^5`.$$
WHERE slug = $$time-map$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$time-map$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$time-map$$),
    'ko',
    $KO$시각 기록 저장소$KO$,
    $KO$길드 공동 플레이 게임은 각 플레이어의 상태 태그를 타임스탬프 체크포인트마다 자동 저장합니다. 나중에 특정 순간에 누가 어떤 태그였는지 들여다볼 수 있도록, 태그 스냅샷을 저장하고 시점 질의에 답하는 `TimestampedStore`를 만들어 주세요.

- `TimestampedStore()` — 빈 저장소로 시작합니다.
- `void write(String key, String value, int timestamp)` — `timestamp` 시각에 `key`의 값으로 `value`를 기록합니다. 같은 `key`에 대한 `write` 호출의 `timestamp`는 반드시 엄격히 증가합니다.
- `String readAt(String key, int timestamp)` — `key`에 대해 `timestamp` 이하 시점에 기록된 값 중 가장 최근 것을 반환하고, 없으면 `""`을 반환합니다.

질의 시점이 두 기록 사이에 놓이면 바로 직전 기록의 값을 돌려줍니다.$KO$,
    $KO$- `1 <= key.length, value.length <= 100`
- `1 <= timestamp <= 10^7`
- 같은 `key`에 대한 `write` 호출의 `timestamp`는 엄격히 증가합니다.
- `write`와 `readAt` 호출은 합쳐서 최대 `2 * 10^5`번 일어납니다.$KO$
);

-- trace-dual-drainage
UPDATE problems SET
    title = $$Trace Dual Drainage$$,
    description = $$Your hamster's sloped playpen is an `m x n` grid where `field[r][c]` is the height of each tile, with a water bowl on the top-left edges (top row or left column) and another on the bottom-right edges (bottom row or right column). Water rolls from a tile to any 4-directional neighbor whose height is **less than or equal to** its own, and edge tiles drip straight into the adjacent bowl.

Return every coordinate `[r, c]` whose water can reach **both** bowls. Order doesn't matter.

**Example 1:**
```
Input: field = [[2,1,3,4,5],[3,2,3,5,6],[4,3,5,4,3],[5,6,4,3,2],[6,5,3,2,1]]
Output: [[0,4],[1,3],[1,4],[2,2],[3,1],[4,0]]
Explanation: Tile (2,2) sits on the ridge — water can step down-left to the top-left bowl and down-right to the bottom-right one.
```

**Example 2:**
```
Input: field = [[2,4,6],[5,7,9],[8,10,12]]
Output: [[0,2],[1,2],[2,0],[2,1],[2,2]]
Explanation: The heights rise monotonically toward the bottom-right, so only the right column and bottom row drain into both bowls.
```$$,
    constraints = $$- `m == field.length`
- `n == field[r].length`
- `1 <= m, n <= 200`
- `0 <= field[r][c] <= 80000`$$
WHERE slug = $$trace-dual-drainage$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$trace-dual-drainage$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$trace-dual-drainage$$),
    'ko',
    $KO$두 물그릇 모두 닿기$KO$,
    $KO$햄스터가 뛰노는 경사진 놀이 공간은 `m x n` 격자이고, `field[r][c]`는 각 칸의 높이예요. 좌상단 테두리(맨 위 행 또는 맨 왼쪽 열)에 물그릇 하나, 우하단 테두리(맨 아래 행 또는 맨 오른쪽 열)에 다른 물그릇이 하나 있습니다. 물은 상하좌우 이웃 중 **높이가 자기 이하인** 칸으로 굴러가고, 테두리 칸의 물은 곧장 옆 그릇으로 떨어집니다.

물이 **두 그릇 모두**에 닿을 수 있는 좌표 `[r, c]`를 전부 반환하세요. 순서는 상관없습니다.

**예시 1:**
```
Input: field = [[2,1,3,4,5],[3,2,3,5,6],[4,3,5,4,3],[5,6,4,3,2],[6,5,3,2,1]]
Output: [[0,4],[1,3],[1,4],[2,2],[3,1],[4,0]]
Explanation: 칸 (2,2)는 능선에 있어, 물이 왼쪽-아래로는 좌상단 그릇에, 오른쪽-아래로는 우하단 그릇에 닿을 수 있습니다.
```

**예시 2:**
```
Input: field = [[2,4,6],[5,7,9],[8,10,12]]
Output: [[0,2],[1,2],[2,0],[2,1],[2,2]]
Explanation: 높이가 우하단 방향으로 단조 증가하므로 오른쪽 열과 아래 행만 두 그릇에 모두 닿습니다.
```$KO$,
    $KO$- `m == field.length`
- `n == field[r].length`
- `1 <= m, n <= 200`
- `0 <= field[r][c] <= 80000`$KO$
);

-- transit-alert-wave
UPDATE problems SET
    title = $$Guild Chat Relay$$,
    description = $$Your online-game guild broadcasts an announcement from one player, and you want to know when the last player in the guild finally sees it. There are `n` players labeled `1` through `n`. You're given `links`, a list of one-way relays where `links[i] = [source, target, minutes]` means a ping fires from player `source` to player `target` after `minutes` minutes; every player retransmits as soon as they first receive it.

Given the starting player `src`, return the **minimum minutes** until every player sees the message, or `-1` if someone can never be reached.

**Example 1:**
```
Input: links = [[1,2,4],[1,3,2],[3,2,1],[2,4,3],[3,4,7]], n = 4, src = 1
Output: 6
Explanation: Player 3 gets it at minute 2, player 2 at minute 3 (via 1 -> 3 -> 2), player 4 at minute 6 (via 1 -> 3 -> 2 -> 4).
```

**Example 2:**
```
Input: links = [[1,2,5]], n = 3, src = 1
Output: -1
Explanation: No relay reaches player 3, so the broadcast never completes.
```$$,
    constraints = $$- `1 <= n <= 120`
- `1 <= links.length <= 6500`
- `links[i].length == 3`
- `1 <= source, target <= n` and `source != target`
- `1 <= minutes <= 120`
- Every `(source, target)` pair is unique$$
WHERE slug = $$transit-alert-wave$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$transit-alert-wave$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$transit-alert-wave$$),
    'ko',
    $KO$길드 공지 전파 시간$KO$,
    $KO$온라인 게임 길드가 한 플레이어로부터 공지를 쏘기 시작합니다. 길드의 마지막 플레이어가 공지를 언제 보는지 알고 싶어요. 플레이어는 `1`부터 `n`까지 번호가 붙어 있고, `links`는 일방향 중계 목록입니다. `links[i] = [source, target, minutes]`는 플레이어 `source`가 `target`에게 `minutes`분 뒤 핑을 쏜다는 뜻이고, 모든 플레이어는 공지를 처음 받은 즉시 재전송합니다.

시작 플레이어 `src`가 주어질 때, 모든 플레이어가 공지를 보는 데 걸리는 **최소 분**을 반환하세요. 누구에게도 닿지 못하는 플레이어가 있으면 `-1`을 반환합니다.

**예시 1:**
```
Input: links = [[1,2,4],[1,3,2],[3,2,1],[2,4,3],[3,4,7]], n = 4, src = 1
Output: 6
Explanation: 3번은 2분, 2번은 3분(1 -> 3 -> 2), 4번은 6분(1 -> 3 -> 2 -> 4)에 공지를 받습니다.
```

**예시 2:**
```
Input: links = [[1,2,5]], n = 3, src = 1
Output: -1
Explanation: 3번에게 닿는 중계가 없으므로 공지가 끝까지 돌지 못합니다.
```$KO$,
    $KO$- `1 <= n <= 120`
- `1 <= links.length <= 6500`
- `links[i].length == 3`
- `1 <= source, target <= n`, `source != target`
- `1 <= minutes <= 120`
- 모든 `(source, target)` 쌍은 유일합니다.$KO$
);

-- tree-codec
UPDATE problems SET
    title = $$Binary Tree Serializer$$,
    description = $$You're saving a skill tree from a video game so a friend can load the exact same build later. The game only lets you send plain text, so you need to pack the tree into a string and unpack it back without losing anything.

Implement the `TreeSerializer` class with two methods:

- `String pack(TreeNode root)` — turns the tree rooted at `root` into a single string. `root` may be `null`, in which case `pack` still returns some well-defined string meaning "empty tree".
- `TreeNode unpack(String data)` — rebuilds the tree from a string produced by `pack`, returning `null` when the string represents an empty tree.

You pick the format, but `unpack(pack(t))` must always give back a tree identical to `t`, and both methods must be stateless.$$,
    constraints = $$- The number of nodes in the tree is in the range `[0, 10000]`.
- `-1000 <= Node.val <= 1000`$$
WHERE slug = $$tree-codec$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$tree-codec$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$tree-codec$$),
    'ko',
    $KO$이진 트리 직렬화$KO$,
    $KO$친구가 똑같은 빌드를 불러올 수 있도록 비디오 게임의 스킬 트리를 저장하려 합니다. 게임은 평문 문자열만 주고받을 수 있어서, 손실 없이 트리를 문자열로 싸고 다시 푸는 작업이 필요해요.

두 메서드를 가진 `TreeSerializer`를 구현하세요.

- `String pack(TreeNode root)` — `root`를 뿌리로 하는 트리를 하나의 문자열로 만듭니다. `root`가 `null`이어도 괜찮으며, 이 경우에도 "빈 트리"를 의미하는 잘 정의된 문자열을 반환해야 합니다.
- `TreeNode unpack(String data)` — `pack`이 만든 문자열에서 트리를 복원합니다. 빈 트리를 나타내는 문자열이면 `null`을 반환합니다.

형식은 자유롭게 고를 수 있지만, `unpack(pack(t))`은 항상 `t`와 동일한 트리를 반환해야 하고, 두 메서드 모두 상태를 가지면 안 됩니다.$KO$,
    $KO$- 트리의 노드 수는 `[0, 10000]` 범위입니다.
- `-1000 <= Node.val <= 1000`$KO$
);

-- trending-feed-topics
UPDATE problems SET
    title = $$Trending Group Chat Topics$$,
    description = $$Your class group chat is nonstop, and you want to surface the `k` topic tags mentioned most in today's messages. On ties, the tag that's earlier alphabetically wins so the ranking stays stable.

Implement `rankTrendingTopics(topics, k)` to return the `k` topic tags with the highest count, sorted by count descending, then label ascending on ties.

**Example 1:**
```
Input: topics = ["climate","climate","market","sports","market","climate","weather"], k = 2
Output: ["climate","market"]
Explanation: "climate" appears 3 times and "market" appears 2 times — the two loudest tags.
```

**Example 2:**
```
Input: topics = ["tech","tech","film","film","music","books","music"], k = 3
Output: ["film","music","tech"]
Explanation: "film", "music", and "tech" all appear twice, so they're returned in alphabetical order.
```$$,
    constraints = $$- `1 <= topics.length <= 2 * 10^3`
- `1 <= topics[i].length <= 10`
- `topics[i]` consists of lowercase English letters
- `k` is in the range `[1, number of distinct topics]`
- The answer is guaranteed to be unique$$
WHERE slug = $$trending-feed-topics$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$trending-feed-topics$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$trending-feed-topics$$),
    'ko',
    $KO$단톡방 유행 주제$KO$,
    $KO$반 단톡방이 쉴 새 없이 울리고, 오늘의 메시지 중 가장 많이 언급된 주제 태그 `k`개를 꺼내 보고 싶습니다. 빈도가 같으면 알파벳이 앞선 태그가 위로 올라와서 순위가 안정적으로 유지됩니다.

빈도 내림차순, 동점 시 라벨 오름차순으로 정렬된 `k`개의 주제 태그를 반환하는 `rankTrendingTopics(topics, k)`를 구현하세요.

**예시 1:**
```
Input: topics = ["climate","climate","market","sports","market","climate","weather"], k = 2
Output: ["climate","market"]
Explanation: "climate"이 3번, "market"이 2번 등장하여 가장 많이 언급된 두 태그입니다.
```

**예시 2:**
```
Input: topics = ["tech","tech","film","film","music","books","music"], k = 3
Output: ["film","music","tech"]
Explanation: "film", "music", "tech" 모두 두 번씩 나와 알파벳 순서로 반환됩니다.
```$KO$,
    $KO$- `1 <= topics.length <= 2 * 10^3`
- `1 <= topics[i].length <= 10`
- `topics[i]`는 영어 소문자로 이루어져 있습니다.
- `k`는 `[1, 서로 다른 주제 수]` 범위입니다.
- 정답은 유일하다고 보장됩니다.$KO$
);

-- triage-zero-priority
UPDATE problems SET
    title = $$Balanced Trio Score$$,
    description = $$A co-op game tracks each player's score delta as a signed integer in `deltas`, where negatives mean they're behind and positives mean they're ahead. You want every unique trio of three distinct players whose deltas add up to exactly zero, so the scoreboard stays balanced.

Return all such trios as `[deltas[i], deltas[j], deltas[k]]`. Each trio appears at most once regardless of how many index picks produce it, and the trios may be returned in any order.

**Example 1:**
```
Input: deltas = [-3,1,2,-2,0,-1,1]
Output: [[-3,1,2],[-2,0,2],[-2,1,1],[-1,0,1]]
Explanation: Four distinct balanced trios exist; each sums to zero.
```

**Example 2:**
```
Input: deltas = [2,3,4]
Output: []
Explanation: Every delta is positive, so no trio sums to zero.
```

**Example 3:**
```
Input: deltas = [0,0,0,0]
Output: [[0,0,0]]
```$$,
    constraints = $$- `3 <= deltas.length <= 2 * 10^3`
- `-10^8 <= deltas[i] <= 10^8`$$
WHERE slug = $$triage-zero-priority$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$triage-zero-priority$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$triage-zero-priority$$),
    'ko',
    $KO$합이 0인 삼인방$KO$,
    $KO$협동 게임이 각 플레이어의 점수 차이를 부호 있는 정수로 `deltas`에 기록합니다. 음수는 뒤처지고 있다는 뜻, 양수는 앞서고 있다는 뜻이에요. 스코어보드가 균형을 유지하도록, 합이 정확히 0이 되는 서로 다른 세 플레이어의 고유 삼인방을 전부 찾고 싶습니다.

조건을 만족하는 삼인방을 `[deltas[i], deltas[j], deltas[k]]` 형태로 전부 반환하세요. 같은 값 조합은 인덱스가 여러 개로 가능해도 한 번만 등장하며, 삼인방들의 순서는 자유입니다.

**예시 1:**
```
Input: deltas = [-3,1,2,-2,0,-1,1]
Output: [[-3,1,2],[-2,0,2],[-2,1,1],[-1,0,1]]
Explanation: 합이 0이 되는 서로 다른 삼인방이 네 개 있습니다.
```

**예시 2:**
```
Input: deltas = [2,3,4]
Output: []
Explanation: 모든 delta가 양수라 합이 0이 되는 삼인방이 없습니다.
```

**예시 3:**
```
Input: deltas = [0,0,0,0]
Output: [[0,0,0]]
```$KO$,
    $KO$- `3 <= deltas.length <= 2 * 10^3`
- `-10^8 <= deltas[i] <= 10^8`$KO$
);

-- unify-crew-contacts
UPDATE problems SET
    title = $$Unify Duplicate Contacts$$,
    description = $$You're cleaning up a shared office contacts list where everyone entered themselves multiple times with different emails. Each entry starts with a name followed by that person's emails, and if two entries share any email they're the same person — though two different people can still share a name.

Implement `unifyContactIdentities(accounts)` to merge entries that share at least one email (transitively). Each returned entry starts with the name, followed by that person's unique emails **sorted lexicographically**. Returned entries can be in any order.

**Example 1:**
```
Input: accounts = [["Maya","maya.dp@set.film","mayalens@set.film"],["Maya","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]
Output: [["Maya","maya.dp@set.film","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]
Explanation: The first two Maya entries share `mayalens@set.film` and collapse into one. The third Maya shares nothing and stays separate.
```

**Example 2:**
```
Input: accounts = [["Ash","ash1@set.film","ash2@set.film"],["Bea","bea1@set.film","bea2@set.film"],["Cal","cal1@set.film","cal2@set.film"]]
Output: [["Ash","ash1@set.film","ash2@set.film"],["Bea","bea1@set.film","bea2@set.film"],["Cal","cal1@set.film","cal2@set.film"]]
Explanation: No shared emails, so every entry stays as-is with its emails sorted.
```$$,
    constraints = $$- `1 <= accounts.length <= 1500`
- `2 <= accounts[i].length <= 10`
- `1 <= accounts[i][j].length <= 30`
- `accounts[i][0]` consists of English letters.
- `accounts[i][j]` for `j > 0` is a valid email address.$$
WHERE slug = $$unify-crew-contacts$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$unify-crew-contacts$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$unify-crew-contacts$$),
    'ko',
    $KO$중복 연락처 합치기$KO$,
    $KO$공용 사무실 연락처 목록을 정리하는 중인데, 다들 이메일을 다르게 써서 본인을 여러 번 등록해 놨습니다. 각 항목은 이름으로 시작해서 그 사람의 이메일들이 뒤따르고, 두 항목이 이메일을 하나라도 공유하면 같은 사람입니다. 다만 서로 다른 두 사람이 같은 이름을 쓰는 경우는 있을 수 있습니다.

`unifyContactIdentities(accounts)`를 구현해서 이메일을 (추이적으로) 하나라도 공유하는 항목들을 합치세요. 반환하는 각 항목은 이름으로 시작하고, 그 뒤에 그 사람의 중복 없는 이메일들이 **사전순으로 정렬돼** 이어집니다. 반환 항목들의 순서는 자유입니다.

**예시 1:**
```
Input: accounts = [["Maya","maya.dp@set.film","mayalens@set.film"],["Maya","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]
Output: [["Maya","maya.dp@set.film","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]
Explanation: The first two Maya entries share `mayalens@set.film` and collapse into one. The third Maya shares nothing and stays separate.
```

**예시 2:**
```
Input: accounts = [["Ash","ash1@set.film","ash2@set.film"],["Bea","bea1@set.film","bea2@set.film"],["Cal","cal1@set.film","cal2@set.film"]]
Output: [["Ash","ash1@set.film","ash2@set.film"],["Bea","bea1@set.film","bea2@set.film"],["Cal","cal1@set.film","cal2@set.film"]]
Explanation: No shared emails, so every entry stays as-is with its emails sorted.
```$KO$,
    $KO$- `1 <= accounts.length <= 1500`
- `2 <= accounts[i].length <= 10`
- `1 <= accounts[i][j].length <= 30`
- `accounts[i][0]`은 영문자로 이뤄져 있습니다.
- `j > 0`일 때 `accounts[i][j]`는 유효한 이메일 주소입니다.$KO$
);

-- unique-topic-window
UPDATE problems SET
    title = $$Unique Topic Window$$,
    description = $$Your Netflix queue is one big string `queue` where each letter is a genre tag, and you want the longest stretch that uses at most `k` different genres so a themed binge stays coherent.

Return the length of the longest contiguous substring of `queue` with at most `k` distinct characters. If `k` is 0, return 0.

**Example 1:**
```
Input: queue = "yyxzxxz", k = 2
Output: 5
Explanation: "xzxxz" only uses x and z and has length 5.
```

**Example 2:**
```
Input: queue = "rrrrrr", k = 1
Output: 6
Explanation: Every tag is the same genre, so the whole string fits inside one distinct tag.
```$$,
    constraints = $$- `1 <= queue.length <= 8 * 10^4`
- `0 <= k <= 50`
- `queue` consists of lowercase English letters.$$
WHERE slug = $$unique-topic-window$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$unique-topic-window$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$unique-topic-window$$),
    'ko',
    $KO$장르 제한 몰아보기 구간$KO$,
    $KO$넷플릭스 시청 대기열이 하나의 긴 문자열 `queue`로 되어 있고 각 글자는 장르 태그인데, 테마를 유지한 몰아보기를 위해 서로 다른 장르가 최대 `k`종류만 섞여 있는 가장 긴 구간을 찾고 싶습니다.

서로 다른 문자가 최대 `k`개 이하인 `queue`의 가장 긴 연속 부분 문자열의 길이를 반환하세요. `k`가 0이면 0을 반환합니다.

**예시 1:**
```
Input: queue = "yyxzxxz", k = 2
Output: 5
Explanation: "xzxxz" only uses x and z and has length 5.
```

**예시 2:**
```
Input: queue = "rrrrrr", k = 1
Output: 6
Explanation: Every tag is the same genre, so the whole string fits inside one distinct tag.
```$KO$,
    $KO$- `1 <= queue.length <= 8 * 10^4`
- `0 <= k <= 50`
- `queue`는 소문자 영어 알파벳으로 이루어져 있습니다.$KO$
);

-- unpaired-frame-reading
UPDATE problems SET
    title = $$Unpaired Frame Reading$$,
    description = $$You dumped a bag of wrapped candies on the table where every flavor shows up twice except one loner you want to find before your friend swipes it.

Given `frames` where every value appears exactly twice except for one that appears once, return that single value. Do it in O(n) time and O(1) extra space.

**Example 1:**
```
Input: frames = [5,5,3]
Output: 3
Explanation: 5 appears twice; 3 only once.
```

**Example 2:**
```
Input: frames = [8,2,6,2,6]
Output: 8
Explanation: 2 and 6 each appear twice. 8 is the loner.
```$$,
    constraints = $$- `1 <= frames.length <= 8 * 10^4`
- `|frames[i]| <= 10^8`
- Every value in `frames` appears exactly twice except one value which appears exactly once.$$
WHERE slug = $$unpaired-frame-reading$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$unpaired-frame-reading$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$unpaired-frame-reading$$),
    'ko',
    $KO$외톨이 사탕 찾기$KO$,
    $KO$포장된 사탕 한 봉지를 식탁에 쏟았더니 모든 맛이 두 개씩 있는데 딱 하나만 외톨이로 남아 있습니다. 친구가 낚아채기 전에 그 하나를 찾아야 합니다.

`frames`가 주어지는데, 모든 값이 정확히 두 번씩 등장하고 딱 하나만 한 번 등장합니다. 그 하나뿐인 값을 반환하세요. O(n) 시간과 O(1) 추가 공간을 써야 합니다.

**예시 1:**
```
Input: frames = [5,5,3]
Output: 3
Explanation: 5 appears twice; 3 only once.
```

**예시 2:**
```
Input: frames = [8,2,6,2,6]
Output: 8
Explanation: 2 and 6 each appear twice. 8 is the loner.
```$KO$,
    $KO$- `1 <= frames.length <= 8 * 10^4`
- `|frames[i]| <= 10^8`
- `frames`의 모든 값은 정확히 두 번씩 등장하지만, 한 값만은 정확히 한 번 등장합니다.$KO$
);

-- unroll-flight-schedule
UPDATE problems SET
    title = $$Unroll Flight Schedule$$,
    description = $$Your coworker stored today's meeting agenda as a binary tree, but the team actually wants it flattened into one long right-pointing chain in **preorder** so they can scroll through it. You must flatten it in place.

Given the `root`, rearrange pointers so every node's `left` is `null` and its `right` points to the next node in preorder. The root stays the same and the return type is `void`; the grader walks right pointers from the root.

**Example 1:**
```
Input: root = [7,3,9,1,4,null,12]
Output: [7,3,1,4,9,12]
Explanation: Preorder of the input is 7, 3, 1, 4, 9, 12. After unrolling, each node links to the next via the right pointer and all left pointers are cleared.
```

**Example 2:**
```
Input: root = []
Output: []
```

**Example 3:**
```
Input: root = [5]
Output: [5]
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[0, 2 * 10^3]`.
- `-10^8 <= Node.val <= 10^8`$$
WHERE slug = $$unroll-flight-schedule$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$unroll-flight-schedule$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$unroll-flight-schedule$$),
    'ko',
    $KO$일정 트리 펼치기$KO$,
    $KO$동료가 오늘 회의 일정을 이진 트리로 저장해 두었는데, 팀은 스크롤로 훑어볼 수 있게 **전위 순회** 순서로 오른쪽만 가리키는 하나의 긴 사슬로 펼쳐달라고 합니다. 펼치기는 제자리에서 이루어져야 합니다.

`root`가 주어졌을 때, 모든 노드의 `left`를 `null`로 바꾸고 `right`가 전위 순회 순서상 다음 노드를 가리키도록 포인터를 재배치하세요. 루트는 그대로이며 반환 타입은 `void`입니다. 채점기는 루트에서부터 오른쪽 포인터를 따라 내려갑니다.

**예시 1:**
```
Input: root = [7,3,9,1,4,null,12]
Output: [7,3,1,4,9,12]
Explanation: Preorder of the input is 7, 3, 1, 4, 9, 12. After unrolling, each node links to the next via the right pointer and all left pointers are cleared.
```

**예시 2:**
```
Input: root = []
Output: []
```

**예시 3:**
```
Input: root = [5]
Output: [5]
```$KO$,
    $KO$- 트리의 노드 수는 `[0, 2 * 10^3]` 범위입니다.
- `-10^8 <= Node.val <= 10^8`$KO$
);

-- validate-part-stream
UPDATE problems SET
    title = $$Validate Homework Code$$,
    description = $$Your CS homework asks you to check student IDs against a tiny pattern language where `.` matches any single character and `*` means zero or more copies of the character right before it. The pattern has to cover the ID end to end, not just a prefix or middle chunk.

Given an ID string `s` and a pattern `p`, return `true` if the pattern matches the whole ID and `false` otherwise.

**Example 1:**
```
Input: s = "bbbc", p = "b*c"
Output: true
Explanation: `b*` consumes the three b's at the start, then `c` matches the trailing c, covering the full ID.
```

**Example 2:**
```
Input: s = "xyzw", p = "x.y"
Output: false
Explanation: The pattern describes only three characters and contains no `*` to stretch, so it cannot cover the four-character ID.
```$$,
    constraints = $$- `1 <= s.length <= 24`
- `1 <= p.length <= 24`
- `s` consists of lowercase English letters
- `p` consists of lowercase English letters, `.`, and `*`
- Every `*` in `p` has a valid preceding character (no leading `*` and no two `*` in a row)$$
WHERE slug = $$validate-part-stream$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$validate-part-stream$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$validate-part-stream$$),
    'ko',
    $KO$과제 ID 검증$KO$,
    $KO$전산 과제로 학생 ID를 작은 패턴 언어로 검사하라는 문제가 나왔습니다. 여기서 `.`은 임의의 문자 하나와 매치되고, `*`는 바로 앞 문자가 0번 이상 반복됨을 의미합니다. 패턴은 ID의 앞부분이나 중간이 아니라 전체를 처음부터 끝까지 덮어야 합니다.

ID 문자열 `s`와 패턴 `p`가 주어졌을 때, 패턴이 ID 전체와 매치되면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: s = "bbbc", p = "b*c"
Output: true
Explanation: `b*` consumes the three b's at the start, then `c` matches the trailing c, covering the full ID.
```

**예시 2:**
```
Input: s = "xyzw", p = "x.y"
Output: false
Explanation: The pattern describes only three characters and contains no `*` to stretch, so it cannot cover the four-character ID.
```$KO$,
    $KO$- `1 <= s.length <= 24`
- `1 <= p.length <= 24`
- `s`는 영어 소문자로 이루어져 있습니다.
- `p`는 영어 소문자와 `.`, `*`로 이루어져 있습니다.
- `p`의 모든 `*` 앞에는 유효한 문자가 하나 있습니다(맨 앞에 `*`가 올 수 없고, `*`가 연달아 두 번 오지도 않습니다).$KO$
);

-- verify-bake-rotation
UPDATE problems SET
    title = $$Verify Bake Rotation$$,
    description = $$Your roommate loaded pizzas into a conveyor oven and the count per slot is in `trays`; you want later slots to never hold fewer pizzas than earlier ones so the ticket looks neat.

Given `trays`, return `true` if you can make the sequence non-decreasing by adjusting **at most one** slot to any integer, and `false` otherwise.

**Example 1:**
```
Input: trays = [3,1,4,5]
Output: true
Explanation: Lowering the first slot to 1 gives [1,1,4,5], which is non-decreasing.
```

**Example 2:**
```
Input: trays = [6,4,2,3]
Output: false
Explanation: Two separate slots are out of order, so one tweak can't fix it.
```$$,
    constraints = $$- `1 <= trays.length <= 2 * 10^5`
- `-10^8 <= trays[i] <= 10^8`$$
WHERE slug = $$verify-bake-rotation$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$verify-bake-rotation$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$verify-bake-rotation$$),
    'ko',
    $KO$피자 트레이 정렬 확인하기$KO$,
    $KO$룸메이트가 컨베이어 오븐에 피자를 올려놨는데, 슬롯별 피자 개수가 `trays`에 들어 있습니다. 주문표가 깔끔해 보이도록 뒤쪽 슬롯이 앞쪽 슬롯보다 피자 개수가 적지 않게 만들고 싶습니다.

`trays`가 주어졌을 때 **슬롯을 최대 하나만** 임의의 정수로 조정해서 수열을 비내림차순으로 만들 수 있으면 `true`를, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: trays = [3,1,4,5]
Output: true
Explanation: Lowering the first slot to 1 gives [1,1,4,5], which is non-decreasing.
```

**예시 2:**
```
Input: trays = [6,4,2,3]
Output: false
Explanation: Two separate slots are out of order, so one tweak can't fix it.
```$KO$,
    $KO$- `1 <= trays.length <= 2 * 10^5`
- `-10^8 <= trays[i] <= 10^8`$KO$
);

-- verify-job-nesting
UPDATE problems SET
    title = $$Verify Bracket Nesting$$,
    description = $$A coworker left a stack of sticky notes with only the brackets `(`, `)`, `[`, `]`, `{`, `}` on them as a string `tape`, and you want to check whether the run of brackets actually nests properly. Every opener must be closed by the matching type and outer brackets can't close before their inner ones.

Given the string `tape` containing only those six marker characters, return `true` if the sequence is a valid nesting, and `false` otherwise.

**Example 1:**
```
Input: tape = "{[()]}"
Output: true
Explanation: Each opener is closed by the matching type in the correct nested order.
```

**Example 2:**
```
Input: tape = "{[(])}"
Output: false
Explanation: The `(` is closed by `]` before its matching `)`, breaking the nesting.
```$$,
    constraints = $$- `1 <= tape.length <= 2 * 10^3`
- `tape` consists only of the characters `'('`, `')'`, `'['`, `']'`, `'{'`, and `'}'`.$$
WHERE slug = $$verify-job-nesting$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$verify-job-nesting$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$verify-job-nesting$$),
    'ko',
    $KO$괄호 중첩 검사하기$KO$,
    $KO$동료가 `(`, `)`, `[`, `]`, `{`, `}` 괄호만 적힌 포스트잇을 쌓아 두고 문자열 `tape`으로 남겼는데, 이 괄호들이 제대로 중첩되는지 확인하고 싶습니다. 모든 여는 괄호는 같은 종류의 닫는 괄호로 닫혀야 하고, 바깥쪽 괄호가 안쪽 괄호보다 먼저 닫히면 안 됩니다.

여섯 가지 기호만으로 이루어진 문자열 `tape`이 주어질 때, 올바르게 중첩되어 있으면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: tape = "{[()]}"
Output: true
Explanation: Each opener is closed by the matching type in the correct nested order.
```

**예시 2:**
```
Input: tape = "{[(])}"
Output: false
Explanation: The `(` is closed by `]` before its matching `)`, breaking the nesting.
```$KO$,
    $KO$- `1 <= tape.length <= 2 * 10^3`
- `tape`은 문자 `'('`, `')'`, `'['`, `']'`, `'{'`, `'}'`로만 이루어져 있습니다.$KO$
);

-- verify-mirror-callnumber
UPDATE problems SET
    title = $$Verify Mirror Phrase$$,
    description = $$Your friend is printing bumper-sticker slogans and wants a quick checker that a slogan `phrase` reads the same forwards and backwards once you ignore casing and any non-alphanumeric junk like spaces or punctuation.

Given `phrase`, lowercase all letters, strip every non-alphanumeric character, and return `true` if what's left reads the same forwards and backwards. An empty string counts as a mirror.

**Example 1:**
```
Input: phrase = "Stacks: Level 2 level stack S"
Output: true
Explanation: After filtering, the phrase becomes "stackslevel2levelstacks", which mirrors itself.
```

**Example 2:**
```
Input: phrase = "Shelf 7A not mirrored"
Output: false
Explanation: After filtering the phrase becomes "shelf7anotmirrored", which is not a mirror.
```

**Example 3:**
```
Input: phrase = ",,,"
Output: true
Explanation: After removing non-alphanumeric characters the phrase is empty, which counts as a mirror.
```$$,
    constraints = $$- `1 <= phrase.length <= 2 * 10^5`
- `phrase` consists only of printable characters between 32 and 126.$$
WHERE slug = $$verify-mirror-callnumber$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$verify-mirror-callnumber$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$verify-mirror-callnumber$$),
    'ko',
    $KO$거울 문구 검사하기$KO$,
    $KO$친구가 범퍼 스티커 슬로건을 인쇄하려고 하는데, 대소문자와 공백·문장부호 같은 알파벳·숫자가 아닌 문자들을 모두 무시했을 때 문구 `phrase`가 앞뒤 어느 쪽으로 읽어도 똑같은지 빠르게 확인해 주는 검사기를 원합니다.

`phrase`가 주어지면 알파벳을 전부 소문자로 만들고, 알파벳·숫자가 아닌 문자는 모두 제거한 뒤, 남은 문자열이 앞뒤로 똑같이 읽히면 `true`를 반환하세요. 빈 문자열도 거울 문구로 칩니다.

**예시 1:**
```
Input: phrase = "Stacks: Level 2 level stack S"
Output: true
Explanation: After filtering, the phrase becomes "stackslevel2levelstacks", which mirrors itself.
```

**예시 2:**
```
Input: phrase = "Shelf 7A not mirrored"
Output: false
Explanation: After filtering the phrase becomes "shelf7anotmirrored", which is not a mirror.
```

**예시 3:**
```
Input: phrase = ",,,"
Output: true
Explanation: After removing non-alphanumeric characters the phrase is empty, which counts as a mirror.
```$KO$,
    $KO$- `1 <= phrase.length <= 2 * 10^5`
- `phrase`는 32~126 범위의 출력 가능한 문자들로만 이루어져 있습니다.$KO$
);

-- verify-shoot-plan
UPDATE problems SET
    title = $$Verify Group Project Plan$$,
    description = $$You and your classmates have `numScenes` group-project tasks numbered `0` to `numScenes - 1`, and some tasks have to wait on others — each `prereqs[i] = [a, b]` means task `b` has to be done before task `a` starts.

Return `true` if some ordering finishes every task, or `false` if the dependencies form a loop that can never be unwound.

**Example 1:**
```
Input: numScenes = 4, prereqs = [[1,0],[2,0],[3,1]]
Output: true
Explanation: Task `0` can go first, then `1` and `2` (which both only need `0`), and finally `3`. No circular dependency exists.
```

**Example 2:**
```
Input: numScenes = 3, prereqs = [[0,2],[2,1],[1,0]]
Output: false
Explanation: Task `0` needs `2`, `2` needs `1`, and `1` needs `0`. The three-way loop means no task can ever start first.
```$$,
    constraints = $$- `1 <= numScenes <= 2000`
- `0 <= prereqs.length <= 5000`
- `prereqs[i].length == 2`
- `0 <= a, b < numScenes`
- All pairs `prereqs[i]` are distinct.$$
WHERE slug = $$verify-shoot-plan$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$verify-shoot-plan$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$verify-shoot-plan$$),
    'ko',
    $KO$조별 과제 계획 검증$KO$,
    $KO$반 친구들과 함께 `0`부터 `numScenes - 1`까지 번호가 매겨진 `numScenes`개의 조별 과제를 진행하는데, 어떤 과제는 다른 과제가 끝나야 시작할 수 있습니다. `prereqs[i] = [a, b]`는 과제 `b`가 끝나야 과제 `a`를 시작할 수 있다는 뜻입니다.

모든 과제를 마칠 수 있는 순서가 존재하면 `true`, 의존 관계가 절대 풀 수 없는 순환을 이루면 `false`를 반환하세요.

**예시 1:**
```
Input: numScenes = 4, prereqs = [[1,0],[2,0],[3,1]]
Output: true
Explanation: Task `0` can go first, then `1` and `2` (which both only need `0`), and finally `3`. No circular dependency exists.
```

**예시 2:**
```
Input: numScenes = 3, prereqs = [[0,2],[2,1],[1,0]]
Output: false
Explanation: Task `0` needs `2`, `2` needs `1`, and `1` needs `0`. The three-way loop means no task can ever start first.
```$KO$,
    $KO$- `1 <= numScenes <= 2000`
- `0 <= prereqs.length <= 5000`
- `prereqs[i].length == 2`
- `0 <= a, b < numScenes`
- 모든 `prereqs[i]` 쌍은 서로 다릅니다.$KO$
);

-- verify-table-bookings
UPDATE problems SET
    title = $$Verify Table Bookings$$,
    description = $$A cafe keeps one cozy window table and logs every reservation for it in `bookings` as `[start, end]` minutes after opening. The host wants to know if the single table can handle every booking without two parties sitting at it at the same time — a booking that ends exactly when the next one starts is fine.

Return `true` if no two entries of `bookings` overlap (open-interval sense), and `false` otherwise.

**Example 1:**
```
Input: bookings = [[18,20],[19,21],[22,23]]
Output: false
Explanation: [18,20] and [19,21] both cover minute 19, so two parties collide.
```

**Example 2:**
```
Input: bookings = [[18,20],[20,22],[22,23]]
Output: true
Explanation: Each booking ends right when the next starts, so the table turns cleanly.
```

**Example 3:**
```
Input: bookings = [[45,90],[30,60]]
Output: false
```$$,
    constraints = $$- `0 <= bookings.length <= 8000`
- `bookings[i].length == 2`
- `0 <= start < end <= 2 * 10^5`$$
WHERE slug = $$verify-table-bookings$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$verify-table-bookings$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$verify-table-bookings$$),
    'ko',
    $KO$테이블 예약 충돌 검사$KO$,
    $KO$한 카페에 아늑한 창가 테이블이 하나 있고, 그 테이블의 모든 예약을 `bookings`에 `[start, end]`로 기록해 둡니다(영업 시작 이후 분 단위). 호스트는 단 하나의 테이블로 두 팀이 동시에 앉는 일 없이 모든 예약을 처리할 수 있는지 알고 싶어합니다. 한 예약이 끝나는 바로 그 시각에 다음 예약이 시작되는 건 괜찮습니다.

`bookings`의 어떤 두 예약도 열린 구간 기준으로 겹치지 않으면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: bookings = [[18,20],[19,21],[22,23]]
Output: false
Explanation: [18,20] and [19,21] both cover minute 19, so two parties collide.
```

**예시 2:**
```
Input: bookings = [[18,20],[20,22],[22,23]]
Output: true
Explanation: Each booking ends right when the next starts, so the table turns cleanly.
```

**예시 3:**
```
Input: bookings = [[45,90],[30,60]]
Output: false
```$KO$,
    $KO$- `0 <= bookings.length <= 8000`
- `bookings[i].length == 2`
- `0 <= start < end <= 2 * 10^5`$KO$
);

-- void-empty-scans
UPDATE problems SET
    title = $$Void Empty Orders$$,
    description = $$The cafe's point-of-sale keeps a list `scans` of each order's price in the order it was rung up, with voided orders stored as `0`. To tidy the end-of-day receipt, you want every `0` slid to the tail while the real prices keep their original order.

Mutate `scans` **in place** — don't allocate a new array. The driver will print the array after your method returns.

**Example 1:**
```
Input: scans = [4,0,0,2,9,0,7]
Output: [4,2,9,7,0,0,0]
Explanation: The four real prices keep their order, and the three voids slide to the end.
```

**Example 2:**
```
Input: scans = [0,0,5]
Output: [5,0,0]
```$$,
    constraints = $$- `1 <= scans.length <= 2 * 10^5`
- `|scans[i]| <= 10^8`$$
WHERE slug = $$void-empty-scans$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$void-empty-scans$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$void-empty-scans$$),
    'ko',
    $KO$취소 주문 뒤로 밀기$KO$,
    $KO$카페 포스기는 주문들을 결제된 순서대로 `scans`에 가격 리스트로 저장하는데, 취소된 주문은 `0`으로 저장됩니다. 마감 영수증을 깔끔하게 하려고 모든 `0`을 뒤로 밀되, 실제 가격들은 원래 순서를 그대로 유지하게 하고 싶습니다.

`scans`를 **제자리에서** 변경하세요. 새 배열을 만들지 마세요. 드라이버가 메서드가 반환된 뒤 배열을 출력합니다.

**예시 1:**
```
Input: scans = [4,0,0,2,9,0,7]
Output: [4,2,9,7,0,0,0]
Explanation: The four real prices keep their order, and the three voids slide to the end.
```

**예시 2:**
```
Input: scans = [0,0,5]
Output: [5,0,0]
```$KO$,
    $KO$- `1 <= scans.length <= 2 * 10^5`
- `|scans[i]| <= 10^8`$KO$
);

-- voucher-price-combos
UPDATE problems SET
    title = $$Voucher Price Combos$$,
    description = $$Your favorite cafe is running a voucher promo: pick any combination of items from the menu whose prices total exactly the voucher amount. The menu has `prices` (a list of distinct positive integer prices), and each item can be ordered any number of times.

Return every unique basket whose prices sum to `voucher`. Each basket is a list of prices (repeats allowed), and two baskets differ if at least one price has a different count. Return the baskets in any order.

**Example 1:**
```
Input: prices = [2,4,5], voucher = 9
Output: [[2,2,5],[4,5]]
Explanation: 2 + 2 + 5 = 9 and 4 + 5 = 9 are the only two matching baskets.
```

**Example 2:**
```
Input: prices = [3,4,7], voucher = 10
Output: [[3,3,4],[3,7]]
```$$,
    constraints = $$- `1 <= prices.length <= 30`
- `2 <= prices[i] <= 40`
- All elements of `prices` are distinct.
- `1 <= voucher <= 40`$$
WHERE slug = $$voucher-price-combos$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$voucher-price-combos$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$voucher-price-combos$$),
    'ko',
    $KO$쿠폰 가격 조합$KO$,
    $KO$단골 카페에서 쿠폰 프로모션을 하고 있어서, 메뉴에서 가격 합이 쿠폰 금액과 정확히 같은 아무 조합이나 고를 수 있습니다. 메뉴에는 `prices`(서로 다른 양의 정수 가격들의 목록)가 있고, 각 항목은 몇 번이든 주문할 수 있습니다.

가격 합이 `voucher`가 되는 모든 서로 다른 장바구니를 반환하세요. 각 장바구니는 가격들의 리스트이고(중복 허용), 적어도 한 가격의 개수가 다르면 두 장바구니는 서로 다른 것으로 봅니다. 장바구니 순서는 상관없습니다.

**예시 1:**
```
Input: prices = [2,4,5], voucher = 9
Output: [[2,2,5],[4,5]]
Explanation: 2 + 2 + 5 = 9 and 4 + 5 = 9 are the only two matching baskets.
```

**예시 2:**
```
Input: prices = [3,4,7], voucher = 10
Output: [[3,3,4],[3,7]]
```$KO$,
    $KO$- `1 <= prices.length <= 30`
- `2 <= prices[i] <= 40`
- `prices`의 모든 원소는 서로 다릅니다.
- `1 <= voucher <= 40`$KO$
);

-- ward-priority-audit
UPDATE problems SET
    title = $$Check the Score Tree$$,
    description = $$Your arcade stores player scores in a binary tree where every left subtree is **strictly lower** than its parent and every right subtree is **strictly higher**. You suspect a recent shuffle broke the ordering and want to double-check.

Given the `root` of the score tree, implement `verifyWardOrder(root)` to return `true` if every node obeys the BST rule across its full left and right subtrees (not just its immediate children), or `false` otherwise. All scores are distinct.

**Example 1:**
```
Input: root = [50,30,70,20,40,60,80]
Output: true
Explanation: Every left subtree stays below its ancestor and every right subtree stays above.
```

**Example 2:**
```
Input: root = [10,5,15,null,null,6,20]
Output: false
Explanation: 6 lives in the right subtree of root 10, but 6 < 10, so the rule breaks.
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[1, 2 * 10^5]`.
- `-10^8 <= Node.val <= 10^8`
- All scores are distinct.$$
WHERE slug = $$ward-priority-audit$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$ward-priority-audit$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$ward-priority-audit$$),
    'ko',
    $KO$점수 트리 검사$KO$,
    $KO$오락실 점수 트리는 왼쪽 서브트리가 부모보다 **엄격히 작고**, 오른쪽 서브트리가 부모보다 **엄격히 큰** 이진 트리로 저장됩니다. 최근 재정렬 때 순서가 깨진 것 같아서 다시 확인하고 싶습니다.

점수 트리의 `root`가 주어졌을 때, 모든 노드가 (단지 직계 자식뿐 아니라) 왼쪽·오른쪽 서브트리 전체에 걸쳐 BST 규칙을 지키면 `true`, 아니면 `false`를 반환하는 `verifyWardOrder(root)`를 구현하세요. 모든 점수는 서로 다릅니다.

**예시 1:**
```
Input: root = [50,30,70,20,40,60,80]
Output: true
Explanation: Every left subtree stays below its ancestor and every right subtree stays above.
```

**예시 2:**
```
Input: root = [10,5,15,null,null,6,20]
Output: false
Explanation: 6 lives in the right subtree of root 10, but 6 < 10, so the rule breaks.
```$KO$,
    $KO$- 트리의 노드 개수는 `[1, 2 * 10^5]` 범위 안에 있습니다.
- `-10^8 <= Node.val <= 10^8`
- 모든 점수는 서로 다릅니다.$KO$
);

-- widest-catalog-span
UPDATE problems SET
    title = $$Widest Catalog Span$$,
    description = $$Your school's folder structure is laid out as a tree rooted at `root`, and you want the longest chain of clicks between any two files. The chain may pivot at an interior folder or run straight down a single branch, whichever is longer.

Return that span, measured as the number of **edges** on the longest path between any two nodes. The path is not required to pass through `root`.

**Example 1:**
```
Input: root = [7,3,8,1,4,null,9]
Output: 4
Explanation: The walk 1 -> 3 -> 7 -> 8 -> 9 uses 4 edges, which is the widest span.
```

**Example 2:**
```
Input: root = [2,null,5,3]
Output: 2
Explanation: The walk 2 -> 5 -> 3 crosses two edges.
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[1, 8000]`.
- `-100 <= Node.val <= 100`$$
WHERE slug = $$widest-catalog-span$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$widest-catalog-span$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$widest-catalog-span$$),
    'ko',
    $KO$가장 긴 폴더 경로$KO$,
    $KO$학교의 폴더 구조가 `root`를 뿌리로 하는 트리로 되어 있고, 두 파일 사이 클릭이 가장 많이 필요한 경로의 길이를 알고 싶습니다. 경로는 내부 폴더에서 꺾일 수도 있고, 한 가지를 따라 곧장 내려갈 수도 있는데, 둘 중 긴 쪽이 답입니다.

아무 두 노드 사이의 가장 긴 경로에 있는 **간선 수**로 측정한 폭을 반환하세요. 경로가 반드시 `root`를 지나야 하는 건 아닙니다.

**예시 1:**
```
Input: root = [7,3,8,1,4,null,9]
Output: 4
Explanation: The walk 1 -> 3 -> 7 -> 8 -> 9 uses 4 edges, which is the widest span.
```

**예시 2:**
```
Input: root = [2,null,5,3]
Output: 2
Explanation: The walk 2 -> 5 -> 3 crosses two edges.
```$KO$,
    $KO$- 트리의 노드 개수는 `[1, 8000]` 범위 안에 있습니다.
- `-100 <= Node.val <= 100`$KO$
);

-- widest-vine-block
UPDATE problems SET
    title = $$Widest Vine Block$$,
    description = $$You're decorating your locker row with a single rectangular banner. The array `lockers` lists each locker's height, and the banner must sit flush across a contiguous run of lockers without rising above any of them — its height is capped by the shortest locker in the run.

Return the largest area (height times number of lockers) the banner can cover.

**Example 1:**
```
Input: lockers = [3,1,4,5,2,3]
Output: 8
Explanation: The banner covering lockers 2 and 3 uses height 4 and width 2 for area 8.
```

**Example 2:**
```
Input: lockers = [4,2,6,3,7,5,3]
Output: 15
Explanation: The banner covering indices 2 through 6 uses height 3 and width 5 for area 15.
```$$,
    constraints = $$- `1 <= lockers.length <= 2 * 10^5`
- `0 <= lockers[i] <= 2 * 10^3`$$
WHERE slug = $$widest-vine-block$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$widest-vine-block$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$widest-vine-block$$),
    'ko',
    $KO$가장 큰 배너 붙이기$KO$,
    $KO$사물함 줄 위에 직사각형 배너 하나를 걸려고 합니다. 배열 `lockers`는 각 사물함 높이를 담고 있고, 배너는 연속된 사물함들 위에 평평하게 얹혀야 하므로 그 구간의 가장 낮은 사물함 높이까지만 올라갈 수 있어요.

배너가 덮을 수 있는 최대 넓이(높이 × 사물함 수)를 반환하세요.

**예시 1:**
```
Input: lockers = [3,1,4,5,2,3]
Output: 8
Explanation: 인덱스 2와 3 두 사물함을 덮는 배너는 높이 4, 너비 2로 넓이 8입니다.
```

**예시 2:**
```
Input: lockers = [4,2,6,3,7,5,3]
Output: 15
Explanation: 인덱스 2부터 6까지 덮는 배너는 높이 3, 너비 5로 넓이 15입니다.
```$KO$,
    $KO$- `1 <= lockers.length <= 2 * 10^5`
- `0 <= lockers[i] <= 2 * 10^3`$KO$
);

-- wire-zone-peers
UPDATE problems SET
    title = $$Wire Zone Peers$$,
    description = $$Your co-op game's guild chart is a **perfect binary tree**: every non-leaf member has exactly two recruits, and every leaf sits at the same tier. Each member has a `next` pointer you want to wire so same-tier gossip can ripple without bouncing through the guildmaster.

```
class Node {
    int val;
    Node left;
    Node right;
    Node next;
}
```

Implement `wireSiblingHubs` so each member's `next` points to the member immediately to its right on the same tier, or stays `null` if it's the rightmost on that tier. Return the updated `root`.

**Example 1:**
```
Input: root = [10,20,30,40,50,60,70]
Output: [10,#,20,30,#,40,50,60,70,#]
Explanation: Three tiers in the tree.
- Tier 0: 10 -> null
- Tier 1: 20 -> 30 -> null
- Tier 2: 40 -> 50 -> 60 -> 70 -> null
The # marks the end of each tier's chain.
```

**Example 2:**
```
Input: root = [9]
Output: [9,#]
Explanation: A lone member has no right neighbor.
```

**Example 3:**
```
Input: root = [5,6,7]
Output: [5,#,6,7,#]
```$$,
    constraints = $$- The number of members in the tree is in the range `[1, 4096]`.
- `-1000 <= Node.val <= 1000`
- The tree is guaranteed to be a perfect binary tree.$$
WHERE slug = $$wire-zone-peers$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$wire-zone-peers$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$wire-zone-peers$$),
    'ko',
    $KO$같은 층 친구 연결$KO$,
    $KO$협동 게임의 길드 차트는 **완전 이진 트리**입니다. 잎이 아닌 모든 멤버에게는 부하 두 명이 있고, 모든 잎은 같은 층(tier)에 있어요. 각 멤버에는 `next` 포인터가 있는데, 같은 층끼리의 소문이 길드마스터를 거치지 않고 옆으로 쭉 퍼질 수 있도록 이걸 연결하려 합니다.

```
class Node {
    int val;
    Node left;
    Node right;
    Node next;
}
```

각 멤버의 `next`가 같은 층의 바로 오른쪽 멤버를 가리키도록 `wireSiblingHubs`를 구현하세요. 해당 층의 가장 오른쪽 멤버는 `next`를 `null`로 둡니다. 갱신된 `root`를 반환하세요.

**예시 1:**
```
Input: root = [10,20,30,40,50,60,70]
Output: [10,#,20,30,#,40,50,60,70,#]
Explanation: 트리에 3개 층이 있습니다.
- 층 0: 10 -> null
- 층 1: 20 -> 30 -> null
- 층 2: 40 -> 50 -> 60 -> 70 -> null
#은 각 층 체인의 끝을 표시합니다.
```

**예시 2:**
```
Input: root = [9]
Output: [9,#]
Explanation: 혼자뿐이라 오른쪽 이웃이 없습니다.
```

**예시 3:**
```
Input: root = [5,6,7]
Output: [5,#,6,7,#]
```$KO$,
    $KO$- 트리에 있는 멤버 수는 `[1, 4096]` 범위입니다.
- `-1000 <= Node.val <= 1000`
- 트리는 완전 이진 트리라고 보장됩니다.$KO$
);

-- word-dictionary
UPDATE problems SET
    title = $$Wildcard Lexicon$$,
    description = $$You're building the cheat-word checker for a word-tile game, where players save favorite words and later test guesses with `.` as a blank tile. A guess passes if some saved word has the same length and matches position-by-position, with `.` standing in for any single letter.

Implement the `WildcardLexicon` class:

- `WildcardLexicon()` starts the checker with no saved words.
- `void enroll(String word)` saves `word` (lowercase letters only). Re-saving the same word is fine.
- `boolean match(String word)` returns `true` if any saved word matches `word` under the wildcard rule, and `false` otherwise (including when nothing is saved).

The `match` input may mix lowercase letters and `.`; `enroll` never contains `.`. Calls to the two methods can interleave in any order, and `match` never changes the saved set.$$,
    constraints = $$- `1 <= word.length <= 25`
- `word` in `enroll` consists of lowercase English letters only.
- `word` in `match` consists of lowercase English letters and/or the wildcard character `.`.
- At most `8000` calls will be made to `enroll` and `match` combined.$$
WHERE slug = $$word-dictionary$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$word-dictionary$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$word-dictionary$$),
    'ko',
    $KO$와일드카드 단어 사전$KO$,
    $KO$단어 타일 게임의 치트 단어 검사기를 만드는 중입니다. 플레이어가 즐겨 쓰는 단어를 저장해 두고, 나중에 추측할 때 `.`을 빈 타일로 써서 일치하는지 확인해요. 저장된 단어 중 하나가 길이가 같고, `.`이 어느 글자와도 매칭된다는 규칙 아래 자리마다 맞아떨어지면 추측이 통과입니다.

`WildcardLexicon` 클래스를 구현하세요.

- `WildcardLexicon()` — 저장된 단어가 없는 상태로 검사기를 시작합니다.
- `void enroll(String word)` — `word`를 저장합니다(영어 소문자만). 같은 단어를 또 저장해도 문제없습니다.
- `boolean match(String word)` — 와일드카드 규칙 아래 저장된 단어 중 하나라도 `word`와 매칭되면 `true`, 아니면 `false`(저장된 게 아무것도 없을 때 포함)를 반환합니다.

`match`의 입력에는 영어 소문자와 `.`이 섞일 수 있고, `enroll`에는 `.`이 들어오지 않습니다. 두 메서드 호출은 어떤 순서로든 섞여 들어올 수 있으며, `match`는 저장된 집합을 바꾸지 않습니다.$KO$,
    $KO$- `1 <= word.length <= 25`
- `enroll`의 `word`는 영어 소문자로만 이루어져 있습니다.
- `match`의 `word`는 영어 소문자와 와일드카드 `.`의 조합입니다.
- `enroll`과 `match`는 합쳐서 최대 `8000`번 호출됩니다.$KO$
);

-- zone-code-anagram
UPDATE problems SET
    title = $$Zone Code Anagram$$,
    description = $$You're skimming a classmate's long note `log` to see if the letters of your crush's name `pattern` happen to sit together anywhere inside it. Return `true` if any permutation of `pattern` appears as a contiguous substring of `log`, and `false` otherwise.

**Example 1:**
```
Input: pattern = "ab", log = "ccbazz"
Output: true
Explanation: The substring "ba" inside log is a reordering of pattern.
```

**Example 2:**
```
Input: pattern = "rp", log = "mailpirzone"
Output: false
Explanation: No length-two substring of log uses one 'r' and one 'p'.
```$$,
    constraints = $$- `1 <= pattern.length, log.length <= 8000`
- `pattern` and `log` consist of lowercase English letters.$$
WHERE slug = $$zone-code-anagram$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$zone-code-anagram$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$zone-code-anagram$$),
    'ko',
    $KO$애너그램 부분 문자열$KO$,
    $KO$짝사랑하는 친구의 이름 `pattern`의 글자들이 반 친구의 긴 노트 `log` 어딘가에 몰려 앉아 있는지 훑어보려 합니다. `pattern`의 어떤 순열이든 `log`의 연속 부분 문자열로 등장하면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: pattern = "ab", log = "ccbazz"
Output: true
Explanation: log 안의 "ba"는 pattern의 글자들을 재배열한 것입니다.
```

**예시 2:**
```
Input: pattern = "rp", log = "mailpirzone"
Output: false
Explanation: 길이 2짜리 log의 부분 문자열 중 'r' 하나와 'p' 하나로 이루어진 것이 없습니다.
```$KO$,
    $KO$- `1 <= pattern.length, log.length <= 8000`
- `pattern`과 `log`는 영어 소문자로 이루어져 있습니다.$KO$
);

-- zone-letter-trail
UPDATE problems SET
    title = $$Word Hunt On The Board$$,
    description = $$You're playing a word-hunt mobile game on an `m x n` letter board. You trace words by stepping between orthogonally adjacent cells (up, down, left, right), never reusing a cell in the same trace.

Given the letter board `board` and a target `word`, implement `traceZonePath` to return `true` if some path of adjacent cells spells `word` exactly, using each cell at most once. Otherwise return `false`.

**Example 1:**
```
Input: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "PEAK"
Output: true
```

**Example 2:**
```
Input: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "NOID"
Output: true
```

**Example 3:**
```
Input: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "PARK"
Output: false
```$$,
    constraints = $$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 8`
- `1 <= word.length <= 20`
- `board` and `word` consist of only uppercase and lowercase English letters.$$
WHERE slug = $$zone-letter-trail$$;

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$zone-letter-trail$$);

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = $$zone-letter-trail$$),
    'ko',
    $KO$보드 위 단어 탐색$KO$,
    $KO$`m x n` 글자판 위에서 단어 찾기 모바일 게임을 하고 있습니다. 상하좌우로 인접한 칸 사이를 이동하며 단어를 그리고, 같은 추적 안에서 같은 칸을 두 번 쓰지 않습니다.

글자판 `board`와 목표 단어 `word`가 주어질 때, 각 칸을 많아야 한 번만 쓰는 인접한 칸들의 경로로 정확히 `word`를 만들 수 있으면 `true`, 아니면 `false`를 반환하는 `traceZonePath`를 구현하세요.

**예시 1:**
```
Input: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "PEAK"
Output: true
```

**예시 2:**
```
Input: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "NOID"
Output: true
```

**예시 3:**
```
Input: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "PARK"
Output: false
```$KO$,
    $KO$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 8`
- `1 <= word.length <= 20`
- `board`와 `word`는 영어 대/소문자로만 이루어져 있습니다.$KO$
);

