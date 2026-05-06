-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 7 (problems #61-#70)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (catalog, target, piles,
-- hours, k, readings, head, score1, score2, queues, root, preorder,
-- inorder) stay verbatim. First mention of each variable in Korean prose
-- is paired with a Korean noun phrase describing its role. Constraint
-- identifiers are aligned with the canonical English parameter names
-- from V135 / V137 source descriptions.

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'search-rotated-catalog', 'slowest-snack-rate', 'find-battery-peak', 'interleave-clip-chain',
      'add-score-lists', 'clone-quest-log', 'merge-cafe-queues', 'nth-lowest-score',
      'rebuild-boss-tree', 'right-side-skill-view'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. search-rotated-catalog
((SELECT id FROM problems WHERE slug = 'search-rotated-catalog'), 'ko',
 $$회전된 카탈로그 탐색$$,
 $$RPG의 아이템 카탈로그는 평소엔 ID 순으로 정렬되어 있지만, 오늘 밤에는 어떤 축을 기준으로 회전되어 있습니다. 예를 들어 `[10,14,18,22,25,28,33]`이 `[25,28,33,10,14,18,22]`로 보일 수 있어요.

회전된 카탈로그 `catalog`와 찾으려는 ID `target`이 주어집니다. `catalog`에서 `target`이 위치한 인덱스를 반환하고, 없으면 `-1`을 반환하세요. 알고리즘은 `O(log n)` 시간에 동작해야 합니다.

**예시 1:**
```
입력: catalog = [12,18,24,31,3,7,9], target = 3
출력: 4
설명: 회전된 카탈로그에서 3은 인덱스 4에 들어 있습니다.
```

**예시 2:**
```
입력: catalog = [12,18,24,31,3,7,9], target = 15
출력: -1
설명: 15에 해당하는 항목이 없습니다.
```

**예시 3:**
```
입력: catalog = [8], target = 3
출력: -1
```$$,
 $$- `1 <= catalog.length <= 6000`
- `|catalog[i]| <= 10^8`
- `catalog`의 값은 모두 서로 다릅니다.
- `catalog`는 오름차순으로 정렬된 뒤 알 수 없는 지점에서 회전된 리스트입니다.
- `|target| <= 10^8`$$),

-- 2. slowest-snack-rate
((SELECT id FROM problems WHERE slug = 'slowest-snack-rate'), 'ko',
 $$가장 느린 간식 속도$$,
 $$핼러윈이 끝나고 남은 사탕 더미들이 정수 배열 `piles`에 들어 있습니다. `piles[i]`는 더미 `i`의 사탕 개수이고, 전부 해치우는 데 `hours`시간을 잡아뒀습니다. 한 시간마다 더미 하나를 골라 거기서 최대 `k`개까지 사탕을 먹는데, 남은 개수가 `k`보다 적으면 그냥 그 더미를 비우고 그 시간의 나머지는 가만히 있습니다.

`hours`시간 안에 모든 더미를 비울 수 있는 가장 작은 정수 먹는 속도 `k`를 반환하세요.

**예시 1:**
```
입력: piles = [5,8,12,20], hours = 9
출력: 6
설명: 속도 6일 때 더미별 소요 시간은 ceil(5/6)=1, ceil(8/6)=2, ceil(12/6)=2, ceil(20/6)=4로 합이 9시간입니다.
```

**예시 2:**
```
입력: piles = [40,25,18,33,12], hours = 5
출력: 40
설명: 더미가 5개인데 시간도 5시간뿐이라, 모든 더미를 한 시간 안에 비워야 합니다.
```

**예시 3:**
```
입력: piles = [40,25,18,33,12], hours = 7
출력: 25
```$$,
 $$- `1 <= piles.length <= 2 * 10^5`
- `piles.length <= hours <= 10^8`
- `1 <= piles[i] <= 10^8`$$),

