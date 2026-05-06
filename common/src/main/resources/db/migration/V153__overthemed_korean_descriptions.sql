-- V153: Korean descriptions for the 13 over-themed problems renamed in
-- V151 / re-described in V152. Mirrors V136's style — identifiers, fenced
-- example blocks (Input/Output/Explanation), numeric values, and string
-- literals are kept verbatim from the English source. Example headers are
-- rendered as **예시 N:**.

-- valid-anagram
UPDATE problem_translations SET
    description = $$두 문자열이 서로 *애너그램*(anagram)이라는 것은 한쪽을 재배열해서 다른 쪽을 만들 수 있다는 뜻입니다. 즉, 정확히 같은 글자들이 정확히 같은 개수만큼 들어 있어야 합니다.

소문자로 된 두 문자열 `s`와 `t`가 주어졌을 때, `t`가 `s`의 애너그램이면 `true`를, 아니면 `false`를 반환하세요. 길이가 다른 두 문자열은 결코 애너그램이 될 수 없습니다.

**예시 1:**
```
Input: s = "anagram", t = "nagaram"
Output: true
```

**예시 2:**
```
Input: s = "rat", t = "car"
Output: false
Explanation: 'a' and 't' appear in `s` but not in `t`, so the letter multisets differ.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$valid-anagram$$);

-- group-anagrams
UPDATE problem_translations SET
    description = $$소문자로 된 문자열 배열 `strs`가 주어집니다. 서로 *애너그램*(같은 글자가 같은 개수만큼 들어 있어 한쪽을 재배열하면 다른 쪽이 되는 관계)인 문자열들을 같은 그룹으로 묶으세요.

결과는 그룹들의 리스트로 반환합니다. 그룹들의 순서나 그룹 안 문자열들의 순서는 상관없습니다.

**예시 1:**
```
Input: strs = ["eat","tea","tan","ate","nat","bat"]
Output: [["bat"],["nat","tan"],["ate","eat","tea"]]
```

**예시 2:**
```
Input: strs = [""]
Output: [[""]]
```

**예시 3:**
```
Input: strs = ["a"]
Output: [["a"]]
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$group-anagrams$$);

-- lca-bst
UPDATE problem_translations SET
    description = $$이진 검색 트리(BST)의 `root`와 트리 안에 존재하는 두 노드 `p`, `q`가 주어졌을 때, `p`와 `q`의 최소 공통 조상(LCA)을 반환하세요.

LCA란 `p`와 `q`를 모두 자손으로 두는 노드 중 가장 깊은 노드를 뜻합니다. 자기 자신도 자손으로 칠 수 있습니다. BST의 성질을 이용하면 루트에서 내려가면서 두 노드가 어느 서브트리에 속하는지 단계마다 판단할 수 있습니다.

**예시 1:**
```
Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 8
Output: 6
Explanation: 2 and 8 split at the root, so the LCA is 6.
```

**예시 2:**
```
Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 4
Output: 2
Explanation: 4 is in the subtree rooted at 2, and a node can be its own descendant.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$lca-bst$$);

-- populating-next-pointers
UPDATE problem_translations SET
    description = $$**완전한** 이진 트리(perfect binary tree)의 `root`가 주어집니다. 모든 부모는 두 자식을 가지며, 모든 잎은 같은 깊이에 있습니다. 각 노드는 `val`, `left`, `right`, `next` 필드를 갖고, 처음에는 모든 `next`가 null입니다.

각 노드의 `next`가 같은 레벨에서 바로 오른쪽에 있는 노드를 가리키도록 설정하세요. 같은 레벨에 오른쪽 노드가 없으면(레벨의 가장 오른쪽 노드면) `next`는 null로 남깁니다. 변경된 `root`를 반환합니다.

**예시 1:**
```
Input: root = [1,2,3,4,5,6,7]
Output: [1,#,2,3,#,4,5,6,7,#]
Explanation: The "#" markers separate levels in the level-order serialization with next pointers attached. 1 has no right neighbor; 2 → 3, 4 → 5 → 6 → 7.
```

**예시 2:**
```
Input: root = []
Output: []
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$populating-next-pointers$$);

-- sum-root-to-leaf
UPDATE problem_translations SET
    description = $$이진 트리의 각 노드는 `0`–`9` 사이의 한 자리 숫자를 담고 있습니다. 루트에서 잎까지 가는 경로의 노드 값을 위에서 아래로 이어 붙이면 음이 아닌 정수 한 개가 만들어집니다. 예를 들어 `4 → 9 → 5` 경로는 `495`를 나타냅니다.

`root`가 주어졌을 때, 모든 루트-잎 경로가 나타내는 정수의 합을 반환하세요. 트리의 노드 수는 많아야 수천 개이고, 합은 32비트 정수 범위 안에 들어갑니다.

**예시 1:**
```
Input: root = [1,2,3]
Output: 25
Explanation: Paths 1→2 and 1→3 spell 12 and 13. 12 + 13 = 25.
```

**예시 2:**
```
Input: root = [4,9,0,5,1]
Output: 1026
Explanation: Paths spell 495, 491, and 40. Sum = 1026.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$sum-root-to-leaf$$);

-- lca-binary-tree
UPDATE problem_translations SET
    description = $$일반 이진 트리(BST일 필요 없음)의 `root`와 트리 안에 존재하는 두 노드 `p`, `q`가 주어졌을 때, `p`와 `q`의 최소 공통 조상(LCA)을 반환하세요.

LCA란 `p`와 `q`를 모두 서브트리에 포함하는 노드 중 가장 깊은 노드를 뜻하며, 노드는 자기 자신을 자손으로 칠 수 있습니다. 모든 노드 값은 서로 다릅니다.

**예시 1:**
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1
Output: 3
Explanation: 5 and 1 belong to different subtrees of 3, so 3 is the deepest node that contains both.
```

