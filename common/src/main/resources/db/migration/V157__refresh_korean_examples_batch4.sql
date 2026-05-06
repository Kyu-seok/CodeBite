-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 4 (problems #31-#40)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose
-- sentence inside the block is Korean. Variable names (root, p, q, nums,
-- prices, voucher, stops, board, adjList, prereqs, numScenes, n) stay
-- verbatim. First mention of each variable in Korean prose is paired with
-- a Korean noun phrase describing its type or role. Constraints are
-- aligned with the canonical English parameter names from V135/V152.

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'binary-tree-level-order', 'valid-score-bst', 'lca-bst', 'subsets-ii',
      'voucher-price-combos', 'cafe-stop-orders', 'count-desk-clusters',
      'snapshot-town-map', 'verify-task-order', 'count-level-hops'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. binary-tree-level-order
((SELECT id FROM problems WHERE slug = 'binary-tree-level-order'), 'ko',
 $$이진 트리 레벨 순서 순회$$,
 $$이진 트리의 `root`가 주어졌을 때, 레벨 순서 순회를 반환하세요. 결과의 `i`번째 원소는 깊이 `i`에 있는 노드 값들을 왼쪽에서 오른쪽 순서로 나열한 리스트입니다.

빈 트리는 빈 리스트를 반환합니다.

**예시 1:**
```
입력: root = [3,9,20,null,null,15,7]
출력: [[3],[9,20],[15,7]]
설명: 깊이 0에는 `3`, 깊이 1에는 `9`와 `20`, 깊이 2에는 `15`와 `7`이 왼쪽부터 차례로 놓여 있습니다.
```

**예시 2:**
```
입력: root = [1]
출력: [[1]]
설명: 노드가 하나뿐이므로 깊이 0에 `1` 한 개만 들어 있는 리스트가 결과입니다.
```

**예시 3:**
```
입력: root = []
출력: []
설명: 빈 트리이므로 결과도 빈 리스트입니다.
```$$,
 $$- 트리의 노드 개수는 `[0, 2 * 10^3]` 범위입니다.
- `-1000 <= Node.val <= 1000`$$),

-- 2. valid-score-bst
((SELECT id FROM problems WHERE slug = 'valid-score-bst'), 'ko',
 $$점수 트리 검사$$,
 $$오락실의 플레이어 점수를 이진 트리에 저장해 두었습니다. 이 트리는 BST여야 합니다. 즉, 왼쪽 서브트리의 모든 노드는 조상 노드보다 **엄격히 작고**, 오른쪽 서브트리의 모든 노드는 조상 노드보다 **엄격히 커야** 합니다. 모든 점수는 서로 다릅니다.

트리의 `root`가 주어졌을 때, 직계 자식뿐 아니라 서브트리 전체에 걸쳐 BST 규칙이 지켜지면 `true`, 그렇지 않으면 `false`를 반환하는 `verifyWardOrder(root)`를 구현하세요.

**예시 1:**
```
입력: root = [50,30,70,20,40,60,80]
출력: true
설명: 모든 왼쪽 서브트리는 조상 노드보다 작은 값만 갖고, 모든 오른쪽 서브트리는 조상 노드보다 큰 값만 갖습니다.
```

**예시 2:**
```
입력: root = [10,5,15,null,null,6,20]
출력: false
설명: `6`이 루트 `10`의 오른쪽 서브트리에 들어 있는데 `6 < 10`이므로 BST 규칙이 깨집니다.
```$$,
 $$- 트리의 노드 개수는 `[1, 2 * 10^5]` 범위 안에 있습니다.
- `-10^8 <= Node.val <= 10^8`
- 모든 점수는 서로 다릅니다.$$),

-- 3. lca-bst
((SELECT id FROM problems WHERE slug = 'lca-bst'), 'ko',
 $$이진 검색 트리의 최소 공통 조상$$,
 $$이진 검색 트리(BST)의 `root`와 트리 안에 존재하는 두 노드 `p`, `q`가 주어졌을 때, `p`와 `q`의 최소 공통 조상(LCA)을 반환하세요.

LCA란 `p`와 `q`를 모두 자손으로 두는 노드 중 가장 깊은 노드를 뜻합니다. 자기 자신도 자손으로 칠 수 있습니다. BST의 성질을 이용하면 루트에서 내려가면서 두 노드가 어느 서브트리에 속하는지 단계마다 판단할 수 있습니다.

**예시 1:**
```
입력: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 8
출력: 6
설명: `2`와 `8`이 루트에서 서로 다른 서브트리로 갈라지므로 LCA는 루트 `6`입니다.
```

**예시 2:**
```
입력: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 4
출력: 2
설명: `4`는 노드 `2`를 루트로 하는 서브트리 안에 있고, 노드는 자기 자신을 자손으로 칠 수 있으므로 LCA는 `2`입니다.
```$$,
 $$- 트리의 노드 개수는 `[2, 2 * 10^5]` 범위 안에 있습니다.
- `-10^8 <= Node.val <= 10^8`
- 모든 노드 값은 서로 다릅니다.
- `p != q`
- `p`와 `q`는 모두 트리 안에 존재합니다.$$),

-- 4. subsets-ii
((SELECT id FROM problems WHERE slug = 'subsets-ii'), 'ko',
 $$부분집합 II$$,
 $$중복 원소가 있을 수 있는 정수 배열 `nums`가 주어집니다. `nums`의 **모든** 가능한 부분집합(멱집합)을 반환하세요. 단, 결과 안에는 중복된 부분집합이 들어 있어서는 안 됩니다.

부분집합들의 순서와 각 부분집합 안의 순서는 상관없습니다.

**예시 1:**
```
입력: nums = [1,2,2]
출력: [[],[1],[1,2],[1,2,2],[2],[2,2]]
설명: `nums`에는 `2`가 두 번 들어 있어 같은 다중집합이 여러 번 만들어지지만, 결과에는 서로 다른 부분집합 6개만 남깁니다.
```

**예시 2:**
```
입력: nums = [0]
출력: [[],[0]]
설명: 원소가 하나뿐이므로 빈 부분집합과 `[0]` 두 가지만 존재합니다.
```$$,
 $$- `1 <= nums.length <= 10`
- `-10 <= nums[i] <= 10`$$),

-- 5. voucher-price-combos
((SELECT id FROM problems WHERE slug = 'voucher-price-combos'), 'ko',
 $$쿠폰 가격 조합$$,
 $$카페 쿠폰으로 가격 합이 정확히 `voucher`와 같아지도록 항목들을 자유롭게 골라 담을 수 있습니다. 가격 목록 `prices`는 서로 다른 양의 정수들로 이루어져 있고, 각 항목은 원하는 만큼 몇 번이든 담을 수 있습니다.

가격 합이 `voucher`와 같아지는 모든 서로 다른 장바구니를 반환하세요. 장바구니는 가격들의 리스트(같은 값 중복 가능)이며, 어느 한 가격이라도 등장 횟수가 다르면 서로 다른 장바구니로 봅니다. 반환 순서는 상관없습니다.

**예시 1:**
```
입력: prices = [2,4,5], voucher = 9
출력: [[2,2,5],[4,5]]
설명: `2 + 2 + 5 = 9`와 `4 + 5 = 9`만 쿠폰 금액과 정확히 일치하는 두 장바구니입니다.
```

**예시 2:**
```
입력: prices = [3,4,7], voucher = 10
출력: [[3,3,4],[3,7]]
설명: `3 + 3 + 4 = 10`과 `3 + 7 = 10`이 쿠폰 금액과 정확히 일치하는 두 장바구니입니다.
```$$,
 $$- `1 <= prices.length <= 30`
- `2 <= prices[i] <= 40`
- `prices`의 모든 원소는 서로 다릅니다.
- `1 <= voucher <= 40`$$),

-- 6. cafe-stop-orders
((SELECT id FROM problems WHERE slug = 'cafe-stop-orders'), 'ko',
 $$카페 투어 순서 짜기$$,
 $$방문 목록 `stops`는 한 번씩 들를 서로 다른 카페 ID들의 리스트입니다. `stops`의 가능한 모든 방문 순서를 반환하도록 `listStationOrders`를 구현하세요. 바깥 리스트의 순서는 상관없습니다.

**예시 1:**
```
입력: stops = [4,7,2]
출력: [[4,7,2],[4,2,7],[7,4,2],[7,2,4],[2,4,7],[2,7,4]]
설명: 서로 다른 카페가 3개이므로 가능한 방문 순서는 `3! = 6`가지입니다.
```

**예시 2:**
```
입력: stops = [5,9]
출력: [[5,9],[9,5]]
설명: 카페가 두 곳뿐이므로 가능한 순서는 `5 → 9`와 `9 → 5` 두 가지입니다.
```$$,
 $$- `1 <= stops.length <= 6`
- `-10 <= stops[i] <= 10`
- `stops`의 모든 원소는 서로 다릅니다.$$),

-- 7. count-desk-clusters
((SELECT id FROM problems WHERE slug = 'count-desk-clusters'), 'ko',
 $$책상 그룹 세기$$,
 $$교실 좌석표가 `m x n` 격자 `board`로 주어지고, `"1"`은 책상이 있는 칸, `"0"`은 빈 칸입니다. **그룹**은 상하좌우로 이어진 책상들의 최대 묶음을 뜻하며, 대각선은 연결로 치지 않습니다.

격자 안에 존재하는 그룹의 개수를 반환하세요. 격자 바깥쪽은 모두 빈 칸으로 간주합니다.

**예시 1:**
```
입력: board = [["0","1","1","0","0","1"],["1","1","0","0","0","1"],["0","0","0","1","0","0"],["1","0","0","1","1","0"],["1","0","0","0","0","1"]]
출력: 5
설명: 4방향으로 이어진 그룹이 다섯 개 — 좌상단 L 모양, 오른쪽 열의 두 칸 묶음, 좌표 (2,3) 근처의 가운데 묶음, (3,0)/(4,0)의 왼쪽 두 칸 묶음, 그리고 (4,5)의 외톨이 책상이 그것입니다.
```

**예시 2:**
```
입력: board = [["1","1","0","0"],["0","1","0","1"],["0","0","0","1"]]
출력: 2
설명: 좌상단의 한 그룹과, 오른쪽 가장자리에 세로로 이어진 두 책상 그룹, 이렇게 두 개입니다.
```$$,
 $$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 250`
- `board[i][j]`는 `'0'` 또는 `'1'`입니다.$$),

-- 8. snapshot-town-map
((SELECT id FROM problems WHERE slug = 'snapshot-town-map'), 'ko',
 $$맵 스냅샷 뜨기$$,
 $$연결된 무방향 그래프에서 마을의 한 장소를 가리키는 노드 `node` 하나가 주어집니다. 각 장소에는 정수 `val`과 이웃 노드들의 리스트 `neighbors`가 있습니다.

주어진 노드에서 도달할 수 있는 연결된 그래프 전체를 **깊은 복사(deep copy)**해서 반환하세요. 복사본의 모든 노드는 같은 `val`과 같은 이웃 구조를 가진, 새로 할당된 객체여야 합니다. 어떤 노드도 원본과 공유해서는 안 됩니다.

그래프는 인접 리스트 `adjList` 형태로 전달됩니다. 인덱스 `i` (0부터 시작)에는 `val = i + 1`인 노드의 이웃들이 담겨 있습니다. 그래프가 비어 있지 않다면 진입점 노드의 `val`은 항상 `1`입니다.

**예시 1:**
```
입력: adjList = [[2,3],[1,4],[1,5],[2,5],[3,4]]
출력: [[2,3],[1,4],[1,5],[2,5],[3,4]]
설명: 장소 `1`은 `2`, `3`과 이어지고 장소 `2`는 `1`, `4`와 이어집니다. 복사본은 모든 간선을 새 노드 객체로 그대로 옮깁니다.
```

**예시 2:**
```
입력: adjList = [[2],[1,3],[2]]
출력: [[2],[1,3],[2]]
설명: 세 장소가 일자로 이어진 그래프를 간선 단위로 그대로 복제합니다.
```$$,
 $$- 맵의 장소 수는 `[0, 100]` 범위입니다.
- `1 <= node.val <= 100`
- `node.val`은 노드마다 유일합니다.
- 그래프에는 자기 자신으로 가는 간선이나 중복 간선이 없습니다.$$),

-- 9. verify-task-order
((SELECT id FROM problems WHERE slug = 'verify-task-order'), 'ko',
 $$조별 과제 계획 검증$$,
 $$조별 과제에는 `0`부터 `numScenes - 1`까지 번호가 매겨진 `numScenes`개의 작업이 있습니다. 선행 조건 배열 `prereqs`의 각 원소 `prereqs[i] = [a, b]`는 작업 `a`를 시작하려면 먼저 작업 `b`가 끝나 있어야 한다는 뜻입니다.

모든 작업을 완료할 수 있는 순서가 하나라도 존재하면 `true`, 의존 관계에 순환이 있어 불가능하면 `false`를 반환하세요.

**예시 1:**
```
입력: numScenes = 4, prereqs = [[1,0],[2,0],[3,1]]
출력: true
설명: 먼저 작업 `0`을 끝내면, 모두 `0`만 필요한 작업 `1`과 `2`를 이어서 처리할 수 있고 마지막으로 작업 `3`을 처리하면 됩니다. 순환 의존이 없습니다.
```

**예시 2:**
```
입력: numScenes = 3, prereqs = [[0,2],[2,1],[1,0]]
출력: false
설명: 작업 `0`은 `2`를, `2`는 `1`을, `1`은 `0`을 필요로 해서 세 작업이 순환을 이루므로 어떤 작업도 시작할 수 없습니다.
```$$,
 $$- `1 <= numScenes <= 2000`
- `0 <= prereqs.length <= 5000`
- `prereqs[i].length == 2`
- `0 <= a, b < numScenes`
- 모든 `prereqs[i]` 쌍은 서로 다릅니다.$$),

-- 10. count-level-hops
((SELECT id FROM problems WHERE slug = 'count-level-hops'), 'ko',
 $$레벨 뛰는 경우의 수$$,
 $$플랫포머 게임에서 캐릭터는 레벨 `0`에 서 있고 목표 레벨 정수 `n`까지 가야 합니다. 한 번의 점프로 1레벨 또는 2레벨 앞으로 나아갈 수 있어요.

레벨 `n`에 정확히 도착하는 서로 다른 점프 순서의 개수를 반환하는 `countReservoirPaths(n)`을 구현하세요.

**예시 1:**
```
입력: n = 4
출력: 5
설명: 합이 4가 되는 1·2 점프 순서는 `1+1+1+1`, `1+1+2`, `1+2+1`, `2+1+1`, `2+2`로 모두 다섯 가지입니다.
```

**예시 2:**
```
입력: n = 5
출력: 8
설명: 합이 5가 되는 1·2 점프 순서가 모두 여덟 가지 있습니다.
```$$,
 $$- `1 <= n <= 40`$$);
