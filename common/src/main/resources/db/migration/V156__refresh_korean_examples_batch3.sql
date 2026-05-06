-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 3 (problems #21-#30)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (menu, target, scores, head,
-- runA, runB, pos, n, root, p, q, subRoot) stay verbatim. First mention of
-- each variable in Korean prose is paired with a Korean noun phrase
-- describing its type or role. Constraint identifiers are also aligned
-- with the canonical English parameter names from V135/V137/V152.

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'find-menu-price', 'find-rotated-low-score', 'reverse-linked-list', 'merge-leaderboard-runs',
      'detect-portal-loop', 'drop-nth-reservation', 'mirror-menu-tree', 'deepest-skill-chain',
      'same-skill-trees', 'find-submap'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. find-menu-price
((SELECT id FROM problems WHERE slug = 'find-menu-price'), 'ko',
 $$메뉴판에서 가격 찾기$$,
 $$카페 메뉴판이 `m x n` 격자 `menu`로 인쇄되어 있고, 각 행은 왼쪽에서 오른쪽으로 오름차순으로 정렬되어 있습니다. 또한 어느 행의 첫 가격은 바로 위 행의 마지막 가격보다 크기 때문에, 행을 차례로 이어서 읽으면 전체가 하나의 정렬된 목록이 됩니다.

격자의 어떤 칸에 정수 `target`과 정확히 같은 값이 있으면 `true`, 없으면 `false`를 반환하세요. `O(log(m * n))` 시간 안에 동작해야 합니다.

**예시 1:**
```
입력: menu = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 22
출력: true
설명: 1번 행 2번 열의 칸에 값 `22`가 들어 있으므로 `target`이 메뉴판에 존재합니다.
```

**예시 2:**
```
입력: menu = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 9
출력: false
설명: 어떤 칸에도 가격 `9`가 적혀 있지 않으므로 `target`은 메뉴판에 없습니다.
```$$,
 $$- `m == menu.length`
- `n == menu[i].length`
- `1 <= m, n <= 120`
- `|menu[i][j]| <= 10^8`
- `|target| <= 10^8`$$),

-- 2. find-rotated-low-score
((SELECT id FROM problems WHERE slug = 'find-rotated-low-score'), 'ko',
 $$회전된 리더보드 최저 점수$$,
 $$서로 다른 점수들로 이루어진 리더보드가 원래는 오름차순으로 정렬되어 있었는데, `1`번에서 `n`번 사이의 횟수만큼 회전된 상태입니다. 회전된 정수 배열 `scores`가 주어졌을 때, 그 안에서 가장 작은 값을 반환하세요.

`O(log n)` 시간 안에 동작해야 합니다.

**예시 1:**
```
입력: scores = [7,9,12,2,5]
출력: 2
설명: 원래 정렬된 목록은 `[2,5,7,9,12]`였고 이를 3번 회전한 결과이므로 가장 작은 값은 `2`입니다.
```

**예시 2:**
```
입력: scores = [15,20,24,31,3,8,12]
출력: 3
설명: 정렬된 목록을 회전한 뒤에도 가장 작은 값은 `3`이며, 회전이 일어난 경계 바로 뒤에 위치합니다.
```

**예시 3:**
```
입력: scores = [21,33,45,58]
출력: 21
설명: 회전이 적용되지 않은 경우이므로 첫 번째 원소가 그대로 가장 작은 값입니다.
```$$,
 $$- `n == scores.length`
- `1 <= n <= 6000`
- `|scores[i]| <= 10^8`
- `scores`의 모든 값은 서로 다릅니다.
- `scores`는 오름차순 리스트를 `1`번에서 `n`번 사이 회전시킨 결과입니다.$$),

-- 3. reverse-linked-list
((SELECT id FROM problems WHERE slug = 'reverse-linked-list'), 'ko',
 $$연결 리스트 뒤집기$$,
 $$단일 연결 리스트의 헤드 `head`가 주어졌을 때, 리스트를 뒤집은 뒤 새 헤드를 반환하세요. 새 리스트를 새로 만들지 말고, 기존 노드들을 **제자리에서** 다시 연결해야 합니다.

**예시 1:**
```
입력: head = [1,2,3,4,5]
출력: [5,4,3,2,1]
설명: 노드 `1`에서 `5`까지 이어지던 리스트가 뒤집혀 `5`에서 `1` 방향으로 연결됩니다.
```

**예시 2:**
```
입력: head = [1,2]
출력: [2,1]
설명: 두 노드짜리 리스트의 순서가 뒤바뀌어 `2`가 새 헤드가 됩니다.
```

**예시 3:**
```
입력: head = []
출력: []
설명: 비어 있는 리스트는 뒤집어도 그대로 빈 리스트입니다.
```$$,
 $$- 리스트의 노드 개수는 `[0, 6000]` 범위 안에 있습니다.
- `-6000 <= Node.val <= 6000`$$),

