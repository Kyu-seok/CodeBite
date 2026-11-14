-- V401: cheapest-courier-route, text restated. maxHops counted intermediate cafes, not
-- hops, inviting an off-by-one: now maxStops, with legs = stops + 1 said plainly. The title
-- said "cheapest" and the text "minutes": now one word, cost. The constraint src != dst was
-- false (a hidden case has n = 1, src = dst = 0, answer 0): dropped, and src == dst is
-- stated to cost 0. Starter method relayDispatchCost -> cheapestRoute, parameter
-- maxHops -> maxStops; the Drivers' flights/k -> links/maxStops. Examples match the sample
-- test cases, which are unchanged.

UPDATE problems SET
    description = $$There are `n` cafes labeled `0` to `n - 1` and one-way courier links between them. Each `links[i] = [from, to, cost]` is a leg from cafe `from` to cafe `to` that costs `cost`. Return the **minimum total cost** of a route from cafe `src` to cafe `dst` that makes at most `maxStops` stops along the way, or `-1` if no such route exists.

- A **stop** is a cafe the route passes through between `src` and `dst`, so a route with at most `maxStops` stops uses at most `maxStops + 1` links.
- When `src == dst`, the route is empty and costs `0`.

**Example 1:**
```
Input: n = 5, links = [[0,1,50],[1,2,40],[0,2,200],[2,3,30],[3,4,20],[1,3,150]], src = 0, dst = 4, maxStops = 2
Output: 220
Explanation: The route 0 -> 1 -> 3 -> 4 costs 50 + 150 + 20 = 220 and stops at 2 cafes (1 and 3). The cheaper route 0 -> 1 -> 2 -> 3 -> 4 (cost 140) stops at 3 cafes, one too many.
```

```diagram-graph
edges: [[0,1],[1,2],[0,2],[2,3],[3,4],[1,3]]
directed: true
highlight_path: [0,1,3,4]
```

**Example 2:**
```
Input: n = 4, links = [[0,1,80],[1,2,40],[0,2,300],[2,3,90],[0,3,400]], src = 0, dst = 3, maxStops = 0
Output: 400
Explanation: With maxStops = 0 the route can't stop anywhere, so only the direct link 0 -> 3 (cost 400) counts, even though 0 -> 1 -> 2 -> 3 costs 210.
```$$,
    constraints = $$- `1 <= n <= 120`
- `0 <= links.length <= n * (n - 1) / 2`
- `links[i].length == 3`
- `0 <= from, to < n` and `from != to`
- `1 <= cost <= 8000`
- `0 <= src, dst, maxStops < n`$$
WHERE slug = $$cheapest-courier-route$$;

UPDATE problem_translations SET
    description = $$`0`부터 `n - 1`까지 번호가 매겨진 `n`개의 카페가 단방향 배달 링크로 이어져 있습니다. 각 `links[i] = [from, to, cost]`는 카페 `from`에서 카페 `to`로 가는 구간이며 비용은 `cost`입니다. 카페 `src`에서 카페 `dst`까지, 도중에 최대 `maxStops`곳을 경유하는 경로의 **최소 총비용**을 반환하세요. 그런 경로가 없으면 `-1`을 반환합니다.

- **경유지**는 경로가 `src`와 `dst` 사이에서 거치는 카페입니다. 따라서 경유지가 `maxStops`곳 이하인 경로는 링크를 최대 `maxStops + 1`개 씁니다.
- `src == dst`이면 경로는 비어 있고 비용은 `0`입니다.

**예시 1:**
```
입력: n = 5, links = [[0,1,50],[1,2,40],[0,2,200],[2,3,30],[3,4,20],[1,3,150]], src = 0, dst = 4, maxStops = 2
출력: 220
설명: 경로 0 -> 1 -> 3 -> 4는 비용이 50 + 150 + 20 = 220이고 카페 2곳(1과 3)을 경유합니다. 더 싼 경로 0 -> 1 -> 2 -> 3 -> 4(비용 140)는 3곳을 경유해 한 곳이 많습니다.
```

```diagram-graph
edges: [[0,1],[1,2],[0,2],[2,3],[3,4],[1,3]]
directed: true
highlight_path: [0,1,3,4]
```

**예시 2:**
```
입력: n = 4, links = [[0,1,80],[1,2,40],[0,2,300],[2,3,90],[0,3,400]], src = 0, dst = 3, maxStops = 0
출력: 400
설명: maxStops = 0이면 어디도 경유할 수 없으므로 직행 링크 0 -> 3(비용 400)만 인정됩니다. 0 -> 1 -> 2 -> 3은 비용이 210이지만 제외됩니다.
```$$,
    constraints = $$- `1 <= n <= 120`
- `0 <= links.length <= n * (n - 1) / 2`
- `links[i].length == 3`
- `0 <= from, to < n`이고 `from != to`
- `1 <= cost <= 8000`
- `0 <= src, dst, maxStops < n`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$cheapest-courier-route$$);
