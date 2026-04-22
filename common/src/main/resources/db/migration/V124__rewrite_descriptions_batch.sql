-- V124: Phase 2 — rewrite description, constraints, and sample
-- test cases for 183 problem(s). Hidden test cases are not touched.
-- Sample test case rows are updated in place (preserving test case IDs) so
-- historical submission_results FKs remain valid.
-- carrier-street-sweep
UPDATE problems SET
  description = $$A regional mail carrier needs to walk every street exactly once during a single shift, then submit the ordered list of zone codes they visited. You are given a list of one-way street segments `routes`, where each entry `routes[i] = [from, to]` records a mandated traversal between two three-letter zone codes. Every shift starts at the sorting hub with code `"HUB"`.

Reconstruct a single walk that uses every segment exactly once, starting at `"HUB"`. When multiple valid walks exist, return the one that is **lexicographically smallest** when compared zone-by-zone.

The input guarantees at least one valid walk exists.

**Example 1:**
```
Input: routes = [["ELM","HUB"],["HUB","BIR"],["BIR","ELM"],["HUB","CED"]]
Output: ["HUB","BIR","ELM","HUB","CED"]
Explanation: The walk HUB -> BIR -> ELM -> HUB -> CED consumes all four segments. Picking CED first would strand the carrier before BIR and ELM are reached.
```

**Example 2:**
```
Input: routes = [["HUB","NOR"],["HUB","SOU"],["NOR","SOU"],["SOU","HUB"],["SOU","NOR"]]
Output: ["HUB","NOR","SOU","HUB","SOU","NOR"]
Explanation: Visiting NOR before SOU from the hub gives the lex-smallest walk that still lets the carrier finish every segment.
```$$,
  constraints = $$- `1 <= routes.length <= 320`
- `routes[i].length == 2`
- Each `from` and `to` is a three-letter uppercase zone code
- `from != to` within any single segment
- The segments admit at least one valid walk starting at `"HUB"`$$
WHERE slug = 'carrier-street-sweep';

UPDATE test_cases SET input = E'[["ELM","HUB"],["HUB","BIR"],["BIR","ELM"],["HUB","CED"]]', expected_output = '["HUB","BIR","ELM","HUB","CED"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'carrier-street-sweep')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[["HUB","NOR"],["HUB","SOU"],["NOR","SOU"],["SOU","HUB"],["SOU","NOR"]]', expected_output = '["HUB","NOR","SOU","HUB","SOU","NOR"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'carrier-street-sweep')
  AND is_sample = TRUE AND order_index = 2;

-- responder-relay-cost
UPDATE problems SET
  description = $$A dispatch center connects `n` districts labeled `0` through `n - 1` via one-way relay corridors between nearby responder stations. Each entry `corridors[i] = [from, to, minutes]` describes a relay that forwards a call from district `from` to district `to` costing `minutes` minutes of radio chatter.

Given a source district `src`, a destination district `dst`, and a maximum of `maxHops` intermediate districts a relay is allowed to pass through, return the **minimum total minutes** needed to push a call from `src` to `dst`. If no valid relay sequence fits within `maxHops` intermediate districts, return `-1`.

**Example 1:**
```
Input: n = 5, corridors = [[0,1,50],[1,2,40],[0,2,200],[2,3,30],[3,4,20],[1,3,150]], src = 0, dst = 4, maxHops = 2
Output: 220
Explanation: The relay 0 -> 1 -> 3 -> 4 (cost 50 + 150 + 20 = 220) uses 2 intermediate districts. The cheaper chain 0 -> 1 -> 2 -> 3 -> 4 would need 3 intermediates and is rejected.
```

**Example 2:**
```
Input: n = 4, corridors = [[0,1,80],[1,2,40],[0,2,300],[2,3,90],[0,3,400]], src = 0, dst = 3, maxHops = 0
Output: 400
Explanation: With `maxHops = 0` only the direct corridor 0 -> 3 at 400 minutes qualifies, even though 0 -> 1 -> 2 -> 3 would total 210.
```$$,
  constraints = $$- `1 <= n <= 120`
- `0 <= corridors.length <= n * (n - 1) / 2`
- `corridors[i].length == 3`
- `0 <= from, to < n` and `from != to`
- `1 <= minutes <= 8000`
- `0 <= src, dst, maxHops < n`
- `src != dst`$$
WHERE slug = 'responder-relay-cost';

UPDATE test_cases SET input = E'5\n[[0,1,50],[1,2,40],[0,2,200],[2,3,30],[3,4,20],[1,3,150]]\n0\n4\n2', expected_output = '220'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'responder-relay-cost')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'4\n[[0,1,80],[1,2,40],[0,2,300],[2,3,90],[0,3,400]]\n0\n3\n0', expected_output = '400'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'responder-relay-cost')
  AND is_sample = TRUE AND order_index = 2;

-- duplicate-catalog-link
UPDATE problems SET
  description = $$A librarian maintains a cross-reference graph over `n` catalog entries labeled `1` through `n`. The reference network was originally a tree, but during a batch import one extra cross-reference slipped in and now exactly one cycle exists. The current references are given as `links`, where each `links[i] = [a, b]` is an undirected cross-reference between entries `a` and `b`.

Return the one link that should be retired so the reference graph becomes a tree again. If more than one link could break the cycle, return the one that appears **last** in `links`.

**Example 1:**
```
Input: links = [[1,2],[2,3],[1,3]]
Output: [1,3]
Explanation: Entries 1, 2, and 3 form the cycle 1 - 2 - 3 - 1. Retiring [1,3] leaves the valid tree 1 - 2 - 3.
```

**Example 2:**
```
Input: links = [[1,2],[2,3],[3,4],[4,5],[2,5],[1,6]]
Output: [2,5]
Explanation: The cycle is 2 - 3 - 4 - 5 - 2. Both [3,4] and [2,5] belong to it, but [2,5] appears later, so it is the one to drop.
```$$,
  constraints = $$- `n == links.length`
- `3 <= n <= 1200`
- `links[i].length == 2`
- `1 <= links[i][0], links[i][1] <= n`
- `links[i][0] != links[i][1]`
- No two links describe the same pair
- The reference graph is connected and contains exactly one cycle$$
WHERE slug = 'duplicate-catalog-link';

UPDATE test_cases SET input = E'[[1,2],[2,3],[1,3]]', expected_output = '[1,3]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'duplicate-catalog-link')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[1,2],[2,3],[3,4],[4,5],[2,5],[1,6]]', expected_output = '[2,5]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'duplicate-catalog-link')
  AND is_sample = TRUE AND order_index = 2;

-- irrigation-pipe-plan
UPDATE problems SET
  description = $$You are laying irrigation pipe across a field where each valve has a known coordinate on the plot grid. You are given `valves`, a list where each `valves[i] = [xi, yi]` marks the position of a valve on the field map. Pipe is laid along grid-aligned trenches, so the cost of a direct pipe between valves `i` and `j` is the Manhattan distance `|xi - xj| + |yi - yj|` in meters.

Return the **minimum total pipe length** required so that every valve is reachable from every other valve, either through a direct pipe or a chain of intermediate valves.

**Example 1:**
```
Input: valves = [[4,4],[4,3],[6,7],[10,2]]
Output: 13
Explanation: Laying pipes [4,4]-[4,3] (length 1), [4,4]-[6,7] (length 5), and [4,3]-[10,2] (length 7) connects every valve for a total of 13 meters.
```

**Example 2:**
```
Input: valves = [[0,0],[2,0]]
Output: 2
Explanation: Only one pipe of length 2 is needed to join the two valves.
```$$,
  constraints = $$- `1 <= valves.length <= 1200`
- `-10^8 <= xi, yi <= 10^8`
- All valve coordinates are distinct$$
WHERE slug = 'irrigation-pipe-plan';

UPDATE test_cases SET input = E'[[4,4],[4,3],[6,7],[10,2]]', expected_output = '13'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'irrigation-pipe-plan')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[0,0],[2,0]]', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'irrigation-pipe-plan')
  AND is_sample = TRUE AND order_index = 2;

-- flooded-corridor-crossing
UPDATE problems SET
  description = $$Heavy rain is flooding a downtown `n x n` grid of intersections. You are given `elevation`, an `n x n` matrix where `elevation[r][c]` is the deck height of the intersection at row `r`, column `c`. Water rises at a steady rate: at time `t`, every intersection with elevation `<= t` is drivable, every intersection with elevation `> t` is impassable.

A response vehicle starts at `(0, 0)` and needs to reach `(n - 1, n - 1)`. From any drivable intersection it may move to a drivable 4-neighbor (up, down, left, right). Return the **minimum water level `t`** at which such a route first exists.

**Example 1:**
```
Input: elevation = [[1,0],[2,3]]
Output: 3
Explanation: The destination itself has deck height 3, so no route can exist before `t = 3`. At `t = 3` every cell is drivable.
```

**Example 2:**
```
Input: elevation = [[0,3,1,2],[7,4,5,8],[11,13,15,12],[6,9,10,14]]
Output: 14
Explanation: The lowest peak along the best route (0,0) -> (1,0) -> (2,0) -> (3,0) -> (3,1) -> (3,2) -> (3,3) is 14, the deck height of the destination itself.
```$$,
  constraints = $$- `n == elevation.length == elevation[i].length`
- `1 <= n <= 60`
- `0 <= elevation[r][c] < n * n`
- Every deck height in `elevation` is distinct$$
WHERE slug = 'flooded-corridor-crossing';

UPDATE test_cases SET input = E'[[1,0],[2,3]]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flooded-corridor-crossing')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[0,3,1,2],[7,4,5,8],[11,13,15,12],[6,9,10,14]]', expected_output = '14'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flooded-corridor-crossing')
  AND is_sample = TRUE AND order_index = 2;

-- transit-alert-wave
UPDATE problems SET
  description = $$A subway operations center broadcasts a service alert from one station and wants to know when the last affected station receives it. The rail system has `n` stations labeled `1` through `n`. You are given `links`, a list of one-way alert relays where each `links[i] = [source, target, minutes]` means a relay fires from station `source` to station `target` after `minutes` minutes. Alerts propagate through every outgoing relay simultaneously, and each station rebroadcasts as soon as it first receives the alert.

Given the broadcast origin `src`, return the **minimum number of minutes** until every station has received the alert. If at least one station can never receive the alert from `src`, return `-1`.

**Example 1:**
```
Input: links = [[1,2,4],[1,3,2],[3,2,1],[2,4,3],[3,4,7]], n = 4, src = 1
Output: 6
Explanation: Station 3 hears the alert at minute 2, station 2 hears it at minute 3 (via 1 -> 3 -> 2), and station 4 hears it at minute 6 (via 1 -> 3 -> 2 -> 4). The slowest station finishes at minute 6.
```

**Example 2:**
```
Input: links = [[1,2,5]], n = 3, src = 1
Output: -1
Explanation: No relay leads to station 3, so it never receives the alert.
```$$,
  constraints = $$- `1 <= n <= 120`
- `1 <= links.length <= 6500`
- `links[i].length == 3`
- `1 <= source, target <= n` and `source != target`
- `1 <= minutes <= 120`
- Every `(source, target)` pair is unique$$
WHERE slug = 'transit-alert-wave';

UPDATE test_cases SET input = E'[[1,2,4],[1,3,2],[3,2,1],[2,4,3],[3,4,7]]\n4\n1', expected_output = '6'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'transit-alert-wave')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[1,2,5]]\n3\n1', expected_output = '-1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'transit-alert-wave')
  AND is_sample = TRUE AND order_index = 2;

-- scene-shoot-order
UPDATE problems SET
  description = $$A production coordinator has a stack of lowercase-letter scene tags that were pre-sorted by a studio's custom priority order — an unknown permutation of the 26 letters that tells the crew which scenes to block first. You are given `cues`, the pre-sorted list of scene tags. Recover the studio's internal letter ordering as a single string so the next call sheet can respect it.

If two adjacent tags contradict any possible ordering (for example, a longer tag appears before a shorter tag that is its prefix), return the empty string `""`. When a consistent ordering is possible, the input is designed so that exactly one such ordering exists for the letters that actually appear in `cues`.

**Example 1:**
```
Input: cues = ["ab","ba","bc","cb","cd","dc"]
Output: "abcd"
Explanation: Adjacent pairs give a before b, a before c, b before c, b before d, and c before d. The only consistent ordering of the letters a, b, c, d is a -> b -> c -> d.
```

**Example 2:**
```
Input: cues = ["studio","stud"]
Output: ""
Explanation: The tag "stud" is a prefix of "studio" but appears after it, which no letter ordering can justify, so the input is inconsistent.
```$$,
  constraints = $$- `cues` contains at least one tag
- Each tag is a non-empty string of lowercase English letters
- When a valid ordering exists, the test inputs are shaped so that exactly one ordering of the letters appearing in `cues` is consistent with all adjacent-pair constraints$$
WHERE slug = 'scene-shoot-order';

UPDATE test_cases SET input = E'["ab","ba","bc","cb","cd","dc"]', expected_output = 'abcd'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'scene-shoot-order')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'["studio","stud"]', expected_output = ''
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'scene-shoot-order')
  AND is_sample = TRUE AND order_index = 2;

-- match-recipe-ingredients
UPDATE problems SET
  description = $$In a bakery's recipe book, two formulas are considered equivalent if they call for the same multiset of ingredient tokens — regardless of the order they were written down. Given two ingredient-code strings `recipeA` and `recipeB`, each a concatenation of lowercase letters representing ingredient tokens, implement `matchRecipe` to return `true` when the two recipes use exactly the same tokens with the same counts, and `false` otherwise.

If the two strings differ in length, they cannot be equivalent.

**Example 1:**
```
Input: recipeA = "butter", recipeB = "bruett"
Output: true
Explanation: Both recipes use one 'b', one 'u', one 'e', one 'r', and two 't' tokens.
```

**Example 2:**
```
Input: recipeA = "yeast", recipeB = "toast"
Output: false
Explanation: recipeA contains 'y' and 'e' which recipeB does not have, so the multisets differ.
```$$,
  constraints = $$- `1 <= recipeA.length, recipeB.length <= 4 * 10^4`
- `recipeA` and `recipeB` consist of lowercase English letters.$$
WHERE slug = 'match-recipe-ingredients';

UPDATE test_cases SET input = E'butter\nbruett', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'match-recipe-ingredients')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'yeast\ntoast', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'match-recipe-ingredients')
  AND is_sample = TRUE AND order_index = 2;

-- cluster-barrel-signatures
UPDATE problems SET
  description = $$A cellar master has labeled each oak barrel with a lowercase tasting-note string. Two barrels share a **signature** when their labels are permutations of the same multiset of letters — i.e. the barrels express the same notes, just written in a different sequence. Given an array `labels` of barrel tasting-note strings, implement `clusterBarrels` to group labels that share a signature and return the clusters.

Each inner list of labels should be sorted lexicographically, and the outer list should be sorted lexicographically by each group's first label.

**Example 1:**
```
Input: labels = ["oakvanilla","vanillaoak","plum","lump","berrytannin","tanninberry","oak"]
Output: [["berrytannin","tanninberry"],["lump","plum"],["oak"],["oakvanilla","vanillaoak"]]
```

**Example 2:**
```
Input: labels = ["merlot"]
Output: [["merlot"]]
```$$,
  constraints = $$- `1 <= labels.length <= 8 * 10^3`
- `0 <= labels[i].length <= 100`
- `labels[i]` consists of lowercase English letters.$$
WHERE slug = 'cluster-barrel-signatures';

UPDATE test_cases SET input = E'["oakvanilla","vanillaoak","plum","lump","berrytannin","tanninberry","oak"]', expected_output = '[["berrytannin","tanninberry"],["lump","plum"],["oak"],["oakvanilla","vanillaoak"]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cluster-barrel-signatures')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'["merlot"]', expected_output = '[["merlot"]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cluster-barrel-signatures')
  AND is_sample = TRUE AND order_index = 2;

-- station-throughput-shares
UPDATE problems SET
  description = $$An assembly line has several stations in series, each producing parts at an integer throughput rate per cycle. For reporting, each station's **throughput share** is defined as the product of every *other* station's rate in the line. Given an integer array `rates` where `rates[i]` is station `i`'s throughput, implement `computeStationShare` to return an array `shares` of the same length, where `shares[i]` equals the product of `rates[j]` for all `j != i`.

The product of any prefix or suffix of `rates` is guaranteed to fit in a signed 32-bit integer. Solve without division and in linear time.

**Example 1:**
```
Input: rates = [2,3,5,4]
Output: [60,40,24,30]
Explanation: For station 0: 3*5*4 = 60. For station 1: 2*5*4 = 40. And so on.
```

**Example 2:**
```
Input: rates = [-2,1,0,4,-1]
Output: [0,0,8,0,0]
Explanation: Every share except index 2 multiplies through the zero at station 2. The share for station 2 is (-2)*1*4*(-1) = 8.
```$$,
  constraints = $$- `2 <= rates.length <= 2 * 10^5`
- `-30 <= rates[i] <= 30`
- The product of any prefix or suffix of `rates` fits in a signed 32-bit integer.$$
WHERE slug = 'station-throughput-shares';

UPDATE test_cases SET input = E'[2,3,5,4]', expected_output = '[60,40,24,30]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'station-throughput-shares')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[-2,1,0,4,-1]', expected_output = '[0,0,8,0,0]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'station-throughput-shares')
  AND is_sample = TRUE AND order_index = 2;

-- sort-material-bins
UPDATE problems SET
  description = $$A recycling plant's conveyor is carrying mixed material codes that must be re-binned into three ordered categories before baling: `0` for paper, `1` for plastic, and `2` for metal. Given an integer array `materials` containing only these three codes, implement `sortMaterials` to rearrange the array **in place** so that all paper codes come first, then all plastic codes, then all metal codes.

Do not call any library sort. The operation returns nothing; the caller inspects `materials` after the call.

**Example 1:**
```
Input: materials = [1,2,0,2,1,0,1]
Output: [0,0,1,1,1,2,2]
Explanation: Two paper codes, three plastic codes, then two metal codes.
```

**Example 2:**
```
Input: materials = [2,1,0]
Output: [0,1,2]
```$$,
  constraints = $$- `1 <= materials.length <= 2 * 10^3`
- `materials[i]` is `0`, `1`, or `2`.$$
WHERE slug = 'sort-material-bins';

UPDATE test_cases SET input = E'[1,2,0,2,1,0,1]', expected_output = '[0,0,1,1,1,2,2]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sort-material-bins')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[2,1,0]', expected_output = '[0,1,2]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sort-material-bins')
  AND is_sample = TRUE AND order_index = 2;

-- repeat-tracking-codes
UPDATE problems SET
  description = $$A postal sorting station stamps each parcel with a **tracking code** between `1` and `n`, where `n` is the number of parcels scanned in the shift. An audit has flagged that some codes may have been printed on exactly two parcels by mistake, while the rest were printed on exactly one. Given the integer array `codes` of length `n` with `1 <= codes[i] <= n`, implement `listRepeatedCodes` to return every code that was scanned **exactly twice**.

The result may be returned in any order. Aim for linear time and only constant extra memory beyond the output list.

**Example 1:**
```
Input: codes = [5,2,6,3,2,1,4,6]
Output: [2,6]
Explanation: Code 2 appears at indices 1 and 4; code 6 appears at indices 2 and 7.
```

**Example 2:**
```
Input: codes = [3,3,1,2]
Output: [3]
```$$,
  constraints = $$- `n == codes.length`
- `1 <= n <= 2 * 10^5`
- `1 <= codes[i] <= n`
- Each code appears either once or twice.$$
WHERE slug = 'repeat-tracking-codes';

UPDATE test_cases SET input = E'[5,2,6,3,2,1,4,6]', expected_output = '[2,6]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'repeat-tracking-codes')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[3,3,1,2]', expected_output = '[3]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'repeat-tracking-codes')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[1,2,3,4,5]', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'repeat-tracking-codes')
  AND is_sample = TRUE AND order_index = 3;

-- detect-callnumber-clash
UPDATE problems SET
  description = $$When a cart of returned books is reshelved, a **call-number clash** occurs if any two volumes on the cart share the same integer call number — this signals either a duplicate acquisition or a mis-scan that needs review. Given an integer array `callNumbers` representing the call numbers of the volumes on the cart, implement `detectClash` to return `true` if at least one value repeats, and `false` when every call number on the cart is distinct.

**Example 1:**
```
Input: callNumbers = [7,2,9,7]
Output: true
Explanation: The call number 7 appears at index 0 and index 3.
```

**Example 2:**
```
Input: callNumbers = [11,22,33,44]
Output: false
Explanation: All four call numbers on the cart are distinct.
```$$,
  constraints = $$- `1 <= callNumbers.length <= 2 * 10^5`
- `-10^8 <= callNumbers[i] <= 10^8`$$
WHERE slug = 'detect-callnumber-clash';

UPDATE test_cases SET input = E'[7,2,9,7]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'detect-callnumber-clash')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[11,22,33,44]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'detect-callnumber-clash')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[5,8,5,3,8,1,3]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'detect-callnumber-clash')
  AND is_sample = TRUE AND order_index = 3;

-- lowest-missing-target
UPDATE problems SET
  description = $$A reshelving cart in the archives section holds books tagged with integer call numbers in `callNumbers`. The archivist wants the **smallest positive call number** that is *not* present on the cart, so she knows which classification slot to reorder next. Negative tags and zero are sorting artifacts and should be ignored.

Implement `lowestMissingTarget` to return the smallest positive integer that does not appear in `callNumbers`. The array is unsorted and may contain duplicates, zeros, or negative values. Aim for O(n) time and O(1) auxiliary space.

**Example 1:**
```
Input: callNumbers = [2,3,1,5]
Output: 4
Explanation: 1, 2, 3 are all present. 4 is the smallest positive integer absent from the cart.
```

**Example 2:**
```
Input: callNumbers = [6,-2,8,10]
Output: 1
Explanation: No copy of 1 appears on the cart, so 1 is the first missing slot.
```$$,
  constraints = $$- `1 <= callNumbers.length <= 2 * 10^5`
- `|callNumbers[i]| <= 10^8`$$
WHERE slug = 'lowest-missing-target';

UPDATE test_cases SET input = E'[2,3,1,5]', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'lowest-missing-target')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[6,-2,8,10]', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'lowest-missing-target')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[4,2,6,2,8]', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'lowest-missing-target')
  AND is_sample = TRUE AND order_index = 3;

-- unique-topic-window
UPDATE problems SET
  description = $$An ingest pipeline tags each arriving article with a single lowercase topic letter, concatenated in arrival order into a string `feed`. The editorial desk wants to display the **longest contiguous span** of the feed that touches at most `k` different topics, so a rotating banner stays coherent while it cycles.

Implement `countUniqueTopics` to return the length of the longest contiguous substring of `feed` that contains at most `k` distinct characters. If `k` is 0, return 0.

**Example 1:**
```
Input: feed = "yyxzxxz", k = 2
Output: 5
Explanation: The span "xzxxz" uses only the topics x and z and has length 5.
```

**Example 2:**
```
Input: feed = "rrrrrr", k = 1
Output: 6
Explanation: Every character is the same topic, so the whole feed fits inside one distinct topic.
```$$,
  constraints = $$- `1 <= feed.length <= 8 * 10^4`
- `0 <= k <= 50`
- `feed` consists of lowercase English letters.$$
WHERE slug = 'unique-topic-window';

UPDATE test_cases SET input = E'yyxzxxz\n2', expected_output = '5'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-topic-window')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'rrrrrr\n1', expected_output = '6'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-topic-window')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'qwerty\n1', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-topic-window')
  AND is_sample = TRUE AND order_index = 3;

-- busiest-machines-list
UPDATE problems SET
  description = $$A gym's booking system logs every machine check-in of the day as an integer machine id in `checkIns`. Management wants a flyer listing the `k` busiest machines — the ones with the highest booking counts — so they can plan maintenance rotations.

Implement `busiestMachines` to return the `k` machine ids that appear most often in `checkIns`. The ids may be returned in any order. The answer is guaranteed to be unique (no ties for the `k`-th spot).

**Example 1:**
```
Input: checkIns = [4,4,4,7,7,5], k = 2
Output: [4,7]
Explanation: Machine 4 logged 3 check-ins, machine 7 logged 2, machine 5 logged 1. The top 2 ids are 4 and 7.
```

**Example 2:**
```
Input: checkIns = [9], k = 1
Output: [9]
```$$,
  constraints = $$- `1 <= checkIns.length <= 2 * 10^5`
- `|checkIns[i]| <= 10^8`
- `k` is in the range `[1, the number of distinct machine ids in checkIns]`.
- The answer is guaranteed to be unique.$$
WHERE slug = 'busiest-machines-list';

UPDATE test_cases SET input = E'[4,4,4,7,7,5]\n2', expected_output = '[4,7]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'busiest-machines-list')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[9]\n1', expected_output = '[9]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'busiest-machines-list')
  AND is_sample = TRUE AND order_index = 2;

-- unpaired-frame-reading
UPDATE problems SET
  description = $$A night at the observatory produces a bag of raw frame brightness tags in `frames`. Every frame was captured twice (once per filter) except one lone calibration frame that was taken only once. You need to recover that unpaired reading to attach it to the calibration log.

Implement `findUnpairedFrame` to return the one integer in `frames` that appears exactly once, given that every other value appears exactly twice. Solve this in O(n) time and O(1) extra space.

**Example 1:**
```
Input: frames = [5,5,3]
Output: 3
Explanation: 5 was captured twice; 3 only once.
```

**Example 2:**
```
Input: frames = [8,2,6,2,6]
Output: 8
Explanation: 2 and 6 each appear twice. 8 is the lone reading.
```$$,
  constraints = $$- `1 <= frames.length <= 8 * 10^4`
- `|frames[i]| <= 10^8`
- Every value in `frames` appears exactly twice except one value which appears exactly once.$$
WHERE slug = 'unpaired-frame-reading';

UPDATE test_cases SET input = E'[5,5,3]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unpaired-frame-reading')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[8,2,6,2,6]', expected_output = '8'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unpaired-frame-reading')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[7]', expected_output = '7'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unpaired-frame-reading')
  AND is_sample = TRUE AND order_index = 3;

-- longest-seat-block
UPDATE problems SET
  description = $$Just before a concert goes on sale, the venue's release list `seatIds` contains the still-available seat numbers across the whole hall, jumbled together from many sections. The box office wants the length of the **longest block of consecutive seat numbers** — a contiguous run like `40, 41, 42, 43` — so they can offer it as a group hold to a travel partner.

Implement `longestSeatBlock` to return the length of the longest run of consecutive integers that can be formed from the values in `seatIds`. Duplicates should be ignored. Your solution should run in O(n) time.

**Example 1:**
```
Input: seatIds = [42,7,41,40,9,8,43]
Output: 4
Explanation: The consecutive block 40, 41, 42, 43 has length 4.
```

**Example 2:**
```
Input: seatIds = [11,13,12,15,16,14,20,19,18]
Output: 6
Explanation: The block 11, 12, 13, 14, 15, 16 has length 6.
```$$,
  constraints = $$- `0 <= seatIds.length <= 2 * 10^5`
- `|seatIds[i]| <= 10^8`$$
WHERE slug = 'longest-seat-block';

UPDATE test_cases SET input = E'[42,7,41,40,9,8,43]', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-seat-block')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[11,13,12,15,16,14,20,19,18]', expected_output = '6'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-seat-block')
  AND is_sample = TRUE AND order_index = 2;

-- next-shot-order
UPDATE problems SET
  description = $$A film crew tracks the day's shooting order as an array of integer shot slugs `shotOrder`. At the end of each day the assistant director advances the lineup to the **next lexicographically greater arrangement** of the same slugs — that becomes tomorrow's call sheet. If today's lineup is already the last one (strictly decreasing), the AD resets it to the earliest arrangement (strictly increasing).

Implement `advanceShotOrder` to rearrange `shotOrder` **in place** to the next greater permutation, or to the smallest permutation if no greater one exists. Use only constant extra memory.

**Example 1:**
```
Input: shotOrder = [2,3,4]
Output: [2,4,3]
Explanation: The next arrangement after [2,3,4] is [2,4,3].
```

**Example 2:**
```
Input: shotOrder = [5,4,3,2]
Output: [2,3,4,5]
Explanation: [5,4,3,2] is the largest arrangement, so the lineup resets to ascending order.
```$$,
  constraints = $$- `1 <= shotOrder.length <= 100`
- `0 <= shotOrder[i] <= 100`$$
WHERE slug = 'next-shot-order';

UPDATE test_cases SET input = E'[2,3,4]', expected_output = '[2,4,3]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'next-shot-order')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[5,4,3,2]', expected_output = '[2,3,4,5]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'next-shot-order')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[1,2,7,6,3]', expected_output = '[1,3,2,6,7]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'next-shot-order')
  AND is_sample = TRUE AND order_index = 3;

-- merge-reservation-windows
UPDATE problems SET
  description = $$A restaurant host tracks table reservations as `[start, end]` pairs, where each pair is the minute the party sits down and the minute they clear the table. Two seatings that share any moment (even a single endpoint) must be combined into one continuous occupancy block so the floor plan reflects a single party turning the table over.

Given a list of `seatings` where `seatings[i] = [start_i, end_i]`, implement `mergeSeatingWindows` to return the minimal list of non-overlapping windows that cover every original seating. Return the windows sorted by start time.

**Example 1:**
```
Input: seatings = [[2,5],[4,7],[9,11],[14,16]]
Output: [[2,7],[9,11],[14,16]]
Explanation: Seatings [2,5] and [4,7] share minutes 4 and 5, so they fuse into [2,7]. The other two windows stay separate.
```

**Example 2:**
```
Input: seatings = [[1,3],[3,8],[10,12]]
Output: [[1,8],[10,12]]
Explanation: [1,3] and [3,8] touch at minute 3, which counts as overlap, so they merge into [1,8].
```$$,
  constraints = $$- `1 <= seatings.length <= 2 * 10^5`
- `seatings[i].length == 2`
- `0 <= start_i <= end_i <= 10^8`$$
WHERE slug = 'merge-reservation-windows';

UPDATE test_cases SET input = E'[[2,5],[4,7],[9,11],[14,16]]', expected_output = '[[2,7],[9,11],[14,16]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-reservation-windows')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[1,3],[3,8],[10,12]]', expected_output = '[[1,8],[10,12]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-reservation-windows')
  AND is_sample = TRUE AND order_index = 2;

-- headline-majority-pick
UPDATE problems SET
  description = $$A news aggregator ingests a burst of articles and tags each one with a single topic id. The editorial desk wants to pin the topic that dominates the burst — the one that appears strictly more than half of the articles — so it can promote the corresponding cluster to the front page.

Given an integer array `topics` of size `n`, implement `majorityHeadline` to return the topic id that appears more than `n / 2` times. A dominant topic is guaranteed to exist in the input.

**Example 1:**
```
Input: topics = [4,7,4]
Output: 4
```

**Example 2:**
```
Input: topics = [5,5,6,6,6,5,6]
Output: 6
Explanation: Topic 6 appears 4 times out of 7 articles, which is more than half.
```

**Example 3:**
```
Input: topics = [9]
Output: 9
```$$,
  constraints = $$- `1 <= topics.length <= 2 * 10^5`
- `-10^8 <= topics[i] <= 10^8`
- A dominant topic always exists.$$
WHERE slug = 'headline-majority-pick';

UPDATE test_cases SET input = E'[4,7,4]', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'headline-majority-pick')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[5,5,6,6,6,5,6]', expected_output = '6'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'headline-majority-pick')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[9]', expected_output = '9'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'headline-majority-pick')
  AND is_sample = TRUE AND order_index = 3;

-- compact-shelved-copies
UPDATE problems SET
  description = $$A library intern is reshelving a run of books whose call numbers are already in non-decreasing order. Multiple copies of the same title can sit side by side, and the intern wants to compact the run so each call number appears exactly once at the front of the shelf, with the tail positions left however they were.

Given an integer array `callNumbers` sorted in non-decreasing order, implement `compactShelf` to overwrite the prefix of `callNumbers` with the unique call numbers in their original order and return `k`, the count of unique values. The first `k` positions of `callNumbers` must hold the unique sequence; positions from index `k` onward are not checked.

**Example 1:**
```
Input: callNumbers = [2,2,5]
Output: 2, callNumbers = [2,5,_]
Explanation: Return k = 2. The front of the shelf now reads 2 then 5.
```

**Example 2:**
```
Input: callNumbers = [1,1,2,2,3,4,4,6,6,6]
Output: 5, callNumbers = [1,2,3,4,6,_,_,_,_,_]
Explanation: Five distinct call numbers (1, 2, 3, 4, 6) end up at the front in their original order.
```

**Example 3:**
```
Input: callNumbers = [8]
Output: 1, callNumbers = [8]
Explanation: A shelf with one copy is already compact.
```$$,
  constraints = $$- `1 <= callNumbers.length <= 2 * 10^5`
- `-100 <= callNumbers[i] <= 100`
- `callNumbers` is sorted in non-decreasing order.$$
WHERE slug = 'compact-shelved-copies';

UPDATE test_cases SET input = E'[2,2,5]', expected_output = '2
[2,5]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'compact-shelved-copies')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[1,1,2,2,3,4,4,6,6,6]', expected_output = '5
[1,2,3,4,6]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'compact-shelved-copies')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[8]', expected_output = '1
[8]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'compact-shelved-copies')
  AND is_sample = TRUE AND order_index = 3;

-- rotate-park-map
UPDATE problems SET
  description = $$A theme park operations lead keeps a square grid of attraction wait-time readings captured from an overhead drone. When the drone's gimbal drifts 90 degrees clockwise between flights, the saved grid has to be reoriented before it's compared to yesterday's map, and the tablet at the command post is too memory-starved to hold a second grid.

Given an `n x n` integer grid `parkMap`, implement `rotateParkMap` to rotate the grid by 90 degrees clockwise **in-place**. You must mutate `parkMap` directly — no second `n x n` grid may be allocated.