-- 3. find-battery-peak
((SELECT id FROM problems WHERE slug = 'find-battery-peak'), 'ko',
 $$정점 값 찾기$$,
 $$오후 동안 휴대폰의 배터리 잔량 로그가 정수 배열 `readings`에 담겨 있고, 배터리가 잠깐 정점을 찍은 순간을 찾고 싶습니다. **정점 값**은 양 이웃보다 엄격히 큰 값을 말합니다. 배열 바깥의 자리는 `-무한`으로 취급하므로, 양 끝 값은 하나뿐인 이웃만 이기면 됩니다.

`readings`의 정점 인덱스 하나를 반환하세요. 여러 개라면 어떤 것이든 정답입니다. 로그가 매우 길기 때문에 풀이는 `O(log n)` 시간에 동작해야 합니다.

**예시 1:**
```
입력: readings = [11,18,22,19,15]
출력: 2
설명: readings[2] = 22는 양 이웃 18, 19보다 큽니다.
```

**예시 2:**
```
입력: readings = [3,7,12,25,20,14,9]
출력: 3
설명: readings[3] = 25는 readings[2] = 12, readings[4] = 20보다 큽니다.
```$$,
 $$- `1 <= readings.length <= 2 * 10^3`
- `|readings[i]| <= 10^8`
- 모든 유효한 `i`에 대해 `readings[i] != readings[i + 1]`.$$),

-- 4. interleave-clip-chain
((SELECT id FROM problems WHERE slug = 'interleave-clip-chain'), 'ko',
 $$트레일러 컷 교차하기$$,
 $$게임 클립 모음이 가장 이른 것부터 가장 늦은 것까지 연결 체인으로 이어져 있습니다. 앞쪽과 뒤쪽 클립이 번갈아 나오도록 제자리에서 재배치하세요.

연결 리스트의 헤드 `head`가 주어졌을 때, 노드 순서를 `S0 -> Sn -> S1 -> Sn-1 -> S2 -> Sn-2 -> ...`이 되도록 다시 엮으세요. `next` 포인터만 다시 연결해야 하며, 노드 값은 절대 바꾸지 않습니다.

**예시 1:**
```
입력: head = [10,20,30,40,50,60]
출력: [10,60,20,50,30,40]
설명: 앞쪽 클립과 뒤쪽 클립이 10, 60, 20, 50처럼 번갈아 엮입니다.
```

**예시 2:**
```
입력: head = [1,3,5,7,9,11,13]
출력: [1,13,3,11,5,9,7]
설명: 길이가 홀수면 가운데 클립이 마지막 자리에 놓입니다.
```$$,
 $$- 체인의 클립 개수는 `[1, 8 * 10^4]` 범위 안에 있습니다.
- `1 <= Shot.val <= 1000`$$),

-- 5. add-score-lists
((SELECT id FROM problems WHERE slug = 'add-score-lists'), 'ko',
 $$점수 합산 연결 리스트$$,
 $$두 플레이어의 점수가 연결 리스트로 저장되어 있는데, **일의 자리가 헤드에 오고** 뒤로 갈수록 더 큰 자릿수가 이어집니다. 두 점수를 더한 값을 같은 방식(자릿수가 뒤집힌 배치)의 새 연결 리스트로 반환하세요.

값이 `0`인 한 노드짜리 리스트를 제외하면, 두 입력 `score1`, `score2` 모두 선행 0은 없습니다.

**예시 1:**
```
입력: score1 = [3,1,7], score2 = [4,8]
출력: [7,9,7]
설명: 입력 두 리스트는 각각 713과 84를 나타냅니다. 합 797을 일의 자리부터 다시 적어 반환합니다.
```

**예시 2:**
```
입력: score1 = [9], score2 = [8]
출력: [7,1]
설명: 9 + 8 = 17 이므로 헤드 노드에는 7이 들어가고, 십의 자리를 위한 올림 노드가 뒤에 추가됩니다.
```

**예시 3:**
```
입력: score1 = [1,8,6], score2 = [4,5]
출력: [5,3,7]
설명: 681 + 54 = 735 입니다.
```$$,
 $$- 각 리스트의 노드 개수는 `[1, 120]` 범위 안에 있습니다.
- `0 <= Node.val <= 9`
- `0`을 나타내는 한 노드짜리 리스트를 제외하면 선행 0은 없습니다.$$),

