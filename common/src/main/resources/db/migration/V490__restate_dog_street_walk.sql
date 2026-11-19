-- V490: dog-street-walk restated, title unchanged. The constraint "three-letter uppercase zone
-- code" was false (hidden case 11 has zones "A" to "E"): zone codes are now 1 to 3 uppercase
-- letters. The lexicographic tie-break now says how zones compare, and Example 2 explains it.
-- Method traceStreetSweep (Python: find_itinerary, an airline leftover) -> planWalk in all 4
-- Starter Codes and Drivers. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Your dog wants to walk every street in the neighborhood exactly once. `routes` lists the streets as one-way segments `[from, to]` between zones. Return the walk as the list of zones it visits, in order: it starts at home, zone `"HUB"`, and uses every segment exactly once.

If several walks work, return the lexicographically smallest one: compare two walks zone by zone, and at the first position where they differ, the walk whose zone code comes first alphabetically is smaller. A valid walk is guaranteed to exist.

**Example 1:**
```
Input: routes = [["ELM","HUB"],["HUB","BIR"],["BIR","ELM"],["HUB","CED"]]
Output: ["HUB","BIR","ELM","HUB","CED"]
Explanation: HUB -> BIR -> ELM -> HUB -> CED uses all four segments. Going to CED first would strand the dog before BIR and ELM, since no segment leaves CED.
```

```diagram-graph
edges: [["ELM","HUB"],["HUB","BIR"],["BIR","ELM"],["HUB","CED"]]
directed: true
highlight_path: ["HUB","BIR","ELM","HUB","CED"]
```

**Example 2:**
```
Input: routes = [["HUB","NOR"],["HUB","SOU"],["NOR","SOU"],["SOU","HUB"],["SOU","NOR"]]
Output: ["HUB","NOR","SOU","HUB","SOU","NOR"]
Explanation: From HUB the dog can go to NOR or SOU. NOR comes first alphabetically, and starting there still uses every segment: HUB -> NOR -> SOU -> HUB -> SOU -> NOR.
```$$,
    constraints = $$- `1 <= routes.length <= 320`
- `routes[i].length == 2`
- Each `from` and `to` is a zone code of 1 to 3 uppercase English letters.
- `from != to` within any single segment.
- At least one walk starts at `"HUB"` and uses every segment exactly once.$$
WHERE slug = $$dog-street-walk$$;

UPDATE problem_translations SET
    description = $$강아지가 동네의 모든 길을 정확히 한 번씩 걷고 싶어 합니다. `routes`는 구역 사이의 길을 일방통행 구간 `[from, to]`로 나열한 목록입니다. 강아지가 들르는 구역을 순서대로 담은 산책 경로를 반환하세요. 경로는 집인 `"HUB"` 구역에서 출발하고, 모든 구간을 정확히 한 번씩 사용합니다.

가능한 경로가 여러 개라면 **사전순으로 가장 작은** 경로를 반환합니다. 두 경로를 구역 하나씩 앞에서부터 비교해, 처음으로 달라지는 자리에서 구역 코드가 알파벳순으로 앞서는 경로가 더 작습니다. 유효한 경로는 항상 하나 이상 있습니다.

**예시 1:**
```
입력: routes = [["ELM","HUB"],["HUB","BIR"],["BIR","ELM"],["HUB","CED"]]
출력: ["HUB","BIR","ELM","HUB","CED"]
설명: HUB -> BIR -> ELM -> HUB -> CED 순서로 가면 네 구간을 모두 사용합니다. CED에서 나가는 구간이 없으므로, CED에 먼저 가면 BIR과 ELM에 가기 전에 갇혀 버립니다.
```

```diagram-graph
edges: [["ELM","HUB"],["HUB","BIR"],["BIR","ELM"],["HUB","CED"]]
directed: true
highlight_path: ["HUB","BIR","ELM","HUB","CED"]
```

**예시 2:**
```
입력: routes = [["HUB","NOR"],["HUB","SOU"],["NOR","SOU"],["SOU","HUB"],["SOU","NOR"]]
출력: ["HUB","NOR","SOU","HUB","SOU","NOR"]
설명: HUB에서는 NOR나 SOU로 갈 수 있습니다. 알파벳순으로 NOR가 앞서고, NOR로 먼저 가도 모든 구간을 사용할 수 있습니다. HUB -> NOR -> SOU -> HUB -> SOU -> NOR 순서입니다.
```$$,
    constraints = $$- `1 <= routes.length <= 320`
- `routes[i].length == 2`
- 각 `from`과 `to`는 영어 대문자 1~3글자로 된 구역 코드입니다.
- 같은 구간 안에서 `from != to`입니다.
- `"HUB"`에서 출발해 모든 구간을 정확히 한 번씩 사용하는 경로가 하나 이상 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$dog-street-walk$$);