**Example 1:**
```
Input: parkMap = [[2,4,6],[8,1,3],[5,7,9]]
Output: [[5,8,2],[7,1,4],[9,3,6]]
```

**Example 2:**
```
Input: parkMap = [[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]
Output: [[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]
```$$,
  constraints = $$- `n == parkMap.length == parkMap[i].length`
- `1 <= n <= 20`
- `-1000 <= parkMap[i][j] <= 1000`$$
WHERE slug = 'rotate-park-map';

UPDATE test_cases SET input = E'[[2,4,6],[8,1,3],[5,7,9]]', expected_output = '[[5,8,2],[7,1,4],[9,3,6]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rotate-park-map')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]', expected_output = '[[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rotate-park-map')
  AND is_sample = TRUE AND order_index = 2;

-- species-grid-validator
UPDATE problems SET
  description = $$An aquarium facility lays out its display tanks as a large square grid partitioned into nine equal rectangular wings. A curator assigns each tank a species code (a digit `1`-`9`) or leaves it empty (`.`) during planning. House rules say no species may repeat within a single row of tanks, within a single column, or within any one of the nine wings — even if many tanks are still unassigned.

Given the partially filled grid `grid`, implement `verifySpeciesGrid` to return `true` if every filled cell obeys all three rules and `false` otherwise. Empty cells are never in violation, and the plan does not need to be completable — only the cells already placed are checked.

**Example 1:**
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

**Example 2:**
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
  constraints = $$- `grid.length == 9`
- `grid[i].length == 9`
- Each `grid[i][j]` is a digit `1`-`9` or the character `'.'`.$$
WHERE slug = 'species-grid-validator';

UPDATE test_cases SET input = E'[[".",".",".",".",".",".",".",".","."],[".","1",".",".","2",".",".","3","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".","4",".",".","5",".",".","6","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".","7",".",".","8",".",".","9","."],[".",".",".",".",".",".",".",".","."]]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'species-grid-validator')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[".",".",".",".",".",".",".",".","."],[".","1",".",".","2",".",".","1","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".","4",".",".","5",".",".","6","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".","7",".",".","8",".",".","9","."],[".",".",".",".",".",".",".",".","."]]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'species-grid-validator')
  AND is_sample = TRUE AND order_index = 2;

-- event-window-tally
UPDATE problems SET
  description = $$A weather station logs hourly anomaly `readings` — positive values for hours that ran hot, negative for hours that ran cool, zero for baseline. A climatologist wants to count how many contiguous hour-windows have anomalies that sum to exactly `k`, because those windows correspond to energy-balanced spells worth flagging for the monthly report.

Given the reading array `readings` and an integer target `k`, implement `countWindowTallies` to return the total number of contiguous subarrays of `readings` whose values sum to `k`. Since readings may be negative, a simple sliding window won't work directly.

**Example 1:**
```
Input: readings = [2,2,2], k = 4
Output: 2
Explanation: The windows readings[0..1] and readings[1..2] each sum to 4.
```

**Example 2:**
```
Input: readings = [3,1,2,4], k = 6
Output: 2
Explanation: The windows [3,1,2] and [2,4] both sum to 6.
```

**Example 3:**
```
Input: readings = [4,-4,0], k = 0
Output: 3
Explanation: [4,-4], [4,-4,0], and [0] each sum to 0.
```$$,
  constraints = $$- `1 <= readings.length <= 2 * 10^5`
- `-1000 <= readings[i] <= 1000`
- `-10^7 <= k <= 10^7`$$
WHERE slug = 'event-window-tally';

UPDATE test_cases SET input = E'[2,2,2]\n4', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'event-window-tally')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[3,1,2,4]\n6', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'event-window-tally')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[4,-4,0]\n0', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'event-window-tally')
  AND is_sample = TRUE AND order_index = 3;

-- station-visit-orders
UPDATE problems SET
  description = $$On a manufacturing line, a single part must pass through every station in some order before it is boxed. Given an array `stations` of distinct station IDs, return every possible order in which the part could visit each station exactly once.

Implement `listStationOrders` to return a list of all such orderings. Any ordering of the outer list is acceptable.

**Example 1:**
```
Input: stations = [4,7,2]
Output: [[4,7,2],[4,2,7],[7,4,2],[7,2,4],[2,4,7],[2,7,4]]
Explanation: Three distinct stations give 3! = 6 possible visit orders.
```

**Example 2:**
```
Input: stations = [5,9]
Output: [[5,9],[9,5]]
```$$,
  constraints = $$- `1 <= stations.length <= 6`
- `-10 <= stations[i] <= 10`
- All entries of `stations` are distinct.$$
WHERE slug = 'station-visit-orders';

UPDATE test_cases SET input = E'[4,7,2]', expected_output = '[[4,7,2],[4,2,7],[7,4,2],[7,2,4],[2,4,7],[2,7,4]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'station-visit-orders')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[5,9]', expected_output = '[[5,9],[9,5]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'station-visit-orders')
  AND is_sample = TRUE AND order_index = 2;

-- enumerate-barrel-blends
UPDATE problems SET
  description = $$At a vineyard, a cellar master wants to catalog every possible blend that could be poured from a set of numbered barrels. Each barrel has a distinct ID and any subset of barrels — including the empty pour and the complete mix — counts as a valid blend.

Given an array `barrels` of distinct barrel IDs, implement `listBarrelBlends` to return every possible blend. The outer list may be in any order, but each inner blend must preserve the relative order in which its barrels appear in `barrels`.

**Example 1:**
```
Input: barrels = [2,5,8]
Output: [[],[2],[2,5],[2,5,8],[2,8],[5],[5,8],[8]]
Explanation: With 3 barrels there are 2^3 = 8 possible blends.
```

**Example 2:**
```
Input: barrels = [7]
Output: [[],[7]]
```$$,
  constraints = $$- `1 <= barrels.length <= 10`
- `-10 <= barrels[i] <= 10`
- All entries of `barrels` are distinct.$$
WHERE slug = 'enumerate-barrel-blends';

UPDATE test_cases SET input = E'[2,5,8]', expected_output = '[[],[2],[2,5],[2,5,8],[2,8],[5],[5,8],[8]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'enumerate-barrel-blends')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[7]', expected_output = '[[],[7]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'enumerate-barrel-blends')
  AND is_sample = TRUE AND order_index = 2;

-- split-zone-codes
UPDATE problems SET
  description = $$A postal sorter prints long digit strings on the side of each parcel, and a routing clerk must punctuate them into a canonical **zone code** of exactly four segments separated by dots. Each segment is an integer from `0` through `255`, and a segment must not carry a leading zero unless the segment is itself `"0"`.

Given a string `digits` containing only decimal digits, implement `splitZoneCodes` to return every valid zone code that can be produced by inserting exactly three dots into `digits`. Return the list sorted in lexicographic order. If no valid zone code exists, return an empty list.

**Example 1:**
```
Input: digits = "19216811"
Output: ["1.92.168.11","19.2.168.11","19.21.68.11","19.216.8.11","19.216.81.1","192.1.68.11","192.16.8.11","192.16.81.1","192.168.1.1"]
```

**Example 2:**
```
Input: digits = "0202"
Output: ["0.2.0.2"]
Explanation: Single-digit segments may be "0". A two-digit segment beginning with "0" would be rejected.
```$$,
  constraints = $$- `1 <= digits.length <= 20`
- `digits` consists of decimal digits only.$$
WHERE slug = 'split-zone-codes';

UPDATE test_cases SET input = E'19216811', expected_output = '["1.92.168.11","19.2.168.11","19.21.68.11","19.216.8.11","19.216.81.1","192.1.68.11","192.16.8.11","192.16.81.1","192.168.1.1"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-zone-codes')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'0202', expected_output = '["0.2.0.2"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-zone-codes')
  AND is_sample = TRUE AND order_index = 2;

-- mirror-headline-splits
UPDATE problems SET
  description = $$An editor at a news aggregator wants to chop a lowercased headline into a run of sub-phrases such that every sub-phrase reads the same forward and backward. A sub-phrase may be a single letter.

Given a string `headline`, implement `splitMirrorPhrases` to return every possible ordered partition of `headline` into mirror-shaped sub-phrases. Each partition must cover the entire headline from left to right with no reordering. The outer list may be returned in any order.

**Example 1:**
```
Input: headline = "dbbc"
Output: [["d","b","b","c"],["d","bb","c"]]
Explanation: Two valid partitions. Every piece — "d", "b", "bb", "c" — is a palindrome.
```

**Example 2:**
```
Input: headline = "ef"
Output: [["e","f"]]
Explanation: "ef" is not a palindrome, so the only valid partition is letter-by-letter.
```$$,
  constraints = $$- `1 <= headline.length <= 16`
- `headline` consists of lowercase English letters only.$$
WHERE slug = 'mirror-headline-splits';

UPDATE test_cases SET input = E'dbbc', expected_output = '[["d","b","b","c"],["d","bb","c"]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'mirror-headline-splits')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'ef', expected_output = '[["e","f"]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'mirror-headline-splits')
  AND is_sample = TRUE AND order_index = 2;

-- keypad-device-codes
UPDATE problems SET
  description = $$A smart-home hub arms itself when the user types a short digit sequence on a wall keypad, but each digit encodes multiple letters — just like a legacy phone keypad — and the firmware has to enumerate every letter code the sequence could possibly represent. The digit-to-letter mapping is:

- `2`: `abc`
- `3`: `def`
- `4`: `ghi`
- `5`: `jkl`
- `6`: `mno`
- `7`: `pqrs`
- `8`: `tuv`
- `9`: `wxyz`

Given a string `digits` of characters drawn from `2`–`9`, implement `mapKeypadCodes` to return every letter code that could match. The result may be returned in any order. If `digits` is empty, return an empty list.

**Example 1:**
```
Input: digits = "45"
Output: ["gj","gk","gl","hj","hk","hl","ij","ik","il"]
Explanation: Digit 4 maps to "ghi" and digit 5 maps to "jkl"; every pairing of one letter from each slot is included.
```

**Example 2:**
```
Input: digits = ""
Output: []
```$$,
  constraints = $$- `0 <= digits.length <= 4`
- Every character of `digits` is a digit in the range `'2'`–`'9'`.$$
WHERE slug = 'keypad-device-codes';

UPDATE test_cases SET input = E'45', expected_output = '["gj","gk","gl","hj","hk","hl","ij","ik","il"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'keypad-device-codes')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'keypad-device-codes')
  AND is_sample = TRUE AND order_index = 2;

-- taxiway-aircraft-layout
UPDATE problems SET
  description = $$An apron scheduler at a regional airport needs to park `n` aircraft on an `n x n` apron grid (one aircraft per row) while honoring wake-separation rules. Two aircraft conflict if they occupy the same column, the same NW-to-SE diagonal, or the same NE-to-SW diagonal of the grid.

Given the grid side length `n`, implement `placeAircraft` to return every distinct conflict-free layout. Each layout is a list of `n` strings of length `n`, where `'Q'` marks a parked aircraft and `'.'` marks an empty stand. Return an empty list if no layout exists. Layouts may be returned in any order.

**Example 1:**
```
Input: n = 5
Output: [["Q....","..Q..","....Q",".Q...","...Q."],["Q....","...Q.",".Q...","....Q","..Q.."],[".Q...","...Q.","Q....","..Q..","....Q"],[".Q...","....Q","..Q..","Q....","...Q."],["..Q..","Q....","...Q.",".Q...","....Q"],["..Q..","....Q",".Q...","...Q.","Q...."],["...Q.","Q....","..Q..","....Q",".Q..."],["...Q.",".Q...","....Q","..Q..","Q...."],["....Q",".Q...","...Q.","Q....","..Q.."],["....Q","..Q..","Q....","...Q.",".Q..."]]
Explanation: Ten non-conflicting layouts exist on a 5 x 5 apron.
```

**Example 2:**
```
Input: n = 3
Output: []
Explanation: No conflict-free layout exists on a 3 x 3 apron.
```$$,
  constraints = $$- `1 <= n <= 10`$$
WHERE slug = 'taxiway-aircraft-layout';

UPDATE test_cases SET input = E'5', expected_output = '[["Q....","..Q..","....Q",".Q...","...Q."],["Q....","...Q.",".Q...","....Q","..Q.."],[".Q...","...Q.","Q....","..Q..","....Q"],[".Q...","....Q","..Q..","Q....","...Q."],["..Q..","Q....","...Q.",".Q...","....Q"],["..Q..","....Q",".Q...","...Q.","Q...."],["...Q.","Q....","..Q..","....Q",".Q..."],["...Q.",".Q...","....Q","..Q..","Q...."],["....Q",".Q...","...Q.","Q....","..Q.."],["....Q","..Q..","Q....","...Q.",".Q..."]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'taxiway-aircraft-layout')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'3', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'taxiway-aircraft-layout')
  AND is_sample = TRUE AND order_index = 2;

-- voucher-price-combos
UPDATE problems SET
  description = $$A grocery chain is promoting a new house-brand line and wants to list every way a shopper can build a basket whose total matches a fixed voucher amount. The store offers a small catalogue of distinct item prices, and each item can be placed in the basket any number of times (shelves are well stocked).

Given an array `prices` of distinct positive integer prices and a positive integer `voucher`, implement `listVoucherSums` to return every unique basket whose prices sum exactly to `voucher`. Each basket is a list of prices (repeats allowed). Two baskets are considered different if they differ in how many times at least one price appears. Return the baskets in any order.

**Example 1:**
```
Input: prices = [2,4,5], voucher = 9
Output: [[2,2,5],[4,5]]
Explanation: 2 + 2 + 5 = 9 and 4 + 5 = 9 are the only two baskets that match the voucher.
```

**Example 2:**
```
Input: prices = [3,4,7], voucher = 10
Output: [[3,3,4],[3,7]]
```$$,
  constraints = $$- `1 <= prices.length <= 30`
- `2 <= prices[i] <= 40`
- All elements of `prices` are distinct.
- `1 <= voucher <= 40`$$
WHERE slug = 'voucher-price-combos';

UPDATE test_cases SET input = E'[2,4,5]\n9', expected_output = '[[2,2,5],[4,5]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'voucher-price-combos')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[3,4,7]\n10', expected_output = '[[3,3,4],[3,7]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'voucher-price-combos')
  AND is_sample = TRUE AND order_index = 2;

-- batch-quota-combos
UPDATE problems SET
  description = $$A print shop groups incoming `jobs` by page count and needs to report every distinct set of jobs whose pages add up exactly to a given press-run `quota`. The job list can contain jobs with the same page count (since multiple clients can submit equally-sized jobs), but each job may be used in a set at most once.

Given an integer array `jobs` representing page counts (possibly with repeats) and a positive integer `quota`, implement `listQuotaBatches` to return every unique set of job page counts summing exactly to `quota`. Two sets are considered the same if they contain the same multiset of page counts, so duplicate multisets must be excluded. Return the sets in any order.

**Example 1:**
```
Input: jobs = [2,3,6,1,3,4], quota = 7
Output: [[1,2,4],[1,3,3],[1,6],[3,4]]
```

**Example 2:**
```
Input: jobs = [4,2,1,2,3], quota = 5
Output: [[1,2,2],[1,4],[2,3]]
```

**Example 3:**
```
Input: jobs = [8,8,8], quota = 16
Output: [[8,8]]
Explanation: Although the value 8 appears three times, the only multiset of job sizes that adds to 16 is a pair of 8s.
```$$,
  constraints = $$- `1 <= jobs.length <= 100`
- `1 <= jobs[i] <= 50`
- `1 <= quota <= 30`$$
WHERE slug = 'batch-quota-combos';

UPDATE test_cases SET input = E'[2,3,6,1,3,4]\n7', expected_output = '[[1,2,4],[1,3,3],[1,6],[3,4]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'batch-quota-combos')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[4,2,1,2,3]\n5', expected_output = '[[1,2,2],[1,4],[2,3]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'batch-quota-combos')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[8,8,8]\n16', expected_output = '[[8,8]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'batch-quota-combos')
  AND is_sample = TRUE AND order_index = 3;

-- montage-scene-picks
UPDATE problems SET
  description = $$A film editor is assembling a clip reel for a sizzle trailer and wants to preview every possible montage of scenes. Each scene is represented by its duration code (an integer), and the duration code list `scenes` may contain repeats because short interstitial cuts often share the same length.

Given the integer array `scenes`, implement `listMontageScenes` to return the full power set of montages, where each montage is a list of duration codes. Two montages are considered identical when they contain the same multiset of codes, so duplicate montages must not appear in the result. Include the empty montage. You may return the montages in any order.

**Example 1:**
```
Input: scenes = [2,5,5]
Output: [[],[2],[2,5],[2,5,5],[5],[5,5]]
```

**Example 2:**
```
Input: scenes = [5]
Output: [[],[5]]
```

**Example 3:**
```
Input: scenes = [2,2,2,1,2]
Output: [[],[1],[1,2],[1,2,2],[1,2,2,2],[1,2,2,2,2],[2],[2,2],[2,2,2],[2,2,2,2]]
Explanation: The value 2 appears four times and 1 appears once; each distinct multiset of selected codes appears exactly once in the output.
```$$,
  constraints = $$- `1 <= scenes.length <= 10`
- `-10 <= scenes[i] <= 10`$$
WHERE slug = 'montage-scene-picks';

UPDATE test_cases SET input = E'[2,5,5]', expected_output = '[[],[2],[2,5],[2,5,5],[5],[5,5]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'montage-scene-picks')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[5]', expected_output = '[[],[5]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'montage-scene-picks')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[2,2,2,1,2]', expected_output = '[[],[1],[1,2],[1,2,2],[1,2,2,2],[1,2,2,2,2],[2],[2,2],[2,2,2],[2,2,2,2]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'montage-scene-picks')
  AND is_sample = TRUE AND order_index = 3;

-- zone-letter-trail
UPDATE problems SET
  description = $$A theme-park wayfinding team encodes each zone on the park map with a single letter, producing an `m x n` grid `park` of letter codes. Guests hunt for hidden codewords by walking between orthogonally adjacent zones (up, down, left, or right), never revisiting a zone within a single trace.

Given the letter grid `park` and a target `codeword`, implement `traceZonePath` to return `true` if some path of orthogonally adjacent zones spells `codeword` exactly, using each zone at most once per trace. Otherwise return `false`.

**Example 1:**
```
Input: park = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], codeword = "PEAK"
Output: true
```

**Example 2:**
```
Input: park = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], codeword = "NOID"
Output: true
```

**Example 3:**
```
Input: park = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], codeword = "PARK"
Output: false
```$$,
  constraints = $$- `m == park.length`
- `n == park[i].length`
- `1 <= m, n <= 8`
- `1 <= codeword.length <= 20`
- `park` and `codeword` consist of only uppercase and lowercase English letters.$$
WHERE slug = 'zone-letter-trail';

UPDATE test_cases SET input = E'[["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]]\nPEAK', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'zone-letter-trail')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]]\nNOID', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'zone-letter-trail')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]]\nPARK', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'zone-letter-trail')
  AND is_sample = TRUE AND order_index = 3;

-- locate-call-number
UPDATE problems SET
  description = $$A reference librarian keeps every volume on a single long shelf ordered by call number. Given `shelf`, an array of unique call numbers sorted in ascending order, and a `query` call number, return the shelf position (0-indexed) of the book whose call number equals `query`, or `-1` if no such book has been cataloged yet.

Your lookup must finish in `O(log n)` time so the reference desk can answer patrons without scanning the whole stack.

**Example 1:**
```
Input: shelf = [102,145,201,247,318,402,510,633], query = 318
Output: 4
Explanation: The call number 318 sits at position 4 on the shelf.
```

**Example 2:**
```
Input: shelf = [102,145,201,247,318,402,510,633], query = 200
Output: -1
Explanation: No book with call number 200 has been cataloged.
```$$,
  constraints = $$- `1 <= shelf.length <= 2 * 10^5`
- `|shelf[i]| <= 10^8`
- `|query| <= 10^8`
- All call numbers in `shelf` are unique.
- `shelf` is sorted in strictly ascending order.$$
WHERE slug = 'locate-call-number';

UPDATE test_cases SET input = E'[102,145,201,247,318,402,510,633]\n318', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'locate-call-number')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[102,145,201,247,318,402,510,633]\n200', expected_output = '-1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'locate-call-number')
  AND is_sample = TRUE AND order_index = 2;

-- pinpoint-peak-reading
UPDATE problems SET
  description = $$A weather station aggregates an afternoon of temperature `readings` taken from a single sensor. A **peak reading** is one that is strictly greater than both of its adjacent samples; boundary readings only need to beat their single neighbor, so treat positions just outside the array as having temperature `-infinity`.

Return the index of any peak reading in `readings`. If several peaks exist, any one of their indices is a valid answer. Your routine must run in `O(log n)` time because the operator scrubs through long log files.

**Example 1:**
```
Input: readings = [11,18,22,19,15]
Output: 2
Explanation: readings[2] = 22 is strictly greater than both neighbors (18 and 19).
```

**Example 2:**
```
Input: readings = [3,7,12,25,20,14,9]
Output: 3
Explanation: readings[3] = 25 towers over readings[2] = 12 and readings[4] = 20.
```$$,
  constraints = $$- `1 <= readings.length <= 2 * 10^3`
- `|readings[i]| <= 10^8`
- `readings[i] != readings[i + 1]` for every valid `i`.$$
WHERE slug = 'pinpoint-peak-reading';

UPDATE test_cases SET input = E'[11,18,22,19,15]', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pinpoint-peak-reading')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[3,7,12,25,20,14,9]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pinpoint-peak-reading')
  AND is_sample = TRUE AND order_index = 2;

-- slowest-conveyor-speed
UPDATE problems SET
  description = $$At a recycling plant, the floor supervisor has `n` bins waiting to be processed, where `piles[i]` is the kilograms of material in bin `i`. A truck arrives to haul everything away in `hours` hours.

A single conveyor feeds the sorter at a constant integer speed `k` kilograms per hour. During each hour the conveyor pulls from exactly one bin: if that bin still holds at least `k` kilograms it removes `k`, otherwise it empties the bin and the remainder of the hour is wasted.

Return the slowest integer speed `k` that lets the sorter empty every bin before the truck arrives.

**Example 1:**
```
Input: piles = [5,8,12,20], hours = 9
Output: 6
Explanation: At speed 6 the hours per bin are ceil(5/6)=1, ceil(8/6)=2, ceil(12/6)=2, ceil(20/6)=4, totaling 9.
```

**Example 2:**
```
Input: piles = [40,25,18,33,12], hours = 5
Output: 40
Explanation: With 5 bins and only 5 hours, every bin must clear in a single hour.
```

**Example 3:**
```
Input: piles = [40,25,18,33,12], hours = 7
Output: 25
```$$,
  constraints = $$- `1 <= piles.length <= 2 * 10^5`
- `piles.length <= hours <= 10^8`
- `1 <= piles[i] <= 10^8`$$
WHERE slug = 'slowest-conveyor-speed';

UPDATE test_cases SET input = E'[5,8,12,20]\n9', expected_output = '6'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'slowest-conveyor-speed')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[40,25,18,33,12]\n5', expected_output = '40'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'slowest-conveyor-speed')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[40,25,18,33,12]\n7', expected_output = '25'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'slowest-conveyor-speed')
  AND is_sample = TRUE AND order_index = 3;

-- detect-flow-value
UPDATE problems SET
  description = $$A traffic-ops team stores per-minute vehicle counts in an `m x n` grid `flows` that covers a corridor. The grid is globally sorted: every row is non-decreasing left to right, and the first entry of every row is greater than the last entry of the previous row. In other words, reading the grid in row-major order yields one ascending sequence.

Given a target flow `target`, return `true` if some cell of `flows` records exactly that value, and `false` otherwise. The search must finish in `O(log(m * n))` time so the dashboard stays responsive.

**Example 1:**
```
Input: flows = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 22
Output: true
Explanation: Row 1, column 2 holds the value 22.
```

**Example 2:**
```
Input: flows = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 9
Output: false
Explanation: No cell records a flow of 9.
```$$,
  constraints = $$- `m == flows.length`
- `n == flows[i].length`
- `1 <= m, n <= 120`
- `|flows[i][j]| <= 10^8`
- `|target| <= 10^8`$$
WHERE slug = 'detect-flow-value';

UPDATE test_cases SET input = E'[[2,4,8,13],[15,19,22,28],[31,37,44,52]]\n22', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'detect-flow-value')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[2,4,8,13],[15,19,22,28],[31,37,44,52]]\n9', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'detect-flow-value')
  AND is_sample = TRUE AND order_index = 2;

-- probe-sugar-reading
UPDATE problems SET
  description = $$A vineyard lays out its fermentation cellar as an `m x n` grid `brix` of Brix sugar readings. The layout is staged carefully so that each row is sorted left to right in ascending order and each column is sorted top to bottom in ascending order. Unlike a fully flattened sorted table, the first reading in a row is not necessarily larger than the last reading of the row above it.

Given a probe value `target`, return `true` if some barrel records exactly `target` and `false` otherwise.

**Example 1:**
```
Input: brix = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 14
Output: true
```

**Example 2:**
```
Input: brix = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 24
Output: false
```

**Example 3:**
```
Input: brix = [[-4,-1],[3,5]], target = -1
Output: true
Explanation: -1 sits in the first row, second column.
```$$,
  constraints = $$- `m == brix.length`
- `n == brix[i].length`
- `1 <= m, n <= 250`
- `|brix[i][j]| <= 10^8`
- `|target| <= 10^8`$$
WHERE slug = 'probe-sugar-reading';

UPDATE test_cases SET input = E'[[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]]\n14', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'probe-sugar-reading')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]]\n24', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'probe-sugar-reading')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[[-4,-1],[3,5]]\n-1', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'probe-sugar-reading')
  AND is_sample = TRUE AND order_index = 3;

-- locate-terminus-station
UPDATE problems SET
  description = $$A subway operations desk keeps the line's stations as an array of unique fare-zone numbers, originally listed in ascending order from yard to terminus. Each night the dispatcher rotates the list between `1` and `n` times so that it starts at whichever station opens the morning run; a rotation shifts every entry one position to the right and wraps the last entry to the front.

Given the rotated `stations` array with distinct values, return the smallest fare-zone number, which identifies the line's terminus station. Your routine must run in `O(log n)` time.

**Example 1:**
```
Input: stations = [7,9,12,2,5]
Output: 2
Explanation: The sorted list was [2,5,7,9,12] rotated 3 times, so 2 is the terminus.
```

**Example 2:**
```
Input: stations = [15,20,24,31,3,8,12]
Output: 3
```

**Example 3:**
```
Input: stations = [21,33,45,58]
Output: 21
Explanation: No rotation was applied tonight, so the first entry is the terminus.
```$$,
  constraints = $$- `n == stations.length`
- `1 <= n <= 6000`
- `|stations[i]| <= 10^8`
- All values in `stations` are unique.
- `stations` is an ascending list rotated between `1` and `n` times.$$
WHERE slug = 'locate-terminus-station';

UPDATE test_cases SET input = E'[7,9,12,2,5]', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'locate-terminus-station')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[15,20,24,31,3,8,12]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'locate-terminus-station')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[21,33,45,58]', expected_output = '21'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'locate-terminus-station')
  AND is_sample = TRUE AND order_index = 3;

-- spot-catalog-target
UPDATE problems SET
  description = $$An observatory keeps its target catalog as an ascending list of unique right-ascension codes. At the start of each night the night assistant rotates the list at an unknown pivot so it begins with the first object above the horizon; for example the catalog `[10,14,18,22,25,28,33]` might open as `[25,28,33,10,14,18,22]`.

Given the rotated `catalog` array and a `target` code, return the index where `target` appears in `catalog`, or `-1` if the object is not in tonight's listing. Your routine must run in `O(log n)` time.

**Example 1:**
```
Input: catalog = [12,18,24,31,3,7,9], target = 3
Output: 4
Explanation: The catalog holds 3 at index 4 after rotation.
```

**Example 2:**
```
Input: catalog = [12,18,24,31,3,7,9], target = 15
Output: -1
Explanation: No entry matches 15.
```

**Example 3:**
```
Input: catalog = [8], target = 3
Output: -1
```$$,
  constraints = $$- `1 <= catalog.length <= 6000`
- `|catalog[i]| <= 10^8`
- All values in `catalog` are unique.
- `catalog` is an ascending list rotated at some unknown pivot.
- `|target| <= 10^8`$$
WHERE slug = 'spot-catalog-target';

UPDATE test_cases SET input = E'[12,18,24,31,3,7,9]\n3', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'spot-catalog-target')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[12,18,24,31,3,7,9]\n15', expected_output = '-1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'spot-catalog-target')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[8]\n3', expected_output = '-1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'spot-catalog-target')
  AND is_sample = TRUE AND order_index = 3;

-- smallest-flow-rate
UPDATE problems SET
  description = $$An orchard's irrigation manifold holds `n` reservoirs that must be drained into the fields within `days` days. `volumes[i]` is the liters standing in reservoir `i`, and the reservoirs must be drained in the given left-to-right order because of pipeline pressure constraints.

Each day the manifold runs at a constant integer flow-rate capacity: drains are packed consecutively into the day until adding the next reservoir would exceed that capacity, at which point the day ends and the remaining reservoirs resume tomorrow.

Return the smallest flow-rate capacity (in liters per day) that lets every reservoir drain within `days` days.

**Example 1:**
```
Input: volumes = [2,4,5,7,9,11,13,16,18,20], days = 5
Output: 27
Explanation: Capacity 27 drains in 5 days: [2,4,5,7,9], [11,13], [16], [18], [20].
```

**Example 2:**
```
Input: volumes = [4,3,3,5,2,5], days = 3
Output: 8
Explanation: Capacity 8 drains in 3 days: [4,3], [3,5], [2,5].
```

**Example 3:**
```
Input: volumes = [2,3,4,2,2], days = 4
Output: 4
Explanation: Capacity 4 drains in 4 days: [2], [3], [4], [2,2].
```$$,
  constraints = $$- `1 <= days <= volumes.length <= 8 * 10^4`
- `1 <= volumes[i] <= 600`$$
WHERE slug = 'smallest-flow-rate';

UPDATE test_cases SET input = E'[2,4,5,7,9,11,13,16,18,20]\n5', expected_output = '27'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'smallest-flow-rate')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[4,3,3,5,2,5]\n3', expected_output = '8'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'smallest-flow-rate')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[2,3,4,2,2]\n4', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'smallest-flow-rate')
  AND is_sample = TRUE AND order_index = 3;

-- merged-zone-median
UPDATE problems SET
  description = $$Two regional postal-sorting machines each produce a stream of integer zone-codes in non-decreasing order. Given the two sorted streams `zonesA` and `zonesB`, return the **median** of the combined stream: the middle value after the two streams are merged, or the average of the two middle values when the combined length is even.

Your merge must run in `O(log(m + n))` time, where `m = zonesA.length` and `n = zonesB.length`, so the dispatch dashboard can refresh in real time.

**Example 1:**
```
Input: zonesA = [2,5], zonesB = [4]
Output: 4.0
Explanation: The merged stream is [2,4,5]; the middle value is 4.
```

**Example 2:**
```
Input: zonesA = [3,8], zonesB = [5,11]
Output: 6.5
Explanation: The merged stream is [3,5,8,11]; the median is (5 + 8) / 2 = 6.5.
```

**Example 3:**
```
Input: zonesA = [], zonesB = [12]
Output: 12.0
Explanation: Only one value total, so the median is that value.
```$$,
  constraints = $$- `0 <= zonesA.length, zonesB.length <= 1500`
- `1 <= zonesA.length + zonesB.length <= 3000`
- `|zonesA[i]|, |zonesB[i]| <= 10^7`
- Both streams are sorted in non-decreasing order.$$
WHERE slug = 'merged-zone-median';

UPDATE test_cases SET input = E'[2,5]\n[4]', expected_output = '4.0'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merged-zone-median')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[3,8]\n[5,11]', expected_output = '6.5'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merged-zone-median')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[]\n[12]', expected_output = '12.0'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merged-zone-median')
  AND is_sample = TRUE AND order_index = 3;

-- locate-vacant-callslot
UPDATE problems SET
  description = $$A library catalog assigns call-slots `0, 1, 2, ..., n` to new acquisitions as they are classified. After a reshelving sweep, the cataloguer hands you a list `callSlots` of `n` distinct slot numbers drawn from that full range of `n + 1` possibilities, meaning exactly one slot in `[0, n]` was never written down.

Implement `findVacantSlot(callSlots)` that returns the single missing slot number. The returned value is guaranteed to exist and be unique.

**Example 1:**
```
Input: callSlots = [4,2,0,1]
Output: 3
Explanation: The list has length 4, so the full range is [0,1,2,3,4]. Only slot 3 is absent.
```

**Example 2:**
```
Input: callSlots = [5,3,1,0,2]
Output: 4
Explanation: The full range is [0..5]; slot 4 is the one not recorded.
```$$,
  constraints = $$- `1 <= callSlots.length <= 2 * 10^5`
- `0 <= callSlots[i] <= callSlots.length`
- Every value in `callSlots` is distinct$$
WHERE slug = 'locate-vacant-callslot';

UPDATE test_cases SET input = E'[4,2,0,1]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'locate-vacant-callslot')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[5,3,1,0,2]', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'locate-vacant-callslot')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[9,6,4,2,3,5,7,0,1]', expected_output = '8'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'locate-vacant-callslot')
  AND is_sample = TRUE AND order_index = 3;

-- compare-pallet-flags
UPDATE problems SET
  description = $$Each pallet in the warehouse carries a compact status word whose bits encode which handling flags (fragile, hazardous, cold-chain, ...) are active. When two pallets are consolidated onto the same dock, the supervisor wants to know how many individual flags disagree between them.

Given two non-negative integers `leftFlags` and `rightFlags`, implement `countFlagMismatches(leftFlags, rightFlags)` that returns the number of bit positions at which the two status words differ.

**Example 1:**
```
Input: leftFlags = 10, rightFlags = 5
Output: 4
Explanation: 10 is 1010 and 5 is 0101 in binary. All four low bits disagree.
```

