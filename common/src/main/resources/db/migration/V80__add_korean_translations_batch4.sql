-- Korean translations: batch 4 (problems #31-40)

------------------------------------------------------------
-- #31 level-traversal
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'level-traversal'),
    'ko',
    '레벨 순회',
    '이진 트리의 `root`가 주어졌을 때, **레벨 순서 순회** 결과를 2차원 배열로 반환하세요. 각 내부 배열에는 해당 깊이의 노드 값들이 왼쪽에서 오른쪽 순서로 담겨야 합니다.

레벨 순서 순회는 루트부터 시작하여, 다음 레벨로 넘어가기 전에 현재 레벨의 모든 노드를 방문합니다.

**예시 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: [[3],[9,20],[15,7]]
Explanation: 레벨 0에 노드 3, 레벨 1에 노드 9와 20, 레벨 2에 노드 15와 7이 있습니다.
```

**예시 2:**
```
Input: root = [1]
Output: [[1]]
```

**예시 3:**
```
Input: root = []
Output: []
```',
    '- `0 <= 트리의 노드 수 <= 2000`
- `-1000 <= Node.val <= 1000`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #32 bst-validator
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'bst-validator'),
    'ko',
    'BST 검증',
    '이진 트리의 `root`가 주어졌을 때, 유효한 **이진 탐색 트리**(BST)인지 판별하세요.

유효한 BST는 다음 조건을 모두 만족합니다:
- 왼쪽 서브트리의 모든 노드 값은 현재 노드 값보다 **작아야** 합니다.
- 오른쪽 서브트리의 모든 노드 값은 현재 노드 값보다 **커야** 합니다.
- 왼쪽과 오른쪽 서브트리 역시 각각 유효한 BST여야 합니다.

이 정의는 직속 자식뿐 아니라 트리 전체에 재귀적으로 적용됩니다.

**예시 1:**
```
Input: root = [2,1,3]
Output: true
Explanation: 왼쪽 자식 1은 2보다 작고, 오른쪽 자식 3은 2보다 큽니다.
```

**예시 2:**
```
Input: root = [5,1,4,null,null,3,6]
Output: false
Explanation: 루트 값이 5인데 오른쪽 자식 값이 4이므로 BST 조건을 위반합니다.
```',
    '- `1 <= 트리의 노드 수 <= 10^4`
- `-2^31 <= Node.val <= 2^31 - 1`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #33 bst-ancestor
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'bst-ancestor'),
    'ko',
    'BST 공통 조상',
    '**이진 탐색 트리**(BST)와 두 노드 `p`, `q`가 주어졌을 때, 이 둘의 **최소 공통 조상**(LCA)을 찾으세요.

최소 공통 조상이란 `p`와 `q`를 모두 자손으로 갖는 가장 깊은 노드입니다. 자기 자신도 자손으로 간주합니다.

BST의 정렬 특성을 활용할 수 있습니다. `p`와 `q`가 모두 현재 노드보다 작으면 LCA는 왼쪽 서브트리에, 둘 다 크면 오른쪽 서브트리에 있습니다. 그 외의 경우 현재 노드가 LCA입니다.

**예시 1:**
```
Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 8
Output: 6
Explanation: 노드 2와 8의 LCA는 6입니다.
```

**예시 2:**
```
Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 4
Output: 2
Explanation: 노드 2와 4의 LCA는 2입니다. 노드는 자기 자신의 자손이 될 수 있습니다.
```

**예시 3:**
```
Input: root = [2,1], p = 2, q = 1
Output: 2
```',
    '- `2 <= 트리의 노드 수 <= 10^5`
- `-10^9 <= Node.val <= 10^9`
- 모든 `Node.val`은 고유합니다.
- `p != q`
- `p`와 `q`는 BST에 반드시 존재합니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #34 all-subsets
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'all-subsets'),
    'ko',
    '모든 부분집합',
    '고유한 원소로 이루어진 정수 배열 `nums`가 주어졌을 때, 가능한 모든 **부분집합**(멱집합)을 반환하세요.

결과에 중복 부분집합이 포함되어서는 안 됩니다. 부분집합의 순서는 상관없습니다.

부분집합이란 배열에서 원소를 선택한 것으로, 빈 집합과 배열 전체도 포함됩니다.

**예시 1:**
```
Input: nums = [1,2,3]
Output: [[],[1],[1,2],[1,2,3],[1,3],[2],[2,3],[3]]
Explanation: 총 2^3 = 8개의 부분집합이 있으며, 빈 집합과 전체 배열을 포함합니다.
```

**예시 2:**
```
Input: nums = [0]
Output: [[],[0]]
```',
    '- `1 <= nums.length <= 10`
- `-10 <= nums[i] <= 10`
- `nums`의 모든 원소는 고유합니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #35 target-combinations
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'target-combinations'),
    'ko',
    '목표 조합',
    '서로 다른 정수로 이루어진 배열 `candidates`와 목표 정수 `target`이 주어졌을 때, 합이 `target`이 되는 모든 고유한 조합을 반환하세요. 조합의 순서는 상관없습니다.

`candidates`의 각 숫자는 **횟수 제한 없이** 사용할 수 있습니다. 선택한 숫자의 빈도가 하나라도 다르면 서로 다른 조합입니다.

**예시 1:**
```
Input: candidates = [2,3,6,7], target = 7
Output: [[2,2,3],[7]]
Explanation: 2 + 2 + 3 = 7, 7 = 7. 이 두 가지가 합이 target이 되는 유일한 조합입니다.
```

**예시 2:**
```
Input: candidates = [2,3,5], target = 8
Output: [[2,2,2,2],[2,3,3],[3,5]]
```

**예시 3:**
```
Input: candidates = [2], target = 1
Output: []
Explanation: 2의 조합으로는 합 1을 만들 수 없습니다.
```',
    '- `1 <= candidates.length <= 30`
- `2 <= candidates[i] <= 40`
- `candidates`의 모든 원소는 서로 다릅니다.
- `1 <= target <= 40`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #36 all-arrangements
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'all-arrangements'),
    'ko',
    '모든 순열',
    '서로 다른 정수로 이루어진 배열 `nums`가 주어졌을 때, 가능한 모든 **순열**을 반환하세요. 순서는 상관없습니다.

순열이란 배열의 모든 원소를 특정 순서로 나열한 것입니다. 길이가 `n`인 배열에는 정확히 `n!`(n 팩토리얼)개의 순열이 존재합니다.

**예시 1:**
```
Input: nums = [1,2,3]
Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
Explanation: 서로 다른 3개의 원소로 만들 수 있는 순열은 3! = 6개입니다.
```

**예시 2:**
```
Input: nums = [0,1]
Output: [[0,1],[1,0]]
```

**예시 3:**
```
Input: nums = [1]
Output: [[1]]
```',
    '- `1 <= nums.length <= 6`
- `-10 <= nums[i] <= 10`
- `nums`의 모든 원소는 고유합니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #37 island-counter
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'island-counter'),
    'ko',
    '섬 개수 세기',
    '`m x n` 크기의 2D 격자가 주어집니다. `"1"`은 땅, `"0"`은 물을 나타냅니다. **섬**의 개수를 반환하세요.

섬이란 **가로 또는 세로**로 연결된(대각선 제외) `"1"`들의 그룹입니다. 격자의 네 가장자리는 모두 물로 둘러싸여 있다고 가정합니다.

**예시 1:**
```
Input: grid = [
  ["1","1","1","1","0"],
  ["1","1","0","1","0"],
  ["1","1","0","0","0"],
  ["0","0","0","0","0"]
]
Output: 1
Explanation: 모든 땅 셀이 연결되어 하나의 섬을 이룹니다.
```

**예시 2:**
```
Input: grid = [
  ["1","1","0","0","0"],
  ["1","1","0","0","0"],
  ["0","0","1","0","0"],
  ["0","0","0","1","1"]
]
Output: 3
Explanation: 연결된 땅 그룹이 3개 있습니다.
```',
    '- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 300`
