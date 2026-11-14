-- V553: count-top-heroes restated, Slug and title unchanged. The dungeon-crawler party opening
-- came before the task, and the statement named the method tallyDominantBlocks (blocks, from an
-- earlier theme): it now opens with the task, and the examples say which path maximum each hero is
-- compared with. Starter method tallyDominantBlocks -> countDominantHeroes in all 4 Starter Codes
-- and Drivers. Examples match the sample test cases, which are unchanged, and Example 1 keeps its
-- Diagram.

UPDATE problems SET
    description = $$Given the `root` of a binary tree where each node holds a hero's damage number, return the number of **dominant** heroes. A hero is dominant when no hero on the path from the root down to them has a strictly higher number. The root is always dominant.

**Example 1:**
```
Input: root = [4,2,6,5,1,null,7]
Output: 4
Explanation: The root 4 is dominant. 6 and 5 are at least 4, the highest number above them, and 7 is at least 6, the highest above it. 2 and 1 are below 4, so they are not dominant.
```

```diagram-tree
nodes: [4, 2, 6, 5, 1, null, 7]
```

**Example 2:**
```
Input: root = [5,3,5,2,4]
Output: 2
Explanation: The root 5 is dominant, and so is its right child 5: a tie is not strictly higher. 3, 2 and 4 are below the root's 5.
```

**Example 3:**
```
Input: root = [7]
Output: 1
Explanation: A tree of one hero has just the root, which is dominant.
```$$
WHERE slug = $$count-top-heroes$$;

UPDATE problem_translations SET
    description = $$각 노드에 영웅의 피해량이 담긴 이진 트리의 루트 `root`가 주어질 때, **우세한** 영웅의 수를 반환하세요. 루트에서 어떤 영웅까지 내려가는 경로 위에 그보다 **엄격히** 큰 값을 가진 영웅이 없으면, 그 영웅은 우세합니다. 루트는 항상 우세합니다.

**예시 1:**
```
입력: root = [4,2,6,5,1,null,7]
출력: 4
설명: 루트 4는 우세합니다. 6과 5는 위쪽 최댓값 4 이상이고, 7은 위쪽 최댓값 6 이상이라 우세합니다. 2와 1은 4보다 작아 우세하지 않습니다.
```

```diagram-tree
nodes: [4, 2, 6, 5, 1, null, 7]
```

**예시 2:**
```
입력: root = [5,3,5,2,4]
출력: 2
설명: 루트 5가 우세하고, 오른쪽 자식 5도 우세합니다. 같은 값은 엄격히 큰 값이 아니기 때문입니다. 3, 2, 4는 루트의 5보다 작습니다.
```

**예시 3:**
```
입력: root = [7]
출력: 1
설명: 영웅이 하나뿐인 트리에는 루트만 있고, 루트는 우세합니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-top-heroes$$);