**Example 2:**
```
Input: leftFlags = 14, rightFlags = 9
Output: 3
Explanation: 14 is 1110 and 9 is 1001; positions 0, 1, and 2 disagree.
```$$,
  constraints = $$- `0 <= leftFlags, rightFlags <= 2.1 * 10^9`$$
WHERE slug = 'compare-pallet-flags';

UPDATE test_cases SET input = E'10\n5', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'compare-pallet-flags')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'14\n9', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'compare-pallet-flags')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'0\n0', expected_output = '0'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'compare-pallet-flags')
  AND is_sample = TRUE AND order_index = 3;

-- tally-priority-flags
UPDATE problems SET
  description = $$Emergency dispatch assigns each incoming call an integer ID from `0` to `upperId`. For audit reporting, you need a histogram that shows, for every possible ID in that range, how many priority bits are raised in its binary encoding (each set bit corresponds to a distinct escalation flag).

Given a non-negative integer `upperId`, implement `tallyPriorityFlags(upperId)` that returns an array `flagCounts` of length `upperId + 1`, where `flagCounts[i]` is the number of set bits in the binary representation of `i`.

**Example 1:**
```
Input: upperId = 4
Output: [0,1,1,2,1]
Explanation: 0=0b0, 1=0b1, 2=0b10, 3=0b11, 4=0b100.
```

**Example 2:**
```
Input: upperId = 7
Output: [0,1,1,2,1,2,2,3]
Explanation: Binary forms through 7 are 0, 1, 10, 11, 100, 101, 110, 111.
```$$,
  constraints = $$- `0 <= upperId <= 8 * 10^4`$$
WHERE slug = 'tally-priority-flags';

UPDATE test_cases SET input = E'4', expected_output = '[0,1,1,2,1]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tally-priority-flags')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'7', expected_output = '[0,1,1,2,1,2,2,3]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tally-priority-flags')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'0', expected_output = '[0]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tally-priority-flags')
  AND is_sample = TRUE AND order_index = 3;

-- combine-counter-readings
UPDATE problems SET
  description = $$A bare-metal manufacturing controller exposes only bitwise operations (AND, OR, XOR, NOT, left shift, right shift) on its two integer cycle counters. Firmware must still be able to combine them into a running total, so you need to implement addition without any `+` or `-` operator.

Given two integers `firstCount` and `secondCount`, implement `combineCounters(firstCount, secondCount)` that returns their arithmetic sum using only bitwise operations. Hint: XOR produces the bitwise sum ignoring carries, and AND followed by a left shift produces the carries themselves; iterate until the carry is zero.

**Example 1:**
```
Input: firstCount = 12, secondCount = 9
Output: 21
```

**Example 2:**
```
Input: firstCount = -15, secondCount = 4
Output: -11
```$$,
  constraints = $$- `-1500 <= firstCount, secondCount <= 1500`$$
WHERE slug = 'combine-counter-readings';

UPDATE test_cases SET input = E'12\n9', expected_output = '21'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'combine-counter-readings')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'-15\n4', expected_output = '-11'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'combine-counter-readings')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'0\n0', expected_output = '0'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'combine-counter-readings')
  AND is_sample = TRUE AND order_index = 3;

-- active-sensor-mask
UPDATE problems SET
  description = $$The smart-home hub packs the online/offline state of up to 31 sensors into a single positive integer `sensorMask`, where each set bit marks one sensor that is currently reporting. The dashboard widget just needs the headline number: how many sensors are active right now.

Implement `countActiveSensors(sensorMask)` that returns the number of `1` bits in the binary representation of `sensorMask`.

**Example 1:**
```
Input: sensorMask = 29
Output: 4
Explanation: 29 is 11101 in binary, which has four set bits.
```

**Example 2:**
```
Input: sensorMask = 256
Output: 1
Explanation: 256 is 100000000 in binary; only a single sensor is active.
```$$,
  constraints = $$- `1 <= sensorMask <= 2.1 * 10^9`$$
WHERE slug = 'active-sensor-mask';

UPDATE test_cases SET input = E'29', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'active-sensor-mask')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'256', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'active-sensor-mask')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'2147483645', expected_output = '30'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'active-sensor-mask')
  AND is_sample = TRUE AND order_index = 3;

-- reverse-printer-flags
UPDATE problems SET
  description = $$A legacy print-shop driver transmits its 32-bit job-status word with bit 0 first on the wire, so a newer firmware that lays bits out most-significant-first has to flip the entire word before it can compare status to its own registers. You are writing that translation step.

Given a 32-bit unsigned integer `statusWord`, implement `reversePrinterFlags(statusWord)` that returns the value obtained by reversing the order of all 32 bits: bit 0 moves to position 31, bit 1 moves to position 30, and so on. Return the result as a `long` in the range `[0, 2^32 - 1]`.

**Example 1:**
```
Input: statusWord = 8
Output: 268435456
Explanation: 8 has bit 3 set. After reversing across 32 positions, that bit lands at position 28, giving 2^28 = 268435456.
```

**Example 2:**
```
Input: statusWord = 6
Output: 1610612736
Explanation: 6 has bits 1 and 2 set. Reversed, they become bits 30 and 29, giving 2^30 + 2^29 = 1610612736.
```$$,
  constraints = $$- `statusWord` is a 32-bit unsigned integer (`0 <= statusWord <= 4294967295`)$$
WHERE slug = 'reverse-printer-flags';

UPDATE test_cases SET input = E'8', expected_output = '268435456'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reverse-printer-flags')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'6', expected_output = '1610612736'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reverse-printer-flags')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'1', expected_output = '2147483648'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reverse-printer-flags')
  AND is_sample = TRUE AND order_index = 3;

-- single-species-tank
UPDATE problems SET
  description = $$A breeding aquarium keeps a specimen counter per tank. A tank qualifies as a "single-species tank" only when the count is `1`, `2`, `4`, `8`, `16`, ... — a power of two — because that matches the doubling policy the curator uses when splitting broods. Counts that are zero, negative, or not an exact power of two do not qualify.

Given an integer `specimenCount`, implement `isSoloSpecies(specimenCount)` that returns `true` when `specimenCount == 2^k` for some non-negative integer `k`, and `false` otherwise.

**Example 1:**
```
Input: specimenCount = 32
Output: true
Explanation: 32 = 2^5.
```

**Example 2:**
```
Input: specimenCount = 12
Output: false
Explanation: 12 lies between 2^3 = 8 and 2^4 = 16, so it is not a power of two.
```$$,
  constraints = $$- `-2.1 * 10^9 <= specimenCount <= 2.1 * 10^9`$$
WHERE slug = 'single-species-tank';

UPDATE test_cases SET input = E'32', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'single-species-tank')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'12', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'single-species-tank')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'6', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'single-species-tank')
  AND is_sample = TRUE AND order_index = 3;

-- best-bake-order
UPDATE problems SET
  description = $$A bakery has a single row of proofing trays lined up along the counter, and each tray holds a batch whose dough weight is printed on the rim. You will pull trays into the oven one at a time in any order you choose.

When you pull the tray at position `i`, you earn `trays[i - 1] * trays[i] * trays[i + 1]` bonus loaves, where the neighbors are whatever trays are still on either side of `i` at that moment. After the pull, that tray is gone and the trays on either side of it slide together. If there is no tray on a side (either because the position is off the end of the row or because every other tray has already been pulled), treat that missing neighbor's weight as `1`.

Implement `bestBakeOrder` to return the maximum total bonus loaves you can earn after pulling every tray.

**Example 1:**
```
Input: trays = [2,4,1,6]
Output: 90
Explanation: One optimal order pulls 1, then 4, then 2, then 6: bonuses = 4*1*6 + 2*4*6 + 1*2*6 + 1*6*1 = 24 + 48 + 12 + 6 = 90.
```

**Example 2:**
```
Input: trays = [3,5]
Output: 20
Explanation: Pull the tray with weight 3 first: 1*3*5 = 15. Then pull 5: 1*5*1 = 5. Total = 20.
```$$,
  constraints = $$- `1 <= trays.length <= 300`
- `0 <= trays[i] <= 100`$$
WHERE slug = 'best-bake-order';

UPDATE test_cases SET input = E'[2,4,1,6]', expected_output = '90'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'best-bake-order')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[3,5]', expected_output = '20'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'best-bake-order')
  AND is_sample = TRUE AND order_index = 2;

-- count-coupon-combos
UPDATE problems SET
  description = $$A self-checkout lane at a grocery store accepts a fixed set of store-credit coupons, each worth a whole number of won. A cashier wants to know how many **distinct** coupon combinations exactly clear a given basket subtotal.

You are given the subtotal `amount` and a list `coupons` of available coupon denominations. Each denomination may be used any number of times, and two combinations are considered different only when they differ in the count of at least one denomination (order does not matter). Implement `countCouponCombos` to return the number of such combinations. If no combination lands exactly on `amount`, return `0`.

**Example 1:**
```
Input: amount = 8, coupons = [1,3,4]
Output: 6
Explanation: The six combinations are 1+1+1+1+1+1+1+1, 1+1+1+1+1+3, 1+1+3+3, 1+1+1+1+4, 1+3+4, and 4+4.
```

**Example 2:**
```
Input: amount = 4, coupons = [5]
Output: 0
Explanation: A 5-won coupon alone can never total 4 won.
```$$,
  constraints = $$- `1 <= coupons.length <= 300`
- `1 <= coupons[i] <= 5000`
- All values in `coupons` are distinct
- `0 <= amount <= 5000`$$
WHERE slug = 'count-coupon-combos';

UPDATE test_cases SET input = E'8\n[1,3,4]', expected_output = '6'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-coupon-combos')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'4\n[5]', expected_output = '0'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-coupon-combos')
  AND is_sample = TRUE AND order_index = 2;

-- min-wait-route
UPDATE problems SET
  description = $$A traffic operations center routes a city van through a rectangular grid of intersections, where each cell records the wait in minutes a vehicle incurs passing through that intersection during the current signal plan. The van enters the grid at the top-left intersection and must reach the bottom-right intersection. From any intersection the driver may only proceed **one block east (right)** or **one block south (down)**.

Implement `minWaitRoute` to return the smallest total wait the van can accumulate along a single valid route from the top-left to the bottom-right cell, counting every intersection that the route visits (including both endpoints).

**Example 1:**
```
Input: grid = [[2,1,4],[5,3,2],[1,2,1]]
Output: 9
Explanation: The route 2 -> 1 -> 3 -> 2 -> 1 sums to 9 minutes, the best achievable.
```

**Example 2:**
```
Input: grid = [[3,1],[2,4],[1,5]]
Output: 11
Explanation: The route 3 -> 2 -> 1 -> 5 sums to 11 minutes; the alternative 3 -> 1 -> 4 -> 5 totals 13.
```$$,
  constraints = $$- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 200`
- `0 <= grid[i][j] <= 200`$$
WHERE slug = 'min-wait-route';

UPDATE test_cases SET input = E'[[2,1,4],[5,3,2],[1,2,1]]', expected_output = '9'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'min-wait-route')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[3,1],[2,4],[1,5]]', expected_output = '11'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'min-wait-route')
  AND is_sample = TRUE AND order_index = 2;

-- min-zone-code-edits
UPDATE problems SET
  description = $$A postal sorting hub maintains short lowercase zone codes for each delivery district, and the routing team sometimes needs to rewrite one code character-by-character so it matches another (for example when a district is merged into a neighbor). Only three kinds of single-character edits are permitted on the code:
- **Insert** one character at any position
- **Delete** one character at any position
- **Replace** one character with a different character

Given the old zone code `source` and the new zone code `target`, implement `minZoneEdits` to return the minimum number of such edits needed to transform `source` into `target`.

**Example 1:**
```
Input: source = "coral", target = "carol"
Output: 2
Explanation: Replace the 'o' at index 1 with 'a', then replace the 'a' at index 3 with 'o'.
```

**Example 2:**
```
Input: source = "sunset", target = "sunrise"
Output: 3
Explanation: Delete the final 't' (sunset -> sunse), insert 'r' after the 'n' (sunse -> sunrse), then insert 'i' after that 'r' (sunrse -> sunrise). Three edits.
```$$,
  constraints = $$- `0 <= source.length, target.length <= 500`
- `source` and `target` consist of lowercase English letters.$$
WHERE slug = 'min-zone-code-edits';

UPDATE test_cases SET input = E'coral\ncarol', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'min-zone-code-edits')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'sunset\nsunrise', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'min-zone-code-edits')
  AND is_sample = TRUE AND order_index = 2;

-- biggest-clear-bay
UPDATE problems SET
  description = $$A warehouse floor is mapped as an `m x n` grid of tiles, where each tile is either `"1"` (clear, a forklift can stage a pallet there) or `"0"` (blocked by a pillar, charging station, or existing rack). The operations manager wants to know the area of the largest **square** staging bay that can be carved out of adjacent clear tiles.

Implement `biggestClearBay` to return the area (side length squared) of the largest all-`"1"` axis-aligned square sub-grid of `floor`. If no clear tile exists, return `0`.

**Example 1:**
```
Input: floor = [["1","1","0","1"],["1","1","1","1"],["0","1","1","1"],["1","1","1","1"]]
Output: 9
Explanation: The bottom-right 3x3 block is entirely clear, so the biggest square has side length 3 and area 9.
```

**Example 2:**
```
Input: floor = [["0","0","0"],["0","1","1"],["0","1","1"]]
Output: 4
Explanation: The 2x2 block in the bottom-right corner is all clear, giving area 4.
```$$,
  constraints = $$- `m == floor.length`
- `n == floor[i].length`
- `1 <= m, n <= 300`
- `floor[i][j]` is `'0'` or `'1'`$$
WHERE slug = 'biggest-clear-bay';

UPDATE test_cases SET input = E'[["1","1","0","1"],["1","1","1","1"],["0","1","1","1"],["1","1","1","1"]]', expected_output = '9'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'biggest-clear-bay')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[["0","0","0"],["0","1","1"],["0","1","1"]]', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'biggest-clear-bay')
  AND is_sample = TRUE AND order_index = 2;

-- longest-vine-ascent
UPDATE problems SET
  description = $$A hillside vineyard is laid out as an `m x n` grid where each cell holds the measured sugar level of the vine at that trellis position. A vintner wants to trace a hand-harvest path of vines whose sugar reading rises with every step, to analyze ripening patterns.

A valid ascent starts at any cell and, at each step, moves to a cell that is directly **up, down, left, or right** of the current one and whose sugar reading is **strictly greater** than the current cell's. Implement `longestVineAscent` to return the number of vines in the longest strictly increasing path that can be traced through `sugar`.

**Example 1:**
```
Input: sugar = [[2,5,8],[3,4,7],[1,6,9]]
Output: 5
Explanation: Starting at the vine with reading 1 in the bottom-left, the ascent 1 -> 3 -> 4 -> 7 -> 9 visits 5 vines, each strictly sweeter than the last.
```

**Example 2:**
```
Input: sugar = [[4,2,1],[5,6,3]]
Output: 5
Explanation: The ascent 1 -> 2 -> 4 -> 5 -> 6 threads through five adjacent vines with strictly increasing sugar levels.
```$$,
  constraints = $$- `m == sugar.length`
- `n == sugar[i].length`
- `1 <= m, n <= 200`
- `0 <= sugar[i][j] <= 10^8`$$
WHERE slug = 'longest-vine-ascent';

UPDATE test_cases SET input = E'[[2,5,8],[3,4,7],[1,6,9]]', expected_output = '5'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-vine-ascent')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[4,2,1],[5,6,3]]', expected_output = '5'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-vine-ascent')
  AND is_sample = TRUE AND order_index = 2;

-- shelf-overlap-length
UPDATE problems SET
  description = $$A library's archive system records each shelf as a string of single-letter subject codes, written in the order the books are shelved. When the cataloger compares two shelves, they want to measure the longest subject-code pattern that appears on **both** shelves in the same relative order, even if the matching letters are separated by other codes in between.

A **subsequence** of a shelf string is a string you can obtain by deleting zero or more letters without changing the order of the remaining letters. Given two shelf strings `left` and `right`, implement `shelfOverlapLength` to return the length of the longest common subsequence between them. If no letter is shared, return `0`.

**Example 1:**
```
Input: left = "history", right = "mystery"
Output: 4
Explanation: One longest common subsequence is "stry" (length 4).
```

**Example 2:**
```
Input: left = "ocean", right = "canoe"
Output: 3
Explanation: One longest common subsequence is "can": it appears in order as positions 1-3-4 of left and 0-1-2 of right.
```$$,
  constraints = $$- `1 <= left.length, right.length <= 1000`
- `left` and `right` consist of lowercase English letters.$$
WHERE slug = 'shelf-overlap-length';

UPDATE test_cases SET input = E'history\nmystery', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shelf-overlap-length')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'ocean\ncanoe', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shelf-overlap-length')
  AND is_sample = TRUE AND order_index = 2;

-- validate-part-stream
UPDATE problems SET
  description = $$A manufacturing line stamps each finished part with a short code string, and quality control keeps a catalog of pattern strings that describe acceptable part codes. A pattern uses two wildcards: `.` stands for any single character in a code, and `*` means **zero or more** copies of the character that appeared immediately before the `*`. A code is considered valid only when the pattern covers it **end to end**, not when it merely describes a prefix or an interior substring.

Given a part code `code` and a pattern `pattern`, implement `validatePartStream` to return `true` if the pattern matches the entire code and `false` otherwise.

**Example 1:**
```
Input: code = "bbbc", pattern = "b*c"
Output: true
Explanation: `b*` consumes the three b's at the start, then `c` matches the trailing c, covering the full code.
```

**Example 2:**
```
Input: code = "xyzw", pattern = "x.y"
Output: false
Explanation: The pattern describes only three characters and contains no `*` to stretch, so it cannot cover the four-character code.
```$$,
  constraints = $$- `1 <= code.length <= 24`
- `1 <= pattern.length <= 24`
- `code` consists of lowercase English letters
- `pattern` consists of lowercase English letters, `.`, and `*`
- Every `*` in `pattern` has a valid preceding character (no leading `*` and no two `*` in a row)$$
WHERE slug = 'validate-part-stream';

UPDATE test_cases SET input = E'bbbc\nb*c', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'validate-part-stream')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'xyzw\nx.y', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'validate-part-stream')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'aaab\na*ab', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'validate-part-stream')
  AND is_sample = TRUE AND order_index = 3;

-- partition-tank-doses
UPDATE problems SET
  description = $$An aquarium technician must dose each of several tanks with a fixed measured amount of buffer solution, but for each tank they can either **add** the amount (raising the chemistry reading by that much) or **drain** the amount (lowering it by that much). Given an array `doses` where `doses[i]` is the dose amount assigned to tank `i`, and an integer `target` equal to the desired net change in readings across all tanks, count the number of distinct add/drain assignments that produce a net change exactly equal to `target`. Every tank must receive exactly one action.

Implement `partitionTankDoses` to return the number of valid assignments.

**Example 1:**
```
Input: doses = [2,2,2,2], target = 4
Output: 4
Explanation: The net change must be +4, so 3 tanks receive add and 1 tank receives drain. There are 4 choices for which tank is drained.
```

**Example 2:**
```
Input: doses = [4,6,8], target = 10
Output: 1
Explanation: The only assignment with net +10 is drain the 4, add the 6, add the 8, giving -4 + 6 + 8 = 10.
```$$,
  constraints = $$- `1 <= doses.length <= 22`
- `0 <= doses[i] <= 900`
- `-900 <= target <= 900`$$
WHERE slug = 'partition-tank-doses';

UPDATE test_cases SET input = E'[2,2,2,2]\n4', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'partition-tank-doses')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[4,6,8]\n10', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'partition-tank-doses')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[3,1,1,2]\n3', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'partition-tank-doses')
  AND is_sample = TRUE AND order_index = 3;

-- best-tier-resale
UPDATE problems SET
  description = $$A resale broker tracks the day-by-day market price of a single concert tier. Each day the broker can either **buy** a seat (if they currently hold none), **sell** the seat they hold, or do nothing. The broker never holds more than one seat at a time, and after selling they must sit out the very next day as a mandatory cooldown before buying again. Given an array `tierPrices` where `tierPrices[i]` is the market price on day `i`, return the maximum total profit the broker can lock in over the entire window.

Implement `bestTierResale` to return that maximum profit.

**Example 1:**
```
Input: tierPrices = [3,8,5,1,6]
Output: 10
Explanation: Buy on day 0 at 3 and sell on day 1 at 8 (profit 5). Day 2 is the forced cooldown. Buy on day 3 at 1 and sell on day 4 at 6 (profit 5). Total 10.
```

**Example 2:**
```
Input: tierPrices = [9,2,5]
Output: 3
Explanation: The opening 9 is too high to sell into, so wait, buy on day 1 at 2, and sell on day 2 at 5 for a profit of 3.
```$$,
  constraints = $$- `1 <= tierPrices.length <= 2000`
- `0 <= tierPrices[i] <= 900`$$
WHERE slug = 'best-tier-resale';

UPDATE test_cases SET input = E'[3,8,5,1,6]', expected_output = '10'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'best-tier-resale')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[9,2,5]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'best-tier-resale')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[4,4]', expected_output = '0'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'best-tier-resale')
  AND is_sample = TRUE AND order_index = 3;

-- check-merged-queue
UPDATE problems SET
  description = $$A busy print shop runs two independent printers, each with its own ordered job queue. At the end of the day a supervisor collates the **merged** queue that a downstream billing system saw as the jobs were dispatched across both machines. The merged queue is legitimate only if it is a true interleave of the two per-printer queues: every job appears, and within each original queue the relative order is preserved (but jobs from the two queues can arrive in any interleaved pattern).

Given three strings `queueA`, `queueB`, and `merged` (each character stands for one job id), implement `checkMergedQueue` to return `true` when `merged` is a valid interleave of `queueA` and `queueB`, or `false` otherwise.

**Example 1:**
```
Input: queueA = "cat", queueB = "dog", merged = "cdoagt"
Output: true
Explanation: Pull c from A, then d and o from B, then a from A, then g from B, then t from A. Both per-queue orders are preserved.
```

**Example 2:**
```
Input: queueA = "abc", queueB = "xyz", merged = "axbzyc"
Output: false
Explanation: After taking a then x, the next job from B would have to be y, but the merged stream shows z before y, which violates B's order.
```$$,
  constraints = $$- `0 <= queueA.length, queueB.length <= 120`
- `0 <= merged.length <= 240`
- `queueA`, `queueB`, and `merged` consist of lowercase English letters$$
WHERE slug = 'check-merged-queue';

UPDATE test_cases SET input = E'cat\ndog\ncdoagt', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'check-merged-queue')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'abc\nxyz\naxbzyc', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'check-merged-queue')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'\n\n', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'check-merged-queue')
  AND is_sample = TRUE AND order_index = 3;

-- count-filter-matches
UPDATE problems SET
  description = $$Each night an observatory records the sequence of optical filters actually swapped onto the main telescope, producing a `log` string where each character encodes one filter letter. Researchers often want to know how many distinct ways a short target filter pattern `target` can be extracted from the log as a **subsequence** — that is, by selecting characters from `log` in order (skipping any number of them) without reordering. Different choices of skipped positions count as different extractions, even if the extracted characters look the same.

Given the log `log` and the pattern `target`, implement `countFilterMatches` to return the total number of distinct subsequence matches. The answer fits in a 64-bit signed integer.

**Example 1:**
```
Input: log = "ggrrg", target = "grg"
Output: 4
Explanation: Each match chooses a g, then a later r, then a later g. Among the g positions (0, 1, 4) and r positions (2, 3), the valid (i, j, k) triples are (0,2,4), (0,3,4), (1,2,4), (1,3,4).
```

**Example 2:**
```
Input: log = "uvuvu", target = "uu"
Output: 3
Explanation: The u positions are 0, 2, and 4, and choosing any ordered pair gives a match: (0,2), (0,4), (2,4).
```$$,
  constraints = $$- `1 <= log.length <= 900`
- `1 <= target.length <= 900`
- `log` and `target` consist of lowercase English letters$$
WHERE slug = 'count-filter-matches';

UPDATE test_cases SET input = E'ggrrg\ngrg', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-filter-matches')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'uvuvu\nuu', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-filter-matches')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'xxxx\nxx', expected_output = '6'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-filter-matches')
  AND is_sample = TRUE AND order_index = 3;

-- count-gate-routes
UPDATE problems SET
  description = $$A theme park lays out its attractions on a rectangular walking grid with `rows` rows and `cols` columns. A guest enters through the gate at the top-left cell `[0, 0]` and wants to reach the headline attraction at the bottom-right cell `[rows - 1, cols - 1]`. Park signage forces one-way foot traffic: from any cell a guest may only walk one cell **down** or one cell **right**.

Implement `countGateRoutes` to return the number of distinct walking routes from the gate to the headline attraction.

**Example 1:**
```
Input: rows = 4, cols = 5
Output: 35
Explanation: Each route takes exactly 3 down-steps and 4 right-steps in some order, so the count is the number of ways to arrange those 7 moves.
```

**Example 2:**
```
Input: rows = 2, cols = 6
Output: 6
Explanation: With a single down-step required, the route is fully determined by which of the 6 columns that down-step happens in.
```$$,
  constraints = $$- `1 <= rows, cols <= 80`$$
WHERE slug = 'count-gate-routes';

UPDATE test_cases SET input = E'4\n5', expected_output = '35'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-gate-routes')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'2\n6', expected_output = '6'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-gate-routes')
  AND is_sample = TRUE AND order_index = 2;

-- split-reading-for-product
UPDATE problems SET
  description = $$A weather station records a single positive integer `span` of consecutive hours that must be partitioned into two or more contiguous sampling blocks (each block at least one hour long). An analyst scores a partition by multiplying the block lengths together, and wants to pick the partition that maximizes that product.

Implement `splitProductMax(span)` that returns the **maximum product** achievable across all valid partitions of `span` into two or more positive integer block lengths whose lengths sum to `span`.

**Example 1:**
```
Input: span = 5
Output: 6
Explanation: The best partition is 5 = 2 + 3, giving a product of 2 * 3 = 6. All other valid partitions (1+4, 1+1+3, 1+2+2, 1+1+1+2, 1+1+1+1+1) yield smaller products.
```

**Example 2:**
```
Input: span = 11
Output: 54
Explanation: The best partition is 11 = 3 + 3 + 3 + 2, giving 3 * 3 * 3 * 2 = 54. Splits like 3+4+4 yield 48 and 3+3+5 yield 45.
```$$,
  constraints = $$- `2 <= span <= 60`$$
WHERE slug = 'split-reading-for-product';

UPDATE test_cases SET input = E'5', expected_output = '6'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-reading-for-product')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'11', expected_output = '54'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-reading-for-product')
  AND is_sample = TRUE AND order_index = 2;

-- pick-least-effort-circuit
UPDATE problems SET
  description = $$A fitness studio exposes a circuit of machines numbered `0` through `n-1`, and each machine charges an effort toll `effort[i]` for a member stepping onto it. A member may start in front of machine `0` or machine `1`, and from any machine they may advance one or two positions forward after paying that machine's toll. The goal is to clear the circuit by stepping off the end (position `n`, just past the last machine).

Implement `pickLeastEffort(effort)` that returns the minimum total toll a member must pay to finish the circuit.

**Example 1:**
```
Input: effort = [4,2,8,3,5,6]
Output: 10
Explanation: Start at machine 1 (pay 2), jump to machine 3 (pay 3), jump to machine 5 (pay 6 is too costly — instead jump from machine 3 to machine 5 via machine 4)… the minimum path pays 2 + 3 + 5 = 10.
```

**Example 2:**
```
Input: effort = [7,1,7,1,7]
Output: 2
Explanation: Start at machine 1 (pay 1), advance two positions to machine 3 (pay 1), then advance two more positions to finish. Total toll is 2 (paying one at each of machines 1 and 3).
```$$,
  constraints = $$- `2 <= effort.length <= 2 * 10^3`
- `0 <= effort[i] <= 800`$$
WHERE slug = 'pick-least-effort-circuit';

UPDATE test_cases SET input = E'[4,2,8,3,5,6]', expected_output = '10'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pick-least-effort-circuit')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[7,1,7,1,7]', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pick-least-effort-circuit')
  AND is_sample = TRUE AND order_index = 2;

-- fewest-bag-sizes
UPDATE problems SET
  description = $$A regional mail-sorting plant keeps a small catalog of reusable mail-bag sizes, each of which holds an exact integer number of pieces. A dispatcher receives an order to prepare exactly `quota` pieces for a downstream truck, and may draw from the catalog any number of bags of any size (with unlimited stock of each size). The plant wants to use as few bags total as possible.

Implement `fewestBagSizes(bagSizes, quota)` that returns the minimum number of bags whose capacities sum to exactly `quota`, or `-1` if no combination of catalog sizes can reach the quota exactly.

**Example 1:**
```
Input: bagSizes = [2,4,7], quota = 15
Output: 3
Explanation: Using bags of size 4, 4, and 7 totals 15 pieces with three bags. No pair of bags from the catalog sums to 15, so three is the minimum.
```

**Example 2:**
```
Input: bagSizes = [3,5], quota = 4
Output: -1
Explanation: No combination of bags with capacities 3 and 5 sums to exactly 4 pieces.
```$$,
  constraints = $$- `1 <= bagSizes.length <= 12`
- `1 <= bagSizes[i] <= 10^8`
- `0 <= quota <= 8000`$$
WHERE slug = 'fewest-bag-sizes';

UPDATE test_cases SET input = E'[2,4,7]\n15', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fewest-bag-sizes')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[3,5]\n4', expected_output = '-1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fewest-bag-sizes')
  AND is_sample = TRUE AND order_index = 2;

-- count-scan-decodings
UPDATE problems SET
  description = $$A warehouse's pallet scanner emits a long digit sequence `scan` where every SKU in the catalog has been pre-encoded as an integer from `1` through `26` (so SKU 1 is `"1"`, SKU 10 is `"10"`, SKU 26 is `"26"`). Picks that start with `0` are invalid — no SKU in the catalog has an id like `05` or `0`. A clerk must decide how many distinct ways the raw digit sequence could be re-split into valid SKU ids.

Implement `countScanDecodings(scan)` that returns the number of ways to parse `scan` left-to-right into a sequence of SKU ids drawn from `1..26`. The answer is guaranteed to fit in a 32-bit signed integer.

**Example 1:**
```
Input: scan = "1234"
Output: 3
Explanation: The valid parses are (1,2,3,4), (12,3,4), and (1,23,4). "1234" as a single id is invalid because 1234 exceeds 26, and "12,34" is invalid because 34 exceeds 26.
```

**Example 2:**
```
Input: scan = "100"
Output: 0
Explanation: The second digit is 0, so it cannot start a new id. The only remaining option would pair the first two digits as 10, but then the trailing 0 is stranded with no id that starts with 0.
```$$,
  constraints = $$- `1 <= scan.length <= 120`
- `scan` contains only decimal digits and may include leading or interior zeros.$$
WHERE slug = 'count-scan-decodings';

UPDATE test_cases SET input = E'1234', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-scan-decodings')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'100', expected_output = '0'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-scan-decodings')
  AND is_sample = TRUE AND order_index = 2;

-- split-shift-loads
UPDATE problems SET
  description = $$An emergency-dispatch desk holds a batch of pending calls, each tagged with an integer workload score `loads[i]` measured in response-minutes. The supervisor wants to divide the batch between the **day** shift and the **night** shift so that every call is handled by exactly one shift and both shifts carry the same total workload.

Implement `canSplitLoads(loads)` that returns `true` if the pending calls can be partitioned into two disjoint groups with equal total workload, and `false` otherwise.

**Example 1:**
```
Input: loads = [3,1,1,2,2,1]
Output: true
Explanation: The sum is 10, so each shift must carry 5 response-minutes. One valid split is {3, 2} for the day shift and {1, 1, 2, 1} for the night shift — both sum to 5.
```

**Example 2:**
```
Input: loads = [2,2,3,5]
Output: false
Explanation: The sum is 12, so each shift would need to carry 6 response-minutes, but no subset of {2, 2, 3, 5} sums to exactly 6.
```$$,
  constraints = $$- `1 <= loads.length <= 200`
- `1 <= loads[i] <= 100`$$
WHERE slug = 'split-shift-loads';

UPDATE test_cases SET input = E'[3,1,1,2,2,1]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-shift-loads')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[2,2,3,5]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-shift-loads')
  AND is_sample = TRUE AND order_index = 2;

-- pick-plot-haul
UPDATE problems SET
  description = $$A vineyard block runs a single row of `n` plots, and the end-of-season sensor log reports an integer sugar yield `yield[i]` for each plot. The harvest crew has a mechanical constraint: if they harvest two adjacent plots on the same pass, the shared trellis wire overloads, so any pair of harvested plots must be separated by at least one unharvested plot.

Implement `pickPlotHaul(yields)` that returns the maximum total yield the crew can collect on a single pass while never harvesting two adjacent plots.

**Example 1:**
```
Input: yields = [4,1,1,9,1,3]
Output: 16
Explanation: Harvesting plots 0, 3, and 5 yields 4 + 9 + 3 = 16. No other no-adjacent selection scores higher.
```

**Example 2:**
```
Input: yields = [5,5,10,100,10,5]
Output: 110
Explanation: Harvesting plots 1, 3, and 5 yields 5 + 100 + 5 = 110. Taking plot 3 alone scores 100, and any selection that skips plot 3 cannot catch up.
```$$,
  constraints = $$- `1 <= yields.length <= 100`
- `0 <= yields[i] <= 400`$$
WHERE slug = 'pick-plot-haul';

UPDATE test_cases SET input = E'[4,1,1,9,1,3]', expected_output = '16'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pick-plot-haul')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[5,5,10,100,10,5]', expected_output = '110'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pick-plot-haul')
  AND is_sample = TRUE AND order_index = 2;

-- pick-circuit-targets
UPDATE problems SET
  description = $$A rooftop observatory is planning a loop survey: `n` targets are arranged around the dome in a closed ring, with each target's expected photon yield given in an integer array `yields`. Because the dome slews mechanically, capturing two **ring-adjacent** targets back-to-back violates the cooldown rule, and since the ring wraps, the first and last targets count as adjacent.

Implement `pickCircuitTargets(yields)` that returns the maximum total yield obtainable by selecting a subset of targets such that no two selected targets are ring-adjacent.

**Example 1:**
```
Input: yields = [4,1,5,6,2]
Output: 10
Explanation: Pick index 0 (yield 4) and index 2 or 3. Best is picking yields[0]=4 and yields[3]=6 for total 10. You cannot also pick yields[4]=2 since it is ring-adjacent to yields[0].
```

**Example 2:**
```
Input: yields = [3,8,2,7,1,9]
Output: 24
Explanation: Picking yields[1]=8, yields[3]=7, yields[5]=9 would total 24 in a line, but yields[5] is ring-adjacent to yields[0]. Skipping yields[0] lets us legally pick 8+7+9=24.
```$$,
  constraints = $$- `1 <= yields.length <= 2 * 10^3`
- `0 <= yields[i] <= 5000`$$
WHERE slug = 'pick-circuit-targets';

UPDATE test_cases SET input = E'[4,1,5,6,2]', expected_output = '10'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pick-circuit-targets')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[3,8,2,7,1,9]', expected_output = '24'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pick-circuit-targets')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[7,3,1,5]', expected_output = '8'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pick-circuit-targets')
  AND is_sample = TRUE AND order_index = 3;

-- longest-bright-run
UPDATE problems SET
  description = $$Walking a single vineyard row, a viticulturist records the refractometer sugar reading (in Brix) at each vine. The readings are given as an integer array `brix` in row order. To argue that the row is ripening on a clean upward trend, the analyst wants the length of the longest strictly increasing **sub-sequence** of readings (vines may be skipped, but the order along the row is preserved).

Implement `longestBrightRun(brix)` that returns the length of the longest strictly increasing subsequence of `brix`. A subsequence selects a subset of indices in their original order; consecutive picks must satisfy `brix[i] < brix[j]`.

**Example 1:**
```
Input: brix = [4,10,2,6,3,5,8,11]
Output: 5
Explanation: The subsequence [2,3,5,8,11] (from indices 2,4,5,6,7) is strictly increasing and has length 5.
```

**Example 2:**
```
Input: brix = [9,2,7,4,6,8]
Output: 4
Explanation: The subsequence [2,4,6,8] has length 4; no strictly increasing subsequence of length 5 exists.
```$$,
  constraints = $$- `1 <= brix.length <= 2 * 10^3`
- `-5000 <= brix[i] <= 5000`$$
WHERE slug = 'longest-bright-run';

UPDATE test_cases SET input = E'[4,10,2,6,3,5,8,11]', expected_output = '5'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-bright-run')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[9,2,7,4,6,8]', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-bright-run')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[5,5,5,5]', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-bright-run')
  AND is_sample = TRUE AND order_index = 3;

-- count-longest-bake-trail
UPDATE problems SET
  description = $$Across a morning shift, a bakery pulls trays out of the rotation oven and logs the browning score for each in order; the scores are given as an integer array `scores`. The head baker calls a **bake trail** any strictly increasing sub-sequence of scores (trays may be skipped but order is preserved), and she wants to know how many distinct trails tie for the longest length.

Implement `countLongestTrail(scores)` that first determines the maximum length `L` of any strictly increasing subsequence of `scores`, then returns the number of distinct subsequences (by index set) that achieve length `L`.

**Example 1:**
```
Input: scores = [2,6,4,5,8]
Output: 1
Explanation: The longest strictly increasing subsequence has length 4: [2,4,5,8]. No other length-4 trail exists.
```

**Example 2:**
```
Input: scores = [3,3,3]
Output: 3
Explanation: No two entries are strictly ordered, so the longest trail has length 1. Each of the three entries alone is a distinct length-1 trail.
```$$,
  constraints = $$- `1 <= scores.length <= 2 * 10^3`
- `-8 * 10^5 <= scores[i] <= 8 * 10^5`$$
WHERE slug = 'count-longest-bake-trail';

UPDATE test_cases SET input = E'[2,6,4,5,8]', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-longest-bake-trail')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[3,3,3]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-longest-bake-trail')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[1,2,4,3,5,4,7,2]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-longest-bake-trail')
  AND is_sample = TRUE AND order_index = 3;

-- build-mirror-length
UPDATE problems SET
  description = $$A library catalog auditor is reviewing run-together call numbers. For a single lowercased call-number string `code`, she wants to find the longest **contiguous** slice that reads identically forwards and backwards (a "mirror run"), because mirror runs tend to mark shelving errors introduced by a buggy importer.

Implement `buildMirrorLength(code)` that returns the length of the longest palindromic contiguous substring of `code`. Every single character is itself a mirror of length 1, so the answer is always at least 1 when `code` is non-empty.

**Example 1:**
```
Input: code = "levelled"
Output: 5
Explanation: The contiguous slice "level" is a palindrome of length 5. No longer palindromic slice exists in code.
```

**Example 2:**
```
Input: code = "barrel"
Output: 2
Explanation: The contiguous slice "rr" is a palindrome of length 2, and no longer palindromic slice exists in code.
```$$,
  constraints = $$- `1 <= code.length <= 1200`
- `code` consists of only lowercase English letters.$$
WHERE slug = 'build-mirror-length';

UPDATE test_cases SET input = E'levelled', expected_output = '5'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'build-mirror-length')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'barrel', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'build-mirror-length')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'q', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'build-mirror-length')
  AND is_sample = TRUE AND order_index = 3;

-- best-flow-streak
UPDATE problems SET
  description = $$A farm's main trunk pipe reports a sequence of hourly net-flow signals along a single channel: positive values mean inflow is winning, negatives mean a reversed (siphoning) pull, and zero means the valve briefly seated closed. The readings are given as an integer array `flow`, and the irrigation engineer wants the maximum **product** of any contiguous subarray of `flow` — the streak whose multiplicative signature dominates the day.

Implement `bestFlowStreak(flow)` that returns the largest product obtainable from any contiguous non-empty subarray of `flow`. The product of any subarray is guaranteed to fit in a signed 32-bit integer.

**Example 1:**
```
Input: flow = [3,-1,4,-2,5]
Output: 120
Explanation: The whole subarray [3,-1,4,-2,5] multiplies to 120, which is the largest contiguous product.
```

**Example 2:**
```
Input: flow = [-3,0,2,-4]
Output: 2
Explanation: Any subarray that crosses the zero has product 0. The best non-crossing choice is [2], giving product 2.
```$$,
  constraints = $$- `1 <= flow.length <= 2 * 10^3`
- `-10 <= flow[i] <= 10`
- The product of any contiguous subarray of `flow` fits in a signed 32-bit integer.$$
WHERE slug = 'best-flow-streak';

UPDATE test_cases SET input = E'[3,-1,4,-2,5]', expected_output = '120'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'best-flow-streak')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[-3,0,2,-4]', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'best-flow-streak')
  AND is_sample = TRUE AND order_index = 2;

-- nth-smooth-batch
UPDATE problems SET
  description = $$A print shop's batch planner only uses stack sizes whose page count factors cleanly into `2`, `3`, and `5` — the three folding ratios supported by the finisher. A **smooth batch size** is any positive integer whose only prime factors are `2`, `3`, or `5`; by convention `1` is the first smooth batch size (it has no prime factors). The sequence begins `1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, 24, ...` (note `7` is excluded because `7` itself is a disallowed prime factor).

Implement `nthSmoothBatch(n)` that returns the `n`-th smooth batch size in ascending order (`1`-indexed).

**Example 1:**
```
Input: n = 7
Output: 8
Explanation: The first seven smooth batch sizes are 1, 2, 3, 4, 5, 6, 8, so the 7th is 8.
```

**Example 2:**
```
Input: n = 12
Output: 16
Explanation: The first twelve smooth batch sizes are 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, so the 12th is 16.
```$$,
  constraints = $$- `1 <= n <= 1500`$$
WHERE slug = 'nth-smooth-batch';

UPDATE test_cases SET input = E'7', expected_output = '8'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'nth-smooth-batch')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'12', expected_output = '16'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'nth-smooth-batch')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'1', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'nth-smooth-batch')
  AND is_sample = TRUE AND order_index = 3;

-- count-mirror-spans
UPDATE problems SET
  description = $$A weather station logs a compact string `code` of single-character condition markers (one per hour of the shift). Analysts are interested in **mirror spans** — contiguous slices of the log that read identically forward and backward, since those tend to bracket a symmetric pressure event.

Implement `countMirrorSpans(code)` that returns the total number of mirror spans contained in `code`. Each single-character slice is a mirror span, and the same span text counted at different positions must be counted separately.

**Example 1:**
```
Input: code = "klmn"
Output: 4
Explanation: No two adjacent markers agree, so only the 4 single-character slices qualify.
```

**Example 2:**
```
Input: code = "rrrr"
Output: 10
Explanation: Every contiguous slice of a run of identical markers is a mirror span. With length 4 there are 4 + 3 + 2 + 1 = 10 such slices.
```$$,
  constraints = $$- `1 <= code.length <= 1500`
- `code` consists of lowercase English letters.$$
WHERE slug = 'count-mirror-spans';

UPDATE test_cases SET input = E'klmn', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-mirror-spans')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'rrrr', expected_output = '10'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-mirror-spans')
  AND is_sample = TRUE AND order_index = 2;

-- count-exact-page-quotas
UPDATE problems SET
  description = $$A print shop stocks paper packs in every **perfect-square** size: 1, 4, 9, 16, 25, and so on. To hit an exact page quota the operator may combine packs, reusing any size as many times as needed.

Implement `countExactTargets(pages)` that returns the fewest packs needed to sum exactly to `pages`.

**Example 1:**
```
Input: pages = 7
Output: 4
Explanation: Using one size-4 pack plus three size-1 packs sums to 7. No combination of 1, 2, or 3 perfect-square packs sums to 7.
```

**Example 2:**
```
Input: pages = 17
Output: 2
Explanation: 17 = 16 + 1.
```

**Example 3:**
```
Input: pages = 5
Output: 2
Explanation: 5 = 4 + 1.
```$$,
  constraints = $$- `1 <= pages <= 12000`$$
WHERE slug = 'count-exact-page-quotas';

UPDATE test_cases SET input = E'7', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-exact-page-quotas')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'17', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-exact-page-quotas')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'5', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-exact-page-quotas')
  AND is_sample = TRUE AND order_index = 3;

-- count-assembly-orders
UPDATE problems SET
  description = $$A warehouse assembles a finished product out of `n` sub-assemblies numbered `0` through `n - 1`. The bill of materials is a rooted tree: sub-assembly `0` is the top-level unit with no prerequisite, and every other sub-assembly `i` has exactly one parent `parent[i]` that must be fully built before work on `i` may start. By convention `parent[0] = -1`.

The floor can only build one sub-assembly at a time. Two build orders are considered distinct if the ordered sequence of sub-assembly indices differs anywhere.

Implement `countAssemblyOrders(parent)` that returns the total number of valid build orders for all `n` sub-assemblies, taken modulo `10^8 + 7`.

**Example 1:**
```
Input: parent = [-1,0,0,2,2]
Output: 8
Explanation: Sub-assembly 0 must be built first. Below it, sub-assembly 1 is a leaf and the pair (3, 4) hangs off sub-assembly 2. Interleaving the two branches yields 8 distinct orders.
```

**Example 2:**
```
Input: parent = [-1,0,1,2,3]
Output: 1
Explanation: The bill of materials is the chain 0 -> 1 -> 2 -> 3 -> 4, so only one build order is valid.
```

**Example 3:**
```
Input: parent = [-1,0,0,0,0]
Output: 24
Explanation: After sub-assembly 0 is built, the remaining four children can be finished in any order, giving 4! = 24 sequences.
```$$,
  constraints = $$- `1 <= n <= 2 * 10^5`
- `parent.length == n`
- `parent[0] == -1`
- `0 <= parent[i] < n` for `i >= 1`
- The input is guaranteed to describe a valid rooted tree.$$
WHERE slug = 'count-assembly-orders';

UPDATE test_cases SET input = E'[-1,0,0,2,2]', expected_output = '8'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-assembly-orders')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[-1,0,1,2,3]', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-assembly-orders')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[-1,0,0,0,0]', expected_output = '24'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-assembly-orders')
  AND is_sample = TRUE AND order_index = 3;

-- count-reservoir-paths
UPDATE problems SET
  description = $$The irrigation grid feeds water into reservoir pads numbered `0` through `n`. A pump at pad `0` can only push water forward through one of two canal hops at a time: a short hop that advances the flow by 1 pad, or a long hop that advances it by 2 pads.

Implement `countReservoirPaths(n)` that returns the number of distinct hop sequences that move the flow from pad `0` to reservoir pad `n`.

**Example 1:**
```
Input: n = 4
Output: 5
Explanation: The valid sequences are 1+1+1+1, 1+1+2, 1+2+1, 2+1+1, and 2+2.
```

**Example 2:**
```
Input: n = 5
Output: 8
Explanation: There are 8 distinct short/long hop sequences that sum to 5.
```$$,
  constraints = $$- `1 <= n <= 40`$$
WHERE slug = 'count-reservoir-paths';

UPDATE test_cases SET input = E'4', expected_output = '5'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-reservoir-paths')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'5', expected_output = '8'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-reservoir-paths')
  AND is_sample = TRUE AND order_index = 2;

-- split-headline-tokens
UPDATE problems SET
  description = $$A news aggregator occasionally receives a run-on `headline` — a lowercase string with the spaces stripped out — along with a `topics` list of known topic tokens. An editor wants to know whether the headline can be cut back into a space-separated sequence of one or more topic tokens from the list, reusing any token as many times as needed.

Implement `splitHeadlineTokens(headline, topics)` that returns `true` if such a segmentation exists, and `false` otherwise.

**Example 1:**
```
Input: headline = "morningwire", topics = ["morning","wire"]
Output: true
Explanation: "morningwire" splits into "morning wire".
```

**Example 2:**
```
Input: headline = "topstoryalert", topics = ["top","story","alert"]
Output: true
Explanation: "topstoryalert" splits into "top story alert".
```

**Example 3:**
```
Input: headline = "breakingnews", topics = ["break","breaking","new","ing"]
Output: false
Explanation: Every prefix that matches a token leaves a suffix that cannot be fully covered — "news" never appears as a prefix of a topic token, and neither does a trailing "s".
```$$,
  constraints = $$- `1 <= headline.length <= 400`
- `1 <= topics.length <= 1500`
- `1 <= topics[i].length <= 25`
- `headline` and each `topics[i]` consist only of lowercase English letters.
- All strings in `topics` are distinct.$$
WHERE slug = 'split-headline-tokens';

UPDATE test_cases SET input = E'morningwire\n["morning","wire"]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-headline-tokens')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'topstoryalert\n["top","story","alert"]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-headline-tokens')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'breakingnews\n["break","breaking","new","ing"]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-headline-tokens')
  AND is_sample = TRUE AND order_index = 3;

-- unify-crew-contacts
UPDATE problems SET
  description = $$A line producer keeps a running roster of crew contacts as the shoot grows. Each entry starts with a crew member's name followed by every email address that person has used across call-sheets. When two entries share at least one email, they belong to the same human — even though two different people can happen to share the same name.

Implement `unifyContactIdentities(accounts)` that merges any two entries that share at least one email (transitively), and returns the consolidated roster. Each returned entry begins with the name, followed by that crew member's unique emails **sorted lexicographically**. The roster entries themselves may be returned in any order.

**Example 1:**
```
Input: accounts = [["Maya","maya.dp@set.film","mayalens@set.film"],["Maya","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]
Output: [["Maya","maya.dp@set.film","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]
Explanation: The first two Maya entries share `mayalens@set.film`, so they collapse into one person with three emails. The third Maya shares no email with anyone and stays separate. Leo has no overlap either.
```

**Example 2:**
```
Input: accounts = [["Ash","ash1@set.film","ash2@set.film"],["Bea","bea1@set.film","bea2@set.film"],["Cal","cal1@set.film","cal2@set.film"]]
Output: [["Ash","ash1@set.film","ash2@set.film"],["Bea","bea1@set.film","bea2@set.film"],["Cal","cal1@set.film","cal2@set.film"]]
Explanation: No emails are shared between entries, so each entry is kept as-is with its emails sorted.
```$$,
  constraints = $$- `1 <= accounts.length <= 1500`
- `2 <= accounts[i].length <= 10`
- `1 <= accounts[i][j].length <= 30`
- `accounts[i][0]` consists of English letters.
- `accounts[i][j]` for `j > 0` is a valid email address.$$
WHERE slug = 'unify-crew-contacts';

UPDATE test_cases SET input = E'[["Maya","maya.dp@set.film","mayalens@set.film"],["Maya","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]', expected_output = '[["Maya","maya.dp@set.film","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unify-crew-contacts')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[["Ash","ash1@set.film","ash2@set.film"],["Bea","bea1@set.film","bea2@set.film"],["Cal","cal1@set.film","cal2@set.film"]]', expected_output = '[["Ash","ash1@set.film","ash2@set.film"],["Bea","bea1@set.film","bea2@set.film"],["Cal","cal1@set.film","cal2@set.film"]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unify-crew-contacts')
  AND is_sample = TRUE AND order_index = 2;

-- seize-enclosed-zones
UPDATE problems SET
  description = $$Dispatch maintains a district map where `'X'` marks a district that has been cleared by responders and `'O'` marks a district still flagged active. A flagged district is only genuinely unreachable — and therefore safe to mark cleared — if no chain of 4-adjacent `'O'` districts connects it to the map's outer edge. Any active region that touches the first row, last row, first column, or last column must remain active because reinforcements can still reach it from the perimeter.

Implement `seizeEnclosedZones(grid)` that modifies `grid` **in place**, turning every `'O'` that is fully surrounded by `'X'` districts into `'X'`, while leaving any `'O'` connected (via up/down/left/right) to the perimeter untouched. Return the modified grid.

**Example 1:**
```
Input: grid = [["X","X","X","X"],["X","O","X","X"],["X","X","O","X"],["X","X","X","O"]]
Output: [["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","X","X","O"]]
Explanation: The `'O'` at (1,1) and the `'O'` at (2,2) are both fully surrounded, so they are marked cleared. The `'O'` at (3,3) lies on the perimeter and is left alone.
```

**Example 2:**
```
Input: grid = [["O","X"],["O","X"]]
Output: [["O","X"],["O","X"]]
Explanation: Both `'O'` cells sit on the first column, so they are already perimeter-connected and nothing changes.
```$$,
  constraints = $$- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 180`
- `grid[i][j]` is `'X'` or `'O'`.$$
WHERE slug = 'seize-enclosed-zones';

UPDATE test_cases SET input = E'[["X","X","X","X"],["X","O","X","X"],["X","X","O","X"],["X","X","X","O"]]', expected_output = '[["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","X","X","O"]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'seize-enclosed-zones')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[["O"]]', expected_output = '[["O"]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'seize-enclosed-zones')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[["O","X"],["O","X"]]', expected_output = '[["O","X"],["O","X"]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'seize-enclosed-zones')
  AND is_sample = TRUE AND order_index = 3;

-- tally-device-meshes
UPDATE problems SET
  description = $$A smart home's hub tracks `n` paired devices labelled `0` to `n - 1`, together with the radio relays that currently let them talk to each other. Each entry `relays[i] = [a, b]` means device `a` and device `b` can reach each other directly. Two devices belong to the same mesh if a chain of relays lets one hear the other, directly or through intermediates.

Implement `tallyDeviceMeshes(n, relays)` that returns how many independent device meshes exist across the home. An isolated device with no relays still counts as its own mesh of size one.

**Example 1:**
```
Input: n = 6, relays = [[0,1],[2,3],[3,4]]
Output: 3
Explanation: Devices `{0,1}` talk through one relay, `{2,3,4}` are chained together, and device `5` sits alone — three meshes in total.
```

**Example 2:**
```
Input: n = 7, relays = [[0,1],[1,2],[2,3],[3,4],[4,5],[5,6]]
Output: 1
Explanation: Every device is reachable from every other device through the relay chain, so the entire home forms a single mesh.
```$$,
  constraints = $$- `1 <= n <= 2000`
- `0 <= relays.length <= 5000`
- `relays[i].length == 2`
- `0 <= a, b < n`
- `a != b`
- No pair appears in `relays` more than once.$$
WHERE slug = 'tally-device-meshes';

UPDATE test_cases SET input = E'6\n[[0,1],[2,3],[3,4]]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tally-device-meshes')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'7\n[[0,1],[1,2],[2,3],[3,4],[4,5],[5,6]]', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tally-device-meshes')
  AND is_sample = TRUE AND order_index = 2;

-- sequence-assembly-steps
UPDATE problems SET
  description = $$A plant's production planner has `numSteps` assembly steps labelled `0` to `numSteps - 1` on a single run. Some steps cannot start until a specific earlier step has finished: each entry `prereqs[i] = [a, b]` means step `b` must be completed before step `a` can begin.

Implement `sequenceAssemblySteps(numSteps, prereqs)` that returns an order in which every step can be executed while respecting the prerequisites. If several valid orderings exist, any of them is acceptable. If the prerequisites form a cycle — making a valid schedule impossible — return an empty array.

**Example 1:**
```
Input: numSteps = 3, prereqs = [[2,0],[1,0]]
Output: [0,1,2]
Explanation: Step `0` has no prerequisites, so it runs first. Steps `1` and `2` can then run in either order; `[0,1,2]` is one valid sequence.
```

**Example 2:**
```
Input: numSteps = 5, prereqs = [[1,0],[2,1],[3,1],[4,2],[4,3]]
Output: [0,1,2,3,4]
Explanation: Step `0` must precede `1`, which must precede both `2` and `3`, and both must precede `4`. The sequence `[0,1,2,3,4]` respects every edge.
```$$,
  constraints = $$- `1 <= numSteps <= 2000`
- `0 <= prereqs.length <= numSteps * (numSteps - 1)`
- `prereqs[i].length == 2`
- `0 <= a, b < numSteps`
- `a != b`
- All pairs `[a, b]` in `prereqs` are distinct.$$
WHERE slug = 'sequence-assembly-steps';

UPDATE test_cases SET input = E'3\n[[2,0],[1,0]]', expected_output = '[0,1,2]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sequence-assembly-steps')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'5\n[[1,0],[2,1],[3,1],[4,2],[4,3]]', expected_output = '[0,1,2,3,4]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sequence-assembly-steps')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'1\n[]', expected_output = '[0]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sequence-assembly-steps')
  AND is_sample = TRUE AND order_index = 3;