-- 6. clone-quest-log
((SELECT id FROM problems WHERE slug = 'clone-quest-log'), 'ko',
 $$퀘스트 로그 복제$$,
 $$길드의 퀘스트 로그는 미션들이 연결 리스트로 이어진 형태입니다. 각 노드에는 다음 미션을 가리키는 `next` 포인터와, 로그 안의 다른 미션(또는 `null`)을 가리키는 `related` 포인터가 있습니다.

노드가 `n`개인 로그의 헤드 `head`가 주어졌을 때, 깊은 복사본의 헤드를 반환하세요. 사본은 정확히 `n`개의 새 노드로 구성되어야 하며, 사본의 모든 `next`와 `related` 포인터는 반드시 사본 내부의 노드만 가리켜야 합니다.

표준 입력은 `[val, related_index]` 쌍의 배열이며, `related_index`는 `related` 포인터가 가리키는 미션의 0부터 시작하는 인덱스이거나 `null`입니다.

**예시 1:**
```
입력: head = [[9,2],[4,null],[6,0],[2,1]]
출력: [[9,2],[4,null],[6,0],[2,1]]
설명: 네 개의 미션이 모두 복제되며, 각 related 포인터는 그에 대응하는 사본 노드로 새로 연결됩니다.
```

**예시 2:**
```
입력: head = [[5,0]]
출력: [[5,0]]
설명: 하나뿐인 노드의 related 포인터는 사본에서 자기 자신을 가리키도록 다시 연결됩니다.
```

**예시 3:**
```
입력: head = [[3,null],[7,null]]
출력: [[3,null],[7,null]]
```$$,
 $$- `0 <= n <= 1200`
- `-8 * 10^4 <= Node.val <= 8 * 10^4`
- `Node.related`는 `null`이거나 로그 안의 어떤 노드를 가리키는 포인터입니다.$$),

-- 7. merge-cafe-queues
((SELECT id FROM problems WHERE slug = 'merge-cafe-queues'), 'ko',
 $$카페 주문 큐 합치기$$,
 $$이미 픽업 시간순으로 정렬된 연결 리스트 `k`개의 헤드가 배열 `queues`에 들어 있습니다. 기존 노드들의 연결만 다시 이어 하나의 정렬된 리스트로 합친 뒤, 그 헤드를 반환하세요.

**예시 1:**
```
입력: queues = [[2,5,8],[1,3,7],[4,6]]
출력: [1,2,3,4,5,6,7,8]
설명: 미리 정렬된 세 개의 큐가 하나의 정렬된 큐로 엮입니다.
```

**예시 2:**
```
입력: queues = [[1,3,5],[2,4,6]]
출력: [1,2,3,4,5,6]
설명: 두 개의 큐가 번갈아 엮이며 하나의 정렬된 줄을 이룹니다.
```

**예시 3:**
```
입력: queues = [[1,4],[2,5],[3,6]]
출력: [1,2,3,4,5,6]
설명: 세 개의 큐가 매 단계마다 헤드 값을 비교하며 함께 엮입니다.
```$$,
 $$- `k == queues.length`
- `0 <= k <= 2 * 10^3`
- `0 <= queues[i].length <= 500`
- `-8 * 10^4 <= queues[i][j] <= 8 * 10^4`
- 각 `queues[i]`는 오름차순으로 정렬되어 있습니다.
- 모든 큐의 주문 노드 총 개수는 `2 * 10^3`을 넘지 않습니다.$$),

