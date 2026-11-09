-- V278: restate graph-valid-tree (#210, part of #193). The examples showed data
-- that is no Test Case (n = 5 twice); they now show sample Test Cases 1 and 2,
-- in English and Korean, with Example 1's Diagram redrawn to its new edges and
-- Example 2's explanation rewritten for its new cycle. Only the descriptions
-- change; Slug, titles, constraints, Test Cases, Starter Code and Drivers are
-- unchanged.

UPDATE problems SET
    description = $$You're given an integer `n` (the number of nodes, labelled `0..n-1`) and an array `edges` where each `edges[i] = [u, v]` is an undirected edge between nodes `u` and `v`. Decide whether `(n, edges)` forms a valid tree.

A valid tree is **connected** (every node reachable from every other), **acyclic** (no cycles), and has exactly `n - 1` edges.

**Example 1:**
```
Input: n = 6, edges = [[0,1],[0,2],[1,3],[1,4],[2,5]]
Output: true
```

```diagram-graph
edges: [[0,1],[0,2],[1,3],[1,4],[2,5]]
directed: false
```

**Example 2:**
```
Input: n = 4, edges = [[0,1],[1,2],[2,0],[0,3]]
Output: false
Explanation: The edges 0-1, 1-2, 2-0 form a cycle.
```$$
WHERE slug = $$graph-valid-tree$$;

UPDATE problem_translations SET
    description = $$정수 `n`(`0..n-1`로 번호가 매겨진 노드의 개수)과 무방향 간선 배열 `edges`가 주어집니다. 각 `edges[i] = [u, v]`는 `u`와 `v`를 잇는 간선입니다. `(n, edges)`가 유효한 트리를 이루는지 판단하세요.

유효한 트리란 모든 노드가 서로 도달 가능한 **연결 그래프**이고, **사이클이 없으며**, 정확히 `n - 1`개의 간선을 갖는 그래프를 뜻합니다.

**예시 1:**
```
입력: n = 6, edges = [[0,1],[0,2],[1,3],[1,4],[2,5]]
출력: true
```

```diagram-graph
edges: [[0,1],[0,2],[1,3],[1,4],[2,5]]
directed: false
```

**예시 2:**
```
입력: n = 4, edges = [[0,1],[1,2],[2,0],[0,3]]
출력: false
설명: 간선 0-1, 1-2, 2-0이 사이클을 이룹니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$graph-valid-tree$$);
