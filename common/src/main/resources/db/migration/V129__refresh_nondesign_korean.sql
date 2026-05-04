-- V129: Phase 5+ — refresh Korean translations for the 183 non-design problems.
--
-- After V121/V122 (slug/method renames) and V124 (English description rewrite),
-- the ko translations inserted by V77-V96 still encoded the pre-V121 state and
-- carried canonical LC fingerprints (e.g. [2,7,11,15], [3,2,4], 10^4) in their
-- sample blocks. This migration drops those 183 ko rows and re-inserts fresh
-- translations that mirror the new English content. The 16 design problems
-- were refreshed separately in V128.


-- Drop stale ko translations for the 183 non-design slugs
DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
    'carrier-street-sweep',
    'responder-relay-cost',
    'duplicate-catalog-link',
    'irrigation-pipe-plan',
    'flooded-corridor-crossing',
    'transit-alert-wave',
    'scene-shoot-order',
    'match-recipe-ingredients',
    'cluster-barrel-signatures',
    'station-throughput-shares',
    'sort-material-bins',
    'repeat-tracking-codes',
    'detect-callnumber-clash',
    'lowest-missing-target',
    'unique-topic-window',
    'busiest-machines-list',
    'unpaired-frame-reading',
    'longest-seat-block',
    'next-shot-order',
    'merge-reservation-windows',
    'headline-majority-pick',
    'compact-shelved-copies',
    'rotate-park-map',
    'species-grid-validator',
    'event-window-tally',
    'station-visit-orders',
    'enumerate-barrel-blends',
    'split-zone-codes',
    'mirror-headline-splits',
    'keypad-device-codes',
    'taxiway-aircraft-layout',
    'voucher-price-combos',
    'batch-quota-combos',
    'montage-scene-picks',
    'zone-letter-trail',
    'locate-call-number',
    'pinpoint-peak-reading',
    'slowest-conveyor-speed',
    'detect-flow-value',
    'probe-sugar-reading',
    'locate-terminus-station',
    'spot-catalog-target',
    'smallest-flow-rate',
    'merged-zone-median',
    'locate-vacant-callslot',
    'compare-pallet-flags',
    'tally-priority-flags',
    'combine-counter-readings',
    'active-sensor-mask',
    'reverse-printer-flags',
    'single-species-tank',
    'best-bake-order',
    'count-coupon-combos',
    'min-wait-route',
    'min-zone-code-edits',
    'biggest-clear-bay',
    'longest-vine-ascent',
    'shelf-overlap-length',
    'validate-part-stream',
    'partition-tank-doses',
    'best-tier-resale',
    'check-merged-queue',
    'count-filter-matches',
    'count-gate-routes',
    'split-reading-for-product',
    'pick-least-effort-circuit',
    'fewest-bag-sizes',
    'count-scan-decodings',
    'split-shift-loads',
    'pick-plot-haul',
    'pick-circuit-targets',
    'longest-bright-run',
    'count-longest-bake-trail',
    'build-mirror-length',
    'best-flow-streak',
    'nth-smooth-batch',
    'count-mirror-spans',
    'count-exact-page-quotas',
    'count-assembly-orders',
    'count-reservoir-paths',
    'split-headline-tokens',
    'unify-crew-contacts',
    'seize-enclosed-zones',
    'tally-device-meshes',
    'sequence-assembly-steps',
    'verify-shoot-plan',
    'resolve-price-ratios',
    'fanout-responder-reach',
    'snapshot-mesh-layout',
    'tally-planted-regions',
    'trace-dual-drainage',
    'check-key-reachability',
    'spread-contamination-wave',
    'chart-block-route',
    'split-into-two-shifts',
    'is-acyclic-network',
    'bridge-label-chain',
    'verify-bake-rotation',
    'balance-print-jobs',
    'choose-start-station',
    'group-oven-bakes',
    'order-ticket-holders',
    'fewest-van-hops',
    'split-zone-runs',
    'peak-reading-window',
    'finish-assembly-line',
    'form-bale-triple',
    'brightest-observed-targets',
    'trending-feed-topics',
    'station-run-planner',
    'nearest-depot-stops',
    'crush-heaviest-bales',
    'space-recipe-bakes',
    'cover-watering-windows',
    'schedule-observing-window',
    'peak-gate-demand',
    'drop-class-conflicts',
    'tightest-or-booking',
    'verify-table-bookings',
    'tally-pick-paths',
    'duplicate-topic-web',
    'detect-transfer-loop',
    'merge-flight-rosters',
    'combine-oven-rotations',
    'drop-tail-booking',
    'interleave-trailer-cuts',
    'flip-sorter-segments',
    'rewind-conveyor-chain',
    'swap-queue-partners',
    'label-lane-scans',
    'bump-parcel-code',
    'calm-sensor-reading',
    'reversible-call-number',
    'decode-zone-numeral',
    'forecast-step-factor',
    'outward-shelf-walk',
    'product-as-text',
    'clear-defect-rows',
    'longest-clean-run',
    'shortest-bake-span',
    'shortest-shelf-span',
    'peak-temp-swing',
    'zone-code-anagram',
    'longest-fresh-feed',
    'peak-flow-stretch',
    'verify-job-nesting',
    'group-train-packs',
    'list-slate-sequences',
    'fold-bale-ops',
    'resolve-lane-crashes',
    'widest-vine-block',
    'days-to-upgrade',
    'shared-assembly-lookup',
    'ward-priority-audit',
    'assemble-script-breakdown',
    'unroll-flight-schedule',
    'tally-dominant-blocks',
    'hub-evenness-check',
    'matching-catalog-layouts',
    'nth-dimmest-target',
    'flights-by-tier',
    'best-scene-branch',
    'reflect-blend-profile',
    'wire-zone-peers',
    'dock-edge-silhouette',
    'sum-zone-codes',
    'list-runtime-branches',
    'shared-dispatch-hub',
    'deepest-zone-chain',
    'widest-catalog-span',
    'contains-topic-branch',
    'alternate-ward-sweep',
    'flag-material-codes',
    'pair-crates-for-order',
    'shift-unscannable-letters',
    'void-empty-scans',
    'verify-mirror-callnumber',
    'quad-tray-demand',
    'pool-between-walls',
    'pair-tiers-budget',
    'order-tank-deviations',
    'triage-zero-priority',
    'frame-largest-bale'
    )
  );

-- carrier-street-sweep
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'carrier-street-sweep'),
    'ko',
    $$택배 노선 순회$$,
    $$한 지역의 우편 집배원이 한 번의 근무 동안 담당 구역의 모든 도로를 정확히 한 번씩 지나야 하며, 방문한 구역 코드를 순서대로 제출해야 합니다. 일방통행 도로 구간 목록 `routes`가 주어지며, 각 항목 `routes[i] = [from, to]`는 세 글자 구역 코드 사이에 반드시 거쳐야 하는 이동을 나타냅니다. 모든 근무는 분류 허브인 코드 `"HUB"`에서 시작합니다.

`"HUB"`에서 출발하여 모든 구간을 정확히 한 번씩 사용하는 하나의 경로를 복원하세요. 유효한 경로가 여러 개 존재하는 경우, 구역 코드를 앞에서부터 비교했을 때 **사전순으로 가장 작은** 경로를 반환합니다.

입력에는 항상 최소 하나의 유효한 경로가 존재한다고 보장됩니다.

**예시 1:**
```
Input: routes = [["ELM","HUB"],["HUB","BIR"],["BIR","ELM"],["HUB","CED"]]
Output: ["HUB","BIR","ELM","HUB","CED"]
Explanation: The walk HUB -> BIR -> ELM -> HUB -> CED consumes all four segments. Picking CED first would strand the carrier before BIR and ELM are reached.
```

**예시 2:**
```
Input: routes = [["HUB","NOR"],["HUB","SOU"],["NOR","SOU"],["SOU","HUB"],["SOU","NOR"]]
Output: ["HUB","NOR","SOU","HUB","SOU","NOR"]
Explanation: Visiting NOR before SOU from the hub gives the lex-smallest walk that still lets the carrier finish every segment.
```$$,
    $$- `1 <= routes.length <= 320`
- `routes[i].length == 2`
- 각 `from`과 `to`는 세 글자 대문자 구역 코드입니다
- 같은 구간 안에서 `from != to`
- 주어진 구간들은 `"HUB"`에서 시작하는 유효한 경로를 최소 하나 이상 허용합니다$$
);

-- responder-relay-cost
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'responder-relay-cost'),
    'ko',
    $$긴급 출동 중계 비용$$,
    $$한 상황실은 `0`부터 `n - 1`까지 번호가 붙은 `n`개의 관할구를 인접한 대응 스테이션 사이의 일방향 중계 회선으로 연결합니다. 각 항목 `corridors[i] = [from, to, minutes]`는 관할구 `from`에서 관할구 `to`로 호출을 넘기는 중계이며, 이때 `minutes`분 만큼의 무선 교신 시간이 소요됨을 의미합니다.

출발 관할구 `src`, 도착 관할구 `dst`, 그리고 중계 도중 거쳐갈 수 있는 중간 관할구의 최대 개수 `maxHops`가 주어졌을 때, `src`에서 `dst`로 호출을 전달하는 데 필요한 **최소 총 소요 분**을 반환하세요. `maxHops` 이내의 중간 관할구로는 유효한 중계 경로를 만들 수 없다면 `-1`을 반환합니다.

**예시 1:**
```
Input: n = 5, corridors = [[0,1,50],[1,2,40],[0,2,200],[2,3,30],[3,4,20],[1,3,150]], src = 0, dst = 4, maxHops = 2
Output: 220
Explanation: The relay 0 -> 1 -> 3 -> 4 (cost 50 + 150 + 20 = 220) uses 2 intermediate districts. The cheaper chain 0 -> 1 -> 2 -> 3 -> 4 would need 3 intermediates and is rejected.
```

**예시 2:**
```
Input: n = 4, corridors = [[0,1,80],[1,2,40],[0,2,300],[2,3,90],[0,3,400]], src = 0, dst = 3, maxHops = 0
Output: 400
Explanation: With `maxHops = 0` only the direct corridor 0 -> 3 at 400 minutes qualifies, even though 0 -> 1 -> 2 -> 3 would total 210.
```$$,
    $$- `1 <= n <= 120`
- `0 <= corridors.length <= n * (n - 1) / 2`
- `corridors[i].length == 3`
- `0 <= from, to < n`, `from != to`
- `1 <= minutes <= 8000`
- `0 <= src, dst, maxHops < n`
- `src != dst`$$
);

-- duplicate-catalog-link
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'duplicate-catalog-link'),
    'ko',
    $$중복된 도서 상호 참조$$,
    $$한 사서가 `1`부터 `n`까지 번호가 붙은 `n`개의 도서 항목에 대한 상호 참조 그래프를 관리하고 있습니다. 이 참조 네트워크는 원래 트리였지만, 일괄 가져오기 과정에서 잘못된 상호 참조 하나가 끼어들어 지금은 정확히 하나의 사이클이 존재합니다. 현재의 참조 목록은 `links`로 주어지며, 각 `links[i] = [a, b]`는 항목 `a`와 `b` 사이의 무방향 상호 참조를 의미합니다.

참조 그래프를 다시 트리로 만들기 위해 제거해야 하는 참조 하나를 반환하세요. 사이클을 끊을 수 있는 참조가 여럿이라면, `links`에서 **가장 뒤에** 나타나는 것을 반환합니다.

**예시 1:**
```
Input: links = [[1,2],[2,3],[1,3]]
Output: [1,3]
Explanation: Entries 1, 2, and 3 form the cycle 1 - 2 - 3 - 1. Retiring [1,3] leaves the valid tree 1 - 2 - 3.
```

**예시 2:**
```
Input: links = [[1,2],[2,3],[3,4],[4,5],[2,5],[1,6]]
Output: [2,5]
Explanation: The cycle is 2 - 3 - 4 - 5 - 2. Both [3,4] and [2,5] belong to it, but [2,5] appears later, so it is the one to drop.
```$$,
    $$- `n == links.length`
- `3 <= n <= 1200`
- `links[i].length == 2`
- `1 <= links[i][0], links[i][1] <= n`
- `links[i][0] != links[i][1]`
- 같은 쌍을 나타내는 참조는 존재하지 않습니다
- 참조 그래프는 연결되어 있으며 정확히 하나의 사이클을 포함합니다$$
);

-- irrigation-pipe-plan
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'irrigation-pipe-plan'),
    'ko',
    $$관개 배관 설계$$,
    $$농지에 관개 배관을 매설하려고 하며, 각 밸브는 부지 격자 위에 정해진 좌표를 가집니다. 밸브 목록 `valves`가 주어지며, 각 `valves[i] = [xi, yi]`는 부지 지도 상 밸브 `i`의 위치를 나타냅니다. 배관은 격자에 나란한 굴착 통로를 따라 매설되므로, 밸브 `i`와 `j`를 직접 잇는 배관의 비용은 맨해튼 거리 `|xi - xj| + |yi - yj|` 미터입니다.

모든 밸브가 직접 연결되거나 다른 밸브들을 거쳐 서로 도달할 수 있도록 하는 데 필요한 **최소 총 배관 길이**를 반환하세요.

**예시 1:**
```
Input: valves = [[4,4],[4,3],[6,7],[10,2]]
Output: 13
Explanation: Laying pipes [4,4]-[4,3] (length 1), [4,4]-[6,7] (length 5), and [4,3]-[10,2] (length 7) connects every valve for a total of 13 meters.
```

**예시 2:**
```
Input: valves = [[0,0],[2,0]]
Output: 2
Explanation: Only one pipe of length 2 is needed to join the two valves.
```$$,
    $$- `1 <= valves.length <= 1200`
- `-10^8 <= xi, yi <= 10^8`
- 모든 밸브의 좌표는 서로 다릅니다$$
);

-- flooded-corridor-crossing
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'flooded-corridor-crossing'),
    'ko',
    $$침수 도로 돌파$$,
    $$폭우로 도심의 `n x n` 교차로 격자가 침수되고 있습니다. `n x n` 행렬 `elevation`이 주어지며, `elevation[r][c]`는 `r`행 `c`열 교차로의 노면 높이입니다. 물은 일정한 속도로 차오릅니다. 시각 `t`일 때 높이가 `<= t`인 교차로는 통행이 가능하고, `> t`인 교차로는 통과할 수 없습니다.

긴급 출동 차량이 `(0, 0)`에서 출발해 `(n - 1, n - 1)`까지 가야 합니다. 통행 가능한 교차로에서는 상하좌우 4방향으로 인접한 통행 가능한 교차로로 이동할 수 있습니다. 이러한 경로가 처음으로 존재하게 되는 **최소 수위 `t`**를 반환하세요.

**예시 1:**
```
Input: elevation = [[1,0],[2,3]]
Output: 3
Explanation: The destination itself has deck height 3, so no route can exist before `t = 3`. At `t = 3` every cell is drivable.
```

**예시 2:**
```
Input: elevation = [[0,3,1,2],[7,4,5,8],[11,13,15,12],[6,9,10,14]]
Output: 14
Explanation: The lowest peak along the best route (0,0) -> (1,0) -> (2,0) -> (3,0) -> (3,1) -> (3,2) -> (3,3) is 14, the deck height of the destination itself.
```$$,
    $$- `n == elevation.length == elevation[i].length`
- `1 <= n <= 60`
- `0 <= elevation[r][c] < n * n`
- `elevation` 안의 모든 노면 높이는 서로 다릅니다$$
);

-- transit-alert-wave
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'transit-alert-wave'),
    'ko',
    $$지하철 경보 전파$$,
    $$한 지하철 운영 관제실이 특정 역에서 서비스 경보를 송출한 뒤, 마지막으로 경보를 받는 역이 언제 수신하는지 알고 싶어합니다. 철도망에는 `1`부터 `n`까지 번호가 붙은 `n`개의 역이 있습니다. 일방향 경보 중계 목록 `links`가 주어지며, 각 `links[i] = [source, target, minutes]`는 역 `source`에서 역 `target`으로 `minutes`분 뒤 중계가 발사됨을 뜻합니다. 경보는 나가는 모든 중계를 통해 동시에 전파되며, 각 역은 처음 경보를 받은 순간 곧바로 재송출합니다.

송출 시작 역 `src`가 주어졌을 때, 모든 역이 경보를 받는 데까지 걸리는 **최소 시간(분)**을 반환하세요. `src`로부터 경보를 전혀 받을 수 없는 역이 하나라도 있다면 `-1`을 반환합니다.

**예시 1:**
```
Input: links = [[1,2,4],[1,3,2],[3,2,1],[2,4,3],[3,4,7]], n = 4, src = 1
Output: 6
Explanation: Station 3 hears the alert at minute 2, station 2 hears it at minute 3 (via 1 -> 3 -> 2), and station 4 hears it at minute 6 (via 1 -> 3 -> 2 -> 4). The slowest station finishes at minute 6.
```

**예시 2:**
```
Input: links = [[1,2,5]], n = 3, src = 1
Output: -1
Explanation: No relay leads to station 3, so it never receives the alert.
```$$,
    $$- `1 <= n <= 120`
- `1 <= links.length <= 6500`
- `links[i].length == 3`
- `1 <= source, target <= n`, `source != target`
- `1 <= minutes <= 120`
- 모든 `(source, target)` 쌍은 고유합니다$$
);

-- scene-shoot-order
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'scene-shoot-order'),
    'ko',
    $$촬영 장면 순서 복원$$,
    $$한 제작 코디네이터가 소문자 알파벳으로 된 장면 태그 더미를 들고 있습니다. 이 태그들은 촬영팀에게 어떤 장면부터 준비할지 알려주는 스튜디오 내부의 고유한 우선순위 — 즉 26개 알파벳에 대한 어떤 알려지지 않은 순열 — 에 따라 미리 정렬되어 있습니다. 미리 정렬된 장면 태그 목록 `cues`가 주어졌을 때, 다음 촬영 콜시트가 해당 순서를 따를 수 있도록 스튜디오의 내부 알파벳 순서를 하나의 문자열로 복원하세요.

서로 인접한 두 태그가 어떤 순서로도 성립할 수 없다면(예: 짧은 태그가 그 접두사와 같은 긴 태그보다 뒤에 나오는 경우), 빈 문자열 `""`을 반환합니다. 일관된 순서가 가능한 경우, `cues`에 실제로 등장하는 알파벳에 대해 정확히 하나의 순서만 존재하도록 입력이 설계되어 있습니다.

**예시 1:**
```
Input: cues = ["ab","ba","bc","cb","cd","dc"]
Output: "abcd"
Explanation: Adjacent pairs give a before b, a before c, b before c, b before d, and c before d. The only consistent ordering of the letters a, b, c, d is a -> b -> c -> d.
```

**예시 2:**
```
Input: cues = ["studio","stud"]
Output: ""
Explanation: The tag "stud" is a prefix of "studio" but appears after it, which no letter ordering can justify, so the input is inconsistent.
```$$,
    $$- `cues`에는 최소 하나의 태그가 포함됩니다
- 각 태그는 소문자 영문자로 이루어진 비어 있지 않은 문자열입니다
- 유효한 순서가 존재할 때, 테스트 입력은 `cues`에 등장하는 알파벳에 대해 인접 쌍 제약과 일관되는 순서가 정확히 하나만 존재하도록 구성됩니다$$
);

-- match-recipe-ingredients
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'match-recipe-ingredients'),
    'ko',
    $$레시피 재료 일치 판정$$,
    $$한 베이커리의 레시피 북에서는 두 배합이 동일한 재료 토큰의 다중집합(multiset)을 사용한다면 — 적힌 순서와 무관하게 — 동등한 배합으로 간주합니다. 소문자 알파벳으로 이루어진 두 재료 코드 문자열 `recipeA`와 `recipeB`(각 알파벳은 하나의 재료 토큰을 의미)가 주어졌을 때, 두 레시피가 같은 토큰을 같은 개수로 사용하면 `true`, 그렇지 않으면 `false`를 반환하도록 `matchRecipe`를 구현하세요.

두 문자열의 길이가 다르면 결코 동등할 수 없습니다.

**예시 1:**
```
Input: recipeA = "butter", recipeB = "bruett"
Output: true
Explanation: Both recipes use one 'b', one 'u', one 'e', one 'r', and two 't' tokens.
```

**예시 2:**
```
Input: recipeA = "yeast", recipeB = "toast"
Output: false
Explanation: recipeA contains 'y' and 'e' which recipeB does not have, so the multisets differ.
```$$,
    $$- `1 <= recipeA.length, recipeB.length <= 4 * 10^4`
- `recipeA`와 `recipeB`는 소문자 영문자로 구성됩니다.$$
);

-- cluster-barrel-signatures
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'cluster-barrel-signatures'),
    'ko',
    $$오크 배럴 시그니처 묶기$$,
    $$한 셀러 마스터는 소문자 알파벳으로 된 테이스팅 노트 문자열로 각 오크 배럴에 라벨을 붙여 두었습니다. 두 배럴은 라벨이 같은 알파벳 다중집합의 순열일 때 — 즉 같은 노트를 순서만 다르게 적어둔 경우 — 같은 **시그니처**를 공유한다고 봅니다. 배럴 테이스팅 노트 문자열 배열 `labels`가 주어졌을 때, 같은 시그니처를 가진 라벨들을 묶어 그 그룹들을 반환하도록 `clusterBarrels`를 구현하세요.

각 내부 라벨 리스트는 사전순으로 정렬되어야 하며, 바깥쪽 리스트 역시 각 그룹의 첫 번째 라벨을 기준으로 사전순 정렬되어야 합니다.

**예시 1:**
```
Input: labels = ["oakvanilla","vanillaoak","plum","lump","berrytannin","tanninberry","oak"]
Output: [["berrytannin","tanninberry"],["lump","plum"],["oak"],["oakvanilla","vanillaoak"]]
```

**예시 2:**
```
Input: labels = ["merlot"]
Output: [["merlot"]]
```$$,
    $$- `1 <= labels.length <= 8 * 10^3`
- `0 <= labels[i].length <= 100`
- `labels[i]`는 소문자 영문자로 구성됩니다.$$
);

-- station-throughput-shares
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'station-throughput-shares'),
    'ko',
    $$공정 스테이션 생산량 지분$$,
    $$조립 라인에는 여러 스테이션이 직렬로 배치되어 있으며, 각 스테이션은 사이클당 정수 단위의 생산량(throughput)을 냅니다. 보고용으로, 각 스테이션의 **생산량 지분**은 라인 위 *나머지 모든* 스테이션의 생산량을 곱한 값으로 정의됩니다. 정수 배열 `rates`(여기서 `rates[i]`는 스테이션 `i`의 생산량)가 주어졌을 때, 동일한 길이의 배열 `shares`를 반환하도록 `computeStationShare`를 구현하세요. 이때 `shares[i]`는 모든 `j != i`에 대한 `rates[j]`의 곱과 같아야 합니다.

`rates`의 임의의 접두사 또는 접미사의 곱은 부호 있는 32비트 정수 범위에 들어옴이 보장됩니다. 나눗셈을 사용하지 않고 선형 시간에 풀어야 합니다.

**예시 1:**
```
Input: rates = [2,3,5,4]
Output: [60,40,24,30]
Explanation: For station 0: 3*5*4 = 60. For station 1: 2*5*4 = 40. And so on.
```

**예시 2:**
```
Input: rates = [-2,1,0,4,-1]
Output: [0,0,8,0,0]
Explanation: Every share except index 2 multiplies through the zero at station 2. The share for station 2 is (-2)*1*4*(-1) = 8.
```$$,
    $$- `2 <= rates.length <= 2 * 10^5`
- `-30 <= rates[i] <= 30`
- `rates`의 임의의 접두사 또는 접미사의 곱은 부호 있는 32비트 정수 범위에 들어옵니다.$$
);

-- sort-material-bins
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'sort-material-bins'),
    'ko',
    $$재료 분리함 정렬$$,
    $$재활용 공장 컨베이어에는 세 가지 재료 코드가 섞인 채로 흘러오고 있으며, 압축 공정으로 넘기기 전에 정해진 순서대로 분리함에 다시 담아야 합니다. `0`은 종이, `1`은 플라스틱, `2`는 금속을 의미합니다. 이 세 가지 코드만 들어 있는 정수 배열 `materials`가 주어질 때, `sortMaterials`를 구현하여 배열을 **제자리에서** 재배치해 종이 코드가 모두 앞에, 그다음 플라스틱 코드, 마지막으로 금속 코드가 오도록 만드세요.

라이브러리 정렬 함수는 호출하지 마세요. 이 함수는 아무것도 반환하지 않으며, 호출자는 함수 호출 이후 `materials`를 직접 확인합니다.

**예시 1:**
```
Input: materials = [1,2,0,2,1,0,1]
Output: [0,0,1,1,1,2,2]
Explanation: Two paper codes, three plastic codes, then two metal codes.
```

**예시 2:**
```
Input: materials = [2,1,0]
Output: [0,1,2]
```$$,
    $$- `1 <= materials.length <= 2 * 10^3`
- `materials[i]`는 `0`, `1`, 또는 `2`입니다.$$
);

-- repeat-tracking-codes
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'repeat-tracking-codes'),
    'ko',
    $$중복 송장 번호 찾기$$,
    $$우편 분류소에서는 교대 근무 동안 스캔한 소포 수를 `n`이라 할 때, 각 소포에 `1`부터 `n` 사이의 **송장 번호**를 찍습니다. 감사에서 일부 번호가 실수로 정확히 두 개의 소포에 찍혔고, 나머지는 한 번씩만 찍힌 것으로 확인되었습니다. 길이가 `n`이고 `1 <= codes[i] <= n`을 만족하는 정수 배열 `codes`가 주어질 때, `listRepeatedCodes`를 구현하여 **정확히 두 번** 스캔된 모든 송장 번호를 반환하세요.

결과는 어떤 순서로 반환해도 괜찮습니다. 선형 시간과 출력 리스트 외에는 상수 크기의 추가 메모리만 사용하는 것을 목표로 하세요.

**예시 1:**
```
Input: codes = [5,2,6,3,2,1,4,6]
Output: [2,6]
Explanation: Code 2 appears at indices 1 and 4; code 6 appears at indices 2 and 7.
```

**예시 2:**
```
Input: codes = [3,3,1,2]
Output: [3]
```$$,
    $$- `n == codes.length`
- `1 <= n <= 2 * 10^5`
- `1 <= codes[i] <= n`
- 각 번호는 한 번 또는 두 번만 등장합니다.$$
);

-- detect-callnumber-clash
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'detect-callnumber-clash'),
    'ko',
    $$청구기호 충돌 감지$$,
    $$반납된 책을 카트에 담아 다시 서가에 꽂을 때, 카트 안의 두 권 이상이 같은 정수 **청구기호**를 가지고 있다면 **청구기호 충돌**이 발생한 것입니다. 이는 중복 구매이거나 스캔 오류일 가능성이 있어 재검토가 필요하다는 신호입니다. 카트에 놓인 책들의 청구기호를 담은 정수 배열 `callNumbers`가 주어질 때, `detectClash`를 구현하여 같은 값이 하나라도 반복되면 `true`, 모든 청구기호가 서로 다르면 `false`를 반환하세요.

**예시 1:**
```
Input: callNumbers = [7,2,9,7]
Output: true
Explanation: The call number 7 appears at index 0 and index 3.
```

**예시 2:**
```
Input: callNumbers = [11,22,33,44]
Output: false
Explanation: All four call numbers on the cart are distinct.
```$$,
    $$- `1 <= callNumbers.length <= 2 * 10^5`
- `-10^8 <= callNumbers[i] <= 10^8`$$
);

-- lowest-missing-target
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'lowest-missing-target'),
    'ko',
    $$비어 있는 최소 청구기호$$,
    $$아카이브 구역의 반납 카트에는 정수 청구기호가 달린 책들이 `callNumbers`에 담겨 있습니다. 사서는 다음에 어떤 분류 칸을 재주문해야 할지 알기 위해, 카트에 존재하지 *않는* **가장 작은 양의 청구기호**를 찾고자 합니다. 음수 태그와 0은 분류 과정의 잡음이므로 무시합니다.

`lowestMissingTarget`을 구현하여 `callNumbers`에 등장하지 않는 가장 작은 양의 정수를 반환하세요. 배열은 정렬되어 있지 않으며 중복, 0, 음수 값을 포함할 수 있습니다. O(n) 시간과 O(1) 보조 공간을 목표로 하세요.

**예시 1:**
```
Input: callNumbers = [2,3,1,5]
Output: 4
Explanation: 1, 2, 3 are all present. 4 is the smallest positive integer absent from the cart.
```

**예시 2:**
```
Input: callNumbers = [6,-2,8,10]
Output: 1
Explanation: No copy of 1 appears on the cart, so 1 is the first missing slot.
```$$,
    $$- `1 <= callNumbers.length <= 2 * 10^5`
- `|callNumbers[i]| <= 10^8`$$
);

-- unique-topic-window
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'unique-topic-window'),
    'ko',
    $$주제 구간 최대 길이$$,
    $$수집 파이프라인은 들어오는 각 기사에 소문자 알파벳 하나로 된 주제 태그를 붙이고, 도착 순서대로 이어 붙여 문자열 `feed`를 만듭니다. 편집부는 순환 배너가 한 주제 묶음 안에서 자연스럽게 돌아가도록, 서로 다른 주제를 최대 `k`개까지만 포함하는 **가장 긴 연속 구간**의 길이를 알고 싶어 합니다.

`countUniqueTopics`를 구현하여 `feed` 안에서 서로 다른 문자가 최대 `k`개 들어 있는 가장 긴 연속 부분 문자열의 길이를 반환하세요. `k`가 0이면 0을 반환합니다.

**예시 1:**
```
Input: feed = "yyxzxxz", k = 2
Output: 5
Explanation: The span "xzxxz" uses only the topics x and z and has length 5.
```

**예시 2:**
```
Input: feed = "rrrrrr", k = 1
Output: 6
Explanation: Every character is the same topic, so the whole feed fits inside one distinct topic.
```$$,
    $$- `1 <= feed.length <= 8 * 10^4`
- `0 <= k <= 50`
- `feed`는 소문자 영어 알파벳으로만 구성됩니다.$$
);

-- busiest-machines-list
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'busiest-machines-list'),
    'ko',
    $$가장 바쁜 운동기구 목록$$,
    $$헬스장 예약 시스템은 하루 동안의 모든 운동기구 체크인을 정수 기구 ID로 `checkIns`에 기록합니다. 관리팀은 정비 일정을 계획하기 위해, 예약 횟수가 가장 많은 상위 `k`개의 **바쁜 기구** 목록이 담긴 전단을 만들고자 합니다.

`busiestMachines`를 구현하여 `checkIns`에 가장 자주 등장하는 `k`개의 기구 ID를 반환하세요. ID는 어떤 순서로 반환해도 괜찮습니다. `k`번째 자리에서 동점이 발생하지 않아 답은 항상 유일합니다.

**예시 1:**
```
Input: checkIns = [4,4,4,7,7,5], k = 2
Output: [4,7]
Explanation: Machine 4 logged 3 check-ins, machine 7 logged 2, machine 5 logged 1. The top 2 ids are 4 and 7.
```

**예시 2:**
```
Input: checkIns = [9], k = 1
Output: [9]
```$$,
    $$- `1 <= checkIns.length <= 2 * 10^5`
- `|checkIns[i]| <= 10^8`
- `k`의 범위는 `[1, the number of distinct machine ids in checkIns]` 입니다.
- 답은 항상 유일함이 보장됩니다.$$
);

-- unpaired-frame-reading
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'unpaired-frame-reading'),
    'ko',
    $$짝 없는 프레임 판독$$,
    $$천문대의 하룻밤 관측이 끝나면 원시 프레임 밝기 태그가 가득한 `frames`가 남습니다. 모든 프레임은 필터마다 한 번씩, 즉 두 번 촬영되었지만 딱 한 장의 보정용 프레임만 한 번만 찍혔습니다. 보정 로그에 첨부할 그 짝 없는 판독값을 찾아내야 합니다.

`findUnpairedFrame`을 구현하여 `frames`에서 정확히 한 번만 나타나는 정수를 반환하세요. 나머지 값들은 모두 정확히 두 번씩 등장합니다. O(n) 시간과 O(1) 추가 공간으로 해결하세요.

**예시 1:**
```
Input: frames = [5,5,3]
Output: 3
Explanation: 5 was captured twice; 3 only once.
```

**예시 2:**
```
Input: frames = [8,2,6,2,6]
Output: 8
Explanation: 2 and 6 each appear twice. 8 is the lone reading.
```$$,
    $$- `1 <= frames.length <= 8 * 10^4`
- `|frames[i]| <= 10^8`
- `frames`의 모든 값은 정확히 두 번씩 등장하며, 한 값만 정확히 한 번 등장합니다.$$
);

-- longest-seat-block
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'longest-seat-block'),
    'ko',
    $$연속 좌석 최장 블록$$,
    $$공연 티켓 오픈 직전, 공연장의 판매 리스트 `seatIds`에는 여러 구역에 걸쳐 아직 판매되지 않은 좌석 번호들이 뒤섞여 담겨 있습니다. 매표소는 여행사 파트너에게 단체 홀드로 제공하기 위해 `40, 41, 42, 43`처럼 **연속한 좌석 번호로 이어지는 가장 긴 블록**의 길이를 알고 싶어 합니다.

`longestSeatBlock`을 구현하여 `seatIds`의 값들로 만들 수 있는 연속 정수 구간의 최대 길이를 반환하세요. 중복된 값은 무시합니다. 알고리즘은 O(n) 시간 안에 동작해야 합니다.

**예시 1:**
```
Input: seatIds = [42,7,41,40,9,8,43]
Output: 4
Explanation: The consecutive block 40, 41, 42, 43 has length 4.
```

**예시 2:**
```
Input: seatIds = [11,13,12,15,16,14,20,19,18]
Output: 6
Explanation: The block 11, 12, 13, 14, 15, 16 has length 6.
```$$,
    $$- `0 <= seatIds.length <= 2 * 10^5`
- `|seatIds[i]| <= 10^8`$$
);

-- next-shot-order
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'next-shot-order'),
    'ko',
    $$다음 촬영 순서$$,
    $$영화 촬영팀은 하루의 촬영 순서를 정수 샷 번호 배열 `shotOrder`로 관리합니다. 촬영이 끝나면 조감독은 같은 샷 번호들로 만들 수 있는 **사전순으로 바로 다음에 오는 배열**로 라인업을 넘겨 다음 날의 콜시트로 삼습니다. 오늘 라인업이 이미 마지막(엄격히 감소하는 순서)이라면, 가장 앞선 배열(엄격히 증가하는 순서)로 초기화합니다.

`advanceShotOrder`를 구현하여 `shotOrder`를 **제자리에서** 다음으로 큰 순열로 재배치하거나, 더 큰 순열이 없다면 가장 작은 순열로 바꾸세요. 추가 메모리는 상수 크기만 사용해야 합니다.

**예시 1:**
```
Input: shotOrder = [2,3,4]
Output: [2,4,3]
Explanation: The next arrangement after [2,3,4] is [2,4,3].
```

**예시 2:**
```
Input: shotOrder = [5,4,3,2]
Output: [2,3,4,5]
Explanation: [5,4,3,2] is the largest arrangement, so the lineup resets to ascending order.
```$$,
    $$- `1 <= shotOrder.length <= 100`
