-- Korean translations: batch 13 (problems #121-130)

------------------------------------------------------------
-- #121 tree-codec (Tree Codec)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'tree-codec'),
    'ko',
    '트리 직렬화',
    '이진 트리를 문자열로 직렬화(serialize)하고, 그 문자열을 다시 원래 트리로 역직렬화(deserialize)하는 알고리즘을 설계하세요.

`Codec` 클래스에 다음 두 메서드를 구현하세요:

- `serialize(root)` -- 이진 트리를 하나의 문자열로 변환합니다.
- `deserialize(data)` -- `serialize`가 생성한 문자열로부터 이진 트리를 복원합니다.

인코딩 형식은 자유롭게 정할 수 있습니다. `deserialize(serialize(root))`의 결과가 원래 트리와 구조적으로 동일하고 같은 노드 값을 가지기만 하면 됩니다.

**예시 1:**
```
Input: root = [1,2,3,null,null,4,5]
Output: [1,2,3,null,null,4,5]
Explanation: 트리를 직렬화한 뒤 역직렬화하면 동일한 구조가 됩니다.
```

**예시 2:**
```
Input: root = []
Output: []
Explanation: 빈 트리는 직렬화와 역직렬화 후에도 빈 트리입니다.
```

**예시 3:**
```
Input: root = [1]
Output: [1]
Explanation: 노드가 하나인 트리도 정상적으로 변환됩니다.
```',
    '- 노드 수의 범위는 `[0, 10000]`입니다
- `-1000 <= Node.val <= 1000`'
);

------------------------------------------------------------
-- #122 good-node-count (Good Node Count)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'good-node-count'),
    'ko',
    '좋은 노드 수',
    '이진 트리의 `root`가 주어졌을 때, **좋은 노드**의 개수를 구하세요.

루트에서 해당 노드까지의 경로에 있는 모든 조상 노드의 값이 해당 노드의 값보다 크지 않으면, 그 노드는 **좋은 노드**입니다. 즉, 자신의 값이 모든 조상의 값 이상이면 좋은 노드입니다. 루트 노드는 조상이 없으므로 항상 좋은 노드입니다.

**예시 1:**
```
Input: root = [3,1,4,3,null,1,5]
Output: 4
Explanation: 좋은 노드는 3(루트), 4, 3(왼쪽-왼쪽 손자), 5입니다. 노드 1(루트의 왼쪽 자식)은 조상 3 > 1이므로 좋은 노드가 아닙니다. 노드 1(4의 왼쪽 자식)도 4 > 1이므로 좋은 노드가 아닙니다.
```

**예시 2:**
```
Input: root = [3,3,null,4,2]
Output: 3
Explanation: 3(루트), 3(왼쪽 자식), 4가 좋은 노드입니다. 노드 2는 조상 3 > 2이므로 좋은 노드가 아닙니다.
```

**예시 3:**
```
Input: root = [1]
Output: 1
Explanation: 루트 노드는 항상 좋은 노드입니다.
```',
    '- 트리의 노드 수 범위는 `[1, 10^5]`입니다
- 각 노드의 값은 `-10^4`에서 `10^4` 사이입니다'
);

------------------------------------------------------------
-- #123 height-check (Height Check)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'height-check'),
    'ko',
    '높이 균형 검사',
    '이진 트리의 `root`가 주어졌을 때, 트리가 **높이 균형** 상태인지 판별하세요.

이진 트리가 높이 균형이란, 모든 노드에서 왼쪽 서브트리와 오른쪽 서브트리의 높이 차이가 최대 `1`인 경우를 말합니다.

빈 트리는 균형 상태로 간주합니다.