-- verify-shoot-plan
UPDATE problems SET
  description = $$A 1st AD is sanity-checking a multi-day shooting plan. There are `numScenes` scenes labelled `0` to `numScenes - 1`. Some scenes have continuity prerequisites — each entry `prereqs[i] = [a, b]` means scene `b` must be in the can before scene `a` can be shot.

Implement `verifyShootPlan(numScenes, prereqs)` that returns `true` if there is some shooting order that respects every prerequisite, or `false` if the prerequisites form a circular dependency that can never be satisfied.

**Example 1:**
```
Input: numScenes = 4, prereqs = [[1,0],[2,0],[3,1]]
Output: true
Explanation: Scene `0` can be shot first, then `1` and `2` (which both only need `0`), and finally `3`. No circular dependency exists.
```

**Example 2:**
```
Input: numScenes = 3, prereqs = [[0,2],[2,1],[1,0]]
Output: false
Explanation: Scene `0` needs `2`, `2` needs `1`, and `1` needs `0`. The three-way loop means no scene can ever be shot first.
```$$,
  constraints = $$- `1 <= numScenes <= 2000`
- `0 <= prereqs.length <= 5000`
- `prereqs[i].length == 2`
- `0 <= a, b < numScenes`
- All pairs `prereqs[i]` are distinct.$$
WHERE slug = 'verify-shoot-plan';

UPDATE test_cases SET input = E'4\n[[1,0],[2,0],[3,1]]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'verify-shoot-plan')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'3\n[[0,2],[2,1],[1,0]]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'verify-shoot-plan')
  AND is_sample = TRUE AND order_index = 2;

-- resolve-price-ratios
UPDATE problems SET
  description = $$A retail analyst has a stack of promo sheets from the grocery chain. Each sheet compares two items and states the ratio of their unit prices: `ratios[i] = [Ai, Bi]` with `values[i]` means one unit of `Ai` costs `values[i]` times one unit of `Bi`. Starting from these comparisons, the analyst wants to answer a list of new ratio questions.

Implement `resolvePriceRatios(ratios, values, queries)` that returns, for every `queries[i] = [Ci, Di]`, the value of `Ci / Di` implied by the known ratios. If the two items cannot be connected through a chain of ratios — including when one of them has never appeared — return `-1.0` for that query. Note that if `A / B = k` is known, then `B / A = 1 / k` is equally known, and `A / A = 1.0` for any item that appears in at least one ratio.

**Example 1:**
```
Input: ratios = [["milk","bread"],["bread","eggs"]], values = [4.0,2.0], queries = [["milk","eggs"],["eggs","bread"],["bread","milk"],["milk","milk"],["soap","milk"]]
Output: [8.00000,0.50000,0.25000,1.00000,-1.00000]
Explanation: `milk/eggs = (milk/bread) * (bread/eggs) = 4.0 * 2.0 = 8.0`; `eggs/bread = 1/2.0 = 0.5`; `bread/milk = 1/4.0 = 0.25`; `milk/milk = 1.0`; `soap` never appears so its query is `-1.0`.
```

**Example 2:**
```
Input: ratios = [["apple","pear"],["pear","plum"],["kiwi","lime"]], values = [3.0,4.0,2.0], queries = [["apple","plum"],["plum","apple"],["kiwi","lime"],["apple","kiwi"]]
Output: [12.00000,0.08333,2.00000,-1.00000]
Explanation: Apple and plum are linked through pear, giving `3.0 * 4.0 = 12.0` and the reciprocal. Kiwi and lime form a separate component, so `kiwi/lime` is known but `apple/kiwi` is not.
```$$,
  constraints = $$- `1 <= ratios.length <= 25`
- `ratios[i].length == 2`
- `1 <= ratios[i][0].length, ratios[i][1].length <= 8`
- `values.length == ratios.length`
- `0.0 < values[i] <= 25.0`
- `1 <= queries.length <= 25`
- `queries[i].length == 2`
- `1 <= queries[i][0].length, queries[i][1].length <= 8`
- Item codes consist of lowercase English letters and digits.$$
WHERE slug = 'resolve-price-ratios';

UPDATE test_cases SET input = E'[["milk","bread"],["bread","eggs"]]\n[4.0,2.0]\n[["milk","eggs"],["eggs","bread"],["bread","milk"],["milk","milk"],["soap","milk"]]', expected_output = '[8.00000,0.50000,0.25000,1.00000,-1.00000]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'resolve-price-ratios')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[["apple","pear"],["pear","plum"],["kiwi","lime"]]\n[3.0,4.0,2.0]\n[["apple","plum"],["plum","apple"],["kiwi","lime"],["apple","kiwi"]]', expected_output = '[12.00000,0.08333,2.00000,-1.00000]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'resolve-price-ratios')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[["x","y"]]\n[4.0]\n[["x","y"],["y","x"],["x","z"]]', expected_output = '[4.00000,0.25000,-1.00000]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'resolve-price-ratios')
  AND is_sample = TRUE AND order_index = 3;

-- fanout-responder-reach
UPDATE problems SET
  description = $$A dispatch operations center tracks how quickly deployed responders can reach every block of the city. The city is laid out as an `m x n` grid where each cell is one of three values:

- `-1` -- a **closed block** (impassable due to ongoing hazard)
- `0` -- a **responder post** (a responder is already stationed here)
- `2147483647` -- an **open block** awaiting coverage

Replace every open block's value with the number of 4-directional steps to the nearest responder post, moving only up, down, left, or right across open blocks. If an open block has no reachable post, leave it at `2147483647`. Update `grid` **in place** and return it.

**Example 1:**
```
Input: grid = [[2147483647,0,-1,2147483647],[2147483647,2147483647,2147483647,2147483647],[-1,2147483647,0,2147483647],[2147483647,2147483647,2147483647,-1]]
Output: [[1,0,-1,3],[2,1,1,2],[-1,2,0,1],[3,2,1,-1]]
Explanation: Responder posts sit at (0,1) and (2,2). Each open block is stamped with its step count to the closer post; the cell at (0,3) is three steps from (0,1) because (0,2) is closed.
```

**Example 2:**
```
Input: grid = [[0,2147483647,2147483647],[-1,2147483647,-1],[2147483647,2147483647,0]]
Output: [[0,1,2],[-1,2,-1],[2,1,0]]
Explanation: Two closed blocks in the middle row force a detour, but every open block still reaches one of the posts.
```$$,
  constraints = $$- `1 <= m, n <= 250`
- `grid[i][j]` is `-1`, `0`, or `2147483647`.$$
WHERE slug = 'fanout-responder-reach';

UPDATE test_cases SET input = E'[[2147483647,0,-1,2147483647],[2147483647,2147483647,2147483647,2147483647],[-1,2147483647,0,2147483647],[2147483647,2147483647,2147483647,-1]]', expected_output = '[[1,0,-1,3],[2,1,1,2],[-1,2,0,1],[3,2,1,-1]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fanout-responder-reach')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[0,2147483647,2147483647],[-1,2147483647,-1],[2147483647,2147483647,0]]', expected_output = '[[0,1,2],[-1,2,-1],[2,1,0]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fanout-responder-reach')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[[2147483647,2147483647],[2147483647,-1]]', expected_output = '[[2147483647,2147483647],[2147483647,-1]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fanout-responder-reach')
  AND is_sample = TRUE AND order_index = 3;

-- snapshot-mesh-layout
UPDATE problems SET
  description = $$Before running a what-if simulation on the transit network, the operations team needs an independent copy so experimental changes never touch the live topology. You are given a reference to one `station` node in a connected undirected graph of subway stations; every station has an integer `val` and a list of its transfer `neighbors`.

Return a **deep copy** of the entire connected network reachable from the given station. Every node in the returned snapshot must be newly allocated with the same `val` and the same adjacency structure, and no node in the snapshot may be the same object as any node in the original.

The graph is fed to the driver as an adjacency list, where index `i` (0-based) holds the neighbors of the station with `val = i + 1`. The given entry point always has `val = 1` when the graph is non-empty.

**Example 1:**
```
Input: adjList = [[2,3],[1,4],[1,5],[2,5],[3,4]]
Output: [[2,3],[1,4],[1,5],[2,5],[3,4]]
Explanation: Station 1 transfers to 2 and 3. Station 2 transfers to 1 and 4. The snapshot mirrors every edge but uses fresh node objects.
```

**Example 2:**
```
Input: adjList = [[2],[1,3],[2]]
Output: [[2],[1,3],[2]]
Explanation: A three-station linear line is cloned edge-for-edge.
```$$,
  constraints = $$- The number of stations in the network is in the range `[0, 100]`.
- `1 <= station.val <= 100`
- `station.val` is unique per node.
- The graph has no self-loops and no repeated edges.$$
WHERE slug = 'snapshot-mesh-layout';

UPDATE test_cases SET input = E'[[2,3],[1,4],[1,5],[2,5],[3,4]]', expected_output = '[[2,3],[1,4],[1,5],[2,5],[3,4]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'snapshot-mesh-layout')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[2],[1,3],[2]]', expected_output = '[[2],[1,3],[2]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'snapshot-mesh-layout')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[]', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'snapshot-mesh-layout')
  AND is_sample = TRUE AND order_index = 3;

-- tally-planted-regions
UPDATE problems SET
  description = $$A vineyard manager surveys a rectangular block map before harvest, where each cell marks one square of ground. `"1"` means the square is planted with vines and `"0"` means it has been left fallow. A **planted region** is a maximal group of planted squares that are connected 4-directionally (up, down, left, right) — diagonals do not count.

Given the `m x n` `field` grid, return the number of distinct planted regions. Assume the grid is bordered on all four sides by fallow ground.

**Example 1:**
```
Input: field = [["0","1","1","0","0","1"],["1","1","0","0","0","1"],["0","0","0","1","0","0"],["1","0","0","1","1","0"],["1","0","0","0","0","1"]]
Output: 5
Explanation: The planted squares cluster into five 4-connected regions — the top-left L, the right-column pair, the central patch around (2,3), the left-side pair at (3,0)/(4,0), and the lone vine at (4,5).
```

**Example 2:**
```
Input: field = [["1","1","0","0"],["0","1","0","1"],["0","0","0","1"]]
Output: 2
Explanation: One region sits in the upper-left corner, and a separate column of two vines occupies the right edge.
```$$,
  constraints = $$- `m == field.length`
- `n == field[i].length`
- `1 <= m, n <= 250`
- `field[i][j]` is `'0'` or `'1'`.$$
WHERE slug = 'tally-planted-regions';

UPDATE test_cases SET input = E'[["0","1","1","0","0","1"],["1","1","0","0","0","1"],["0","0","0","1","0","0"],["1","0","0","1","1","0"],["1","0","0","0","0","1"]]', expected_output = '5'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tally-planted-regions')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[["1","1","0","0"],["0","1","0","1"],["0","0","0","1"]]', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tally-planted-regions')
  AND is_sample = TRUE AND order_index = 2;

-- trace-dual-drainage
UPDATE problems SET
  description = $$A terraced farm sits on a rectangular `m x n` slope. `field[r][c]` gives the elevation of the plot at row `r`, column `c`. The farm is flanked by two reservoirs: the **upland reservoir** collects runoff from any plot along the top edge (row 0) or left edge (column 0), and the **lowland reservoir** collects runoff from any plot along the bottom edge or right edge.

Water flows from a plot to any 4-directional neighbor whose elevation is **less than or equal to** the current plot's elevation; any edge-adjacent plot drains into its neighboring reservoir directly.

