-- Korean translations: batch 7 (problems #61-70)

------------------------------------------------------------
-- #61 search-rotated-array
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'search-rotated-array'),
    'ko',
    '회전 배열 탐색',
    '**고유한** 값들로 이루어진 오름차순 정수 배열 `nums`가 특정 피벗 인덱스에서 회전되어 있습니다. `target` 값이 주어졌을 때, `nums`에서 `target`의 인덱스를 반환하세요. 존재하지 않으면 `-1`을 반환합니다.

예를 들어, 배열 `[0,1,2,4,5,6,7]`이 피벗 인덱스 3에서 회전되면 `[4,5,6,7,0,1,2]`가 됩니다.

알고리즘은 **O(log n)** 시간에 동작해야 합니다.

**예시 1:**
```
Input: nums = [4,5,6,7,0,1,2], target = 0
Output: 4
Explanation: 값 0은 회전된 배열에서 인덱스 4에 위치합니다.
```

**예시 2:**
```
Input: nums = [4,5,6,7,0,1,2], target = 3
Output: -1
Explanation: 값 3은 배열에 존재하지 않습니다.
```

**예시 3:**
```
Input: nums = [1], target = 0
Output: -1
```',
    '- `1 <= nums.length <= 5000`
- `-10^4 <= nums[i] <= 10^4`
- `nums`의 모든 값은 고유합니다.
- `nums`는 특정 피벗에서 회전되어 있음이 보장됩니다.
- `-10^4 <= target <= 10^4`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #62 koko-bananas
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'koko-bananas'),
    'ko',
    '바나나 먹기',
    '바나나 더미가 `n`개 있고, `i`번째 더미에는 `piles[i]`개의 바나나가 있습니다. 경비원은 `h`시간 후에 돌아옵니다.

시간당 `k`개의 바나나를 먹는 속도를 정할 수 있습니다. 매 시간마다 더미 하나를 골라 `k`개의 바나나를 먹습니다. 더미에 `k`개보다 적은 바나나가 남아 있으면 전부 먹고, 남은 시간은 아무것도 하지 않습니다.

`h`시간 안에 모든 바나나를 먹을 수 있는 최소 정수 `k`를 반환하세요.

**예시 1:**
```
Input: piles = [3,6,7,11], h = 8
Output: 4
Explanation: 속도 4일 때, 각 더미에 필요한 시간은 [1,2,2,3]이며, 총 8시간입니다.
```

**예시 2:**
```
Input: piles = [30,11,23,4,20], h = 5
Output: 30
Explanation: 5시간에 5개의 더미이므로 각 더미를 한 시간 안에 끝내야 합니다.
```

**예시 3:**
```
Input: piles = [30,11,23,4,20], h = 6
Output: 23
```',
    '- `1 <= piles.length <= 10^4`
- `piles.length <= h <= 10^9`
- `1 <= piles[i] <= 10^9`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #63 find-peak
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'find-peak'),
    'ko',
    '피크 원소 찾기',
    '**피크 원소**란 이웃한 원소들보다 순수하게 큰 원소를 말합니다.

0-indexed 정수 배열 `nums`가 주어졌을 때, 아무 피크 원소의 인덱스를 반환하세요.

`nums[-1]`과 `nums[n]`은 모두 음의 무한대라고 가정합니다. 즉, 경계에 있는 원소는 인접한 하나의 원소보다 크기만 하면 됩니다.

배열에 피크가 여러 개 있으면, 그중 아무 것이나 반환해도 됩니다.

알고리즘은 **O(log n)** 시간에 동작해야 합니다.

**예시 1:**
```
Input: nums = [1,2,3,1]
Output: 2
Explanation: 3이 피크 원소이므로 인덱스 2를 반환합니다.
```

**예시 2:**
```
Input: nums = [1,2,1,3,5,6,4]
Output: 5
Explanation: 인덱스 1(값 2) 또는 인덱스 5(값 6) 중 아무 것이나 반환할 수 있습니다.
```',
    '- `1 <= nums.length <= 1000`
