-- V533: longest-folder-path restated, title unchanged. The first sentence now says the path
-- may bend at any folder and need not pass through the root, and Example 1 says "longest",
-- not "widest span". Starter method widestCatalogSpan -> longestPathEdges in all 4 Starter
-- Codes and Drivers. Examples and their Diagram match the sample test cases, which are
-- unchanged.

UPDATE problems SET
    description = $$Given the `root` of a folder tree, return the number of **edges** on the longest path between any two folders. The path may bend at any folder and need not pass through `root`.

**Example 1:**
```
Input: root = [7,3,8,1,4,null,9]
Output: 4
Explanation: The path 1 -> 3 -> 7 -> 8 -> 9 has 4 edges, and no path is longer.
```

```diagram-tree
nodes: [7, 3, 8, 1, 4, null, 9]
```

**Example 2:**
```
Input: root = [2,null,5,3]
Output: 2
Explanation: The path 2 -> 5 -> 3 runs straight down one branch and has 2 edges.
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[1, 8000]`.
- `-100 <= Node.val <= 100`$$
WHERE slug = $$longest-folder-path$$;

UPDATE problem_translations SET
    description = $$폴더 트리의 루트 `root`가 주어질 때, 두 폴더를 잇는 가장 긴 경로의 **간선 수**를 반환하세요. 경로는 어느 폴더에서든 꺾일 수 있고, `root`를 지나지 않아도 됩니다.

**예시 1:**
```
입력: root = [7,3,8,1,4,null,9]
출력: 4
설명: 1 -> 3 -> 7 -> 8 -> 9 경로의 간선은 4개이고, 이보다 긴 경로는 없습니다.
```

```diagram-tree
nodes: [7, 3, 8, 1, 4, null, 9]
```

**예시 2:**
```
입력: root = [2,null,5,3]
출력: 2
설명: 2 -> 5 -> 3 경로는 한 가지를 따라 곧장 내려가며 간선이 2개입니다.
```$$,
    constraints = $$- 트리의 노드 개수는 `[1, 8000]` 범위입니다.
- `-100 <= Node.val <= 100`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-folder-path$$);