- `0 <= shotOrder[i] <= 100`$$
);

-- merge-reservation-windows
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'merge-reservation-windows'),
    'ko',
    $$예약 시간대 병합$$,
    $$레스토랑의 호스트는 테이블 예약을 `[start, end]` 쌍으로 관리하며, 각 쌍은 손님이 앉는 시각과 테이블을 비우는 시각(분 단위)을 의미합니다. 시간이 조금이라도 겹치는 두 예약, 심지어 끝점 하나만 맞닿는 경우라도 하나의 연속된 점유 블록으로 합쳐져야 바닥 도면 상 한 팀이 테이블을 이어 사용하는 것으로 표시됩니다.

`seatings[i] = [start_i, end_i]` 형태의 예약 리스트 `seatings`가 주어질 때, `mergeSeatingWindows`를 구현하여 원래 예약들을 모두 덮으면서 서로 겹치지 않는 최소 개수의 시간대 리스트를 반환하세요. 시간대는 시작 시각 기준 오름차순으로 정렬해 반환합니다.

**예시 1:**
```
Input: seatings = [[2,5],[4,7],[9,11],[14,16]]
Output: [[2,7],[9,11],[14,16]]
Explanation: Seatings [2,5] and [4,7] share minutes 4 and 5, so they fuse into [2,7]. The other two windows stay separate.
```

**예시 2:**
```
Input: seatings = [[1,3],[3,8],[10,12]]
Output: [[1,8],[10,12]]
Explanation: [1,3] and [3,8] touch at minute 3, which counts as overlap, so they merge into [1,8].
```$$,
    $$- `1 <= seatings.length <= 2 * 10^5`
- `seatings[i].length == 2`
- `0 <= start_i <= end_i <= 10^8`$$
);

-- headline-majority-pick
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'headline-majority-pick'),
    'ko',
    $$헤드라인 다수결 선정$$,
    $$뉴스 집계 서비스가 한꺼번에 들어온 기사들을 수집하며 각 기사에 주제 id를 하나씩 태깅합니다. 편집 데스크는 이 묶음에서 과반을 차지하는 주제, 즉 전체 기사 수의 절반을 초과해 등장한 주제를 찾아 해당 클러스터를 메인 페이지 상단에 고정하려 합니다.

크기 `n`의 정수 배열 `topics`가 주어질 때, `n / 2`번보다 더 많이 등장한 주제 id를 반환하도록 `majorityHeadline`을 구현하세요. 지배적인 주제는 항상 존재함이 보장됩니다.

**예시 1:**
```
Input: topics = [4,7,4]
Output: 4
```

**예시 2:**
```
Input: topics = [5,5,6,6,6,5,6]
Output: 6
Explanation: Topic 6 appears 4 times out of 7 articles, which is more than half.
```

**예시 3:**
```
Input: topics = [9]
Output: 9
```$$,
    $$- `1 <= topics.length <= 2 * 10^5`
- `-10^8 <= topics[i] <= 10^8`
- 지배적인 주제가 항상 존재합니다.$$
);

-- compact-shelved-copies
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'compact-shelved-copies'),
    'ko',
    $$서가 중복 도서 정리$$,
    $$도서관 인턴이 이미 비내림차순으로 정렬된 청구기호 순서로 책을 다시 꽂고 있습니다. 같은 제목의 여러 사본이 나란히 놓일 수 있는데, 인턴은 각 청구기호가 서가 앞쪽에 정확히 한 번씩만 나타나도록 정리하고 뒷부분은 그대로 둬도 상관없다고 합니다.

비내림차순으로 정렬된 정수 배열 `callNumbers`가 주어질 때, 고유한 청구기호를 원래 순서대로 `callNumbers`의 앞쪽에 덮어써 기록하고 고유한 값의 개수 `k`를 반환하도록 `compactShelf`를 구현하세요. `callNumbers`의 앞 `k`개 위치에는 고유한 순서열이 들어 있어야 하며, 인덱스 `k` 이후의 위치는 검사되지 않습니다.

**예시 1:**
```
Input: callNumbers = [2,2,5]
Output: 2, callNumbers = [2,5,_]
Explanation: Return k = 2. The front of the shelf now reads 2 then 5.
```

**예시 2:**
```
Input: callNumbers = [1,1,2,2,3,4,4,6,6,6]
Output: 5, callNumbers = [1,2,3,4,6,_,_,_,_,_]
Explanation: Five distinct call numbers (1, 2, 3, 4, 6) end up at the front in their original order.
```

**예시 3:**
```
Input: callNumbers = [8]
Output: 1, callNumbers = [8]
Explanation: A shelf with one copy is already compact.
```$$,
    $$- `1 <= callNumbers.length <= 2 * 10^5`
- `-100 <= callNumbers[i] <= 100`
- `callNumbers`는 비내림차순으로 정렬되어 있습니다.$$
);

-- rotate-park-map
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'rotate-park-map'),
    'ko',
    $$놀이공원 지도 회전$$,
    $$테마파크 운영 담당자는 상공에서 드론으로 촬영한 놀이기구 대기시간 데이터를 정사각형 격자로 보관합니다. 비행 사이에 드론의 짐벌이 시계 방향으로 90도 틀어지면, 저장된 격자를 어제의 지도와 비교하기 전에 먼저 방향을 맞춰야 하는데 지휘소의 태블릿은 메모리가 부족해 같은 크기의 격자를 하나 더 담을 수 없습니다.

`n x n` 정수 격자 `parkMap`이 주어질 때, 이 격자를 시계 방향으로 90도 **제자리에서(in-place)** 회전시키도록 `rotateParkMap`을 구현하세요. `parkMap`을 직접 변경해야 하며, 별도의 `n x n` 격자를 새로 할당해서는 안 됩니다.

**예시 1:**
```
Input: parkMap = [[2,4,6],[8,1,3],[5,7,9]]
Output: [[5,8,2],[7,1,4],[9,3,6]]
```

**예시 2:**
```
Input: parkMap = [[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]
Output: [[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]
```$$,
    $$- `n == parkMap.length == parkMap[i].length`
- `1 <= n <= 20`
- `-1000 <= parkMap[i][j] <= 1000`$$
);

-- species-grid-validator
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'species-grid-validator'),
    'ko',
    $$수조 배치 유효성 검사$$,
    $$한 수족관 시설은 전시용 수조를 큰 정사각형 격자 형태로 배치하고, 이를 9개의 동일한 직사각형 구역으로 나눕니다. 큐레이터는 기획 단계에서 각 수조에 종 코드(숫자 `1`부터 `9`까지) 를 지정하거나 비워 두는데(`.`), 규정상 같은 종이 한 행의 수조들, 한 열의 수조들, 또는 9개 구역 중 어느 한 구역 안에서 중복돼서는 안 됩니다. 아직 배정되지 않은 수조가 많더라도 이 규칙은 적용됩니다.

부분적으로 채워진 격자 `grid`가 주어질 때, 이미 채워진 모든 칸이 위의 세 가지 규칙을 모두 지키면 `true`, 그렇지 않으면 `false`를 반환하도록 `verifySpeciesGrid`를 구현하세요. 비어 있는 칸은 규칙 위반이 될 수 없으며, 기획이 완성 가능한지 여부는 검사하지 않고 이미 배치된 칸만 확인합니다.

**예시 1:**
```
Input: grid =
[[".",".",".",".",".",".",".",".","."]
,[".","1",".",".","2",".",".","3","."]
,[".",".",".",".",".",".",".",".","."]
,[".",".",".",".",".",".",".",".","."]
,[".","4",".",".","5",".",".","6","."]
,[".",".",".",".",".",".",".",".","."]
,[".",".",".",".",".",".",".",".","."]
,[".","7",".",".","8",".",".","9","."]
,[".",".",".",".",".",".",".",".","."]]
Output: true
Explanation: Every row, column, and wing contains at most one of each species code, so the plan is valid.
```

**예시 2:**
```
Input: grid =
[[".",".",".",".",".",".",".",".","."]
,[".","1",".",".","2",".",".","1","."]
,[".",".",".",".",".",".",".",".","."]
,[".",".",".",".",".",".",".",".","."]
,[".","4",".",".","5",".",".","6","."]
,[".",".",".",".",".",".",".",".","."]
,[".",".",".",".",".",".",".",".","."]
,[".","7",".",".","8",".",".","9","."]
,[".",".",".",".",".",".",".",".","."]]
Output: false
Explanation: Row 1 contains species code `1` in two different columns, which breaks the uniqueness rule for that row.
```$$,
    $$- `grid.length == 9`
- `grid[i].length == 9`
- 각 `grid[i][j]`는 `1`부터 `9`까지의 숫자이거나 문자 `'.'`입니다.$$
);

-- event-window-tally
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'event-window-tally'),
    'ko',
    $$이벤트 구간 집계$$,
    $$한 기상 관측소가 시간 단위 이상치 측정값 `readings`를 기록합니다. 양수는 그 시간대가 평년보다 더웠음을, 음수는 더 시원했음을, 0은 기준선에 맞았음을 의미합니다. 기후학자는 합이 정확히 `k`가 되는 연속 시간 구간의 개수를 세려 합니다. 이런 구간이 바로 월간 보고서에 표시할 만한 에너지 균형 상태를 나타내기 때문입니다.

측정값 배열 `readings`와 정수 목표값 `k`가 주어질 때, 값의 합이 `k`가 되는 `readings`의 연속 부분배열 총 개수를 반환하도록 `countWindowTallies`를 구현하세요. 측정값이 음수일 수 있으므로 단순한 슬라이딩 윈도우 방식은 직접적으로 통하지 않습니다.

**예시 1:**
```
Input: readings = [2,2,2], k = 4
Output: 2
Explanation: The windows readings[0..1] and readings[1..2] each sum to 4.
```

**예시 2:**
```
Input: readings = [3,1,2,4], k = 6
Output: 2
Explanation: The windows [3,1,2] and [2,4] both sum to 6.
```

**예시 3:**
```
Input: readings = [4,-4,0], k = 0
Output: 3
Explanation: [4,-4], [4,-4,0], and [0] each sum to 0.
```$$,
    $$- `1 <= readings.length <= 2 * 10^5`
- `-1000 <= readings[i] <= 1000`
- `-10^7 <= k <= 10^7`$$
);

-- station-visit-orders
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'station-visit-orders'),
    'ko',
    $$공정 방문 순서 나열$$,
    $$한 생산 라인에서 부품 한 개가 포장되기 전에 모든 공정 스테이션을 어떤 순서로든 한 번씩 거쳐야 합니다. 서로 다른 스테이션 ID가 담긴 배열 `stations`가 주어질 때, 부품이 각 스테이션을 정확히 한 번씩 방문할 수 있는 모든 순서를 반환합니다.

이러한 모든 순서를 리스트로 반환하도록 `listStationOrders`를 구현하세요. 바깥쪽 리스트의 순서는 임의로 정해도 됩니다.

**예시 1:**
```
Input: stations = [4,7,2]
Output: [[4,7,2],[4,2,7],[7,4,2],[7,2,4],[2,4,7],[2,7,4]]
Explanation: Three distinct stations give 3! = 6 possible visit orders.
```

**예시 2:**
```
Input: stations = [5,9]
Output: [[5,9],[9,5]]
```$$,
    $$- `1 <= stations.length <= 6`
- `-10 <= stations[i] <= 10`
- `stations`의 모든 원소는 서로 다릅니다.$$
);

-- enumerate-barrel-blends
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'enumerate-barrel-blends'),
    'ko',
    $$오크통 블렌드 전체 열거$$,
    $$한 와이너리에서 저장고 책임자가 번호가 매겨진 오크통들로 만들 수 있는 모든 블렌드를 목록화하려 합니다. 각 오크통에는 고유한 ID가 있고, 오크통의 어떠한 부분집합도(비워 두는 경우와 전부 섞는 경우 포함) 유효한 블렌드로 취급됩니다.

서로 다른 오크통 ID가 담긴 배열 `barrels`가 주어질 때, 가능한 모든 블렌드를 반환하도록 `listBarrelBlends`를 구현하세요. 바깥쪽 리스트의 순서는 임의여도 되지만, 각 블렌드 내부에서는 오크통이 `barrels`에 등장하는 상대적 순서를 유지해야 합니다.

**예시 1:**
```
Input: barrels = [2,5,8]
Output: [[],[2],[2,5],[2,5,8],[2,8],[5],[5,8],[8]]
Explanation: With 3 barrels there are 2^3 = 8 possible blends.
```

**예시 2:**
```
Input: barrels = [7]
Output: [[],[7]]
```$$,
    $$- `1 <= barrels.length <= 10`
- `-10 <= barrels[i] <= 10`
- `barrels`의 모든 원소는 서로 다릅니다.$$
);

-- split-zone-codes
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'split-zone-codes'),
    'ko',
    $$우편 구역 코드 분할$$,
    $$한 우편 분류원이 소포 옆면에 긴 숫자 문자열을 인쇄해 두면, 배송 분류 담당자는 이를 점(`.`)으로 구분된 정확히 네 개의 세그먼트로 이루어진 표준 **구역 코드(zone code)** 형식으로 구두점을 찍어야 합니다. 각 세그먼트는 `0`부터 `255`까지의 정수이며, 세그먼트 자체가 `"0"`인 경우를 제외하고는 앞에 0이 붙으면 안 됩니다.

십진수 숫자만 포함된 문자열 `digits`가 주어질 때, `digits`에 점 세 개를 정확히 삽입해 만들 수 있는 모든 유효한 구역 코드를 반환하도록 `splitZoneCodes`를 구현하세요. 결과는 사전순으로 정렬해 반환해야 하며, 유효한 구역 코드가 하나도 없다면 빈 리스트를 반환합니다.

**예시 1:**
```
Input: digits = "19216811"
Output: ["1.92.168.11","19.2.168.11","19.21.68.11","19.216.8.11","19.216.81.1","192.1.68.11","192.16.8.11","192.16.81.1","192.168.1.1"]
```

**예시 2:**
```
Input: digits = "0202"
Output: ["0.2.0.2"]
Explanation: Single-digit segments may be "0". A two-digit segment beginning with "0" would be rejected.
```$$,
    $$- `1 <= digits.length <= 20`
- `digits`는 십진수 숫자로만 이루어져 있습니다.$$
);

-- mirror-headline-splits
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'mirror-headline-splits'),
    'ko',
    $$대칭 헤드라인 분할$$,
    $$뉴스 집계 서비스의 에디터가 소문자로 표기된 헤드라인을 여러 하위 구절로 잘라, 각 구절이 앞에서 읽든 뒤에서 읽든 똑같이 읽히도록 나누려 합니다. 하위 구절은 글자 한 개짜리일 수도 있습니다.

문자열 `headline`이 주어질 때, `headline`을 대칭 형태(회문) 하위 구절들의 순서 있는 분할로 쪼개는 모든 경우를 반환하도록 `splitMirrorPhrases`를 구현하세요. 각 분할은 헤드라인 전체를 왼쪽에서 오른쪽으로 순서대로 빠짐없이 덮어야 합니다. 바깥쪽 리스트의 순서는 임의여도 됩니다.

**예시 1:**
```
Input: headline = "dbbc"
Output: [["d","b","b","c"],["d","bb","c"]]
Explanation: Two valid partitions. Every piece — "d", "b", "bb", "c" — is a palindrome.
```

**예시 2:**
```
Input: headline = "ef"
Output: [["e","f"]]
Explanation: "ef" is not a palindrome, so the only valid partition is letter-by-letter.
```$$,
    $$- `1 <= headline.length <= 16`
- `headline`은 소문자 영문자로만 이루어져 있습니다.$$
);

-- keypad-device-codes
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'keypad-device-codes'),
    'ko',
    $$키패드 기기 코드 변환$$,
    $$스마트홈 허브는 사용자가 벽면 키패드에 짧은 숫자 시퀀스를 입력하면 경보를 설정합니다. 그런데 각 숫자는 예전 전화기 키패드처럼 여러 글자를 나타내므로, 펌웨어는 해당 시퀀스가 표현할 수 있는 모든 글자 코드를 열거해야 합니다. 숫자-글자 매핑은 다음과 같습니다.

- `2`: `abc`
- `3`: `def`
- `4`: `ghi`
- `5`: `jkl`
- `6`: `mno`
- `7`: `pqrs`
- `8`: `tuv`
- `9`: `wxyz`

`2`부터 `9` 사이 문자로 이루어진 문자열 `digits`가 주어질 때, 해당 시퀀스로 만들 수 있는 모든 글자 코드를 반환하도록 `mapKeypadCodes`를 구현하세요. 결과는 임의의 순서로 반환해도 되며, `digits`가 비어 있다면 빈 리스트를 반환합니다.

**예시 1:**
```
Input: digits = "45"
Output: ["gj","gk","gl","hj","hk","hl","ij","ik","il"]
Explanation: Digit 4 maps to "ghi" and digit 5 maps to "jkl"; every pairing of one letter from each slot is included.
```

**예시 2:**
```
Input: digits = ""
Output: []
```$$,
    $$- `0 <= digits.length <= 4`
- `digits`의 모든 문자는 `'2'`부터 `'9'`까지의 숫자입니다.$$
);

-- taxiway-aircraft-layout
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'taxiway-aircraft-layout'),
    'ko',
    $$유도로 항공기 배치$$,
    $$지방 공항의 계류장 배정 담당자가 `n x n` 크기의 계류장 격자에 항공기 `n`대를 주기하려 합니다(한 행에 한 대씩). 이때 후류 분리 규정을 지켜야 하며, 두 항공기가 같은 열, 같은 북서-남동 대각선, 또는 같은 북동-남서 대각선에 위치하면 서로 충돌하는 것으로 봅니다.

격자의 한 변 길이 `n`이 주어질 때, 충돌이 없는 모든 서로 다른 배치를 반환하도록 `placeAircraft`를 구현합니다. 각 배치는 길이 `n`인 문자열 `n`개로 이루어진 리스트이며, `'Q'`는 주기된 항공기를, `'.'`는 빈 자리를 나타냅니다. 가능한 배치가 없다면 빈 리스트를 반환합니다. 배치들의 순서는 임의로 반환해도 됩니다.

**예시 1:**
```
Input: n = 5
Output: [["Q....","..Q..","....Q",".Q...","...Q."],["Q....","...Q.",".Q...","....Q","..Q.."],[".Q...","...Q.","Q....","..Q..","....Q"],[".Q...","....Q","..Q..","Q....","...Q."],["..Q..","Q....","...Q.",".Q...","....Q"],["..Q..","....Q",".Q...","...Q.","Q...."],["...Q.","Q....","..Q..","....Q",".Q..."],["...Q.",".Q...","....Q","..Q..","Q...."],["....Q",".Q...","...Q.","Q....","..Q.."],["....Q","..Q..","Q....","...Q.",".Q..."]]
Explanation: Ten non-conflicting layouts exist on a 5 x 5 apron.
```

**예시 2:**
```
Input: n = 3
Output: []
Explanation: No conflict-free layout exists on a 3 x 3 apron.
```$$,
    $$- `1 <= n <= 10`$$
);

-- voucher-price-combos
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'voucher-price-combos'),
    'ko',
    $$상품권 금액 조합$$,
    $$한 식료품 체인이 자체 브랜드 신제품을 홍보하면서, 고객이 고정된 상품권 금액에 딱 맞게 장바구니를 구성할 수 있는 모든 방법을 안내하려 합니다. 매장에서는 서로 다른 가격의 품목들로 구성된 소형 카탈로그를 제공하며, 각 품목은 재고가 충분해 원하는 만큼 몇 번이든 담을 수 있습니다.

서로 다른 양의 정수 가격을 담은 배열 `prices`와 양의 정수 `voucher`가 주어질 때, 가격의 합이 정확히 `voucher`가 되는 모든 고유한 장바구니를 반환하도록 `listVoucherSums`를 구현합니다. 각 장바구니는 가격들의 리스트이며 중복 선택을 허용합니다. 어떤 가격이 몇 번 등장하는지가 한 번이라도 다르면 서로 다른 장바구니로 간주합니다. 장바구니들의 순서는 임의로 반환해도 됩니다.

**예시 1:**
```
Input: prices = [2,4,5], voucher = 9
Output: [[2,2,5],[4,5]]
Explanation: 2 + 2 + 5 = 9 and 4 + 5 = 9 are the only two baskets that match the voucher.
```

**예시 2:**
```
Input: prices = [3,4,7], voucher = 10
Output: [[3,3,4],[3,7]]
```$$,
    $$- `1 <= prices.length <= 30`
- `2 <= prices[i] <= 40`
- `prices`의 모든 원소는 서로 다릅니다.
- `1 <= voucher <= 40`$$
);

-- batch-quota-combos
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'batch-quota-combos'),
    'ko',
    $$배치 할당 조합$$,
    $$한 인쇄소가 들어오는 작업들을 페이지 수별로 묶어, 특정 인쇄 한 회차의 `quota`(할당량)에 정확히 맞는 모든 서로 다른 작업 집합을 보고하려고 합니다. 여러 고객이 같은 분량의 작업을 제출할 수 있어 `jobs` 목록에는 페이지 수가 같은 작업이 여러 개 있을 수 있지만, 각 작업은 한 집합에서 최대 한 번만 사용할 수 있습니다.

페이지 수(중복 포함 가능)를 담은 정수 배열 `jobs`와 양의 정수 `quota`가 주어질 때, 합이 정확히 `quota`가 되는 모든 고유한 페이지 수 집합을 반환하도록 `listQuotaBatches`를 구현합니다. 같은 다중집합(multiset)을 이루는 집합들은 동일한 것으로 간주하므로, 중복된 다중집합은 결과에 포함시키지 않습니다. 집합들의 순서는 임의로 반환해도 됩니다.

**예시 1:**
```
Input: jobs = [2,3,6,1,3,4], quota = 7
Output: [[1,2,4],[1,3,3],[1,6],[3,4]]
```

**예시 2:**
```
Input: jobs = [4,2,1,2,3], quota = 5
Output: [[1,2,2],[1,4],[2,3]]
```

**예시 3:**
```
Input: jobs = [8,8,8], quota = 16
Output: [[8,8]]
Explanation: Although the value 8 appears three times, the only multiset of job sizes that adds to 16 is a pair of 8s.
```$$,
    $$- `1 <= jobs.length <= 100`
- `1 <= jobs[i] <= 50`
- `1 <= quota <= 30`$$
);

-- montage-scene-picks
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'montage-scene-picks'),
    'ko',
    $$몽타주 장면 선택$$,
    $$한 영화 편집자가 티저 예고편용 클립 릴을 구성하면서 가능한 모든 장면 몽타주를 미리 보려고 합니다. 각 장면은 길이 코드(정수)로 표현되며, 짧은 간삽 컷들이 같은 길이를 공유하는 경우가 많아 길이 코드 리스트 `scenes`에는 중복 값이 포함될 수 있습니다.

정수 배열 `scenes`가 주어질 때, 몽타주(선택된 길이 코드들의 리스트) 전체 멱집합을 반환하도록 `listMontageScenes`를 구현합니다. 같은 다중집합을 이루는 몽타주들은 동일한 것으로 간주하므로 중복된 몽타주는 결과에 포함되어서는 안 됩니다. 빈 몽타주도 포함합니다. 몽타주들의 순서는 임의로 반환해도 됩니다.

**예시 1:**
```
Input: scenes = [2,5,5]
Output: [[],[2],[2,5],[2,5,5],[5],[5,5]]
```

**예시 2:**
```
Input: scenes = [5]
Output: [[],[5]]
```

**예시 3:**
```
Input: scenes = [2,2,2,1,2]
Output: [[],[1],[1,2],[1,2,2],[1,2,2,2],[1,2,2,2,2],[2],[2,2],[2,2,2],[2,2,2,2]]
Explanation: The value 2 appears four times and 1 appears once; each distinct multiset of selected codes appears exactly once in the output.
```$$,
    $$- `1 <= scenes.length <= 10`
- `-10 <= scenes[i] <= 10`$$
);

-- zone-letter-trail
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'zone-letter-trail'),
    'ko',
    $$구역 문자 경로$$,
    $$한 테마파크 안내 팀이 파크 지도의 각 구역을 한 글자로 인코딩하여 `m x n` 크기의 문자 코드 격자 `park`를 만들었습니다. 방문객은 상하좌우로 인접한 구역 사이를 이동하며 숨겨진 코드워드를 찾되, 한 번의 탐색에서 같은 구역을 다시 방문하지 않습니다.

문자 격자 `park`와 목표 문자열 `codeword`가 주어질 때, 상하좌우로 인접한 구역들을 따라 이동하면서 `codeword`를 정확히 만들 수 있고 한 번의 탐색에서 각 구역을 최대 한 번만 사용하는 경로가 존재하면 `true`를, 그렇지 않으면 `false`를 반환하도록 `traceZonePath`를 구현합니다.

**예시 1:**
```
Input: park = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], codeword = "PEAK"
Output: true
```

**예시 2:**
```
Input: park = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], codeword = "NOID"
Output: true
```

**예시 3:**
```
Input: park = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], codeword = "PARK"
Output: false
```$$,
    $$- `m == park.length`
- `n == park[i].length`
- `1 <= m, n <= 8`
- `1 <= codeword.length <= 20`
- `park`와 `codeword`는 영어 대소문자로만 구성됩니다.$$
);

-- locate-call-number
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'locate-call-number'),
    'ko',
    $$청구기호 찾기$$,
    $$한 참고봉사 사서가 모든 장서를 긴 책꽂이 하나에 청구기호 오름차순으로 정리해 둡니다. 서로 다른 청구기호가 오름차순으로 정렬된 배열 `shelf`와 조회할 청구기호 `query`가 주어질 때, `query`와 같은 청구기호를 가진 책의 책꽂이 위치(0부터 시작)를 반환하고, 아직 목록화되지 않은 책이라면 `-1`을 반환합니다.

참고 데스크가 서가 전체를 훑지 않고도 이용자 문의에 답할 수 있도록, 조회는 `O(log n)` 시간 안에 끝나야 합니다.

**예시 1:**
```
Input: shelf = [102,145,201,247,318,402,510,633], query = 318
Output: 4
Explanation: The call number 318 sits at position 4 on the shelf.
```

**예시 2:**
```
Input: shelf = [102,145,201,247,318,402,510,633], query = 200
Output: -1
Explanation: No book with call number 200 has been cataloged.
```$$,
    $$- `1 <= shelf.length <= 2 * 10^5`
- `|shelf[i]| <= 10^8`
- `|query| <= 10^8`
- `shelf`의 모든 청구기호는 서로 다릅니다.
- `shelf`는 엄격한 오름차순으로 정렬되어 있습니다.$$
);

-- pinpoint-peak-reading
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'pinpoint-peak-reading'),
    'ko',
    $$피크 측정값 찾기$$,
    $$한 기상 관측소가 단일 센서에서 오후 동안 수집한 기온 측정값 `readings`를 모아 둡니다. **피크 측정값**이란 양 옆의 이웃보다 엄격하게 큰 값을 말합니다. 경계에 있는 값은 한쪽 이웃만 이기면 되므로, 배열 바깥쪽 위치는 기온이 `-infinity`인 것으로 간주합니다.

`readings`에 있는 피크 측정값의 인덱스 중 아무거나 하나를 반환합니다. 피크가 여러 개라면 그중 어느 인덱스든 정답입니다. 운영자가 긴 로그를 빠르게 훑을 수 있도록 루틴은 `O(log n)` 시간에 동작해야 합니다.

**예시 1:**
```
Input: readings = [11,18,22,19,15]
Output: 2
Explanation: readings[2] = 22 is strictly greater than both neighbors (18 and 19).
```

**예시 2:**
```
Input: readings = [3,7,12,25,20,14,9]
Output: 3
Explanation: readings[3] = 25 towers over readings[2] = 12 and readings[4] = 20.
```$$,
    $$- `1 <= readings.length <= 2 * 10^3`
- `|readings[i]| <= 10^8`
- 모든 유효한 `i`에 대해 `readings[i] != readings[i + 1]`.$$
);

-- slowest-conveyor-speed
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'slowest-conveyor-speed'),
    'ko',
    $$최저 컨베이어 속도$$,
    $$한 재활용 처리장에서 작업 관리자에게는 처리 대기 중인 수거함이 `n`개 있으며, `piles[i]`는 수거함 `i`에 담긴 물질의 무게(kg)를 나타냅니다. 트럭은 `hours`시간 뒤에 도착해 전량을 실어 갑니다.

단일 컨베이어는 일정한 정수 속도 `k`(kg/시)로 선별기에 원료를 공급합니다. 매 시간마다 컨베이어는 정확히 하나의 수거함에서만 원료를 가져오는데, 해당 수거함에 `k` kg 이상이 남아 있으면 `k` kg을 꺼내고, 그렇지 않으면 수거함을 모두 비운 뒤 그 시간의 나머지는 낭비됩니다.

트럭이 도착하기 전에 선별기가 모든 수거함을 비울 수 있는 가장 느린 정수 속도 `k`를 반환합니다.

**예시 1:**
```
Input: piles = [5,8,12,20], hours = 9
Output: 6
Explanation: At speed 6 the hours per bin are ceil(5/6)=1, ceil(8/6)=2, ceil(12/6)=2, ceil(20/6)=4, totaling 9.
```

**예시 2:**
```
Input: piles = [40,25,18,33,12], hours = 5
Output: 40
Explanation: With 5 bins and only 5 hours, every bin must clear in a single hour.
```

**예시 3:**
```
Input: piles = [40,25,18,33,12], hours = 7
Output: 25
```$$,
    $$- `1 <= piles.length <= 2 * 10^5`
- `piles.length <= hours <= 10^8`
- `1 <= piles[i] <= 10^8`$$
);

-- detect-flow-value
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'detect-flow-value'),
    'ko',
    $$통행량 값 탐지$$,
    $$한 교통 운영 팀이 특정 구간의 분당 차량 통행량을 `m x n` 격자 `flows`에 저장합니다. 이 격자는 전역적으로 정렬되어 있어, 모든 행은 왼쪽에서 오른쪽으로 비감소이며 각 행의 첫 번째 값은 이전 행의 마지막 값보다 큽니다. 즉, 격자를 행 우선 순서로 읽으면 하나의 오름차순 수열이 됩니다.

목표 통행량 `target`이 주어질 때, `flows`의 어떤 칸이 정확히 그 값을 기록했다면 `true`를, 그렇지 않으면 `false`를 반환합니다. 대시보드의 응답성을 유지하기 위해 탐색은 `O(log(m * n))` 시간 안에 끝나야 합니다.

**예시 1:**
```
Input: flows = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 22
Output: true
Explanation: Row 1, column 2 holds the value 22.
```

**예시 2:**
```
Input: flows = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 9
Output: false
Explanation: No cell records a flow of 9.
```$$,
    $$- `m == flows.length`
- `n == flows[i].length`
- `1 <= m, n <= 120`
- `|flows[i][j]| <= 10^8`
- `|target| <= 10^8`$$
);

-- probe-sugar-reading
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'probe-sugar-reading'),
    'ko',
    $$당도 측정값 탐색$$,
    $$한 포도원이 발효 저장고를 Brix 당도 측정값의 `m x n` 격자 `brix`로 배치해 둡니다. 각 행은 왼쪽에서 오른쪽으로 오름차순, 각 열은 위에서 아래로 오름차순이 되도록 신중하게 구성되어 있습니다. 완전히 펼쳐 정렬된 표와 달리, 한 행의 첫 번째 값이 반드시 바로 위 행의 마지막 값보다 크지는 않습니다.

탐색 값 `target`이 주어질 때, 어떤 배럴이 정확히 `target`을 기록했다면 `true`를, 그렇지 않으면 `false`를 반환합니다.

**예시 1:**
```
Input: brix = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 14
Output: true
```

**예시 2:**
```
Input: brix = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 24
Output: false
```

**예시 3:**
```
Input: brix = [[-4,-1],[3,5]], target = -1
Output: true
Explanation: -1 sits in the first row, second column.
```$$,
    $$- `m == brix.length`
- `n == brix[i].length`
- `1 <= m, n <= 250`
- `|brix[i][j]| <= 10^8`
- `|target| <= 10^8`$$
);

-- locate-terminus-station
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'locate-terminus-station'),
    'ko',
    $$종착역 찾기$$,
    $$지하철 운영 데스크는 노선의 역들을 고유한 요금 구역 번호 배열로 관리하며, 원래는 차량 기지에서 종착역까지 오름차순으로 정렬되어 있습니다. 매일 밤 배차 담당자는 아침 첫 운행을 시작할 역이 맨 앞에 오도록 이 목록을 `1`번에서 `n`번 사이로 회전시킵니다. 한 번의 회전은 모든 항목을 오른쪽으로 한 칸씩 이동시키고 마지막 항목을 맨 앞으로 순환시킵니다.

고유한 값을 가진 회전된 `stations` 배열이 주어질 때, 노선의 종착역을 식별하는 가장 작은 요금 구역 번호를 반환하세요. 이 루틴은 `O(log n)` 시간에 실행되어야 합니다.

**예시 1:**
```
Input: stations = [7,9,12,2,5]
Output: 2
Explanation: The sorted list was [2,5,7,9,12] rotated 3 times, so 2 is the terminus.
```

**예시 2:**
```
Input: stations = [15,20,24,31,3,8,12]
Output: 3
```

**예시 3:**
```
Input: stations = [21,33,45,58]
Output: 21
Explanation: No rotation was applied tonight, so the first entry is the terminus.
```$$,
    $$- `n == stations.length`
- `1 <= n <= 6000`
- `|stations[i]| <= 10^8`
- `stations`의 모든 값은 서로 다릅니다.
- `stations`는 오름차순 목록을 `1`번에서 `n`번 사이 회전시킨 결과입니다.$$
);

-- spot-catalog-target
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'spot-catalog-target'),
    'ko',
    $$관측 카탈로그 탐색$$,
    $$한 천문대는 관측 대상 카탈로그를 고유한 적경 코드의 오름차순 목록으로 관리합니다. 매일 밤 시작 전, 야간 조수는 지평선 위로 처음 떠오르는 천체가 맨 앞에 오도록 알 수 없는 기준점에서 목록을 회전시킵니다. 예를 들어 `[10,14,18,22,25,28,33]` 카탈로그가 `[25,28,33,10,14,18,22]`로 시작될 수 있습니다.

회전된 `catalog` 배열과 `target` 코드가 주어질 때, `catalog`에서 `target`이 위치한 인덱스를 반환하고, 오늘 밤 목록에 해당 천체가 없다면 `-1`을 반환하세요. 이 루틴은 `O(log n)` 시간에 실행되어야 합니다.

**예시 1:**
```
Input: catalog = [12,18,24,31,3,7,9], target = 3
Output: 4
Explanation: The catalog holds 3 at index 4 after rotation.
```

**예시 2:**
```
Input: catalog = [12,18,24,31,3,7,9], target = 15
Output: -1
Explanation: No entry matches 15.
```

**예시 3:**
```
Input: catalog = [8], target = 3
Output: -1
```$$,
    $$- `1 <= catalog.length <= 6000`
- `|catalog[i]| <= 10^8`
- `catalog`의 모든 값은 서로 다릅니다.
- `catalog`는 알 수 없는 기준점에서 회전된 오름차순 목록입니다.
- `|target| <= 10^8`$$
);