Return every coordinate `[r, c]` whose runoff can reach **both** reservoirs. Order does not matter.

**Example 1:**
```
Input: field = [[2,1,3,4,5],[3,2,3,5,6],[4,3,5,4,3],[5,6,4,3,2],[6,5,3,2,1]]
Output: [[0,4],[1,3],[1,4],[2,2],[3,1],[4,0]]
Explanation: Plot (2,2) sits on the central ridge — water can step down-left to reach the upland reservoir and down-right to reach the lowland one.
```

**Example 2:**
```
Input: field = [[2,4,6],[5,7,9],[8,10,12]]
Output: [[0,2],[1,2],[2,0],[2,1],[2,2]]
Explanation: Elevation rises monotonically toward the bottom-right, so only the right column and bottom row drain into both reservoirs.
```$$,
  constraints = $$- `m == field.length`
- `n == field[r].length`
- `1 <= m, n <= 200`
- `0 <= field[r][c] <= 80000`$$
WHERE slug = 'trace-dual-drainage';

UPDATE test_cases SET input = E'[[2,1,3,4,5],[3,2,3,5,6],[4,3,5,4,3],[5,6,4,3,2],[6,5,3,2,1]]', expected_output = '[[0,4],[1,3],[1,4],[2,2],[3,1],[4,0]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'trace-dual-drainage')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[2,4,6],[5,7,9],[8,10,12]]', expected_output = '[[0,2],[1,2],[2,0],[2,1],[2,2]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'trace-dual-drainage')
  AND is_sample = TRUE AND order_index = 2;

-- check-key-reachability
UPDATE problems SET
  description = $$A warehouse has `n` secured aisles numbered `0` to `n - 1`. Each aisle stores a set of key cards that unlock **other** aisles. Every aisle is locked except aisle `0`, which is open for the picker at shift start.

When the picker walks into an aisle, they collect every key card stored there and can use any collected card to open the corresponding aisle. Given `aisles`, where `aisles[i]` lists the aisle numbers whose key cards are stored in aisle `i`, return `true` if the picker can eventually enter **every** aisle, or `false` otherwise.

**Example 1:**
```
Input: aisles = [[2,1],[4],[3],[],[3,0]]
Output: true
Explanation: Start in aisle 0 and pick up cards for 2 and 1. Aisle 1 holds the card for 4; aisle 2 holds the card for 3. Visiting 3 and 4 covers all five aisles.
```

**Example 2:**
```
Input: aisles = [[2],[3],[],[4],[1]]
Output: false
Explanation: Aisle 0 only offers the card for aisle 2, and aisle 2 is empty. The cards for aisles 1, 3, and 4 sit inside those aisles themselves, so they are never reachable.
```$$,
  constraints = $$- `1 <= n <= 1000`
- `0 <= aisles[i].length <= n`
- `0 <= aisles[i][j] < n`
- All values in `aisles[i]` are unique.$$
WHERE slug = 'check-key-reachability';

UPDATE test_cases SET input = E'[[2,1],[4],[3],[],[3,0]]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'check-key-reachability')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[2],[3],[],[4],[1]]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'check-key-reachability')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[[1],[0]]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'check-key-reachability')
  AND is_sample = TRUE AND order_index = 3;

-- spread-contamination-wave
UPDATE problems SET
  description = $$An isolation unit is laid out as an `m x n` grid of bed slots. Every minute, each bed is classified as one of three states:

- `0` — an **empty slot** (no patient)
- `1` — a **stable patient**
- `2` — an **infectious patient**

Contamination spreads one cell per minute: any stable patient who shares a 4-directional edge with an infectious patient becomes infectious at the end of that minute. Return the minimum number of minutes until no stable patient remains. If any stable patient can never be reached, return `-1`.

**Example 1:**
```
Input: ward = [[2,1,1],[1,0,1],[1,1,1]]
Output: 4
Explanation: Starting from the single infectious bed at (0,0), the wave reaches its last stable patient at (2,2) after four minutes.
```

**Example 2:**
```
Input: ward = [[2,0,1],[0,0,1],[1,1,1]]
Output: -1
Explanation: The infectious bed at (0,0) is walled off by empty slots, so the wave can never reach the stable patients.
```

**Example 3:**
```
Input: ward = [[0,0,2],[0,0,0]]
Output: 0
Explanation: There are no stable patients, so zero minutes pass.
```$$,
  constraints = $$- `m == ward.length`
- `n == ward[i].length`
- `1 <= m, n <= 10`
- `ward[i][j]` is `0`, `1`, or `2`.$$
WHERE slug = 'spread-contamination-wave';

UPDATE test_cases SET input = E'[[2,1,1],[1,0,1],[1,1,1]]', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'spread-contamination-wave')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[2,0,1],[0,0,1],[1,1,1]]', expected_output = '-1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'spread-contamination-wave')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[[0,0,2],[0,0,0]]', expected_output = '0'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'spread-contamination-wave')
  AND is_sample = TRUE AND order_index = 3;

-- chart-block-route
UPDATE problems SET
  description = $$You control the traffic-management console for a small district laid out as an `n x n` grid of intersections. Each cell of `grid` is either `0` (clear to drive through) or `1` (closed due to an incident). A dispatcher needs the fastest king-style corridor from the northwest corner `(0, 0)` to the southeast corner `(n - 1, n - 1)`, where a vehicle may roll into any of the 8 adjacent intersections each step (N, S, E, W, or diagonal).

Implement `chartBlockRoute(grid)` to return the number of intersections on the shortest clear corridor, counting both endpoints. Every intersection visited along the corridor must hold value `0`. If either endpoint is closed or no corridor exists, return `-1`.

**Example 1:**
```
Input: grid = [[0,0],[0,0]]
Output: 2
Explanation: A single diagonal step from (0,0) to (1,1) visits 2 clear intersections.
```

**Example 2:**
```
Input: grid = [[0,1,0],[0,0,0],[1,0,0]]
Output: 3
Explanation: The corridor (0,0) -> (1,1) -> (2,2) visits 3 intersections and avoids every closure.
```$$,
  constraints = $$- `n == grid.length`
- `n == grid[i].length`
- `1 <= n <= 120`
- Each `grid[i][j]` is `0` or `1`$$
WHERE slug = 'chart-block-route';

UPDATE test_cases SET input = E'[[0,0],[0,0]]', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'chart-block-route')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[0,1,0],[0,0,0],[1,0,0]]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'chart-block-route')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[[0,1],[1,0]]', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'chart-block-route')
  AND is_sample = TRUE AND order_index = 3;

-- split-into-two-shifts
UPDATE problems SET
  description = $$A restaurant manager wants to split the floor staff into exactly two rotating shifts. Each staff member has an index from `0` to `n - 1`, and `conflicts[i]` lists the indices of coworkers who cannot be scheduled on the same shift as staff `i` (either a personality clash or an overlapping station). The conflict relation is symmetric and may contain several disjoint clusters of staff.

Implement `splitIntoTwoShifts(conflicts)` to return `true` if it is possible to assign every staff member to one of two shifts so that no two conflicting coworkers land on the same shift, or `false` if any cluster of conflicts makes that impossible.

**Example 1:**
```
Input: conflicts = [[1],[0,2],[1,3],[2]]
Output: true
Explanation: Place staff 0 and 2 on the morning shift and staff 1 and 3 on the evening shift; every listed conflict crosses shifts.
```

**Example 2:**
```
Input: conflicts = [[1,2],[0,2],[0,1]]
Output: false
Explanation: Staff 0, 1, and 2 mutually conflict, so any assignment of three people to two shifts forces two of them together.
```$$,
  constraints = $$- `1 <= conflicts.length <= 150`
- `0 <= conflicts[i].length < conflicts.length`
- `conflicts[i]` does not contain `i`
- If `conflicts[i]` contains `j`, then `conflicts[j]` contains `i`
- The conflict graph may be disconnected$$
WHERE slug = 'split-into-two-shifts';

UPDATE test_cases SET input = E'[[1],[0,2],[1,3],[2]]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-into-two-shifts')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[1,2],[0,2],[0,1]]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-into-two-shifts')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[[],[],[]]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-into-two-shifts')
  AND is_sample = TRUE AND order_index = 3;

-- is-acyclic-network
UPDATE problems SET
  description = $$A courier company models its depots as `n` nodes labeled `0` to `n - 1` and its bidirectional transfer lanes as a list of `lanes`, where each entry `[u, v]` means parcels can flow freely between depot `u` and depot `v`. Dispatch wants the network to be a clean hierarchy: every depot should be reachable from every other depot, and there should be no redundant loops that let a parcel circle back on itself.

Implement `isAcyclicNetwork(n, lanes)` to return `true` if the depots and lanes together form a single fully connected structure with no cycles, and `false` otherwise.

**Example 1:**
```
Input: n = 6, lanes = [[0,1],[0,2],[1,3],[1,4],[2,5]]
Output: true
Explanation: All 6 depots are reachable from depot 0, and the 5 lanes introduce no loops.
```

**Example 2:**
```
Input: n = 4, lanes = [[0,1],[1,2],[2,0],[0,3]]
Output: false
Explanation: Depots 0, 1, and 2 form a cycle, so the structure is not loop-free.
```$$,
  constraints = $$- `1 <= n <= 2 * 10^3`
- `0 <= lanes.length <= 4500`
- `lanes[i].length == 2`
- `0 <= lanes[i][0], lanes[i][1] < n`
- No self-loops and no duplicate lanes$$
WHERE slug = 'is-acyclic-network';

UPDATE test_cases SET input = E'6\n[[0,1],[0,2],[1,3],[1,4],[2,5]]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'is-acyclic-network')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'4\n[[0,1],[1,2],[2,0],[0,3]]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'is-acyclic-network')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'5\n[[0,1],[2,3]]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'is-acyclic-network')
  AND is_sample = TRUE AND order_index = 3;

-- bridge-label-chain
UPDATE problems SET
  description = $$At a recycling plant, every sort station is tagged with a short lowercase code, and reconfiguring the line means editing those codes one letter at a time. Each reconfiguration step replaces a single character in the current code, and the resulting code must appear in the approved bank `codeBank` of station labels. You are given a starting label `startCode` and a target label `targetCode` of the same length.

Implement `bridgeLabelChain(startCode, targetCode, codeBank)` to return the total number of codes in the shortest sequence that begins at `startCode`, ends at `targetCode`, and changes exactly one character per step with every intermediate code drawn from `codeBank`. `startCode` does not need to appear in `codeBank`, but `targetCode` must. If no such sequence exists, return `0`.

**Example 1:**
```
Input: startCode = "pet", targetCode = "pot", codeBank = ["pit","pot","pat"]
Output: 3
Explanation: pet -> pit -> pot reconfigures one character per step and every intermediate code is approved.
```

**Example 2:**
```
Input: startCode = "pet", targetCode = "pot", codeBank = ["pit","pat"]
Output: 0
Explanation: The target code "pot" is not in codeBank, so no sequence can end there.
```$$,
  constraints = $$- `1 <= startCode.length <= 10`
- `targetCode.length == startCode.length`
- `1 <= codeBank.length <= 4500`
- `codeBank[i].length == startCode.length`
- `startCode`, `targetCode`, and each `codeBank[i]` consist of lowercase English letters
- `startCode != targetCode`$$
WHERE slug = 'bridge-label-chain';

UPDATE test_cases SET input = E'pet\npot\n["pit","pot","pat"]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bridge-label-chain')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'pet\npot\n["pit","pat"]', expected_output = '0'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bridge-label-chain')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'x\nz\n["x","y","z"]', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bridge-label-chain')
  AND is_sample = TRUE AND order_index = 3;

-- verify-bake-rotation
UPDATE problems SET
  description = $$A pastry chef records the number of loaves loaded into each successive slot of a conveyor oven. The rotation is considered **smooth** if the tray counts are non-decreasing from the first slot to the last (so later slots never hold fewer loaves than earlier ones).

Given an integer array `trays` of loaf counts, return `true` if you can make the sequence non-decreasing by adjusting **at most one** slot to a new count (any integer), and `false` otherwise.

**Example 1:**
```
Input: trays = [3,1,4,5]
Output: true
Explanation: Lowering the first slot to 1 yields [1,1,4,5], which is non-decreasing.
```

**Example 2:**
```
Input: trays = [6,4,2,3]
Output: false
Explanation: Two distinct slots are out of order, so a single adjustment cannot fix the rotation.
```$$,
  constraints = $$- `1 <= trays.length <= 2 * 10^5`
- `-10^8 <= trays[i] <= 10^8`$$
WHERE slug = 'verify-bake-rotation';

UPDATE test_cases SET input = E'[3,1,4,5]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'verify-bake-rotation')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[6,4,2,3]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'verify-bake-rotation')
  AND is_sample = TRUE AND order_index = 2;

-- balance-print-jobs
UPDATE problems SET
  description = $$A spooler at a copy shop stores queued jobs as a compact tag string: `(` means a job opens a new print batch, `)` closes the currently open batch, and `*` is a **flexible slot** that can be reinterpreted as `(`, as `)`, or dropped entirely when the queue is flushed.

A tag string is **balanced** if every opening tag is closed by a later closing tag and the overall order is well-formed. Given the queue string `code`, return `true` if some interpretation of the flexible slots makes `code` balanced, and `false` otherwise.

**Example 1:**
```
Input: code = "((*)"
Output: true
Explanation: Treating the flexible slot as ')' yields "(())", which is balanced.
```

**Example 2:**
```
Input: code = "())"
Output: false
Explanation: A closing tag has no opening partner and no flexible slot is available to compensate.
```$$,
  constraints = $$- `1 <= code.length <= 120`
- Each character of `code` is `'('`, `')'`, or `'*'`$$
WHERE slug = 'balance-print-jobs';

UPDATE test_cases SET input = E'((*)', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'balance-print-jobs')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'())', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'balance-print-jobs')
  AND is_sample = TRUE AND order_index = 2;

-- choose-start-station
UPDATE problems SET
  description = $$A driverless shuttle runs a circular subway loop with `n` platforms. At platform `i` the shuttle picks up `energy[i]` units from the charging coil, and the leg from platform `i` to platform `(i + 1) mod n` consumes `drain[i]` units. The shuttle starts with an empty battery at whichever platform you choose and must complete one full clockwise loop without the battery dipping below zero.

Given integer arrays `energy` and `drain`, return the index of a valid starting platform, or `-1` if no loop is possible. If a valid start exists, it is guaranteed to be unique.

**Example 1:**
```
Input: energy = [4,6,1,3,5], drain = [3,5,2,2,6]
Output: 0
```

**Example 2:**
```
Input: energy = [5,2,8], drain = [6,4,7]
Output: -1
```$$,
  constraints = $$- `n == energy.length == drain.length`
- `1 <= n <= 2 * 10^5`
- `0 <= energy[i], drain[i] <= 8000`$$
WHERE slug = 'choose-start-station';

UPDATE test_cases SET input = E'[4,6,1,3,5]\n[3,5,2,2,6]', expected_output = '0'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'choose-start-station')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[5,2,8]\n[6,4,7]', expected_output = '-1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'choose-start-station')
  AND is_sample = TRUE AND order_index = 2;

-- group-oven-bakes
UPDATE problems SET
  description = $$A bakery scheduler holds a multiset of tray numbers waiting to be baked, where tray number `t` indicates a recipe labeled `t` on the master rotation chart. The head baker wants to fire the ovens in **runs** of exactly `runSize` trays whose recipe numbers are consecutive integers (for example `{7,8,9}` when `runSize = 3`). Every tray in the queue must belong to exactly one such run.

Given the integer array `trays` and the integer `runSize`, return `true` if the queue can be partitioned into runs of `runSize` consecutive recipe numbers, and `false` otherwise.

**Example 1:**
```
Input: trays = [2,3,4,5,6,7], runSize = 3
Output: true
Explanation: Fire the ovens as [2,3,4] then [5,6,7].
```

**Example 2:**
```
Input: trays = [1,2,3,5], runSize = 2
Output: false
Explanation: After pairing [1,2], the leftover trays 3 and 5 are not consecutive.
```$$,
  constraints = $$- `1 <= trays.length <= 2 * 10^5`
- `0 <= trays[i] <= 10^8`
- `1 <= runSize <= trays.length`$$
WHERE slug = 'group-oven-bakes';

UPDATE test_cases SET input = E'[2,3,4,5,6,7]\n3', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'group-oven-bakes')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[1,2,3,5]\n2', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'group-oven-bakes')
  AND is_sample = TRUE AND order_index = 2;

-- order-ticket-holders
UPDATE problems SET
  description = $$A concert hall is re-sequencing its standby queue before releasing seats. Each ticket holder is described by a pair `[h, k]`, where `h` is the holder's height in centimeters and `k` is the number of holders **ahead** of them whose height is at least `h`. The queue is currently scrambled and you must rebuild the lineup so every holder's `k` value is consistent with the positions in front of them.

Given the array `holders`, return the reordered queue as a list of `[h, k]` pairs in order from front to back. A valid ordering is guaranteed to exist.

**Example 1:**
```
Input: holders = [[8,0],[6,0],[8,1],[4,2],[6,2]]
Output: [[6,0],[8,0],[4,2],[6,2],[8,1]]
```

**Example 2:**
```
Input: holders = [[5,0],[4,1],[5,1],[3,2]]
Output: [[5,0],[4,1],[3,2],[5,1]]
```$$,
  constraints = $$- `1 <= holders.length <= 2 * 10^3`
- `0 <= h <= 8 * 10^5`
- `0 <= k < holders.length`
- A valid queue ordering is guaranteed to exist$$
WHERE slug = 'order-ticket-holders';

UPDATE test_cases SET input = E'[[8,0],[6,0],[8,1],[4,2],[6,2]]', expected_output = '[[6,0],[8,0],[4,2],[6,2],[8,1]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'order-ticket-holders')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[5,0],[4,1],[5,1],[3,2]]', expected_output = '[[5,0],[4,1],[3,2],[5,1]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'order-ticket-holders')
  AND is_sample = TRUE AND order_index = 2;

-- fewest-van-hops
UPDATE problems SET
  description = $$A courier fleet plans a same-day run along a line of stops numbered `0` through `n - 1`. A van leaves the depot at stop `0` loaded with parcels. The dispatcher publishes an array `fuel` where `fuel[i]` is the farthest forward reach (in stops) the van can manage from stop `i` before it must re-fuel at whatever stop it lands on — from stop `i` the van may next visit any stop in the range `[i + 1, i + fuel[i]]`.

Write `minVanHops(fuel)` that returns the minimum number of hops the van must make to reach the final stop `n - 1`. The dispatcher guarantees the run is feasible, so you never need to report failure.

**Example 1:**
```
Input: fuel = [1,4,2,1,3,1,2]
Output: 3
Explanation: Hop from stop 0 to stop 1 (one step). From stop 1 the van can reach up to stop 5, so hop to stop 4. From stop 4 the van reaches stop 6, the final stop.
```

**Example 2:**
```
Input: fuel = [3,1,1,4,2,1]
Output: 2
Explanation: Hop from stop 0 directly to stop 3 (within the reach of 3). From stop 3 the van can reach up to stop 7, which covers the final stop 5.
```$$,
  constraints = $$- `1 <= fuel.length <= 2 * 10^3`
- `0 <= fuel[i] <= 1000`
- The final stop is guaranteed to be reachable from stop `0`.$$
WHERE slug = 'fewest-van-hops';

UPDATE test_cases SET input = E'[1,4,2,1,3,1,2]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fewest-van-hops')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[3,1,1,4,2,1]', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fewest-van-hops')
  AND is_sample = TRUE AND order_index = 2;

-- split-zone-runs
UPDATE problems SET
  description = $$A recycling plant feeds a single conveyor where every item is already tagged with a one-letter material code. For accounting, the plant cuts the shift's stream into as many consecutive runs as possible, subject to one rule: a given material code must appear in exactly one run, never split across two. The runs, concatenated in order, must reconstruct the original stream `stream`.

Write `splitZoneRuns(stream)` that returns the length of each run in order.

**Example 1:**
```
Input: stream = "mnopmpoqrqrts"
Output: [7,4,1,1]
Explanation: 'm', 'n', 'o', 'p' are all contained in the first 7 characters. Then 'q' and 'r' fill positions 7..10. 't' and 's' each occur once.
```

**Example 2:**
```
Input: stream = "xyzzyx"
Output: [6]
Explanation: 'x' bookends the stream, forcing 'y' and 'z' into the same run, so the entire string is one run.
```$$,
  constraints = $$- `1 <= stream.length <= 500`
- `stream` consists of lowercase English letters.$$
WHERE slug = 'split-zone-runs';

UPDATE test_cases SET input = E'mnopmpoqrqrts', expected_output = '[7,4,1,1]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-zone-runs')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'xyzzyx', expected_output = '[6]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-zone-runs')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'abcdef', expected_output = '[1,1,1,1,1,1]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-zone-runs')
  AND is_sample = TRUE AND order_index = 3;

-- peak-reading-window
UPDATE problems SET
  description = $$A weather station logs an hourly temperature anomaly — the deviation from the seasonal baseline — as an integer for each sample. The meteorologist wants the hottest continuous stretch of the log: the contiguous, non-empty window of readings whose sum is largest, and reports that sum as the heat-peak score.

Write `peakReadingSum(readings)` that returns the largest sum obtainable from any contiguous non-empty window of `readings`.

**Example 1:**
```
Input: readings = [3,-2,5,-1,2,-8,4,3]
Output: 7
Explanation: The window [3,-2,5,-1,2] sums to 7, which is the maximum.
```

**Example 2:**
```
Input: readings = [2,1,-3,6,4]
Output: 10
Explanation: The window [6,4] sums to 10. Taking the whole array sums to 10 as well.
```$$,
  constraints = $$- `1 <= readings.length <= 2 * 10^5`
- `|readings[i]| <= 10^8`$$
WHERE slug = 'peak-reading-window';

UPDATE test_cases SET input = E'[3,-2,5,-1,2,-8,4,3]', expected_output = '7'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'peak-reading-window')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[-4]', expected_output = '-4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'peak-reading-window')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[2,1,-3,6,4]', expected_output = '10'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'peak-reading-window')
  AND is_sample = TRUE AND order_index = 3;

-- finish-assembly-line
UPDATE problems SET
  description = $$An assembly line has `n` stations arranged left to right, indexed `0` through `n - 1`. A part enters at station `0`. Each station `i` has a slack value `slack[i]`: after station `i` handles the part, the part may be forwarded to any downstream station in the range `[i + 1, i + slack[i]]`. A slack of `0` means the part halts and cannot proceed further.

Write `canFinishLine(slack)` that returns `true` if it is possible to route the part from station `0` to station `n - 1`, and `false` otherwise.

**Example 1:**
```
Input: slack = [2,1,3,1,1,2]
Output: true
Explanation: Route 0 -> 2 (slack 2), 2 -> 5 (slack 3). Station 5 is the final station.
```

**Example 2:**
```
Input: slack = [2,0,0,1,3]
Output: false
Explanation: From station 0 the part can only reach stations 1 or 2, both of which halt it. Station 3 is unreachable.
```$$,
  constraints = $$- `1 <= slack.length <= 2 * 10^5`
- `0 <= slack[i] <= 8 * 10^4`$$
WHERE slug = 'finish-assembly-line';

UPDATE test_cases SET input = E'[2,1,3,1,1,2]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'finish-assembly-line')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[2,0,0,1,3]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'finish-assembly-line')
  AND is_sample = TRUE AND order_index = 2;

-- form-bale-triple
UPDATE problems SET
  description = $$A recycling plant presses mixed materials into labelled bales. Each incoming bale carries a three-channel profile `[paper, plastic, metal]` — the kilograms of each material inside. The plant manager wants to combine a subset of bales into one super-bale by laying them on top of each other: the super-bale's reading on each channel is the **maximum** across the chosen bales on that channel. A bale is only usable if every one of its channel readings is at most the corresponding channel in the `target` profile — otherwise it would overshoot that channel and disqualify the super-bale.

Write `canBuildBales(bales, target)` that returns `true` if some subset of usable bales combines (by channel-wise max) to exactly match `target`, and `false` otherwise.

**Example 1:**
```
Input: bales = [[3,2,1],[1,6,4],[3,1,7],[2,5,2]], target = [3,6,7]
Output: true
Explanation: Stack [3,2,1], [1,6,4], and [3,1,7]. The channel-wise maxima are [3,6,7].
```

**Example 2:**
```
Input: bales = [[2,3,4],[4,2,1]], target = [2,3,5]
Output: false
Explanation: The second bale overshoots channel 0 (4 > 2) so it is unusable. The first bale alone yields [2,3,4], and no usable bale can lift channel 2 up to 5.
```$$,
  constraints = $$- `1 <= bales.length <= 2 * 10^5`
- `bales[i].length == 3`
- `1 <= bales[i][j], target[j] <= 1000`$$
WHERE slug = 'form-bale-triple';

UPDATE test_cases SET input = E'[[3,2,1],[1,6,4],[3,1,7],[2,5,2]]\n[3,6,7]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'form-bale-triple')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[2,3,4],[4,2,1]]\n[2,3,5]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'form-bale-triple')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[[1,3,2],[3,1,2],[2,2,3],[1,1,1]]\n[3,3,3]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'form-bale-triple')
  AND is_sample = TRUE AND order_index = 3;

-- brightest-observed-targets
UPDATE problems SET
  description = $$An observatory logs the apparent brightness (in relative magnitude units) of every sky target captured during a night's run. A researcher preparing a stacking pipeline wants to know the `k`-th brightest reading, counting multiplicity — so within readings `[8, 3, 5, 5]` the 1st brightest is `8` and the 2nd brightest is `5`.

Implement `findBrightestTargets(readings, k)` so it returns the brightness value that sits in the `k`-th position when the log is sorted in descending order.

**Example 1:**
```
Input: readings = [7,2,9,4,9,6,3], k = 3
Output: 7
Explanation: Sorted descending: [9,9,7,6,4,3,2]. The 3rd entry is 7.
```

**Example 2:**
```
Input: readings = [12,5,8,5,8,15,3,11], k = 4
Output: 8
Explanation: Sorted descending: [15,12,11,8,8,5,5,3]. The 4th entry is 8.
```$$,
  constraints = $$- `1 <= k <= readings.length <= 2 * 10^5`
- `|readings[i]| <= 10^8`$$
WHERE slug = 'brightest-observed-targets';

UPDATE test_cases SET input = E'[7,2,9,4,9,6,3]\n3', expected_output = '7'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'brightest-observed-targets')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[12,5,8,5,8,15,3,11]\n4', expected_output = '8'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'brightest-observed-targets')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[20]\n1', expected_output = '20'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'brightest-observed-targets')
  AND is_sample = TRUE AND order_index = 3;

-- trending-feed-topics
UPDATE problems SET
  description = $$A news aggregator clusters incoming headlines by topic label and wants to surface the `k` topics mentioned most often in the current window. When two topics tie on mention count, the editor prefers the one that comes first alphabetically so the ranking is deterministic across refreshes.

Implement `rankTrendingTopics(topics, k)` so it returns the `k` topic labels with the highest frequency, ordered by count descending and then by label ascending on ties.

**Example 1:**
```
Input: topics = ["climate","climate","market","sports","market","climate","weather"], k = 2
Output: ["climate","market"]
Explanation: "climate" appears 3 times and "market" appears 2 times — the two loudest topics in the window.
```

**Example 2:**
```
Input: topics = ["tech","tech","film","film","music","books","music"], k = 3
Output: ["film","music","tech"]
Explanation: "film", "music", and "tech" all appear twice, so they are returned in alphabetical order.
```$$,
  constraints = $$- `1 <= topics.length <= 2 * 10^3`
- `1 <= topics[i].length <= 10`
- `topics[i]` consists of lowercase English letters
- `k` is in the range `[1, number of distinct topics]`
- The answer is guaranteed to be unique$$
WHERE slug = 'trending-feed-topics';

UPDATE test_cases SET input = E'["climate","climate","market","sports","market","climate","weather"]\n2', expected_output = '["climate","market"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'trending-feed-topics')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'["tech","tech","film","film","music","books","music"]\n3', expected_output = '["film","music","tech"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'trending-feed-topics')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'["update","news","update"]\n1', expected_output = '["update"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'trending-feed-topics')
  AND is_sample = TRUE AND order_index = 3;

-- station-run-planner
UPDATE problems SET
  description = $$A manufacturing line feeds a conveyor of parts, each labeled by the station code that must assemble it. Because each station needs a mandatory cool-down of `n` cycles between two consecutive runs of the same code, the planner must insert idle cycles where necessary. Parts may be reordered freely.

Each cycle the scheduler either runs one part at its target station or stays idle. Implement `planStationRuns(runs, n)` so it returns the minimum number of cycles required to process every part while respecting the cool-down.

**Example 1:**
```
Input: runs = ["P","P","P","P","Q","Q"], n = 3
Output: 13
Explanation: One valid schedule is P -> Q -> idle -> idle -> P -> Q -> idle -> idle -> P -> idle -> idle -> idle -> P, using 13 cycles.
```

**Example 2:**
```
Input: runs = ["A","B","C","A","B","D"], n = 1
Output: 6
Explanation: The order A -> B -> C -> A -> B -> D already separates identical stations by at least 1 cycle, so no idle cycles are needed.
```$$,
  constraints = $$- `1 <= runs.length <= 2 * 10^3`
- `runs[i]` is an uppercase English letter
- `0 <= n <= 100`$$
WHERE slug = 'station-run-planner';

UPDATE test_cases SET input = E'["P","P","P","P","Q","Q"]\n3', expected_output = '13'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'station-run-planner')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'["A","B","C","A","B","D"]\n1', expected_output = '6'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'station-run-planner')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'["R","R","S","S","T","T"]\n0', expected_output = '6'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'station-run-planner')
  AND is_sample = TRUE AND order_index = 3;

-- nearest-depot-stops
UPDATE problems SET
  description = $$A courier dispatch console shows every scheduled stop as an `[x, y]` coordinate relative to the central depot at the origin. Before dispatch, the planner pulls the `k` stops physically closest to the depot so the first van can be loaded with short-radius parcels.

The distance from a stop to the depot is the Euclidean distance `sqrt(x^2 + y^2)`. Implement `selectNearestStops(stops, k)` so it returns the `k` nearest stops. The answer is guaranteed to be unique except for the order in which the stops are listed.

**Example 1:**
```
Input: stops = [[2,4],[7,7]], k = 1
Output: [[2,4]]
Explanation: sqrt(2^2 + 4^2) ≈ 4.47 is less than sqrt(7^2 + 7^2) ≈ 9.90, so (2, 4) is the nearest stop.
```

**Example 2:**
```
Input: stops = [[5,5],[1,2],[-3,1],[4,-4]], k = 2
Output: [[-3,1],[1,2]]
Explanation: The closest two stops are (-3, 1) at sqrt(10) and (1, 2) at sqrt(5).
```$$,
  constraints = $$- `1 <= k <= stops.length <= 2 * 10^3`
- `|x|, |y| <= 10^8`$$
WHERE slug = 'nearest-depot-stops';

UPDATE test_cases SET input = E'[[2,4],[7,7]]\n1', expected_output = '[[2,4]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'nearest-depot-stops')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[5,5],[1,2],[-3,1],[4,-4]]\n2', expected_output = '[[-3,1],[1,2]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'nearest-depot-stops')
  AND is_sample = TRUE AND order_index = 2;

-- crush-heaviest-bales
UPDATE problems SET
  description = $$A recycling plant keeps a yard of compressed bales, each with a numeric weight. A crushing arm repeatedly grabs the two heaviest bales and slams them together. If the two bales weigh `x` and `y` with `x <= y`, the result is:

- If `x == y`, both bales are pulverized and removed.
- If `x != y`, the lighter bale is destroyed and the heavier bale is reduced to weight `y - x`.

Repeat until at most one bale remains in the yard. Implement `crushHeaviestBales(bales)` so it returns the weight of the final remaining bale, or `0` if the yard is empty.

**Example 1:**
```
Input: bales = [3,6,4,9,5,2]
Output: 1
Explanation:
Crush 9 and 6 -> remaining 3; yard becomes [3,4,5,2,3].
Crush 5 and 4 -> remaining 1; yard becomes [3,2,3,1].
Crush 3 and 3 -> both destroyed; yard becomes [2,1].
Crush 2 and 1 -> remaining 1; yard becomes [1].
```

**Example 2:**
```
Input: bales = [9]
Output: 9
```$$,
  constraints = $$- `1 <= bales.length <= 40`
- `1 <= bales[i] <= 1500`$$
WHERE slug = 'crush-heaviest-bales';

UPDATE test_cases SET input = E'[3,6,4,9,5,2]', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'crush-heaviest-bales')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[9]', expected_output = '9'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'crush-heaviest-bales')
  AND is_sample = TRUE AND order_index = 2;

-- space-recipe-bakes
UPDATE problems SET
  description = $$A space-galley bakery ovens pipeline needs to sequence a tray of portions, each tagged by a recipe letter. To avoid flavor crossover, no two adjacent portions on the cooling rack may share the same recipe letter.

Implement `orderRecipeBakes(recipes)` so it returns any arrangement of the letters in `recipes` such that no two adjacent letters are equal. If no such arrangement exists, return the empty string `""`.

**Example 1:**
```
Input: recipes = "bread"
Output: "brade"
Explanation: Any arrangement with no two equal adjacent letters is accepted — e.g. "brade" or "dabre".
```

**Example 2:**
```
Input: recipes = "aaaab"
Output: ""
Explanation: The letter 'a' appears 4 times in a length-5 string, so any arrangement must place two 'a's next to each other.
```

**Example 3:**
```
Input: recipes = "flour"
Output: "flour"
Explanation: All letters are distinct, so the input itself is already a valid arrangement.
```$$,
  constraints = $$- `1 <= recipes.length <= 800`
- `recipes` consists of lowercase English letters only$$
WHERE slug = 'space-recipe-bakes';

UPDATE test_cases SET input = E'bread', expected_output = 'valid'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'space-recipe-bakes')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'aaaab', expected_output = ''
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'space-recipe-bakes')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'flour', expected_output = 'valid'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'space-recipe-bakes')
  AND is_sample = TRUE AND order_index = 3;