**예시 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: true
Explanation: 왼쪽 서브트리의 높이는 1, 오른쪽 서브트리의 높이는 2입니다. 모든 노드에서 높이 차이가 최대 1입니다.
```

**예시 2:**
```
Input: root = [1,2,2,3,3,null,null,4,4]
Output: false
Explanation: 왼쪽 서브트리의 높이는 3이고 오른쪽 서브트리의 높이는 1입니다.
```

**예시 3:**
```
Input: root = []
Output: true
Explanation: 빈 트리는 균형 상태로 간주합니다.
```',
    '- `0 <= 노드 수 <= 5000`
- `-10^4 <= Node.val <= 10^4`'
);

------------------------------------------------------------
-- #124 zigzag-levels (Zigzag Levels)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'zigzag-levels'),
    'ko',
    '지그재그 레벨 순회',
    '이진 트리의 `root`가 주어졌을 때, 노드 값을 레벨별로 **지그재그** 순서로 묶어 반환하세요.

지그재그 순서란 첫 번째 레벨(루트)은 왼쪽에서 오른쪽으로, 두 번째 레벨은 오른쪽에서 왼쪽으로, 세 번째 레벨은 다시 왼쪽에서 오른쪽으로 읽는 식으로 레벨마다 방향이 번갈아 바뀌는 것을 말합니다.

결과는 배열의 배열로 반환하며, 각 내부 배열에는 해당 레벨의 노드 값이 지정된 순서대로 들어갑니다.

**예시 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: [[3],[20,9],[15,7]]
Explanation: 레벨 0은 왼->오: [3]. 레벨 1은 오->왼: [20,9]. 레벨 2는 왼->오: [15,7].
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
    '- `0 <= 노드 수 <= 2000`
- `-100 <= Node.val <= 100`'
);

------------------------------------------------------------
-- #125 target-path (Target Path)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'target-path'),
    'ko',
    '목표 합 경로',
    '이진 트리의 `root`와 정수 `target`이 주어졌을 때, 경로상의 노드 값의 합이 `target`이 되는 모든 **루트-리프 경로**를 찾으세요.

**리프**는 자식이 없는 노드입니다. 각 경로를 루트에서 리프까지의 노드 값 배열로 반환하세요.

**예시 1:**
```
Input: root = [5,4,8,11,null,13,4,7,2,null,null,5,1], target = 22
Output: [[5,4,11,2],[5,8,4,5]]
Explanation: 합이 22가 되는 경로가 두 개 있습니다: 5 + 4 + 11 + 2 = 22, 5 + 8 + 4 + 5 = 22.
```

**예시 2:**
```
Input: root = [1,2,3], target = 5
Output: []
Explanation: 합이 5인 루트-리프 경로가 없습니다.
```

**예시 3:**
```
Input: root = [1,2], target = 3
Output: [[1,2]]
```',
    '- `0 <= 노드 수 <= 5000`
- `-1000 <= Node.val <= 1000`
- `-1000 <= target <= 1000`'
);

------------------------------------------------------------
-- #126 right-pointers (Right Pointers)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'right-pointers'),
    'ko',
    '오른쪽 포인터 연결',
    '모든 부모 노드가 정확히 두 자식을 가지고, 모든 리프가 같은 레벨에 있는 **완전 이진 트리**가 주어집니다. 각 노드에는 처음에 `null`로 설정된 `next` 포인터가 추가로 있습니다.

```
class Node {
    int val;
    Node left;
    Node right;
    Node next;
}
```

각 노드의 `next` 포인터를 같은 레벨에서 바로 오른쪽에 있는 노드로 연결하세요. 오른쪽에 노드가 없으면 `next`는 `null`을 유지합니다.

수정된 트리의 루트를 반환하세요.

**예시 1:**
```
Input: root = [1,2,3,4,5,6,7]
Output: [1,#,2,3,#,4,5,6,7,#]
Explanation: 트리에 세 개의 레벨이 있습니다.
- 레벨 0: 1 -> null
- 레벨 1: 2 -> 3 -> null
- 레벨 2: 4 -> 5 -> 6 -> 7 -> null
직렬화에서 #은 각 레벨 체인의 끝을 나타냅니다.
```

**예시 2:**
```
Input: root = [1]
Output: [1,#]
Explanation: 루트 노드 하나뿐이므로 오른쪽 이웃이 없습니다.
```

**예시 3:**
```
Input: root = [1,2,3]
Output: [1,#,2,3,#]
```',
    '- 노드 수의 범위는 `[1, 4096]`입니다
- `-1000 <= Node.val <= 1000`
- 트리는 완전 이진 트리(perfect binary tree)임이 보장됩니다'
);

------------------------------------------------------------
-- #127 root-sum (Root Sum)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'root-sum'),
    'ko',
    '루트-리프 숫자 합',
    '각 노드가 한 자리 숫자(`0`-`9`)를 담고 있는 이진 트리의 `root`가 주어졌을 때, 모든 루트-리프 경로로 만들어지는 숫자의 합을 구하세요.

각 루트-리프 경로는 경로를 따라 숫자를 이어 붙여 만든 수를 나타냅니다. 예를 들어 `1 -> 2 -> 3` 경로는 숫자 `123`을 의미합니다.

모든 루트-리프 경로로 만든 숫자의 총합을 반환하세요.

**예시 1:**
```
Input: root = [1,2,3]
Output: 25
Explanation: 1 -> 2 경로는 12, 1 -> 3 경로는 13을 만듭니다. 총합은 12 + 13 = 25입니다.
```

**예시 2:**
```
Input: root = [4,9,0,5,1]
Output: 1026
Explanation: 4 -> 9 -> 5 = 495, 4 -> 9 -> 1 = 491, 4 -> 0 = 40. 총합 = 495 + 491 + 40 = 1026.
```

**예시 3:**
```
Input: root = [7]
Output: 7
Explanation: 루트이자 리프인 노드가 하나뿐이므로 숫자는 7입니다.
```',
    '- `1 <= 노드 수 <= 1000`
- `0 <= Node.val <= 9`'
);

------------------------------------------------------------
-- #128 flatten-tree (Flatten Tree)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'flatten-tree'),
    'ko',
    '트리 평탄화',
    '이진 트리의 `root`가 주어졌을 때, 트리를 오른쪽 포인터를 사용한 단일 연결 리스트로 **제자리에서(in-place)** 평탄화하세요.

평탄화된 리스트의 노드 순서는 원래 트리의 **전위 순회(pre-order)** 순서와 같아야 합니다. 모든 노드의 `left` 포인터는 `null`로, `right` 포인터는 전위 순회에서 다음 노드를 가리켜야 합니다.

**예시 1:**
```
Input: root = [1,2,5,3,4,null,6]
Output: [1,2,3,4,5,6]
Explanation: 트리가 오른쪽 포인터를 사용해 1 -> 2 -> 3 -> 4 -> 5 -> 6으로 평탄화됩니다.
```

**예시 2:**
```
Input: root = []
Output: []
```

**예시 3:**
```
Input: root = [0]
Output: [0]
```',
    '- 트리의 노드 수 범위는 `[0, 2000]`입니다
- `-100 <= Node.val <= 100`'
);

------------------------------------------------------------
-- #129 tree-ancestor (Tree Ancestor)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'tree-ancestor'),
    'ko',
    '최소 공통 조상',
    '이진 트리와 두 노드 `p`, `q`가 주어졌을 때, 두 노드의 **최소 공통 조상**(LCA)을 찾으세요.

최소 공통 조상이란 `p`와 `q`를 모두 자손으로 가지는 가장 깊은 노드입니다. 노드는 자기 자신의 자손이 될 수 있습니다.

모든 노드 값은 고유하며, `p`와 `q`는 반드시 트리에 존재합니다.

**예시 1:**
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1
Output: 3
Explanation: 노드 5와 1의 LCA는 3입니다.
```

**예시 2:**
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4
Output: 5
Explanation: 노드 5가 노드 4의 조상이므로 LCA는 5 자체입니다.
```

**예시 3:**
```
Input: root = [1,2,3], p = 2, q = 3
Output: 1
```',
    '- 트리의 노드 수 범위는 `[2, 10000]`입니다
- `-10^9 <= Node.val <= 10^9`
- 모든 `Node.val`은 고유합니다
- `p != q`
- `p`와 `q` 모두 트리에 존재합니다'
);

------------------------------------------------------------
-- #130 job-scheduler (Job Scheduler)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'job-scheduler'),
    'ko',
    '작업 스케줄러',
    '문자 배열 `jobs`가 주어지며, 각 문자는 작업의 종류를 나타냅니다. 정수 `n`은 같은 종류의 작업 사이에 필요한 **쿨다운 시간**입니다.

매 시간 단위마다 작업 하나를 실행하거나 대기(idle)할 수 있습니다. 같은 종류의 작업은 최소 `n` 시간 단위 간격을 두고 실행해야 합니다. 작업 순서는 자유롭게 정할 수 있습니다.

모든 작업을 완료하는 데 필요한 최소 시간 단위 수를 반환하세요.

**예시 1:**
```
Input: jobs = ["A","A","A","B","B","B"], n = 2
Output: 8
Explanation: 가능한 스케줄: A -> B -> idle -> A -> B -> idle -> A -> B. 총 8 구간입니다.
```

**예시 2:**
```
Input: jobs = ["A","C","A","B","D","B"], n = 1
Output: 6
Explanation: 가능한 스케줄: A -> B -> C -> D -> A -> B. 같은 작업 간 간격이 충분해 대기 시간이 필요 없습니다.
```

**예시 3:**
```
Input: jobs = ["A","A","A","B","B","B"], n = 0
Output: 6
Explanation: 쿨다운이 없으므로 모든 작업을 연속 실행하면 6 구간에 완료됩니다.
```',
    '- `1 <= jobs.length <= 10^4`
- `jobs[i]`는 대문자 영어 알파벳입니다
- `0 <= n <= 100`'
);