-- smallest-flow-rate
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'smallest-flow-rate'),
    'ko',
    $$최소 방류 유량$$,
    $$한 과수원의 관개 매니폴드에는 `n`개의 저수조가 있으며, `days`일 이내에 모두 들판으로 방류해야 합니다. `volumes[i]`는 저수조 `i`에 저장된 물의 양(리터)이며, 파이프라인 압력 제약으로 인해 저수조는 주어진 왼쪽에서 오른쪽 순서대로 방류해야 합니다.

매일 매니폴드는 일정한 정수 유량 용량으로 작동합니다. 하루 동안 방류 작업을 연속적으로 묶다가 다음 저수조를 추가하면 용량을 초과하게 되는 시점에서 그날을 종료하고, 남은 저수조는 다음 날 이어서 처리합니다.

모든 저수조를 `days`일 이내에 방류할 수 있는 가장 작은 유량 용량(일일 리터)을 반환하세요.

**예시 1:**
```
Input: volumes = [2,4,5,7,9,11,13,16,18,20], days = 5
Output: 27
Explanation: Capacity 27 drains in 5 days: [2,4,5,7,9], [11,13], [16], [18], [20].
```

**예시 2:**
```
Input: volumes = [4,3,3,5,2,5], days = 3
Output: 8
Explanation: Capacity 8 drains in 3 days: [4,3], [3,5], [2,5].
```

**예시 3:**
```
Input: volumes = [2,3,4,2,2], days = 4
Output: 4
Explanation: Capacity 4 drains in 4 days: [2], [3], [4], [2,2].
```$$,
    $$- `1 <= days <= volumes.length <= 8 * 10^4`
- `1 <= volumes[i] <= 600`$$
);

-- merged-zone-median
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'merged-zone-median'),
    'ko',
    $$병합 구역 중앙값$$,
    $$두 지역 우편 분류기가 각각 비감소 순서의 정수 구역 코드 스트림을 출력합니다. 정렬된 두 스트림 `zonesA`와 `zonesB`가 주어질 때, 두 스트림을 병합한 결합 스트림의 **중앙값**을 반환하세요. 즉, 병합 후 가운데 값을 반환하거나 결합된 길이가 짝수인 경우 가운데 두 값의 평균을 반환합니다.

배차 대시보드가 실시간으로 갱신될 수 있도록 병합은 `O(log(m + n))` 시간에 실행되어야 합니다. 여기서 `m = zonesA.length`, `n = zonesB.length`입니다.

**예시 1:**
```
Input: zonesA = [2,5], zonesB = [4]
Output: 4.0
Explanation: The merged stream is [2,4,5]; the middle value is 4.
```

**예시 2:**
```
Input: zonesA = [3,8], zonesB = [5,11]
Output: 6.5
Explanation: The merged stream is [3,5,8,11]; the median is (5 + 8) / 2 = 6.5.
```

**예시 3:**
```
Input: zonesA = [], zonesB = [12]
Output: 12.0
Explanation: Only one value total, so the median is that value.
```$$,
    $$- `0 <= zonesA.length, zonesB.length <= 1500`
- `1 <= zonesA.length + zonesB.length <= 3000`
- `|zonesA[i]|, |zonesB[i]| <= 10^7`
- 두 스트림은 모두 비감소 순서로 정렬되어 있습니다.$$
);

-- locate-vacant-callslot
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'locate-vacant-callslot'),
    'ko',
    $$비어 있는 청구기호 찾기$$,
    $$도서관 목록은 새로 수서되는 자료가 분류될 때마다 `0, 1, 2, ..., n`의 청구기호를 부여합니다. 서가 정리가 끝난 뒤, 목록 담당자는 전체 `n + 1`개 범위에서 뽑힌 `n`개의 서로 다른 청구기호 목록 `callSlots`를 건네줍니다. 즉, `[0, n]` 범위 중 정확히 하나의 번호만 기록되지 않았습니다.

누락된 단 하나의 번호를 반환하는 `findVacantSlot(callSlots)`를 구현하세요. 반환 값은 반드시 존재하며 유일함이 보장됩니다.

**예시 1:**
```
Input: callSlots = [4,2,0,1]
Output: 3
Explanation: The list has length 4, so the full range is [0,1,2,3,4]. Only slot 3 is absent.
```

**예시 2:**
```
Input: callSlots = [5,3,1,0,2]
Output: 4
Explanation: The full range is [0..5]; slot 4 is the one not recorded.
```$$,
    $$- `1 <= callSlots.length <= 2 * 10^5`
- `0 <= callSlots[i] <= callSlots.length`
- `callSlots`의 모든 값은 서로 다릅니다.$$
);

-- compare-pallet-flags
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'compare-pallet-flags'),
    'ko',
    $$팔레트 플래그 비교$$,
    $$창고의 각 팔레트는 어떤 취급 플래그(취급 주의, 위험물, 저온 유통 등)가 활성화되어 있는지를 비트로 인코딩한 작은 상태 워드를 지니고 있습니다. 두 팔레트가 같은 도크로 합쳐질 때 감독관은 두 팔레트 사이에서 서로 다른 플래그가 몇 개인지 알고 싶어합니다.

두 음이 아닌 정수 `leftFlags`와 `rightFlags`가 주어질 때, 두 상태 워드가 서로 다른 비트 위치의 개수를 반환하는 `countFlagMismatches(leftFlags, rightFlags)`를 구현하세요.

**예시 1:**
```
Input: leftFlags = 10, rightFlags = 5
Output: 4
Explanation: 10 is 1010 and 5 is 0101 in binary. All four low bits disagree.
```

**예시 2:**
```
Input: leftFlags = 14, rightFlags = 9
Output: 3
Explanation: 14 is 1110 and 9 is 1001; positions 0, 1, and 2 disagree.
```$$,
    $$- `0 <= leftFlags, rightFlags <= 2.1 * 10^9`$$
);

-- tally-priority-flags
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'tally-priority-flags'),
    'ko',
    $$우선순위 플래그 집계$$,
    $$긴급 배차 시스템은 들어오는 각 신고에 `0`부터 `upperId`까지의 정수 ID를 부여합니다. 감사 리포트를 위해 해당 범위의 모든 가능한 ID에 대해 그 이진 표현에서 몇 개의 우선순위 비트가 세워져 있는지(각 세워진 비트는 하나의 고유한 에스컬레이션 플래그를 의미) 보여주는 히스토그램이 필요합니다.

음이 아닌 정수 `upperId`가 주어질 때, 길이 `upperId + 1`의 배열 `flagCounts`를 반환하는 `tallyPriorityFlags(upperId)`를 구현하세요. 여기서 `flagCounts[i]`는 `i`의 이진 표현에서 세워진 비트의 개수입니다.

**예시 1:**
```
Input: upperId = 4
Output: [0,1,1,2,1]
Explanation: 0=0b0, 1=0b1, 2=0b10, 3=0b11, 4=0b100.
```

**예시 2:**
```
Input: upperId = 7
Output: [0,1,1,2,1,2,2,3]
Explanation: Binary forms through 7 are 0, 1, 10, 11, 100, 101, 110, 111.
```$$,
    $$- `0 <= upperId <= 8 * 10^4`$$
);

-- combine-counter-readings
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'combine-counter-readings'),
    'ko',
    $$카운터 측정값 합산$$,
    $$베어 메탈 제조 컨트롤러는 두 개의 정수 사이클 카운터에 대해 비트 연산(AND, OR, XOR, NOT, 왼쪽 시프트, 오른쪽 시프트)만 제공합니다. 그래도 펌웨어는 두 카운터를 누적 합계로 결합할 수 있어야 하므로, `+` 또는 `-` 연산자 없이 덧셈을 구현해야 합니다.

두 정수 `firstCount`와 `secondCount`가 주어질 때, 비트 연산만으로 산술 합을 반환하는 `combineCounters(firstCount, secondCount)`를 구현하세요. 힌트: XOR은 자리 올림을 무시한 비트 단위 합을 만들고, AND 후 왼쪽 시프트는 자리 올림 자체를 만듭니다. 자리 올림이 0이 될 때까지 반복하세요.

**예시 1:**
```
Input: firstCount = 12, secondCount = 9
Output: 21
```

**예시 2:**
```
Input: firstCount = -15, secondCount = 4
Output: -11
```$$,
    $$- `-1500 <= firstCount, secondCount <= 1500`$$
);

-- active-sensor-mask
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'active-sensor-mask'),
    'ko',
    $$활성 센서 마스크$$,
    $$스마트 홈 허브는 최대 31개 센서의 온/오프 상태를 단일 양의 정수 `sensorMask`로 묶어 저장하며, 세워진 각 비트는 현재 보고 중인 센서 하나를 의미합니다. 대시보드 위젯은 지금 몇 개의 센서가 활성 상태인지라는 핵심 수치만 필요합니다.

`sensorMask`의 이진 표현에서 `1`인 비트 개수를 반환하는 `countActiveSensors(sensorMask)`를 구현하세요.

**예시 1:**
```
Input: sensorMask = 29
Output: 4
Explanation: 29 is 11101 in binary, which has four set bits.
```

**예시 2:**
```
Input: sensorMask = 256
Output: 1
Explanation: 256 is 100000000 in binary; only a single sensor is active.
```$$,
    $$- `1 <= sensorMask <= 2.1 * 10^9`$$
);

-- reverse-printer-flags
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'reverse-printer-flags'),
    'ko',
    $$프린터 플래그 비트 반전$$,
    $$레거시 인쇄소 드라이버는 32비트 작업 상태 워드를 비트 0부터 차례로 전송합니다. 따라서 최상위 비트 우선으로 배치하는 최신 펌웨어는 상태 워드 전체를 뒤집어야 자체 레지스터와 비교할 수 있습니다. 당신은 그 변환 단계를 작성하고 있습니다.

32비트 부호 없는 정수 `statusWord`가 주어질 때, 32비트 전체의 순서를 반전시킨 값을 반환하는 `reversePrinterFlags(statusWord)`를 구현하세요. 비트 0은 위치 31로, 비트 1은 위치 30으로, 이런 식으로 이동합니다. 결과는 `[0, 2^32 - 1]` 범위의 `long` 값으로 반환하세요.

**예시 1:**
```
Input: statusWord = 8
Output: 268435456
Explanation: 8 has bit 3 set. After reversing across 32 positions, that bit lands at position 28, giving 2^28 = 268435456.
```

**예시 2:**
```
Input: statusWord = 6
Output: 1610612736
Explanation: 6 has bits 1 and 2 set. Reversed, they become bits 30 and 29, giving 2^30 + 2^29 = 1610612736.
```$$,
    $$- `statusWord`는 32비트 부호 없는 정수입니다 (`0 <= statusWord <= 4294967295`).$$
);

-- single-species-tank
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'single-species-tank'),
    'ko',
    $$단일 종 수조 판정$$,
    $$번식용 아쿠아리움에서는 수조마다 개체 수 카운터를 관리합니다. 큐레이터가 알집을 나눌 때 두 배씩 증식시키는 방침을 쓰기 때문에, 개체 수가 `1`, `2`, `4`, `8`, `16`, ... 처럼 2의 거듭제곱일 때에만 해당 수조를 "단일 종 수조"로 인정합니다. 0 이하이거나 2의 거듭제곱이 아닌 수는 인정되지 않습니다.

정수 `specimenCount`가 주어질 때, 어떤 음이 아닌 정수 `k`에 대해 `specimenCount == 2^k`이면 `true`를, 그렇지 않으면 `false`를 반환하는 `isSoloSpecies(specimenCount)`를 구현하세요.

**예시 1:**
```
Input: specimenCount = 32
Output: true
Explanation: 32 = 2^5.
```

**예시 2:**
```
Input: specimenCount = 12
Output: false
Explanation: 12 lies between 2^3 = 8 and 2^4 = 16, so it is not a power of two.
```$$,
    $$- `-2.1 * 10^9 <= specimenCount <= 2.1 * 10^9`$$
);

-- best-bake-order
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'best-bake-order'),
    'ko',
    $$최적의 베이킹 순서$$,
    $$한 제과점의 카운터 위에 발효 트레이들이 한 줄로 놓여 있고, 각 트레이에는 반죽의 무게가 테두리에 적혀 있습니다. 여러분은 원하는 순서대로 한 번에 하나씩 트레이를 오븐에 넣을 수 있습니다.

위치 `i`에 있는 트레이를 꺼낼 때 얻는 보너스 빵의 개수는 `trays[i - 1] * trays[i] * trays[i + 1]`이며, 여기서 양옆의 이웃은 그 순간 `i`의 좌우에 **아직 남아 있는** 트레이를 가리킵니다. 트레이를 꺼내면 그 자리는 비고, 양옆의 트레이들이 서로 붙어 이어집니다. 어느 한쪽에 트레이가 없는 경우(줄의 끝을 벗어나거나 이미 모든 트레이가 꺼내진 경우)에는 그쪽 이웃의 무게를 `1`로 간주합니다.

모든 트레이를 꺼낸 뒤 얻을 수 있는 보너스 빵의 최대 합계를 반환하는 `bestBakeOrder`를 구현하세요.

**예시 1:**
```
Input: trays = [2,4,1,6]
Output: 90
Explanation: One optimal order pulls 1, then 4, then 2, then 6: bonuses = 4*1*6 + 2*4*6 + 1*2*6 + 1*6*1 = 24 + 48 + 12 + 6 = 90.
```

**예시 2:**
```
Input: trays = [3,5]
Output: 20
Explanation: Pull the tray with weight 3 first: 1*3*5 = 15. Then pull 5: 1*5*1 = 5. Total = 20.
```$$,
    $$- `1 <= trays.length <= 300`
- `0 <= trays[i] <= 100`$$
);

-- count-coupon-combos
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'count-coupon-combos'),
    'ko',
    $$쿠폰 조합 개수 세기$$,
    $$한 식료품점의 셀프 계산대는 정해진 종류의 스토어 크레딧 쿠폰을 받으며, 각 쿠폰은 정수 원 단위의 가치를 가집니다. 계산원은 주어진 장바구니 소계를 정확히 맞출 수 있는 **서로 다른** 쿠폰 조합의 수가 얼마나 되는지 궁금합니다.

소계 `amount`와 사용 가능한 쿠폰 액면가 목록 `coupons`가 주어집니다. 각 액면가는 몇 번이든 사용할 수 있으며, 두 조합은 최소 한 종류의 액면가 사용 횟수가 다를 때에만 서로 다른 것으로 간주합니다(순서는 상관없음). 조건을 만족하는 조합의 수를 반환하는 `countCouponCombos`를 구현하세요. 정확히 `amount`를 만드는 조합이 하나도 없으면 `0`을 반환합니다.

**예시 1:**
```
Input: amount = 8, coupons = [1,3,4]
Output: 6
Explanation: The six combinations are 1+1+1+1+1+1+1+1, 1+1+1+1+1+3, 1+1+3+3, 1+1+1+1+4, 1+3+4, and 4+4.
```

**예시 2:**
```
Input: amount = 4, coupons = [5]
Output: 0
Explanation: A 5-won coupon alone can never total 4 won.
```$$,
    $$- `1 <= coupons.length <= 300`
- `1 <= coupons[i] <= 5000`
- All values in `coupons` are distinct
- `0 <= amount <= 5000`$$
);

-- min-wait-route
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'min-wait-route'),
    'ko',
    $$최소 대기 시간 경로$$,
    $$교통 관제 센터는 도시 밴을 직사각형 교차로 격자 위에서 운행시킵니다. 각 칸에는 현재 신호 체계에서 해당 교차로를 통과할 때 발생하는 대기 시간(분)이 기록되어 있습니다. 밴은 좌측 상단 교차로에서 진입해 우측 하단 교차로까지 도달해야 하며, 각 교차로에서는 **동쪽(오른쪽)으로 한 블록** 또는 **남쪽(아래)으로 한 블록**으로만 이동할 수 있습니다.

좌측 상단에서 우측 하단까지 이어지는 유효한 경로 하나를 따라 쌓이는 대기 시간의 최솟값을 반환하는 `minWaitRoute`를 구현하세요. 이때 경로가 거치는 모든 교차로(양 끝점 포함)의 값을 모두 합산합니다.

**예시 1:**
```
Input: grid = [[2,1,4],[5,3,2],[1,2,1]]
Output: 9
Explanation: The route 2 -> 1 -> 3 -> 2 -> 1 sums to 9 minutes, the best achievable.
```