-- 8. nth-lowest-score
((SELECT id FROM problems WHERE slug = 'nth-lowest-score'), 'ko',
 $$N번째 낮은 점수$$,
 $$점수가 점수를 키로 하는 이진 탐색 트리에 저장돼 있어서, 중위 순회로 훑으면 가장 낮은 점수부터 가장 높은 점수까지 차례대로 방문합니다.

트리의 루트 `root`와 1부터 시작하는 위치 `k`가 주어졌을 때, `pickNthTarget`을 구현해 `k`번째로 낮은 점수를 반환하세요. `k`는 `1` 이상이고 트리에 있는 점수 개수 이하라고 가정합니다.

**예시 1:**
```
입력: root = [8,4,12,2,6,10,14], k = 4
출력: 8
설명: 중위 순회 결과는 [2,4,6,8,10,12,14] 입니다. 4번째 값은 8입니다.
```

**예시 2:**
```
입력: root = [20,10,30,5,15,25,35,null,7], k = 2
출력: 7
설명: 중위 순회 결과는 [5,7,10,15,20,25,30,35] 입니다. 2번째 값은 7입니다.
```$$,
 $$- 트리에 들어 있는 점수 개수는 `n`입니다.
- `1 <= k <= n <= 8 * 10^4`
- `0 <= Node.val <= 10^8`
- 트리는 올바른 이진 탐색 트리입니다.$$),

-- 9. rebuild-boss-tree
((SELECT id FROM problems WHERE slug = 'rebuild-boss-tree'), 'ko',
 $$보스전 트리 복원$$,
 $$비디오 게임 세이브 파일의 보스전 트리가 손상됐지만 두 개의 로그 파일이 살아남았습니다. 하나는 **전위 순회**(노드, 왼쪽, 오른쪽) 순서, 다른 하나는 **중위 순회**(왼쪽, 노드, 오른쪽) 순서로 기록되어 있어요. 이 두 로그를 가지고 트리를 다시 만들어 보세요.

같은 노드 id들이 각 순회 순서대로 들어 있는 정수 배열 `preorder`와 `inorder`가 주어집니다. `assembleBreakdown(preorder, inorder)`를 구현해 복원된 트리를 반환하세요.

**예시 1:**
```
입력: preorder = [10,5,3,7,20,15], inorder = [3,5,7,10,15,20]
출력: [10,5,20,3,7,15]
설명: 10이 루트입니다. 중위 순회는 [3,5,7](왼쪽 서브트리)와 [15,20](오른쪽 서브트리)로 갈리며, 왼쪽은 (5, 왼쪽 3, 오른쪽 7), 오른쪽은 (20, 왼쪽 15)가 됩니다.
```

**예시 2:**
```
입력: preorder = [42], inorder = [42]
출력: [42]
설명: 노드 하나가 트리 전체입니다.
```$$,
 $$- `1 <= preorder.length <= 2 * 10^3`
- `inorder.length == preorder.length`
- `-10^8 <= preorder[i], inorder[i] <= 10^8`
- 모든 id는 서로 다릅니다.
- `inorder`에 있는 모든 값은 `preorder`에도 있습니다.
- `preorder`는 트리의 올바른 전위 순회 결과입니다.
- `inorder`는 같은 트리의 올바른 중위 순회 결과입니다.$$),

-- 10. right-side-skill-view
((SELECT id FROM problems WHERE slug = 'right-side-skill-view'), 'ko',
 $$오른쪽에서 본 스킬 트리$$,
 $$화면 오른쪽 끝에서 스킬 트리를 바라보면, 각 단계마다 가장 오른쪽에 있는 노드만 보이고 그 뒤의 노드들은 가려집니다.

스킬 트리의 루트 `root`가 주어졌을 때, 위에서 아래로 각 단계의 가장 오른쪽 노드 값을 반환하세요. 트리가 비어 있으면 빈 리스트를 반환합니다.

**예시 1:**
```
입력: root = [7,8,9,null,6,null,3]
출력: [7,9,3]
설명: 0층은 7만 보입니다. 1층은 8과 9 중 오른쪽에 있는 9가 보입니다. 2층은 6과 3 중 오른쪽에 있는 3이 보입니다.
```

**예시 2:**
```
입력: root = [2,null,5]
출력: [2,5]
```

**예시 3:**
```
입력: root = [1,null,2]
출력: [1,2]
설명: 각 층마다 가장 오른쪽 노드가 드러납니다. 0층에서는 1, 1층에서는 2가 보입니다.
```$$,
 $$- 트리의 노드 개수는 `[0, 100]` 범위에 있습니다.
- `-100 <= Node.val <= 100`$$);
