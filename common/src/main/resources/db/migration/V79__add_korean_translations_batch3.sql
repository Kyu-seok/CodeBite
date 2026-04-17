-- Korean translations: batch 3 (problems #21-30)

------------------------------------------------------------
-- #21 matrix-search
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'matrix-search'),
    'ko',
    '행렬 탐색',
    '`m x n` 정수 행렬과 정수 `target`이 주어집니다. 행렬에 `target`이 존재하는지 판별하세요. 이 행렬은 다음과 같은 특성을 가집니다:

- 각 행은 오름차순으로 정렬되어 있습니다.
- 각 행의 첫 번째 값은 이전 행의 마지막 값보다 큽니다.

즉, 행렬을 왼쪽에서 오른쪽으로, 위에서 아래로 읽으면 하나의 정렬된 수열이 됩니다.

`O(log(m * n))` 시간 복잡도로 풀어야 합니다.

**예시 1:**
```
Input: matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 3
Output: true
Explanation: 첫 번째 행에 3이 존재합니다.
```

**예시 2:**
```
Input: matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 13
Output: false
Explanation: 행렬 어디에도 13이 존재하지 않습니다.
```',
    '- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= m, n <= 100`
- `-10^4 <= matrix[i][j], target <= 10^4`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #22 rotated-array-min
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'rotated-array-min'),
    'ko',
    '회전 배열의 최솟값',
    '오름차순으로 정렬된 길이 `n`의 배열이 `1`~`n`번 **회전**되었습니다. 회전은 모든 원소를 오른쪽으로 한 칸씩 밀고, 마지막 원소를 맨 앞으로 보내는 연산입니다. 예를 들어, `[0,1,2,4,5,6,7]`을 4번 회전하면 `[4,5,6,7,0,1,2]`가 됩니다.

고유한 원소로 이루어진 회전 배열 `nums`가 주어졌을 때, 최솟값을 반환하세요.

`O(log n)` 시간 복잡도로 풀어야 합니다.

**예시 1:**
```
Input: nums = [3,4,5,1,2]
Output: 1
Explanation: 원래 배열은 [1,2,3,4,5]이며 3번 회전되었습니다.
```

**예시 2:**
```
Input: nums = [4,5,6,7,0,1,2]
Output: 0
```

**예시 3:**
```
Input: nums = [11,13,15,17]
Output: 11
Explanation: 회전이 이루어지지 않은 배열입니다.
```',
    '- `n == nums.length`
- `1 <= n <= 5000`
- `-5000 <= nums[i] <= 5000`
- `nums`의 모든 원소는 고유합니다.
- `nums`는 정렬된 상태에서 `1`~`n`번 회전된 배열입니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #23 reverse-list
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'reverse-list'),
    'ko',
    '리스트 뒤집기',
    '단일 연결 리스트의 `head`가 주어졌을 때, 리스트를 뒤집고 새로운 head를 반환하세요.

기존 노드의 연결을 변경하여 in-place로 뒤집어야 합니다.

**예시 1:**
```
Input: head = [1,2,3,4,5]
Output: [5,4,3,2,1]
Explanation: 1->2->3->4->5가 5->4->3->2->1이 됩니다.
```

**예시 2:**
```
Input: head = [1,2]
Output: [2,1]
```

**예시 3:**
```
Input: head = []
Output: []
```',
    '- 리스트의 노드 수는 `[0, 5000]` 범위입니다.
- `-5000 <= Node.val <= 5000`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #24 merge-sorted-lists
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'merge-sorted-lists'),
    'ko',
    '정렬 리스트 병합',
    '정렬된 두 연결 리스트 `list1`과 `list2`의 head가 주어집니다. 두 리스트를 하나의 정렬된 리스트로 병합하세요.

두 입력 리스트의 노드를 이어 붙여 새 리스트를 만들어야 합니다. 병합된 연결 리스트의 head를 반환하세요.

**예시 1:**
```
Input: list1 = [1,2,4], list2 = [1,3,4]
Output: [1,1,2,3,4,4]
Explanation: 1->2->4와 1->3->4를 병합하면 1->1->2->3->4->4가 됩니다.
```

**예시 2:**
```
Input: list1 = [], list2 = []
Output: []
```

**예시 3:**
```
Input: list1 = [], list2 = [0]
Output: [0]
Explanation: list1이 비어 있으므로 결과는 list2 그대로입니다.
```',
    '- 두 리스트의 노드 수는 각각 `[0, 50]` 범위입니다.
- `-100 <= Node.val <= 100`
- `list1`과 `list2`는 오름차순으로 정렬되어 있습니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #25 cycle-detection
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'cycle-detection'),
    'ko',
    '순환 감지',
    '연결 리스트의 `head`가 주어졌을 때, 리스트에 **순환**이 있는지 판별하세요.

순환이란 어떤 노드의 `next` 포인터가 이전 노드를 다시 가리켜서, `next`를 계속 따라가면 같은 노드에 다시 도달하는 경우를 말합니다. `pos`는 꼬리 노드의 `next`가 연결되는 노드의 인덱스(0-based)를 나타내며, 설명용으로만 제공될 뿐 실제 매개변수로 전달되지는 않습니다.

순환이 있으면 `true`, 없으면 `false`를 반환하세요.

**예시 1:**
```
Input: head = [3,2,0,-4], pos = 1
Output: true
Explanation: 꼬리 노드가 인덱스 1의 노드에 연결되어 순환이 존재합니다.
```

**예시 2:**
```
Input: head = [1,2], pos = 0
Output: true
Explanation: 꼬리 노드가 인덱스 0의 노드에 연결되어 순환이 존재합니다.
```