**예시 2:**
```
Input: grid = [[3,1],[2,4],[1,5]]
Output: 11
Explanation: The route 3 -> 2 -> 1 -> 5 sums to 11 minutes; the alternative 3 -> 1 -> 4 -> 5 totals 13.
```$$,
    $$- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 200`
- `0 <= grid[i][j] <= 200`$$
);

-- min-zone-code-edits
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'min-zone-code-edits'),
    'ko',
    $$우편 구역 코드 최소 편집$$,
    $$우편 분류 허브는 배송 구역마다 짧은 소문자 구역 코드를 관리하며, 라우팅 팀은 한 구역이 이웃 구역에 병합되는 등의 상황에서 코드를 한 글자씩 고쳐 다른 코드와 같아지도록 만들어야 할 때가 있습니다. 코드에 대해 허용되는 단일 글자 편집은 다음 세 가지뿐입니다.
- 임의 위치에 한 글자를 **삽입**
- 임의 위치의 한 글자를 **삭제**
- 한 글자를 다른 글자로 **치환**

이전 구역 코드 `source`와 새 구역 코드 `target`이 주어질 때, `source`를 `target`으로 바꾸는 데 필요한 최소 편집 횟수를 반환하는 `minZoneEdits`를 구현하세요.

**예시 1:**
```
Input: source = "coral", target = "carol"
Output: 2
Explanation: Replace the 'o' at index 1 with 'a', then replace the 'a' at index 3 with 'o'.
```

**예시 2:**
```
Input: source = "sunset", target = "sunrise"
Output: 3
Explanation: Delete the final 't' (sunset -> sunse), insert 'r' after the 'n' (sunse -> sunrse), then insert 'i' after that 'r' (sunrse -> sunrise). Three edits.
```$$,
    $$- `0 <= source.length, target.length <= 500`
- `source` and `target` consist of lowercase English letters.$$
);

-- biggest-clear-bay
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'biggest-clear-bay'),
    'ko',
    $$최대 빈 적재 구역$$,
    $$창고 바닥은 `m x n` 격자로 표현되며, 각 칸은 `"1"`(비어 있어 지게차가 파레트를 적재할 수 있음) 또는 `"0"`(기둥, 충전소, 기존 랙 등으로 막힘) 중 하나입니다. 운영 관리자는 인접한 빈 칸들로 만들 수 있는 **정사각형** 적재 구역 중 가장 큰 것의 면적이 얼마인지 알고자 합니다.

`floor`에서 축에 정렬된 `"1"`로만 이루어진 가장 큰 정사각형 부분 격자의 면적(한 변 길이의 제곱)을 반환하는 `biggestClearBay`를 구현하세요. 빈 칸이 하나도 없으면 `0`을 반환합니다.

**예시 1:**
```
Input: floor = [["1","1","0","1"],["1","1","1","1"],["0","1","1","1"],["1","1","1","1"]]
Output: 9
Explanation: The bottom-right 3x3 block is entirely clear, so the biggest square has side length 3 and area 9.
```

**예시 2:**
```
Input: floor = [["0","0","0"],["0","1","1"],["0","1","1"]]
Output: 4
Explanation: The 2x2 block in the bottom-right corner is all clear, giving area 4.
```$$,
    $$- `m == floor.length`
- `n == floor[i].length`
- `1 <= m, n <= 300`
- `floor[i][j]` is `'0'` or `'1'`$$
);

-- longest-vine-ascent
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'longest-vine-ascent'),
    'ko',
    $$가장 긴 포도나무 오름차순 경로$$,
    $$산비탈의 한 포도원이 `m x n` 격자 형태로 조성되어 있고, 각 칸에는 그 격자 위치의 포도나무에서 측정한 당도가 기록되어 있습니다. 포도 재배자는 숙성 패턴을 분석하기 위해 한 걸음 내디딜 때마다 당도가 증가하는 수확 경로를 찾고자 합니다.

유효한 상승 경로는 임의의 칸에서 시작하며, 각 단계에서 현재 칸의 **상하좌우** 인접 칸 중 당도가 **엄밀히 더 큰** 칸으로만 이동할 수 있습니다. `sugar`에서 찾을 수 있는 엄밀히 증가하는 경로의 최대 포도나무 개수를 반환하는 `longestVineAscent`를 구현하세요.

**예시 1:**
```
Input: sugar = [[2,5,8],[3,4,7],[1,6,9]]
Output: 5
Explanation: Starting at the vine with reading 1 in the bottom-left, the ascent 1 -> 3 -> 4 -> 7 -> 9 visits 5 vines, each strictly sweeter than the last.
```

**예시 2:**
```
Input: sugar = [[4,2,1],[5,6,3]]
Output: 5
Explanation: The ascent 1 -> 2 -> 4 -> 5 -> 6 threads through five adjacent vines with strictly increasing sugar levels.
```$$,
    $$- `m == sugar.length`
- `n == sugar[i].length`
- `1 <= m, n <= 200`
- `0 <= sugar[i][j] <= 10^8`$$
);

-- shelf-overlap-length
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'shelf-overlap-length'),
    'ko',
    $$서가 공통 부분수열 길이$$,
    $$한 도서관의 아카이브 시스템은 각 서가를 한 글자짜리 주제 코드들의 문자열로 기록하며, 책이 꽂혀 있는 순서대로 적어 둡니다. 목록 담당자가 두 서가를 비교할 때에는, 중간에 다른 코드가 끼어 있어도 상대적인 순서가 유지되는 한, **양쪽 서가에 모두** 등장하는 가장 긴 주제 코드 패턴의 길이를 알고 싶어 합니다.

서가 문자열의 **부분수열**이란 나머지 글자들의 순서를 바꾸지 않고 0개 이상의 글자를 지워서 얻을 수 있는 문자열을 말합니다. 두 서가 문자열 `left`와 `right`가 주어질 때, 둘 사이의 최장 공통 부분수열의 길이를 반환하는 `shelfOverlapLength`를 구현하세요. 공통된 글자가 하나도 없으면 `0`을 반환합니다.

**예시 1:**
```
Input: left = "history", right = "mystery"
Output: 4
Explanation: One longest common subsequence is "stry" (length 4).
```

**예시 2:**
```
Input: left = "ocean", right = "canoe"
Output: 3
Explanation: One longest common subsequence is "can": it appears in order as positions 1-3-4 of left and 0-1-2 of right.
```$$,
    $$- `1 <= left.length, right.length <= 1000`
- `left` and `right` consist of lowercase English letters.$$
);

-- validate-part-stream
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'validate-part-stream'),
    'ko',
    $$부품 코드 스트림 검증$$,
    $$제조 라인에서는 완성된 부품마다 짧은 코드 문자열을 찍어내며, 품질 관리 팀은 허용되는 부품 코드의 패턴 문자열 카탈로그를 관리합니다. 패턴에는 두 가지 와일드카드가 사용됩니다. `.`는 코드의 임의의 한 글자를 나타내고, `*`는 바로 앞에 나온 글자가 **0회 이상** 반복됨을 의미합니다. 코드가 유효하려면 패턴이 코드의 **처음부터 끝까지** 전체를 덮어야 하며, 접두사나 중간 부분만 일치하는 경우는 유효하지 않습니다.

부품 코드 `code`와 패턴 `pattern`이 주어질 때, 패턴이 코드 전체와 일치하면 `true`를, 그렇지 않으면 `false`를 반환하는 `validatePartStream`을 구현하세요.

**예시 1:**
```
Input: code = "bbbc", pattern = "b*c"
Output: true
Explanation: `b*` consumes the three b's at the start, then `c` matches the trailing c, covering the full code.
```

**예시 2:**
```
Input: code = "xyzw", pattern = "x.y"
Output: false
Explanation: The pattern describes only three characters and contains no `*` to stretch, so it cannot cover the four-character code.
```$$,
    $$- `1 <= code.length <= 24`
- `1 <= pattern.length <= 24`
- `code` consists of lowercase English letters
- `pattern` consists of lowercase English letters, `.`, and `*`
- Every `*` in `pattern` has a valid preceding character (no leading `*` and no two `*` in a row)$$
);

-- partition-tank-doses
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'partition-tank-doses'),
    'ko',
    $$수조 투여량 분배$$,
    $$한 아쿠아리움 기술자는 여러 수조에 정해진 양의 완충 용액을 투여해야 하는데, 각 수조에 대해 그 양만큼 **주입**(화학 수치를 해당 수치만큼 올림)하거나 **배출**(해당 수치만큼 내림)할 수 있습니다. 배열 `doses`에서 `doses[i]`가 수조 `i`에 배정된 투여량이고, 정수 `target`이 모든 수조에 걸쳐 원하는 수치 변화의 총합일 때, 각 수조의 주입/배출 방식을 지정하여 총 변화가 정확히 `target`과 같아지는 서로 다른 할당의 개수를 세고자 합니다. 모든 수조에는 반드시 둘 중 하나의 조치를 정확히 한 번 취해야 합니다.

조건을 만족하는 할당의 개수를 반환하는 `partitionTankDoses`를 구현하세요.

**예시 1:**
```
Input: doses = [2,2,2,2], target = 4
Output: 4
Explanation: The net change must be +4, so 3 tanks receive add and 1 tank receives drain. There are 4 choices for which tank is drained.
```

**예시 2:**
```
Input: doses = [4,6,8], target = 10
Output: 1
Explanation: The only assignment with net +10 is drain the 4, add the 6, add the 8, giving -4 + 6 + 8 = 10.
```$$,
    $$- `1 <= doses.length <= 22`
- `0 <= doses[i] <= 900`
- `-900 <= target <= 900`$$
);

-- best-tier-resale
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'best-tier-resale'),
    'ko',
    $$최고 등급 좌석 재판매$$,
    $$한 재판매 브로커가 특정 콘서트 좌석 등급의 일별 시장 가격을 추적합니다. 매일 브로커는 좌석을 보유하고 있지 않다면 한 장을 **매수**하거나, 보유 중이라면 **매도**하거나, 아무것도 하지 않을 수 있습니다. 브로커는 동시에 두 장 이상의 좌석을 보유하지 않으며, 매도 직후 바로 다음 날에는 반드시 쿨다운으로 쉬어야 다시 매수할 수 있습니다. 배열 `tierPrices`가 주어지고 `tierPrices[i]`가 `i`일째의 시장 가격일 때, 전체 기간 동안 브로커가 확보할 수 있는 최대 총이익을 반환합니다.

`bestTierResale`를 구현하여 그 최대 이익을 반환합니다.

**예시 1:**
```
Input: tierPrices = [3,8,5,1,6]
Output: 10
Explanation: Buy on day 0 at 3 and sell on day 1 at 8 (profit 5). Day 2 is the forced cooldown. Buy on day 3 at 1 and sell on day 4 at 6 (profit 5). Total 10.
```

**예시 2:**
```
Input: tierPrices = [9,2,5]
Output: 3
Explanation: The opening 9 is too high to sell into, so wait, buy on day 1 at 2, and sell on day 2 at 5 for a profit of 3.
```$$,
    $$- `1 <= tierPrices.length <= 2000`
- `0 <= tierPrices[i] <= 900`$$
);

-- check-merged-queue
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'check-merged-queue'),
    'ko',
    $$병합된 큐 검증$$,
    $$바쁜 인쇄소가 두 대의 독립된 프린터를 운영하며, 각 프린터는 자신만의 순서가 있는 작업 큐를 가집니다. 하루가 끝날 무렵, 관리자는 두 기계에 걸쳐 작업이 송출되는 동안 하위 청구 시스템이 관측한 **병합된** 큐를 정리합니다. 이 병합 큐는 두 프린터 큐의 올바른 인터리브일 때에만 유효합니다. 즉, 모든 작업이 등장하고, 각 원본 큐 내부의 상대 순서가 보존되어야 합니다(다만 두 큐의 작업은 임의의 인터리브 패턴으로 섞일 수 있습니다).

세 문자열 `queueA`, `queueB`, `merged`(각 문자는 하나의 작업 id를 나타냅니다)가 주어졌을 때, `checkMergedQueue`를 구현하여 `merged`가 `queueA`와 `queueB`의 유효한 인터리브이면 `true`를, 그렇지 않으면 `false`를 반환합니다.

**예시 1:**
```
Input: queueA = "cat", queueB = "dog", merged = "cdoagt"
Output: true
Explanation: Pull c from A, then d and o from B, then a from A, then g from B, then t from A. Both per-queue orders are preserved.
```

**예시 2:**
```
Input: queueA = "abc", queueB = "xyz", merged = "axbzyc"
Output: false
Explanation: After taking a then x, the next job from B would have to be y, but the merged stream shows z before y, which violates B's order.
```$$,
    $$- `0 <= queueA.length, queueB.length <= 120`
- `0 <= merged.length <= 240`
- `queueA`, `queueB`, `merged`는 영어 소문자로만 구성됩니다$$
);

-- count-filter-matches
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'count-filter-matches'),
    'ko',
    $$필터 매칭 횟수 세기$$,
    $$매일 밤 한 천문대는 주 망원경에 실제로 교체된 광학 필터 순서를 기록하여, 각 문자가 하나의 필터 문자를 나타내는 로그 문자열 `log`를 생성합니다. 연구자들은 종종 이 로그로부터 짧은 목표 필터 패턴 `target`이 **부분 수열**로 몇 가지 서로 다른 방식으로 추출될 수 있는지 알고 싶어 합니다. 즉, `log`에서 순서를 유지한 채 임의의 개수의 문자를 건너뛰어 선택하는 방식입니다. 추출된 문자들이 겉보기에 같더라도, 건너뛴 위치가 다르면 서로 다른 추출로 간주합니다.

로그 `log`와 패턴 `target`이 주어졌을 때, `countFilterMatches`를 구현하여 서로 다른 부분 수열 매칭의 총 개수를 반환합니다. 답은 64비트 부호 있는 정수 범위에 들어갑니다.

**예시 1:**
```
Input: log = "ggrrg", target = "grg"
Output: 4
Explanation: Each match chooses a g, then a later r, then a later g. Among the g positions (0, 1, 4) and r positions (2, 3), the valid (i, j, k) triples are (0,2,4), (0,3,4), (1,2,4), (1,3,4).
```

**예시 2:**
```
Input: log = "uvuvu", target = "uu"
Output: 3
Explanation: The u positions are 0, 2, and 4, and choosing any ordered pair gives a match: (0,2), (0,4), (2,4).
```$$,
    $$- `1 <= log.length <= 900`
- `1 <= target.length <= 900`
- `log`와 `target`은 영어 소문자로만 구성됩니다$$
);

-- count-gate-routes
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'count-gate-routes'),
    'ko',
    $$게이트 경로 세기$$,
    $$한 테마파크가 `rows`행 `cols`열의 직사각형 도보 격자 위에 명소들을 배치합니다. 방문객은 좌상단 칸 `[0, 0]`에 있는 게이트로 입장하여 우하단 칸 `[rows - 1, cols - 1]`에 있는 대표 명소까지 도달하고자 합니다. 공원의 안내 표지판은 보행자 동선을 일방통행으로 제한하여, 어떤 칸에서도 방문객은 한 칸 **아래** 또는 한 칸 **오른쪽**으로만 이동할 수 있습니다.

`countGateRoutes`를 구현하여 게이트에서 대표 명소까지 가는 서로 다른 보행 경로의 수를 반환합니다.

**예시 1:**
```
Input: rows = 4, cols = 5
Output: 35
Explanation: Each route takes exactly 3 down-steps and 4 right-steps in some order, so the count is the number of ways to arrange those 7 moves.
```

**예시 2:**
```
Input: rows = 2, cols = 6
Output: 6
Explanation: With a single down-step required, the route is fully determined by which of the 6 columns that down-step happens in.
```$$,
    $$- `1 <= rows, cols <= 80`$$
);

-- split-reading-for-product
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'split-reading-for-product'),
    'ko',
    $$측정 구간 분할로 곱 최대화$$,
    $$한 기상 관측소가 연속된 시간 수 `span`(양의 정수)을 기록했으며, 이를 두 개 이상의 연속된 표본 블록(각 블록은 최소 1시간 이상)으로 분할해야 합니다. 분석가는 블록 길이들을 모두 곱하여 분할의 점수를 매기고, 그 곱을 최대화하는 분할을 선택하고자 합니다.

`splitProductMax(span)`을 구현하여, 길이 합이 `span`이 되는 두 개 이상의 양의 정수 블록 길이로 `span`을 분할하는 모든 유효한 분할 중에서 얻을 수 있는 **최대 곱**을 반환합니다.

**예시 1:**
```
Input: span = 5
Output: 6
Explanation: The best partition is 5 = 2 + 3, giving a product of 2 * 3 = 6. All other valid partitions (1+4, 1+1+3, 1+2+2, 1+1+1+2, 1+1+1+1+1) yield smaller products.
```

**예시 2:**
```
Input: span = 11
Output: 54
Explanation: The best partition is 11 = 3 + 3 + 3 + 2, giving 3 * 3 * 3 * 2 = 54. Splits like 3+4+4 yield 48 and 3+3+5 yield 45.
```$$,
    $$- `2 <= span <= 60`$$
);

-- pick-least-effort-circuit
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'pick-least-effort-circuit'),
    'ko',
    $$최소 운동 부하 회로 선택$$,
    $$한 피트니스 스튜디오가 `0`번부터 `n-1`번까지 번호가 매겨진 운동 기구들의 회로를 제공하며, 각 기구는 회원이 올라설 때 운동 부하 `effort[i]`만큼을 요구합니다. 회원은 `0`번 기구 또는 `1`번 기구 앞에서 시작할 수 있으며, 현재 기구의 부하를 지불한 뒤 앞으로 한 칸 또는 두 칸 전진할 수 있습니다. 목표는 마지막 기구 바로 다음 위치(`n`번 위치)로 빠져나와 회로를 끝내는 것입니다.

`pickLeastEffort(effort)`를 구현하여 회원이 회로를 완료하기 위해 지불해야 하는 최소 총 부하를 반환합니다.

**예시 1:**
```
Input: effort = [4,2,8,3,5,6]
Output: 10
Explanation: Start at machine 1 (pay 2), jump to machine 3 (pay 3), jump to machine 5 (pay 6 is too costly — instead jump from machine 3 to machine 5 via machine 4)… the minimum path pays 2 + 3 + 5 = 10.
```

**예시 2:**
```
Input: effort = [7,1,7,1,7]
Output: 2
Explanation: Start at machine 1 (pay 1), advance two positions to machine 3 (pay 1), then advance two more positions to finish. Total toll is 2 (paying one at each of machines 1 and 3).
```$$,
    $$- `2 <= effort.length <= 2 * 10^3`
- `0 <= effort[i] <= 800`$$
);

-- fewest-bag-sizes
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'fewest-bag-sizes'),
    'ko',
    $$최소 개수의 우편 가방$$,
    $$한 지역 우편 분류소가 재사용 가능한 우편 가방 크기의 소규모 카탈로그를 보유하며, 각 가방은 정확히 정수 개수의 우편물만을 담습니다. 배송 담당자는 하류 트럭을 위해 정확히 `quota`개의 우편물을 준비하라는 주문을 받으며, 카탈로그에서 어떤 크기의 가방이든 원하는 만큼(각 크기는 재고 무제한) 사용할 수 있습니다. 분류소는 총 가방 수를 가능한 한 적게 사용하고자 합니다.

`fewestBagSizes(bagSizes, quota)`를 구현하여 용량의 합이 정확히 `quota`가 되는 최소 가방 수를 반환하고, 카탈로그 크기들의 어떤 조합으로도 정확히 `quota`에 도달할 수 없다면 `-1`을 반환합니다.

**예시 1:**
```
Input: bagSizes = [2,4,7], quota = 15
Output: 3
Explanation: Using bags of size 4, 4, and 7 totals 15 pieces with three bags. No pair of bags from the catalog sums to 15, so three is the minimum.
```

**예시 2:**
```
Input: bagSizes = [3,5], quota = 4
Output: -1
Explanation: No combination of bags with capacities 3 and 5 sums to exactly 4 pieces.
```$$,
    $$- `1 <= bagSizes.length <= 12`
- `1 <= bagSizes[i] <= 10^8`
- `0 <= quota <= 8000`$$
);

-- count-scan-decodings
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'count-scan-decodings'),
    'ko',
    $$스캔 디코딩 경우의 수$$,
    $$한 창고의 팔레트 스캐너가 긴 숫자 시퀀스 `scan`을 출력합니다. 카탈로그의 모든 SKU는 `1`부터 `26`까지의 정수로 사전 인코딩되어 있어(SKU 1은 `"1"`, SKU 10은 `"10"`, SKU 26은 `"26"`), `0`으로 시작하는 pick은 유효하지 않습니다. 카탈로그에는 `05`나 `0` 같은 id를 가진 SKU가 없기 때문입니다. 담당자는 이 원시 숫자 시퀀스가 유효한 SKU id들의 나열로 몇 가지 서로 다른 방식으로 재분할될 수 있는지 결정해야 합니다.

`countScanDecodings(scan)`을 구현하여 `scan`을 왼쪽에서 오른쪽으로 `1..26` 범위의 SKU id 시퀀스로 파싱하는 방법의 수를 반환합니다. 답은 32비트 부호 있는 정수 범위에 들어가는 것이 보장됩니다.

**예시 1:**
```
Input: scan = "1234"
Output: 3
Explanation: The valid parses are (1,2,3,4), (12,3,4), and (1,23,4). "1234" as a single id is invalid because 1234 exceeds 26, and "12,34" is invalid because 34 exceeds 26.
```

**예시 2:**
```
Input: scan = "100"
Output: 0
Explanation: The second digit is 0, so it cannot start a new id. The only remaining option would pair the first two digits as 10, but then the trailing 0 is stranded with no id that starts with 0.
```$$,
    $$- `1 <= scan.length <= 120`
- `scan`은 십진 숫자로만 구성되며 선행 혹은 중간 `0`을 포함할 수 있습니다.$$
);

-- split-shift-loads
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'split-shift-loads'),
    'ko',
    $$교대 근무 업무량 균등 분할$$,
    $$한 긴급 배차 데스크에 대기 중인 호출들이 모여 있으며, 각 호출에는 응답 분 단위의 정수 업무량 점수 `loads[i]`가 부여되어 있습니다. 관리자는 모든 호출이 정확히 한 교대조에서 처리되고 **주간** 교대와 **야간** 교대가 동일한 총 업무량을 맡도록 이 배치를 나누고자 합니다.

`canSplitLoads(loads)`를 구현하여 대기 호출들을 총 업무량이 같은 두 개의 서로소 그룹으로 분할할 수 있으면 `true`를, 그렇지 않으면 `false`를 반환합니다.

**예시 1:**
```
Input: loads = [3,1,1,2,2,1]
Output: true
Explanation: The sum is 10, so each shift must carry 5 response-minutes. One valid split is {3, 2} for the day shift and {1, 1, 2, 1} for the night shift — both sum to 5.
```

**예시 2:**
```
Input: loads = [2,2,3,5]
Output: false
Explanation: The sum is 12, so each shift would need to carry 6 response-minutes, but no subset of {2, 2, 3, 5} sums to exactly 6.
```$$,
    $$- `1 <= loads.length <= 200`
- `1 <= loads[i] <= 100`$$
);

-- pick-plot-haul
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'pick-plot-haul'),
    'ko',
    $$포도밭 구획 수확량 극대화$$,
    $$한 포도밭 블록은 `n`개의 구획이 일렬로 늘어선 단일 열로 구성되며, 시즌 종료 센서 로그는 각 구획에 대한 정수 당도 수확량 `yield[i]`를 보고합니다. 수확 작업반에는 기계적인 제약이 있어, 같은 패스에서 인접한 두 구획을 수확하면 공유된 격자 철선이 과부하를 일으키므로, 수확되는 구획들 사이에는 수확되지 않은 구획이 최소 하나 이상 있어야 합니다.

`pickPlotHaul(yields)`를 구현하여, 인접한 두 구획을 동시에 수확하지 않는다는 조건에서 작업반이 단일 패스로 모을 수 있는 최대 총 수확량을 반환합니다.

**예시 1:**
```
Input: yields = [4,1,1,9,1,3]
Output: 16
Explanation: Harvesting plots 0, 3, and 5 yields 4 + 9 + 3 = 16. No other no-adjacent selection scores higher.
```

**예시 2:**
```
Input: yields = [5,5,10,100,10,5]
Output: 110
Explanation: Harvesting plots 1, 3, and 5 yields 5 + 100 + 5 = 110. Taking plot 3 alone scores 100, and any selection that skips plot 3 cannot catch up.
```$$,
    $$- `1 <= yields.length <= 100`
- `0 <= yields[i] <= 400`$$
);

-- pick-circuit-targets
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'pick-circuit-targets'),
    'ko',
    $$원형 관측 타깃 선택$$,
    $$옥상 천문대가 순환 관측을 계획하고 있습니다. 돔 주변에 `n`개의 타깃이 닫힌 고리 형태로 배치되어 있으며, 각 타깃에서 기대되는 광자 수율이 정수 배열 `yields`로 주어집니다. 돔은 기계식으로 회전하기 때문에 **고리상 인접한** 두 타깃을 연속해서 관측하면 냉각 규칙을 위반하게 되며, 고리가 순환 구조이므로 첫 번째와 마지막 타깃도 인접한 것으로 간주됩니다.

선택한 두 타깃이 고리상 인접하지 않도록 부분집합을 골랐을 때 얻을 수 있는 최대 총 수율을 반환하는 `pickCircuitTargets(yields)`를 구현하세요.

**예시 1:**
```
Input: yields = [4,1,5,6,2]
Output: 10
Explanation: Pick index 0 (yield 4) and index 2 or 3. Best is picking yields[0]=4 and yields[3]=6 for total 10. You cannot also pick yields[4]=2 since it is ring-adjacent to yields[0].
```

**예시 2:**
```
Input: yields = [3,8,2,7,1,9]
Output: 24
Explanation: Picking yields[1]=8, yields[3]=7, yields[5]=9 would total 24 in a line, but yields[5] is ring-adjacent to yields[0]. Skipping yields[0] lets us legally pick 8+7+9=24.
```$$,
    $$- `1 <= yields.length <= 2 * 10^3`
- `0 <= yields[i] <= 5000`$$
);

-- longest-bright-run
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'longest-bright-run'),
    'ko',
    $$가장 긴 당도 상승 구간$$,
    $$포도 재배자가 한 열의 포도나무를 차례로 걸으며 각 나무에서 굴절계로 측정한 당도(Brix 단위)를 기록합니다. 측정값은 행 순서대로 정수 배열 `brix`로 주어집니다. 이 열이 깔끔한 상승 추세로 익어가고 있음을 보이기 위해, 분석가는 측정값들로 이루어진 가장 긴 **순증가 부분수열**의 길이를 알고 싶어 합니다(중간의 나무는 건너뛸 수 있지만 행을 따라가는 순서는 유지됩니다).

`brix`에서 가장 긴 순증가 부분수열의 길이를 반환하는 `longestBrightRun(brix)`를 구현하세요. 부분수열은 원래 순서를 유지한 채 인덱스들의 부분집합을 선택한 것이며, 연속해서 선택한 값들은 `brix[i] < brix[j]`를 만족해야 합니다.

**예시 1:**
```
Input: brix = [4,10,2,6,3,5,8,11]
Output: 5
Explanation: The subsequence [2,3,5,8,11] (from indices 2,4,5,6,7) is strictly increasing and has length 5.
```

**예시 2:**
```
Input: brix = [9,2,7,4,6,8]
Output: 4
Explanation: The subsequence [2,4,6,8] has length 4; no strictly increasing subsequence of length 5 exists.
```$$,
    $$- `1 <= brix.length <= 2 * 10^3`
- `-5000 <= brix[i] <= 5000`$$
);

-- count-longest-bake-trail
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'count-longest-bake-trail'),
    'ko',
    $$가장 긴 베이킹 트레일 개수 세기$$,
    $$아침 근무 동안 한 빵집이 회전식 오븐에서 트레이를 순서대로 꺼내며 각 트레이의 갈변 점수를 기록했고, 이 점수들이 정수 배열 `scores`로 주어집니다. 수석 제빵사는 점수의 순증가 부분수열(트레이는 건너뛸 수 있지만 순서는 유지)을 **베이킹 트레일**이라고 부르며, 가장 긴 길이를 갖는 서로 다른 트레일이 몇 개인지 알고 싶어 합니다.

`scores`의 순증가 부분수열 중 최대 길이 `L`을 먼저 구한 뒤, 길이 `L`에 도달하는 서로 다른 부분수열의 개수(인덱스 집합 기준)를 반환하는 `countLongestTrail(scores)`를 구현하세요.

**예시 1:**
```
Input: scores = [2,6,4,5,8]
Output: 1
Explanation: The longest strictly increasing subsequence has length 4: [2,4,5,8]. No other length-4 trail exists.
```

**예시 2:**
```
Input: scores = [3,3,3]
Output: 3
Explanation: No two entries are strictly ordered, so the longest trail has length 1. Each of the three entries alone is a distinct length-1 trail.
```$$,
    $$- `1 <= scores.length <= 2 * 10^3`
- `-8 * 10^5 <= scores[i] <= 8 * 10^5`$$
);

-- build-mirror-length
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'build-mirror-length'),
    'ko',
    $$가장 긴 미러 런 길이$$,
    $$도서관 목록 감사관이 붙여 쓴 청구기호들을 점검하고 있습니다. 소문자로 이루어진 청구기호 문자열 `code`가 하나 주어졌을 때, 앞뒤로 읽어도 동일한 가장 긴 **연속** 조각("미러 런")의 길이를 찾으려 합니다. 미러 런은 버그가 있는 임포터가 만든 배가 오류의 흔적일 가능성이 높기 때문입니다.

`code`에서 가장 긴 팰린드롬 연속 부분문자열의 길이를 반환하는 `buildMirrorLength(code)`를 구현하세요. 모든 한 글자 자체가 길이 1의 미러이므로, `code`가 비어 있지 않다면 답은 항상 1 이상입니다.

**예시 1:**
```
Input: code = "levelled"
Output: 5
Explanation: The contiguous slice "level" is a palindrome of length 5. No longer palindromic slice exists in code.
```

**예시 2:**
```
Input: code = "barrel"
Output: 2
Explanation: The contiguous slice "rr" is a palindrome of length 2, and no longer palindromic slice exists in code.
```$$,
    $$- `1 <= code.length <= 1200`
- `code` consists of only lowercase English letters.$$
);

-- best-flow-streak
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'best-flow-streak'),
    'ko',
    $$최고 유량 연속 구간$$,
    $$한 농장의 주 관로가 단일 채널을 따라 시간당 순유량 신호를 기록합니다. 양수는 유입이 우세함을, 음수는 역류(빨아들이는 힘)를, 0은 밸브가 잠시 완전히 닫혔음을 의미합니다. 이 측정값들은 정수 배열 `flow`로 주어지며, 관개 엔지니어는 하루 중 곱셈적으로 가장 지배적인 연속 구간, 즉 `flow`의 연속 부분배열 중 **곱**이 최대인 값을 알고 싶어 합니다.

`flow`의 비어 있지 않은 연속 부분배열에서 얻을 수 있는 최대 곱을 반환하는 `bestFlowStreak(flow)`를 구현하세요. 어떤 부분배열의 곱이든 부호 있는 32비트 정수 범위에 들어가는 것이 보장됩니다.

**예시 1:**
```
Input: flow = [3,-1,4,-2,5]
Output: 120
Explanation: The whole subarray [3,-1,4,-2,5] multiplies to 120, which is the largest contiguous product.
```

**예시 2:**
```
Input: flow = [-3,0,2,-4]
Output: 2
Explanation: Any subarray that crosses the zero has product 0. The best non-crossing choice is [2], giving product 2.
```$$,
    $$- `1 <= flow.length <= 2 * 10^3`
- `-10 <= flow[i] <= 10`
- The product of any contiguous subarray of `flow` fits in a signed 32-bit integer.$$
);

-- nth-smooth-batch
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'nth-smooth-batch'),
    'ko',
    $$N번째 매끄러운 배치 크기$$,
    $$한 인쇄소의 배치 플래너는 페이지 수가 `2`, `3`, `5`로만 깔끔하게 소인수분해되는 스택 크기만 사용합니다. 이 세 값은 마감기가 지원하는 접지 비율이기 때문입니다. **매끄러운 배치 크기**란 소인수가 오직 `2`, `3`, `5`뿐인 양의 정수이며, 관례상 `1`은 첫 번째 매끄러운 배치 크기입니다(소인수가 없기 때문). 수열은 `1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, 24, ...`로 시작합니다 (`7`은 허용되지 않는 소인수이므로 제외됨에 유의하세요).

오름차순으로 `n`번째 매끄러운 배치 크기를 반환하는 `nthSmoothBatch(n)`를 구현하세요 (`1`-인덱스 기준).

**예시 1:**
```
Input: n = 7
Output: 8
Explanation: The first seven smooth batch sizes are 1, 2, 3, 4, 5, 6, 8, so the 7th is 8.
```

**예시 2:**
```
Input: n = 12
Output: 16
Explanation: The first twelve smooth batch sizes are 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, so the 12th is 16.
```$$,
    $$- `1 <= n <= 1500`$$
);

-- count-mirror-spans
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'count-mirror-spans'),
    'ko',
    $$미러 스팬 개수 세기$$,
    $$한 기상 관측소가 근무 시간당 하나씩, 단일 문자 상태 기호로 이루어진 간결한 문자열 `code`를 기록합니다. 분석가들은 **미러 스팬**에 관심이 있습니다. 이는 앞뒤로 읽어도 동일한 로그의 연속 조각으로, 대칭적인 기압 이벤트의 경계를 이루는 경향이 있기 때문입니다.

`code`에 포함된 미러 스팬의 총 개수를 반환하는 `countMirrorSpans(code)`를 구현하세요. 한 글자짜리 조각은 모두 미러 스팬이며, 동일한 텍스트라도 서로 다른 위치에서 나타나면 각각 별도로 계산해야 합니다.

**예시 1:**
```
Input: code = "klmn"
Output: 4
Explanation: No two adjacent markers agree, so only the 4 single-character slices qualify.
```

**예시 2:**
```
Input: code = "rrrr"
Output: 10
Explanation: Every contiguous slice of a run of identical markers is a mirror span. With length 4 there are 4 + 3 + 2 + 1 = 10 such slices.
```$$,
    $$- `1 <= code.length <= 1500`
- `code` consists of lowercase English letters.$$
);

-- count-exact-page-quotas
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'count-exact-page-quotas'),
    'ko',
    $$정확한 페이지 할당량 채우기$$,
    $$한 인쇄소는 모든 **완전제곱수** 크기(1, 4, 9, 16, 25, ...)의 종이 묶음을 갖추고 있습니다. 정확한 페이지 할당량을 맞추기 위해 오퍼레이터는 묶음들을 조합할 수 있으며, 동일한 크기를 필요한 만큼 반복해서 사용할 수 있습니다.

합이 정확히 `pages`가 되도록 하는 데 필요한 묶음의 최소 개수를 반환하는 `countExactTargets(pages)`를 구현하세요.

**예시 1:**
```
Input: pages = 7
Output: 4
Explanation: Using one size-4 pack plus three size-1 packs sums to 7. No combination of 1, 2, or 3 perfect-square packs sums to 7.
```

**예시 2:**
```
Input: pages = 17
Output: 2
Explanation: 17 = 16 + 1.
```

**예시 3:**
```
Input: pages = 5
Output: 2
Explanation: 5 = 4 + 1.
```$$,
    $$- `1 <= pages <= 12000`$$
);

-- count-assembly-orders
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'count-assembly-orders'),
    'ko',
    $$조립 순서 개수 세기$$,
    $$한 창고에서 `0`번부터 `n - 1`번까지 번호가 매겨진 `n`개의 하위 조립품으로 완제품을 조립합니다. 자재 명세는 루트가 있는 트리로 주어집니다. 0번 하위 조립품은 선행 조건이 없는 최상위 단위이며, 그 외의 모든 하위 조립품 `i`는 정확히 하나의 부모 `parent[i]`를 가지며, 부모가 완전히 조립된 후에야 `i`의 작업을 시작할 수 있습니다. 관례상 `parent[0] = -1`입니다.

작업장은 한 번에 하나의 하위 조립품만 조립할 수 있습니다. 두 조립 순서는 하위 조립품 인덱스의 정렬된 수열이 어느 한 자리라도 다르면 서로 다른 것으로 간주합니다.

`n`개의 하위 조립품 전체에 대해 유효한 조립 순서의 총 개수를 `10^8 + 7`로 나눈 나머지로 반환하는 `countAssemblyOrders(parent)`를 구현하세요.

**예시 1:**
```
Input: parent = [-1,0,0,2,2]
Output: 8
Explanation: Sub-assembly 0 must be built first. Below it, sub-assembly 1 is a leaf and the pair (3, 4) hangs off sub-assembly 2. Interleaving the two branches yields 8 distinct orders.
```

**예시 2:**
```
Input: parent = [-1,0,1,2,3]
Output: 1
Explanation: The bill of materials is the chain 0 -> 1 -> 2 -> 3 -> 4, so only one build order is valid.
```

**예시 3:**
```
Input: parent = [-1,0,0,0,0]
Output: 24
Explanation: After sub-assembly 0 is built, the remaining four children can be finished in any order, giving 4! = 24 sequences.
```$$,
    $$- `1 <= n <= 2 * 10^5`
- `parent.length == n`
- `parent[0] == -1`
- `0 <= parent[i] < n` for `i >= 1`
- The input is guaranteed to describe a valid rooted tree.$$
);

-- count-reservoir-paths
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'count-reservoir-paths'),
    'ko',
    $$저수 패드 경로 개수 세기$$,
    $$관개용 격자는 `0`번부터 `n`번까지 번호가 매겨진 저수 패드로 물을 보냅니다. `0`번 패드의 펌프는 한 번에 두 가지 수로 점프 중 하나만 쓸 수 있습니다. 흐름을 패드 하나만큼 전진시키는 짧은 점프, 또는 패드 두 개만큼 전진시키는 긴 점프입니다.

`0`번 패드에서 `n`번 저수 패드까지 흐름을 이동시키는 서로 다른 점프 수열의 수를 반환하는 `countReservoirPaths(n)`를 구현하세요.

**예시 1:**
```
Input: n = 4
Output: 5
Explanation: The valid sequences are 1+1+1+1, 1+1+2, 1+2+1, 2+1+1, and 2+2.
```

**예시 2:**
```
Input: n = 5
Output: 8
Explanation: There are 8 distinct short/long hop sequences that sum to 5.
```$$,
    $$- `1 <= n <= 40`$$
);

-- split-headline-tokens
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'split-headline-tokens'),
    'ko',
    $$헤드라인 토큰 분할$$,
    $$한 뉴스 집계 서비스는 공백이 모두 제거된 소문자 문자열 `headline`과, 알려진 토픽 토큰 목록 `topics`를 함께 받는 경우가 있습니다. 편집자는 이 헤드라인을 목록에 있는 토픽 토큰들을 공백으로 구분한 하나 이상의 시퀀스로 되돌릴 수 있는지 확인하려 합니다. 각 토큰은 필요한 만큼 반복해서 사용할 수 있습니다.

이러한 분할이 가능하면 `true`, 그렇지 않으면 `false`를 반환하는 `splitHeadlineTokens(headline, topics)`를 구현하세요.

**예시 1:**
```
Input: headline = "morningwire", topics = ["morning","wire"]
Output: true
Explanation: "morningwire" splits into "morning wire".
```

**예시 2:**
```
Input: headline = "topstoryalert", topics = ["top","story","alert"]
Output: true
Explanation: "topstoryalert" splits into "top story alert".
```

**예시 3:**
```
Input: headline = "breakingnews", topics = ["break","breaking","new","ing"]
Output: false
Explanation: Every prefix that matches a token leaves a suffix that cannot be fully covered — "news" never appears as a prefix of a topic token, and neither does a trailing "s".
```$$,
    $$- `1 <= headline.length <= 400`
- `1 <= topics.length <= 1500`
- `1 <= topics[i].length <= 25`
- `headline`과 각 `topics[i]`는 소문자 영문자로만 구성됩니다.
- `topics`의 모든 문자열은 서로 다릅니다.$$
);

-- unify-crew-contacts
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'unify-crew-contacts'),
    'ko',
    $$촬영 크루 연락처 통합$$,
    $$한 라인 프로듀서가 촬영 규모가 커지는 동안 크루 연락처 목록을 계속 갱신합니다. 각 항목은 크루 구성원의 이름으로 시작하고, 뒤이어 콜시트에 사용된 그 사람의 모든 이메일 주소가 나열됩니다. 두 항목이 이메일 하나라도 공유한다면 같은 사람의 항목으로 간주합니다. 다만 이름이 같다고 해서 반드시 같은 사람인 것은 아닙니다.

이메일을 하나라도 공유하는 항목들을 (이행적으로) 병합해 통합된 목록을 반환하는 `unifyContactIdentities(accounts)`를 구현하세요. 반환되는 각 항목은 이름으로 시작하고, 그 뒤에 해당 크루 구성원의 중복 없는 이메일이 **사전순으로 정렬**되어 이어집니다. 목록 항목 자체의 순서는 임의로 반환해도 됩니다.

**예시 1:**
```
Input: accounts = [["Maya","maya.dp@set.film","mayalens@set.film"],["Maya","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]
Output: [["Maya","maya.dp@set.film","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]
Explanation: The first two Maya entries share `mayalens@set.film`, so they collapse into one person with three emails. The third Maya shares no email with anyone and stays separate. Leo has no overlap either.
```

**예시 2:**
```
Input: accounts = [["Ash","ash1@set.film","ash2@set.film"],["Bea","bea1@set.film","bea2@set.film"],["Cal","cal1@set.film","cal2@set.film"]]
Output: [["Ash","ash1@set.film","ash2@set.film"],["Bea","bea1@set.film","bea2@set.film"],["Cal","cal1@set.film","cal2@set.film"]]
Explanation: No emails are shared between entries, so each entry is kept as-is with its emails sorted.
```$$,
    $$- `1 <= accounts.length <= 1500`
- `2 <= accounts[i].length <= 10`
- `1 <= accounts[i][j].length <= 30`
- `accounts[i][0]`은 영문자로 구성됩니다.
- `j > 0`인 `accounts[i][j]`는 유효한 이메일 주소입니다.$$
);

-- seize-enclosed-zones
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'seize-enclosed-zones'),
    'ko',
    $$포위된 구역 접수$$,
    $$지휘 본부는 `'X'`로 표시된 칸을 대응팀이 정리한 구역으로, `'O'`로 표시된 칸을 아직 활성 상태인 구역으로 관리합니다. 활성 구역이 진정으로 도달 불가능한 상태 — 즉 정리 완료로 표시해도 안전한 상태 — 가 되려면, 4방향으로 인접한 `'O'` 구역들의 사슬이 지도의 외곽에 전혀 닿지 않아야 합니다. 첫 행, 마지막 행, 첫 열, 마지막 열에 닿는 활성 영역은 외부에서 증원이 들어올 수 있으므로 활성 상태로 남겨야 합니다.

`grid`를 **제자리에서** 변경해, `'X'` 구역으로 완전히 둘러싸인 모든 `'O'`를 `'X'`로 바꾸고, 상하좌우로 외곽과 연결된 `'O'`는 그대로 두는 `seizeEnclosedZones(grid)`를 구현한 뒤 변경된 `grid`를 반환하세요.

**예시 1:**
```
Input: grid = [["X","X","X","X"],["X","O","X","X"],["X","X","O","X"],["X","X","X","O"]]
Output: [["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","X","X","O"]]
Explanation: The `'O'` at (1,1) and the `'O'` at (2,2) are both fully surrounded, so they are marked cleared. The `'O'` at (3,3) lies on the perimeter and is left alone.
```

**예시 2:**
```
Input: grid = [["O","X"],["O","X"]]
Output: [["O","X"],["O","X"]]
Explanation: Both `'O'` cells sit on the first column, so they are already perimeter-connected and nothing changes.
```$$,
    $$- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 180`
- `grid[i][j]`는 `'X'` 또는 `'O'`입니다.$$
);

-- tally-device-meshes
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'tally-device-meshes'),
    'ko',
    $$기기 메시 개수 집계$$,
    $$한 스마트홈 허브는 `0`부터 `n - 1`까지 라벨이 붙은 `n`개의 페어링된 기기와, 현재 이들 간의 통신을 가능하게 해주는 무선 릴레이를 관리합니다. 각 항목 `relays[i] = [a, b]`는 기기 `a`와 기기 `b`가 서로 직접 통신할 수 있다는 뜻입니다. 두 기기는 릴레이의 사슬을 통해 직접 또는 중간 기기를 거쳐 서로에게 신호가 닿으면 같은 메시에 속합니다.

집 전체에 존재하는 독립된 기기 메시의 개수를 반환하는 `tallyDeviceMeshes(n, relays)`를 구현하세요. 릴레이가 전혀 없는 고립된 기기도 크기 1의 메시로 한 개 카운트합니다.

**예시 1:**
```
Input: n = 6, relays = [[0,1],[2,3],[3,4]]
Output: 3
Explanation: Devices `{0,1}` talk through one relay, `{2,3,4}` are chained together, and device `5` sits alone — three meshes in total.
```

**예시 2:**
```
Input: n = 7, relays = [[0,1],[1,2],[2,3],[3,4],[4,5],[5,6]]
Output: 1
Explanation: Every device is reachable from every other device through the relay chain, so the entire home forms a single mesh.
```$$,
    $$- `1 <= n <= 2000`
- `0 <= relays.length <= 5000`
- `relays[i].length == 2`
- `0 <= a, b < n`
- `a != b`
- `relays`에서 같은 쌍이 두 번 이상 나타나지 않습니다.$$
);

-- sequence-assembly-steps
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'sequence-assembly-steps'),
    'ko',
    $$조립 공정 순서 결정$$,
    $$한 공장의 생산 계획 담당자는 한 번의 실행에서 `0`부터 `numSteps - 1`까지 라벨이 붙은 `numSteps`개의 조립 공정을 다룹니다. 일부 공정은 특정 선행 공정이 완료되어야만 시작할 수 있습니다. 각 항목 `prereqs[i] = [a, b]`는 공정 `a`를 시작하려면 공정 `b`가 먼저 완료되어야 한다는 뜻입니다.

선행 관계를 모두 만족하면서 모든 공정을 실행할 수 있는 순서를 반환하는 `sequenceAssemblySteps(numSteps, prereqs)`를 구현하세요. 유효한 순서가 여러 개라면 그중 아무거나 반환해도 됩니다. 선행 관계가 순환을 이루어 유효한 일정이 불가능한 경우에는 빈 배열을 반환합니다.

**예시 1:**
```
Input: numSteps = 3, prereqs = [[2,0],[1,0]]
Output: [0,1,2]
Explanation: Step `0` has no prerequisites, so it runs first. Steps `1` and `2` can then run in either order; `[0,1,2]` is one valid sequence.
```

**예시 2:**
```
Input: numSteps = 5, prereqs = [[1,0],[2,1],[3,1],[4,2],[4,3]]
Output: [0,1,2,3,4]
Explanation: Step `0` must precede `1`, which must precede both `2` and `3`, and both must precede `4`. The sequence `[0,1,2,3,4]` respects every edge.
```$$,
    $$- `1 <= numSteps <= 2000`
- `0 <= prereqs.length <= numSteps * (numSteps - 1)`
- `prereqs[i].length == 2`
- `0 <= a, b < numSteps`
- `a != b`
- `prereqs`의 모든 쌍 `[a, b]`는 서로 다릅니다.$$
);

-- verify-shoot-plan
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'verify-shoot-plan'),
    'ko',
    $$촬영 계획 검증$$,
    $$조감독이 여러 날에 걸친 촬영 계획을 점검하고 있습니다. `0`부터 `numScenes - 1`까지 라벨이 붙은 `numScenes`개의 신이 있으며, 일부 신에는 연속성 상의 선행 조건이 있습니다. 각 항목 `prereqs[i] = [a, b]`는 신 `a`를 찍기 전에 신 `b`가 먼저 촬영 완료되어야 한다는 뜻입니다.

모든 선행 조건을 만족하는 촬영 순서가 존재하면 `true`, 선행 조건이 순환 의존을 이루어 어떤 순서로도 만족할 수 없으면 `false`를 반환하는 `verifyShootPlan(numScenes, prereqs)`를 구현하세요.

**예시 1:**
```
Input: numScenes = 4, prereqs = [[1,0],[2,0],[3,1]]
Output: true
Explanation: Scene `0` can be shot first, then `1` and `2` (which both only need `0`), and finally `3`. No circular dependency exists.
```

**예시 2:**
```
Input: numScenes = 3, prereqs = [[0,2],[2,1],[1,0]]
Output: false
Explanation: Scene `0` needs `2`, `2` needs `1`, and `1` needs `0`. The three-way loop means no scene can ever be shot first.
```$$,
    $$- `1 <= numScenes <= 2000`
- `0 <= prereqs.length <= 5000`
- `prereqs[i].length == 2`
- `0 <= a, b < numScenes`
- 모든 `prereqs[i]` 쌍은 서로 다릅니다.$$
);

-- resolve-price-ratios
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'resolve-price-ratios'),
    'ko',
    $$가격 비율 계산$$,
    $$한 유통 분석가는 식료품 체인의 판촉 전단 묶음을 가지고 있습니다. 각 전단은 두 품목의 단위 가격 비율을 비교합니다. `ratios[i] = [Ai, Bi]`와 `values[i]`는 품목 `Ai` 한 단위의 가격이 품목 `Bi` 한 단위 가격의 `values[i]`배라는 뜻입니다. 분석가는 이 비교들을 바탕으로 새로운 비율 질의 목록에 답하려고 합니다.

`queries[i] = [Ci, Di]` 각각에 대해 알려진 비율들로부터 유도되는 `Ci / Di` 값을 반환하는 `resolvePriceRatios(ratios, values, queries)`를 구현하세요. 두 품목이 비율의 사슬로 연결되어 있지 않다면 — 둘 중 하나가 전단에 등장한 적이 없는 경우를 포함해 — 해당 질의에는 `-1.0`을 반환합니다. `A / B = k`가 알려져 있으면 `B / A = 1 / k` 역시 동일하게 알려진 값이며, 적어도 한 번 등장한 품목에 대해서는 `A / A = 1.0`입니다.

**예시 1:**
```
Input: ratios = [["milk","bread"],["bread","eggs"]], values = [4.0,2.0], queries = [["milk","eggs"],["eggs","bread"],["bread","milk"],["milk","milk"],["soap","milk"]]
Output: [8.00000,0.50000,0.25000,1.00000,-1.00000]
Explanation: `milk/eggs = (milk/bread) * (bread/eggs) = 4.0 * 2.0 = 8.0`; `eggs/bread = 1/2.0 = 0.5`; `bread/milk = 1/4.0 = 0.25`; `milk/milk = 1.0`; `soap` never appears so its query is `-1.0`.
```

**예시 2:**
```
Input: ratios = [["apple","pear"],["pear","plum"],["kiwi","lime"]], values = [3.0,4.0,2.0], queries = [["apple","plum"],["plum","apple"],["kiwi","lime"],["apple","kiwi"]]
Output: [12.00000,0.08333,2.00000,-1.00000]
Explanation: Apple and plum are linked through pear, giving `3.0 * 4.0 = 12.0` and the reciprocal. Kiwi and lime form a separate component, so `kiwi/lime` is known but `apple/kiwi` is not.
```$$,
    $$- `1 <= ratios.length <= 25`
- `ratios[i].length == 2`
- `1 <= ratios[i][0].length, ratios[i][1].length <= 8`
- `values.length == ratios.length`
- `0.0 < values[i] <= 25.0`
- `1 <= queries.length <= 25`
- `queries[i].length == 2`
- `1 <= queries[i][0].length, queries[i][1].length <= 8`
- 품목 코드는 소문자 영문자와 숫자로만 구성됩니다.$$
);

-- fanout-responder-reach
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'fanout-responder-reach'),
    'ko',
    $$대응팀 도달 범위 산출$$,
    $$한 출동 상황실은 배치된 대응팀이 도시의 모든 블록까지 얼마나 빨리 도달할 수 있는지를 추적합니다. 도시는 `m x n` 격자로 표현되며, 각 칸은 다음 세 값 중 하나입니다.

- `-1` — **폐쇄 블록** (진행 중인 위험으로 통과 불가)
- `0` — **대응팀 거점** (이미 대응팀이 배치되어 있음)
- `2147483647` — 아직 커버되지 않은 **열린 블록**

열린 블록의 값들을 가장 가까운 대응팀 거점까지의 4방향 이동 걸음 수로 치환하세요. 이동은 열린 블록을 따라 상하좌우로만 할 수 있습니다. 어떤 거점에도 도달할 수 없는 열린 블록은 `2147483647`로 남겨둡니다. `grid`를 **제자리에서** 갱신하고 반환하세요.

**예시 1:**
```
Input: grid = [[2147483647,0,-1,2147483647],[2147483647,2147483647,2147483647,2147483647],[-1,2147483647,0,2147483647],[2147483647,2147483647,2147483647,-1]]
Output: [[1,0,-1,3],[2,1,1,2],[-1,2,0,1],[3,2,1,-1]]
Explanation: Responder posts sit at (0,1) and (2,2). Each open block is stamped with its step count to the closer post; the cell at (0,3) is three steps from (0,1) because (0,2) is closed.
```

**예시 2:**
```
Input: grid = [[0,2147483647,2147483647],[-1,2147483647,-1],[2147483647,2147483647,0]]
Output: [[0,1,2],[-1,2,-1],[2,1,0]]
Explanation: Two closed blocks in the middle row force a detour, but every open block still reaches one of the posts.
```$$,
    $$- `1 <= m, n <= 250`
- `grid[i][j]`는 `-1`, `0`, 또는 `2147483647`입니다.$$
);

-- snapshot-mesh-layout
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'snapshot-mesh-layout'),
    'ko',
    $$메시 레이아웃 스냅샷$$,
    $$교통망에서 what-if 시뮬레이션을 돌리기 전에 운영팀은 실 토폴로지에 실험적인 변경이 영향을 미치지 않도록 독립된 복사본을 만들어두어야 합니다. 연결된 무방향 지하철역 그래프에 속한 한 `station` 노드에 대한 참조가 주어지며, 각 역에는 정수 `val`과 환승 인접 역 목록 `neighbors`가 있습니다.

