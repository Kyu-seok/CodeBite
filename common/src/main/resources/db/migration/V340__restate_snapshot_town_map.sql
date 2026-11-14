-- V340: snapshot-town-map restated. The statement said the function gets one `node`,
-- then that "the graph is passed as an adjacency list", so a reader couldn't tell what
-- the function receives. It now states the task first (return a deep copy of the map
-- containing `node`), says the adjacency list is only how the examples write a map,
-- and shows the empty map (sample 3) as Example 3, with `null` in and out. Starter
-- method snapshotMeshLayout -> cloneMap. Examples match the sample test cases, which
-- are unchanged.

UPDATE problems SET
    description = $$Return a **deep copy** of a town map, given `node`, one spot on it. The map is a connected undirected graph of spots, and you return the copy of the spot `node`.

Each spot is a `Node` with an integer `val` and a list `neighbors` of the spots it connects to. Every node of the copy must be a new object with the same `val` and the same neighbors; no node may be shared with the original. When the map is empty, `node` is `null` (`None` in Python) and you return `null`.

The examples write a map as an adjacency list `adjList`: the spots have the values `1` to `n`, `adjList[i]` lists the values of the neighbors of the spot with `val = i + 1`, and `node` is the spot with `val = 1`. The output writes the copy the same way.

**Example 1:**
```
Input: adjList = [[2,3],[1,4],[1,5],[2,5],[3,4]]
Output: [[2,3],[1,4],[1,5],[2,5],[3,4]]
Explanation: Spot 1 connects to spots 2 and 3, spot 2 to spots 1 and 4, and so on. The copy has the same five spots and edges, made of new nodes, so it is written the same way.
```

```diagram-graph
edges: [[1,2],[1,3],[2,4],[3,5],[4,5]]
directed: false
```

**Example 2:**
```
Input: adjList = [[2],[1,3],[2]]
Output: [[2],[1,3],[2]]
Explanation: Three spots in a line, 1 - 2 - 3. The copy is the same line of new nodes.
```

**Example 3:**
```
Input: adjList = []
Output: []
Explanation: The map is empty, so `node` is `null` and the copy is `null` too.
```$$,
    constraints = $$- The number of spots in the map is in the range `[0, 100]`.
- `1 <= node.val <= 100`
- `node.val` is unique per spot.
- The map has no self-loops and no repeated edges.$$
WHERE slug = $$snapshot-town-map$$;

UPDATE problem_translations SET
    description = $$마을 지도의 한 장소 `node`가 주어질 때, 지도를 **깊은 복사(deep copy)**해서 반환하세요. 지도는 장소들로 이루어진 연결된 무방향 그래프이며, 장소 `node`의 복사본을 반환하면 됩니다.

각 장소는 정수 `val`과 이어진 장소들의 리스트 `neighbors`를 가진 `Node`입니다. 복사본의 모든 노드는 같은 `val`과 같은 이웃을 가진 새 객체여야 하며, 원본과 공유하는 노드가 있어서는 안 됩니다. 지도가 비어 있으면 `node`는 `null`(Python에서는 `None`)이고, `null`을 반환합니다.

예시에서는 지도를 인접 리스트 `adjList`로 적습니다. 장소들의 값은 `1`부터 `n`까지이고, `adjList[i]`에는 `val = i + 1`인 장소와 이어진 장소들의 값이 담기며, `node`는 `val = 1`인 장소입니다. 출력도 복사본을 같은 방식으로 적은 것입니다.

**예시 1:**
```
입력: adjList = [[2,3],[1,4],[1,5],[2,5],[3,4]]
출력: [[2,3],[1,4],[1,5],[2,5],[3,4]]
설명: 장소 1은 장소 2, 3과 이어지고, 장소 2는 장소 1, 4와 이어지는 식입니다. 복사본은 새 노드로 만든 같은 다섯 장소와 같은 간선을 가지므로 똑같이 적힙니다.
```

```diagram-graph
edges: [[1,2],[1,3],[2,4],[3,5],[4,5]]
directed: false
```

**예시 2:**
```
입력: adjList = [[2],[1,3],[2]]
출력: [[2],[1,3],[2]]
설명: 세 장소가 1 - 2 - 3으로 일자로 이어져 있습니다. 복사본은 새 노드로 만든 같은 일자 그래프입니다.
```

**예시 3:**
```
입력: adjList = []
출력: []
설명: 지도가 비어 있으므로 `node`는 `null`이고, 복사본도 `null`입니다.
```$$,
    constraints = $$- 지도의 장소 수는 `[0, 100]` 범위입니다.
- `1 <= node.val <= 100`
- `node.val`은 장소마다 서로 다릅니다.
- 지도에는 자기 자신으로 가는 간선이나 중복 간선이 없습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$snapshot-town-map$$);