**예시 2:**
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4
Output: 5
Explanation: 4 lives inside the subtree rooted at 5, and a node can be a descendant of itself.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$lca-binary-tree$$);

-- subsets-ii
UPDATE problem_translations SET
    description = $$중복 원소가 있을 수 있는 정수 배열 `nums`가 주어집니다. `nums`의 **모든** 가능한 부분집합(멱집합)을 반환하세요. 단, 결과 안에는 중복된 부분집합이 들어 있어서는 안 됩니다.

부분집합들의 순서와 각 부분집합 안의 순서는 상관없습니다.

**예시 1:**
```
Input: nums = [1,2,2]
Output: [[],[1],[1,2],[1,2,2],[2],[2,2]]
```

**예시 2:**
```
Input: nums = [0]
Output: [[],[0]]
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$subsets-ii$$);

-- graph-valid-tree
UPDATE problem_translations SET
    description = $$정수 `n`(`0..n-1`로 번호가 매겨진 노드의 개수)과 무방향 간선 배열 `edges`가 주어집니다. 각 `edges[i] = [u, v]`는 `u`와 `v`를 잇는 간선입니다. `(n, edges)`가 유효한 트리를 이루는지 판단하세요.

유효한 트리란 모든 노드가 서로 도달 가능한 **연결 그래프**이고, **사이클이 없으며**, 정확히 `n - 1`개의 간선을 갖는 그래프를 뜻합니다.

**예시 1:**
```
Input: n = 5, edges = [[0,1],[0,2],[0,3],[1,4]]
Output: true
```

**예시 2:**
```
Input: n = 5, edges = [[0,1],[1,2],[2,3],[1,3],[1,4]]
Output: false
Explanation: The edges 1-2, 2-3, 1-3 form a cycle.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$graph-valid-tree$$);

-- reverse-linked-list
UPDATE problem_translations SET
    description = $$단일 연결 리스트의 `head`가 주어졌을 때, 리스트를 뒤집은 뒤 새 헤드를 반환하세요. 새 리스트를 새로 만들지 말고, 기존 노드들을 **제자리에서** 다시 연결해야 합니다.

**예시 1:**
```
Input: head = [1,2,3,4,5]
Output: [5,4,3,2,1]
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
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$reverse-linked-list$$);

-- binary-tree-level-order
UPDATE problem_translations SET
    description = $$이진 트리의 `root`가 주어졌을 때, 레벨 순서 순회를 반환하세요. 결과의 `i`번째 원소는 깊이 `i`에 있는 노드 값들을 왼쪽에서 오른쪽 순서로 나열한 리스트입니다.

빈 트리는 빈 리스트를 반환합니다.

**예시 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: [[3],[9,20],[15,7]]
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
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$binary-tree-level-order$$);

-- binary-tree-codec
UPDATE problem_translations SET
    description = $$다음 두 메서드를 가진 `Codec` 클래스를 설계하세요:

- `String serialize(TreeNode root)` — 이진 트리를 문자열로 변환합니다.
- `TreeNode deserialize(String data)` — 그런 문자열에서 트리를 복원합니다.

직렬화 형식은 자유롭게 정해도 됩니다. 채점기는 각 입력 트리에 대해 `deserialize(serialize(root))`를 호출하고, 복원된 트리가 원본과 구조적으로 동일한지 확인합니다.

노드 값은 32비트 정수 범위 안의 어떤 값이든 가능하며, 트리는 비어 있을 수도 있습니다(`root = null`).

**예시 1:**
```
Input: root = [1,2,3,null,null,4,5]
Output: [1,2,3,null,null,4,5]
Explanation: The exact serialized string can differ; only the round-trip tree must match.
```

**예시 2:**
```
Input: root = []
Output: []
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$binary-tree-codec$$);

-- walls-and-gates
UPDATE problem_translations SET
    description = $$`m × n` 격자 `rooms`가 주어집니다. 각 칸은 다음 셋 중 하나입니다:
- `-1` — **벽**(이동 불가).
- `0` — **문**.
- `2147483647`(즉, INT_MAX) — **빈 방**.

각 빈 방에 가장 가까운 문까지의 거리(상하좌우로 이동한 칸 수)를 채워 `rooms`를 **제자리에서** 갱신하세요. 어떤 문에도 도달할 수 없는 빈 방은 그대로 `2147483647`로 둡니다.

**예시 1:**
```
Input: rooms = [[2147483647,-1,0,2147483647],[2147483647,2147483647,2147483647,-1],[2147483647,-1,2147483647,-1],[0,-1,2147483647,2147483647]]
Output: [[3,-1,0,1],[2,2,1,-1],[1,-1,2,-1],[0,-1,3,4]]
```

**예시 2:**
```
Input: rooms = [[-1]]
Output: [[-1]]
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$walls-and-gates$$);

-- longest-palindromic-substring (length variant)
UPDATE problem_translations SET
    description = $$문자열 `s`가 주어졌을 때, `s`의 가장 긴 회문 부분 문자열의 **길이**를 반환하세요. 회문 부분 문자열이란 앞뒤로 읽어도 같은 부분 문자열을 말합니다.

**예시 1:**
```
Input: s = "babad"
Output: 3
Explanation: "bab" and "aba" are both palindromic substrings of length 3.
```

**예시 2:**
```
Input: s = "cbbd"
Output: 2
Explanation: "bb" has length 2; no longer palindromic substring exists.
```

**예시 3:**
```
Input: s = "a"
Output: 1
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-palindromic-substring$$);