주어진 역에서 도달 가능한 연결 네트워크 전체에 대한 **깊은 복사본**을 반환하세요. 반환된 스냅샷의 모든 노드는 원본과 동일한 `val`과 동일한 인접 구조를 가지되 새로 할당되어야 하며, 어떤 노드도 원본의 노드와 같은 객체여서는 안 됩니다.

드라이버에는 그래프가 인접 리스트로 전달되며, 인덱스 `i` (0-기준) 는 `val = i + 1`인 역의 이웃을 나타냅니다. 그래프가 비어 있지 않다면 진입 노드의 `val`은 항상 `1`입니다.

**예시 1:**
```
Input: adjList = [[2,3],[1,4],[1,5],[2,5],[3,4]]
Output: [[2,3],[1,4],[1,5],[2,5],[3,4]]
Explanation: Station 1 transfers to 2 and 3. Station 2 transfers to 1 and 4. The snapshot mirrors every edge but uses fresh node objects.
```

**예시 2:**
```
Input: adjList = [[2],[1,3],[2]]
Output: [[2],[1,3],[2]]
Explanation: A three-station linear line is cloned edge-for-edge.
```$$,
    $$- 네트워크의 역 개수는 `[0, 100]` 범위입니다.
- `1 <= station.val <= 100`
- `station.val`은 노드마다 고유합니다.
- 그래프에는 자기 루프와 중복 간선이 없습니다.$$
);

-- tally-planted-regions
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'tally-planted-regions'),
    'ko',
    $$식재 구역 수 집계$$,
    $$수확을 앞두고 포도밭 관리자가 직사각형 구획 지도를 조사합니다. 각 칸은 한 평방 구획을 나타내며, `"1"`은 포도나무가 심어진 칸, `"0"`은 휴경 중인 칸을 뜻합니다. **식재 구역**은 4방향(상하좌우)으로 연결된 식재 칸들의 최대 그룹을 의미하며, 대각선 연결은 포함하지 않습니다.

`m x n` `field` 격자가 주어질 때, 서로 다른 식재 구역의 개수를 반환하세요. 격자의 사방은 모두 휴경 땅으로 둘러싸여 있다고 가정합니다.

**예시 1:**
```
Input: field = [["0","1","1","0","0","1"],["1","1","0","0","0","1"],["0","0","0","1","0","0"],["1","0","0","1","1","0"],["1","0","0","0","0","1"]]
Output: 5
Explanation: The planted squares cluster into five 4-connected regions — the top-left L, the right-column pair, the central patch around (2,3), the left-side pair at (3,0)/(4,0), and the lone vine at (4,5).
```

**예시 2:**
```
Input: field = [["1","1","0","0"],["0","1","0","1"],["0","0","0","1"]]
Output: 2
Explanation: One region sits in the upper-left corner, and a separate column of two vines occupies the right edge.
```$$,
    $$- `m == field.length`
- `n == field[i].length`
- `1 <= m, n <= 250`
- `field[i][j]`는 `'0'` 또는 `'1'`입니다.$$
);

-- trace-dual-drainage
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'trace-dual-drainage'),
    'ko',
    $$이중 배수로 추적$$,
    $$계단식 농장이 `m x n` 크기의 직사각형 경사면에 놓여 있습니다. `field[r][c]`는 행 `r`, 열 `c` 구획의 해발 고도를 나타냅니다. 농장 양옆에는 두 개의 저수지가 있는데, **상단 저수지**는 맨 위 가장자리(0행)나 왼쪽 가장자리(0열)에 접한 구획에서 흘러내린 물을 모으고, **하단 저수지**는 맨 아래 가장자리나 오른쪽 가장자리에 접한 구획에서 흘러내린 물을 모읍니다.

물은 현재 구획의 고도보다 **작거나 같은** 고도를 지닌 4방향 이웃 구획으로 흐르며, 가장자리에 맞닿은 구획은 그 쪽 저수지로 곧바로 배수됩니다.

**두 저수지 모두**로 물이 흘러갈 수 있는 모든 좌표 `[r, c]`를 반환합니다. 순서는 상관없습니다.

**예시 1:**
```
Input: field = [[2,1,3,4,5],[3,2,3,5,6],[4,3,5,4,3],[5,6,4,3,2],[6,5,3,2,1]]
Output: [[0,4],[1,3],[1,4],[2,2],[3,1],[4,0]]
Explanation: Plot (2,2) sits on the central ridge — water can step down-left to reach the upland reservoir and down-right to reach the lowland one.
```

**예시 2:**
```
Input: field = [[2,4,6],[5,7,9],[8,10,12]]
Output: [[0,2],[1,2],[2,0],[2,1],[2,2]]
Explanation: Elevation rises monotonically toward the bottom-right, so only the right column and bottom row drain into both reservoirs.
```$$,
    $$- `m == field.length`
- `n == field[r].length`
- `1 <= m, n <= 200`
- `0 <= field[r][c] <= 80000`$$
);

-- check-key-reachability
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'check-key-reachability'),
    'ko',
    $$열쇠 도달 가능성 확인$$,
    $$창고에는 `0`부터 `n - 1`까지 번호가 매겨진 `n`개의 보안 통로가 있습니다. 각 통로에는 **다른** 통로를 열 수 있는 키 카드들이 보관되어 있습니다. 모든 통로는 잠겨 있으며 근무 시작 시 피커가 들어갈 수 있는 통로는 `0`번뿐입니다.

피커가 어떤 통로에 들어가면 그곳에 있는 모든 키 카드를 수거하고, 수거한 카드를 써서 대응하는 통로를 열 수 있습니다. `aisles[i]`가 통로 `i`에 보관된 키 카드들이 여는 통로 번호 목록일 때, 피커가 결국 **모든** 통로에 들어갈 수 있으면 `true`, 그렇지 않으면 `false`를 반환합니다.

**예시 1:**
```
Input: aisles = [[2,1],[4],[3],[],[3,0]]
Output: true
Explanation: Start in aisle 0 and pick up cards for 2 and 1. Aisle 1 holds the card for 4; aisle 2 holds the card for 3. Visiting 3 and 4 covers all five aisles.
```

**예시 2:**
```
Input: aisles = [[2],[3],[],[4],[1]]
Output: false
Explanation: Aisle 0 only offers the card for aisle 2, and aisle 2 is empty. The cards for aisles 1, 3, and 4 sit inside those aisles themselves, so they are never reachable.
```$$,
    $$- `1 <= n <= 1000`
- `0 <= aisles[i].length <= n`
- `0 <= aisles[i][j] < n`
- `aisles[i]`의 모든 값은 서로 다릅니다.$$
);

-- spread-contamination-wave
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'spread-contamination-wave'),
    'ko',
    $$오염 확산 파동$$,
    $$격리 병동이 `m x n` 크기의 병상 슬롯 격자로 배치되어 있습니다. 매 분마다 각 병상은 다음 세 가지 상태 중 하나로 분류됩니다.

- `0` — **빈 슬롯** (환자 없음)
- `1` — **안정 환자**
- `2` — **감염 환자**

오염은 1분에 한 칸씩 퍼집니다. 감염 환자와 4방향으로 변을 공유하는 안정 환자는 해당 분이 끝날 때 감염 상태로 바뀝니다. 안정 환자가 하나도 남지 않을 때까지 걸리는 최소 분 수를 반환합니다. 도달할 수 없는 안정 환자가 있다면 `-1`을 반환합니다.

**예시 1:**
```
Input: ward = [[2,1,1],[1,0,1],[1,1,1]]
Output: 4
Explanation: Starting from the single infectious bed at (0,0), the wave reaches its last stable patient at (2,2) after four minutes.
```

**예시 2:**
```
Input: ward = [[2,0,1],[0,0,1],[1,1,1]]
Output: -1
Explanation: The infectious bed at (0,0) is walled off by empty slots, so the wave can never reach the stable patients.
```

**예시 3:**
```
Input: ward = [[0,0,2],[0,0,0]]
Output: 0
Explanation: There are no stable patients, so zero minutes pass.
```$$,
    $$- `m == ward.length`
- `n == ward[i].length`
- `1 <= m, n <= 10`
- `ward[i][j]`는 `0`, `1`, 또는 `2`입니다.$$
);

-- chart-block-route
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'chart-block-route'),
    'ko',
    $$차단 구간 경로 계획$$,
    $$`n x n` 격자 형태의 교차로로 이루어진 작은 구역의 교통 관제 콘솔을 담당합니다. `grid`의 각 칸은 `0`(통행 가능)이거나 `1`(사고로 인해 폐쇄)입니다. 배차 담당자는 북서쪽 모서리 `(0, 0)`에서 남동쪽 모서리 `(n - 1, n - 1)`까지 가장 빠른 킹 스타일 경로를 필요로 하며, 차량은 한 번에 8방향(N, S, E, W 또는 대각선)으로 이웃한 교차로로 이동할 수 있습니다.

`chartBlockRoute(grid)`를 구현해, 양 끝점을 모두 포함하여 최단 통행 경로에 놓인 교차로 개수를 반환하세요. 경로상의 모든 교차로는 값이 `0`이어야 합니다. 어느 한쪽 끝이 폐쇄되었거나 경로가 존재하지 않으면 `-1`을 반환합니다.

**예시 1:**
```
Input: grid = [[0,0],[0,0]]
Output: 2
Explanation: A single diagonal step from (0,0) to (1,1) visits 2 clear intersections.
```

**예시 2:**
```
Input: grid = [[0,1,0],[0,0,0],[1,0,0]]
Output: 3
Explanation: The corridor (0,0) -> (1,1) -> (2,2) visits 3 intersections and avoids every closure.
```$$,
    $$- `n == grid.length`
- `n == grid[i].length`
- `1 <= n <= 120`
- 각 `grid[i][j]`는 `0` 또는 `1`$$
);

-- split-into-two-shifts
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'split-into-two-shifts'),
    'ko',
    $$두 교대조로 분할$$,
    $$식당 매니저가 홀 직원을 정확히 두 개의 교대조로 나누려 합니다. 각 직원은 `0`부터 `n - 1`까지의 인덱스를 가지며, `conflicts[i]`는 직원 `i`와 같은 교대조에 배치할 수 없는 동료들의 인덱스 목록입니다(성격 충돌이나 담당 구역 중복 등의 이유). 충돌 관계는 대칭적이며, 서로 분리된 여러 직원 집단으로 이루어질 수 있습니다.

`splitIntoTwoShifts(conflicts)`를 구현해, 충돌하는 두 동료가 같은 교대조에 놓이지 않도록 모든 직원을 두 교대조 중 하나에 배정할 수 있으면 `true`, 어떤 충돌 집단 때문에 불가능하면 `false`를 반환하세요.

**예시 1:**
```
Input: conflicts = [[1],[0,2],[1,3],[2]]
Output: true
Explanation: Place staff 0 and 2 on the morning shift and staff 1 and 3 on the evening shift; every listed conflict crosses shifts.
```

**예시 2:**
```
Input: conflicts = [[1,2],[0,2],[0,1]]
Output: false
Explanation: Staff 0, 1, and 2 mutually conflict, so any assignment of three people to two shifts forces two of them together.
```$$,
    $$- `1 <= conflicts.length <= 150`
- `0 <= conflicts[i].length < conflicts.length`
- `conflicts[i]`는 `i`를 포함하지 않습니다
- `conflicts[i]`가 `j`를 포함하면 `conflicts[j]`도 `i`를 포함합니다
- 충돌 그래프는 여러 연결 요소로 나뉠 수 있습니다$$
);

-- is-acyclic-network
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'is-acyclic-network'),
    'ko',
    $$비순환 네트워크 판별$$,
    $$택배 회사가 영업소를 `0`부터 `n - 1`까지 번호가 붙은 `n`개의 노드로, 양방향 이송 경로를 `lanes` 목록으로 모델링합니다. 각 항목 `[u, v]`는 영업소 `u`와 `v` 사이에 소포가 자유롭게 오갈 수 있음을 의미합니다. 배차 팀은 이 네트워크가 깔끔한 계층 구조이기를 원합니다. 즉, 모든 영업소가 서로 도달 가능해야 하고, 소포가 제자리로 돌아오게 만드는 중복 루프가 없어야 합니다.

`isAcyclicNetwork(n, lanes)`를 구현해, 영업소와 경로가 함께 하나의 완전히 연결되고 순환이 없는 구조를 이루면 `true`, 그렇지 않으면 `false`를 반환하세요.

**예시 1:**
```
Input: n = 6, lanes = [[0,1],[0,2],[1,3],[1,4],[2,5]]
Output: true
Explanation: All 6 depots are reachable from depot 0, and the 5 lanes introduce no loops.
```

**예시 2:**
```
Input: n = 4, lanes = [[0,1],[1,2],[2,0],[0,3]]
Output: false
Explanation: Depots 0, 1, and 2 form a cycle, so the structure is not loop-free.
```$$,
    $$- `1 <= n <= 2 * 10^3`
- `0 <= lanes.length <= 4500`
- `lanes[i].length == 2`
- `0 <= lanes[i][0], lanes[i][1] < n`
- 자기 자신으로의 루프나 중복된 경로는 없습니다$$
);

-- bridge-label-chain
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'bridge-label-chain'),
    'ko',
    $$라벨 체인 연결$$,
    $$재활용 처리장에서는 각 분류 스테이션에 짧은 소문자 코드가 붙어 있으며, 라인을 재구성하려면 그 코드를 한 글자씩 바꿔야 합니다. 각 재구성 단계는 현재 코드의 문자 하나를 교체하며, 바뀐 코드는 승인된 스테이션 라벨 목록 `codeBank`에 존재해야 합니다. 시작 라벨 `startCode`와 길이가 같은 목표 라벨 `targetCode`가 주어집니다.

`bridgeLabelChain(startCode, targetCode, codeBank)`를 구현해, `startCode`에서 시작해 `targetCode`에서 끝나며 매 단계마다 정확히 한 글자씩 바꾸고 모든 중간 코드가 `codeBank`에 속하는 가장 짧은 수열의 총 코드 수를 반환하세요. `startCode`는 `codeBank`에 포함되지 않아도 되지만, `targetCode`는 반드시 포함되어야 합니다. 그런 수열이 존재하지 않으면 `0`을 반환합니다.

**예시 1:**
```
Input: startCode = "pet", targetCode = "pot", codeBank = ["pit","pot","pat"]
Output: 3
Explanation: pet -> pit -> pot reconfigures one character per step and every intermediate code is approved.
```

**예시 2:**
```
Input: startCode = "pet", targetCode = "pot", codeBank = ["pit","pat"]
Output: 0
Explanation: The target code "pot" is not in codeBank, so no sequence can end there.
```$$,
    $$- `1 <= startCode.length <= 10`
- `targetCode.length == startCode.length`
- `1 <= codeBank.length <= 4500`
- `codeBank[i].length == startCode.length`
- `startCode`, `targetCode`, 그리고 각 `codeBank[i]`는 영어 소문자로만 이루어집니다
- `startCode != targetCode`$$
);

-- verify-bake-rotation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'verify-bake-rotation'),
    'ko',
    $$베이킹 순서 검증$$,
    $$제빵사가 컨베이어 오븐의 각 슬롯에 차례로 올려지는 빵 덩어리 수를 기록합니다. 이 순환은 트레이 수가 첫 슬롯부터 마지막 슬롯까지 비내림차순일 때(뒤쪽 슬롯이 앞쪽 슬롯보다 적은 덩어리를 싣지 않을 때) **매끄럽다**고 간주합니다.

정수 배열 `trays`가 주어질 때, 슬롯 **하나**의 값을 임의의 정수로 바꾸는 조정만으로 수열을 비내림차순으로 만들 수 있으면 `true`, 그렇지 않으면 `false`를 반환합니다.

**예시 1:**
```
Input: trays = [3,1,4,5]
Output: true
Explanation: Lowering the first slot to 1 yields [1,1,4,5], which is non-decreasing.
```

**예시 2:**
```
Input: trays = [6,4,2,3]
Output: false
Explanation: Two distinct slots are out of order, so a single adjustment cannot fix the rotation.
```$$,
    $$- `1 <= trays.length <= 2 * 10^5`
- `-10^8 <= trays[i] <= 10^8`$$
);

-- balance-print-jobs
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'balance-print-jobs'),
    'ko',
    $$인쇄 작업 균형 맞추기$$,
    $$복사 가게의 스풀러는 대기 중인 작업을 간결한 태그 문자열로 저장합니다. `(`는 새 인쇄 배치를 여는 작업, `)`는 현재 열린 배치를 닫는 작업을 뜻하고, `*`는 **유연 슬롯**으로 큐를 비울 때 `(`, `)`, 또는 생략 중 어느 하나로 해석할 수 있습니다.

태그 문자열은 모든 여는 태그가 이후의 닫는 태그와 짝을 이루고 전체 순서가 올바르게 구성되어 있을 때 **균형 잡힌** 상태입니다. 큐 문자열 `code`가 주어질 때, 유연 슬롯을 적절히 해석해 `code`를 균형 잡히게 만들 수 있으면 `true`, 그렇지 않으면 `false`를 반환합니다.

**예시 1:**
```
Input: code = "((*)"
Output: true
Explanation: Treating the flexible slot as ')' yields "(())", which is balanced.
```

**예시 2:**
```
Input: code = "())"
Output: false
Explanation: A closing tag has no opening partner and no flexible slot is available to compensate.
```$$,
    $$- `1 <= code.length <= 120`
- `code`의 각 문자는 `'('`, `')'`, 또는 `'*'` 입니다$$
);

-- choose-start-station
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'choose-start-station'),
    'ko',
    $$출발 정거장 선택$$,
    $$무인 셔틀이 `n`개의 승강장을 도는 순환 지하철 노선을 운행합니다. 승강장 `i`에서는 충전 코일로부터 `energy[i]` 단위를 공급받고, 승강장 `i`에서 `(i + 1) mod n`으로 가는 구간은 `drain[i]` 단위를 소모합니다. 셔틀은 여러분이 선택한 승강장에서 빈 배터리 상태로 출발하며, 배터리가 0 미만으로 떨어지지 않으면서 시계 방향으로 한 바퀴를 완주해야 합니다.

정수 배열 `energy`와 `drain`이 주어질 때, 유효한 출발 승강장의 인덱스를 반환하고, 완주할 수 없으면 `-1`을 반환하세요. 유효한 출발점이 존재하면 그 값은 유일함이 보장됩니다.

**예시 1:**
```
Input: energy = [4,6,1,3,5], drain = [3,5,2,2,6]
Output: 0
```

**예시 2:**
```
Input: energy = [5,2,8], drain = [6,4,7]
Output: -1
```$$,
    $$- `n == energy.length == drain.length`
- `1 <= n <= 2 * 10^5`
- `0 <= energy[i], drain[i] <= 8000`$$
);

-- group-oven-bakes
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'group-oven-bakes'),
    'ko',
    $$오븐 베이킹 그룹 편성$$,
    $$한 베이커리의 스케줄러는 구워지기를 기다리는 트레이 번호들의 멀티셋을 관리합니다. 트레이 번호 `t`는 마스터 로테이션 차트에서 `t`로 표기된 레시피를 의미합니다. 수석 제빵사는 정확히 `runSize`개의 트레이로 이루어지며 레시피 번호가 연속된 정수인 **런(run)** 단위로 오븐을 돌리고 싶어합니다 (예: `runSize = 3`일 때 `{7,8,9}`). 큐에 있는 모든 트레이는 이러한 런 중 정확히 하나에 속해야 합니다.

정수 배열 `trays`와 정수 `runSize`가 주어질 때, 큐를 `runSize`개의 연속된 레시피 번호로 이루어진 런들로 분할할 수 있으면 `true`를, 그렇지 않으면 `false`를 반환하세요.

**예시 1:**
```
Input: trays = [2,3,4,5,6,7], runSize = 3
Output: true
Explanation: Fire the ovens as [2,3,4] then [5,6,7].
```

**예시 2:**
```
Input: trays = [1,2,3,5], runSize = 2
Output: false
Explanation: After pairing [1,2], the leftover trays 3 and 5 are not consecutive.
```$$,
    $$- `1 <= trays.length <= 2 * 10^5`
- `0 <= trays[i] <= 10^8`
- `1 <= runSize <= trays.length`$$
);

-- order-ticket-holders
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'order-ticket-holders'),
    'ko',
    $$티켓 보유자 줄 세우기$$,
    $$한 콘서트 홀이 좌석을 풀기 전에 대기 줄을 재정렬하려 합니다. 각 티켓 보유자는 한 쌍 `[h, k]`로 표현되는데, `h`는 보유자의 키(센티미터)이고 `k`는 그 보유자의 **앞쪽에** 위치한 사람 중 키가 `h` 이상인 사람의 수입니다. 현재 줄은 뒤섞여 있으며, 모든 보유자의 `k` 값이 앞에 서 있는 사람들의 배치와 일관되도록 줄을 다시 구성해야 합니다.

배열 `holders`가 주어질 때, 재정렬된 줄을 앞에서부터 뒤 순서로 `[h, k]` 쌍의 리스트로 반환하세요. 유효한 순서가 존재함이 보장됩니다.

**예시 1:**
```
Input: holders = [[8,0],[6,0],[8,1],[4,2],[6,2]]
Output: [[6,0],[8,0],[4,2],[6,2],[8,1]]
```

**예시 2:**
```
Input: holders = [[5,0],[4,1],[5,1],[3,2]]
Output: [[5,0],[4,1],[3,2],[5,1]]
```$$,
    $$- `1 <= holders.length <= 2 * 10^3`
- `0 <= h <= 8 * 10^5`
- `0 <= k < holders.length`
- 유효한 줄 세우기 순서가 존재함이 보장됩니다$$
);

-- fewest-van-hops
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'fewest-van-hops'),
    'ko',
    $$최소 배송 밴 이동 횟수$$,
    $$한 택배 업체의 밴이 `0`부터 `n - 1`까지 번호가 매겨진 정류소들을 따라 당일 배송을 계획합니다. 밴은 소포를 싣고 정류소 `0`에서 출발합니다. 배차 담당자는 배열 `fuel`을 제공하며, `fuel[i]`는 정류소 `i`에서 밴이 재급유하기 전까지 전방으로 나아갈 수 있는 최대 거리(정류소 개수)입니다. 즉, 정류소 `i`에서 밴은 `[i + 1, i + fuel[i]]` 범위의 임의의 정류소로 다음에 이동할 수 있습니다.

밴이 마지막 정류소 `n - 1`에 도달하기 위해 필요한 최소 이동 횟수를 반환하는 `minVanHops(fuel)`을 작성하세요. 배차 담당자는 이 배송이 실현 가능함을 보장하므로, 실패를 보고할 필요는 없습니다.

**예시 1:**
```
Input: fuel = [1,4,2,1,3,1,2]
Output: 3
Explanation: Hop from stop 0 to stop 1 (one step). From stop 1 the van can reach up to stop 5, so hop to stop 4. From stop 4 the van reaches stop 6, the final stop.
```

**예시 2:**
```
Input: fuel = [3,1,1,4,2,1]
Output: 2
Explanation: Hop from stop 0 directly to stop 3 (within the reach of 3). From stop 3 the van can reach up to stop 7, which covers the final stop 5.
```$$,
    $$- `1 <= fuel.length <= 2 * 10^3`
- `0 <= fuel[i] <= 1000`
- 마지막 정류소는 정류소 `0`에서 반드시 도달 가능합니다.$$
);

-- split-zone-runs
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'split-zone-runs'),
    'ko',
    $$구역별 런 분할$$,
    $$한 재활용 처리장은 하나의 컨베이어에 품목을 투입하며, 각 품목에는 이미 한 글자짜리 재질 코드가 태그되어 있습니다. 회계 처리를 위해 이 처리장은 교대 근무 동안의 스트림을 가능한 한 많은 연속된 런으로 자르되, 다음 규칙을 지켜야 합니다: 특정 재질 코드는 정확히 하나의 런에만 나타나야 하며, 결코 두 런에 걸쳐 쪼개질 수 없습니다. 이 런들을 순서대로 이어 붙이면 원래 스트림 `stream`이 복원되어야 합니다.

각 런의 길이를 순서대로 반환하는 `splitZoneRuns(stream)`을 작성하세요.

**예시 1:**
```
Input: stream = "mnopmpoqrqrts"
Output: [7,4,1,1]
Explanation: 'm', 'n', 'o', 'p' are all contained in the first 7 characters. Then 'q' and 'r' fill positions 7..10. 't' and 's' each occur once.
```

**예시 2:**
```
Input: stream = "xyzzyx"
Output: [6]
Explanation: 'x' bookends the stream, forcing 'y' and 'z' into the same run, so the entire string is one run.
```$$,
    $$- `1 <= stream.length <= 500`
- `stream`은 영어 소문자로만 이루어집니다.$$
);

-- peak-reading-window
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'peak-reading-window'),
    'ko',
    $$최고 측정값 구간$$,
    $$한 기상 관측소는 매 시간 기온 이상치(계절 평균으로부터의 편차)를 정수로 기록합니다. 기상 전문가는 로그에서 가장 뜨거웠던 연속 구간, 즉 합이 가장 큰 비어 있지 않은 연속 측정값 윈도우를 찾아 그 합을 열 피크(heat-peak) 점수로 보고하려 합니다.

`readings`에서 비어 있지 않은 임의의 연속된 윈도우로부터 얻을 수 있는 최대 합을 반환하는 `peakReadingSum(readings)`를 작성하세요.

**예시 1:**
```
Input: readings = [3,-2,5,-1,2,-8,4,3]
Output: 7
Explanation: The window [3,-2,5,-1,2] sums to 7, which is the maximum.
```

**예시 2:**
```
Input: readings = [2,1,-3,6,4]
Output: 10
Explanation: The window [6,4] sums to 10. Taking the whole array sums to 10 as well.
```$$,
    $$- `1 <= readings.length <= 2 * 10^5`
- `|readings[i]| <= 10^8`$$
);

-- finish-assembly-line
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'finish-assembly-line'),
    'ko',
    $$조립 라인 완주 가능성$$,
    $$어떤 조립 라인에는 왼쪽에서 오른쪽으로 `0`부터 `n - 1`까지 인덱싱된 `n`개의 스테이션이 배치되어 있습니다. 부품은 스테이션 `0`에서 들어옵니다. 각 스테이션 `i`에는 여유 값 `slack[i]`가 있어, 스테이션 `i`에서 부품을 처리한 후 `[i + 1, i + slack[i]]` 범위의 임의의 하류 스테이션으로 부품을 보낼 수 있습니다. 여유 값이 `0`이면 부품은 그 자리에서 멈추며 더 이상 진행할 수 없습니다.

스테이션 `0`에서 스테이션 `n - 1`까지 부품을 라우팅할 수 있으면 `true`를, 그렇지 않으면 `false`를 반환하는 `canFinishLine(slack)`을 작성하세요.

**예시 1:**
```
Input: slack = [2,1,3,1,1,2]
Output: true
Explanation: Route 0 -> 2 (slack 2), 2 -> 5 (slack 3). Station 5 is the final station.
```

**예시 2:**
```
Input: slack = [2,0,0,1,3]
Output: false
Explanation: From station 0 the part can only reach stations 1 or 2, both of which halt it. Station 3 is unreachable.
```$$,
    $$- `1 <= slack.length <= 2 * 10^5`
- `0 <= slack[i] <= 8 * 10^4`$$
);

-- form-bale-triple
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'form-bale-triple'),
    'ko',
    $$베일 트리플 조합하기$$,
    $$한 재활용 처리장은 혼합 재질을 라벨이 붙은 베일(bale)로 압축합니다. 들어오는 각 베일은 세 채널 프로파일 `[paper, plastic, metal]`을 가지는데, 이는 베일 안에 든 각 재질의 무게(킬로그램)를 의미합니다. 공장장은 일부 베일들의 부분집합을 서로 겹쳐 올려 하나의 슈퍼 베일로 합치고자 합니다. 슈퍼 베일의 각 채널 값은 선택된 베일들의 해당 채널 값들의 **최댓값**으로 정해집니다. 어떤 베일이 한 채널이라도 `target` 프로파일의 해당 채널을 초과하는 값을 가지면, 그 채널을 넘겨 슈퍼 베일을 실격시키므로 사용할 수 없습니다.

사용 가능한 베일들의 어떤 부분집합이 채널별 최댓값 연산으로 `target`과 정확히 일치하게 합쳐지면 `true`를, 그렇지 않으면 `false`를 반환하는 `canBuildBales(bales, target)`을 작성하세요.

**예시 1:**
```
Input: bales = [[3,2,1],[1,6,4],[3,1,7],[2,5,2]], target = [3,6,7]
Output: true
Explanation: Stack [3,2,1], [1,6,4], and [3,1,7]. The channel-wise maxima are [3,6,7].
```

**예시 2:**
```
Input: bales = [[2,3,4],[4,2,1]], target = [2,3,5]
Output: false
Explanation: The second bale overshoots channel 0 (4 > 2) so it is unusable. The first bale alone yields [2,3,4], and no usable bale can lift channel 2 up to 5.
```$$,
    $$- `1 <= bales.length <= 2 * 10^5`
- `bales[i].length == 3`
- `1 <= bales[i][j], target[j] <= 1000`$$
);

-- brightest-observed-targets
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'brightest-observed-targets'),
    'ko',
    $$가장 밝은 관측 대상$$,
    $$한 관측소는 밤 동안 관측된 모든 천체 대상의 겉보기 밝기(상대 등급 단위)를 기록합니다. 스태킹 파이프라인을 준비 중인 연구자는 중복을 포함하여 `k`번째로 밝은 측정값을 알고자 합니다. 예를 들어 측정값 `[8, 3, 5, 5]`에서 1번째로 밝은 값은 `8`이고 2번째로 밝은 값은 `5`입니다.

로그를 내림차순으로 정렬했을 때 `k`번째 위치에 있는 밝기 값을 반환하도록 `findBrightestTargets(readings, k)`를 구현하세요.

**예시 1:**
```
Input: readings = [7,2,9,4,9,6,3], k = 3
Output: 7
Explanation: Sorted descending: [9,9,7,6,4,3,2]. The 3rd entry is 7.
```

**예시 2:**
```
Input: readings = [12,5,8,5,8,15,3,11], k = 4
Output: 8
Explanation: Sorted descending: [15,12,11,8,8,5,5,3]. The 4th entry is 8.
```$$,
    $$- `1 <= k <= readings.length <= 2 * 10^5`
- `|readings[i]| <= 10^8`$$
);

-- trending-feed-topics
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'trending-feed-topics'),
    'ko',
    $$인기 피드 토픽$$,
    $$한 뉴스 애그리게이터는 들어오는 기사 제목을 토픽 라벨별로 묶고, 현재 윈도우에서 가장 자주 언급된 `k`개의 토픽을 노출하고자 합니다. 두 토픽의 언급 횟수가 같을 때는, 새로고침 간에 순위가 결정적이도록 편집자가 알파벳 순으로 앞서는 토픽을 선호합니다.

빈도가 가장 높은 `k`개의 토픽 라벨을 반환하되, 빈도 내림차순으로 정렬하고 동률일 때는 라벨 오름차순으로 정렬하도록 `rankTrendingTopics(topics, k)`를 구현하세요.

**예시 1:**
```
Input: topics = ["climate","climate","market","sports","market","climate","weather"], k = 2
Output: ["climate","market"]
Explanation: "climate" appears 3 times and "market" appears 2 times — the two loudest topics in the window.
```

**예시 2:**
```
Input: topics = ["tech","tech","film","film","music","books","music"], k = 3
Output: ["film","music","tech"]
Explanation: "film", "music", and "tech" all appear twice, so they are returned in alphabetical order.
```$$,
    $$- `1 <= topics.length <= 2 * 10^3`
- `1 <= topics[i].length <= 10`
- `topics[i]`는 영어 소문자로만 이루어집니다
- `k`는 `[1, 서로 다른 토픽의 수]` 범위에 있습니다
- 정답은 유일함이 보장됩니다$$
);

-- station-run-planner
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'station-run-planner'),
    'ko',
    $$스테이션 작업 스케줄러$$,
    $$한 제조 라인의 컨베이어는 부품들을 흘려보내며, 각 부품은 그것을 조립해야 하는 스테이션 코드로 라벨링되어 있습니다. 같은 코드의 두 연속된 작업 사이에는 각 스테이션마다 `n` 사이클의 의무적인 쿨다운이 필요하므로, 플래너는 필요하면 유휴(idle) 사이클을 삽입해야 합니다. 부품의 순서는 자유롭게 바꿀 수 있습니다.

매 사이클마다 스케줄러는 한 부품을 해당 스테이션에서 처리하거나 유휴 상태로 머무릅니다. 쿨다운 조건을 지키면서 모든 부품을 처리하기 위한 최소 사이클 수를 반환하도록 `planStationRuns(runs, n)`을 구현하세요.

**예시 1:**
```
Input: runs = ["P","P","P","P","Q","Q"], n = 3
Output: 13
Explanation: One valid schedule is P -> Q -> idle -> idle -> P -> Q -> idle -> idle -> P -> idle -> idle -> idle -> P, using 13 cycles.
```

**예시 2:**
```
Input: runs = ["A","B","C","A","B","D"], n = 1
Output: 6
Explanation: The order A -> B -> C -> A -> B -> D already separates identical stations by at least 1 cycle, so no idle cycles are needed.
```$$,
    $$- `1 <= runs.length <= 2 * 10^3`
- `runs[i]`는 영어 대문자입니다
- `0 <= n <= 100`$$
);

-- nearest-depot-stops
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'nearest-depot-stops'),
    'ko',
    $$가장 가까운 배송지 선택$$,
    $$택배 배차 콘솔은 예정된 모든 배송지를 원점에 위치한 중앙 창고를 기준으로 한 `[x, y]` 좌표로 표시합니다. 배차에 앞서 배차 담당자는 첫 번째 밴에 근거리 소포를 우선 적재할 수 있도록, 창고에서 물리적으로 가장 가까운 `k`개의 배송지를 뽑아냅니다.

배송지에서 창고까지의 거리는 유클리드 거리 `sqrt(x^2 + y^2)`입니다. `selectNearestStops(stops, k)`를 구현하여 가장 가까운 `k`개의 배송지를 반환하세요. 나열 순서를 제외하면 정답은 유일함이 보장됩니다.

**예시 1:**
```
Input: stops = [[2,4],[7,7]], k = 1
Output: [[2,4]]
Explanation: sqrt(2^2 + 4^2) ≈ 4.47 is less than sqrt(7^2 + 7^2) ≈ 9.90, so (2, 4) is the nearest stop.
```

**예시 2:**
```
Input: stops = [[5,5],[1,2],[-3,1],[4,-4]], k = 2
Output: [[-3,1],[1,2]]
Explanation: The closest two stops are (-3, 1) at sqrt(10) and (1, 2) at sqrt(5).
```$$,
    $$- `1 <= k <= stops.length <= 2 * 10^3`
- `|x|, |y| <= 10^8`$$
);