**예시 3:**
```
Input: head = [1], pos = -1
Output: false
Explanation: 순환이 없는 연결 리스트입니다.
```',
    '- 리스트의 노드 수는 `[0, 10^4]` 범위입니다.
- `-10^5 <= Node.val <= 10^5`
- `pos`는 `-1`이거나 연결 리스트의 유효한 인덱스입니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #26 remove-from-end
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'remove-from-end'),
    'ko',
    '끝에서 N번째 노드 제거',
    '연결 리스트의 `head`가 주어졌을 때, 끝에서 `n`번째 노드를 제거하고 head를 반환하세요.

**예시 1:**
```
Input: head = [1,2,3,4,5], n = 2
Output: [1,2,3,5]
Explanation: 끝에서 2번째 노드는 4입니다. 제거하면 1->2->3->5가 됩니다.
```

**예시 2:**
```
Input: head = [1], n = 1
Output: []
Explanation: 유일한 노드를 제거하면 빈 리스트가 됩니다.
```

**예시 3:**
```
Input: head = [1,2], n = 1
Output: [1]
```',
    '- 리스트의 노드 수는 `sz`입니다.
- `1 <= sz <= 30`
- `0 <= Node.val <= 100`
- `1 <= n <= sz`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #27 mirror-tree
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'mirror-tree'),
    'ko',
    '트리 뒤집기',
    '이진 트리의 `root`가 주어졌을 때, 트리를 **반전**하고 루트를 반환하세요.

이진 트리를 반전한다는 것은 모든 노드의 왼쪽 자식과 오른쪽 자식을 재귀적으로 교환하여 원래 트리의 거울 이미지를 만드는 것입니다.

**예시 1:**
```
Input: root = [4,2,7,1,3,6,9]
Output: [4,7,2,9,6,3,1]
Explanation: 모든 왼쪽-오른쪽 자식 쌍이 교환됩니다. 값 2의 노드가 오른쪽으로, 값 7의 노드가 왼쪽으로 이동합니다.
```

**예시 2:**
```
Input: root = [2,1,3]
Output: [2,3,1]
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

------------------------------------------------------------
-- #28 tree-depth
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'tree-depth'),
    'ko',
    '트리의 최대 깊이',
    '이진 트리의 `root`가 주어졌을 때, **최대 깊이**를 반환하세요.

최대 깊이란 루트 노드에서 가장 먼 리프 노드까지의 경로에 포함된 노드의 수입니다. 리프 노드는 자식이 없는 노드를 말합니다.

**예시 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: 3
Explanation: 가장 긴 경로는 root(3) -> right(20) -> left(15) 또는 root(3) -> right(20) -> right(7)이며, 둘 다 노드 3개입니다.
```

**예시 2:**
```
Input: root = [1,null,2]
Output: 2
Explanation: 루트에 왼쪽 자식이 없습니다. root(1) -> right(2) 경로의 노드 수는 2개입니다.
```',
    '- 트리의 노드 수는 `[0, 10^4]` 범위입니다.
- `-100 <= Node.val <= 100`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #29 identical-trees
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'identical-trees'),
    'ko',
    '동일한 트리',
    '두 이진 트리의 루트 `p`와 `q`가 주어졌을 때, 두 트리가 **동일한지** 판별하세요.

두 트리가 동일하다는 것은 구조가 같고 모든 대응하는 노드의 값이 같다는 의미입니다.

**예시 1:**
```
Input: p = [1,2,3], q = [1,2,3]
Output: true
Explanation: 두 트리의 구조와 모든 노드의 값이 같습니다.
```

**예시 2:**
```
Input: p = [1,2], q = [1,null,2]
Output: false
Explanation: 트리 p에서 2는 루트의 왼쪽 자식이고, 트리 q에서 2는 오른쪽 자식입니다. 구조가 다릅니다.
```

**예시 3:**
```
Input: p = [1,2,1], q = [1,1,2]
Output: false
Explanation: 구조는 같지만 노드 값이 다릅니다. 트리 p는 왼쪽 자식 2, 오른쪽 자식 1이고, 트리 q는 왼쪽 자식 1, 오른쪽 자식 2입니다.
```',
    '- 두 트리의 노드 수는 각각 `[0, 100]` 범위입니다.
- `-10^4 <= Node.val <= 10^4`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #30 tree-within-tree
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'tree-within-tree'),
    'ko',
    '트리 속 트리',
    '두 이진 트리 `root`와 `subRoot`의 루트가 주어졌을 때, `subRoot`가 `root`의 **서브트리**인지 판별하세요.

이진 트리의 서브트리란 트리의 한 노드와 그 노드의 모든 자손을 포함하는 트리입니다. `root` 자체도 자신의 유효한 서브트리입니다. 두 서브트리가 일치하려면 구조가 같고 모든 대응하는 노드의 값이 같아야 합니다.

**예시 1:**
```
Input: root = [3,4,5,1,2], subRoot = [4,1,2]
Output: true
Explanation: root의 왼쪽 서브트리(노드 4를 루트로 하는)가 subRoot와 정확히 일치합니다.
```

**예시 2:**
```
Input: root = [3,4,5,1,2,null,null,null,null,0], subRoot = [4,1,2]
Output: false
Explanation: root에서 노드 4의 서브트리에는 노드 2 아래에 추가 자식(노드 0)이 있어 subRoot와 일치하지 않습니다.
```',
    '- `root` 트리의 노드 수는 `[1, 2000]` 범위입니다.
- `subRoot` 트리의 노드 수는 `[1, 1000]` 범위입니다.
- `-10^4 <= root.val <= 10^4`
- `-10^4 <= subRoot.val <= 10^4`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;