- `-2^31 <= nums[i] <= 2^31 - 1`
- 모든 유효한 `i`에 대해 `nums[i] != nums[i + 1]`입니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #64 reorder-list
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'reorder-list'),
    'ko',
    '리스트 재정렬',
    '단일 연결 리스트의 head가 주어집니다. 노드가 `L0 -> L1 -> ... -> Ln-1 -> Ln`일 때, 다음과 같은 순서로 재정렬하세요:

`L0 -> Ln -> L1 -> Ln-1 -> L2 -> Ln-2 -> ...`

노드의 값은 변경할 수 없습니다. 노드의 연결만 재배치해야 합니다.

**예시 1:**
```
Input: head = [1,2,3,4]
Output: [1,4,2,3]
Explanation: 양쪽 끝에서 번갈아 연결합니다: 1->4->2->3.
```

**예시 2:**
```
Input: head = [1,2,3,4,5]
Output: [1,5,2,4,3]
Explanation: 앞과 뒤에서 번갈아 노드를 가져옵니다.
```',
    '- 노드의 수는 `[1, 5 * 10^4]` 범위입니다.
- `1 <= Node.val <= 1000`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #65 add-two-numbers
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'add-two-numbers'),
    'ko',
    '두 수 더하기',
    '음이 아닌 정수를 나타내는 두 개의 **비어 있지 않은** 연결 리스트가 주어집니다. 각 자릿수는 **역순**으로 저장되어 있으며, 각 노드에는 한 자리 숫자가 들어 있습니다.

두 수를 더한 결과를 같은 역순 형태의 연결 리스트로 반환하세요.

두 수 모두 `0` 자체를 제외하면 선행 0이 없다고 가정합니다.

**예시 1:**
```
Input: l1 = [2,4,3], l2 = [5,6,4]
Output: [7,0,8]
Explanation: 342 + 465 = 807.
```

**예시 2:**
```
Input: l1 = [0], l2 = [0]
Output: [0]
```

**예시 3:**
```
Input: l1 = [9,9,9,9,9,9,9], l2 = [9,9,9,9]
Output: [8,9,9,9,0,0,0,1]
```',
    '- 각 연결 리스트의 노드 수는 `[1, 100]` 범위입니다.
- `0 <= Node.val <= 9`
- 리스트가 나타내는 수에 선행 0이 없음이 보장됩니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #66 copy-random-list
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'copy-random-list'),
    'ko',
    '랜덤 포인터 리스트 복사',
    '길이 `n`인 연결 리스트가 주어지며, 각 노드에는 두 개의 포인터가 있습니다:

- `next` -- 리스트의 다음 노드를 가리킵니다 (없으면 `null`).
- `random` -- 리스트 내의 임의의 노드를 가리키거나, `null`입니다.

이 리스트의 **깊은 복사(deep copy)**를 만드세요. 복사본은 정확히 `n`개의 새로운 노드로 구성되어야 하며, 각 새 노드의 `next`와 `random` 포인터는 복사된 리스트의 노드만 가리켜야 합니다.

복사된 연결 리스트의 head를 반환하세요.

입력은 `[val, random_index]` 쌍의 배열로 표현되며, `random_index`는 `random` 포인터가 가리키는 노드의 0-based 인덱스이고, 가리키는 곳이 없으면 `null`입니다.

**예시 1:**
```
Input: head = [[7,null],[13,0],[11,4],[10,2],[1,0]]
Output: [[7,null],[13,0],[11,4],[10,2],[1,0]]
Explanation: 각 노드가 random 포인터를 유지한 채 복제됩니다.
```

**예시 2:**
```
Input: head = [[1,1],[2,1]]
Output: [[1,1],[2,1]]
```

**예시 3:**
```
Input: head = [[3,null],[3,0],[3,null]]
Output: [[3,null],[3,0],[3,null]]
```',
    '- `0 <= n <= 1000`
- `-10^4 <= Node.val <= 10^4`
- `Node.random`은 `null`이거나 연결 리스트 내의 특정 노드를 가리킵니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #67 merge-k-lists
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'merge-k-lists'),
    'ko',
    'K개 리스트 병합',
    '각각 오름차순으로 정렬된 `k`개의 연결 리스트 배열이 주어졌을 때, 모두 합쳐 하나의 정렬된 연결 리스트로 만들어 반환하세요.