-- crush-heaviest-bales
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'crush-heaviest-bales'),
    'ko',
    $$가장 무거운 베일 충돌$$,
    $$한 재활용 공장의 야적장에는 각각 무게가 숫자로 표시된 압축 베일이 쌓여 있습니다. 분쇄기 팔은 가장 무거운 두 베일을 반복해서 집어 들어 서로 충돌시킵니다. 두 베일의 무게가 `x`와 `y`이고 `x <= y`라면, 결과는 다음과 같습니다.

- `x == y`라면 두 베일 모두 완전히 부서져 제거됩니다.
- `x != y`라면 가벼운 베일은 사라지고, 무거운 베일은 `y - x` 무게로 줄어듭니다.

야적장에 베일이 최대 하나만 남을 때까지 이 과정을 반복합니다. `crushHeaviestBales(bales)`를 구현하여 마지막에 남은 베일의 무게를 반환하고, 야적장이 비어 있으면 `0`을 반환하세요.

**예시 1:**
```
Input: bales = [3,6,4,9,5,2]
Output: 1
Explanation:
Crush 9 and 6 -> remaining 3; yard becomes [3,4,5,2,3].
Crush 5 and 4 -> remaining 1; yard becomes [3,2,3,1].
Crush 3 and 3 -> both destroyed; yard becomes [2,1].
Crush 2 and 1 -> remaining 1; yard becomes [1].
```

**예시 2:**
```
Input: bales = [9]
Output: 9
```$$,
    $$- `1 <= bales.length <= 40`
- `1 <= bales[i] <= 1500`$$
);

-- space-recipe-bakes
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'space-recipe-bakes'),
    'ko',
    $$우주 베이커리 굽기 순서$$,
    $$우주 조리실 베이커리의 오븐 파이프라인은 한 접시에 담긴 여러 포션을 구워내야 하며, 각 포션에는 레시피를 나타내는 알파벳이 붙어 있습니다. 맛이 섞이지 않도록, 냉각 랙 위에서 서로 인접한 두 포션은 같은 레시피 글자를 가질 수 없습니다.

`orderRecipeBakes(recipes)`를 구현하여 `recipes`의 글자들을 재배열한 결과 중 인접한 두 글자가 같지 않은 배열을 반환하세요. 그러한 배열이 존재하지 않는다면 빈 문자열 `""`을 반환합니다.

**예시 1:**
```
Input: recipes = "bread"
Output: "brade"
Explanation: Any arrangement with no two equal adjacent letters is accepted — e.g. "brade" or "dabre".
```

**예시 2:**
```
Input: recipes = "aaaab"
Output: ""
Explanation: The letter 'a' appears 4 times in a length-5 string, so any arrangement must place two 'a's next to each other.
```

**예시 3:**
```
Input: recipes = "flour"
Output: "flour"
Explanation: All letters are distinct, so the input itself is already a valid arrangement.
```$$,
    $$- `1 <= recipes.length <= 800`
- `recipes` consists of lowercase English letters only$$
);

-- cover-watering-windows
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'cover-watering-windows'),
    'ko',
    $$급수 구간 전체 커버$$,
    $$새벽 관개 팀은 농장의 물이 필요한 모든 구획을 메인 파이프라인을 따라 놓인 1차원 급수 구간으로 표시했습니다. 각 구획은 `[start, end]` (양 끝 포함)로 기술되며, 이는 해당 구획에 물을 대기 위해 스프링클러가 닿아야 하는 파이프라인 위치 범위를 의미합니다.

스프링클러는 파이프라인 상의 임의의 위치 `x`에 설치할 수 있습니다. 위치 `x`에 설치된 스프링클러 하나는 `start <= x <= end`를 만족하는 모든 구획에 물을 공급합니다. 급수 구간 목록 `plots`가 주어질 때, 모든 구획에 최소 한 번씩 물을 주기 위해 필요한 스프링클러의 **최소** 개수를 반환하세요.

**예시 1:**
```
Input: plots = [[5,11],[3,9],[8,14],[12,18],[20,25]]
Output: 3
Explanation: One valid placement is sprinklers at 9, 18, and 25. The sprinkler at 9 waters [3,9], [5,11], and [8,14]; the sprinkler at 18 waters [12,18]; the sprinkler at 25 waters [20,25].
```

**예시 2:**
```
Input: plots = [[1,5],[6,10],[11,15]]
Output: 3
Explanation: No two plots share any pipeline position, so every plot needs its own sprinkler.
```$$,
    $$- `1 <= plots.length <= 2 * 10^5`
- `plots[i].length == 2`
- `-10^8 <= start <= end <= 10^8`$$
);

-- schedule-observing-window
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'schedule-observing-window'),
    'ko',
    $$관측 시간대 일정 삽입$$,
    $$천문대의 관측 일지는 이미 망원경 대상에 예약된 밤 시간의 분 단위를 나타내는 `windows` 목록을 유지합니다. 각 항목은 `[start, end]` 형태이며, `start` 기준으로 정렬되어 있고 서로 겹치지 않습니다. 방금 새로운 관측 대상이 승인되었고, 일지에 추가해야 할 가시성 구간 `newWindow = [start, end]`가 주어졌습니다.

`newWindow`를 `windows`에 삽입하되, 결과가 여전히 `start` 기준으로 정렬되고 서로 겹치지 않도록 만드세요. `newWindow`와 맞닿거나 겹치는 관측 시간대는 하나의 항목으로 병합한 뒤, 갱신된 목록을 반환합니다.

**예시 1:**
```
Input: windows = [[1,4],[7,10]], newWindow = [3,6]
Output: [[1,6],[7,10]]
Explanation: newWindow overlaps [1,4], so they merge into [1,6]. [7,10] is untouched.
```

**예시 2:**
```
Input: windows = [[2,4],[6,8],[10,12],[14,18]], newWindow = [5,11]
Output: [[2,4],[5,12],[14,18]]
Explanation: newWindow swallows [6,8] and [10,12], merging with both to form [5,12].
```$$,
    $$- `0 <= windows.length <= 8000`
- `windows[i].length == 2`
- `0 <= start <= end <= 8 * 10^4`
- `windows` is sorted by `start` in ascending order and contains no overlaps.
- `newWindow.length == 2`$$
);

-- peak-gate-demand
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'peak-gate-demand'),
    'ko',
    $$게이트 최대 수요$$,
    $$공항 운영팀은 터미널에서 가장 바쁜 순간을 파악하고자 합니다. `flights`가 주어지며, `flights[i] = [arrival, departure]`는 `i`번째 항공편이 게이트에 진입하는 시각(분)과 밀어 나가는 시각(분)을 나타냅니다. 하나의 게이트는 한 번에 하나의 항공편만 수용할 수 있으며, 항공편은 반개구간 `[arrival, departure)` 동안 게이트를 점유합니다. 즉, 이전 항공편이 떠나는 바로 그 시각에 다음 항공편이 같은 게이트로 들어올 수 있습니다.

모든 항공편이 체류 기간 내내 게이트를 확보할 수 있도록, 터미널이 운영해야 하는 게이트의 **최소** 개수를 반환하세요.

**예시 1:**
```
Input: flights = [[60,180],[90,150],[120,240],[200,300]]
Output: 3
Explanation: Between minute 120 and 150, the flights [60,180], [90,150], and [120,240] are all at a gate at once, so three gates are required.
```

**예시 2:**
```
Input: flights = [[500,600],[100,200]]
Output: 1
Explanation: The two flights never share a minute at a gate, so a single gate suffices.
```$$,
    $$- `1 <= flights.length <= 8000`
- `0 <= arrival < departure <= 2 * 10^5`$$
);

-- drop-class-conflicts
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'drop-class-conflicts'),
    'ko',
    $$수업 충돌 제거$$,
    $$한 부티크 체육관에는 한 번에 하나의 수업만 지도할 수 있는 트레이너가 한 명뿐입니다. 요청된 모든 수업 시간대 `[start, end]` (개장 이후 경과 분)의 목록 `classes`가 주어집니다. 두 수업은 시간대가 엄격하게 겹칠 때에만 충돌하며, 한 수업이 끝나는 바로 그 시각에 다음 수업이 시작되는 것은 허용됩니다.

남은 수업들이 충돌 없이 모두 진행될 수 있도록, 요청 목록에서 반드시 제거해야 하는 수업의 **최소** 개수를 반환하세요.

**예시 1:**
```
Input: classes = [[1,3],[2,4],[3,5],[1,5]]
Output: 2
Explanation: Keep [1,3] and [3,5]; drop [2,4] and [1,5] to eliminate every overlap.
```

**예시 2:**
```
Input: classes = [[5,6],[5,6]]
Output: 1
Explanation: The two requests cover the same window, so one must go.
```

**예시 3:**
```
Input: classes = [[1,2],[2,3]]
Output: 0
Explanation: No conflict — the classes abut but do not overlap.
```$$,
    $$- `1 <= classes.length <= 2 * 10^5`
- `classes[i].length == 2`
- `-8 * 10^4 <= start < end <= 8 * 10^4`$$
);

-- tightest-or-booking
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'tightest-or-booking'),
    'ko',
    $$가장 타이트한 수술실 예약$$,
    $$병원 운영팀은 예약된 모든 수술실 블록을 `bookings[i] = [start, end]` 형태로 기록하며, 양 끝점은 공용 타임라인 상의 **포함된** 분 단위입니다. 이후 수간호사는 여러 질의를 던집니다. `probes`의 각 분 시점에 대해, 그 시점을 포함하는 예약 블록 중 가장 **짧은** 블록의 길이는 얼마인지 구하는 것이 목표입니다. 예약의 길이는 `end - start + 1`입니다.

`i`번째 원소가 `probes[i]`를 포함하는 가장 타이트한 예약의 길이이고, 그 시점을 포함하는 예약이 없다면 `-1`인 배열을 반환하세요.

**예시 1:**
```
Input: bookings = [[2,5],[4,7],[1,9],[6,10]], probes = [3,6,9,11]
Output: [4,4,5,-1]
Explanation: Minute 3 sits inside [2,5] (length 4) and [1,9] (length 9); the tightest is 4. Minute 11 is outside every booking.
```

**예시 2:**
```
Input: bookings = [[10,12],[8,20]], probes = [9,11,25]
Output: [13,3,-1]
Explanation: Minute 9 is only inside [8,20] (length 13). Minute 11 is inside [10,12] (length 3) and [8,20] (length 13); the tightest is 3. Minute 25 is outside every booking.
```$$,
    $$- `1 <= bookings.length <= 2 * 10^5`
- `1 <= probes.length <= 2 * 10^5`
- `1 <= start <= end <= 10^8`
- `1 <= probes[i] <= 10^8`$$
);

-- verify-table-bookings
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'verify-table-bookings'),
    'ko',
    $$테이블 예약 검증$$,
    $$한 레스토랑의 예약 장부는 단일 테이블에 대한 모든 예약을 `bookings[i] = [start, end]` 형태(개장 이후 경과 분)로 저장합니다. 호스트는 간단한 점검을 원합니다. 모든 예약이 같은 테이블에 필요하면 연이어, 두 팀이 동시에 앉는 일 없이 배정될 수 있는지 확인해야 합니다. 한 예약이 끝나는 바로 그 시각에 다음 예약이 시작되는 것은 허용됩니다. 그 사이에 테이블이 정리되기 때문입니다.

`bookings`의 어떤 두 항목도 열린 구간의 의미로 겹치지 않으면 `true`를, 그렇지 않으면 `false`를 반환하세요.

**예시 1:**
```
Input: bookings = [[18,20],[19,21],[22,23]]
Output: false
Explanation: [18,20] and [19,21] overlap at minute 19, so two parties would collide.
```

**예시 2:**
```
Input: bookings = [[18,20],[20,22],[22,23]]
Output: true
Explanation: Each booking ends exactly when the next starts, so the table turns cleanly.
```

**예시 3:**
```
Input: bookings = [[45,90],[30,60]]
Output: false
```$$,
    $$- `0 <= bookings.length <= 8000`
- `bookings[i].length == 2`
- `0 <= start < end <= 2 * 10^5`$$
);

-- tally-pick-paths
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'tally-pick-paths'),
    'ko',
    $$피킹 경로 합산$$,
    $$한 창고의 장부 시스템은 미처리 주문의 수량을 선반 체인으로 저장하며, 각 선반에 숫자 한 자리가 놓입니다. 체인은 **일의 자리가 맨 앞 선반에 오도록** 감겨 있어, 피커가 통로를 걸어가며 가장 먼저 읽게 되며, 그 뒤로 더 큰 자릿수가 이어집니다. 이러한 두 피킹 경로는 두 개의 음이 아닌 정수 수량을 의미하며, 이들을 하나의 통합 주문으로 합쳐야 합니다.

`tallyPickRoutes(route1, route2)`를 구현하여 합산 결과를 동일한 역순 자릿수 구조의 새 연결 리스트로 반환하세요. 두 입력 경로 모두 (값이 `0` 하나뿐인 단일 선반 경로를 제외하면) 앞자리에 `0`이 오지 않습니다.

**예시 1:**
```
Input: route1 = [3,1,7], route2 = [4,8]
Output: [7,9,7]
Explanation: The paths spell out 713 and 84. Their sum, 797, is laid back on the shelves ones-digit first.
```

**예시 2:**
```
Input: route1 = [9], route2 = [8]
Output: [7,1]
Explanation: 9 + 8 = 17, so the head shelf stores 7 and a carry shelf is appended for the tens digit.
```

**예시 3:**
```
Input: route1 = [1,8,6], route2 = [4,5]
Output: [5,3,7]
Explanation: 681 + 54 = 735.
```$$,
    $$- The number of shelves in each path is in the range `[1, 120]`.
- `0 <= Shelf.val <= 9`
- Neither path has a leading zero except the single-shelf path representing `0`.$$
);

-- duplicate-topic-web
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'duplicate-topic-web'),
    'ko',
    $$토픽 웹 복제$$,
    $$한 뉴스 애그리게이터는 **토픽 웹**을 유지합니다. 각 기사는 정수 토픽 id, 편집 순서상 다음 기사를 가리키는 `next` 포인터, 그리고 같은 웹 내 임의의 다른 기사를 가리키는 `related` 포인터(또는 `null`)를 가진 노드에 담겨 있습니다. 아카이빙을 위해서는 편집자가 라이브 피드를 건드리지 않고 실험할 수 있도록 웹을 완전히 독립적으로 복제해야 합니다.

`duplicateTopicWeb(head)`를 구현하여 해당 웹의 **깊은 복사본**의 헤드를 반환하세요. 복사본은 정확히 `n`개의 새로운 노드로 이루어져야 하며, 모든 `next`와 `related` 포인터는 원본이 아닌 복사본 내부의 노드만 가리켜야 합니다.

표준 입력은 `[val, related_index]` 쌍의 배열이며, `related_index`는 `related` 포인터가 가리키는 기사의 0-based 인덱스이거나 가리키는 대상이 없으면 `null`입니다.

**예시 1:**
```
Input: head = [[9,2],[4,null],[6,0],[2,1]]
Output: [[9,2],[4,null],[6,0],[2,1]]
Explanation: Four articles are cloned; each related pointer is rewired to the matching copy.
```

**예시 2:**
```
Input: head = [[5,0]]
Output: [[5,0]]
Explanation: The single node's related pointer loops back to itself in the clone.
```

**예시 3:**
```
Input: head = [[3,null],[7,null]]
Output: [[3,null],[7,null]]
```$$,
    $$- `0 <= n <= 1200`
- `-8 * 10^4 <= Node.val <= 8 * 10^4`
- `Node.related`는 `null`이거나 웹 내 어떤 노드를 가리키는 포인터입니다.$$
);

-- detect-transfer-loop
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'detect-transfer-loop'),
    'ko',
    $$환승 루프 탐지$$,
    $$한 교통 기획자가 지하철 노선을 역들의 연결된 체인으로 모델링합니다. 각 역의 `next` 포인터는 경로상 다음 환승역을 가리킵니다. 최근 재구성 이후 운영팀은 체인이 자기 자신으로 되돌아가, 환승 표지를 계속 따라가는 승객이 종착역에 도달하지 못하고 영원히 돌게 될까 걱정합니다.

`detectTransferLoop(head, pos)`를 구현하여 `head`에서 `next` 포인터를 따라가다가 어떤 역을 다시 방문하게 되면 `true`를, 그렇지 않으면 `false`를 반환하세요. 정수 `pos`는 꼬리가 연결되는 역의 0-based 인덱스이며(`-1`이면 꼬리는 진짜 종착역), 테스트 입력을 구성하기 위한 용도일 뿐 함수 로직의 일부가 **아닙니다**.

**예시 1:**
```
Input: head = [8,5,2,6,9], pos = 2
Output: true
Explanation: The tail station's next pointer loops back into the station at index 2, so the chain cycles.
```

**예시 2:**
```
Input: head = [4,7,3], pos = 0
Output: true
Explanation: The last station routes back to the head, forming a full loop.
```

**예시 3:**
```
Input: head = [6,2], pos = -1
Output: false
Explanation: The chain ends cleanly; there is no cycle.
```$$,
    $$- 노선의 역 수는 `[0, 2 * 10^3]` 범위입니다.
- `-8 * 10^4 <= Station.val <= 8 * 10^4`
- `pos`는 `-1`이거나 체인의 유효한 0-based 인덱스입니다.$$
);

-- merge-flight-rosters
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'merge-flight-rosters'),
    'ko',
    $$항공편 탑승자 명단 병합$$,
    $$한 공항의 근무 관리자는 도착 항공편마다 탑승 우선순위 명단을 관리합니다. 각 명단은 탑승 그룹 순으로 비내림차순 정렬된 승객 id들의 연결 체인입니다. 여러 항공편이 하나의 지상 팀에 통합될 때는, 각각의 명단을 하나의 정렬된 마스터 체인으로 이어 붙여야 합니다.

`mergeFlightRosters(rosters)`를 구현하여 `k`개의 정렬된 연결 리스트 헤드를 받아, 병합된 하나의 정렬된 연결 리스트의 헤드를 반환하세요. 병합된 리스트는 기존 노드를 재연결하여 구성해야 합니다.

**예시 1:**
```
Input: rosters = [[2,5,8],[1,3,7],[4,6]]
Output: [1,2,3,4,5,6,7,8]
Explanation: Three pre-sorted rosters are woven together into a single chain.
```

**예시 2:**
```
Input: rosters = []
Output: []
Explanation: With no rosters there is nothing to board.
```

**예시 3:**
```
Input: rosters = [[]]
Output: []
Explanation: A single empty roster merges to an empty chain.
```$$,
    $$- `k == rosters.length`
- `0 <= k <= 2 * 10^3`
- `0 <= rosters[i].length <= 500`
- `-8 * 10^4 <= rosters[i][j] <= 8 * 10^4`
- 각 `rosters[i]`는 오름차순으로 정렬되어 있습니다.
- 모든 명단에 걸친 승객 노드의 총 수는 `2 * 10^3`을 넘지 않습니다.$$
);

-- combine-oven-rotations
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'combine-oven-rotations'),
    'ko',
    $$오븐 로테이션 합치기$$,
    $$두 제빵사가 각각 자신의 오븐을 트레이 로테이션으로 운용합니다. 각 로테이션은 발효 시간 순(비내림차순)으로 정렬된 트레이 id의 연결 체인입니다. 아침 굽기 전에 수석 제빵사는 현장 팀이 하나의 대기열만 추적하면 되도록 두 로테이션을 발효 시간 순서가 유지된 하나의 마스터 체인으로 엮고자 합니다.

`combineOvenRotations(ovenA, ovenB)`를 구현하여 두 체인의 기존 트레이 노드를 하나의 정렬된 체인으로 이어 붙이고 그 헤드를 반환하세요.

**예시 1:**
```
Input: ovenA = [2,5,9], ovenB = [3,4,7]
Output: [2,3,4,5,7,9]
Explanation: The trays are interleaved by proof time into one rotation.
```

**예시 2:**
```
Input: ovenA = [], ovenB = []
Output: []
Explanation: Both ovens are idle.
```

**예시 3:**
```
Input: ovenA = [], ovenB = [3]
Output: [3]
Explanation: Only the second oven has a tray to bake.
```$$,
    $$- 각 로테이션의 트레이 수는 `[0, 60]` 범위입니다.
- `-100 <= Tray.val <= 100`
- `ovenA`와 `ovenB`는 모두 비내림차순으로 정렬되어 있습니다.$$
);

-- drop-tail-booking
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'drop-tail-booking'),
    'ko',
    $$말단 예약 취소$$,
    $$한 헬스장 예약 시스템은 하루 동안의 기구 예약을 접수 순서대로 연결 체인에 담아 둡니다. 회원은 체인의 **끝에서부터** 센 `n`번째 예약을 취소할 수 있습니다. 즉 `n = 1`은 가장 마지막 예약, `n = 2`는 그 앞 예약을 제거하는 식입니다.

`dropTailBooking(head, n)`을 구현하여 해당 예약 노드 하나를 체인에서 제거하고 갱신된 헤드를 반환하세요.

**예시 1:**
```
Input: head = [10,20,30,40,50,60], n = 3
Output: [10,20,30,50,60]
Explanation: Counting from the end, booking 40 is 3rd; after removing it the chain is 10 -> 20 -> 30 -> 50 -> 60.
```

**예시 2:**
```
Input: head = [7], n = 1
Output: []
Explanation: The only booking is cancelled, leaving the schedule empty.
```

**예시 3:**
```
Input: head = [4,9], n = 2
Output: [9]
Explanation: The 2nd from the end is the very first booking, so it is dropped.
```$$,
    $$- 체인에 있는 예약 수는 `sz`입니다.
- `1 <= sz <= 40`
- `0 <= Booking.val <= 100`
- `1 <= n <= sz`$$
);

-- interleave-trailer-cuts
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'interleave-trailer-cuts'),
    'ko',
    $$예고편 컷 교차 배치$$,
    $$한 예고편 편집자가 다가오는 티저용 샷 리스트를 연결 체인 `S0 -> S1 -> ... -> Sn-1 -> Sn`로 배치했습니다. 헤드에는 오프닝 장면들이, 꼬리에는 클로징 장면들이 있습니다. 감독은 최종 컷에서 초반부와 후반부 샷이 **교차로** 나오도록 하여, 피날레의 한 장면마다 초반부 설정으로 감싸이길 원합니다. 즉, 체인을 제자리에서 다음과 같이 재배치해야 합니다:

`S0 -> Sn -> S1 -> Sn-1 -> S2 -> Sn-2 -> ...`

`interleaveTrailerCuts(head)`를 구현하여 노드의 연결을 재배선해 체인이 이러한 지그재그 순서를 갖도록 하세요. 어떤 노드에 저장된 값도 수정해서는 안 되며, `next` 포인터만 변경할 수 있습니다.

**예시 1:**
```
Input: head = [10,20,30,40,50,60]
Output: [10,60,20,50,30,40]
Explanation: Front and back shots are woven together: opening 10, closing 60, second 20, second-to-last 50, and so on.
```

**예시 2:**
```
Input: head = [1,3,5,7,9,11,13]
Output: [1,13,3,11,5,9,7]
Explanation: With an odd length the middle shot ends the cut alone.
```$$,
    $$- 체인의 샷 수는 `[1, 8 * 10^4]` 범위입니다.
- `1 <= Shot.val <= 1000`$$
);

-- flip-sorter-segments
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'flip-sorter-segments'),
    'ko',
    $$분류기 구간 뒤집기$$,
    $$한 재활용 공장은 자재 배치를 분류 라인으로 보내는 과정을 스테이션 코드의 연결 체인으로 표현합니다. 분류기 간 부하를 균형 있게 분배하기 위해, 교대 조장은 길이 `k`의 연속 구간을 제자리에서 **양 끝이 뒤집히도록** 반전하려 합니다. `k`보다 짧은 말단 자투리 구간은 그대로 둡니다.

`flipSorterSegments(head, k)`를 구현하여 노드의 연결을 `k`개씩 뒤집고 재배치된 체인의 헤드를 반환하세요. 노드 내부의 값은 변경해서는 안 되며, `next` 포인터만 재배선할 수 있습니다.

**예시 1:**
```
Input: head = [10,20,30,40,50,60,70], k = 3
Output: [30,20,10,60,50,40,70]
Explanation: The first run (10,20,30) flips to (30,20,10); the next run (40,50,60) flips to (60,50,40); the trailing 70 stands alone.
```

**예시 2:**
```
Input: head = [5,15,25,35], k = 4
Output: [35,25,15,5]
Explanation: Exactly one run of length 4 is reversed in full.
```

**예시 3:**
```
Input: head = [2,4,6,8,10], k = 1
Output: [2,4,6,8,10]
Explanation: With k = 1 each run is a single station, so the chain is unchanged.
```$$,
    $$- 체인의 스테이션 수는 `n`입니다.
- `1 <= k <= n <= 6000`
- `0 <= Station.val <= 1000`$$
);

-- rewind-conveyor-chain
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'rewind-conveyor-chain'),
    'ko',
    $$컨베이어 체인 되감기$$,
    $$한 제조 라인은 현재 부품이 흐르는 방향의 스테이션 id 연결 체인으로 모델링됩니다. 야간 근무 엔지니어들은 유지보수 전에 버퍼를 비우기 위해 라인을 역방향으로 돌려야 합니다. 즉 같은 스테이션 노드를 재사용하면서 체인 전체를 뒤집어 기존 꼬리가 새로운 헤드가 되도록 해야 합니다.

`rewindConveyorChain(head)`를 구현하여 `next` 포인터를 재배선해 체인을 제자리에서 뒤집고, 뒤집힌 체인의 헤드를 반환하세요.

**예시 1:**
```
Input: head = [8,3,12,5,9]
Output: [9,5,12,3,8]
Explanation: The line flips so station 9 is now first and station 8 is last.
```

**예시 2:**
```
Input: head = [4,7]
Output: [7,4]
Explanation: A two-station chain swaps direction.
```

**예시 3:**
```
Input: head = []
Output: []
Explanation: An empty line has nothing to rewind.
```$$,
    $$- 체인의 스테이션 수는 `[0, 6000]` 범위입니다.
- `-6000 <= Station.val <= 6000`$$
);

-- swap-queue-partners
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'swap-queue-partners'),
    'ko',
    $$대기열 파트너 교환$$,
    $$한 인쇄소의 단일 프린터 대기열은 제출 순서대로 나열된 작업 id의 연결 체인으로 관리됩니다. 인쇄소 주인은 매주 "공평 교환"을 진행합니다. 대기열에서 인접한 두 작업끼리 자리를 바꿔 각 쌍의 두 번째 작업이 먼저 오도록 합니다. 대기열 길이가 홀수라면 마지막 외톨이 작업은 원래 자리에 그대로 남습니다.

`swapQueuePartners(head)`를 구현하여 `next` 포인터를 재배선해 인접한 모든 쌍을 교환하고 새로운 헤드를 반환하세요. 노드에 저장된 작업 id는 변경해서는 안 되며, 연결만 바뀔 수 있습니다.

**예시 1:**
```
Input: head = [11,22,33,44]
Output: [22,11,44,33]
Explanation: Pairs (11,22) and (33,44) trade places.
```

**예시 2:**
```
Input: head = [8,3]
Output: [3,8]
Explanation: The single pair is swapped.
```

**예시 3:**
```
Input: head = [6,9,15]
Output: [9,6,15]
Explanation: The first pair swaps; job 15 has no partner and keeps its spot.
```$$,
    $$- `0 <= 작업 수 <= 120`
- `0 <= Job.val <= 100`$$
);

-- label-lane-scans
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'label-lane-scans'),
    'ko',
    $$계산대 스캔 라벨 붙이기$$,
    $$한 슈퍼마켓에서 캐셔 교육용으로 하루의 첫 `n`개 계산대 스캔에 대한 라벨을 인쇄해 리듬을 낭독할 수 있게 하려고 합니다. 양의 정수 `n`이 주어질 때, `1`부터 `n`까지 각 스캔 인덱스에 대해 다음 규칙으로 라벨을 구한 리스트를 반환하세요.

- 인덱스가 3과 5 모두로 나누어지면 라벨은 `"FizzBuzz"`입니다.
- 인덱스가 3으로만 나누어지면 라벨은 `"Fizz"`입니다.
- 인덱스가 5로만 나누어지면 라벨은 `"Buzz"`입니다.
- 그 외에는 라벨이 인덱스를 10진수 문자열로 쓴 값입니다.

결과 라벨 리스트를 순서대로 반환하세요.

**예시 1:**
```
Input: n = 4
Output: ["1","2","Fizz","4"]
```

**예시 2:**
```
Input: n = 6
Output: ["1","2","Fizz","4","Buzz","Fizz"]
```$$,
    $$- `1 <= n <= 15000`$$
);

-- bump-parcel-code
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'bump-parcel-code'),
    'ko',
    $$택배 번호 증가$$,
    $$우편물 분류기는 각 택배에 순차적으로 증가하는 일련번호를 찍으며, 이 번호는 10진수 자릿수 배열로 저장되고 `digits[0]`이 최상위 자릿수입니다. 다음 택배가 도착하면 분류기는 번호를 1 증가시키고, 자리 올림을 올바르게 전파하여(예를 들어 `9,9`는 `1,0,0`으로 넘어가도록) 새로운 자릿수 배열을 출력해야 합니다.

입력은 전체 코드가 0인 경우(`[0]`으로 표현)를 제외하면 절대 선행 0을 포함하지 않습니다. 1이 증가된 번호를 자릿수 배열로 반환합니다.

**예시 1:**
```
Input: digits = [4,5,6]
Output: [4,5,7]
Explanation: 456 + 1 = 457.
```

**예시 2:**
```
Input: digits = [2,9,9]
Output: [3,0,0]
Explanation: 299 + 1 = 300, which keeps the same length but rewrites the trailing digits.
```$$,
    $$- `1 <= digits.length <= 100`
- `0 <= digits[i] <= 9`
- 입력 배열은 코드 `0` 자체를 제외하면 선행 0을 포함하지 않습니다$$
);

-- calm-sensor-reading
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'calm-sensor-reading'),
    'ko',
    $$안정된 센서 판독값$$,
    $$스마트홈 허브는 센서 판독 ID를 알림 채널로 라우팅하기 전에 **안정(calm)** 여부를 분류합니다. 양의 정수 `reading`이 주어지면, 해당 값을 각 10진 자릿수의 제곱의 합으로 반복해서 치환합니다. 이 과정이 결국 `1`에 도달하면 판독값은 안정된 것이고, `1`에 영원히 도달하지 못하고 무한 순환에 빠지면 안정되지 않은 것입니다.

`reading`이 안정되어 있으면 `true`를, 그렇지 않으면 `false`를 반환합니다.

**예시 1:**
```
Input: reading = 7
Output: true
Explanation: 7 -> 49 -> 97 -> 130 -> 10 -> 1.
```

**예시 2:**
```
Input: reading = 4
Output: false
Explanation: 4 -> 16 -> 37 -> 58 -> 89 -> 145 -> 42 -> 20 -> 4, a cycle that never hits 1.
```$$,
    $$- `1 <= reading <= 2 * 10^8`$$
);

-- reversible-call-number
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'reversible-call-number'),
    'ko',
    $$뒤집어도 같은 청구 기호$$,
    $$도서관 분관 사서는 청구 기호의 10진 자릿수가 왼쪽에서 오른쪽으로 읽든 오른쪽에서 왼쪽으로 읽든 동일할 때 이를 **뒤집을 수 있는(reversible)** 기호로 표시하며, 이는 책꽂이에서 쉽게 식별하기 위함입니다. 정수 `code`가 주어질 때, `code`가 앞뒤로 동일하게 읽히면 `true`를, 그렇지 않으면 `false`를 반환합니다.

음수 `code`는 자동으로 뒤집을 수 없는 것으로 처리되는데, 이는 선행 마이너스 기호에 대응되는 기호가 자릿수의 오른쪽 끝에 존재하지 않기 때문입니다.

**예시 1:**
```
Input: code = 929
Output: true
Explanation: 929 reversed is still 929.
```

**예시 2:**
```
Input: code = 20
Output: false
Explanation: 20 reversed reads 02, which does not match 20.
```$$,
    $$- `-2 * 10^8 <= code <= 2 * 10^8`$$
);

-- decode-zone-numeral
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'decode-zone-numeral'),
    'ko',
    $$구역 번호 해독$$,
    $$테마파크는 손목밴드 입장권에 놀이기구 구역 번호를 로마자 표기법으로 인코딩하며, 출입구 소프트웨어는 손목밴드의 숫자 문자열을 다시 정수 구역 ID로 변환해야 합니다. 기호 매핑은 일반적인 방식을 따릅니다:

- `I` = 1, `V` = 5, `X` = 10, `L` = 50, `C` = 100, `D` = 500, `M` = 1000

기호는 일반적으로 왼쪽에서 오른쪽으로 큰 값부터 작은 값 순서로 배치됩니다. 작은 기호가 엄밀히 더 큰 기호 바로 앞에 나타나면 그 쌍은 뺄셈을 의미합니다(`IV` = 4, `IX` = 9). 유효한 뺄셈 쌍은 `IV`, `IX`, `XL`, `XC`, `CD`, `CM`의 여섯 가지입니다.

숫자 문자열 `numeral`이 주어지면 그 정수 값을 반환합니다.

**예시 1:**
```
Input: numeral = "XIV"
Output: 14
Explanation: X + IV = 10 + 4 = 14.
```

**예시 2:**
```
Input: numeral = "CDXLII"
Output: 442
Explanation: CD + XL + II = 400 + 40 + 2 = 442.
```$$,
    $$- `1 <= numeral.length <= 15`
- `numeral`은 `I`, `V`, `X`, `L`, `C`, `D`, `M` 문자만 포함합니다
- `numeral`은 `[1, 3999]` 범위의 유효한 로마 숫자임이 보장됩니다$$
);

-- forecast-step-factor
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'forecast-step-factor'),
    'ko',
    $$예보 변화 계수$$,
    $$기상 관측소는 한 시간 단위 관측값 사이의 온도 변화를 단일 스칼라 `base`로 모델링하며, 이 값을 정수 거듭제곱 `step`으로 올리면 `step`시간 후의 예상 변화 계수가 됩니다. 부동소수점 밑 `base`와 정수 지수 `step`이 주어지면, `base`의 `step`제곱을 계산합니다.

`step`이 음수인 경우 계수는 `1 / base^|step|`이 됩니다(예를 들어 `2.0^-3 = 0.125`). `step`의 절댓값이 매우 커질 수 있기 때문에, 단순히 `|step|`번 반복 곱하는 방식은 숨겨진 테스트에서 시간 초과가 발생합니다.

결과를 소수점 다섯 자리로 반올림하여 반환합니다.

**예시 1:**
```
Input: base = 3.00000, step = 4
Output: 81.00000
```

**예시 2:**
```
Input: base = 2.00000, step = -3
Output: 0.12500
Explanation: 2.0^-3 = 1 / (2.0^3) = 1/8 = 0.125.
```$$,
    $$- `-100.0 < base < 100.0`
- `-2 * 10^8 <= step <= 2 * 10^8`
- `step`은 정수입니다
- `base`가 0이 아니거나 `step > 0` 중 적어도 하나가 성립합니다
- `|base^step| <= 8 * 10^4`$$
);