-- cover-watering-windows
UPDATE problems SET
  description = $$A dawn irrigation crew has mapped every thirsty plot on the farm as a 1D watering window along the main pipeline. Each plot is described as `[start, end]` (inclusive on both sides) giving the pipeline positions a sprinkler must reach to soak that plot.

You can drop a sprinkler at any pipeline position `x`. A single sprinkler at `x` waters every plot whose window satisfies `start <= x <= end`. Given a list `plots` of these windows, return the **minimum** number of sprinklers needed so that every plot is watered at least once.

**Example 1:**
```
Input: plots = [[5,11],[3,9],[8,14],[12,18],[20,25]]
Output: 3
Explanation: One valid placement is sprinklers at 9, 18, and 25. The sprinkler at 9 waters [3,9], [5,11], and [8,14]; the sprinkler at 18 waters [12,18]; the sprinkler at 25 waters [20,25].
```

**Example 2:**
```
Input: plots = [[1,5],[6,10],[11,15]]
Output: 3
Explanation: No two plots share any pipeline position, so every plot needs its own sprinkler.
```$$,
  constraints = $$- `1 <= plots.length <= 2 * 10^5`
- `plots[i].length == 2`
- `-10^8 <= start <= end <= 10^8`$$
WHERE slug = 'cover-watering-windows';

UPDATE test_cases SET input = E'[[5,11],[3,9],[8,14],[12,18],[20,25]]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cover-watering-windows')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[1,5],[6,10],[11,15]]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cover-watering-windows')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[[1,2],[2,3],[3,4],[4,5]]', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cover-watering-windows')
  AND is_sample = TRUE AND order_index = 3;

-- schedule-observing-window
UPDATE problems SET
  description = $$The observatory's logbook keeps a list of `windows`, each `[start, end]` giving the minutes of the night already reserved for a telescope target. The entries are sorted by `start` and never overlap. A new target has just been cleared, with its own visibility window `newWindow = [start, end]` that must be slotted into the book.

Insert `newWindow` into `windows` so the resulting schedule is still sorted by `start` and still non-overlapping. Merge any observing windows that touch or overlap `newWindow` into a single entry, and return the updated list.

**Example 1:**
```
Input: windows = [[1,4],[7,10]], newWindow = [3,6]
Output: [[1,6],[7,10]]
Explanation: newWindow overlaps [1,4], so they merge into [1,6]. [7,10] is untouched.
```

**Example 2:**
```
Input: windows = [[2,4],[6,8],[10,12],[14,18]], newWindow = [5,11]
Output: [[2,4],[5,12],[14,18]]
Explanation: newWindow swallows [6,8] and [10,12], merging with both to form [5,12].
```$$,
  constraints = $$- `0 <= windows.length <= 8000`
- `windows[i].length == 2`
- `0 <= start <= end <= 8 * 10^4`
- `windows` is sorted by `start` in ascending order and contains no overlaps.
- `newWindow.length == 2`$$
WHERE slug = 'schedule-observing-window';

UPDATE test_cases SET input = E'[[1,4],[7,10]]\n[3,6]', expected_output = '[[1,6],[7,10]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'schedule-observing-window')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[2,4],[6,8],[10,12],[14,18]]\n[5,11]', expected_output = '[[2,4],[5,12],[14,18]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'schedule-observing-window')
  AND is_sample = TRUE AND order_index = 2;

-- peak-gate-demand
UPDATE problems SET
  description = $$Airport operations needs to know the busiest moment at the terminal. You are given `flights`, where `flights[i] = [arrival, departure]` is the clock-minute a flight pulls into a gate and the clock-minute it pushes back. A gate can only host one flight at a time, and a flight occupies its gate for the whole half-open interval `[arrival, departure)` — a new flight may roll into the same gate at the exact minute the previous one departs.

Return the **minimum** number of gates the terminal must keep open so that every flight has a gate for its entire stay.

**Example 1:**
```
Input: flights = [[60,180],[90,150],[120,240],[200,300]]
Output: 3
Explanation: Between minute 120 and 150, the flights [60,180], [90,150], and [120,240] are all at a gate at once, so three gates are required.
```

**Example 2:**
```
Input: flights = [[500,600],[100,200]]
Output: 1
Explanation: The two flights never share a minute at a gate, so a single gate suffices.
```$$,
  constraints = $$- `1 <= flights.length <= 8000`
- `0 <= arrival < departure <= 2 * 10^5`$$
WHERE slug = 'peak-gate-demand';

UPDATE test_cases SET input = E'[[60,180],[90,150],[120,240],[200,300]]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'peak-gate-demand')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[500,600],[100,200]]', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'peak-gate-demand')
  AND is_sample = TRUE AND order_index = 2;

-- drop-class-conflicts
UPDATE problems SET
  description = $$A boutique gym has a single trainer who can only coach one class at a time. You're handed `classes`, a list of every requested class window `[start, end]` (minutes past opening). Two classes conflict when their windows overlap strictly — a class ending exactly when the next begins is fine.

Return the **minimum** number of classes that must be dropped from the request list so the remaining classes can all be coached without any conflict.

**Example 1:**
```
Input: classes = [[1,3],[2,4],[3,5],[1,5]]
Output: 2
Explanation: Keep [1,3] and [3,5]; drop [2,4] and [1,5] to eliminate every overlap.
```

**Example 2:**
```
Input: classes = [[5,6],[5,6]]
Output: 1
Explanation: The two requests cover the same window, so one must go.
```

**Example 3:**
```
Input: classes = [[1,2],[2,3]]
Output: 0
Explanation: No conflict — the classes abut but do not overlap.
```$$,
  constraints = $$- `1 <= classes.length <= 2 * 10^5`
- `classes[i].length == 2`
- `-8 * 10^4 <= start < end <= 8 * 10^4`$$
WHERE slug = 'drop-class-conflicts';

UPDATE test_cases SET input = E'[[1,3],[2,4],[3,5],[1,5]]', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'drop-class-conflicts')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[5,6],[5,6]]', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'drop-class-conflicts')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[[1,2],[2,3]]', expected_output = '0'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'drop-class-conflicts')
  AND is_sample = TRUE AND order_index = 3;

-- tightest-or-booking
UPDATE problems SET
  description = $$Hospital operations logs every booked operating-room block as `bookings[i] = [start, end]`, where both endpoints are **inclusive** minutes on a single shared timeline. The charge nurse then asks a batch of questions: for each minute in `probes`, which currently booked block covering that minute is the **shortest**? A booking's length is `end - start + 1`.

Return an array where the `i`-th entry is the length of the tightest booking that covers `probes[i]`, or `-1` if no booking covers that minute.

**Example 1:**
```
Input: bookings = [[2,5],[4,7],[1,9],[6,10]], probes = [3,6,9,11]
Output: [4,4,5,-1]
Explanation: Minute 3 sits inside [2,5] (length 4) and [1,9] (length 9); the tightest is 4. Minute 11 is outside every booking.
```

**Example 2:**
```
Input: bookings = [[10,12],[8,20]], probes = [9,11,25]
Output: [13,3,-1]
Explanation: Minute 9 is only inside [8,20] (length 13). Minute 11 is inside [10,12] (length 3) and [8,20] (length 13); the tightest is 3. Minute 25 is outside every booking.
```$$,
  constraints = $$- `1 <= bookings.length <= 2 * 10^5`
- `1 <= probes.length <= 2 * 10^5`
- `1 <= start <= end <= 10^8`
- `1 <= probes[i] <= 10^8`$$
WHERE slug = 'tightest-or-booking';

UPDATE test_cases SET input = E'[[2,5],[4,7],[1,9],[6,10]]\n[3,6,9,11]', expected_output = '[4,4,5,-1]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tightest-or-booking')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[10,12],[8,20]]\n[9,11,25]', expected_output = '[13,3,-1]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tightest-or-booking')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[[4,4]]\n[4,5]', expected_output = '[1,-1]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tightest-or-booking')
  AND is_sample = TRUE AND order_index = 3;

-- verify-table-bookings
UPDATE problems SET
  description = $$A restaurant's reservation ledger stores every booking for a single table as `bookings[i] = [start, end]`, in minutes past opening. The host needs a quick sanity check: can every booking be seated at that one table, back-to-back if necessary, without any two parties occupying it at the same time? A booking that ends exactly when another begins is allowed — the seats are cleared between them.

Return `true` if no two entries of `bookings` overlap in the open-interval sense, and `false` otherwise.

**Example 1:**
```
Input: bookings = [[18,20],[19,21],[22,23]]
Output: false
Explanation: [18,20] and [19,21] overlap at minute 19, so two parties would collide.
```

**Example 2:**
```
Input: bookings = [[18,20],[20,22],[22,23]]
Output: true
Explanation: Each booking ends exactly when the next starts, so the table turns cleanly.
```

**Example 3:**
```
Input: bookings = [[45,90],[30,60]]
Output: false
```$$,
  constraints = $$- `0 <= bookings.length <= 8000`
- `bookings[i].length == 2`
- `0 <= start < end <= 2 * 10^5`$$
WHERE slug = 'verify-table-bookings';

UPDATE test_cases SET input = E'[[18,20],[19,21],[22,23]]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'verify-table-bookings')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[18,20],[20,22],[22,23]]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'verify-table-bookings')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[[45,90],[30,60]]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'verify-table-bookings')
  AND is_sample = TRUE AND order_index = 3;

-- tally-pick-paths
UPDATE problems SET
  description = $$A warehouse bookkeeping system stores each outstanding order's unit count as a chain of shelves, one digit per shelf. The chain is wound up so that the **ones digit sits at the head** — the picker reads it first as they walk the aisle — and the more significant digits follow. Two such pick paths represent two non-negative integer quantities that must be combined into a single consolidated order.

Implement `tallyPickRoutes(route1, route2)` to return the combined total as a new linked list in the same reverse-digit layout. Neither input path has a leading zero (except the lone chain representing `0` itself).

**Example 1:**
```
Input: route1 = [3,1,7], route2 = [4,8]
Output: [7,9,7]
Explanation: The paths spell out 713 and 84. Their sum, 797, is laid back on the shelves ones-digit first.
```

**Example 2:**
```
Input: route1 = [9], route2 = [8]
Output: [7,1]
Explanation: 9 + 8 = 17, so the head shelf stores 7 and a carry shelf is appended for the tens digit.
```

**Example 3:**
```
Input: route1 = [1,8,6], route2 = [4,5]
Output: [5,3,7]
Explanation: 681 + 54 = 735.
```$$,
  constraints = $$- The number of shelves in each path is in the range `[1, 120]`.
- `0 <= Shelf.val <= 9`
- Neither path has a leading zero except the single-shelf path representing `0`.$$
WHERE slug = 'tally-pick-paths';

UPDATE test_cases SET input = E'[3,1,7]\n[4,8]', expected_output = '[7,9,7]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tally-pick-paths')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[9]\n[8]', expected_output = '[7,1]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tally-pick-paths')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[1,8,6]\n[4,5]', expected_output = '[5,3,7]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tally-pick-paths')
  AND is_sample = TRUE AND order_index = 3;

-- duplicate-topic-web
UPDATE problems SET
  description = $$A news aggregator keeps a **topic web**: each article sits in a node holding an integer topic id, a `next` pointer to the following article in the editorial order, and a `related` pointer that jumps to any other article in the same web (or is `null`). Archival requires a fully independent clone of the web so editors can experiment without disturbing the live feed.

Implement `duplicateTopicWeb(head)` to return the head of a **deep copy** of the web. The copy must contain exactly `n` brand-new nodes and every `next` and `related` pointer must reference nodes inside the copy only, never the original.

The stdin input is an array of pairs `[val, related_index]`, where `related_index` is the 0-based index of the article the `related` pointer targets, or `null` if it points at nothing.

**Example 1:**
```
Input: head = [[9,2],[4,null],[6,0],[2,1]]
Output: [[9,2],[4,null],[6,0],[2,1]]
Explanation: Four articles are cloned; each related pointer is rewired to the matching copy.
```

**Example 2:**
```
Input: head = [[5,0]]
Output: [[5,0]]
Explanation: The single node's related pointer loops back to itself in the clone.
```

**Example 3:**
```
Input: head = [[3,null],[7,null]]
Output: [[3,null],[7,null]]
```$$,
  constraints = $$- `0 <= n <= 1200`
- `-8 * 10^4 <= Node.val <= 8 * 10^4`
- `Node.related` is either `null` or a pointer to some node in the web.$$
WHERE slug = 'duplicate-topic-web';

UPDATE test_cases SET input = E'[[9,2],[4,null],[6,0],[2,1]]', expected_output = '[[9,2],[4,null],[6,0],[2,1]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'duplicate-topic-web')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[5,0]]', expected_output = '[[5,0]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'duplicate-topic-web')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[[3,null],[7,null]]', expected_output = '[[3,null],[7,null]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'duplicate-topic-web')
  AND is_sample = TRUE AND order_index = 3;

-- detect-transfer-loop
UPDATE problems SET
  description = $$A transit planner models a subway line as a chain of stations, where each station's `next` pointer names the following transfer on the route. After a recent reconfiguration, operations worries that the chain may double back on itself, making a passenger who keeps following transfer signs loop forever instead of reaching a terminus.

Implement `detectTransferLoop(head, pos)` to return `true` when following `next` pointers from `head` ever revisits a station, and `false` otherwise. The integer `pos` is the 0-based index of the station the tail connects into (`-1` means the tail is a true terminus); it exists only to build the test input and is **not** part of the function's logic.

**Example 1:**
```
Input: head = [8,5,2,6,9], pos = 2
Output: true
Explanation: The tail station's next pointer loops back into the station at index 2, so the chain cycles.
```

**Example 2:**
```
Input: head = [4,7,3], pos = 0
Output: true
Explanation: The last station routes back to the head, forming a full loop.
```

**Example 3:**
```
Input: head = [6,2], pos = -1
Output: false
Explanation: The chain ends cleanly; there is no cycle.
```$$,
  constraints = $$- The number of stations on the line is in the range `[0, 2 * 10^3]`.
- `-8 * 10^4 <= Station.val <= 8 * 10^4`
- `pos` is `-1` or a valid 0-based index into the chain.$$
WHERE slug = 'detect-transfer-loop';

UPDATE test_cases SET input = E'[8,5,2,6,9]\n2', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'detect-transfer-loop')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[4,7,3]\n0', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'detect-transfer-loop')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[6,2]\n-1', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'detect-transfer-loop')
  AND is_sample = TRUE AND order_index = 3;

-- merge-flight-rosters
UPDATE problems SET
  description = $$An airport's duty manager keeps a boarding priority roster for every inbound flight — each roster is a linked chain of passenger ids already sorted in non-decreasing order of boarding group. When several flights are being consolidated onto one ground crew, every individual roster must be spliced into a single master chain that is still sorted.

Implement `mergeFlightRosters(rosters)` to take a list of `k` sorted linked-list heads and return the head of one merged, sorted linked list. The merged list should be built by re-linking the existing nodes.

**Example 1:**
```
Input: rosters = [[2,5,8],[1,3,7],[4,6]]
Output: [1,2,3,4,5,6,7,8]
Explanation: Three pre-sorted rosters are woven together into a single chain.
```

**Example 2:**
```
Input: rosters = []
Output: []
Explanation: With no rosters there is nothing to board.
```

**Example 3:**
```
Input: rosters = [[]]
Output: []
Explanation: A single empty roster merges to an empty chain.
```$$,
  constraints = $$- `k == rosters.length`
- `0 <= k <= 2 * 10^3`
- `0 <= rosters[i].length <= 500`
- `-8 * 10^4 <= rosters[i][j] <= 8 * 10^4`
- Each `rosters[i]` is sorted in ascending order.
- The total number of passenger nodes across all rosters does not exceed `2 * 10^3`.$$
WHERE slug = 'merge-flight-rosters';

UPDATE test_cases SET input = E'[[2,5,8],[1,3,7],[4,6]]', expected_output = '[1,2,3,4,5,6,7,8]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-flight-rosters')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[]', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-flight-rosters')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[[]]', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-flight-rosters')
  AND is_sample = TRUE AND order_index = 3;

-- combine-oven-rotations
UPDATE problems SET
  description = $$Two bakers each run an oven with its own rotation of trays, and each rotation is a linked chain of tray ids ordered by proof time (non-decreasing). Before the morning bake the head baker wants the two rotations woven together into a single master chain — still ordered by proof time — so the floor crew only has to track one queue.

Implement `combineOvenRotations(ovenA, ovenB)` to splice the existing tray nodes from both chains into one sorted chain and return its head.

**Example 1:**
```
Input: ovenA = [2,5,9], ovenB = [3,4,7]
Output: [2,3,4,5,7,9]
Explanation: The trays are interleaved by proof time into one rotation.
```

**Example 2:**
```
Input: ovenA = [], ovenB = []
Output: []
Explanation: Both ovens are idle.
```

**Example 3:**
```
Input: ovenA = [], ovenB = [3]
Output: [3]
Explanation: Only the second oven has a tray to bake.
```$$,
  constraints = $$- The number of trays in each rotation is in the range `[0, 60]`.
- `-100 <= Tray.val <= 100`
- Both `ovenA` and `ovenB` are sorted in non-decreasing order.$$
WHERE slug = 'combine-oven-rotations';

UPDATE test_cases SET input = E'[2,5,9]\n[3,4,7]', expected_output = '[2,3,4,5,7,9]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'combine-oven-rotations')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[]\n[]', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'combine-oven-rotations')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[]\n[3]', expected_output = '[3]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'combine-oven-rotations')
  AND is_sample = TRUE AND order_index = 3;

-- drop-tail-booking
UPDATE problems SET
  description = $$A gym's reservation system holds the day's machine bookings as a linked chain in the order they were placed. A member is allowed to cancel the `n`-th booking counted **from the end** of the chain — so `n = 1` removes the very last reservation, `n = 2` removes the one before it, and so on.

Implement `dropTailBooking(head, n)` to remove that single booking node from the chain and return the updated head.

**Example 1:**
```
Input: head = [10,20,30,40,50,60], n = 3
Output: [10,20,30,50,60]
Explanation: Counting from the end, booking 40 is 3rd; after removing it the chain is 10 -> 20 -> 30 -> 50 -> 60.
```

**Example 2:**
```
Input: head = [7], n = 1
Output: []
Explanation: The only booking is cancelled, leaving the schedule empty.
```

**Example 3:**
```
Input: head = [4,9], n = 2
Output: [9]
Explanation: The 2nd from the end is the very first booking, so it is dropped.
```$$,
  constraints = $$- The number of bookings in the chain is `sz`.
- `1 <= sz <= 40`
- `0 <= Booking.val <= 100`
- `1 <= n <= sz`$$
WHERE slug = 'drop-tail-booking';

UPDATE test_cases SET input = E'[10,20,30,40,50,60]\n3', expected_output = '[10,20,30,50,60]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'drop-tail-booking')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[7]\n1', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'drop-tail-booking')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[4,9]\n2', expected_output = '[9]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'drop-tail-booking')
  AND is_sample = TRUE AND order_index = 3;

-- interleave-trailer-cuts
UPDATE problems SET
  description = $$A trailer editor has laid out the shot list for an upcoming teaser as a linked chain `S0 -> S1 -> ... -> Sn-1 -> Sn`, opening scenes at the head and closing scenes at the tail. The director wants the final cut to **alternate** between front-of-film and end-of-film shots so each glimpse of the finale is framed by an early-film setup. That means the chain must be rearranged in place into:

`S0 -> Sn -> S1 -> Sn-1 -> S2 -> Sn-2 -> ...`

Implement `interleaveTrailerCuts(head)` to rewire the node links so the chain takes on this zig-zag order. You must not modify the values stored in any node — only the `next` pointers may change.

**Example 1:**
```
Input: head = [10,20,30,40,50,60]
Output: [10,60,20,50,30,40]
Explanation: Front and back shots are woven together: opening 10, closing 60, second 20, second-to-last 50, and so on.
```

**Example 2:**
```
Input: head = [1,3,5,7,9,11,13]
Output: [1,13,3,11,5,9,7]
Explanation: With an odd length the middle shot ends the cut alone.
```$$,
  constraints = $$- The number of shots in the chain is in the range `[1, 8 * 10^4]`.
- `1 <= Shot.val <= 1000`$$
WHERE slug = 'interleave-trailer-cuts';

UPDATE test_cases SET input = E'[10,20,30,40,50,60]', expected_output = '[10,60,20,50,30,40]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'interleave-trailer-cuts')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[1,3,5,7,9,11,13]', expected_output = '[1,13,3,11,5,9,7]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'interleave-trailer-cuts')
  AND is_sample = TRUE AND order_index = 2;

-- flip-sorter-segments
UPDATE problems SET
  description = $$A recycling plant sends material batches through a sort floor as a linked chain of station codes. To balance load across the sorters, the shift lead wants to take consecutive runs of length `k` and **flip each run end-for-end** in place. Any trailing stub shorter than `k` is left untouched.

Implement `flipSorterSegments(head, k)` to reverse the node links `k` at a time and return the head of the reworked chain. The values inside the nodes must not be mutated — only the `next` pointers may be rewired.

**Example 1:**
```
Input: head = [10,20,30,40,50,60,70], k = 3
Output: [30,20,10,60,50,40,70]
Explanation: The first run (10,20,30) flips to (30,20,10); the next run (40,50,60) flips to (60,50,40); the trailing 70 stands alone.
```

**Example 2:**
```
Input: head = [5,15,25,35], k = 4
Output: [35,25,15,5]
Explanation: Exactly one run of length 4 is reversed in full.
```

**Example 3:**
```
Input: head = [2,4,6,8,10], k = 1
Output: [2,4,6,8,10]
Explanation: With k = 1 each run is a single station, so the chain is unchanged.
```$$,
  constraints = $$- The number of stations in the chain is `n`.
- `1 <= k <= n <= 6000`
- `0 <= Station.val <= 1000`$$
WHERE slug = 'flip-sorter-segments';

UPDATE test_cases SET input = E'[10,20,30,40,50,60,70]\n3', expected_output = '[30,20,10,60,50,40,70]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flip-sorter-segments')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[5,15,25,35]\n4', expected_output = '[35,25,15,5]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flip-sorter-segments')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[2,4,6,8,10]\n1', expected_output = '[2,4,6,8,10]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flip-sorter-segments')
  AND is_sample = TRUE AND order_index = 3;

-- rewind-conveyor-chain
UPDATE problems SET
  description = $$A manufacturing line is modelled as a linked chain of station ids in the direction parts currently flow. Night-shift engineers need to run the line in reverse to drain buffers before maintenance — that means flipping the whole chain so the former tail becomes the new head while reusing the same station nodes.

Implement `rewindConveyorChain(head)` to reverse the chain in place by rewiring the `next` pointers and return the head of the reversed chain.

**Example 1:**
```
Input: head = [8,3,12,5,9]
Output: [9,5,12,3,8]
Explanation: The line flips so station 9 is now first and station 8 is last.
```

**Example 2:**
```
Input: head = [4,7]
Output: [7,4]
Explanation: A two-station chain swaps direction.
```

**Example 3:**
```
Input: head = []
Output: []
Explanation: An empty line has nothing to rewind.
```$$,
  constraints = $$- The number of stations in the chain is in the range `[0, 6000]`.
- `-6000 <= Station.val <= 6000`$$
WHERE slug = 'rewind-conveyor-chain';

UPDATE test_cases SET input = E'[8,3,12,5,9]', expected_output = '[9,5,12,3,8]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rewind-conveyor-chain')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[4,7]', expected_output = '[7,4]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rewind-conveyor-chain')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[]', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rewind-conveyor-chain')
  AND is_sample = TRUE AND order_index = 3;

-- swap-queue-partners
UPDATE problems SET
  description = $$A print shop's single-printer queue is tracked as a linked chain of job ids in submission order. The shop owner runs a weekly "fairness swap": every two adjacent jobs in the queue trade places so the second of each pair goes first. If the queue has an odd length, the lone trailing job stays where it is.

Implement `swapQueuePartners(head)` to rewire the `next` pointers so every adjacent pair is swapped, returning the new head. The job ids stored in the nodes must not be mutated — only the links may change.

**Example 1:**
```
Input: head = [11,22,33,44]
Output: [22,11,44,33]
Explanation: Pairs (11,22) and (33,44) trade places.
```

**Example 2:**
```
Input: head = [8,3]
Output: [3,8]
Explanation: The single pair is swapped.
```

**Example 3:**
```
Input: head = [6,9,15]
Output: [9,6,15]
Explanation: The first pair swaps; job 15 has no partner and keeps its spot.
```$$,
  constraints = $$- `0 <= Number of jobs <= 120`
- `0 <= Job.val <= 100`$$
WHERE slug = 'swap-queue-partners';

UPDATE test_cases SET input = E'[11,22,33,44]', expected_output = '[22,11,44,33]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'swap-queue-partners')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[8,3]', expected_output = '[3,8]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'swap-queue-partners')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[6,9,15]', expected_output = '[9,6,15]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'swap-queue-partners')
  AND is_sample = TRUE AND order_index = 3;

-- label-lane-scans
UPDATE problems SET
  description = $$A supermarket wants to print labels for the first `n` lane scans of the day so cashiers can recite the cadence during training. Given a positive integer `n`, return a list of labels for each scan index from `1` to `n` using the following rules:

- If the index is divisible by both 3 and 5, the label is `"FizzBuzz"`.
- If the index is divisible by 3 only, the label is `"Fizz"`.
- If the index is divisible by 5 only, the label is `"Buzz"`.
- Otherwise, the label is the index written as a decimal string.

Return the resulting list of labels in order.

**Example 1:**
```
Input: n = 4
Output: ["1","2","Fizz","4"]
```

**Example 2:**
```
Input: n = 6
Output: ["1","2","Fizz","4","Buzz","Fizz"]
```$$,
  constraints = $$- `1 <= n <= 15000`$$
WHERE slug = 'label-lane-scans';

UPDATE test_cases SET input = E'4', expected_output = '["1","2","Fizz","4"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'label-lane-scans')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'6', expected_output = '["1","2","Fizz","4","Buzz","Fizz"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'label-lane-scans')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'15', expected_output = '["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'label-lane-scans')
  AND is_sample = TRUE AND order_index = 3;

-- bump-parcel-code
UPDATE problems SET
  description = $$A postal sorter stamps a rolling sequence number on each parcel, stored as an array of its decimal digits with `digits[0]` as the most significant digit. When the next parcel arrives, the sorter needs to bump the code by one and emit the new digit array, propagating any carry correctly (so a code like `9,9` rolls over to `1,0,0`).

The input never carries a leading zero except when the entire code is zero, in which case it is represented as `[0]`. Return the bumped code as an array of digits.

**Example 1:**
```
Input: digits = [4,5,6]
Output: [4,5,7]
Explanation: 456 + 1 = 457.
```

**Example 2:**
```
Input: digits = [2,9,9]
Output: [3,0,0]
Explanation: 299 + 1 = 300, which keeps the same length but rewrites the trailing digits.
```$$,
  constraints = $$- `1 <= digits.length <= 100`
- `0 <= digits[i] <= 9`
- The input array has no leading zeros except for the code `0` itself$$
WHERE slug = 'bump-parcel-code';

UPDATE test_cases SET input = E'[4,5,6]', expected_output = '[4,5,7]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bump-parcel-code')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[2,9,9]', expected_output = '[3,0,0]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bump-parcel-code')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[0]', expected_output = '[1]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bump-parcel-code')
  AND is_sample = TRUE AND order_index = 3;

-- calm-sensor-reading
UPDATE problems SET
  description = $$A smart-home hub classifies sensor reading IDs as **calm** or not before routing them to the alert channel. Given a positive integer `reading`, repeatedly replace it with the sum of the squares of its decimal digits; the reading is calm if this process eventually lands on `1`, and not calm if it falls into an endless cycle that never reaches `1`.

Return `true` if `reading` is calm and `false` otherwise.

**Example 1:**
```
Input: reading = 7
Output: true
Explanation: 7 -> 49 -> 97 -> 130 -> 10 -> 1.
```

**Example 2:**
```
Input: reading = 4
Output: false
Explanation: 4 -> 16 -> 37 -> 58 -> 89 -> 145 -> 42 -> 20 -> 4, a cycle that never hits 1.
```$$,
  constraints = $$- `1 <= reading <= 2 * 10^8`$$
WHERE slug = 'calm-sensor-reading';

UPDATE test_cases SET input = E'7', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'calm-sensor-reading')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'4', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'calm-sensor-reading')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'1', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'calm-sensor-reading')
  AND is_sample = TRUE AND order_index = 3;

-- reversible-call-number
UPDATE problems SET
  description = $$A branch librarian tags a call number as **reversible** when its decimal digits read identically left-to-right and right-to-left, which makes it easier to spot on a stacked shelf. Given an integer `code`, return `true` when `code` reads the same forwards and backwards and `false` otherwise.

Any negative `code` is automatically not reversible, because the leading minus sign has no counterpart on the right side of the digits.

**Example 1:**
```
Input: code = 929
Output: true
Explanation: 929 reversed is still 929.
```

**Example 2:**
```
Input: code = 20
Output: false
Explanation: 20 reversed reads 02, which does not match 20.
```$$,
  constraints = $$- `-2 * 10^8 <= code <= 2 * 10^8`$$
WHERE slug = 'reversible-call-number';

UPDATE test_cases SET input = E'929', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reversible-call-number')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'20', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reversible-call-number')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'10', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reversible-call-number')
  AND is_sample = TRUE AND order_index = 3;

-- decode-zone-numeral
UPDATE problems SET
  description = $$A theme park encodes attraction zone numerals in Roman notation on its wristband passes, and the turnstile software needs to convert a wristband's numeral string back to its integer zone ID. The symbols follow the usual mapping:

- `I` = 1, `V` = 5, `X` = 10, `L` = 50, `C` = 100, `D` = 500, `M` = 1000

Symbols are generally placed largest-to-smallest from left to right. When a smaller symbol appears directly before a strictly larger one, the pair encodes subtraction (so `IV` = 4 and `IX` = 9). The six valid subtractive pairs are `IV`, `IX`, `XL`, `XC`, `CD`, `CM`.

Given a numeral string `numeral`, return its integer value.

**Example 1:**
```
Input: numeral = "XIV"
Output: 14
Explanation: X + IV = 10 + 4 = 14.
```

**Example 2:**
```
Input: numeral = "CDXLII"
Output: 442
Explanation: CD + XL + II = 400 + 40 + 2 = 442.
```$$,
  constraints = $$- `1 <= numeral.length <= 15`
- `numeral` contains only the characters `I`, `V`, `X`, `L`, `C`, `D`, `M`
- `numeral` is guaranteed to be a valid Roman numeral in the range `[1, 3999]`$$
WHERE slug = 'decode-zone-numeral';

UPDATE test_cases SET input = E'XIV', expected_output = '14'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'decode-zone-numeral')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'CDXLII', expected_output = '442'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'decode-zone-numeral')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'MCMXCIV', expected_output = '1994'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'decode-zone-numeral')
  AND is_sample = TRUE AND order_index = 3;

-- forecast-step-factor
UPDATE problems SET
  description = $$A weather station models the temperature drift between hourly snapshots as a single scalar `base`, and raising it to an integer power `step` gives the projected drift factor after `step` hours. Given a floating-point base `base` and an integer `step`, compute `base` raised to the `step`-th power.

When `step` is negative, the factor becomes `1 / base^|step|` (for instance, `2.0^-3 = 0.125`). Because `step` can be large in magnitude, a plain loop of `|step|` multiplications will time out on the hidden tests.

Return the result rounded to 5 decimal places.

**Example 1:**
```
Input: base = 3.00000, step = 4
Output: 81.00000
```

**Example 2:**
```
Input: base = 2.00000, step = -3
Output: 0.12500
Explanation: 2.0^-3 = 1 / (2.0^3) = 1/8 = 0.125.
```$$,
  constraints = $$- `-100.0 < base < 100.0`
- `-2 * 10^8 <= step <= 2 * 10^8`
- `step` is an integer
- Either `base` is not zero or `step > 0`
- `|base^step| <= 8 * 10^4`$$
WHERE slug = 'forecast-step-factor';

UPDATE test_cases SET input = E'3.00000\n4', expected_output = '81.00000'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'forecast-step-factor')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'2.00000\n-3', expected_output = '0.12500'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'forecast-step-factor')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'2.00000\n-2', expected_output = '0.25000'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'forecast-step-factor')
  AND is_sample = TRUE AND order_index = 3;

-- outward-shelf-walk
UPDATE problems SET
  description = $$A warehouse picker starts at the top-left shelf of a rectangular bay and walks the aisles in an outward spiral: across the top row, down the rightmost column, back along the bottom row, up the leftmost column, then inward and repeat. Given an `m x n` grid `bay` where each cell holds the SKU count on that shelf, return the SKU counts in the order the picker visits them.

The picker visits each shelf exactly once.

**Example 1:**
```
Input: bay = [[1,2],[3,4]]
Output: [1,2,4,3]
```

**Example 2:**
```
Input: bay = [[5,6,7],[8,9,10],[11,12,13],[14,15,16]]
Output: [5,6,7,10,13,16,15,14,11,8,9,12]
```$$,
  constraints = $$- `m == bay.length`
- `n == bay[i].length`
- `1 <= m, n <= 10`
- `-100 <= bay[i][j] <= 100`$$
WHERE slug = 'outward-shelf-walk';

UPDATE test_cases SET input = E'[[1,2],[3,4]]', expected_output = '[1,2,4,3]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'outward-shelf-walk')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[5,6,7],[8,9,10],[11,12,13],[14,15,16]]', expected_output = '[5,6,7,10,13,16,15,14,11,8,9,12]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'outward-shelf-walk')
  AND is_sample = TRUE AND order_index = 2;

-- product-as-text
UPDATE problems SET
  description = $$A film production budget tool stores two non-negative line-item amounts as decimal digit strings, `left` and `right`, because the numbers can run longer than a native integer type. The tool needs to multiply them together and emit the product as a decimal string.