-- 4. merge-leaderboard-runs
((SELECT id FROM problems WHERE slug = 'merge-leaderboard-runs'), 'ko',
 $$리더보드 기록 합치기$$,
 $$랩 타임을 담은 두 연결 리스트의 헤드 `runA`와 `runB`가 주어지며, 각각 비내림차순으로 정렬되어 있습니다. 두 리스트의 기존 노드들을 그대로 이어 붙여 정렬된 하나의 리스트로 만든 뒤, 그 헤드를 반환하는 `combineOvenRotations(runA, runB)`를 구현하세요.

**예시 1:**
```
입력: runA = [2,5,9], runB = [3,4,7]
출력: [2,3,4,5,7,9]
설명: 두 리스트의 랩 타임이 교차되며 하나의 정렬된 리더보드로 엮입니다.
```

**예시 2:**
```
입력: runA = [], runB = [2,4,6]
출력: [2,4,6]
설명: 한쪽 친구의 기록이 비어 있으면 다른 친구의 기록이 그대로 결과가 됩니다.
```

**예시 3:**
```
입력: runA = [], runB = [3]
출력: [3]
설명: 두 번째 친구의 단일 기록만 남아 있으므로 그 노드 하나가 결과 리스트가 됩니다.
```$$,
 $$- 각 리스트의 노드 개수는 `[0, 60]` 범위 안에 있습니다.
- `-100 <= Node.val <= 100`
- `runA`와 `runB`는 비내림차순으로 정렬되어 있습니다.$$),

-- 5. detect-portal-loop
((SELECT id FROM problems WHERE slug = 'detect-portal-loop'), 'ko',
 $$포털 루프 감지$$,
 $$RPG 던전에서 각 방의 `next` 포인터는 다음 방으로 순간이동시키며, 어떤 체인은 이전 방으로 되돌아가 무한히 순환하기도 합니다.

리스트의 헤드 `head`에서 시작해 `next` 포인터를 계속 따라갔을 때 어떤 방을 다시 방문하면 `true`를, 그렇지 않으면 `false`를 반환하는 `detectTransferLoop(head, pos)`를 구현하세요. 정수 `pos`는 꼬리 노드가 가리키는 0-based 인덱스이며(`-1`이면 루프 없음), 테스트 입력을 구성할 때만 사용되고 함수 안에서는 **사용하지 않습니다**.

**예시 1:**
```
입력: head = [8,5,2,6,9], pos = 2
출력: true
설명: 꼬리 노드의 `next` 포인터가 인덱스 `2`의 방으로 다시 연결되어 루프가 형성됩니다.
```

**예시 2:**
```
입력: head = [4,7,3], pos = 0
출력: true
설명: 마지막 방이 헤드 방으로 순간이동되어 전체 체인이 하나의 큰 루프를 이룹니다.
```

**예시 3:**
```
입력: head = [6,2], pos = -1
출력: false
설명: 체인이 깔끔하게 끝나며 어떤 방으로도 되돌아가지 않으므로 루프가 없습니다.
```$$,
 $$- 방의 개수는 `[0, 2 * 10^3]` 범위 안에 있습니다.
- `-8 * 10^4 <= Node.val <= 8 * 10^4`
- `pos`는 `-1`이거나 체인 안의 유효한 0-based 인덱스입니다.$$),

-- 6. drop-nth-reservation
((SELECT id FROM problems WHERE slug = 'drop-nth-reservation'), 'ko',
 $$뒤에서 N번째 예약 취소$$,
 $$어느 카페가 오늘의 예약을 들어온 순서대로 연결 리스트로 관리합니다. 리스트의 헤드 `head`와 정수 `n`이 주어지면, **뒤에서부터** `n`번째 예약을 제거하고 갱신된 헤드를 반환하세요.

**예시 1:**
```
입력: head = [10,20,30,40,50,60], n = 3
출력: [10,20,30,50,60]
설명: 뒤에서 셌을 때 예약 `40`이 3번째이며, 이를 제거하면 리스트는 `10 -> 20 -> 30 -> 50 -> 60`이 됩니다.
```

**예시 2:**
```
입력: head = [7], n = 1
출력: []
설명: 유일한 예약이 취소되었으므로 스케줄이 비게 됩니다.
```

**예시 3:**
```
입력: head = [4,9], n = 2
출력: [9]
설명: 뒤에서 2번째 예약은 가장 첫 번째 노드인 `4`이므로, 이를 제거하면 `9`만 남습니다.
```$$,
 $$- 리스트의 예약 개수는 `sz`입니다.
- `1 <= sz <= 40`
- `0 <= Node.val <= 100`
- `1 <= n <= sz`$$),