-- outward-shelf-walk
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'outward-shelf-walk'),
    'ko',
    $$선반 나선 순회$$,
    $$창고의 피커는 직사각형 구획의 좌측 상단 선반에서 출발하여 바깥쪽 나선 형태로 통로를 돕니다. 맨 위 행을 따라 가로지르고, 가장 오른쪽 열을 따라 내려가고, 맨 아래 행을 따라 되돌아오고, 가장 왼쪽 열을 따라 올라간 다음 안쪽으로 들어가 이 과정을 반복합니다. 각 셀에 해당 선반의 SKU 수량이 담긴 `m x n` 그리드 `bay`가 주어지면, 피커가 방문하는 순서대로 SKU 수량을 반환합니다.

피커는 각 선반을 정확히 한 번씩 방문합니다.

**예시 1:**
```
Input: bay = [[1,2],[3,4]]
Output: [1,2,4,3]
```

**예시 2:**
```
Input: bay = [[5,6,7],[8,9,10],[11,12,13],[14,15,16]]
Output: [5,6,7,10,13,16,15,14,11,8,9,12]
```$$,
    $$- `m == bay.length`
- `n == bay[i].length`
- `1 <= m, n <= 10`
- `-100 <= bay[i][j] <= 100`$$
);

-- product-as-text
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'product-as-text'),
    'ko',
    $$문자열로 표현된 곱셈$$,
    $$영화 제작 예산 도구는 두 개의 음이 아닌 항목 금액을 10진 자릿수 문자열 `left`와 `right`로 저장하는데, 이는 금액이 네이티브 정수 타입의 범위를 넘어갈 수 있기 때문입니다. 이 도구는 두 값을 곱한 뒤 결과를 10진 문자열로 출력해야 합니다.

어느 피연산자도 숫자 타입으로 캐스팅할 수 없고, 빅 인티저 라이브러리를 사용할 수 없으며, 임의 길이 수를 위한 내장 곱셈 보조 함수도 사용할 수 없습니다. 대신 손으로 계산할 때처럼 자릿수 단위로 긴 곱셈을 직접 시뮬레이션해야 합니다.

**예시 1:**
```
Input: left = "12", right = "34"
Output: "408"
```

**예시 2:**
```
Input: left = "25", right = "13"
Output: "325"
```$$,
    $$- `1 <= left.length, right.length <= 200`
- `left`와 `right`는 10진 자릿수만 포함합니다
- `left`와 `right` 모두 값 `0` 자체인 경우를 제외하면 선행 0을 포함하지 않습니다$$
);

-- clear-defect-rows
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'clear-defect-rows'),
    'ko',
    $$결함 행 정리$$,
    $$제조 QA 대시보드는 `m x n` 정수 그리드 `board`에 결함 수를 추적하며, 각 셀은 한 검사 지점에서 표시된 결함 수를 의미합니다. 특정 셀이 정확히 `0`인 경우, 라인 작업자는 해당 **행과 열 전체**를 정리된 상태(`0`으로 설정)로 표시하여 그 지점 주변의 잡음을 다운스트림 뷰에서 숨기려 합니다.

원래 0이었던 셀과 같은 행이나 열에 있는 모든 셀이 `0`이 되도록 `board`를 **제자리에서(in-place)** 재작성합니다. 그런 행이나 열에 속하지 않는 셀은 원래 값을 유지합니다.

**예시 1:**
```
Input: board = [[2,3],[4,5]]
Output: [[2,3],[4,5]]
Explanation: No zero cells exist, so the board is unchanged.
```

**예시 2:**
```
Input: board = [[4,6,8],[2,0,5],[7,9,3]]
Output: [[4,0,8],[0,0,0],[7,0,3]]
Explanation: The zero sits at row 1, column 1, so row 1 and column 1 are cleared.
```$$,
    $$- `m == board.length`
- `n == board[0].length`
- `1 <= m, n <= 200`
- `|board[i][j]| <= 10^8`$$
);

-- longest-clean-run
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'longest-clean-run'),
    'ko',
    $$가장 긴 단일 구간$$,
    $$단일 스트림 재활용 컨베이어가 혼합된 품목들을 광학 분류기 앞으로 운반합니다. 배열 `stream`이 주어지며, `stream[i]`는 지나가는 `i`번째 품목의 재질 코드입니다. 하류의 베일러는 한 번 처리할 때 **최대 두 가지 재질 코드**만 포함한 연속 구간만 소화할 수 있으며, 그 이상이면 비우고 리셋해야 합니다.

`longestCleanRun`을 구현하여 `stream`에서 서로 다른 재질 코드가 두 개 이하로 이루어진 가장 긴 연속 구간의 길이를 반환합니다.

**예시 1:**
```
Input: stream = [4,4,7,4,7,2,7,2,2]
Output: 5
Explanation: The stretch [7,2,7,2,2] at the end uses only codes 7 and 2 and has length 5. The opening stretch [4,4,7,4,7] also has length 5 using codes 4 and 7.
```

**예시 2:**
```
Input: stream = [9,9,9]
Output: 3
Explanation: Every piece shares the same material code, so the entire conveyor is one clean run.
```

**예시 3:**
```
Input: stream = [1,5,1,5,1,5]
Output: 6
Explanation: The whole conveyor alternates between only two codes, so the longest clean run spans everything.
```$$,
    $$- `1 <= stream.length <= 2 * 10^5`
- `0 <= stream[i] < stream.length`$$
);

-- shortest-bake-span
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'shortest-bake-span'),
    'ko',
    $$최단 베이킹 구간$$,
    $$베이커리의 데크 오븐은 트레이들이 일렬 큐로 운영됩니다. 배열 `trays`는 오븐 순서대로 각 트레이가 산출할 예정인 빵 덩어리 수를 나열하며, `target`은 아침 배송에 필요한 최소 빵 수입니다. 제빵사들은 합산 산출량이 `target` 이상인 **연속된 트레이 구간**을 선택하되, 오븐을 빠르게 비울 수 있도록 그 구간이 가능한 한 짧기를 원합니다.

`shortestBakeSpan`을 구현하여 합이 `target` 이상인 `trays`의 가장 짧은 연속 구간 길이를 반환합니다. 주문을 충족하는 구간이 없으면 `0`을 반환합니다.

**예시 1:**
```
Input: trays = [3,1,4,1,5,9,2,6], target = 15
Output: 3
Explanation: The span [1,5,9] already sums to 15, and no shorter span reaches the target.
```

**예시 2:**
```
Input: trays = [2,2,2], target = 10
Output: 0
Explanation: The full oven only yields 6 loaves, well short of the order.
```

**예시 3:**
```
Input: trays = [8,3,2], target = 8
Output: 1
Explanation: The very first tray already meets the target on its own.
```$$,
    $$- `1 <= trays.length <= 2 * 10^5`
- `1 <= trays[i] <= 8000`
- `1 <= target <= 10^8`$$
);

-- shortest-shelf-span
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'shortest-shelf-span'),
    'ko',
    $$최소 진열 구간$$,
    $$참고도서 사서가 길게 늘어선 청구기호 라벨들을 바라보며, 전시에 필요한 모든 글자 태그를 함께 담고 있는 연속된 서가 구간을 골라내야 합니다. 진열 순서대로 한 권당 한 글자를 나타낸 서가 문자열 `shelf`와, 전시가 요구하는 글자 태그들을 나열한 요건 문자열 `needed`가 주어집니다. 이때 **중복까지 포함해서** 맞춰야 합니다 — 예를 들어 `needed`에 `'O'` 태그가 두 개 있다면, 구간은 최소 두 권의 `'O'` 태그 도서를 포함해야 합니다.

`needed`에 있는 모든 글자 태그를(중복 포함) 덮는 `shelf`의 최단 연속 부분 문자열을 반환하는 `shortestShelfSpan`을 구현하세요. 그러한 구간이 존재하지 않으면 빈 문자열 `""`를 반환합니다. 길이가 같은 구간이 여러 개라면 가장 먼저 시작하는 구간을 반환합니다.

**예시 1:**
```
Input: shelf = "FINDTHEBOOKSNOW", needed = "BOK"
Output: "BOOK"
Explanation: The span "BOOK" contains a 'B', an 'O', and a 'K', and no shorter span covers all three tags.
```

**예시 2:**
```
Input: shelf = "XY", needed = "Y"
Output: "Y"
Explanation: The single volume tagged 'Y' already covers the requirement.
```

**예시 3:**
```
Input: shelf = "Q", needed = "QQ"
Output: ""
Explanation: The requirement asks for two 'Q'-tagged volumes, but the shelf only holds one.
```$$,
    $$- `m == shelf.length`
- `n == needed.length`
- `1 <= m, n <= 2 * 10^5`
- `shelf`와 `needed`는 영어 대소문자로만 구성됩니다.$$
);

-- peak-temp-swing
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'peak-temp-swing'),
    'ko',
    $$최대 기온 상승폭$$,
    $$기상관측소가 폭풍이 지나가는 동안 시간당 외부 기온을 기록했고, 분석가는 가장 큰 상승폭 — 즉 `i < j`를 만족하는 `readings[j] - readings[i]`의 최댓값 — 을 알고 싶어합니다. 이는 폭풍 구간에서 이전의 저점에서 이후의 고점까지 기온이 얼마나 치솟았는지를 나타냅니다.

배열 `readings`에서 그러한 양의 상승폭의 최댓값을 반환하는 `maxTempSwing`을 구현하세요. 앞선 어떤 지점에서 뒤쪽 지점으로 기온이 한 번도 오르지 않는다면 `0`을 반환합니다.

**예시 1:**
```
Input: readings = [14,9,11,8,12,15,10]
Output: 7
Explanation: The low at index 3 (reading 8) is followed by a high at index 5 (reading 15), a swing of 7.
```

**예시 2:**
```
Input: readings = [20,18,15,11]
Output: 0
Explanation: Temperatures only fall through the log, so no upward swing exists.
```$$,
    $$- `1 <= readings.length <= 2 * 10^5`
- `0 <= readings[i] <= 8000`$$
);

-- zone-code-anagram
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'zone-code-anagram'),
    'ko',
    $$구역 코드 아나그램$$,
    $$우편물 분류 담당자가 스캔되는 구역 코드 스트림을 지켜보면서, 탐색 대상인 `pattern`이 더 긴 스캔 로그 `log` 안에서 **연속 재배열** 형태로 어디든 등장하는지 알고자 합니다. 구체적으로는 `pattern`의 문자들을 임의로 재배열한 것이 `log`의 연속 부분 문자열로 나타나는지 판정하는 문제입니다.

그러한 부분 문자열이 존재하면 `true`, 아니면 `false`를 반환하는 `matchesZoneAnagram`을 구현하세요.

**예시 1:**
```
Input: pattern = "ab", log = "ccbazz"
Output: true
Explanation: The substring "ba" inside log is a reordering of pattern.
```

**예시 2:**
```
Input: pattern = "rp", log = "mailpirzone"
Output: false
Explanation: No length-two substring of log uses one 'r' and one 'p'.
```$$,
    $$- `1 <= pattern.length, log.length <= 8000`
- `pattern`과 `log`는 영어 소문자로만 구성됩니다.$$
);

-- longest-fresh-feed
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'longest-fresh-feed'),
    'ko',
    $$최장 신선 피드$$,
    $$뉴스 애그리게이터는 들어오는 각 헤드라인에 한 글자짜리 주제 코드를 태깅해 긴 문자열 `feed`를 만들어냅니다. 편집자는 **어떤 주제도 중복되지 않는** 가장 긴 연속 헤드라인 구간을 알고 싶어합니다 — 그 구간이 길수록 보도가 그만큼 다양하다는 뜻이기 때문입니다.

모든 문자가 서로 다른 `feed`의 최장 연속 부분 문자열의 길이를 반환하는 `longestFreshFeed`를 구현하세요.

**예시 1:**
```
Input: feed = "finance"
Output: 4
Explanation: The substring "ance" uses four distinct topic codes; no longer distinct run exists.
```

**예시 2:**
```
Input: feed = "zzzz"
Output: 1
Explanation: Every headline carries the same topic, so only length-one runs are distinct.
```

**예시 3:**
```
Input: feed = "xxxyz"
Output: 3
Explanation: The tail "xyz" uses three distinct topic codes.
```$$,
    $$- `0 <= feed.length <= 8 * 10^4`
- `feed`는 영문자, 숫자, 기호, 공백으로 구성됩니다.$$
);

-- peak-flow-stretch
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'peak-flow-stretch'),
    'ko',
    $$구간별 최대 교통량$$,
    $$교통 엔지니어가 선형 도로 구간을 분석합니다. 배열 `flow`에는 연속된 교차로들에서 측정한 분당 차량 수가 기록되어 있고, `k`는 아침 보고서에 사용되는 슬라이딩 리뷰 윈도의 폭입니다. `k`개의 교차로로 이루어진 윈도가 구간의 시작부터 끝까지 한 칸씩 이동할 때, 엔지니어는 각 윈도 내부의 최대 교통량을 모두 구하고자 합니다.

`i`번째 원소가 `flow[i..i+k-1]`의 최댓값인 정수 배열을 반환하는 `peakFlowPerStretch`를 구현하세요.

**예시 1:**
```
Input: flow = [4,2,8,5,1,7,9,3], k = 4
Output: [8,8,8,9,9]
Explanation:
Window                         Peak
[4  2  8  5]  1  7  9  3        8
 4 [2  8  5  1] 7  9  3         8
 4  2 [8  5  1  7] 9  3         8
 4  2  8 [5  1  7  9] 3         9
 4  2  8  5 [1  7  9  3]        9
```

**예시 2:**
```
Input: flow = [6,6,6], k = 2
Output: [6,6]
Explanation: Every window of two intersections reports the same peak flow.
```$$,
    $$- `1 <= flow.length <= 2 * 10^5`
- `-8000 <= flow[i] <= 8000`
- `1 <= k <= flow.length`$$
);

-- verify-job-nesting
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'verify-job-nesting'),
    'ko',
    $$인쇄 작업 중첩 검증$$,
    $$인쇄소는 `(`, `)`, `[`, `]`, `{`, `}`라는 열기/닫기 표시를 사용해 중첩된 인쇄 작업 그룹을 관리합니다. 그룹이 유효하려면 모든 열기 기호가 같은 종류의 닫기 기호로 닫혀야 하고 중첩 순서도 올바라야 합니다 — 바깥쪽 그룹은 안쪽 그룹이 끝나기 전에 먼저 닫힐 수 없습니다.

위 여섯 가지 문자만으로 이루어진 문자열 `jobTape`이 주어질 때, 이 테이프가 인쇄 작업 그룹의 유효한 중첩 구조를 나타내면 `true`를, 아니면 `false`를 반환합니다. 제약 조건상 빈 테이프는 입력으로 들어오지 않습니다.

**예시 1:**
```
Input: jobTape = "{[()]}"
Output: true
Explanation: Each opener is closed by the matching type in the correct nested order.
```

**예시 2:**
```
Input: jobTape = "{[(])}"
Output: false
Explanation: The `(` is closed by `]` before its matching `)`, breaking the nesting.
```$$,
    $$- `1 <= jobTape.length <= 2 * 10^3`
- `jobTape`은 오직 문자 `'('`, `')'`, `'['`, `']'`, `'{'`, `'}'`로만 구성됩니다.$$
);

-- group-train-packs
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'group-train-packs'),
    'ko',
    $$열차 그룹 묶기$$,
    $$단선 지하철 노선이 킬로미터 지점 `terminal`에 있는 종착역을 향해 운행합니다. 현재 노선 위에는 `n`대의 열차가 있으며, `launchKm[i]`는 `i`번째 열차의 출발 킬로미터 지점이고 `cruiseSpeed[i]`는 그 열차의 순항 속도(km/h)입니다. 뒤따라오는 더 빠른 열차는 앞의 느린 열차를 추월할 수 없습니다 — 따라잡게 되면 뒤쪽에 붙어 같은 속도로 운행해야 합니다. 하나 이상의 열차가 선두 열차의 속도에 맞춰 함께 움직이는 집합을 **팩(pack)**이라고 합니다.

`terminal`, `launchKm`, `cruiseSpeed`가 주어졌을 때 종착역에 도달하는 팩의 개수를 반환합니다.

**예시 1:**
```
Input: terminal = 20, launchKm = [0,3,7,14], cruiseSpeed = [5,3,2,1]
Output: 2
Explanation: The train at km 14 reaches the terminal alone (6h). The trains at km 7, 3, and 0 each catch up with the km-7 train before it reaches the terminal, forming a second pack.
```

**예시 2:**
```
Input: terminal = 15, launchKm = [5], cruiseSpeed = [2]
Output: 1
```$$,
    $$- `n == launchKm.length == cruiseSpeed.length`
- `1 <= n <= 2 * 10^5`
- `0 <= launchKm[i] < terminal <= 10^8`
- `1 <= cruiseSpeed[i] <= 2 * 10^5`
- `launchKm`의 모든 값은 서로 다릅니다.$$
);

-- list-slate-sequences
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'list-slate-sequences'),
    'ko',
    $$슬레이트 시퀀스 나열$$,
    $$촬영팀은 매 테이크마다 슬레이트(`slate`)와 컷(`cut`) 한 쌍을 각각 `(`와 `)`로 기록합니다. `pairCount`개의 쌍으로 이루어진 리허설 로그에 대해, 조감독은 올바르게 중첩된 — 모든 `(`가 언젠가 대응되는 `)`로 닫히고, 대응되는 `(` 이전에 `)`가 등장하지 않는 — 모든 슬레이트/컷 배치를 나열해야 합니다.

정수 `pairCount`가 주어질 때 그러한 모든 올바른 형식의 시퀀스를 반환합니다. 반환된 리스트의 순서는 중요하지 않습니다 — 채점기는 비교 전에 결과를 사전순으로 정렬합니다.

**예시 1:**
```
Input: pairCount = 2
Output: ["(())","()()"]
Explanation: The two valid slate/cut layouts using two pairs.
```

**예시 2:**
```
Input: pairCount = 4
Output: ["(((())))","((()()))","((())())","((()))()","(()(()))","(()()())","(()())()","(())(())","(())()()","()((()))","()(()())","()(())()","()()(())","()()()()"]
```$$,
    $$- `1 <= pairCount <= 9`$$
);

-- fold-bale-ops
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'fold-bale-ops'),
    'ko',
    $$압축 더미 연산 접기$$,
    $$재활용 공장은 후위 표기법 병합 연산을 통해 압축 더미(베일)의 무게를 계산합니다. 제어 테이프는 토큰 배열 `baleTape`이며, 각 토큰은 부호 있는 정수(kg 단위의 베일 무게)이거나 `+`, `-`, `*`, `/` 중 하나의 연산자입니다. 각 연산자는 작업 스택의 상위 두 값을 꺼내 결합한 뒤 결과를 다시 스택에 넣습니다.

나눗셈은 0쪽으로 버림합니다. 테이프는 최종 평가 결과 스택에 정확히 숫자 하나만 남는 유효한 후위 표기식이며, 0으로 나누는 경우는 없음이 보장됩니다. 그 최종 정수를 반환하세요.

**예시 1:**
```
Input: baleTape = ["5","3","-","2","*"]
Output: 4
Explanation: (5 - 3) * 2 = 4.
```

**예시 2:**
```
Input: baleTape = ["8","2","/","7","+","3","*"]
Output: 33
Explanation: ((8 / 2) + 7) * 3 = 33.
```$$,
    $$- `1 <= baleTape.length <= 2 * 10^3`
- `baleTape[i]`는 `{"+", "-", "*", "/"}` 중 하나의 연산자이거나 `|baleTape[i]| <= 250`인 부호 있는 정수입니다.$$
);

-- resolve-lane-crashes
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'resolve-lane-crashes'),
    'ko',
    $$차선 충돌 정리$$,
    $$교통 격자의 단일 차선에 자율주행 셔틀들이 일렬로 늘어서 동시에 출발합니다. 배열 `shuttles`는 각 차량의 부호 있는 질량을 나타냅니다: 절댓값은 질량이고 부호는 방향으로, 양수는 오른쪽으로, 음수는 왼쪽으로 주행합니다. 같은 방향으로 움직이는 셔틀들은 결코 충돌하지 않습니다. 오른쪽으로 가는 셔틀과 왼쪽으로 가는 셔틀이 만나면 가벼운 쪽이 파괴되고 무거운 쪽이 계속 진행합니다. 두 셔틀의 질량이 같다면 둘 다 파괴됩니다.

가능한 모든 충돌이 해소된 뒤 차선에 남아 있는 셔틀 배열을 원래의 왼쪽에서 오른쪽 순서대로 반환합니다.

**예시 1:**
```
Input: shuttles = [3,7,-8]
Output: [-8]
Explanation: The -8 meets 7 and destroys it, then meets 3 and destroys it as well, leaving only -8.
```

**예시 2:**
```
Input: shuttles = [-3,4,-4,2]
Output: [-3,2]
Explanation: 4 and -4 collide and both are destroyed; -3 and 2 never meet anything going the opposite way.
```$$,
    $$- `2 <= shuttles.length <= 2 * 10^3`
- `-1200 <= shuttles[i] <= 1200`
- `shuttles[i] != 0`$$
);

-- widest-vine-block
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'widest-vine-block'),
    'ko',
    $$가장 넓은 포도나무 구간$$,
    $$포도밭의 한 구역은 폭이 모두 `1`로 동일한 포도나무들이 한 줄로 늘어선 형태로 구성되어 있습니다. 배열 `canopy`에는 각 포도나무의 수관(잎 덮개) 높이가 순서대로 기록되어 있습니다. 재배자는 연속된 포도나무들의 구간 위에 하나의 직사각형 차양막을 팽팽하게 덮으려고 합니다. 차양막은 덮는 포도나무들 중 어느 것보다도 위로 올라가지 않아야 하므로, 그 높이는 해당 구간에서 가장 낮은 수관 높이에 맞춰집니다.

차양막이 덮을 수 있는 최대 면적(높이 × 포도나무 개수)을 반환하세요.

**예시 1:**
```
Input: canopy = [3,1,4,5,2,3]
Output: 8
Explanation: The cloth covering vines at indices 2 and 3 uses height 4 and width 2 for area 8.
```

**예시 2:**
```
Input: canopy = [4,2,6,3,7,5,3]
Output: 15
Explanation: The cloth covering indices 2 through 6 uses height 3 and width 5 for area 15.
```$$,
    $$- `1 <= canopy.length <= 2 * 10^5`
- `0 <= canopy[i] <= 2 * 10^3`$$
);

-- days-to-upgrade
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'days-to-upgrade'),
    'ko',
    $$기온 상승까지의 대기 일수$$,
    $$어느 기상 관측소는 일별 최고 기온을 배열 `readings`에 날짜 순서대로 기록합니다. 기상학자들은 각 날짜마다 **엄격히 더 따뜻한** 기온이 기록되기까지 예보관이 며칠을 기다려야 하는지 알고 싶어 합니다.

같은 길이의 배열 `wait`을 반환하세요. 여기서 `wait[i]`는 `i`일 이후에 엄격히 더 따뜻한 기온이 처음 나타날 때까지의 일수입니다. 이후 날짜 중 더 따뜻한 기온이 없다면 `wait[i]`를 `0`으로 설정합니다.

**예시 1:**
```
Input: readings = [55,58,52,50,54,60]
Output: [1,4,2,1,1,0]
Explanation: Day 1 (58) is the next warmer day after day 0. Day 5 (60) is the next warmer day after day 1. No day is warmer than day 5.
```

**예시 2:**
```
Input: readings = [45,45,45,50]
Output: [3,2,1,0]
Explanation: Each of the first three days must wait for day 3 (50), which is the next strictly warmer reading.
```$$,
    $$- `1 <= readings.length <= 2 * 10^5`
- `30 <= readings[i] <= 110`$$
);

-- shared-assembly-lookup
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'shared-assembly-lookup'),
    'ko',
    $$공통 조립 단계 찾기$$,
    $$어느 창고는 자재 명세서(BOM)를 **이진 탐색 트리**로 관리하며, 각 노드 값은 그 단계의 SKU 번호를 나타냅니다. 노드의 왼쪽 서브트리에 속한 하위 조립은 모두 SKU가 더 작고, 오른쪽 서브트리에 속한 하위 조립은 모두 SKU가 더 큽니다. 이 BOM 트리의 `root`와 두 부품 `p`, `q`가 주어질 때, 두 부품을 모두 자신의 서브트리에 포함하는 가장 깊은 조립 단계를 반환하세요.

`findSharedAssembly(root, p, q)`를 구현하세요. 노드는 자기 자신의 자손으로도 간주되므로, 두 부품 중 하나가 다른 하나의 조상이라면 그 부품 자체를 반환합니다. `p`와 `q`는 트리에 반드시 존재하며 서로 다릅니다.

**예시 1:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 8, q = 12
Output: 10
Explanation: SKU 8 lives under the left branch of 10 (via 5), and SKU 12 lives under the right branch of 10 (via 15). 10 is the deepest assembly containing both.
```

**예시 2:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 25, q = 40
Output: 30
Explanation: Both parts sit in the right subtree of 20. Their lowest shared assembly is 30.
```