You may not cast either operand to a numeric type, use a big-integer library, or rely on any built-in multiplication helper for arbitrary-length numbers. Instead, simulate the long multiplication you would do by hand, digit by digit.

**Example 1:**
```
Input: left = "12", right = "34"
Output: "408"
```

**Example 2:**
```
Input: left = "25", right = "13"
Output: "325"
```$$,
  constraints = $$- `1 <= left.length, right.length <= 200`
- `left` and `right` consist of decimal digits only
- Neither `left` nor `right` has leading zeros, except the value `0` itself$$
WHERE slug = 'product-as-text';

UPDATE test_cases SET input = E'12\n34', expected_output = '408'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'product-as-text')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'25\n13', expected_output = '325'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'product-as-text')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'99\n0', expected_output = '0'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'product-as-text')
  AND is_sample = TRUE AND order_index = 3;

-- clear-defect-rows
UPDATE problems SET
  description = $$A manufacturing QA dashboard tracks defect counts in an `m x n` integer grid `board`, where each cell is the count flagged at one inspection station. When any cell reads exactly `0`, the line operator wants the corresponding **row and column** to be marked clear (set to `0`) so the downstream view hides noise around those stations.

Rewrite `board` **in-place** so that every cell sharing a row or column with an original zero becomes `0`. Cells that were not in such a row or column keep their original value.

**Example 1:**
```
Input: board = [[2,3],[4,5]]
Output: [[2,3],[4,5]]
Explanation: No zero cells exist, so the board is unchanged.
```

**Example 2:**
```
Input: board = [[4,6,8],[2,0,5],[7,9,3]]
Output: [[4,0,8],[0,0,0],[7,0,3]]
Explanation: The zero sits at row 1, column 1, so row 1 and column 1 are cleared.
```$$,
  constraints = $$- `m == board.length`
- `n == board[0].length`
- `1 <= m, n <= 200`
- `|board[i][j]| <= 10^8`$$
WHERE slug = 'clear-defect-rows';

UPDATE test_cases SET input = E'[[2,3],[4,5]]', expected_output = '[[2,3],[4,5]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'clear-defect-rows')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[[4,6,8],[2,0,5],[7,9,3]]', expected_output = '[[4,0,8],[0,0,0],[7,0,3]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'clear-defect-rows')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[[1,2],[3,4]]', expected_output = '[[1,2],[3,4]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'clear-defect-rows')
  AND is_sample = TRUE AND order_index = 3;

-- longest-clean-run
UPDATE problems SET
  description = $$A single-stream recycling conveyor carries mixed items past an optical sorter. You are given an array `stream` where `stream[i]` is the material code of the `i`-th piece that rolls by. The downstream baler can only handle a run that mixes **at most two distinct material codes** before it has to be flushed and reset.

Implement `longestCleanRun` to return the length of the longest contiguous stretch of `stream` whose pieces use no more than two distinct material codes.

**Example 1:**
```
Input: stream = [4,4,7,4,7,2,7,2,2]
Output: 5
Explanation: The stretch [7,2,7,2,2] at the end uses only codes 7 and 2 and has length 5. The opening stretch [4,4,7,4,7] also has length 5 using codes 4 and 7.
```

**Example 2:**
```
Input: stream = [9,9,9]
Output: 3
Explanation: Every piece shares the same material code, so the entire conveyor is one clean run.
```

**Example 3:**
```
Input: stream = [1,5,1,5,1,5]
Output: 6
Explanation: The whole conveyor alternates between only two codes, so the longest clean run spans everything.
```$$,
  constraints = $$- `1 <= stream.length <= 2 * 10^5`
- `0 <= stream[i] < stream.length`$$
WHERE slug = 'longest-clean-run';

UPDATE test_cases SET input = E'[4,4,7,4,7,2,7,2,2]', expected_output = '5'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-clean-run')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[9,9,9]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-clean-run')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[1,5,1,5,1,5]', expected_output = '6'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-clean-run')
  AND is_sample = TRUE AND order_index = 3;

-- shortest-bake-span
UPDATE problems SET
  description = $$A bakery's deck oven runs as a single linear queue of trays. The array `trays` lists, in oven order, how many loaves each tray is scheduled to yield, and `target` is the minimum number of loaves the morning delivery needs. The bakers want to pick a **contiguous span of trays** whose combined yield meets or exceeds `target`, and they want that span to be as short as possible so the oven frees up quickly.

Implement `shortestBakeSpan` to return the length of the shortest contiguous span of `trays` whose sum is at least `target`. If no span can meet the order, return `0`.

**Example 1:**
```
Input: trays = [3,1,4,1,5,9,2,6], target = 15
Output: 3
Explanation: The span [1,5,9] already sums to 15, and no shorter span reaches the target.
```

**Example 2:**
```
Input: trays = [2,2,2], target = 10
Output: 0
Explanation: The full oven only yields 6 loaves, well short of the order.
```

**Example 3:**
```
Input: trays = [8,3,2], target = 8
Output: 1
Explanation: The very first tray already meets the target on its own.
```$$,
  constraints = $$- `1 <= trays.length <= 2 * 10^5`
- `1 <= trays[i] <= 8000`
- `1 <= target <= 10^8`$$
WHERE slug = 'shortest-bake-span';

UPDATE test_cases SET input = E'[3,1,4,1,5,9,2,6]\n15', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shortest-bake-span')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[2,2,2]\n10', expected_output = '0'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shortest-bake-span')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[8,3,2]\n8', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shortest-bake-span')
  AND is_sample = TRUE AND order_index = 3;

-- shortest-shelf-span
UPDATE problems SET
  description = $$A reference librarian is staring at a long row of call-number labels and needs to grab a contiguous block of shelves that together contain every required letter-tag for an exhibit. You are given a shelf string `shelf` (one character per volume, in shelving order) and a requirements string `needed` listing letter-tags the exhibit demands, **with multiplicity** — if `needed` lists two `'O'` tags, the span must include at least two volumes tagged `'O'`.

Implement `shortestShelfSpan` to return the shortest contiguous substring of `shelf` that covers every letter-tag in `needed` (counting duplicates). If no such span exists, return the empty string `""`. If several spans tie on length, return the one that starts earliest.

**Example 1:**
```
Input: shelf = "FINDTHEBOOKSNOW", needed = "BOK"
Output: "BOOK"
Explanation: The span "BOOK" contains a 'B', an 'O', and a 'K', and no shorter span covers all three tags.
```

**Example 2:**
```
Input: shelf = "XY", needed = "Y"
Output: "Y"
Explanation: The single volume tagged 'Y' already covers the requirement.
```

**Example 3:**
```
Input: shelf = "Q", needed = "QQ"
Output: ""
Explanation: The requirement asks for two 'Q'-tagged volumes, but the shelf only holds one.
```$$,
  constraints = $$- `m == shelf.length`
- `n == needed.length`
- `1 <= m, n <= 2 * 10^5`
- `shelf` and `needed` consist of uppercase and lowercase English letters.$$
WHERE slug = 'shortest-shelf-span';

UPDATE test_cases SET input = E'FINDTHEBOOKSNOW\nBOK', expected_output = 'BOOK'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shortest-shelf-span')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'XY\nY', expected_output = 'Y'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shortest-shelf-span')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'Q\nQQ', expected_output = ''
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shortest-shelf-span')
  AND is_sample = TRUE AND order_index = 3;

-- peak-temp-swing
UPDATE problems SET
  description = $$A weather station logged hourly outdoor temperatures during a storm and an analyst wants to know the biggest upward swing — the largest `readings[j] - readings[i]` where `i < j`. This captures how far the temperature climbed from a prior low to a later high across the storm window.

Implement `maxTempSwing` to return the largest such positive swing in the array `readings`. If the temperature never rises from any earlier point to a later one, return `0`.

**Example 1:**
```
Input: readings = [14,9,11,8,12,15,10]
Output: 7
Explanation: The low at index 3 (reading 8) is followed by a high at index 5 (reading 15), a swing of 7.
```

**Example 2:**
```
Input: readings = [20,18,15,11]
Output: 0
Explanation: Temperatures only fall through the log, so no upward swing exists.
```$$,
  constraints = $$- `1 <= readings.length <= 2 * 10^5`
- `0 <= readings[i] <= 8000`$$
WHERE slug = 'peak-temp-swing';

UPDATE test_cases SET input = E'[14,9,11,8,12,15,10]', expected_output = '7'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'peak-temp-swing')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[20,18,15,11]', expected_output = '0'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'peak-temp-swing')
  AND is_sample = TRUE AND order_index = 2;

-- zone-code-anagram
UPDATE problems SET
  description = $$A postal sorter is watching a stream of scanned zone codes and needs to know whether a hunt-list `pattern` shows up anywhere in the longer scan log `log` as a **contiguous reordering**. Concretely, you want to know whether any permutation of the characters in `pattern` appears as a contiguous substring of `log`.

Implement `matchesZoneAnagram` to return `true` if such a substring exists and `false` otherwise.

**Example 1:**
```
Input: pattern = "ab", log = "ccbazz"
Output: true
Explanation: The substring "ba" inside log is a reordering of pattern.
```

**Example 2:**
```
Input: pattern = "rp", log = "mailpirzone"
Output: false
Explanation: No length-two substring of log uses one 'r' and one 'p'.
```$$,
  constraints = $$- `1 <= pattern.length, log.length <= 8000`
- `pattern` and `log` consist of lowercase English letters.$$
WHERE slug = 'zone-code-anagram';

UPDATE test_cases SET input = E'ab\nccbazz', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'zone-code-anagram')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'rp\nmailpirzone', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'zone-code-anagram')
  AND is_sample = TRUE AND order_index = 2;

-- longest-fresh-feed
UPDATE problems SET
  description = $$A news aggregator tags each incoming headline with a single-character topic code, producing a long string `feed`. An editor wants the longest contiguous run of headlines in which **no topic repeats** — the longer that run, the fresher the stretch of coverage.

Implement `longestFreshFeed` to return the length of the longest contiguous substring of `feed` whose characters are all distinct.

**Example 1:**
```
Input: feed = "finance"
Output: 4
Explanation: The substring "ance" uses four distinct topic codes; no longer distinct run exists.
```

**Example 2:**
```
Input: feed = "zzzz"
Output: 1
Explanation: Every headline carries the same topic, so only length-one runs are distinct.
```

**Example 3:**
```
Input: feed = "xxxyz"
Output: 3
Explanation: The tail "xyz" uses three distinct topic codes.
```$$,
  constraints = $$- `0 <= feed.length <= 8 * 10^4`
- `feed` consists of English letters, digits, symbols and spaces.$$
WHERE slug = 'longest-fresh-feed';

UPDATE test_cases SET input = E'finance', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-fresh-feed')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'zzzz', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-fresh-feed')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'xxxyz', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-fresh-feed')
  AND is_sample = TRUE AND order_index = 3;

-- peak-flow-stretch
UPDATE problems SET
  description = $$A traffic engineer is analysing a linear corridor. The array `flow` records the vehicles-per-minute measured at consecutive intersections, and `k` is the width of the sliding review window used by the morning report. For every position of a `k`-intersection window sliding from the start of the corridor to the end, the engineer wants the peak flow seen inside that window.

Implement `peakFlowPerStretch` to return an integer array whose `i`-th entry is the maximum of `flow[i..i+k-1]`.

**Example 1:**
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

**Example 2:**
```
Input: flow = [6,6,6], k = 2
Output: [6,6]
Explanation: Every window of two intersections reports the same peak flow.
```$$,
  constraints = $$- `1 <= flow.length <= 2 * 10^5`
- `-8000 <= flow[i] <= 8000`
- `1 <= k <= flow.length`$$
WHERE slug = 'peak-flow-stretch';

UPDATE test_cases SET input = E'[4,2,8,5,1,7,9,3]\n4', expected_output = '[8,8,8,9,9]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'peak-flow-stretch')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[6,6,6]\n2', expected_output = '[6,6]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'peak-flow-stretch')
  AND is_sample = TRUE AND order_index = 2;

-- verify-job-nesting
UPDATE problems SET
  description = $$A print shop tracks nested print-job groups with opening and closing markers: `(`, `)`, `[`, `]`, `{`, and `}`. A group only validates if every opener is closed by the matching type and the groups are properly nested — an outer group cannot close before its inner groups finish.

Given a single string `jobTape` containing only those six marker characters, return `true` if the tape describes a valid nesting of print-job groups, and `false` otherwise. An empty tape is not a valid input per the constraints.

**Example 1:**
```
Input: jobTape = "{[()]}"
Output: true
Explanation: Each opener is closed by the matching type in the correct nested order.
```

**Example 2:**
```
Input: jobTape = "{[(])}"
Output: false
Explanation: The `(` is closed by `]` before its matching `)`, breaking the nesting.
```$$,
  constraints = $$- `1 <= jobTape.length <= 2 * 10^3`
- `jobTape` consists only of the characters `'('`, `')'`, `'['`, `']'`, `'{'`, and `'}'`.$$
WHERE slug = 'verify-job-nesting';

UPDATE test_cases SET input = E'{[()]}', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'verify-job-nesting')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'{[(])}', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'verify-job-nesting')
  AND is_sample = TRUE AND order_index = 2;

-- group-train-packs
UPDATE problems SET
  description = $$A single-track subway line runs toward a terminal at kilometer marker `terminal`. There are `n` trains currently on the line; `launchKm[i]` is the starting kilometer of the `i`-th train and `cruiseSpeed[i]` is its cruising speed in km/h. A faster train behind a slower one cannot overtake — when it catches up, it must dwell behind and inherit the slower speed. A **pack** is one or more trains moving together because the lead train caps the rest.

Given `terminal`, `launchKm`, and `cruiseSpeed`, return the number of packs that reach the terminal.

**Example 1:**
```
Input: terminal = 20, launchKm = [0,3,7,14], cruiseSpeed = [5,3,2,1]
Output: 2
Explanation: The train at km 14 reaches the terminal alone (6h). The trains at km 7, 3, and 0 each catch up with the km-7 train before it reaches the terminal, forming a second pack.
```

**Example 2:**
```
Input: terminal = 15, launchKm = [5], cruiseSpeed = [2]
Output: 1
```$$,
  constraints = $$- `n == launchKm.length == cruiseSpeed.length`
- `1 <= n <= 2 * 10^5`
- `0 <= launchKm[i] < terminal <= 10^8`
- `1 <= cruiseSpeed[i] <= 2 * 10^5`
- All values in `launchKm` are distinct.$$
WHERE slug = 'group-train-packs';

UPDATE test_cases SET input = E'20\n[0,3,7,14]\n[5,3,2,1]', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'group-train-packs')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'15\n[5]\n[2]', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'group-train-packs')
  AND is_sample = TRUE AND order_index = 2;

-- list-slate-sequences
UPDATE problems SET
  description = $$A film crew marks each take with a matched `slate`/`cut` pair, written as `(` and `)`. For a rehearsal log of `pairCount` pairs, the assistant director must enumerate every layout of slates and cuts that is properly nested — every `(` eventually closes with a `)`, and no `)` appears before its matching `(`.

Given the integer `pairCount`, return all such well-formed sequences. The order of the returned list does not matter — the grader sorts results lexicographically before comparing.

**Example 1:**
```
Input: pairCount = 2
Output: ["(())","()()"]
Explanation: The two valid slate/cut layouts using two pairs.
```

**Example 2:**
```
Input: pairCount = 4
Output: ["(((())))","((()()))","((())())","((()))()","(()(()))","(()()())","(()())()","(())(())","(())()()","()((()))","()(()())","()(())()","()()(())","()()()()"]
```$$,
  constraints = $$- `1 <= pairCount <= 9`$$
WHERE slug = 'list-slate-sequences';

UPDATE test_cases SET input = E'2', expected_output = '["(())","()()"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'list-slate-sequences')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'4', expected_output = '["(((())))","((()()))","((())())","((()))()","(()(()))","(()()())","(()())()","(())(())","(())()()","()((()))","()(()())","()(())()","()()(())","()()()()"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'list-slate-sequences')
  AND is_sample = TRUE AND order_index = 2;

-- fold-bale-ops
UPDATE problems SET
  description = $$A recycling plant composes bale weights using postfix merge operations. The control tape is an array `baleTape` of tokens where each token is either a signed integer (a bale weight in kg) or one of the operators `+`, `-`, `*`, `/`. Each operator pops the top two weights off the working stack, combines them, and pushes the result back.

Division truncates toward zero. The tape is guaranteed to be a valid postfix program whose final evaluation leaves exactly one number on the stack, with no division by zero. Return that final integer.

**Example 1:**
```
Input: baleTape = ["5","3","-","2","*"]
Output: 4
Explanation: (5 - 3) * 2 = 4.
```

**Example 2:**
```
Input: baleTape = ["8","2","/","7","+","3","*"]
Output: 33
Explanation: ((8 / 2) + 7) * 3 = 33.
```$$,
  constraints = $$- `1 <= baleTape.length <= 2 * 10^3`
- `baleTape[i]` is either an operator in `{"+", "-", "*", "/"}` or a signed integer with `|baleTape[i]| <= 250`.$$
WHERE slug = 'fold-bale-ops';

UPDATE test_cases SET input = E'["5","3","-","2","*"]', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fold-bale-ops')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'["8","2","/","7","+","3","*"]', expected_output = '33'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fold-bale-ops')
  AND is_sample = TRUE AND order_index = 2;

-- resolve-lane-crashes
UPDATE problems SET
  description = $$On a single corridor of a traffic grid, autonomous shuttles are lined up along a lane and dispatched simultaneously. The array `shuttles` gives each vehicle's signed mass: the magnitude is its mass and the sign is its direction — positive shuttles drive right, negative shuttles drive left. Shuttles moving in the same direction never collide; when a right-bound shuttle meets a left-bound shuttle, the lighter one is destroyed and the heavier one continues. If both have the same mass, both are destroyed.

Return the lineup of shuttles that remain on the corridor once every possible collision has resolved, in their original left-to-right order.

**Example 1:**
```
Input: shuttles = [3,7,-8]
Output: [-8]
Explanation: The -8 meets 7 and destroys it, then meets 3 and destroys it as well, leaving only -8.
```

**Example 2:**
```
Input: shuttles = [-3,4,-4,2]
Output: [-3,2]
Explanation: 4 and -4 collide and both are destroyed; -3 and 2 never meet anything going the opposite way.
```$$,
  constraints = $$- `2 <= shuttles.length <= 2 * 10^3`
- `-1200 <= shuttles[i] <= 1200`
- `shuttles[i] != 0`$$
WHERE slug = 'resolve-lane-crashes';

UPDATE test_cases SET input = E'[3,7,-8]', expected_output = '[-8]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'resolve-lane-crashes')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[-3,4,-4,2]', expected_output = '[-3,2]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'resolve-lane-crashes')
  AND is_sample = TRUE AND order_index = 2;

-- widest-vine-block
UPDATE problems SET
  description = $$A vineyard block is laid out as a row of adjacent vines of equal width `1`. The array `canopy` records each vine's canopy height. The viticulturist wants to stretch a single rectangular shade cloth across a contiguous run of vines so that the cloth sits flush on top and never rises above any vine it covers — its height is limited by the shortest canopy in that run.

Return the largest area (height times number of vines) the shade cloth can cover.

**Example 1:**
```
Input: canopy = [3,1,4,5,2,3]
Output: 8
Explanation: The cloth covering vines at indices 2 and 3 uses height 4 and width 2 for area 8.
```

**Example 2:**
```
Input: canopy = [4,2,6,3,7,5,3]
Output: 15
Explanation: The cloth covering indices 2 through 6 uses height 3 and width 5 for area 15.
```$$,
  constraints = $$- `1 <= canopy.length <= 2 * 10^5`
- `0 <= canopy[i] <= 2 * 10^3`$$
WHERE slug = 'widest-vine-block';

UPDATE test_cases SET input = E'[3,1,4,5,2,3]', expected_output = '8'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'widest-vine-block')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[4,2,6,3,7,5,3]', expected_output = '15'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'widest-vine-block')
  AND is_sample = TRUE AND order_index = 2;

-- days-to-upgrade
UPDATE problems SET
  description = $$A weather station logs the daily high temperature as the array `readings`, indexed by day. Meteorologists want to know, for each day, how long a forecaster must wait before recording a **strictly warmer** reading.

Return an array `wait` of the same length where `wait[i]` is the number of days after day `i` until a strictly warmer reading occurs. If no later day in `readings` is warmer, set `wait[i]` to `0`.

**Example 1:**
```
Input: readings = [55,58,52,50,54,60]
Output: [1,4,2,1,1,0]
Explanation: Day 1 (58) is the next warmer day after day 0. Day 5 (60) is the next warmer day after day 1. No day is warmer than day 5.
```

**Example 2:**
```
Input: readings = [45,45,45,50]
Output: [3,2,1,0]
Explanation: Each of the first three days must wait for day 3 (50), which is the next strictly warmer reading.
```$$,
  constraints = $$- `1 <= readings.length <= 2 * 10^5`
- `30 <= readings[i] <= 110`$$
WHERE slug = 'days-to-upgrade';

UPDATE test_cases SET input = E'[55,58,52,50,54,60]', expected_output = '[1,4,2,1,1,0]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'days-to-upgrade')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[45,45,45,50]', expected_output = '[3,2,1,0]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'days-to-upgrade')
  AND is_sample = TRUE AND order_index = 2;

-- shared-assembly-lookup
UPDATE problems SET
  description = $$A warehouse keeps its bill-of-materials as a **binary search tree** whose node value is the SKU number: every sub-assembly in a node's left subtree has a smaller SKU, and every sub-assembly on its right has a larger SKU. Given the `root` of this BOM tree and two specific parts `p` and `q`, return the deepest assembly that still contains both parts in its subtree.

Implement `findSharedAssembly(root, p, q)`. A node counts as its own descendant, so if one of the parts is already an ancestor of the other, return that part. Both `p` and `q` are guaranteed to exist in the tree and they are distinct.

**Example 1:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 8, q = 12
Output: 10
Explanation: SKU 8 lives under the left branch of 10 (via 5), and SKU 12 lives under the right branch of 10 (via 15). 10 is the deepest assembly containing both.
```

**Example 2:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 25, q = 40
Output: 30
Explanation: Both parts sit in the right subtree of 20. Their lowest shared assembly is 30.
```

