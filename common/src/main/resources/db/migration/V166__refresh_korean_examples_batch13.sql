-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 13 (problems #121-#130)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (root, p, q, jobs, target, n)
-- and structural tokens (TreeNode, Node.val, null, true, false, void) stay
-- verbatim. The first mention of each variable in Korean prose is paired
-- with a Korean noun phrase describing its role. Constraint identifiers
-- align with the canonical English parameter names from the latest source
-- migrations (V137 for balanced-hamster-tree and flatten-agenda-tree, V152
-- for the four originally over-themed tree problems, V135 for the rest).

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'binary-tree-codec', 'count-top-heroes', 'balanced-hamster-tree',
      'zigzag-yearbook-order', 'list-skill-build-paths',
      'populating-next-pointers', 'sum-root-to-leaf', 'flatten-agenda-tree',
      'lca-binary-tree', 'task-cooldown-planner'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. binary-tree-codec
((SELECT id FROM problems WHERE slug = 'binary-tree-codec'), 'ko',
 $$이진 트리 직렬화와 역직렬화$$,
 $$다음 두 메서드를 가진 `Codec` 클래스를 설계하세요:

- `String serialize(TreeNode root)` — 이진 트리를 문자열로 변환합니다.
- `TreeNode deserialize(String data)` — 그런 문자열에서 트리를 복원합니다.

직렬화 형식은 자유롭게 정해도 됩니다. 채점기는 각 입력 트리에 대해 `deserialize(serialize(root))`를 호출하고, 복원된 트리가 원본과 구조적으로 동일한지 확인합니다.

노드 값은 32비트 정수 범위 안의 어떤 값이든 가능하며, 트리는 비어 있을 수도 있습니다(`root = null`).

**예시 1:**
```
입력: root = [1,2,3,null,null,4,5]
출력: [1,2,3,null,null,4,5]
설명: 직렬화된 문자열의 형식은 자유롭게 달라질 수 있고, 왕복 후 복원된 트리만 원본과 일치하면 됩니다.
```

**예시 2:**
```
입력: root = []
출력: []
설명: 빈 트리는 그대로 빈 트리로 복원되어야 합니다.
```$$,
 $$- 트리의 노드 개수는 `[0, 10000]` 범위 안에 있습니다.
- `-1000 <= Node.val <= 1000`$$),

-- 2. count-top-heroes
((SELECT id FROM problems WHERE slug = 'count-top-heroes'), 'ko',
 $$최고점 영웅 세기$$,
 $$던전 크롤러의 파티 트리에서 각 노드는 영웅의 피해량을 저장합니다. 루트에서 어떤 영웅까지 내려가는 경로 위에 그보다 **엄격히** 더 큰 값을 가진 영웅이 없다면, 그 영웅을 **우세하다(dominant)**고 합니다. 루트는 항상 우세한 것으로 칩니다.

파티 트리의 `root`가 주어질 때, 우세한 영웅의 수를 반환하는 `tallyDominantBlocks(root)`를 구현하세요.

**예시 1:**
```
입력: root = [4,2,6,5,1,null,7]
출력: 4
설명: 루트인 영웅 4는 항상 우세합니다. 영웅 5는 경로상 최대 조상 4를 이깁니다. 영웅 6도 최대 조상 4를 이깁니다. 영웅 7은 최대 조상 6을 이깁니다. 영웅 2와 1은 모두 4에 가려져 우세하지 않습니다.
```

**예시 2:**
```
입력: root = [5,3,5,2,4]
출력: 2
설명: 루트 5는 우세합니다. 오른쪽 자식 5는 조상 5와 동률이지만 우세에 포함됩니다. 왼쪽 서브트리의 영웅 3, 2, 4는 모두 루트 5에 가려집니다.
```

**예시 3:**
```
입력: root = [7]
출력: 1
설명: 영웅이 한 명뿐일 때는 항상 우세합니다.
```$$,
 $$- 트리의 노드 개수는 `[1, 2 * 10^5]` 범위 안에 있습니다.
- `-10^8 <= Node.val <= 10^8`$$),

-- 3. balanced-hamster-tree
((SELECT id FROM problems WHERE slug = 'balanced-hamster-tree'), 'ko',
 $$햄스터 가계도 균형 검사$$,
 $$펫샵 햄스터 가계도가 이진 트리로 저장되어 있습니다. 이 트리가 균형 잡혀 있는지 확인하세요.

`root`가 주어졌을 때, 모든 노드에서 왼쪽 서브트리와 오른쪽 서브트리의 높이 차가 1 이하이면 `true`를 반환하세요. 빈 트리는 균형 잡힌 것으로 간주합니다.

**예시 1:**
```
입력: root = [5,2,8,1,null,null,11]
출력: true
설명: 모든 노드에서 왼쪽과 오른쪽 서브트리의 높이 차가 1 이하입니다.
```

**예시 2:**
```
입력: root = [1,2,null,3,null,4]
출력: false
설명: 트리가 1->2->3->4로 왼쪽으로만 늘어져 있어, 루트의 왼쪽 서브트리 높이는 3인데 오른쪽 서브트리 높이는 0입니다.
```

**예시 3:**
```
입력: root = [1,2]
출력: true
설명: 자식이 한 쪽에 하나만 있는 루트는 좌우 높이 차가 정확히 1이라 여전히 균형입니다.
```$$,
 $$- 트리의 노드 개수는 `[0, 2 * 10^3]` 범위 안에 있습니다.
- `-10^8 <= Node.val <= 10^8`$$),

-- 4. zigzag-yearbook-order
((SELECT id FROM problems WHERE slug = 'zigzag-yearbook-order'), 'ko',
 $$지그재그로 줄 서기$$,
 $$졸업 앨범 사진을 찍으려고 반 친구들이 이진 트리 모양으로 줄을 섰습니다. 사진사는 이름을 한 줄씩 읽는데, 줄마다 방향을 번갈아 뒤집어서 부릅니다.

`root`가 주어지면, 각 레벨의 노드 값을 지그재그 순서로 묶어 반환하세요. 맨 윗줄은 왼쪽에서 오른쪽으로, 그 다음 줄은 오른쪽에서 왼쪽으로, 또 그 다음 줄은 다시 왼쪽에서 오른쪽으로 진행합니다. 각 레벨은 내부 리스트이고 바깥 리스트는 위에서 아래 순서이며, 트리가 비어 있으면 빈 리스트를 반환합니다.

**예시 1:**
```
입력: root = [5,3,7,2,9,6,8]
출력: [[5],[7,3],[2,9,6,8]]
설명: 0번째 줄은 왼쪽에서 오른쪽으로 [5], 1번째 줄은 오른쪽에서 왼쪽으로 [7,3], 2번째 줄은 다시 왼쪽에서 오른쪽으로 [2,9,6,8]이 됩니다.
```

**예시 2:**
```
입력: root = [4]
출력: [[4]]
설명: 학생이 한 명뿐일 때는 그 한 명만으로 한 줄을 차지합니다.
```$$,
 $$- 트리의 노드 개수는 `[0, 2 * 10^3]` 범위 안에 있습니다.
- `-100 <= Node.val <= 100`$$),

-- 5. list-skill-build-paths
((SELECT id FROM problems WHERE slug = 'list-skill-build-paths'), 'ko',
 $$스킬 빌드 경로 나열$$,
 $$각 노드에 XP 값이 들어 있는 RPG 스킬 트리가 `root`를 루트로 주어집니다. 노드 값의 합이 정확히 `target`이 되는 루트에서 리프까지의 모든 경로를 반환하세요.

각 경로는 위에서 아래 순서대로 노드 값을 담은 리스트입니다. **리프**는 자식이 없는 노드를 말하며, 경로는 왼쪽 우선 DFS가 찾는 순서대로 나열합니다.

**예시 1:**
```
입력: root = [10,6,9,3,null,4,5,null,null,8,2], target = 19
출력: [[10,6,3]]
설명: 합이 19가 되는 루트-리프 경로는 10 -> 6 -> 3 하나뿐입니다.
```

**예시 2:**
```
입력: root = [7,2,4,null,5,1,3], target = 14
출력: [[7,2,5],[7,4,3]]
설명: 합이 14가 되는 두 갈래 경로 7 + 2 + 5와 7 + 4 + 3이 있습니다.
```$$,
 $$- 트리의 노드 개수는 `[0, 4500]` 범위 안에 있습니다.
- `-1000 <= Node.val <= 1000`
- `-1000 <= target <= 1000`$$),

-- 6. populating-next-pointers
((SELECT id FROM problems WHERE slug = 'populating-next-pointers'), 'ko',
 $$다음 오른쪽 포인터 연결$$,
 $$**완전한** 이진 트리(perfect binary tree)의 `root`가 주어집니다. 모든 부모는 두 자식을 가지며, 모든 잎은 같은 깊이에 있습니다. 각 노드는 `val`, `left`, `right`, `next` 필드를 갖고, 처음에는 모든 `next`가 null입니다.

각 노드의 `next`가 같은 레벨에서 바로 오른쪽에 있는 노드를 가리키도록 설정하세요. 같은 레벨에 오른쪽 노드가 없으면(레벨의 가장 오른쪽 노드면) `next`는 null로 남깁니다. 변경된 `root`를 반환합니다.

**예시 1:**
```
입력: root = [1,2,3,4,5,6,7]
출력: [1,#,2,3,#,4,5,6,7,#]
설명: "#" 표시는 next 포인터가 붙은 레벨 순서 직렬화에서 각 레벨의 끝을 구분합니다. 1은 오른쪽 이웃이 없고, 2 → 3, 4 → 5 → 6 → 7로 next가 이어집니다.
```

**예시 2:**
```
입력: root = []
출력: []
설명: 빈 트리에는 연결할 노드가 없으므로 결과도 비어 있습니다.
```$$,
 $$- 트리의 노드 개수는 `[1, 4096]` 범위 안에 있습니다.
- `-1000 <= Node.val <= 1000`
- 입력 트리는 완전한 이진 트리(perfect binary tree)임이 보장됩니다.$$),

-- 7. sum-root-to-leaf
((SELECT id FROM problems WHERE slug = 'sum-root-to-leaf'), 'ko',
 $$루트에서 리프까지의 수 합$$,
 $$이진 트리의 각 노드는 `0`–`9` 사이의 한 자리 숫자를 담고 있습니다. 루트에서 잎까지 가는 경로의 노드 값을 위에서 아래로 이어 붙이면 음이 아닌 정수 한 개가 만들어집니다. 예를 들어 `4 → 9 → 5` 경로는 `495`를 나타냅니다.

`root`가 주어졌을 때, 모든 루트-잎 경로가 나타내는 정수의 합을 반환하세요. 트리의 노드 수는 많아야 수천 개이고, 합은 32비트 정수 범위 안에 들어갑니다.

**예시 1:**
```
입력: root = [1,2,3]
출력: 25
설명: 경로 1→2와 1→3은 각각 12와 13을 나타냅니다. 12 + 13 = 25입니다.
```

**예시 2:**
```
입력: root = [4,9,0,5,1]
출력: 1026
설명: 세 갈래 경로가 각각 495, 491, 40을 나타내며 합은 1026입니다.
```$$,
 $$- 트리의 노드 개수는 `[1, 1000]` 범위 안에 있습니다.
- `0 <= Node.val <= 9`
- 모든 루트-잎 경로가 나타내는 수의 합은 32비트 정수 범위 안에 들어갑니다.$$),

-- 8. flatten-agenda-tree
((SELECT id FROM problems WHERE slug = 'flatten-agenda-tree'), 'ko',
 $$일정 트리 펼치기$$,
 $$회의 안건이 이진 트리 `root`에 저장되어 있습니다. 이를 **전위 순회** 순서로 오른쪽만 가리키는 하나의 사슬로 제자리에서 펼치세요. 즉, 모든 노드의 `left`는 `null`이 되고, `right`는 전위 순회 순서상 다음 노드를 가리켜야 합니다.

루트는 그대로 유지되며 반환 타입은 `void`입니다. 채점기는 루트에서부터 `right` 포인터를 따라가며 결과를 확인합니다.

**예시 1:**
```
입력: root = [7,3,9,1,4,null,12]
출력: [7,3,1,4,9,12]
설명: 입력의 전위 순회 순서는 7, 3, 1, 4, 9, 12입니다. 펼친 뒤에는 각 노드가 right 포인터로 다음 노드에 연결되고, 모든 left 포인터는 null이 됩니다.
```

**예시 2:**
```
입력: root = [1]
출력: [1]
설명: 안건이 하나뿐이면 그대로 한 노드짜리 사슬이 됩니다.
```

**예시 3:**
```
입력: root = [5]
출력: [5]
설명: 노드가 하나뿐이라 펼친 결과도 그 노드 한 개로 끝납니다.
```$$,
 $$- 트리의 노드 개수는 `[0, 2 * 10^3]` 범위 안에 있습니다.
- `-10^8 <= Node.val <= 10^8`$$),

-- 9. lca-binary-tree
((SELECT id FROM problems WHERE slug = 'lca-binary-tree'), 'ko',
 $$이진 트리의 최소 공통 조상$$,
 $$일반 이진 트리(BST일 필요 없음)의 `root`와 트리 안에 존재하는 두 노드 `p`, `q`가 주어졌을 때, `p`와 `q`의 최소 공통 조상(LCA)을 반환하세요.

LCA란 `p`와 `q`를 모두 서브트리에 포함하는 노드 중 가장 깊은 노드를 뜻하며, 노드는 자기 자신을 자손으로 칠 수 있습니다. 모든 노드 값은 서로 다릅니다.

**예시 1:**
```
입력: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1
출력: 3
설명: 5와 1은 3의 서로 다른 서브트리에 속하므로, 두 노드를 모두 포함하는 가장 깊은 노드는 3입니다.
```

**예시 2:**
```
입력: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4
출력: 5
설명: 4는 5를 루트로 하는 서브트리 안에 있고, 노드는 자기 자신을 자손으로 칠 수 있으므로 LCA는 5입니다.
```$$,
 $$- 트리의 노드 개수는 `[2, 9000]` 범위 안에 있습니다.
- `|Node.val| <= 10^8`
- 모든 `Node.val`은 서로 다릅니다.
- `p != q`
- `p`와 `q`는 모두 트리에 존재합니다.$$),

-- 10. task-cooldown-planner
((SELECT id FROM problems WHERE slug = 'task-cooldown-planner'), 'ko',
 $$작업 쿨다운 스케줄러$$,
 $$사무실 공용 프린터는 한 슬롯에 작업을 하나씩만 처리하고, 각 작업에는 보낸 사람의 라벨이 붙어 있습니다. 같은 라벨의 작업은 `n` 슬롯 이내에 다시 돌릴 수 없으며, 각 슬롯은 작업을 하나 인쇄하거나 그냥 비워 둘 수 있고 작업 순서는 자유롭게 정할 수 있습니다.

작업 라벨 배열 `jobs`와 정수 `n`이 주어졌을 때, 쿨다운 규칙을 지키면서 모든 작업을 인쇄하는 데 필요한 최소 슬롯 수를 반환하세요.

**예시 1:**
```
입력: jobs = ["P","P","P","P","Q","Q"], n = 3
출력: 13
설명: 한 가지 유효한 스케줄은 P -> Q -> 휴 -> 휴 -> P -> Q -> 휴 -> 휴 -> P -> 휴 -> 휴 -> 휴 -> P이며, 모두 13 슬롯을 사용합니다.
```

**예시 2:**
```
입력: jobs = ["A","B","C","A","B","D"], n = 1
출력: 6
설명: A -> B -> C -> A -> B -> D 순서가 이미 같은 라벨을 1 슬롯 이상 띄워 주므로 빈 슬롯이 전혀 필요 없습니다.
```$$,
 $$- `1 <= jobs.length <= 2 * 10^3`
- `jobs[i]`는 영어 대문자입니다.
- `0 <= n <= 100`$$);