-- 7. mirror-menu-tree
((SELECT id FROM problems WHERE slug = 'mirror-menu-tree'), 'ko',
 $$메뉴 트리 뒤집기$$,
 $$카페 메뉴가 이진 트리 형태로 구성되어 있고, 왼쪽 자식은 순한 옵션, 오른쪽 자식은 진한 옵션입니다. 모든 계층에서 왼쪽과 오른쪽을 맞바꿔 메뉴판을 통째로 뒤집으세요.

메뉴 트리의 루트 `root`가 주어졌을 때, 각 노드의 왼쪽과 오른쪽 자식을 재귀적으로 교환하고 뒤집힌 루트를 반환하는 `reflectBlend`를 구현하세요.

**예시 1:**
```
입력: root = [5,3,8,2,4,7,9]
출력: [5,8,3,9,7,4,2]
설명: 모든 계층에서 왼쪽과 오른쪽 자식 쌍이 통째로 맞바뀌어 거울 이미지 트리가 만들어집니다.
```

**예시 2:**
```
입력: root = [6,4,11]
출력: [6,11,4]
설명: 루트 `6`의 왼쪽 자식 `4`와 오른쪽 자식 `11`이 서로 자리를 바꿉니다.
```

**예시 3:**
```
입력: root = [5]
출력: [5]
설명: 자식이 없는 단일 노드는 이미 자기 자신이 거울 이미지이므로 변하지 않습니다.
```$$,
 $$- 트리의 노드 개수는 `[0, 100]` 범위 안에 있습니다.
- `-100 <= Node.val <= 100`$$),

-- 8. deepest-skill-chain
((SELECT id FROM problems WHERE slug = 'deepest-skill-chain'), 'ko',
 $$가장 깊은 스킬 체인$$,
 $$RPG 스킬 트리가 루트 `root`를 시작으로 퍼크를 해금해 나가며 점점 더 깊은 스킬로 뻗어 갑니다. 트리의 **최대 깊이**, 즉 `root`에서 임의의 리프까지 내려가는 가장 긴 경로 위의 노드 수를 반환하세요. 빈 트리의 깊이는 `0`입니다.

**예시 1:**
```
입력: root = [8,5,12,null,null,9,17]
출력: 3
설명: 가장 긴 체인이 `8 -> 12 -> 9` 또는 `8 -> 12 -> 17`로 세 단계 깊이까지 이어집니다.
```

**예시 2:**
```
입력: root = [4,null,2,null,7]
출력: 3
설명: 체인 `4 -> 2 -> 7`이 세 노드로 이어지므로 깊이는 `3`입니다.
```$$,
 $$- 트리의 노드 개수는 `[0, 8000]` 범위 안에 있습니다.
- `-100 <= Node.val <= 100`$$),

-- 9. same-skill-trees
((SELECT id FROM problems WHERE slug = 'same-skill-trees'), 'ko',
 $$같은 스킬 트리 확인$$,
 $$두 플레이어가 각자 캐릭터의 스킬 트리를 이진 트리로 내보냈습니다. 두 내보낸 결과가 완전히 같은지 — 모양이 같고 모든 노드의 값도 같은지 — 확인해야 합니다.

두 스킬 트리의 루트 `p`와 `q`가 주어졌을 때, 모든 노드에서 일치하면 `true`, 그렇지 않으면 `false`를 반환하세요. 둘 중 어느 한 쪽이 비어 있을 수도 있습니다.

**예시 1:**
```
입력: p = [8,4,12], q = [8,4,12]
출력: true
설명: 두 트리가 모양도 같고 모든 노드의 값도 같으므로 동일한 트리입니다.
```

**예시 2:**
```
입력: p = [3,5], q = [3,null,5]
출력: false
설명: `p`에서는 `5`가 왼쪽 자식이지만 `q`에서는 오른쪽 자식이므로 모양이 달라 동일하지 않습니다.
```

**예시 3:**
```
입력: p = [6,2,9], q = [6,9,2]
출력: false
설명: 왼쪽 자식과 오른쪽 자식이 서로 뒤바뀌어 있으므로 두 트리는 일치하지 않습니다.
```$$,
 $$- 각 트리의 노드 개수는 `[0, 2 * 10^3]` 범위 안에 있습니다.
- `-10^8 <= Node.val <= 10^8`$$),

-- 10. find-submap
((SELECT id FROM problems WHERE slug = 'find-submap'), 'ko',
 $$서브맵 찾기$$,
 $$스터디 그룹이 마인드맵을 트리 형태로 정리했습니다. 메인 맵의 루트 `root`와 참고용 서브맵의 루트 `subRoot`가 주어졌을 때, `root`의 어떤 노드에서 시작한 서브트리가 `subRoot`와 모양과 값 모두 정확히 일치하면 `true`, 그렇지 않으면 `false`를 반환하세요. `root` 트리 자체도 자기 자신의 서브트리로 간주합니다.

**예시 1:**
```
입력: root = [9,6,7,2,4], subRoot = [6,2,4]
출력: true
설명: `root`의 왼쪽 자식 `6`에서 시작한 서브트리 `[6,2,4]`가 `subRoot`와 모양과 값 모두 일치합니다.
```

**예시 2:**
```
입력: root = [1,8,3,null,5], subRoot = [8,5]
출력: false
설명: `root` 안에 노드 `8`이 있지만 그 자식 `5`는 오른쪽에 매달려 있고 `subRoot`에서는 왼쪽에 있어, 모양이 어긋나므로 일치하지 않습니다.
```$$,
 $$- `root` 트리의 노드 개수는 `[1, 2000]` 범위 안에 있습니다.
- `subRoot` 트리의 노드 개수는 `[1, 900]` 범위 안에 있습니다.
- `-8000 <= root.val <= 8000`
- `-8000 <= subRoot.val <= 8000`$$);