**Example 3:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 10, q = 15
Output: 10
Explanation: 15 lies beneath 10, so 10 is itself the shared assembly.
```$$,
  constraints = $$- The number of nodes in the BOM tree is in the range `[2, 2 * 10^5]`.
- `-10^8 <= Node.val <= 10^8`
- All SKU values are unique.
- `p != q`
- Both `p` and `q` exist in the tree.$$
WHERE slug = 'shared-assembly-lookup';

UPDATE test_cases SET input = E'[20,10,30,5,15,25,40,null,8,12,18]\n8\n12', expected_output = '10'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shared-assembly-lookup')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[20,10,30,5,15,25,40,null,8,12,18]\n25\n40', expected_output = '30'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shared-assembly-lookup')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[20,10,30,5,15,25,40,null,8,12,18]\n10\n15', expected_output = '10'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shared-assembly-lookup')
  AND is_sample = TRUE AND order_index = 3;

-- ward-priority-audit
UPDATE problems SET
  description = $$A hospital organizes its ward's patient-priority tree so that, for every attending node, every patient on the left has a **strictly lower** acuity score and every patient on the right has a **strictly higher** acuity score. The administrator suspects a reorg has broken this ordering somewhere in the tree and wants a quick audit.

Given the `root` of the priority tree, implement `verifyWardOrder(root)` and return `true` if the tree obeys the BST invariant at every node (applied to the entire left and right subtrees, not only the immediate children), or `false` otherwise. All acuity scores are distinct.

**Example 1:**
```
Input: root = [50,30,70,20,40,60,80]
Output: true
Explanation: Every left subtree stays below its ancestor and every right subtree stays above. The ward ordering is consistent.
```

**Example 2:**
```
Input: root = [10,5,15,null,null,6,20]
Output: false
Explanation: 6 sits in the right subtree of root 10, but 6 < 10, so the invariant is violated.
```$$,
  constraints = $$- The number of nodes in the tree is in the range `[1, 2 * 10^5]`.
- `-10^8 <= Node.val <= 10^8`
- All acuity scores are distinct.$$
WHERE slug = 'ward-priority-audit';

UPDATE test_cases SET input = E'[50,30,70,20,40,60,80]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ward-priority-audit')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[10,5,15,null,null,6,20]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ward-priority-audit')
  AND is_sample = TRUE AND order_index = 2;

-- assemble-script-breakdown
UPDATE problems SET
  description = $$A film's production team keeps a scene breakdown as a binary tree of shots. The archive server crashed but two traversal logs survived: one recorded in **preorder** (scene, then its left branch, then its right branch) and one in **inorder** (left branch, scene, right branch). You need to rebuild the breakdown from these two logs.

Given two integer arrays `preorder` and `inorder` that contain the same shot IDs in those two traversal orders, implement `assembleBreakdown(preorder, inorder)` and return the reconstructed tree. All shot IDs are unique and every ID in `preorder` also appears in `inorder`.

**Example 1:**
```
Input: preorder = [10,5,3,7,20,15], inorder = [3,5,7,10,15,20]
Output: [10,5,20,3,7,15]
Explanation: 10 is the root. Inorder splits into [3,5,7] (left subtree) and [15,20] (right subtree). Recursing yields left = (5, left 3, right 7) and right = (20, left 15, right null).
```

**Example 2:**
```
Input: preorder = [42], inorder = [42]
Output: [42]
Explanation: A single shot becomes the entire tree.
```$$,
  constraints = $$- `1 <= preorder.length <= 2 * 10^3`
- `inorder.length == preorder.length`
- `-10^8 <= preorder[i], inorder[i] <= 10^8`
- All shot IDs are unique.
- Every value in `inorder` also appears in `preorder`.
- `preorder` is a valid preorder traversal of the tree.
- `inorder` is a valid inorder traversal of the same tree.$$
WHERE slug = 'assemble-script-breakdown';

UPDATE test_cases SET input = E'[10,5,3,7,20,15]\n[3,5,7,10,15,20]', expected_output = '[10,5,20,3,7,15]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'assemble-script-breakdown')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[42]\n[42]', expected_output = '[42]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'assemble-script-breakdown')
  AND is_sample = TRUE AND order_index = 2;

-- unroll-flight-schedule
UPDATE problems SET
  description = $$An airport operations console stores its daily airline hierarchy as a binary tree, but the turnaround crew wants it unrolled into a single right-pointing timeline that follows the tree's **preorder** sweep. You must do the unroll **in place** using the existing nodes.

Given the `root` of the schedule tree, implement `unrollSchedule(root)`. After the call, every node's `left` pointer must be `null` and its `right` pointer must point to the next node in the preorder sequence. The root of the tree stays the same; the return type is `void`. The grader inspects the tree by walking right pointers from the root.

**Example 1:**
```
Input: root = [7,3,9,1,4,null,12]
Output: [7,3,1,4,9,12]
Explanation: Preorder of the input is 7, 3, 1, 4, 9, 12. After unrolling, each node links to the next via the right pointer and all left pointers are cleared.
```

**Example 2:**
```
Input: root = []
Output: []
```

**Example 3:**
```
Input: root = [5]
Output: [5]
```$$,
  constraints = $$- The number of nodes in the schedule tree is in the range `[0, 2 * 10^3]`.
- `-10^8 <= Node.val <= 10^8`$$
WHERE slug = 'unroll-flight-schedule';

UPDATE test_cases SET input = E'[7,3,9,1,4,null,12]', expected_output = '[7,3,1,4,9,12]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unroll-flight-schedule')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[]', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unroll-flight-schedule')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[5]', expected_output = '[5]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unroll-flight-schedule')
  AND is_sample = TRUE AND order_index = 3;

-- tally-dominant-blocks
UPDATE problems SET
  description = $$A vineyard stores each year's blending tree of blocks; the node value is that block's final yield in kilograms. A block is called **dominant** when no ancestor along the path from the vintage root down to it has a strictly greater yield — in other words, the block's yield is at least as high as every yield upstream of it. The vintage root is always dominant.

Given the `root` of the blending tree, implement `tallyDominantBlocks(root)` and return the number of dominant blocks in the tree.

**Example 1:**
```
Input: root = [4,2,6,5,1,null,7]
Output: 4
Explanation: Block 4 (root) is dominant. 5 beats its max ancestor 4. 6 beats its max ancestor 4. 7 beats its max ancestor 6. Block 2 is overshadowed by 4, and block 1 is overshadowed by 4.
```

**Example 2:**
```
Input: root = [5,3,5,2,4]
Output: 2
Explanation: The root 5 is dominant. The right child 5 ties with its ancestor 5 and still counts. The left subtree blocks (3, 2, 4) are all overshadowed by the root.
```

**Example 3:**
```
Input: root = [7]
Output: 1
Explanation: A single block is always dominant.
```$$,
  constraints = $$- The number of nodes in the tree is in the range `[1, 2 * 10^5]`.
- `-10^8 <= Node.val <= 10^8`$$
WHERE slug = 'tally-dominant-blocks';

UPDATE test_cases SET input = E'[4,2,6,5,1,null,7]', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tally-dominant-blocks')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[5,3,5,2,4]', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tally-dominant-blocks')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[7]', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tally-dominant-blocks')
  AND is_sample = TRUE AND order_index = 3;

-- hub-evenness-check
UPDATE problems SET
  description = $$A courier network keeps its depot→hub→route hierarchy as a binary tree. Dispatch wants to confirm the hub distribution is **evenly loaded**: for every node, the heights of its left and right subtrees must differ by at most one. An empty tree counts as evenly loaded.

Given the `root` of the hub tree, implement `checkHubEvenness(root)` and return `true` if every subtree in the hierarchy satisfies this depth balance, or `false` if any node has left and right subtrees whose heights differ by more than one.

**Example 1:**
```
Input: root = [5,2,8,1,null,null,11]
Output: true
Explanation: Every node's left and right subtree heights differ by at most 1.
```

**Example 2:**
```
Input: root = [1,2,null,3,null,4]
Output: false
Explanation: The tree leans all the way left into a chain 1→2→3→4; the root's left subtree has height 3 while its right subtree has height 0.
```

**Example 3:**
```
Input: root = []
Output: true
Explanation: An empty hierarchy is considered evenly loaded by definition.
```$$,
  constraints = $$- The number of nodes in the tree is in the range `[0, 2 * 10^3]`.
- `-10^8 <= Node.val <= 10^8`$$
WHERE slug = 'hub-evenness-check';

UPDATE test_cases SET input = E'[5,2,8,1,null,null,11]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'hub-evenness-check')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[1,2,null,3,null,4]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'hub-evenness-check')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'hub-evenness-check')
  AND is_sample = TRUE AND order_index = 3;

-- matching-catalog-layouts
UPDATE problems SET
  description = $$A branch library and the central catalog each maintain their Dewey-style classification as a binary tree whose node value is the call-number code for that section. A migration audit needs to confirm the two layouts are **identical** — same shape and same call number at every corresponding node.

Given the roots of two classification trees `p` and `q`, implement `matchCatalogLayout(p, q)` and return `true` if the two trees mirror each other node for node (structure and value), or `false` otherwise. Either tree may be empty.

**Example 1:**
```
Input: p = [8,4,12], q = [8,4,12]
Output: true
Explanation: Both catalogs have identical shape and identical call numbers at every node.
```

**Example 2:**
```
Input: p = [3,5], q = [3,null,5]
Output: false
Explanation: In p the 5 hangs as a left child of 3. In q the 5 hangs as a right child. The shapes differ even though the multisets of values match.
```

**Example 3:**
```
Input: p = [6,2,9], q = [6,9,2]
Output: false
Explanation: The shapes match but the left and right call numbers are swapped, so the catalogs are not identical.
```$$,
  constraints = $$- The number of nodes in each tree is in the range `[0, 2 * 10^3]`.
- `-10^8 <= Node.val <= 10^8`$$
WHERE slug = 'matching-catalog-layouts';

UPDATE test_cases SET input = E'[8,4,12]\n[8,4,12]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'matching-catalog-layouts')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[3,5]\n[3,null,5]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'matching-catalog-layouts')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[6,2,9]\n[6,9,2]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'matching-catalog-layouts')
  AND is_sample = TRUE AND order_index = 3;

-- nth-dimmest-target
UPDATE problems SET
  description = $$A nightly observing catalog is organized as a binary search tree keyed by target magnitude (lower numeric magnitude means brighter). The observatory logs every target under a root pointer so that an in-order walk of the tree visits targets from brightest to dimmest.

Given the `root` of the catalog tree and a 1-indexed position `k`, implement `pickNthTarget` to return the magnitude of the `k`th brightest target in the catalog.

You may assume `k` is within `[1, n]`, where `n` is the number of logged targets.

**Example 1:**
```
Input: root = [8,4,12,2,6,10,14], k = 4
Output: 8
Explanation: In-order traversal yields magnitudes [2,4,6,8,10,12,14]. The 4th entry is 8.
```

**Example 2:**
```
Input: root = [20,10,30,5,15,25,35,null,7], k = 2
Output: 7
Explanation: In-order traversal yields [5,7,10,15,20,25,30,35]. The 2nd entry is 7.
```$$,
  constraints = $$- The number of targets in the catalog is `n`.
- `1 <= k <= n <= 8 * 10^4`
- `0 <= Node.val <= 10^8`
- The tree is a valid binary search tree.$$
WHERE slug = 'nth-dimmest-target';

UPDATE test_cases SET input = E'[8,4,12,2,6,10,14]\n4', expected_output = '8'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'nth-dimmest-target')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[20,10,30,5,15,25,35,null,7]\n2', expected_output = '7'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'nth-dimmest-target')
  AND is_sample = TRUE AND order_index = 2;

-- flights-by-tier
UPDATE problems SET
  description = $$An airline's daily manifest is modeled as a binary tree rooted at the carrier, descending through aircraft types to individual flights. Ops teams want to broadcast each tier as its own row on a status board, top tier first.

Given the `root` of the manifest tree, implement `groupByTier` to return the values level by level, where each inner list holds the values at that depth ordered from left to right.

If the manifest is empty, return an empty list.

**Example 1:**
```
Input: root = [10,5,15,null,null,12,20]
Output: [[10],[5,15],[12,20]]
Explanation: Tier 0 has flight 10. Tier 1 has flights 5 and 15. Tier 2 has flights 12 and 20.
```

**Example 2:**
```
Input: root = [42]
Output: [[42]]
Explanation: A solo root flight makes a single-row board.
```

**Example 3:**
```
Input: root = []
Output: []
```$$,
  constraints = $$- The number of nodes in the manifest tree is in the range `[0, 2 * 10^3]`.
- `-1000 <= Node.val <= 1000`$$
WHERE slug = 'flights-by-tier';

UPDATE test_cases SET input = E'[10,5,15,null,null,12,20]', expected_output = '[[10],[5,15],[12,20]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flights-by-tier')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[42]', expected_output = '[[42]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flights-by-tier')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[]', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flights-by-tier')
  AND is_sample = TRUE AND order_index = 3;

-- best-scene-branch
UPDATE problems SET
  description = $$A production breakdown is stored as a binary tree where each node carries a signed audience-impact score for a scene; positive scores excite the audience, negative ones drag. The editor wants the most impactful contiguous chain of scenes to build an act around.

A **branch** is a sequence of nodes where each adjacent pair is connected by an edge, no node repeats, and the chain does not need to contain the root. The **branch total** is the sum of scores along the chain.

Given the `root` of the breakdown tree, implement `maxBranchTotal` to return the largest branch total among all non-empty branches.

**Example 1:**
```
Input: root = [4,5,6]
Output: 15
Explanation: The best branch is 5 -> 4 -> 6, totaling 5 + 4 + 6 = 15.
```

**Example 2:**
```
Input: root = [-8,11,25,null,null,13,9]
Output: 47
Explanation: The best branch is 13 -> 25 -> 9, totaling 13 + 25 + 9 = 47. Starting at the root pulls the total down because of the -8.
```$$,
  constraints = $$- The number of scenes in the tree is in the range `[1, 8 * 10^4]`.
- `-1000 <= Node.val <= 1000`$$
WHERE slug = 'best-scene-branch';

UPDATE test_cases SET input = E'[4,5,6]', expected_output = '15'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'best-scene-branch')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[-8,11,25,null,null,13,9]', expected_output = '47'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'best-scene-branch')
  AND is_sample = TRUE AND order_index = 2;

-- reflect-blend-profile
UPDATE problems SET
  description = $$A winemaker stores a blending plan as a binary tree: each node names a barrel, its left child is the early-palate blend, its right child is the late-palate blend. To taste the reverse of every blending decision, the winemaker wants a mirrored copy of the plan where every left/right pairing is swapped, all the way down.

Given the `root` of the blend tree, implement `reflectBlend` to swap every node's left and right children recursively and return the root of the reflected tree.

**Example 1:**
```
Input: root = [5,3,8,2,4,7,9]
Output: [5,8,3,9,7,4,2]
Explanation: Every left/right pair is swapped at every level.
```

**Example 2:**
```
Input: root = [6,4,11]
Output: [6,11,4]
```

**Example 3:**
```
Input: root = []
Output: []
```$$,
  constraints = $$- The number of barrels in the tree is in the range `[0, 100]`.
- `-100 <= Node.val <= 100`$$
WHERE slug = 'reflect-blend-profile';

UPDATE test_cases SET input = E'[5,3,8,2,4,7,9]', expected_output = '[5,8,3,9,7,4,2]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reflect-blend-profile')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[6,4,11]', expected_output = '[6,11,4]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reflect-blend-profile')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[]', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reflect-blend-profile')
  AND is_sample = TRUE AND order_index = 3;

-- wire-zone-peers
UPDATE problems SET
  description = $$A smart-home mesh is laid out as a **perfect binary tree**: every hub except the leaves has exactly two child hubs, and every leaf hub sits on the same floor. Each hub exposes an additional `next` pointer that ops wants to wire up so a sibling-level gossip broadcast can ripple across a floor without re-walking the root.

```
class Node {
    int val;
    Node left;
    Node right;
    Node next;
}
```

Implement `wireSiblingHubs` so that for every hub, `next` points at the hub immediately to its right on the same floor. If a hub is the rightmost on its floor, `next` must remain `null`. Return the `root` of the updated mesh.

**Example 1:**
```
Input: root = [10,20,30,40,50,60,70]
Output: [10,#,20,30,#,40,50,60,70,#]
Explanation: The tree has three floors.
- Floor 0: 10 -> null
- Floor 1: 20 -> 30 -> null
- Floor 2: 40 -> 50 -> 60 -> 70 -> null
The # marks the end of each floor's chain.
```

**Example 2:**
```
Input: root = [9]
Output: [9,#]
Explanation: A lone hub has no right neighbor.
```

**Example 3:**
```
Input: root = [5,6,7]
Output: [5,#,6,7,#]
```$$,
  constraints = $$- The number of hubs in the mesh is in the range `[1, 4096]`.
- `-1000 <= Node.val <= 1000`
- The mesh is guaranteed to be a perfect binary tree.$$
WHERE slug = 'wire-zone-peers';

UPDATE test_cases SET input = E'[10,20,30,40,50,60,70]', expected_output = '[10,#,20,30,#,40,50,60,70,#]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'wire-zone-peers')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[9]', expected_output = '[9,#]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'wire-zone-peers')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[5,6,7]', expected_output = '[5,#,6,7,#]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'wire-zone-peers')
  AND is_sample = TRUE AND order_index = 3;

-- dock-edge-silhouette
UPDATE problems SET
  description = $$A warehouse stores its bill-of-materials as a binary tree: root assembly at the top, subassemblies and parts branching below. From the loading dock you can only see the rightmost shelf that sticks out at each tier; anything to its left is hidden behind it.

Given the `root` of the bill-of-materials tree, implement `captureDockSilhouette` to return, tier by tier from top to bottom, the value of the rightmost visible shelf on that tier. If the tree is empty, return an empty list.

**Example 1:**
```
Input: root = [7,8,9,null,6,null,3]
Output: [7,9,3]
Explanation: Tier 0 shows shelf 7. Tier 1 shows shelves 8 and 9 with 9 on the right. Tier 2 shows shelves 6 and 3 with 3 on the right.
```

**Example 2:**
```
Input: root = [2,null,5]
Output: [2,5]
```

**Example 3:**
```
Input: root = []
Output: []
```$$,
  constraints = $$- The number of shelves in the tree is in the range `[0, 100]`.
- `-100 <= Node.val <= 100`$$
WHERE slug = 'dock-edge-silhouette';

UPDATE test_cases SET input = E'[7,8,9,null,6,null,3]', expected_output = '[7,9,3]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'dock-edge-silhouette')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[2,null,5]', expected_output = '[2,5]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'dock-edge-silhouette')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[]', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'dock-edge-silhouette')
  AND is_sample = TRUE AND order_index = 3;

-- sum-zone-codes
UPDATE problems SET
  description = $$A postal sorting center stores its region-to-postcode hierarchy as a binary tree where every node holds a single digit (`0`-`9`). Walking from the root down to any leaf spells out a full zone code: concatenating the digits along that path gives a single integer for that branch.

Given the `root` of the zone-code tree, implement `totalZoneCodes` to return the sum of every zone code produced by a root-to-leaf walk.

**Example 1:**
```
Input: root = [2,5,8]
Output: 53
Explanation: Path 2 -> 5 spells 25 and path 2 -> 8 spells 28. Total = 25 + 28 = 53.
```

**Example 2:**
```
Input: root = [3,6,1,4,0]
Output: 755
Explanation: 3 -> 6 -> 4 = 364, 3 -> 6 -> 0 = 360, 3 -> 1 = 31. Total = 364 + 360 + 31 = 755.
```

**Example 3:**
```
Input: root = [9]
Output: 9
Explanation: A single node is both root and leaf, giving one zone code of 9.
```$$,
  constraints = $$- The number of nodes in the zone-code tree is in the range `[1, 1000]`.
- `0 <= Node.val <= 9`$$
WHERE slug = 'sum-zone-codes';

UPDATE test_cases SET input = E'[2,5,8]', expected_output = '53'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sum-zone-codes')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[3,6,1,4,0]', expected_output = '755'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sum-zone-codes')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[9]', expected_output = '9'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sum-zone-codes')
  AND is_sample = TRUE AND order_index = 3;

-- list-runtime-branches
UPDATE problems SET
  description = $$A post-production editor breaks the film down as a tree: the `root` is the final cut, each inner node is an act or sequence, and every leaf is an unbroken runtime segment with a minute count written on it. The editor wants every top-to-bottom branch whose minute values add up to exactly `target`, because those branches fit cleanly into a slot the broadcaster has pre-sold.

Implement `listRuntimeBranches(root, target)` to return every root-to-leaf path whose node values sum to `target`. Each path is returned as the list of node values in order from `root` down to the leaf. A **leaf** is a node with no children. Return the paths in the order they are discovered by a left-first depth-first walk.

**Example 1:**
```
Input: root = [10,6,9,3,null,4,5,null,null,8,2], target = 19
Output: [[10,6,3]]
Explanation: The only root-to-leaf branch summing to 19 is 10 -> 6 -> 3.
```

**Example 2:**
```
Input: root = [7,2,4,null,5,1,3], target = 14
Output: [[7,2,5],[7,4,3]]
Explanation: Two branches reach 14: 7 + 2 + 5 and 7 + 4 + 3.
```$$,
  constraints = $$- The number of nodes in the tree is in the range `[0, 4500]`.
- `-1000 <= Node.val <= 1000`
- `-1000 <= target <= 1000`$$
WHERE slug = 'list-runtime-branches';

UPDATE test_cases SET input = E'[10,6,9,3,null,4,5,null,null,8,2]\n19', expected_output = '[[10,6,3]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'list-runtime-branches')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[7,2,4,null,5,1,3]\n14', expected_output = '[[7,2,5],[7,4,3]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'list-runtime-branches')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[3,4]\n7', expected_output = '[[3,4]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'list-runtime-branches')
  AND is_sample = TRUE AND order_index = 3;

-- shared-dispatch-hub
UPDATE problems SET
  description = $$A courier network is laid out as a tree of dispatch hubs: the `root` is the central depot, each child is a regional hub, and deeper nodes are zone hubs, last-mile clusters, and finally individual drop stops. Every hub carries a unique numeric code. When two packages headed for stops `p` and `q` need to ride the same van as far as possible, dispatch wants the deepest hub that has both stops somewhere in its subtree.

Implement `findSharedHub(root, p, q)` to return that **lowest common ancestor** node. A hub is considered an ancestor of itself, so if one of `p` or `q` sits above the other, that upper node is the answer. All node values are unique, and both `p` and `q` are guaranteed to exist in the tree.

**Example 1:**
```
Input: root = [12,7,20,4,9,16,25,null,null,8,11], p = 4, q = 11
Output: 7
Explanation: Stop 4 sits under hub 7, and stop 11 sits under hub 9 which itself sits under hub 7, so 7 is the deepest shared hub.
```

**Example 2:**
```
Input: root = [12,7,20,4,9,16,25,null,null,8,11], p = 9, q = 7
Output: 7
Explanation: Hub 9 is already under hub 7, so 7 is its own lowest common ancestor with 9.
```$$,
  constraints = $$- The number of nodes in the tree is in the range `[2, 9000]`.
- `|Node.val| <= 10^8`
- All `Node.val` are unique.
- `p != q`
- Both `p` and `q` are present in the tree.$$
WHERE slug = 'shared-dispatch-hub';

UPDATE test_cases SET input = E'[12,7,20,4,9,16,25,null,null,8,11]\n4\n11', expected_output = '7'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shared-dispatch-hub')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[12,7,20,4,9,16,25,null,null,8,11]\n9\n7', expected_output = '7'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shared-dispatch-hub')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[5,2,6]\n2\n6', expected_output = '5'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shared-dispatch-hub')
  AND is_sample = TRUE AND order_index = 3;

-- deepest-zone-chain
UPDATE problems SET
  description = $$A regional mail sorter models its address space as a hierarchy: the `root` is the country-level zone code, its children are provincial codes, their children are city codes, and so on down to individual postcodes. Leadership wants to know, at a glance, how many levels deep the deepest zone-code chain runs so they can size the scanner cache accordingly.

Implement `deepestZoneChain(root)` to return the **maximum depth** of the hierarchy — that is, the number of nodes on the longest path from `root` down to any leaf. A leaf is a node with no children. An empty tree has depth `0`.

**Example 1:**
```
Input: root = [8,5,12,null,null,9,17]
Output: 3
Explanation: The longest chain has three hubs: 8 -> 12 -> 9 or 8 -> 12 -> 17.
```

**Example 2:**
```
Input: root = [4,null,2,null,7]
Output: 3
Explanation: The chain 4 -> 2 -> 7 runs three nodes deep; the left spine is empty.
```$$,
  constraints = $$- The number of nodes in the tree is in the range `[0, 8000]`.
- `-100 <= Node.val <= 100`$$
WHERE slug = 'deepest-zone-chain';

UPDATE test_cases SET input = E'[8,5,12,null,null,9,17]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'deepest-zone-chain')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[4,null,2,null,7]', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'deepest-zone-chain')
  AND is_sample = TRUE AND order_index = 2;

-- widest-catalog-span
UPDATE problems SET
  description = $$A librarian lays out the Dewey classification as a tree: the `root` is the top-level class, and every descendant is a narrower sub-classification down to individual call-number buckets. For an accessibility audit, the librarian needs the number of cross-shelf **hops** on the longest walk between any two buckets in the catalog — the path may pivot at an interior class or run straight down a single spine, whichever is longer.

Implement `widestCatalogSpan(root)` to return that span, measured as the number of **edges** on the longest path between any two nodes in the tree. The path is not required to pass through `root`.

**Example 1:**
```
Input: root = [7,3,8,1,4,null,9]
Output: 4
Explanation: The walk 1 -> 3 -> 7 -> 8 -> 9 uses 4 edges, which is the widest span.
```

**Example 2:**
```
Input: root = [2,null,5,3]
Output: 2
Explanation: The walk 2 -> 5 -> 3 crosses two edges.
```$$,
  constraints = $$- The number of nodes in the tree is in the range `[1, 8000]`.
- `-100 <= Node.val <= 100`$$
WHERE slug = 'widest-catalog-span';

UPDATE test_cases SET input = E'[7,3,8,1,4,null,9]', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'widest-catalog-span')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[2,null,5,3]', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'widest-catalog-span')
  AND is_sample = TRUE AND order_index = 2;

-- contains-topic-branch
UPDATE problems SET
  description = $$A news aggregator maintains a topic taxonomy as a tree: every node is a topic label, and the parent-child links encode which broader topic subsumes which narrower one. An analyst comes to you with a small reference branch that describes a niche coverage area and asks whether that exact branch already lives somewhere inside the main taxonomy.

Given the taxonomy `root` and the reference branch `subRoot`, implement `containsSubBranch(root, subRoot)` to return `true` when there is a node in `root` whose entire subtree matches `subRoot` both in shape and in every corresponding topic value. The whole `root` tree counts as one of its own subtrees. Return `false` if no such node exists.

**Example 1:**
```
Input: root = [9,6,7,2,4], subRoot = [6,2,4]
Output: true
Explanation: The left child of root is topic 6, and its subtree [6,2,4] matches subRoot exactly.
```

**Example 2:**
```
Input: root = [1,8,3,null,5], subRoot = [8,5]
Output: false
Explanation: Topic 8 appears in root, but there the child 5 hangs on the right, while subRoot has 5 on the left, so the shapes do not agree.
```$$,
  constraints = $$- The number of nodes in the `root` tree is in the range `[1, 2000]`.
- The number of nodes in the `subRoot` tree is in the range `[1, 900]`.
- `-8000 <= root.val <= 8000`
- `-8000 <= subRoot.val <= 8000`$$
WHERE slug = 'contains-topic-branch';

UPDATE test_cases SET input = E'[9,6,7,2,4]\n[6,2,4]', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'contains-topic-branch')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[1,8,3,null,5]\n[8,5]', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'contains-topic-branch')
  AND is_sample = TRUE AND order_index = 2;

-- alternate-ward-sweep
UPDATE problems SET
  description = $$A hospital triage board is organized as a binary tree of acuity scores: the `root` is the on-call lead, each left branch tracks lower-acuity consults and each right branch tracks higher-acuity ones. During the twice-hourly sweep the charge nurse walks the board in a zigzag: the lead's row is read left-to-right, the row below right-to-left, the next row left-to-right again, and so on, alternating direction every ward level.

Implement `alternateWardSweep(root)` to return the node values grouped by level using that zigzag order. Each level is an inner list; the outer list is ordered from the root's level downward. An empty tree yields an empty list.

**Example 1:**
```
Input: root = [5,3,7,2,9,6,8]
Output: [[5],[7,3],[2,9,6,8]]
Explanation: Row 0 left-to-right gives [5]; row 1 right-to-left gives [7,3]; row 2 left-to-right gives [2,9,6,8].
```

**Example 2:**
```
Input: root = [4]
Output: [[4]]
Explanation: A single node is reported on its own row.
```$$,
  constraints = $$- The number of nodes in the tree is in the range `[0, 1800]`.
- `-100 <= Node.val <= 100`$$
WHERE slug = 'alternate-ward-sweep';

UPDATE test_cases SET input = E'[5,3,7,2,9,6,8]', expected_output = '[[5],[7,3],[2,9,6,8]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'alternate-ward-sweep')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[4]', expected_output = '[[4]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'alternate-ward-sweep')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[]', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'alternate-ward-sweep')
  AND is_sample = TRUE AND order_index = 3;

-- flag-material-codes
UPDATE problems SET
  description = $$A recycling plant lays out its sort floor as an `m x n` grid of cells, where each cell is stamped with a single lowercase letter of **material shorthand** (a, p, g, r, etc.). The quality team keeps a list of hazard `patterns` that must be audited against the current floor layout.

A pattern is considered **traceable** if its letters can be read off by starting at some cell in `grid` and walking through **horizontally or vertically adjacent** cells in order, without stepping on the same cell twice within a single trace.

Implement `flagMaterialCodes(grid, patterns)` to return every traceable pattern from `patterns`, sorted in lexicographic order. Each pattern in the result must appear at most once even if it could be traced in multiple ways.

**Example 1:**
```
Input: grid = [["c","o","d","e"],["h","a","t","s"],["i","r","n","m"],["p","u","a","l"]], patterns = ["code","chat","maze","nail"]
Output: ["chat","code"]
```

**Example 2:**
```
Input: grid = [["p","a"],["g","c"]], patterns = ["pcg"]
Output: []
```$$,
  constraints = $$- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 12`
- `grid[i][j]` is a lowercase English letter.
- `1 <= patterns.length <= 8 * 10^4`
- `1 <= patterns[i].length <= 10`
- `patterns[i]` consists of lowercase English letters.
- All the strings in `patterns` are unique.$$
WHERE slug = 'flag-material-codes';

UPDATE test_cases SET input = E'[["c","o","d","e"],["h","a","t","s"],["i","r","n","m"],["p","u","a","l"]]\n["code","chat","maze","nail"]', expected_output = '["chat","code"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flag-material-codes')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[["p","a"],["g","c"]]\n["pcg"]', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flag-material-codes')
  AND is_sample = TRUE AND order_index = 2;

-- pair-crates-for-order
UPDATE problems SET
  description = $$A cross-dock manager is loading crates onto pallets before the evening ship-out. Each pallet can hold **at most two crates** and cannot exceed a combined weight of `capacity` kilograms. Every crate must go on exactly one pallet.

Given an integer array `crates` where `crates[i]` is the weight of the `i`-th crate and an integer `capacity` giving the pallet weight limit, return the **minimum number of pallets** needed to ship every crate out of the dock.

**Example 1:**
```
Input: crates = [2,4], capacity = 6
Output: 1
Explanation: The two crates together weigh 6 kg, which fits a single pallet.
```

**Example 2:**
```
Input: crates = [4,3,1,2], capacity = 4
Output: 3
Explanation: Pair crate 1 with crate 3 (sum 4) on one pallet. Crate 2 rides alone, and crate 4 rides alone — three pallets in total.
```$$,
  constraints = $$- `1 <= crates.length <= 2 * 10^5`
- `1 <= crates[i] <= capacity <= 2 * 10^3`$$
WHERE slug = 'pair-crates-for-order';

UPDATE test_cases SET input = E'[2,4]\n6', expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pair-crates-for-order')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[4,3,1,2]\n4', expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pair-crates-for-order')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[6,7,5,8]\n9', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pair-crates-for-order')
  AND is_sample = TRUE AND order_index = 3;

-- shift-unscannable-letters
UPDATE problems SET
  description = $$A postal sorter reads zone letters stamped on a long belt of parcels, producing a string `code` of uppercase letters. To maximize a clean run for a single destination bin, the operator is allowed to **relabel at most `k` parcels**, each relabel rewriting one letter in `code` to any other uppercase letter.

Return the length of the longest contiguous run in `code` that can be made to consist of a single letter after performing at most `k` relabels.

**Example 1:**
```
Input: code = "PQPQ", k = 2
Output: 4
Explanation: Relabel both P's to Q to obtain "QQQQ", a run of length 4.
```

**Example 2:**
```
Input: code = "XXYXYYX", k = 1
Output: 4
Explanation: Relabel the Y at index 2 to X to obtain the run "XXXX" from indices 0..3.
```$$,
  constraints = $$- `1 <= code.length <= 2 * 10^5`
- `code` consists of only uppercase English letters.
- `0 <= k <= code.length`$$
WHERE slug = 'shift-unscannable-letters';

UPDATE test_cases SET input = E'PQPQ\n2', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shift-unscannable-letters')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'XXYXYYX\n1', expected_output = '4'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shift-unscannable-letters')
  AND is_sample = TRUE AND order_index = 2;

-- void-empty-scans
UPDATE problems SET
  description = $$A checkout terminal keeps a log `scans` of the amounts charged for each barcode in the order it was scanned. Voided entries appear as `0` in the log. To keep the receipt tidy for the customer, the cashier wants every voided entry pushed to the tail of the log while keeping the **relative order of the real charges** exactly as they were scanned.

Mutate `scans` **in place** — do not allocate a new array. The driver will print the array after your method returns.

**Example 1:**
```
Input: scans = [4,0,0,2,9,0,7]
Output: [4,2,9,7,0,0,0]
Explanation: The four real charges keep their scan order, and the three voids slide to the end.
```

**Example 2:**
```
Input: scans = [0,0,5]
Output: [5,0,0]
```$$,
  constraints = $$- `1 <= scans.length <= 2 * 10^5`
- `|scans[i]| <= 10^8`$$
WHERE slug = 'void-empty-scans';

UPDATE test_cases SET input = E'[4,0,0,2,9,0,7]', expected_output = '[4,2,9,7,0,0,0]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'void-empty-scans')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[0,0,5]', expected_output = '[5,0,0]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'void-empty-scans')
  AND is_sample = TRUE AND order_index = 2;

-- verify-mirror-callnumber
UPDATE problems SET
  description = $$A library's special-collections curator labels mirror-themed displays with **call-number phrases** that are supposed to read the same forward and backward once you ignore casing and all non-alphanumeric characters (spaces, punctuation, etc.). An intern wants a quick checker before printing the labels.

Given a string `code`, convert all uppercase letters to lowercase and strip every non-alphanumeric character. Return `true` if the resulting sequence reads identically forward and backward, otherwise return `false`. Treat the empty string as a valid mirror.

**Example 1:**
```
Input: code = "Stacks: Level 2 level stack S"
Output: true
Explanation: After filtering, the phrase becomes "stackslevel2levelstacks", which mirrors itself.
```

**Example 2:**
```
Input: code = "Shelf 7A not mirrored"
Output: false
Explanation: After filtering the phrase becomes "shelf7anotmirrored", which is not a mirror.
```

**Example 3:**
```
Input: code = ",,,"
Output: true
Explanation: After removing non-alphanumeric characters the phrase is empty, which counts as a mirror.
```$$,
  constraints = $$- `1 <= code.length <= 2 * 10^5`
- `code` consists only of printable characters between 32 and 126.$$
WHERE slug = 'verify-mirror-callnumber';

UPDATE test_cases SET input = E'Stacks: Level 2 level stack S', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'verify-mirror-callnumber')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'Shelf 7A not mirrored', expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'verify-mirror-callnumber')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E',,,', expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'verify-mirror-callnumber')
  AND is_sample = TRUE AND order_index = 3;

-- quad-tray-demand
UPDATE problems SET
  description = $$A bakery planner has a roster of proofed trays, each with a signed loaf-count adjustment `trays[i]` (positive means a surplus versus the plan, negative means a shortfall). She wants to discover which **groups of four distinct trays** can be pooled so their combined adjustment lands exactly on a target demand delta.

Given an integer array `trays` and an integer `demand`, return every **unique quadruplet** `[trays[a], trays[b], trays[c], trays[d]]` of four distinct indices whose values sum to `demand`. The answer must contain no duplicate quadruplets and may be returned in any order.

**Example 1:**
```
Input: trays = [1,-1,2,-2,3,-3], demand = 0
Output: [[-3,-2,2,3],[-3,-1,1,3],[-2,-1,1,2]]
Explanation: Three distinct foursomes of tray adjustments add up to a zero net delta.
```

**Example 2:**
```
Input: trays = [3,3,3,3,3], demand = 12
Output: [[3,3,3,3]]
Explanation: Every tray has surplus 3, and any four of them pool to 12.
```$$,
  constraints = $$- `1 <= trays.length <= 2 * 10^3`
- `|trays[i]| <= 10^8`
- `|demand| <= 10^8`$$
WHERE slug = 'quad-tray-demand';

UPDATE test_cases SET input = E'[1,-1,2,-2,3,-3]\n0', expected_output = '[[-3,-2,2,3],[-3,-1,1,3],[-2,-1,1,2]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'quad-tray-demand')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[3,3,3,3,3]\n12', expected_output = '[[3,3,3,3]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'quad-tray-demand')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[5,6,7,8]\n50', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'quad-tray-demand')
  AND is_sample = TRUE AND order_index = 3;

-- pool-between-walls
UPDATE problems SET
  description = $$A terraced irrigation field runs as a straight strip of masonry walls, one per plot. You are given an array `wallHeight` of `n` non-negative integers, where `wallHeight[i]` is the height of the wall on plot `i` (each plot is 1 meter wide). After a storm, water pools in the low spots between taller walls up to the level of the shorter neighbor on either side.

Return the total volume of rainwater (in unit cells) that the field holds once runoff has settled.

**Example 1:**
```
Input: wallHeight = [0,2,0,3,1,0,2,4,1,2,0,1]
Output: 10
Explanation: The tallest flanking walls cap each trough. Summing the trapped depth above every plot yields 10 unit cells.
```

**Example 2:**
```
Input: wallHeight = [3,1,0,2,1,4]
Output: 8
Explanation: Water pools between the leftmost wall of height 3 and the rightmost wall of height 4, trapping 8 unit cells in the dip.
```$$,
  constraints = $$- `n == wallHeight.length`
- `1 <= n <= 2 * 10^5`
- `0 <= wallHeight[i] <= 10^8`$$
WHERE slug = 'pool-between-walls';

UPDATE test_cases SET input = E'[0,2,0,3,1,0,2,4,1,2,0,1]', expected_output = '10'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pool-between-walls')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[3,1,0,2,1,4]', expected_output = '8'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pool-between-walls')
  AND is_sample = TRUE AND order_index = 2;

-- pair-tiers-budget
UPDATE problems SET
  description = $$The box office runs a **1-indexed** price sheet `tierPrice` sorted in non-decreasing order, one row per seating tier. A fan walks up with a fixed `budget` and wants exactly two different tiers whose listed prices add up to that budget so they can buy one seat in each.

Return the two tier numbers as `[tier1, tier2]` with `1 <= tier1 < tier2 <= tierPrice.length`. The input is guaranteed to admit exactly one such pair, and your routine must use only constant extra space beyond the input itself.

**Example 1:**
```
Input: tierPrice = [12,30,45,58,70,85], budget = 100
Output: [2,5]
Explanation: Tier 2 costs 30 and tier 5 costs 70, which together match the 100 budget.
```

**Example 2:**
```
Input: tierPrice = [5,14,22,40], budget = 54
Output: [2,4]
Explanation: Tier 2 is 14 and tier 4 is 40; 14 + 40 = 54.
```$$,
  constraints = $$- `2 <= tierPrice.length <= 2 * 10^5`
- `-10^8 <= tierPrice[i] <= 10^8`
- `tierPrice` is sorted in non-decreasing order.
- `-2 * 10^8 <= budget <= 2 * 10^8`
- The input is generated so that exactly one valid pair exists.$$
WHERE slug = 'pair-tiers-budget';

UPDATE test_cases SET input = E'[12,30,45,58,70,85]\n100', expected_output = '[2,5]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pair-tiers-budget')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[5,14,22,40]\n54', expected_output = '[2,4]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pair-tiers-budget')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[-8,-3,2,5]\n-1', expected_output = '[2,3]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pair-tiers-budget')
  AND is_sample = TRUE AND order_index = 3;

-- order-tank-deviations
UPDATE problems SET
  description = $$Each tank in the aquarium logs its pH deviation from the baseline as a signed integer. You are given an array `deviation` sorted in non-decreasing order (acidic drifts are negative, alkaline drifts are positive). For a stress audit the lab wants the **squared** deviation of every tank, then returned in non-decreasing order so mild drifts come first and the most unstable tanks come last.

Return the array of squared deviations, sorted ascending. Aim for an O(n) pass — no general-purpose sort.

**Example 1:**
```
Input: deviation = [-5,-2,0,4,9]
Output: [0,4,16,25,81]
```

**Example 2:**
```
Input: deviation = [-6,-4,1,3,8]
Output: [1,9,16,36,64]
```

**Example 3:**
```
Input: deviation = [2,3,5,7]
Output: [4,9,25,49]
Explanation: All readings are non-negative, so squaring them preserves the existing order.
```$$,
  constraints = $$- `1 <= deviation.length <= 2 * 10^5`
- `-8 * 10^3 <= deviation[i] <= 8 * 10^3`
- `deviation` is sorted in non-decreasing order.$$
WHERE slug = 'order-tank-deviations';

UPDATE test_cases SET input = E'[-5,-2,0,4,9]', expected_output = '[0,4,16,25,81]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'order-tank-deviations')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[-6,-4,1,3,8]', expected_output = '[1,9,16,36,64]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'order-tank-deviations')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[2,3,5,7]', expected_output = '[4,9,25,49]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'order-tank-deviations')
  AND is_sample = TRUE AND order_index = 3;

-- triage-zero-priority
UPDATE problems SET
  description = $$The 119 dispatch desk tracks each pending call's **priority delta** — a signed integer where negatives mean the call is under-prioritized and positives mean it is over-prioritized relative to protocol. Given an integer array `delta`, the supervisor wants every unique trio of three distinct call indices whose deltas sum to exactly zero (a perfectly balanced triage group).

Return all such triplets as `[delta[i], delta[j], delta[k]]`. Each triplet must appear at most once regardless of how many index trios produce it, and the triplets may be returned in any order.

**Example 1:**
```
Input: delta = [-3,1,2,-2,0,-1,1]
Output: [[-3,1,2],[-2,0,2],[-2,1,1],[-1,0,1]]
Explanation: Four distinct balanced trios exist; each sums to zero.
```

**Example 2:**
```
Input: delta = [2,3,4]
Output: []
Explanation: Every delta is positive, so no trio can sum to zero.
```

**Example 3:**
```
Input: delta = [0,0,0,0]
Output: [[0,0,0]]
```$$,
  constraints = $$- `3 <= delta.length <= 2 * 10^3`
- `-10^8 <= delta[i] <= 10^8`$$
WHERE slug = 'triage-zero-priority';

UPDATE test_cases SET input = E'[-3,1,2,-2,0,-1,1]', expected_output = '[[-3,1,2],[-2,0,2],[-2,1,1],[-1,0,1]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'triage-zero-priority')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[2,3,4]', expected_output = '[]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'triage-zero-priority')
  AND is_sample = TRUE AND order_index = 2;
UPDATE test_cases SET input = E'[0,0,0,0]', expected_output = '[[0,0,0]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'triage-zero-priority')
  AND is_sample = TRUE AND order_index = 3;

-- frame-largest-bale
UPDATE problems SET
  description = $$On the recycling plant floor, a row of vertical partition walls lines the bale-staging area. Each wall `i` rises from the ground at position `(i, 0)` up to `(i, partitionHeight[i])`. To stage a new bale, you choose two walls; together with the floor (the x-axis) they frame a rectangular footprint whose height is limited by the **shorter** of the two walls and whose width is the horizontal distance between them.

Given the integer array `partitionHeight` of length `n`, return the largest rectangular bale footprint (width × limiting height) that any pair of walls can frame. Walls may not be tilted.

**Example 1:**
```
Input: partitionHeight = [2,6,4,1,5,3,6,2,8]
Output: 42
Explanation: The walls at index 1 (height 6) and index 8 (height 8) frame a footprint of width 7 and limiting height 6, giving 42.
```

**Example 2:**
```
Input: partitionHeight = [2,3]
Output: 2
```$$,
  constraints = $$- `n == partitionHeight.length`
- `2 <= n <= 2 * 10^5`
- `0 <= partitionHeight[i] <= 8 * 10^4`$$
WHERE slug = 'frame-largest-bale';

UPDATE test_cases SET input = E'[2,6,4,1,5,3,6,2,8]', expected_output = '42'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'frame-largest-bale')
  AND is_sample = TRUE AND order_index = 1;
UPDATE test_cases SET input = E'[2,3]', expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'frame-largest-bale')
  AND is_sample = TRUE AND order_index = 2;