- `grid[i][j]`는 `''0''` 또는 `''1''`입니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #38 graph-copy
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'graph-copy'),
    'ko',
    '그래프 복제',
    '연결된 무방향 그래프의 한 노드에 대한 참조가 주어졌을 때, 그래프 전체의 **깊은 복사본**(클론)을 반환하세요.

각 노드는 정수 값과 이웃 노드 리스트를 갖습니다. 그래프는 인접 리스트로 표현되며, 각 인덱스가 하나의 노드에 대응하고 해당 리스트에 그 노드의 이웃들이 담겨 있습니다. 주어지는 노드는 항상 `val = 1`인 첫 번째 노드입니다.

복제된 그래프는 원본과 동일한 구조와 값을 가진 완전히 새로운 노드들로 구성되어야 합니다. 복제본의 어떤 노드도 원본 그래프의 노드를 참조해서는 안 됩니다.

**예시 1:**
```
Input: adjList = [[2,4],[1,3],[2,4],[1,3]]
Output: [[2,4],[1,3],[2,4],[1,3]]
Explanation: 노드 1은 노드 2, 4와 연결됩니다. 노드 2는 노드 1, 3과 연결됩니다. 복제본도 같은 구조를 갖습니다.
```

**예시 2:**
```
Input: adjList = [[]]
Output: [[]]
Explanation: 이웃이 없는 노드 하나로 이루어진 그래프입니다.
```