**예시 1:**
```
Input: lists = [[1,4,5],[1,3,4],[2,6]]
Output: [1,1,2,3,4,4,5,6]
Explanation: 연결 리스트는 다음과 같습니다:
  1->4->5
  1->3->4
  2->6
하나로 합치면: 1->1->2->3->4->4->5->6
```

**예시 2:**
```
Input: lists = []
Output: []
```

**예시 3:**
```
Input: lists = [[]]
Output: []
```',
    '- `k == lists.length`
- `0 <= k <= 10^4`
- `0 <= lists[i].length <= 500`
- `-10^4 <= lists[i][j] <= 10^4`
- `lists[i]`는 오름차순으로 정렬되어 있습니다.
- `lists[i].length`의 총합은 `10^4`을 넘지 않습니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #68 kth-smallest-bst
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'kth-smallest-bst'),
    'ko',
    'BST에서 K번째 최솟값',
    '이진 탐색 트리의 `root`와 정수 `k`가 주어졌을 때, 트리의 모든 노드 값 중 `k`번째로 작은 값을 반환하세요.

`k`는 **1-indexed**입니다. 즉, `k = 1`이면 가장 작은 값, `k = 2`이면 두 번째로 작은 값을 의미합니다.

**예시 1:**
```
Input: root = [3,1,4,null,2], k = 1
Output: 1
Explanation: 중위 순회 결과는 [1,2,3,4]입니다. 1번째로 작은 값은 1입니다.
```

**예시 2:**
```
Input: root = [5,3,6,2,4,null,null,1], k = 3
Output: 3
Explanation: 중위 순회 결과는 [1,2,3,4,5,6]입니다. 3번째로 작은 값은 3입니다.
```',
    '- 트리의 노드 수는 `n`입니다.
- `1 <= k <= n <= 10^4`
- `0 <= Node.val <= 10^4`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #69 build-tree
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'build-tree'),
    'ko',
    '트리 구성',
    '두 정수 배열 `preorder`와 `inorder`가 주어졌을 때, 이를 바탕으로 이진 트리를 구성하여 반환하세요.

- `preorder`는 **전위 순회(preorder traversal)** 순서입니다 (루트, 왼쪽, 오른쪽).
- `inorder`는 **중위 순회(inorder traversal)** 순서입니다 (왼쪽, 루트, 오른쪽).

두 배열의 길이는 같으며, 모든 값은 고유합니다.

**예시 1:**
```
Input: preorder = [3,9,20,15,7], inorder = [9,3,15,20,7]
Output: [3,9,20,null,null,15,7]
Explanation: 루트는 3이고, 왼쪽 서브트리는 [9], 오른쪽 서브트리는 [20,15,7]입니다.
```

**예시 2:**
```
Input: preorder = [-1], inorder = [-1]
Output: [-1]
```',
    '- `1 <= preorder.length <= 3000`
- `inorder.length == preorder.length`
- `-3000 <= preorder[i], inorder[i] <= 3000`
- `preorder`와 `inorder`의 값은 모두 고유합니다.
- `inorder`의 각 값은 `preorder`에도 존재합니다.
- `preorder`는 트리의 전위 순회 결과임이 보장됩니다.
- `inorder`는 트리의 중위 순회 결과임이 보장됩니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #70 right-side-view
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'right-side-view'),
    'ko',
    '오른쪽에서 본 트리',
    '이진 트리의 `root`가 주어졌을 때, 트리의 **오른쪽**에 서서 왼쪽을 바라본다고 상상해 보세요.

위에서 아래로, 각 레벨에서 보이는 가장 오른쪽 노드의 값을 반환하세요.

**예시 1:**
```
Input: root = [1,2,3,null,5,null,4]
Output: [1,3,4]
Explanation: 레벨 0에서는 노드 1, 레벨 1에서는 노드 3, 레벨 2에서는 노드 4가 보입니다.
```

**예시 2:**
```
Input: root = [1,null,3]
Output: [1,3]
```

**예시 3:**
```
Input: root = []
Output: []
```',
    '- 트리의 노드 수는 `[0, 100]` 범위입니다.
- `-100 <= Node.val <= 100`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;