**예시 3:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 10, q = 15
Output: 10
Explanation: 15 lies beneath 10, so 10 is itself the shared assembly.
```$$,
    $$- BOM 트리의 노드 수는 `[2, 2 * 10^5]` 범위 내입니다.
- `-10^8 <= Node.val <= 10^8`
- 모든 SKU 값은 서로 다릅니다.
- `p != q`
- `p`와 `q`는 모두 트리에 존재합니다.$$
);

-- ward-priority-audit
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'ward-priority-audit'),
    'ko',
    $$병동 우선순위 감사$$,
    $$한 병원은 병동의 환자 우선순위 트리를 운영하며, 모든 담당 노드에 대해 왼쪽의 모든 환자는 **엄격히 더 낮은** 중증도 점수를 가지고 오른쪽의 모든 환자는 **엄격히 더 높은** 점수를 갖도록 관리합니다. 행정 담당자는 최근 개편으로 트리 어딘가에서 이 순서가 깨졌을지 모른다고 의심하여 빠르게 감사를 진행하려 합니다.

우선순위 트리의 `root`가 주어질 때, `verifyWardOrder(root)`를 구현하여 (직계 자식뿐 아니라 왼쪽 서브트리 전체와 오른쪽 서브트리 전체에 대해) 모든 노드에서 BST 불변식이 유지되면 `true`를, 그렇지 않으면 `false`를 반환하세요. 모든 중증도 점수는 서로 다릅니다.

**예시 1:**
```
Input: root = [50,30,70,20,40,60,80]
Output: true
Explanation: Every left subtree stays below its ancestor and every right subtree stays above. The ward ordering is consistent.
```

**예시 2:**
```
Input: root = [10,5,15,null,null,6,20]
Output: false
Explanation: 6 sits in the right subtree of root 10, but 6 < 10, so the invariant is violated.
```$$,
    $$- 트리의 노드 수는 `[1, 2 * 10^5]` 범위 내입니다.
- `-10^8 <= Node.val <= 10^8`
- 모든 중증도 점수는 서로 다릅니다.$$
);

-- assemble-script-breakdown
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'assemble-script-breakdown'),
    'ko',
    $$촬영 구성표 복원$$,
    $$한 영화 제작팀은 씬 구성표를 샷들의 이진 트리로 관리합니다. 아카이브 서버가 고장 났지만 두 개의 순회 로그가 남아 있습니다. 하나는 **전위 순회**(씬 → 왼쪽 가지 → 오른쪽 가지) 로그이고, 다른 하나는 **중위 순회**(왼쪽 가지 → 씬 → 오른쪽 가지) 로그입니다. 이 두 로그로부터 구성표를 복원해야 합니다.

동일한 샷 ID들을 각 순회 순서대로 담은 두 정수 배열 `preorder`와 `inorder`가 주어질 때, `assembleBreakdown(preorder, inorder)`를 구현하여 복원된 트리를 반환하세요. 모든 샷 ID는 서로 다르며, `preorder`의 모든 ID는 `inorder`에도 존재합니다.

**예시 1:**
```
Input: preorder = [10,5,3,7,20,15], inorder = [3,5,7,10,15,20]
Output: [10,5,20,3,7,15]
Explanation: 10 is the root. Inorder splits into [3,5,7] (left subtree) and [15,20] (right subtree). Recursing yields left = (5, left 3, right 7) and right = (20, left 15, right null).
```

**예시 2:**
```
Input: preorder = [42], inorder = [42]
Output: [42]
Explanation: A single shot becomes the entire tree.
```$$,
    $$- `1 <= preorder.length <= 2 * 10^3`
- `inorder.length == preorder.length`
- `-10^8 <= preorder[i], inorder[i] <= 10^8`
- 모든 샷 ID는 서로 다릅니다.
- `inorder`의 모든 값은 `preorder`에도 존재합니다.
- `preorder`는 해당 트리의 유효한 전위 순회입니다.
- `inorder`는 같은 트리의 유효한 중위 순회입니다.$$
);

-- unroll-flight-schedule
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'unroll-flight-schedule'),
    'ko',
    $$항공 스케줄 펼치기$$,
    $$어느 공항 운영 콘솔은 일일 항공사 계층 구조를 이진 트리로 저장하지만, 정비 팀은 이를 트리의 **전위 순회** 순서대로 오른쪽으로만 뻗는 하나의 타임라인으로 펼치길 원합니다. 기존 노드를 그대로 사용하여 **제자리(in-place)**에서 작업해야 합니다.

스케줄 트리의 `root`가 주어질 때, `unrollSchedule(root)`를 구현하세요. 호출 이후 모든 노드의 `left` 포인터는 `null`이어야 하고, `right` 포인터는 전위 순회 순서상 다음 노드를 가리켜야 합니다. 트리의 루트는 바뀌지 않으며 반환 타입은 `void`입니다. 채점기는 루트에서 오른쪽 포인터를 따라 이동하면서 트리를 검사합니다.

**예시 1:**
```
Input: root = [7,3,9,1,4,null,12]
Output: [7,3,1,4,9,12]
Explanation: Preorder of the input is 7, 3, 1, 4, 9, 12. After unrolling, each node links to the next via the right pointer and all left pointers are cleared.
```

**예시 2:**
```
Input: root = []
Output: []
```

**예시 3:**
```
Input: root = [5]
Output: [5]
```$$,
    $$- 스케줄 트리의 노드 수는 `[0, 2 * 10^3]` 범위 내입니다.
- `-10^8 <= Node.val <= 10^8`$$
);

-- tally-dominant-blocks
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'tally-dominant-blocks'),
    'ko',
    $$우세 블록 개수 세기$$,
    $$한 포도원은 매년의 블렌딩 트리를 보관하며, 각 노드 값은 해당 블록의 최종 수확량(kg)을 나타냅니다. 어떤 블록이 **우세(dominant)** 하다는 것은 빈티지 루트에서 그 블록까지의 경로상에 있는 어떤 조상도 수확량이 엄격히 더 크지 않은 경우, 즉 그 블록의 수확량이 상위의 모든 수확량 이상인 경우를 의미합니다. 빈티지 루트는 항상 우세합니다.

블렌딩 트리의 `root`가 주어질 때, `tallyDominantBlocks(root)`를 구현하여 트리에 있는 우세 블록의 개수를 반환하세요.

**예시 1:**
```
Input: root = [4,2,6,5,1,null,7]
Output: 4
Explanation: Block 4 (root) is dominant. 5 beats its max ancestor 4. 6 beats its max ancestor 4. 7 beats its max ancestor 6. Block 2 is overshadowed by 4, and block 1 is overshadowed by 4.
```

**예시 2:**
```
Input: root = [5,3,5,2,4]
Output: 2
Explanation: The root 5 is dominant. The right child 5 ties with its ancestor 5 and still counts. The left subtree blocks (3, 2, 4) are all overshadowed by the root.
```

**예시 3:**
```
Input: root = [7]
Output: 1
Explanation: A single block is always dominant.
```$$,
    $$- 트리의 노드 수는 `[1, 2 * 10^5]` 범위 내입니다.
- `-10^8 <= Node.val <= 10^8`$$
);

-- hub-evenness-check
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'hub-evenness-check'),
    'ko',
    $$허브 균형 점검$$,
    $$한 택배 네트워크는 물류센터 → 허브 → 배송 경로의 계층 구조를 이진 트리로 관리합니다. 배차 담당자는 허브 배치가 **고르게 적재**되었는지, 즉 모든 노드에서 왼쪽 서브트리와 오른쪽 서브트리의 높이 차이가 최대 1 이하인지 확인하고자 합니다. 빈 트리는 고르게 적재된 것으로 간주합니다.

허브 트리의 `root`가 주어질 때, `checkHubEvenness(root)`를 구현하여 계층 구조의 모든 서브트리가 이 깊이 균형 조건을 만족하면 `true`를, 어떤 노드의 좌우 서브트리 높이 차가 1을 초과하면 `false`를 반환하세요.

**예시 1:**
```
Input: root = [5,2,8,1,null,null,11]
Output: true
Explanation: Every node's left and right subtree heights differ by at most 1.
```

**예시 2:**
```
Input: root = [1,2,null,3,null,4]
Output: false
Explanation: The tree leans all the way left into a chain 1→2→3→4; the root's left subtree has height 3 while its right subtree has height 0.
```

**예시 3:**
```
Input: root = []
Output: true
Explanation: An empty hierarchy is considered evenly loaded by definition.
```$$,
    $$- 트리의 노드 수는 `[0, 2 * 10^3]` 범위 내입니다.
- `-10^8 <= Node.val <= 10^8`$$
);

-- matching-catalog-layouts
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'matching-catalog-layouts'),
    'ko',
    $$일치하는 도서 분류 체계$$,
    $$어느 분관 도서관과 중앙 도서관은 각자 듀이 십진식 분류 체계를 이진 트리로 관리하며, 각 노드 값은 해당 구획의 청구 기호입니다. 이관 감사에서는 두 분류 체계가 **동일**한지, 즉 모든 대응 노드에서 모양과 청구 기호가 모두 같은지를 확인해야 합니다.

두 분류 트리의 루트 `p`와 `q`가 주어질 때, `matchCatalogLayout(p, q)`를 구현하여 두 트리가 노드별로 (구조와 값 모두) 완벽히 대응되면 `true`를, 그렇지 않으면 `false`를 반환하세요. 어느 쪽 트리든 비어 있을 수 있습니다.

**예시 1:**
```
Input: p = [8,4,12], q = [8,4,12]
Output: true
Explanation: Both catalogs have identical shape and identical call numbers at every node.
```

**예시 2:**
```
Input: p = [3,5], q = [3,null,5]
Output: false
Explanation: In p the 5 hangs as a left child of 3. In q the 5 hangs as a right child. The shapes differ even though the multisets of values match.
```

**예시 3:**
```
Input: p = [6,2,9], q = [6,9,2]
Output: false
Explanation: The shapes match but the left and right call numbers are swapped, so the catalogs are not identical.
```$$,
    $$- 각 트리의 노드 수는 `[0, 2 * 10^3]` 범위 내입니다.
- `-10^8 <= Node.val <= 10^8`$$
);

-- nth-dimmest-target
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'nth-dimmest-target'),
    'ko',
    $$N번째로 어두운 관측 대상$$,
    $$야간 관측 카탈로그는 대상의 광도 등급(수치가 낮을수록 더 밝음)을 기준으로 하는 이진 탐색 트리로 구성됩니다. 관측소는 모든 대상을 하나의 루트 포인터 아래에 기록하므로, 트리를 중위 순회하면 가장 밝은 것부터 가장 어두운 것 순서대로 대상을 방문하게 됩니다.

카탈로그 트리의 `root`와 1부터 시작하는 순위 `k`가 주어질 때, `pickNthTarget`을 구현하여 카탈로그에서 `k`번째로 밝은 대상의 광도 등급을 반환하세요.

`k`는 `[1, n]` 범위 내라고 가정해도 되며, 여기서 `n`은 기록된 대상의 수입니다.

**예시 1:**
```
Input: root = [8,4,12,2,6,10,14], k = 4
Output: 8
Explanation: In-order traversal yields magnitudes [2,4,6,8,10,12,14]. The 4th entry is 8.
```

**예시 2:**
```
Input: root = [20,10,30,5,15,25,35,null,7], k = 2
Output: 7
Explanation: In-order traversal yields [5,7,10,15,20,25,30,35]. The 2nd entry is 7.
```$$,
    $$- 카탈로그의 대상 수는 `n`입니다.
- `1 <= k <= n <= 8 * 10^4`
- `0 <= Node.val <= 10^8`
- 트리는 유효한 이진 탐색 트리입니다.$$
);

-- flights-by-tier
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'flights-by-tier'),
    'ko',
    $$층별 항공편 분류$$,
    $$항공사의 일일 운항표는 최상단 캐리어에서 시작해 기종, 개별 항공편으로 내려가는 이진 트리로 모델링됩니다. 운영팀은 각 층을 상황판의 한 행으로 표시하고자 하며, 최상위 층이 가장 먼저 오도록 하고 싶어 합니다.

운항표 트리의 `root`가 주어질 때, `groupByTier`를 구현하여 각 층의 값을 순서대로 반환하세요. 각 내부 리스트는 해당 깊이의 값을 왼쪽에서 오른쪽 순서로 담습니다.

운항표가 비어 있다면 빈 리스트를 반환합니다.

**예시 1:**
```
Input: root = [10,5,15,null,null,12,20]
Output: [[10],[5,15],[12,20]]
Explanation: Tier 0 has flight 10. Tier 1 has flights 5 and 15. Tier 2 has flights 12 and 20.
```

**예시 2:**
```
Input: root = [42]
Output: [[42]]
Explanation: A solo root flight makes a single-row board.
```

**예시 3:**
```
Input: root = []
Output: []
```$$,
    $$- 운항표 트리의 노드 개수는 `[0, 2 * 10^3]` 범위입니다.
- `-1000 <= Node.val <= 1000`$$
);

-- best-scene-branch
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'best-scene-branch'),
    'ko',
    $$최고의 장면 체인$$,
    $$제작 분석표는 이진 트리로 저장되며, 각 노드는 해당 장면의 관객 몰입도 점수(부호 있는 정수)를 가집니다. 양수는 관객을 사로잡고, 음수는 몰입을 떨어뜨립니다. 편집자는 한 막을 구성할 수 있는 가장 임팩트 있는 연속된 장면 체인을 찾고자 합니다.

**체인(branch)** 은 인접한 노드끼리 간선으로 연결된 노드들의 시퀀스이며, 노드는 중복되지 않고, 루트를 반드시 지날 필요는 없습니다. **체인 총점** 은 체인을 따라가는 점수의 합입니다.

분석표 트리의 `root`가 주어질 때, `maxBranchTotal`을 구현하여 비어 있지 않은 모든 체인 중 최대 체인 총점을 반환하세요.

**예시 1:**
```
Input: root = [4,5,6]
Output: 15
Explanation: The best branch is 5 -> 4 -> 6, totaling 5 + 4 + 6 = 15.
```

**예시 2:**
```
Input: root = [-8,11,25,null,null,13,9]
Output: 47
Explanation: The best branch is 13 -> 25 -> 9, totaling 13 + 25 + 9 = 47. Starting at the root pulls the total down because of the -8.
```$$,
    $$- 트리의 장면 개수는 `[1, 8 * 10^4]` 범위입니다.
- `-1000 <= Node.val <= 1000`$$
);

-- reflect-blend-profile
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'reflect-blend-profile'),
    'ko',
    $$블렌딩 프로파일 반전$$,
    $$양조사는 블렌딩 계획을 이진 트리로 저장합니다. 각 노드는 배럴을 나타내고, 왼쪽 자식은 초반 풍미 블렌드, 오른쪽 자식은 후반 풍미 블렌드입니다. 모든 블렌딩 결정을 뒤집어 맛보기 위해, 양조사는 모든 층에서 왼쪽/오른쪽 짝이 뒤바뀐 미러링된 계획 사본을 원합니다.

블렌드 트리의 `root`가 주어질 때, `reflectBlend`를 구현하여 모든 노드의 왼쪽과 오른쪽 자식을 재귀적으로 교체하고, 반전된 트리의 루트를 반환하세요.

**예시 1:**
```
Input: root = [5,3,8,2,4,7,9]
Output: [5,8,3,9,7,4,2]
Explanation: Every left/right pair is swapped at every level.
```

**예시 2:**
```
Input: root = [6,4,11]
Output: [6,11,4]
```

**예시 3:**
```
Input: root = []
Output: []
```$$,
    $$- 트리의 배럴 개수는 `[0, 100]` 범위입니다.
- `-100 <= Node.val <= 100`$$
);

-- wire-zone-peers
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'wire-zone-peers'),
    'ko',
    $$동일 층 허브 연결$$,
    $$스마트홈 메시 네트워크는 **완전 이진 트리** 로 구성됩니다. 잎을 제외한 모든 허브는 정확히 두 개의 자식 허브를 가지며, 모든 잎 허브는 같은 층에 위치합니다. 각 허브에는 추가로 `next` 포인터가 있으며, 운영팀은 이 포인터를 연결해서 같은 층의 형제 허브 사이로 가십 브로드캐스트가 루트까지 되돌아가지 않고도 퍼지도록 하고자 합니다.

```
class Node {
    int val;
    Node left;
    Node right;
    Node next;
}
```

`wireSiblingHubs`를 구현하여 각 허브의 `next`가 같은 층에서 바로 오른쪽에 있는 허브를 가리키도록 하세요. 해당 허브가 그 층의 가장 오른쪽이라면 `next`는 `null`로 유지되어야 합니다. 갱신된 메시의 `root`를 반환하세요.

**예시 1:**
```
Input: root = [10,20,30,40,50,60,70]
Output: [10,#,20,30,#,40,50,60,70,#]
Explanation: The tree has three floors.
- Floor 0: 10 -> null
- Floor 1: 20 -> 30 -> null
- Floor 2: 40 -> 50 -> 60 -> 70 -> null
The # marks the end of each floor's chain.
```

**예시 2:**
```
Input: root = [9]
Output: [9,#]
Explanation: A lone hub has no right neighbor.
```

**예시 3:**
```
Input: root = [5,6,7]
Output: [5,#,6,7,#]
```$$,
    $$- 메시의 허브 개수는 `[1, 4096]` 범위입니다.
- `-1000 <= Node.val <= 1000`
- 메시는 완전 이진 트리임이 보장됩니다.$$
);

-- dock-edge-silhouette
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'dock-edge-silhouette'),
    'ko',
    $$하역장 측면 실루엣$$,
    $$창고는 자재 명세서를 이진 트리로 저장합니다. 최상단에는 루트 어셈블리가 있고, 그 아래로 서브 어셈블리와 부품들이 갈라집니다. 하역장에서 보면 각 층에서 가장 오른쪽으로 튀어나온 선반만 보이며, 그 왼쪽에 있는 것들은 가려집니다.

자재 명세서 트리의 `root`가 주어질 때, `captureDockSilhouette`를 구현하여 위에서 아래로 각 층의 가장 오른쪽에 보이는 선반의 값을 반환하세요. 트리가 비어 있다면 빈 리스트를 반환합니다.

**예시 1:**
```
Input: root = [7,8,9,null,6,null,3]
Output: [7,9,3]
Explanation: Tier 0 shows shelf 7. Tier 1 shows shelves 8 and 9 with 9 on the right. Tier 2 shows shelves 6 and 3 with 3 on the right.
```

**예시 2:**
```
Input: root = [2,null,5]
Output: [2,5]
```

**예시 3:**
```
Input: root = []
Output: []
```$$,
    $$- 트리의 선반 개수는 `[0, 100]` 범위입니다.
- `-100 <= Node.val <= 100`$$
);

-- sum-zone-codes
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'sum-zone-codes'),
    'ko',
    $$우편 구역 코드 합산$$,
    $$우편 분류 센터는 지역-우편번호 계층을 이진 트리로 저장하며, 각 노드는 한 자리 숫자(`0`-`9`)를 가집니다. 루트에서 어떤 잎까지 내려가면 전체 구역 코드가 완성되며, 경로를 따라 이어진 숫자들을 연결하면 그 가지에 해당하는 하나의 정수가 됩니다.

구역 코드 트리의 `root`가 주어질 때, `totalZoneCodes`를 구현하여 루트에서 잎까지의 모든 경로가 만들어내는 구역 코드의 합을 반환하세요.

**예시 1:**
```
Input: root = [2,5,8]
Output: 53
Explanation: Path 2 -> 5 spells 25 and path 2 -> 8 spells 28. Total = 25 + 28 = 53.
```

**예시 2:**
```
Input: root = [3,6,1,4,0]
Output: 755
Explanation: 3 -> 6 -> 4 = 364, 3 -> 6 -> 0 = 360, 3 -> 1 = 31. Total = 364 + 360 + 31 = 755.
```

**예시 3:**
```
Input: root = [9]
Output: 9
Explanation: A single node is both root and leaf, giving one zone code of 9.
```$$,
    $$- 구역 코드 트리의 노드 개수는 `[1, 1000]` 범위입니다.
- `0 <= Node.val <= 9`$$
);

-- list-runtime-branches
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'list-runtime-branches'),
    'ko',
    $$러닝타임 분기 추출$$,
    $$포스트프로덕션 편집자는 영화를 트리로 분해합니다. `root`는 최종 컷이고, 각 내부 노드는 막이나 시퀀스이며, 모든 잎은 분할되지 않은 러닝타임 구간으로 분(分) 단위 값이 적혀 있습니다. 편집자는 방송사가 미리 팔아둔 슬롯에 딱 맞게 들어갈 수 있도록, 분 값의 합이 정확히 `target`이 되는 모든 최상위-최하위 경로를 찾고자 합니다.

`listRuntimeBranches(root, target)`을 구현하여 노드 값의 합이 `target`과 같은 모든 루트-잎 경로를 반환하세요. 각 경로는 `root`에서 잎까지 순서대로 노드 값을 담은 리스트입니다. **잎(leaf)** 은 자식이 없는 노드입니다. 경로는 왼쪽을 먼저 탐색하는 깊이 우선 탐색으로 발견되는 순서대로 반환합니다.

**예시 1:**
```
Input: root = [10,6,9,3,null,4,5,null,null,8,2], target = 19
Output: [[10,6,3]]
Explanation: The only root-to-leaf branch summing to 19 is 10 -> 6 -> 3.
```

**예시 2:**
```
Input: root = [7,2,4,null,5,1,3], target = 14
Output: [[7,2,5],[7,4,3]]
Explanation: Two branches reach 14: 7 + 2 + 5 and 7 + 4 + 3.
```$$,
    $$- 트리의 노드 개수는 `[0, 4500]` 범위입니다.
- `-1000 <= Node.val <= 1000`
- `-1000 <= target <= 1000`$$
);

-- shared-dispatch-hub
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'shared-dispatch-hub'),
    'ko',
    $$공통 배송 허브 찾기$$,
    $$택배 네트워크는 배송 허브의 트리로 구성됩니다. `root`는 중앙 집하장, 각 자식은 권역 허브, 그 아래는 지역 허브, 라스트마일 클러스터, 그리고 마지막으로 개별 배송지입니다. 모든 허브는 고유한 숫자 코드를 가집니다. 목적지가 `p`와 `q`인 두 택배가 가능한 한 오래 같은 차량을 탈 수 있도록, 디스패처는 두 배송지를 서브트리에 모두 포함하는 가장 깊은 허브를 찾고자 합니다.

`findSharedHub(root, p, q)`를 구현하여 그 **최소 공통 조상(lowest common ancestor)** 노드를 반환하세요. 허브는 자기 자신의 조상으로 간주되므로, `p`나 `q` 중 하나가 다른 하나의 위쪽에 있다면 그 위쪽 노드가 답이 됩니다. 모든 노드 값은 고유하며, `p`와 `q`는 트리에 반드시 존재합니다.

**예시 1:**
```
Input: root = [12,7,20,4,9,16,25,null,null,8,11], p = 4, q = 11
Output: 7
Explanation: Stop 4 sits under hub 7, and stop 11 sits under hub 9 which itself sits under hub 7, so 7 is the deepest shared hub.
```

**예시 2:**
```
Input: root = [12,7,20,4,9,16,25,null,null,8,11], p = 9, q = 7
Output: 7
Explanation: Hub 9 is already under hub 7, so 7 is its own lowest common ancestor with 9.
```$$,
    $$- 트리의 노드 개수는 `[2, 9000]` 범위입니다.
- `|Node.val| <= 10^8`
- 모든 `Node.val`은 고유합니다.
- `p != q`
- `p`와 `q`는 모두 트리에 존재합니다.$$
);

-- deepest-zone-chain
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'deepest-zone-chain'),
    'ko',
    $$최대 깊이 구역 체인$$,
    $$지역 우편 분류기는 주소 공간을 계층 구조로 모델링합니다. `root`는 국가 단위 구역 코드, 그 자식은 도(道) 단위 코드, 그 다음은 시(市) 단위 코드, 그리고 개별 우편번호까지 이어집니다. 경영진은 스캐너 캐시 용량을 정하기 위해, 가장 긴 구역 코드 체인이 몇 단계 깊이까지 내려가는지 한눈에 파악하고자 합니다.

`deepestZoneChain(root)`을 구현하여 계층 구조의 **최대 깊이** — 즉 `root`에서 어떤 잎까지의 가장 긴 경로 위에 있는 노드 개수 — 를 반환하세요. 잎은 자식이 없는 노드입니다. 빈 트리의 깊이는 `0`입니다.

**예시 1:**
```
Input: root = [8,5,12,null,null,9,17]
Output: 3
Explanation: The longest chain has three hubs: 8 -> 12 -> 9 or 8 -> 12 -> 17.
```

**예시 2:**
```
Input: root = [4,null,2,null,7]
Output: 3
Explanation: The chain 4 -> 2 -> 7 runs three nodes deep; the left spine is empty.
```$$,
    $$- 트리의 노드 개수는 `[0, 8000]` 범위입니다.
- `-100 <= Node.val <= 100`$$
);

-- widest-catalog-span
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'widest-catalog-span'),
    'ko',
    $$최장 카탈로그 경로$$,
    $$사서는 듀이 분류 체계를 트리로 배치합니다. `root`는 최상위 분류이며, 모든 후손 노드는 개별 청구기호 버킷에 이르기까지 더 세분화된 하위 분류입니다. 접근성 감사를 위해 사서는 카탈로그 내 어떤 두 버킷 사이의 가장 긴 이동 경로에 포함된 **서가 간 이동(홉)** 횟수가 필요합니다. 경로는 내부 분류에서 꺾일 수도 있고 하나의 축을 따라 곧게 내려갈 수도 있으며, 둘 중 더 긴 쪽을 취합니다.

`widestCatalogSpan(root)`을 구현하여 그 경로 길이를 반환하세요. 이는 트리 내 어떤 두 노드 사이의 가장 긴 경로에 포함된 **간선(edge)** 수로 측정됩니다. 경로는 반드시 `root`를 지날 필요는 없습니다.

**예시 1:**
```
Input: root = [7,3,8,1,4,null,9]
Output: 4
Explanation: The walk 1 -> 3 -> 7 -> 8 -> 9 uses 4 edges, which is the widest span.
```

**예시 2:**
```
Input: root = [2,null,5,3]
Output: 2
Explanation: The walk 2 -> 5 -> 3 crosses two edges.
```$$,
    $$- 트리의 노드 개수는 `[1, 8000]` 범위입니다.
- `-100 <= Node.val <= 100`$$
);

-- contains-topic-branch
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'contains-topic-branch'),
    'ko',
    $$토픽 분기 포함 여부$$,
    $$한 뉴스 집계 서비스는 토픽 분류 체계를 트리 형태로 관리합니다. 각 노드는 토픽 레이블이고, 부모-자식 관계는 어떤 넓은 토픽이 어떤 좁은 토픽을 포괄하는지를 나타냅니다. 한 분석가가 특정 세부 보도 영역을 나타내는 작은 참조 분기를 가지고 와서, 그 분기가 기존 분류 체계 내부 어딘가에 그대로 존재하는지 확인하고 싶어 합니다.

분류 체계 `root`와 참조 분기 `subRoot`가 주어질 때, `root` 안에 어떤 노드가 존재하여 그 노드를 루트로 하는 서브트리가 모양과 모든 토픽 값이 `subRoot`와 정확히 일치한다면 `true`를, 그렇지 않다면 `false`를 반환하는 `containsSubBranch(root, subRoot)`를 구현하세요. `root` 트리 전체도 자기 자신의 서브트리로 간주합니다.

**예시 1:**
```
Input: root = [9,6,7,2,4], subRoot = [6,2,4]
Output: true
Explanation: The left child of root is topic 6, and its subtree [6,2,4] matches subRoot exactly.
```

**예시 2:**
```
Input: root = [1,8,3,null,5], subRoot = [8,5]
Output: false
Explanation: Topic 8 appears in root, but there the child 5 hangs on the right, while subRoot has 5 on the left, so the shapes do not agree.
```$$,
    $$- `root` 트리의 노드 수는 `[1, 2000]` 범위입니다.
- `subRoot` 트리의 노드 수는 `[1, 900]` 범위입니다.
- `-8000 <= root.val <= 8000`
- `-8000 <= subRoot.val <= 8000`$$
);

-- alternate-ward-sweep
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'alternate-ward-sweep'),
    'ko',
    $$병동 지그재그 순회$$,
    $$한 병원의 트리아지 보드는 중증도 점수의 이진 트리로 구성되어 있습니다. `root`는 당직 책임자이며, 각 왼쪽 분기는 더 낮은 중증도 협진을, 오른쪽 분기는 더 높은 중증도 협진을 추적합니다. 30분마다 두 번 진행되는 순회에서 수석 간호사는 보드를 지그재그로 훑어봅니다. 책임자의 행은 왼쪽에서 오른쪽으로, 바로 아래 행은 오른쪽에서 왼쪽으로, 그다음 행은 다시 왼쪽에서 오른쪽으로 읽는 식으로 병동 레벨마다 방향을 번갈아 가며 진행합니다.

`alternateWardSweep(root)`를 구현하여 노드 값들을 레벨별로 그룹화하되 이 지그재그 순서를 따르도록 반환하세요. 각 레벨은 내부 리스트이며, 바깥쪽 리스트는 루트 레벨부터 아래쪽 순으로 정렬됩니다. 빈 트리는 빈 리스트를 반환합니다.

**예시 1:**
```
Input: root = [5,3,7,2,9,6,8]
Output: [[5],[7,3],[2,9,6,8]]
Explanation: Row 0 left-to-right gives [5]; row 1 right-to-left gives [7,3]; row 2 left-to-right gives [2,9,6,8].
```

**예시 2:**
```
Input: root = [4]
Output: [[4]]
Explanation: A single node is reported on its own row.
```$$,
    $$- 트리의 노드 수는 `[0, 1800]` 범위입니다.
- `-100 <= Node.val <= 100`$$
);

-- flag-material-codes
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'flag-material-codes'),
    'ko',
    $$자재 코드 추적$$,
    $$한 재활용 처리장의 분류 바닥은 `m x n` 크기의 격자로 배치되어 있으며, 각 칸에는 **자재 약어**를 나타내는 하나의 소문자 알파벳(a, p, g, r 등)이 찍혀 있습니다. 품질 담당 팀은 현재 바닥 배치와 대조해서 감사해야 할 위험 `patterns` 목록을 관리합니다.

어떤 패턴을 `grid`의 한 칸에서 출발해서 **가로 또는 세로로 인접한** 칸들을 순서대로 따라 읽을 수 있고, 하나의 추적 과정에서 같은 칸을 두 번 밟지 않는다면 그 패턴은 **추적 가능**하다고 간주합니다.

`flagMaterialCodes(grid, patterns)`를 구현하여 `patterns` 중 추적 가능한 모든 패턴을 사전식 순서로 반환하세요. 하나의 패턴이 여러 방법으로 추적 가능하더라도 결과에는 최대 한 번만 포함되어야 합니다.

**예시 1:**
```
Input: grid = [["c","o","d","e"],["h","a","t","s"],["i","r","n","m"],["p","u","a","l"]], patterns = ["code","chat","maze","nail"]
Output: ["chat","code"]
```

**예시 2:**
```
Input: grid = [["p","a"],["g","c"]], patterns = ["pcg"]
Output: []
```$$,
    $$- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 12`
- `grid[i][j]`는 소문자 영문자입니다.
- `1 <= patterns.length <= 8 * 10^4`
- `1 <= patterns[i].length <= 10`
- `patterns[i]`는 소문자 영문자로만 구성됩니다.
- `patterns`의 모든 문자열은 서로 다릅니다.$$
);

-- pair-crates-for-order
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'pair-crates-for-order'),
    'ko',
    $$주문 상자 짝짓기$$,
    $$한 크로스도크 관리자가 저녁 출하 전에 상자들을 팔레트에 싣고 있습니다. 각 팔레트는 **최대 두 개의 상자**만 실을 수 있고, 총 무게가 `capacity` 킬로그램을 넘을 수 없습니다. 모든 상자는 정확히 하나의 팔레트에 실려야 합니다.

정수 배열 `crates`(여기서 `crates[i]`는 `i`번째 상자의 무게)와 팔레트 적재 한도를 나타내는 정수 `capacity`가 주어질 때, 도크에서 모든 상자를 출하하는 데 필요한 **최소 팔레트 수**를 반환하세요.

**예시 1:**
```
Input: crates = [2,4], capacity = 6
Output: 1
Explanation: The two crates together weigh 6 kg, which fits a single pallet.
```

**예시 2:**
```
Input: crates = [4,3,1,2], capacity = 4
Output: 3
Explanation: Pair crate 1 with crate 3 (sum 4) on one pallet. Crate 2 rides alone, and crate 4 rides alone — three pallets in total.
```$$,
    $$- `1 <= crates.length <= 2 * 10^5`
- `1 <= crates[i] <= capacity <= 2 * 10^3`$$
);

-- shift-unscannable-letters
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'shift-unscannable-letters'),
    'ko',
    $$스캔 불가 문자 치환$$,
    $$한 우편 분류기가 긴 소포 벨트 위에 찍힌 구역 문자를 읽어 대문자 문자열 `code`를 생성합니다. 단일 목적지 빈으로 향하는 연속 구간을 최대로 확보하기 위해, 운영자는 **최대 `k`개의 소포를 재레이블링**할 수 있으며, 재레이블링 한 번으로 `code`의 한 문자를 임의의 다른 대문자로 바꿀 수 있습니다.

최대 `k`번의 재레이블링 이후 `code`에서 하나의 동일한 문자로만 구성된 연속 구간의 최대 길이를 반환하세요.

**예시 1:**
```
Input: code = "PQPQ", k = 2
Output: 4
Explanation: Relabel both P's to Q to obtain "QQQQ", a run of length 4.
```

**예시 2:**
```
Input: code = "XXYXYYX", k = 1
Output: 4
Explanation: Relabel the Y at index 2 to X to obtain the run "XXXX" from indices 0..3.
```$$,
    $$- `1 <= code.length <= 2 * 10^5`
- `code`는 대문자 영문자로만 구성됩니다.
- `0 <= k <= code.length`$$
);

-- void-empty-scans
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'void-empty-scans'),
    'ko',
    $$빈 스캔 정리$$,
    $$한 계산대 단말기는 바코드가 스캔된 순서대로 각 바코드에 청구된 금액을 로그 `scans`에 기록합니다. 취소된 항목은 로그에 `0`으로 나타납니다. 고객에게 깔끔한 영수증을 제공하기 위해, 계산원은 실제 청구 항목들의 **스캔 상대 순서**를 그대로 유지하면서 모든 취소 항목을 로그의 끝으로 밀어내고 싶어 합니다.

`scans`를 **제자리에서** 변경하세요. 새 배열을 할당해서는 안 됩니다. 드라이버는 메서드가 반환된 뒤 배열을 출력합니다.

**예시 1:**
```
Input: scans = [4,0,0,2,9,0,7]
Output: [4,2,9,7,0,0,0]
Explanation: The four real charges keep their scan order, and the three voids slide to the end.
```

**예시 2:**
```
Input: scans = [0,0,5]
Output: [5,0,0]
```$$,
    $$- `1 <= scans.length <= 2 * 10^5`
- `|scans[i]| <= 10^8`$$
);

-- verify-mirror-callnumber
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'verify-mirror-callnumber'),
    'ko',
    $$거울 청구기호 검증$$,
    $$한 도서관 특별 장서 큐레이터는 거울을 테마로 한 전시대에 **청구기호 문구**로 레이블을 붙이는데, 이 문구는 대소문자와 영숫자가 아닌 문자(공백, 구두점 등)를 무시하면 앞뒤로 똑같이 읽혀야 합니다. 인턴이 레이블을 인쇄하기 전에 빠르게 검증할 수 있는 도구를 원합니다.

문자열 `code`가 주어지면, 모든 대문자를 소문자로 바꾸고 영숫자가 아닌 문자를 모두 제거하세요. 남은 시퀀스가 앞뒤로 동일하게 읽히면 `true`를, 그렇지 않으면 `false`를 반환하세요. 빈 문자열도 유효한 거울로 간주합니다.

**예시 1:**
```
Input: code = "Stacks: Level 2 level stack S"
Output: true
Explanation: After filtering, the phrase becomes "stackslevel2levelstacks", which mirrors itself.
```

**예시 2:**
```
Input: code = "Shelf 7A not mirrored"
Output: false
Explanation: After filtering the phrase becomes "shelf7anotmirrored", which is not a mirror.
```

**예시 3:**
```
Input: code = ",,,"
Output: true
Explanation: After removing non-alphanumeric characters the phrase is empty, which counts as a mirror.
```$$,
    $$- `1 <= code.length <= 2 * 10^5`
- `code`는 32에서 126 사이의 출력 가능한 문자로만 구성됩니다.$$
);

-- quad-tray-demand
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'quad-tray-demand'),
    'ko',
    $$4단 트레이 수요 조합$$,
    $$한 제과점 플래너는 발효가 끝난 트레이 명단을 보유하고 있으며, 각 트레이에는 계획 대비 부호 있는 빵 개수 조정값 `trays[i]`가 기록되어 있습니다(양수는 잉여, 음수는 부족). 그녀는 **서로 다른 네 개 트레이 조합**의 조정값 합이 정확히 목표 수요 변동량과 같아지는 모든 그룹을 찾고 싶어 합니다.

정수 배열 `trays`와 정수 `demand`가 주어질 때, 서로 다른 네 인덱스의 값들이 합쳐 `demand`가 되는 모든 **고유한 4원소 조합** `[trays[a], trays[b], trays[c], trays[d]]`를 반환하세요. 결과에는 중복된 조합이 없어야 하며 어떤 순서로 반환해도 됩니다.

**예시 1:**
```
Input: trays = [1,-1,2,-2,3,-3], demand = 0
Output: [[-3,-2,2,3],[-3,-1,1,3],[-2,-1,1,2]]
Explanation: Three distinct foursomes of tray adjustments add up to a zero net delta.
```

**예시 2:**
```
Input: trays = [3,3,3,3,3], demand = 12
Output: [[3,3,3,3]]
Explanation: Every tray has surplus 3, and any four of them pool to 12.
```$$,
    $$- `1 <= trays.length <= 2 * 10^3`
- `|trays[i]| <= 10^8`
- `|demand| <= 10^8`$$
);

-- pool-between-walls
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'pool-between-walls'),
    'ko',
    $$벽 사이 빗물 저류$$,
    $$계단식 관개 농지가 한 줄로 늘어선 석벽으로 이루어져 있으며, 각 구획마다 하나씩 벽이 세워져 있습니다. `n`개의 비음수 정수로 이루어진 배열 `wallHeight`가 주어지고, `wallHeight[i]`는 `i`번째 구획(각 구획의 폭은 1미터) 벽의 높이입니다. 폭풍이 지난 뒤 낮은 지점에는 양쪽 중 더 낮은 이웃 벽의 높이까지 물이 고입니다.

유수가 안정된 후 이 농지가 저장하는 총 빗물 양을 단위 칸 수로 반환하세요.

**예시 1:**
```
Input: wallHeight = [0,2,0,3,1,0,2,4,1,2,0,1]
Output: 10
Explanation: The tallest flanking walls cap each trough. Summing the trapped depth above every plot yields 10 unit cells.
```

**예시 2:**
```
Input: wallHeight = [3,1,0,2,1,4]
Output: 8
Explanation: Water pools between the leftmost wall of height 3 and the rightmost wall of height 4, trapping 8 unit cells in the dip.
```$$,
    $$- `n == wallHeight.length`
- `1 <= n <= 2 * 10^5`
- `0 <= wallHeight[i] <= 10^8`$$
);

-- pair-tiers-budget
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'pair-tiers-budget'),
    'ko',
    $$예산에 맞는 등급 짝 찾기$$,
    $$매표소는 좌석 등급별로 한 행씩, 비내림차순으로 정렬된 **1-인덱스** 가격표 `tierPrice`를 운영합니다. 한 팬이 고정된 `budget`을 들고 와서 가격 합계가 정확히 해당 예산이 되는 서로 다른 두 등급을 찾아 각 등급에서 한 좌석씩 사고자 합니다.

두 등급 번호를 `[tier1, tier2]` 형태로 반환하되 `1 <= tier1 < tier2 <= tierPrice.length`를 만족해야 합니다. 입력은 정확히 한 쌍의 유효한 해답이 존재하도록 보장되며, 구현은 입력 자체 외에 **상수 크기의 추가 공간**만 사용해야 합니다.

**예시 1:**
```
Input: tierPrice = [12,30,45,58,70,85], budget = 100
Output: [2,5]
Explanation: Tier 2 costs 30 and tier 5 costs 70, which together match the 100 budget.
```

**예시 2:**
```
Input: tierPrice = [5,14,22,40], budget = 54
Output: [2,4]
Explanation: Tier 2 is 14 and tier 4 is 40; 14 + 40 = 54.
```$$,
    $$- `2 <= tierPrice.length <= 2 * 10^5`
- `-10^8 <= tierPrice[i] <= 10^8`
- `tierPrice`는 비내림차순으로 정렬되어 있습니다.
- `-2 * 10^8 <= budget <= 2 * 10^8`
- 입력은 정확히 하나의 유효한 쌍이 존재하도록 생성됩니다.$$
);

-- order-tank-deviations
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'order-tank-deviations'),
    'ko',
    $$수조 편차 정렬$$,
    $$아쿠아리움의 각 수조는 기준치 대비 pH 편차를 부호 있는 정수로 기록합니다. 비내림차순으로 정렬된 배열 `deviation`이 주어지며, 음수는 산성 쪽으로, 양수는 알칼리성 쪽으로 치우친 값을 나타냅니다. 안정성 점검을 위해 연구실은 각 수조의 편차를 **제곱**한 뒤, 안정된 수조가 먼저 오고 가장 불안정한 수조가 마지막에 오도록 비내림차순으로 반환하길 원합니다.

제곱된 편차 값을 오름차순으로 정렬한 배열을 반환하세요. 일반 정렬 알고리즘을 쓰지 말고 O(n)에 처리하는 것을 목표로 합니다.

**예시 1:**
```
Input: deviation = [-5,-2,0,4,9]
Output: [0,4,16,25,81]
```

**예시 2:**
```
Input: deviation = [-6,-4,1,3,8]
Output: [1,9,16,36,64]
```

**예시 3:**
```
Input: deviation = [2,3,5,7]
Output: [4,9,25,49]
Explanation: All readings are non-negative, so squaring them preserves the existing order.
```$$,
    $$- `1 <= deviation.length <= 2 * 10^5`
- `-8 * 10^3 <= deviation[i] <= 8 * 10^3`
- `deviation`은 비내림차순으로 정렬되어 있습니다.$$
);

-- triage-zero-priority
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'triage-zero-priority'),
    'ko',
    $$제로 우선순위 트리아지$$,
    $$119 상황실은 대기 중인 각 신고의 **우선순위 편차(priority delta)**를 부호 있는 정수로 관리합니다. 음수는 프로토콜 대비 과소 우선순위, 양수는 과대 우선순위를 뜻합니다. 정수 배열 `delta`가 주어질 때, 관리자는 서로 다른 세 개의 신고 인덱스로 구성되고 편차의 합이 정확히 0인 모든 고유한 3-튜플(완벽하게 균형 잡힌 트리아지 그룹)을 찾고자 합니다.

그러한 모든 트리플을 `[delta[i], delta[j], delta[k]]` 형태로 반환하세요. 동일한 트리플은 서로 다른 인덱스 조합에서 여러 번 만들어지더라도 결과에 한 번만 포함되어야 하며, 트리플 사이의 순서는 상관없습니다.

**예시 1:**
```
Input: delta = [-3,1,2,-2,0,-1,1]
Output: [[-3,1,2],[-2,0,2],[-2,1,1],[-1,0,1]]
Explanation: Four distinct balanced trios exist; each sums to zero.
```

**예시 2:**
```
Input: delta = [2,3,4]
Output: []
Explanation: Every delta is positive, so no trio can sum to zero.
```

**예시 3:**
```
Input: delta = [0,0,0,0]
Output: [[0,0,0]]
```$$,
    $$- `3 <= delta.length <= 2 * 10^3`
- `-10^8 <= delta[i] <= 10^8`$$
);

-- frame-largest-bale
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'frame-largest-bale'),
    'ko',
    $$최대 베일 적재 면적$$,
    $$재활용 처리장 바닥의 베일 적재 구역에는 수직 칸막이벽들이 일렬로 세워져 있습니다. 각 벽 `i`는 위치 `(i, 0)`에서 바닥부터 `(i, partitionHeight[i])`까지 솟아 있습니다. 새 베일을 적재할 때는 두 개의 벽을 고르고, 이 두 벽과 바닥(x축)이 함께 직사각형 모양의 적재 바닥면을 형성합니다. 이때 높이는 두 벽 중 **더 낮은** 쪽으로 제한되고, 너비는 두 벽 사이의 수평 거리입니다.

길이 `n`의 정수 배열 `partitionHeight`가 주어질 때, 임의의 두 벽이 만들 수 있는 가장 큰 베일 바닥면(너비 × 제한 높이)을 반환하세요. 벽은 기울일 수 없습니다.

**예시 1:**
```
Input: partitionHeight = [2,6,4,1,5,3,6,2,8]
Output: 42
Explanation: The walls at index 1 (height 6) and index 8 (height 8) frame a footprint of width 7 and limiting height 6, giving 42.
```

**예시 2:**
```
Input: partitionHeight = [2,3]
Output: 2
```$$,
    $$- `n == partitionHeight.length`
- `2 <= n <= 2 * 10^5`
- `0 <= partitionHeight[i] <= 8 * 10^4`$$
);