**예시 3:**
```
Input: adjList = []
Output: []
Explanation: 빈 그래프입니다(노드 없음).
```',
    '- `0 <= 그래프의 노드 수 <= 100`
- `1 <= Node.val <= 100`
- `Node.val`은 각 노드마다 고유합니다.
- 중복 간선과 자기 루프는 없습니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #39 course-planner
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'course-planner'),
    'ko',
    '수강 계획',
    '`0`부터 `numCourses - 1`까지 번호가 매겨진 `numCourses`개의 과목이 있습니다. 배열 `prerequisites`가 주어지며, `prerequisites[i] = [a, b]`는 과목 `a`를 수강하려면 과목 `b`를 먼저 이수해야 한다는 뜻입니다.

모든 과목을 이수할 수 있으면 `true`를, 아니면 `false`를 반환하세요.

이 문제는 본질적으로 사이클 탐지 문제입니다. 선수과목 그래프에 사이클이 있으면 모든 과목을 이수하는 것이 불가능합니다.

**예시 1:**
```
Input: numCourses = 2, prerequisites = [[1,0]]
Output: true
Explanation: 과목 0을 먼저 수강한 뒤 과목 1을 수강하면 됩니다.
```

**예시 2:**
```
Input: numCourses = 2, prerequisites = [[1,0],[0,1]]
Output: false
Explanation: 과목 1은 과목 0이 필요하고, 과목 0은 과목 1이 필요합니다. 순환 의존으로 인해 둘 다 이수할 수 없습니다.
```',
    '- `1 <= numCourses <= 2000`
- `0 <= prerequisites.length <= 5000`
- `prerequisites[i].length == 2`
- `0 <= a_i, b_i < numCourses`
- 모든 `prerequisites[i]` 쌍은 고유합니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #40 staircase
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'staircase'),
    'ko',
    '계단 오르기',
    '`n`개의 계단이 있는 계단을 오르고 있습니다. 한 번에 `1`계단 또는 `2`계단씩 오를 수 있습니다.

꼭대기에 도달하는 서로 다른 방법의 수를 반환하세요.

**예시 1:**
```
Input: n = 2
Output: 2
Explanation: 꼭대기에 오르는 방법은 두 가지입니다.
1. 1계단 + 1계단
2. 2계단
```

**예시 2:**
```
Input: n = 3
Output: 3
Explanation: 꼭대기에 오르는 방법은 세 가지입니다.
1. 1계단 + 1계단 + 1계단
2. 1계단 + 2계단
3. 2계단 + 1계단
```',
    '- `1 <= n <= 45`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;
