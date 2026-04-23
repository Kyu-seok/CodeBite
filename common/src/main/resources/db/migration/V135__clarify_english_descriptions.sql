-- V135: Rewrite every English problem description to be clearer, more direct,
-- and easier to understand while preserving the rethemed casual scenarios.
-- Example blocks, identifiers, and numeric values are kept verbatim; only the
-- prose framing is tightened. Korean translations are NOT touched in this pass.

-- add-score-lists
UPDATE problems SET
    description = $$Two player scores are stored as linked lists with the **ones digit at the head** and more significant digits after. Add the two scores and return the sum as a new linked list in the same reverse-digit layout.

Neither input has a leading zero, except the single-node list representing `0`.

**Example 1:**
```
Input: score1 = [3,1,7], score2 = [4,8]
Output: [7,9,7]
Explanation: The inputs spell out 713 and 84. Their sum, 797, is written back ones-digit first.
```

**Example 2:**
```
Input: score1 = [9], score2 = [8]
Output: [7,1]
Explanation: 9 + 8 = 17, so the head node stores 7 and a carry node is appended for the tens digit.
```

**Example 3:**
```
Input: score1 = [1,8,6], score2 = [4,5]
Output: [5,3,7]
Explanation: 681 + 54 = 735.
```$$
WHERE slug = $$add-score-lists$$;

-- add-without-plus
UPDATE problems SET
    description = $$An old handheld game only exposes bitwise ops (AND, OR, XOR, NOT, shifts) on its two kill-counter registers. Add them without using `+` or `-`.

Given two integers `firstCount` and `secondCount`, implement `combineCounters` to return their sum using only bitwise operations. XOR produces the carry-less sum, and AND plus a left shift produces the carries, so loop until the carry is zero.

**Example 1:**
```
Input: firstCount = 12, secondCount = 9
Output: 21
```

**Example 2:**
```
Input: firstCount = -15, secondCount = 4
Output: -11
```$$
WHERE slug = $$add-without-plus$$;

-- balance-print-queue
UPDATE problems SET
    description = $$A print queue is a string where `(` opens a batch, `)` closes one, and `*` is a flexible slot that can act as `(`, `)`, or be dropped.

Given the queue string `tags`, return `true` if some assignment of the flexible slots makes every opener match a later closer.

**Example 1:**
```
Input: tags = "((*)"
Output: true
Explanation: Treating the flexible slot as ')' yields "(())", which is balanced.
```

**Example 2:**
```
Input: tags = "())"
Output: false
Explanation: A closing tag has no opener to match, and there's no flexible slot to fix it.
```$$
WHERE slug = $$balance-print-queue$$;

-- balanced-hamster-tree
UPDATE problems SET
    description = $$A pet-shop family tree of hamsters is stored as a binary tree. Check whether the tree is balanced.

Given the `root`, return `true` if for every node the heights of its left and right subtrees differ by at most one. An empty tree counts as balanced.

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
Explanation: The tree leans all the way left into 1->2->3->4; the root's left subtree has height 3 while its right has height 0.
```

**Example 3:**
```
Input: root = []
Output: true
Explanation: An empty family is balanced by default.
```$$
WHERE slug = $$balanced-hamster-tree$$;

-- barista-throughput-share
UPDATE problems SET
    description = $$A cafe has baristas in a row, and `rates[i]` is how many drinks barista `i` makes per cycle. Each barista's **share** is the product of every other barista's rate.

Given `rates`, return an array `shares` of the same length where `shares[i]` equals the product of `rates[j]` for all `j != i`. Any prefix or suffix product of `rates` fits in a signed 32-bit integer. Solve without division and in linear time.

**Example 1:**
```
Input: rates = [2,3,5,4]
Output: [60,40,24,30]
Explanation: For barista 0: 3*5*4 = 60. For barista 1: 2*5*4 = 40. And so on.
```

**Example 2:**
```
Input: rates = [-2,1,0,4,-1]
Output: [0,0,8,0,0]
Explanation: Every share except index 2 multiplies through the zero at barista 2. The share for barista 2 is (-2)*1*4*(-1) = 8.
```$$
WHERE slug = $$barista-throughput-share$$;

-- battery-drain-power
UPDATE problems SET
    description = $$Your phone battery drains by a factor `base` each hour. Compute `base` raised to the `step`-th power to find how much remains after `step` hours.

A negative `step` means `1 / base^|step|` (for example, `2.0^-3 = 0.125`). Return the result rounded to 5 decimal places. `|step|` can be very large, so a plain loop will time out.

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
```$$
WHERE slug = $$battery-drain-power$$;

-- battery-window-tally
UPDATE problems SET
    description = $$The array `readings` logs hourly battery swings: positive when the phone gained charge, negative when it drained, zero when it held steady. Count how many contiguous stretches sum to exactly `k`.

Given `readings` and integer `k`, implement `countWindowTallies` to return the number of contiguous subarrays whose values sum to `k`. Readings may be negative, so a plain sliding window will not work.

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
```$$
WHERE slug = $$battery-window-tally$$;

-- best-balloon-pop-order
UPDATE problems SET
    description = $$A row of balloons has numbers on them, given in `balloons`. Pop them one at a time in any order to maximize your total points.

Popping balloon `i` earns `balloons[i - 1] * balloons[i] * balloons[i + 1]` points, where the neighbors are whatever balloons are still next to `i` at that moment. Treat a missing neighbor (off the end, or already popped) as `1`. Return the maximum total points after popping all of them.

**Example 1:**
```
Input: balloons = [2,4,1,6]
Output: 90
Explanation: One good order pops 1, then 4, then 2, then 6: 4*1*6 + 2*4*6 + 1*2*6 + 1*6*1 = 24 + 48 + 12 + 6 = 90.
```

**Example 2:**
```
Input: balloons = [3,5]
Output: 20
Explanation: Pop 3 first (1*3*5 = 15), then 5 (1*5*1 = 5). Total = 20.
```$$
WHERE slug = $$best-balloon-pop-order$$;

-- best-boba-streak
UPDATE problems SET
    description = $$The array `traffic` logs hourly foot traffic at a boba shop: positives are customers arriving, negatives are walkouts, zero means the door was closed. Return the largest **product** of any contiguous non-empty slice.

The product of any subarray fits in a signed 32-bit integer.

**Example 1:**
```
Input: traffic = [3,-1,4,-2,5]
Output: 120
Explanation: The whole slice [3,-1,4,-2,5] multiplies to 120, the best you can get.
```

**Example 2:**
```
Input: traffic = [-3,0,2,-4]
Output: 2
Explanation: Any slice crossing the zero collapses to 0, so the best non-crossing pick is [2].
```$$
WHERE slug = $$best-boba-streak$$;

-- best-skill-tree-path
UPDATE problems SET
    description = $$A co-op party's skill tree is a binary tree whose nodes hold scores that can be positive or negative. Find the best contiguous chain to spec into.

A **branch** is a sequence of nodes connected by edges with no repeats, and it does not have to include the root. Given the `root`, return the largest sum of scores along any non-empty branch.

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
Explanation: The best branch is 13 -> 25 -> 9, totaling 13 + 25 + 9 = 47. Including the root drags things down because of the -8.
```$$
WHERE slug = $$best-skill-tree-path$$;

-- best-skin-flip-day
UPDATE problems SET
    description = $$You're flipping a rare skin on a game marketplace where the price changes daily. Each day you can buy one copy (only if you hold none), sell the one you hold, or do nothing. After any sale, you must sit out the next day before buying again.

Given `tierPrices` where `tierPrices[i]` is the price on day `i`, return the maximum total profit.

**Example 1:**
```
Input: tierPrices = [3,8,5,1,6]
Output: 10
Explanation: Buy day 0 at 3, sell day 1 at 8 (profit 5). Day 2 is the forced cooldown. Buy day 3 at 1, sell day 4 at 6 (profit 5). Total 10.
```

**Example 2:**
```
Input: tierPrices = [9,2,5]
Output: 3
Explanation: Skip the 9, buy day 1 at 2, sell day 2 at 5 for a profit of 3.
```$$
WHERE slug = $$best-skin-flip-day$$;

-- biggest-banner-span
UPDATE problems SET
    description = $$You're hanging a single rectangular banner across a contiguous run of lockers. The array `lockers` gives each locker's height, and the banner's height is capped by the shortest locker in the run it covers.

Return the largest area (height times number of lockers) the banner can cover.

**Example 1:**
```
Input: lockers = [3,1,4,5,2,3]
Output: 8
Explanation: The banner covering lockers 2 and 3 uses height 4 and width 2 for area 8.
```

**Example 2:**
```
Input: lockers = [4,2,6,3,7,5,3]
Output: 15
Explanation: The banner covering indices 2 through 6 uses height 3 and width 5 for area 15.
```$$
WHERE slug = $$biggest-banner-span$$;

-- biggest-clear-floor
UPDATE problems SET
    description = $$The classroom floor is a grid of tiles. `"1"` means clear carpet; `"0"` means a desk is in the way. Given `floor`, return the area of the largest axis-aligned square made entirely of `"1"` tiles. If no tile is clear, return `0`.

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
```$$
WHERE slug = $$biggest-clear-floor$$;

-- biggest-locker-poster
UPDATE problems SET
    description = $$Locker `i` in the hallway stands `lockers[i]` tall. Pick two lockers to tape a rectangular poster between: its height is the shorter of the two lockers, and its width is the distance between their indices.

Given `lockers` of length `n`, return the largest possible poster area.

**Example 1:**
```
Input: lockers = [2,6,4,1,5,3,6,2,8]
Output: 42
Explanation: Lockers at index 1 (height 6) and index 8 (height 8) frame a poster of width 7 and height 6, giving 42.
```

**Example 2:**
```
Input: lockers = [2,3]
Output: 2
```$$
WHERE slug = $$biggest-locker-poster$$;

-- brawler-lane-collision
UPDATE problems SET
    description = $$A row of fighters moves along a single lane at the same time. The array `fighters` gives each one's signed power: magnitude is strength, sign is direction (positive moves right, negative moves left).

Same-direction fighters never meet. When opposite-direction fighters collide, the weaker is knocked out; if they tie, both are knocked out.

Return the fighters still standing after all collisions, in original left-to-right order.

**Example 1:**
```
Input: fighters = [3,7,-8]
Output: [-8]
Explanation: -8 knocks out 7, then knocks out 3, leaving only -8.
```

**Example 2:**
```
Input: fighters = [-3,4,-4,2]
Output: [-3,2]
Explanation: 4 and -4 cancel out; -3 and 2 never meet an opposite.
```$$
WHERE slug = $$brawler-lane-collision$$;

-- bump-takeout-number
UPDATE problems SET
    description = $$A take-out box's number is stored as an array of decimal digits, with `digits[0]` the most significant. Add one to the number and return the resulting digit array, carrying as needed (so `9,9` becomes `1,0,0`).

The input has no leading zeros, except when the number is `0` (written `[0]`).

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
```$$
WHERE slug = $$bump-takeout-number$$;

-- cafe-price-ratios
UPDATE problems SET
    description = $$Your cafe has a list of known price ratios: `ratios[i] = [Ai, Bi]` with `values[i]` means one `Ai` costs `values[i]` times one `Bi`.

For each `queries[i] = [Ci, Di]`, return `Ci / Di` as implied by the ratios. If the two drinks cannot be connected — or either one never appears in `ratios` — return `-1.0`.

Note: if `A / B = k` is known, then `B / A = 1 / k`, and `A / A = 1.0` for any drink that appears at least once.

**Example 1:**
```
Input: ratios = [["milk","bread"],["bread","eggs"]], values = [4.0,2.0], queries = [["milk","eggs"],["eggs","bread"],["bread","milk"],["milk","milk"],["soap","milk"]]
Output: [8.00000,0.50000,0.25000,1.00000,-1.00000]
Explanation: milk/eggs = (milk/bread) * (bread/eggs) = 4.0 * 2.0 = 8.0; eggs/bread = 1/2.0 = 0.5; bread/milk = 1/4.0 = 0.25; milk/milk = 1.0; soap never appears so its query is -1.0.
```

**Example 2:**
```
Input: ratios = [["apple","pear"],["pear","plum"],["kiwi","lime"]], values = [3.0,4.0,2.0], queries = [["apple","plum"],["plum","apple"],["kiwi","lime"],["apple","kiwi"]]
Output: [12.00000,0.08333,2.00000,-1.00000]
Explanation: Apple and plum link through pear, giving 3.0 * 4.0 = 12.0 and the reciprocal. Kiwi and lime form a separate component, so kiwi/lime is known but apple/kiwi is not.
```$$
WHERE slug = $$cafe-price-ratios$$;

-- cafe-stop-orders
UPDATE problems SET
    description = $$`stops` is a list of distinct cafe IDs you plan to visit once each. Implement `listStationOrders` to return every possible ordering of `stops`. The outer list may be in any order.

**Example 1:**
```
Input: stops = [4,7,2]
Output: [[4,7,2],[4,2,7],[7,4,2],[7,2,4],[2,4,7],[2,7,4]]
Explanation: Three distinct cafes give 3! = 6 possible visit orders.
```

**Example 2:**
```
Input: stops = [5,9]
Output: [[5,9],[9,5]]
```$$
WHERE slug = $$cafe-stop-orders$$;

-- calm-phone-number
UPDATE problems SET
    description = $$Given a positive integer `reading`, repeatedly replace it with the sum of the squares of its digits. Call it **calm** if this process eventually reaches `1`, and **not calm** if it loops forever.

Return `true` if `reading` is calm, `false` otherwise.

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
```$$
WHERE slug = $$calm-phone-number$$;

-- can-attend-bookings
UPDATE problems SET
    description = $$A cafe has one window table. `bookings` lists reservations as `[start, end]` minutes after opening.

Return `true` if no two bookings overlap, and `false` otherwise. A booking that ends exactly when the next one starts does not count as overlap.

**Example 1:**
```
Input: bookings = [[18,20],[19,21],[22,23]]
Output: false
Explanation: [18,20] and [19,21] both cover minute 19, so two parties collide.
```

**Example 2:**
```
Input: bookings = [[18,20],[20,22],[22,23]]
Output: true
Explanation: Each booking ends right when the next starts, so the table turns cleanly.
```

**Example 3:**
```
Input: bookings = [[45,90],[30,60]]
Output: false
```$$
WHERE slug = $$can-attend-bookings$$;

-- capture-enclosed-tiles
UPDATE problems SET
    description = $$You're playing a territory game on a grid. `'X'` is your tile and `'O'` is an enemy tile. An enemy region survives if any of its cells can reach the border by moving up, down, left, or right through other `'O'` cells; otherwise it is captured.

Modify `board` **in place**: flip every surrounded `'O'` to `'X'` and leave border-connected `'O'` cells alone. Return the modified board.

**Example 1:**
```
Input: board = [["X","X","X","X"],["X","O","X","X"],["X","X","O","X"],["X","X","X","O"]]
Output: [["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","X","X","O"]]
Explanation: The `'O'` at (1,1) and (2,2) are boxed in, so they flip. The `'O'` at (3,3) sits on the border and survives.
```

**Example 2:**
```
Input: board = [["O","X"],["O","X"]]
Output: [["O","X"],["O","X"]]
Explanation: Both `'O'` cells are on the first column, already touching the edge, so nothing changes.
```$$
WHERE slug = $$capture-enclosed-tiles$$;

-- chat-log-codec
UPDATE problems SET
    description = $$Design a codec for a co-op game's chat log. The sender has a list of messages and can only hand the receiver a single string, which must later unpack into the same list.

Implement the `ListCoder` class with two methods:

- `String pack(List<String> messages)` — encodes the list into one string. Messages may contain any characters, including any marker you choose, so a plain join on a reserved character won't work.
- `List<String> unpack(String blob)` — decodes a string produced by `pack` back into the original list with the same order, length, and contents, including empty messages.

The codec must be stateless: `unpack` uses only the string `pack` emitted. A round trip must reproduce the input exactly, even when the list is empty, contains empty messages, or contains messages made entirely of marker-like characters.$$
WHERE slug = $$chat-log-codec$$;

-- chat-ring-buffer
UPDATE problems SET
    description = $$A party chat keeps only the most recent messages in a fixed-size circular buffer. Implement `FixedRing` to manage it.

- `FixedRing(int k)` — creates an empty ring with capacity `k`.
- `boolean push(int value)` — inserts `value` at the rear. Returns `true` on success, `false` if full.
- `boolean pull()` — removes the front message. Returns `true` on success, `false` if empty.
- `int front()` — returns the front message without removing it, or `-1` if empty.
- `int rear()` — returns the rear message without removing it, or `-1` if empty.
- `boolean isEmpty()` — returns `true` when the ring holds no messages.
- `boolean isFull()` — returns `true` when all `k` slots are filled.

**Example:**
```
ring = new FixedRing(3)
ring.push(1); ring.push(2); ring.push(3)   // all succeed
ring.push(4)                               // false, ring full
ring.rear()                                // 3
ring.pull()                                // true, drops 1
ring.push(4)                               // true, wraps around
ring.rear()                                // 4
```$$
WHERE slug = $$chat-ring-buffer$$;

-- cheapest-courier-route
UPDATE problems SET
    description = $$A delivery tool routes orders between `n` cafes labeled `0..n-1` over one-way courier links. Each `links[i] = [from, to, minutes]` is a leg from cafe `from` to cafe `to` costing `minutes` minutes.

Given a source `src`, destination `dst`, and an upper bound `maxHops` on the number of intermediate cafes allowed, return the **minimum total minutes** to deliver from `src` to `dst`. Return `-1` if no route fits within `maxHops` intermediate cafes.

**Example 1:**
```
Input: n = 5, links = [[0,1,50],[1,2,40],[0,2,200],[2,3,30],[3,4,20],[1,3,150]], src = 0, dst = 4, maxHops = 2
Output: 220
Explanation: The chain 0 -> 1 -> 3 -> 4 (cost 50 + 150 + 20 = 220) uses 2 intermediate cafes. The cheaper chain 0 -> 1 -> 2 -> 3 -> 4 would need 3 intermediates and is rejected.
```

**Example 2:**
```
Input: n = 4, links = [[0,1,80],[1,2,40],[0,2,300],[2,3,90],[0,3,400]], src = 0, dst = 3, maxHops = 0
Output: 400
Explanation: With maxHops = 0 only the direct link 0 -> 3 at 400 minutes qualifies, even though 0 -> 1 -> 2 -> 3 would total 210.
```$$
WHERE slug = $$cheapest-courier-route$$;

-- check-interleaved-inputs
UPDATE problems SET
    description = $$In a rhythm game, two controllers each produce a fixed sequence of button letters, and the screen logs a merged sequence of every press. The merge is valid only if it's a true interleave: every press appears once, and each controller's original order is preserved.

Given strings `controllerA`, `controllerB`, and `merged`, return `true` if `merged` is a valid interleave of `controllerA` and `controllerB`, otherwise `false`.

**Example 1:**
```
Input: controllerA = "cat", controllerB = "dog", merged = "cdoagt"
Output: true
Explanation: Pull c from A, then d and o from B, then a from A, then g from B, then t from A. Both controller orders are preserved.
```

**Example 2:**
```
Input: controllerA = "abc", controllerB = "xyz", merged = "axbzyc"
Output: false
Explanation: After a then x, the next press from B would have to be y, but the merged stream shows z before y, violating B's order.
```$$
WHERE slug = $$check-interleaved-inputs$$;

-- click-tally-window
UPDATE problems SET
    description = $$Track how often a button gets clicked. Build `ClickTally` to record click timestamps and report how many clicks happened in the last five minutes (inclusive on both ends).

- `ClickTally()` — creates an empty tally.
- `void record(int timestamp)` — logs one click at second `timestamp`. Multiple clicks can share a second.
- `int countSince(int timestamp)` — returns the number of clicks in `[timestamp - 299, timestamp]`.

Calls arrive in non-decreasing timestamp order.

**Example 1:**
```
Input: ["ClickTally","record","record","record","countSince","record","countSince","countSince"] / [[],[1],[2],[3],[4],[300],[300],[301]]
Output: [null,null,null,null,3,null,4,3]
```
At second 4, the clicks at 1, 2, and 3 are all inside the window. At second 300 the click at 1 still counts, so four clicks show up. One tick later it slips out and the count drops to three.

**Example 2:**
```
Input: ["ClickTally","record","record","record","countSince"] / [[],[100],[100],[100],[100]]
Output: [null,null,null,null,3]
```
Three clicks in the same second all count.

**Example 3:**
```
Input: ["ClickTally","countSince","record","countSince"] / [[],[1],[2],[300]]
Output: [null,0,null,1]
```
Querying before any click arrives returns zero; the later click still falls in the window at second 300.$$
WHERE slug = $$click-tally-window$$;

-- clone-quest-log
UPDATE problems SET
    description = $$A guild's quest log is a linked list of missions. Each node has a `next` pointer to the following mission and a `related` pointer to some other mission in the log (or `null`).

Given the head of a log with `n` nodes, return the head of a deep copy. The copy must contain exactly `n` new nodes, and every `next` and `related` pointer in the copy must reference nodes in the copy only.

The stdin input is an array of pairs `[val, related_index]`, where `related_index` is the 0-based index of the mission the `related` pointer targets, or `null`.

**Example 1:**
```
Input: head = [[9,2],[4,null],[6,0],[2,1]]
Output: [[9,2],[4,null],[6,0],[2,1]]
Explanation: Four missions are cloned; each related pointer is rewired to the matching copy.
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
```$$
WHERE slug = $$clone-quest-log$$;

-- compare-loadout-bits
UPDATE problems SET
    description = $$Two teammates have loadout bitmasks where each bit represents one perk. Count how many perk slots they disagree on.

Given non-negative integers `leftFlags` and `rightFlags`, return the number of bit positions where the two values differ.

**Example 1:**
```
Input: leftFlags = 10, rightFlags = 5
Output: 4
Explanation: 10 is 1010 and 5 is 0101; all four low bits disagree.
```

**Example 2:**
```
Input: leftFlags = 14, rightFlags = 9
Output: 3
Explanation: 14 is 1110 and 9 is 1001; positions 0, 1, and 2 disagree.
```$$
WHERE slug = $$compare-loadout-bits$$;

-- connect-water-bowls
UPDATE problems SET
    description = $$Water bowls for neighborhood cats sit at known grid coordinates, and you want to connect them with the least total hose. You are given `bowls`, where `bowls[i] = [xi, yi]` is bowl `i`'s location. The hose between bowls `i` and `j` runs along the grid and costs `|xi - xj| + |yi - yj|` meters.

Return the minimum total hose length that makes every bowl reachable from every other bowl, possibly through intermediate bowls.

**Example 1:**
```
Input: bowls = [[4,4],[4,3],[6,7],[10,2]]
Output: 13
Explanation: Laying hoses [4,4]-[4,3] (length 1), [4,4]-[6,7] (length 5), and [4,3]-[10,2] (length 7) connects every bowl for a total of 13 meters.
```

**Example 2:**
```
Input: bowls = [[0,0],[2,0]]
Output: 2
Explanation: Only one hose of length 2 is needed to join the two bowls.
```$$
WHERE slug = $$connect-water-bowls$$;

-- count-cipher-decodings
UPDATE problems SET
    description = $$In a retro cipher game, letters `A..Z` map to the ids `1..26`. You're given a digit string `scan` to decode. A group starting with `0` is invalid, since no card has an id like `05`.

Return the number of distinct ways to split `scan` left-to-right into valid ids from `1..26`. The answer fits in a 32-bit signed integer.

**Example 1:**
```
Input: scan = "1234"
Output: 3
Explanation: Valid splits: (1,2,3,4), (12,3,4), (1,23,4). "1234" as one id is too big, and "12,34" fails because 34 > 26.
```

**Example 2:**
```
Input: scan = "100"
Output: 0
Explanation: The second digit is 0, so it can't start an id, and the trailing 0 has no valid id either.
```$$
WHERE slug = $$count-cipher-decodings$$;

-- count-coupon-ways
UPDATE problems SET
    description = $$The cafe gave you store-credit coupons in fixed denominations, and you want to spend exactly `amount` won. Given `amount` and `coupons`, return the number of distinct combinations that sum to `amount`. Each coupon value may be reused any number of times, and order does not matter. Return `0` if no combination works.

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
```$$
WHERE slug = $$count-coupon-ways$$;

-- count-desk-clusters
UPDATE problems SET
    description = $$A classroom seating chart is an `m x n` grid `board` where `"1"` marks an occupied desk and `"0"` marks an empty one. A **cluster** is a maximal group of occupied desks connected 4-directionally (up, down, left, right). Diagonals do not count.

Return the number of clusters. Treat anything outside the grid as empty.

**Example 1:**
```
Input: board = [["0","1","1","0","0","1"],["1","1","0","0","0","1"],["0","0","0","1","0","0"],["1","0","0","1","1","0"],["1","0","0","0","0","1"]]
Output: 5
Explanation: Five 4-connected clusters — the top-left L, the right column pair, the center patch near (2,3), the left pair at (3,0)/(4,0), and the lone desk at (4,5).
```

**Example 2:**
```
Input: board = [["1","1","0","0"],["0","1","0","1"],["0","0","0","1"]]
Output: 2
Explanation: One cluster in the upper-left, and a two-desk column on the right edge.
```$$
WHERE slug = $$count-desk-clusters$$;

-- count-doodle-palindromes
UPDATE problems SET
    description = $$You're doodling letters into a string `code`. A **mirror span** is any contiguous substring of `code` that reads the same forwards and backwards. Every single letter also counts.

Implement `countMirrorSpans(code)` to return how many mirror spans `code` contains. The same text at different positions counts separately.

**Example 1:**
```
Input: code = "klmn"
Output: 4
Explanation: No two neighboring letters match, so only the 4 single letters qualify.
```

**Example 2:**
```
Input: code = "rrrr"
Output: 10
Explanation: Every contiguous chunk of the run is a mirror span. Length 4 gives 4 + 3 + 2 + 1 = 10.
```$$
WHERE slug = $$count-doodle-palindromes$$;

-- count-dungeon-paths
UPDATE problems SET
    description = $$A tile-based dungeon has `rows` rows and `cols` columns. Your character starts at the top-left tile, the treasure is at the bottom-right, and each move steps one tile down or one tile right.

Implement `countGateRoutes` to return the number of distinct paths from start to treasure.

**Example 1:**
```
Input: rows = 4, cols = 5
Output: 35
Explanation: Every path uses exactly 3 down-steps and 4 right-steps in some order, so the count is the number of ways to arrange those 7 moves.
```

**Example 2:**
```
Input: rows = 2, cols = 6
Output: 6
Explanation: With a single down-step required, the path is fully determined by which of the 6 columns that down-step happens in.
```$$
WHERE slug = $$count-dungeon-paths$$;

-- count-flag-bits
UPDATE problems SET
    description = $$In a retro game, each level from `0` to `upperId` has a completion bitmask, and you want to know how many achievements (set bits) each level awards.

Given a non-negative integer `upperId`, return an array `flagCounts` of length `upperId + 1` where `flagCounts[i]` is the number of set bits in the binary representation of `i`.

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
```$$
WHERE slug = $$count-flag-bits$$;

-- count-hint-matches
UPDATE problems SET
    description = $$Given lecture `notes` and a short hint `target`, count how many times `target` appears in `notes` as a subsequence. A subsequence picks letters from `notes` in order, skipping any you like. Different choices of positions count separately, even if the kept letters look the same.

Implement `countFilterMatches` to return the total count. The answer fits in a 64-bit signed integer.

**Example 1:**
```
Input: notes = "ggrrg", target = "grg"
Output: 4
Explanation: Each match picks a g, then a later r, then a later g. Among the g positions (0, 1, 4) and r positions (2, 3), the valid (i, j, k) triples are (0,2,4), (0,3,4), (1,2,4), (1,3,4).
```

**Example 2:**
```
Input: notes = "uvuvu", target = "uu"
Output: 3
Explanation: The u positions are 0, 2, and 4, and choosing any ordered pair gives a match: (0,2), (0,4), (2,4).
```$$
WHERE slug = $$count-hint-matches$$;

-- count-level-hops
UPDATE problems SET
    description = $$In a platformer, your character starts at level `0` and wants to reach level `n`. Each jump moves forward either 1 or 2 levels.

Implement `countReservoirPaths(n)` to return the number of distinct jump sequences that land exactly on level `n`.

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
Explanation: There are 8 distinct 1/2 hop sequences that sum to 5.
```$$
WHERE slug = $$count-level-hops$$;

-- count-longest-cookie-runs
UPDATE problems SET
    description = $$An array `scores` lists browning ratings for cookies in the order they came off the tray. Find the length of the longest strictly increasing subsequence of `scores`, then return how many distinct subsequences reach that length. (Order is fixed; you may skip entries but not reorder them.)

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
```$$
WHERE slug = $$count-longest-cookie-runs$$;

-- count-square-candy-bags
UPDATE problems SET
    description = $$A candy store sells bags only in perfect-square sizes: 1, 4, 9, 16, 25, and so on, and you can buy any size as many times as you want. Implement `countExactTargets(pages)` to return the minimum number of bags whose sizes sum to exactly `pages`.

**Example 1:**
```
Input: pages = 7
Output: 4
Explanation: One size-4 bag plus three size-1 bags totals 7. No combo of 1, 2, or 3 square-sized bags hits 7.
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
```$$
WHERE slug = $$count-square-candy-bags$$;

-- count-task-orderings
UPDATE problems SET
    description = $$A group project has `n` sub-tasks numbered `0` through `n - 1`. Every task except task `0` has one prerequisite that must finish first, so the dependencies form a tree with `parent[0] = -1` at the root.

Only one person works at a time, so tasks are done one by one. Return the number of valid finish orders for all `n` tasks, modulo `10^8 + 7`.

**Example 1:**
```
Input: parent = [-1,0,0,2,2]
Output: 8
Explanation: Task 0 goes first. Below it, task 1 is a leaf and tasks 3, 4 hang off task 2. Interleaving the two branches yields 8 distinct orders.
```

**Example 2:**
```
Input: parent = [-1,0,1,2,3]
Output: 1
Explanation: The chain 0 -> 1 -> 2 -> 3 -> 4 has only one valid order.
```

**Example 3:**
```
Input: parent = [-1,0,0,0,0]
Output: 24
Explanation: After task 0, the four children can go in any order, giving 4! = 24 sequences.
```$$
WHERE slug = $$count-task-orderings$$;

-- count-top-heroes
UPDATE problems SET
    description = $$In a dungeon-crawler party tree, each node stores a hero's damage number. A hero is **dominant** if no hero on the path from the root down to them has a strictly higher number. The root always counts as dominant.

Given the `root` of the party tree, implement `tallyDominantBlocks(root)` to return the number of dominant heroes.

**Example 1:**
```
Input: root = [4,2,6,5,1,null,7]
Output: 4
Explanation: Hero 4 (root) is dominant. 5 beats its max ancestor 4. 6 beats its max ancestor 4. 7 beats its max ancestor 6. Hero 2 is overshadowed by 4, and hero 1 is overshadowed by 4.
```

**Example 2:**
```
Input: root = [5,3,5,2,4]
Output: 2
Explanation: The root 5 is dominant. The right child 5 ties with its ancestor 5 and still counts. The left subtree heroes (3, 2, 4) are all overshadowed by the root.
```

**Example 3:**
```
Input: root = [7]
Output: 1
Explanation: A single hero is always dominant.
```$$
WHERE slug = $$count-top-heroes$$;

-- count-voice-parties
UPDATE problems SET
    description = $$A co-op game has `n` players labelled `0` to `n - 1`. Each entry `relays[i] = [a, b]` means players `a` and `b` can hear each other directly. Two players are in the same party if a chain of relays connects them.

Implement `tallyDeviceMeshes(n, relays)` to return the number of separate parties. A player with no relays counts as their own party.

**Example 1:**
```
Input: n = 6, relays = [[0,1],[2,3],[3,4]]
Output: 3
Explanation: Players `{0,1}` share a relay, `{2,3,4}` are chained, and player `5` is alone — three parties total.
```

**Example 2:**
```
Input: n = 7, relays = [[0,1],[1,2],[2,3],[3,4],[4,5],[5,6]]
Output: 1
Explanation: Every player is reachable from every other through the relay chain, so one big party.
```$$
WHERE slug = $$count-voice-parties$$;

-- cover-aquarium-zones
UPDATE problems SET
    description = $$Each fish species feeds within a 1D stretch `[start, end]` (inclusive). A pellet dropped at position `x` feeds every species whose zone covers `x`.

Given a list `zones` of these stretches, return the minimum number of pellets needed so every species gets fed at least once.

**Example 1:**
```
Input: zones = [[5,11],[3,9],[8,14],[12,18],[20,25]]
Output: 3
Explanation: Pellets at 9, 18, and 25 work. Position 9 feeds [3,9], [5,11], and [8,14]; 18 feeds [12,18]; 25 feeds [20,25].
```

**Example 2:**
```
Input: zones = [[1,5],[6,10],[11,15]]
Output: 3
Explanation: No two zones overlap, so each needs its own pellet.
```$$
WHERE slug = $$cover-aquarium-zones$$;

-- crush-heaviest-blocks
UPDATE problems SET
    description = $$An arcade machine repeatedly slams the two heaviest blocks together. If they weigh `x` and `y` with `x <= y`:

- If `x == y`, both blocks are pulverized.
- If `x != y`, the lighter block is destroyed and the heavier one becomes `y - x`.

Repeat until at most one block remains. Given the array `blocks`, return the weight of the last surviving block, or `0` if the pile is empty.

**Example 1:**
```
Input: blocks = [3,6,4,9,5,2]
Output: 1
Explanation:
Crush 9 and 6 -> 3; pile becomes [3,4,5,2,3].
Crush 5 and 4 -> 1; pile becomes [3,2,3,1].
Crush 3 and 3 -> both destroyed; pile becomes [2,1].
Crush 2 and 1 -> 1; pile becomes [1].
```

**Example 2:**
```
Input: blocks = [9]
Output: 9
```$$
WHERE slug = $$crush-heaviest-blocks$$;

-- days-until-warmer
UPDATE problems SET
    description = $$Your weather widget logs daily high temperatures in the array `readings`, indexed by day. For each day, find how many days you must wait for a **strictly warmer** reading.

Return an array `wait` of the same length where `wait[i]` is the number of days after day `i` until a strictly warmer reading. If no later day is warmer, set `wait[i]` to `0`.

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
Explanation: Each of the first three days must wait for day 3 (50), the next strictly warmer reading.
```$$
WHERE slug = $$days-until-warmer$$;

-- decode-roman-floor
UPDATE problems SET
    description = $$A retro RPG labels dungeon floors with Roman numerals. Convert a floor tag into its integer value.

Symbol values:

- `I` = 1, `V` = 5, `X` = 10, `L` = 50, `C` = 100, `D` = 500, `M` = 1000

Symbols read largest-to-smallest left-to-right. When a smaller symbol sits directly before a larger one, the pair subtracts (so `IV` = 4 and `IX` = 9). The valid subtractive pairs are `IV`, `IX`, `XL`, `XC`, `CD`, `CM`.

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
```$$
WHERE slug = $$decode-roman-floor$$;

-- dedupe-textbook-shelf
UPDATE problems SET
    description = $$A sorted integer array `books` represents textbooks on a classroom shelf, with duplicates grouped together. Move the unique values to the front in their original order, and return `k`, the number of unique values. Positions from index `k` onward aren't checked.

**Example 1:**
```
Input: books = [2,2,5]
Output: 2, books = [2,5,_]
Explanation: Return k = 2. The front reads 2 then 5.
```

**Example 2:**
```
Input: books = [1,1,2,2,3,4,4,6,6,6]
Output: 5, books = [1,2,3,4,6,_,_,_,_,_]
Explanation: Five distinct values sit at the front in order.
```

**Example 3:**
```
Input: books = [8]
Output: 1, books = [8]
Explanation: A single-copy shelf is already compact.
```$$
WHERE slug = $$dedupe-textbook-shelf$$;

-- deepest-skill-chain
UPDATE problems SET
    description = $$An RPG skill tree rooted at `root` branches outward as perks unlock deeper skills. Return the **maximum depth** of the tree — the number of nodes on the longest path from `root` down to any leaf. An empty tree has depth `0`.

**Example 1:**
```
Input: root = [8,5,12,null,null,9,17]
Output: 3
Explanation: The longest chain runs three perks deep: 8 -> 12 -> 9 or 8 -> 12 -> 17.
```

**Example 2:**
```
Input: root = [4,null,2,null,7]
Output: 3
Explanation: The chain 4 -> 2 -> 7 is three perks deep.
```$$
WHERE slug = $$deepest-skill-chain$$;

-- desk-notes-overlap
UPDATE problems SET
    description = $$You and your desk-mate each wrote class notes as a string of single-letter subject codes. Find the length of the longest stretch of letters that appears in both strings in the same order (extra letters between them are allowed).

A **subsequence** is obtained by deleting any letters without reordering. Given note strings `left` and `right`, return the length of the longest common subsequence, or `0` if nothing matches.

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
Explanation: One longest common subsequence is "can": positions 1-3-4 of left and 0-1-2 of right.
```$$
WHERE slug = $$desk-notes-overlap$$;

-- detect-portal-loop
UPDATE problems SET
    description = $$In an RPG dungeon, each room's `next` pointer teleports you to another room. Some chains loop back to an earlier room forever.

Implement `detectTransferLoop(head, pos)` to return `true` if following `next` pointers from `head` ever revisits a room, and `false` otherwise. `pos` is the 0-based index the tail links to (`-1` means no loop); it is used only to build the test input and is **not** used by the function.

**Example 1:**
```
Input: head = [8,5,2,6,9], pos = 2
Output: true
Explanation: The tail's next pointer loops back to the room at index 2.
```

**Example 2:**
```
Input: head = [4,7,3], pos = 0
Output: true
Explanation: The last room teleports to the head, forming a full loop.
```

**Example 3:**
```
Input: head = [6,2], pos = -1
Output: false
Explanation: The chain ends cleanly; there's no loop.
```$$
WHERE slug = $$detect-portal-loop$$;

-- dog-street-walk
UPDATE problems SET
    description = $$Your dog wants to walk every street in the neighborhood exactly once, starting from home (zone `"HUB"`). You're given `routes`, a list of one-way segments `[from, to]`.

Return a walk that starts at `"HUB"` and uses every segment exactly once. If multiple walks work, return the one that is lexicographically smallest compared zone-by-zone. A valid walk is guaranteed to exist.

**Example 1:**
```
Input: routes = [["ELM","HUB"],["HUB","BIR"],["BIR","ELM"],["HUB","CED"]]
Output: ["HUB","BIR","ELM","HUB","CED"]
Explanation: HUB -> BIR -> ELM -> HUB -> CED uses all four segments. Going to CED first would strand the dog before BIR and ELM.
```

**Example 2:**
```
Input: routes = [["HUB","NOR"],["HUB","SOU"],["NOR","SOU"],["SOU","HUB"],["SOU","NOR"]]
Output: ["HUB","NOR","SOU","HUB","SOU","NOR"]
Explanation: Taking NOR before SOU from the hub gives the lex-smallest walk that still finishes every segment.
```$$
WHERE slug = $$dog-street-walk$$;

-- drop-conflicting-classes
UPDATE problems SET
    description = $$You're picking classes for next semester but can only attend one at a time. Each class in `classes` is `[start, end]` in minutes. Two classes conflict only if their windows overlap — touching at the boundary (one ends when the next starts) is fine.

Return the **minimum** number of classes to drop so the rest have no overlap.

**Example 1:**
```
Input: classes = [[1,3],[2,4],[3,5],[1,5]]
Output: 2
Explanation: Keep [1,3] and [3,5]; drop [2,4] and [1,5] to clear every overlap.
```

**Example 2:**
```
Input: classes = [[5,6],[5,6]]
Output: 1
Explanation: Two classes in the same slot — one has to go.
```

**Example 3:**
```
Input: classes = [[1,2],[2,3]]
Output: 0
Explanation: They touch but don't overlap, so you can take both.
```$$
WHERE slug = $$drop-conflicting-classes$$;

-- drop-nth-reservation
UPDATE problems SET
    description = $$A cafe stores today's reservations as a linked list in booking order. Given the `head` of the list and an integer `n`, remove the `n`-th reservation counted from the end and return the updated head.

**Example 1:**
```
Input: head = [10,20,30,40,50,60], n = 3
Output: [10,20,30,50,60]
Explanation: Counting from the end, booking 40 is 3rd; after removing it the list is 10 -> 20 -> 30 -> 50 -> 60.
```

**Example 2:**
```
Input: head = [7], n = 1
Output: []
Explanation: The only booking is cancelled, so the schedule is empty.
```

**Example 3:**
```
Input: head = [4,9], n = 2
Output: [9]
Explanation: The 2nd from the end is the very first booking, so it gets dropped.
```$$
WHERE slug = $$drop-nth-reservation$$;

-- dual-waterbowl-flow
UPDATE problems SET
    description = $$A hamster's sloped playpen is an `m x n` grid where `field[r][c]` is a tile's height. One water bowl sits along the top-left edges (top row and left column); another sits along the bottom-right edges (bottom row and right column). Water flows from a tile to any 4-directional neighbor whose height is **less than or equal to** its own. Edge tiles drain into the adjacent bowl.

Return every coordinate `[r, c]` whose water can reach **both** bowls. Order doesn't matter.

**Example 1:**
```
Input: field = [[2,1,3,4,5],[3,2,3,5,6],[4,3,5,4,3],[5,6,4,3,2],[6,5,3,2,1]]
Output: [[0,4],[1,3],[1,4],[2,2],[3,1],[4,0]]
Explanation: Tile (2,2) sits on the ridge — water can step down-left to the top-left bowl and down-right to the bottom-right one.
```

**Example 2:**
```
Input: field = [[2,4,6],[5,7,9],[8,10,12]]
Output: [[0,2],[1,2],[2,0],[2,1],[2,2]]
Explanation: The heights rise monotonically toward the bottom-right, so only the right column and bottom row drain into both bowls.
```$$
WHERE slug = $$dual-waterbowl-flow$$;

-- eval-postfix-tape
UPDATE problems SET
    description = $$Evaluate a postfix expression from the math teacher's board. The tape `baleTape` is an array of tokens; each token is a signed integer or one of `+`, `-`, `*`, `/`. Each operator pops the top two numbers off the stack, combines them, and pushes the result.

Division truncates toward zero. The tape is a valid postfix program that leaves exactly one number on the stack, with no division by zero. Return that integer.

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
```$$
WHERE slug = $$eval-postfix-tape$$;

-- fewest-candy-bags
UPDATE problems SET
    description = $$You're packing candy for movie night. The pantry has several bag sizes, each holding an exact number of pieces, and you can grab unlimited bags of any size. Hand out exactly `quota` pieces using the fewest bags.

Implement `fewestBagSizes(bagSizes, quota)` to return the minimum number of bags whose sizes sum to `quota`, or `-1` if no combination works.

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
```$$
WHERE slug = $$fewest-candy-bags$$;

-- fewest-tile-jumps
UPDATE problems SET
    description = $$You're on a platformer with `n` tiles numbered `0` through `n - 1`, starting on tile `0`. The array `fuel` gives the max forward jump from each tile: from tile `i` you can land on any tile in `[i + 1, i + fuel[i]]`.

Implement `minVanHops(fuel)` to return the fewest jumps needed to reach tile `n - 1`. The level is always beatable.

**Example 1:**
```
Input: fuel = [1,4,2,1,3,1,2]
Output: 3
Explanation: Jump from tile 0 to tile 1. From tile 1 you can reach tile 5, so jump to tile 4. From tile 4 you can reach tile 6, the goal.
```

**Example 2:**
```
Input: fuel = [3,1,1,4,2,1]
Output: 2
Explanation: Jump from tile 0 straight to tile 3 (within reach 3). From tile 3 you can reach tile 7, which covers tile 5.
```$$
WHERE slug = $$fewest-tile-jumps$$;

-- find-battery-peak
UPDATE problems SET
    description = $$Your phone's afternoon battery log is `readings`, and you want to find a moment where the level briefly peaked. A **peak reading** is strictly greater than both neighbors; treat positions just outside the array as `-infinity`, so edge readings only need to beat their one neighbor.

Return the index of any peak. If several exist, any one works. The log is huge, so your solution must run in `O(log n)` time.

**Example 1:**
```
Input: readings = [11,18,22,19,15]
Output: 2
Explanation: readings[2] = 22 beats both neighbors (18 and 19).
```

**Example 2:**
```
Input: readings = [3,7,12,25,20,14,9]
Output: 3
Explanation: readings[3] = 25 beats readings[2] = 12 and readings[4] = 20.
```$$
WHERE slug = $$find-battery-peak$$;

-- find-empty-locker
UPDATE problems SET
    description = $$The gym teacher hands out lockers numbered `0, 1, 2, ..., n` and tells you which `n` of them are already claimed. Exactly one number from `[0, n]` is missing — that's yours.

Given the list `lockers` of claimed numbers, return the missing one. The answer exists and is unique.

**Example 1:**
```
Input: lockers = [4,2,0,1]
Output: 3
Explanation: The list has length 4, so the full range is [0..4]. Only 3 is missing.
```

**Example 2:**
```
Input: lockers = [5,3,1,0,2]
Output: 4
Explanation: The full range is [0..5]; 4 isn't on the list.
```$$
WHERE slug = $$find-empty-locker$$;

-- find-hidden-words
UPDATE problems SET
    description = $$You're playing a word-search game on an `m x n` letter `board` with a list of `targetWords`. A word is found if its letters trace a path of horizontally or vertically adjacent cells that never reuses the same cell.

Return every word from `targetWords` that can be traced on the board, sorted in lexicographic order. Each matching word appears at most once in the result.

**Example 1:**
```
Input: board = [["c","o","d","e"],["h","a","t","s"],["i","r","n","m"],["p","u","a","l"]], targetWords = ["code","chat","maze","nail"]
Output: ["chat","code"]
```

**Example 2:**
```
Input: board = [["p","a"],["g","c"]], targetWords = ["pcg"]
Output: []
```$$
WHERE slug = $$find-hidden-words$$;

-- find-locker-number
UPDATE problems SET
    description = $$A sorted list `shelf` holds unique locker numbers. Find the 0-indexed position of `query` in `shelf`, or return `-1` if it isn't there.

Run in `O(log n)` time.

**Example 1:**
```
Input: shelf = [102,145,201,247,318,402,510,633], query = 318
Output: 4
Explanation: Locker 318 sits at position 4 in the row.
```

**Example 2:**
```
Input: shelf = [102,145,201,247,318,402,510,633], query = 200
Output: -1
Explanation: No locker 200 exists in the list.
```$$
WHERE slug = $$find-locker-number$$;

-- find-menu-calorie
UPDATE problems SET
    description = $$A cafe's calorie chart is an `m x n` grid `menu`. Each row is sorted left-to-right ascending, and each column is sorted top-to-bottom ascending. Rows may overlap: the first value of a row can be smaller than the last value of the row above.

Return `true` if any cell equals `target`, otherwise `false`.

**Example 1:**
```
Input: menu = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 14
Output: true
```

**Example 2:**
```
Input: menu = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 24
Output: false
```

**Example 3:**
```
Input: menu = [[-4,-1],[3,5]], target = -1
Output: true
Explanation: -1 sits in the first row, second column.
```$$
WHERE slug = $$find-menu-calorie$$;

-- find-menu-price
UPDATE problems SET
    description = $$A cafe menu is an `m x n` grid `menu`. Each row is sorted left-to-right ascending, and the first price of each row is larger than the last price of the row above — so reading row by row gives one sorted list.

Return `true` if any cell equals `target`, otherwise `false`. Run in `O(log(m * n))` time.

**Example 1:**
```
Input: menu = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 22
Output: true
Explanation: Row 1, column 2 holds the value 22.
```

**Example 2:**
```
Input: menu = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 9
Output: false
Explanation: No cell shows a price of 9.
```$$
WHERE slug = $$find-menu-price$$;

-- find-name-anagram
UPDATE problems SET
    description = $$Given a note `log` and a name `pattern`, return `true` if some permutation of `pattern` appears as a contiguous substring of `log`, otherwise `false`.

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
```$$
WHERE slug = $$find-name-anagram$$;

-- find-rotated-low-score
UPDATE problems SET
    description = $$A leaderboard of distinct scores was sorted ascending, then rotated between `1` and `n` times. Given the rotated array `scores`, return the smallest value.

Run in `O(log n)` time.

**Example 1:**
```
Input: scores = [7,9,12,2,5]
Output: 2
Explanation: The sorted list was [2,5,7,9,12] rotated 3 times, so 2 is the smallest.
```

**Example 2:**
```
Input: scores = [15,20,24,31,3,8,12]
Output: 3
```

**Example 3:**
```
Input: scores = [21,33,45,58]
Output: 21
Explanation: No rotation was applied, so the first entry is the smallest.
```$$
WHERE slug = $$find-rotated-low-score$$;

-- find-submap
UPDATE problems SET
    description = $$A study group's mind map is a tree. Given the main map `root` and a reference sub-map `subRoot`, return `true` if some node in `root` has a subtree that matches `subRoot` exactly in both shape and values, otherwise `false`. The entire `root` tree counts as one of its own subtrees.

**Example 1:**
```
Input: root = [9,6,7,2,4], subRoot = [6,2,4]
Output: true
Explanation: The left child of root is 6, and its subtree [6,2,4] matches subRoot exactly.
```

**Example 2:**
```
Input: root = [1,8,3,null,5], subRoot = [8,5]
Output: false
Explanation: Node 8 appears in root, but its child 5 hangs on the right, while subRoot has 5 on the left, so the shapes don't line up.
```$$
WHERE slug = $$find-submap$$;

-- finish-the-level
UPDATE problems SET
    description = $$You're on tile `0` of a platformer level with `n` tiles. `slack[i]` is the max jump length from tile `i`; a `0` means tile `i` is a pit.

Implement `canFinishLine(slack)` to return `true` if you can reach tile `n - 1`, otherwise `false`.

**Example 1:**
```
Input: slack = [2,1,3,1,1,2]
Output: true
Explanation: Route 0 -> 2 (jump 2), 2 -> 5 (jump 3). Tile 5 is the final tile.
```

**Example 2:**
```
Input: slack = [2,0,0,1,3]
Output: false
Explanation: From tile 0 you can only reach tiles 1 or 2, both pits. Tile 3 is unreachable.
```$$
WHERE slug = $$finish-the-level$$;

-- flatten-agenda-tree
UPDATE problems SET
    description = $$A meeting agenda is stored as a binary tree rooted at `root`. Flatten it in place into a right-pointing chain in **preorder**: every node's `left` must be `null`, and its `right` must point to the next node in preorder.

The root stays the same and the return type is `void`; the grader walks right pointers from the root.

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
```$$
WHERE slug = $$flatten-agenda-tree$$;

-- flip-chunks-of-k
UPDATE problems SET
    description = $$Given a linked list of power-ups, reverse each consecutive run of `k` nodes in place. Leave any trailing run shorter than `k` alone.

Return the new head. Only rewire `next` pointers — do not mutate node values.

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
Explanation: With k = 1 each run is a single node, so the list is unchanged.
```$$
WHERE slug = $$flip-chunks-of-k$$;

-- flip-phone-codes
UPDATE problems SET
    description = $$On an old flip phone, each digit maps to several letters:

- `2`: `abc`
- `3`: `def`
- `4`: `ghi`
- `5`: `jkl`
- `6`: `mno`
- `7`: `pqrs`
- `8`: `tuv`
- `9`: `wxyz`

Given a string `digits` containing only `2`-`9`, implement `mapKeypadCodes` to return every letter combination the digits could spell. Any order is fine. Return an empty list if `digits` is empty.

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
```$$
WHERE slug = $$flip-phone-codes$$;

-- four-tray-sum
UPDATE problems SET
    description = $$After a bake sale, each tray in `trays` has a signed count (positive = extras, negative = short). Find every group of four trays whose counts sum to `demand`.

Given `trays` and `demand`, return all **unique quadruplets** `[trays[a], trays[b], trays[c], trays[d]]` with four distinct indices that sum to `demand`. No duplicate quadruplets; any order is fine.

**Example 1:**
```
Input: trays = [1,-1,2,-2,3,-3], demand = 0
Output: [[-3,-2,2,3],[-3,-1,1,3],[-2,-1,1,2]]
Explanation: Three different foursomes of trays cancel out to zero.
```

**Example 2:**
```
Input: trays = [3,3,3,3,3], demand = 12
Output: [[3,3,3,3]]
Explanation: Every tray has 3 extras, and any four of them bundle to 12.
```$$
WHERE slug = $$four-tray-sum$$;

-- grocery-bag-triple
UPDATE problems SET
    description = $$Each grocery bag has three readings `[produce, dairy, frozen]`. A bag is usable only if none of its readings exceed `target` on any channel. Pick a subset of usable bags whose channel-wise max equals `target` exactly.

Write `canBuildBales(bags, target)` that returns `true` if such a subset exists, else `false`.

**Example 1:**
```
Input: bags = [[3,2,1],[1,6,4],[3,1,7],[2,5,2]], target = [3,6,7]
Output: true
Explanation: Stack [3,2,1], [1,6,4], and [3,1,7]. The per-channel maxima are [3,6,7].
```

**Example 2:**
```
Input: bags = [[2,3,4],[4,2,1]], target = [2,3,5]
Output: false
Explanation: The second bag overshoots channel 0 (4 > 2) so it's out. The first alone gives [2,3,4], and nothing can lift channel 2 to 5.
```$$
WHERE slug = $$grocery-bag-triple$$;

-- group-car-packs
UPDATE problems SET
    description = $$Cars drive down a one-lane road toward a toll booth at kilometer `target`. Car `i` starts at `position[i]` with cruising speed `speed[i]`. Faster cars can't overtake — when one catches up, it matches the slower pace. A **pack** is any group of cars traveling together.

Return the number of packs that reach the toll booth.

**Example 1:**
```
Input: target = 20, position = [0,3,7,14], speed = [5,3,2,1]
Output: 2
Explanation: The car at km 14 reaches alone (6h). The cars at km 7, 3, and 0 all catch up to the km-7 car before the booth, forming one pack. Two packs total.
```

**Example 2:**
```
Input: target = 15, position = [5], speed = [2]
Output: 1
```$$
WHERE slug = $$group-car-packs$$;

-- group-drink-labels
UPDATE problems SET
    description = $$Given an array `labels` of lowercase strings, group the ones that are anagrams of each other.

Implement `clusterBarrels` so each inner list is sorted lexicographically and the outer list is sorted lexicographically by each group's first label.

**Example 1:**
```
Input: labels = ["oakvanilla","vanillaoak","plum","lump","berrytannin","tanninberry","oak"]
Output: [["berrytannin","tanninberry"],["lump","plum"],["oak"],["oakvanilla","vanillaoak"]]
```

**Example 2:**
```
Input: labels = ["merlot"]
Output: [["merlot"]]
```$$
WHERE slug = $$group-drink-labels$$;

-- group-study-cards
UPDATE problems SET
    description = $$A study group wants to deal flashcards into groups of `groupSize` consecutive numbers (like `{7,8,9}` when `groupSize = 3`). Every card must go in exactly one group.

Given the integer array `cards` and the integer `groupSize`, return `true` if the pile can be split this way, else `false`.

**Example 1:**
```
Input: cards = [2,3,4,5,6,7], groupSize = 3
Output: true
Explanation: Deal the cards as [2,3,4] then [5,6,7].
```

**Example 2:**
```
Input: cards = [1,2,3,5], groupSize = 2
Output: false
Explanation: After [1,2], the leftover cards 3 and 5 aren't consecutive.
```$$
WHERE slug = $$group-study-cards$$;

-- group-tree-by-level
UPDATE problems SET
    description = $$An RPG guild is stored as a binary tree, with the guildmaster at the root. Print each rank as its own row, top rank first.

Given the `root` of the guild tree, implement `groupByTier` to return values level by level, each inner list ordered left to right. Return an empty list if the tree is empty.

**Example 1:**
```
Input: root = [10,5,15,null,null,12,20]
Output: [[10],[5,15],[12,20]]
Explanation: Rank 0 has 10. Rank 1 has 5 and 15. Rank 2 has 12 and 20.
```

**Example 2:**
```
Input: root = [42]
Output: [[42]]
Explanation: A lone guildmaster makes a single row.
```

**Example 3:**
```
Input: root = []
Output: []
```$$
WHERE slug = $$group-tree-by-level$$;

-- guild-chat-relay
UPDATE problems SET
    description = $$A guild has `n` players labeled `1` through `n`. The list `links` holds one-way relays: `links[i] = [source, target, minutes]` means a ping goes from `source` to `target` after `minutes`. Each player retransmits the moment they first receive the message.

Given the starting player `src`, return the **minimum minutes** until every player has seen the message, or `-1` if some player is unreachable.

**Example 1:**
```
Input: links = [[1,2,4],[1,3,2],[3,2,1],[2,4,3],[3,4,7]], n = 4, src = 1
Output: 6
Explanation: Player 3 gets it at minute 2, player 2 at minute 3 (via 1 -> 3 -> 2), player 4 at minute 6 (via 1 -> 3 -> 2 -> 4).
```

**Example 2:**
```
Input: links = [[1,2,5]], n = 3, src = 1
Output: -1
Explanation: No relay reaches player 3, so the broadcast never completes.
```$$
WHERE slug = $$guild-chat-relay$$;

-- interleave-clip-chain
UPDATE problems SET
    description = $$A montage of game clips is a linked chain from earliest to latest. Rearrange it in place so early and late clips interleave.

Given `head`, reorder the nodes to `S0 -> Sn -> S1 -> Sn-1 -> S2 -> Sn-2 -> ...`. Only rewire `next` pointers — don't change any node values.

**Example 1:**
```
Input: head = [10,20,30,40,50,60]
Output: [10,60,20,50,30,40]
Explanation: Early and late clips are woven together: 10, 60, 20, 50, and so on.
```

**Example 2:**
```
Input: head = [1,3,5,7,9,11,13]
Output: [1,13,3,11,5,9,7]
Explanation: With an odd length the middle clip lands at the end.
```$$
WHERE slug = $$interleave-clip-chain$$;

-- kth-top-score-stream
UPDATE problems SET
    description = $$A guild posts raid scores one at a time. Track the `k`-th highest score as each new score arrives. Duplicates keep their own rank, so the `k`-th largest is the value at position `k` in the sorted list.

Build `TopKStream`:

- `TopKStream(int k, int[] scores)` seeds the tracker with rank `k` and a starting batch of raid scores.
- `int record(int val)` adds `val` to the stream and returns the current `k`-th largest score overall.

**Example 1:**
```
Input:
["TopKStream", "record", "record", "record", "record", "record"]
[[3, [4, 5, 8, 2]], [3], [5], [10], [9], [4]]
Output: [null, 4, 5, 5, 8, 8]

Explanation:
TopKStream tracker = new TopKStream(3, [4, 5, 8, 2]);
tracker.record(3);   // stream becomes [4,5,8,2,3]; 3rd largest is 4
tracker.record(5);   // stream becomes [4,5,8,2,3,5]; 3rd largest is 5
tracker.record(10);  // stream becomes [4,5,8,2,3,5,10]; 3rd largest is 5
tracker.record(9);   // stream becomes [4,5,8,2,3,5,10,9]; 3rd largest is 8
tracker.record(4);   // stream becomes [4,5,8,2,3,5,10,9,4]; 3rd largest is 8
```

The leaderboard refreshes constantly, so re-sorting everything on each post won't keep up.$$
WHERE slug = $$kth-top-score-stream$$;

-- link-guild-siblings
UPDATE problems SET
    description = $$A guild chart is a **perfect binary tree**: every non-leaf member has two recruits, and all leaves sit at the same tier. Each node has a `next` pointer.

```
class Node {
    int val;
    Node left;
    Node right;
    Node next;
}
```

Implement `wireSiblingHubs` so each member's `next` points to the member immediately to its right on the same tier, or stays `null` if it's the rightmost on that tier. Return the updated `root`.

**Example 1:**
```
Input: root = [10,20,30,40,50,60,70]
Output: [10,#,20,30,#,40,50,60,70,#]
Explanation: Three tiers in the tree.
- Tier 0: 10 -> null
- Tier 1: 20 -> 30 -> null
- Tier 2: 40 -> 50 -> 60 -> 70 -> null
The # marks the end of each tier's chain.
```

**Example 2:**
```
Input: root = [9]
Output: [9,#]
Explanation: A lone member has no right neighbor.
```

**Example 3:**
```
Input: root = [5,6,7]
Output: [5,#,6,7,#]
```$$
WHERE slug = $$link-guild-siblings$$;

-- list-bracket-pairings
UPDATE problems SET
    description = $$Given an integer `pairCount`, return every well-formed string built from `pairCount` pairs of brackets. A string is well-formed when every `(` is later closed by a `)` and no `)` appears before its match.

Any order is fine — the grader sorts before comparing.

**Example 1:**
```
Input: pairCount = 2
Output: ["(())","()()"]
Explanation: The two valid bracket layouts using two pairs.
```

**Example 2:**
```
Input: pairCount = 4
Output: ["(((())))","((()()))","((())())","((()))()","(()(()))","(()()())","(()())()","(())(())","(())()()","()((()))","()(()())","()(())()","()()(())","()()()()"]
```$$
WHERE slug = $$list-bracket-pairings$$;

-- list-skill-build-paths
UPDATE problems SET
    description = $$You have an RPG skill tree rooted at `root` where each node holds an XP value. Return every root-to-leaf path whose node values sum to exactly `target`.

Each path is the list of node values top-down. A **leaf** is a node with no children. List paths in the order a left-first DFS finds them.

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
```$$
WHERE slug = $$list-skill-build-paths$$;

-- list-trail-mix-combos
UPDATE problems SET
    description = $$Given an array `barrels` of distinct bin IDs, return every subset — from the empty scoop up to all bins.

The outer list can be in any order, but each inner combo must keep the relative order from `barrels`.

**Example 1:**
```
Input: barrels = [2,5,8]
Output: [[],[2],[2,5],[2,5,8],[2,8],[5],[5,8],[8]]
Explanation: With 3 bins there are 2^3 = 8 combos.
```

**Example 2:**
```
Input: barrels = [7]
Output: [[],[7]]
```$$
WHERE slug = $$list-trail-mix-combos$$;

-- lonely-candy
UPDATE problems SET
    description = $$You dumped a bag of candies on the table. Every flavor shows up twice except one loner — find it.

Given `frames` where every value appears exactly twice except for one that appears once, return that single value. Use O(n) time and O(1) extra space.

**Example 1:**
```
Input: frames = [5,5,3]
Output: 3
Explanation: 5 appears twice; 3 only once.
```

**Example 2:**
```
Input: frames = [8,2,6,2,6]
Output: 8
Explanation: 2 and 6 each appear twice. 8 is the loner.
```$$
WHERE slug = $$lonely-candy$$;

-- longest-combo-run
UPDATE problems SET
    description = $$A rhythm game records your button hits as an uppercase string `code`. You may overwrite up to `k` characters with any letter.

Return the length of the longest contiguous substring that can be made of a single letter after at most `k` overwrites.

**Example 1:**
```
Input: code = "PQPQ", k = 2
Output: 4
Explanation: Overwrite both P's to Q to get "QQQQ", a run of length 4.
```

**Example 2:**
```
Input: code = "XXYXYYX", k = 1
Output: 4
Explanation: Overwrite the Y at index 2 to X to get the run "XXXX" from indices 0..3.
```$$
WHERE slug = $$longest-combo-run$$;

-- longest-doodle-palindrome
UPDATE problems SET
    description = $$Given a word `word` doodled in a notebook, find the longest contiguous substring that reads the same forwards and backwards.

Implement `buildMirrorLength(word)` to return its length. Every single character counts as a palindrome of length 1.

**Example 1:**
```
Input: word = "levelled"
Output: 5
Explanation: The slice "level" is a palindrome of length 5, and nothing longer mirrors itself.
```

**Example 2:**
```
Input: word = "barrel"
Output: 2
Explanation: The slice "rr" is a palindrome of length 2, and no longer mirror exists.
```$$
WHERE slug = $$longest-doodle-palindrome$$;

-- longest-folder-path
UPDATE problems SET
    description = $$A school's folder tree is rooted at `root`. Return the longest path between any two nodes, measured as the number of **edges** on that path.

The path may pivot at an interior folder or run straight down a single branch. It does not have to pass through `root`.

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
```$$
WHERE slug = $$longest-folder-path$$;

-- longest-genre-window
UPDATE problems SET
    description = $$Your Netflix queue is the string `feed`, where each character is a genre tag. Return the length of the longest contiguous substring whose characters are all distinct.

**Example 1:**
```
Input: feed = "finance"
Output: 4
Explanation: The substring "ance" has four distinct characters; no longer run is unique.
```

**Example 2:**
```
Input: feed = "zzzz"
Output: 1
Explanation: Every tag is the same, so only length-one runs are distinct.
```

**Example 3:**
```
Input: feed = "xxxyz"
Output: 3
Explanation: The tail "xyz" has three distinct characters.
```$$
WHERE slug = $$longest-genre-window$$;

-- longest-level-up-path
UPDATE problems SET
    description = $$A puzzle game board is an `m x n` grid `scores`. Starting from any tile, you may step to an adjacent tile (up, down, left, or right) only if its score is **strictly higher**.

Implement `longestVineAscent` to return the length of the longest strictly increasing path through `scores`.

**Example 1:**
```
Input: scores = [[2,5,8],[3,4,7],[1,6,9]]
Output: 5
Explanation: Starting from the 1 in the bottom-left, 1 -> 3 -> 4 -> 7 -> 9 visits 5 tiles, each higher than the last.
```

**Example 2:**
```
Input: scores = [[4,2,1],[5,6,3]]
Output: 5
Explanation: The combo 1 -> 2 -> 4 -> 5 -> 6 threads through five adjacent tiles with strictly increasing scores.
```$$
WHERE slug = $$longest-level-up-path$$;

-- longest-quiz-streak
UPDATE problems SET
    description = $$Given your weekly quiz scores in the order you took them as the integer array `scores`, return the length of the longest strictly increasing **subsequence**. You may skip quizzes, but the timeline order must be preserved, and consecutive picks must satisfy `scores[i] < scores[j]`.

**Example 1:**
```
Input: scores = [4,10,2,6,3,5,8,11]
Output: 5
Explanation: The subsequence [2,3,5,8,11] (from indices 2,4,5,6,7) is strictly increasing and has length 5.
```

**Example 2:**
```
Input: scores = [9,2,7,4,6,8]
Output: 4
Explanation: The subsequence [2,4,6,8] has length 4; no strictly increasing subsequence of length 5 exists.
```$$
WHERE slug = $$longest-quiz-streak$$;

-- longest-seat-run
UPDATE problems SET
    description = $$The array `seatIds` lists free lobby slot numbers in any order. Return the length of the **longest run of consecutive integers** that can be formed from `seatIds`.

Ignore duplicates. Your solution must run in O(n) time.

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
```$$
WHERE slug = $$longest-seat-run$$;

-- longest-unique-treats
UPDATE problems SET
    description = $$The array `treats[i]` is the flavor code of the `i`-th piece on a buffet line. Return the length of the longest contiguous stretch of `treats` that contains **at most two distinct flavors**.

**Example 1:**
```
Input: treats = [4,4,7,4,7,2,7,2,2]
Output: 5
Explanation: The stretch [7,2,7,2,2] at the end uses only flavors 7 and 2 and has length 5. The opening stretch [4,4,7,4,7] also has length 5 using flavors 4 and 7.
```

**Example 2:**
```
Input: treats = [9,9,9]
Output: 3
Explanation: Every piece shares one flavor, so the entire run is clean.
```

**Example 3:**
```
Input: treats = [1,5,1,5,1,5]
Output: 6
Explanation: The whole row alternates between only two flavors, so the longest clean run spans everything.
```$$
WHERE slug = $$longest-unique-treats$$;

-- low-score-stack
UPDATE problems SET
    description = $$Design a stack for speedrun attempt scores that also reports the lowest score currently on the stack. All operations must run in `O(1)`.

Implement `LowTrackStack`:

- `LowTrackStack()` starts with an empty stack.
- `void push(int val)` adds attempt score `val` on top.
- `void pop()` removes the top score.
- `int top()` returns the top score without removing it.
- `int getMin()` returns the smallest score currently on the stack.

`pop`, `top`, and `getMin` are only called when at least one score has been pushed.

**Example 1:**
```
Input:
["LowTrackStack","push","push","push","getMin","pop","top","getMin"]
[[],[12],[6],[-2],[],[],[],[]]
Output: [null,null,null,null,-2,null,6,6]
```
Three scores (12, 6, -2) are pushed. `getMin` returns `-2`. After a pop the stack is `[12, 6]`; `top` returns `6` and `getMin` returns `6` since the previous minimum is gone.$$
WHERE slug = $$low-score-stack$$;

-- majority-boss-vote
UPDATE problems SET
    description = $$The array `votes` has `n` entries, and one choice received strictly more than half the votes. Return that id — the value that appears more than `n / 2` times.

A dominant choice is guaranteed to exist.

**Example 1:**
```
Input: votes = [4,7,4]
Output: 4
```

**Example 2:**
```
Input: votes = [5,5,6,6,6,5,6]
Output: 6
Explanation: 6 shows up 4 times out of 7, which is more than half.
```

**Example 3:**
```
Input: votes = [9]
Output: 9
```$$
WHERE slug = $$majority-boss-vote$$;

-- menu-combos-tab
UPDATE problems SET
    description = $$The array `pastries` lists cafe pastry prices (values may repeat). Find every distinct combo of pastries that sums to exactly `tab`. Each pastry on the shelf can be used at most once per combo, and two combos with the same multiset of prices count as one.

Implement `listQuotaBatches` to return every unique multiset. Order does not matter.

**Example 1:**
```
Input: pastries = [2,3,6,1,3,4], tab = 7
Output: [[1,2,4],[1,3,3],[1,6],[3,4]]
```

**Example 2:**
```
Input: pastries = [4,2,1,2,3], tab = 5
Output: [[1,2,2],[1,4],[2,3]]
```

**Example 3:**
```
Input: pastries = [8,8,8], tab = 16
Output: [[8,8]]
Explanation: 8 appears three times, but only a pair of 8s adds to 16.
```$$
WHERE slug = $$menu-combos-tab$$;

-- merge-cafe-queues
UPDATE problems SET
    description = $$You're given `k` sorted linked-list heads in `queues`, each ordered by pickup time. Merge them into one sorted list by re-linking the existing nodes, and return the head.

**Example 1:**
```
Input: queues = [[2,5,8],[1,3,7],[4,6]]
Output: [1,2,3,4,5,6,7,8]
Explanation: Three pre-sorted queues weave into one.
```

**Example 2:**
```
Input: queues = []
Output: []
Explanation: No queues, nothing to merge.
```

**Example 3:**
```
Input: queues = [[]]
Output: []
Explanation: One empty queue merges to empty.
```$$
WHERE slug = $$merge-cafe-queues$$;

-- merge-duplicate-contacts
UPDATE problems SET
    description = $$A shared office contacts list has duplicates. Each entry starts with a name followed by that person's emails. Two entries belong to the same person if they share at least one email (transitively). Note that two different people can still share a name.

Implement `unifyContactIdentities(accounts)`. Merge entries that share any email, and return each merged entry as the name followed by that person's unique emails **sorted lexicographically**. The returned entries can be in any order.

**Example 1:**
```
Input: accounts = [["Maya","maya.dp@set.film","mayalens@set.film"],["Maya","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]
Output: [["Maya","maya.dp@set.film","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]
Explanation: The first two Maya entries share `mayalens@set.film` and collapse into one. The third Maya shares nothing and stays separate.
```

**Example 2:**
```
Input: accounts = [["Ash","ash1@set.film","ash2@set.film"],["Bea","bea1@set.film","bea2@set.film"],["Cal","cal1@set.film","cal2@set.film"]]
Output: [["Ash","ash1@set.film","ash2@set.film"],["Bea","bea1@set.film","bea2@set.film"],["Cal","cal1@set.film","cal2@set.film"]]
Explanation: No shared emails, so every entry stays as-is with its emails sorted.
```$$
WHERE slug = $$merge-duplicate-contacts$$;

-- merge-leaderboard-runs
UPDATE problems SET
    description = $$Two linked lists of run times, `runA` and `runB`, are each sorted non-decreasingly. Implement `combineOvenRotations(runA, runB)` to splice the existing nodes into one sorted list and return its head.

**Example 1:**
```
Input: runA = [2,5,9], runB = [3,4,7]
Output: [2,3,4,5,7,9]
Explanation: The times interleave into one sorted leaderboard.
```

**Example 2:**
```
Input: runA = [], runB = []
Output: []
Explanation: Neither friend has a run recorded.
```

**Example 3:**
```
Input: runA = [], runB = [3]
Output: [3]
Explanation: Only the second friend has a time.
```$$
WHERE slug = $$merge-leaderboard-runs$$;

-- merge-reservation-slots
UPDATE problems SET
    description = $$You're given brunch seatings as `[start, end]` pairs in `seatings`, where `seatings[i] = [start_i, end_i]`. Merge any two that overlap — touching at a single endpoint counts as overlap — and return the shortest list of non-overlapping windows that still covers every original seating, sorted by start time.

**Example 1:**
```
Input: seatings = [[2,5],[4,7],[9,11],[14,16]]
Output: [[2,7],[9,11],[14,16]]
Explanation: [2,5] and [4,7] share minutes 4 and 5, so they merge into [2,7]. The other two stay separate.
```

**Example 2:**
```
Input: seatings = [[1,3],[3,8],[10,12]]
Output: [[1,8],[10,12]]
Explanation: [1,3] and [3,8] touch at minute 3, which still counts as overlap, so they fuse into [1,8].
```$$
WHERE slug = $$merge-reservation-slots$$;

-- merged-price-median
UPDATE problems SET
    description = $$Two baristas each kept a sorted list of today's drink prices: `zonesA` and `zonesB`. Return the median of the merged list — the middle value, or the average of the two middles when the total count is even.

Your solution must run in `O(log(m + n))` time, where `m = zonesA.length` and `n = zonesB.length`.

**Example 1:**
```
Input: zonesA = [2,5], zonesB = [4]
Output: 4.0
Explanation: The merged list is [2,4,5]; the middle value is 4.
```

**Example 2:**
```
Input: zonesA = [3,8], zonesB = [5,11]
Output: 6.5
Explanation: The merged list is [3,5,8,11]; the median is (5 + 8) / 2 = 6.5.
```

**Example 3:**
```
Input: zonesA = [], zonesB = [12]
Output: 12.0
Explanation: Only one value, so the median is that value.
```$$
WHERE slug = $$merged-price-median$$;

-- micro-feed
UPDATE problems SET
    description = $$Build a `MicroFeed` class for a gaming hangout board where players post short status updates, follow each other, and read a newest-first feed.

- `MicroFeed()` — starts an empty board.
- `publishPost(int userId, int messageId)` — player `userId` posts snippet `messageId`. Each `messageId` is globally unique and arrives in post order.
- `List<Integer> latestFeed(int userId)` — returns up to the 10 most recent message IDs from `userId` and the players they follow, newest first.
- `subscribe(int followerId, int followeeId)` — `followerId` follows `followeeId`. No-op if the IDs match.
- `unsubscribe(int followerId, int followeeId)` — `followerId` unfollows `followeeId`. No-op if the IDs match or the follow isn't active.

**Example 1:**
```
Input: ["MicroFeed","publishPost","publishPost","latestFeed"]
       [[],[1,10],[1,20],[1]]
Output: [null,null,null,[20,10]]
```
Player 1 posts twice and sees them newest-first.

**Example 2:**
```
Input: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed"]
       [[],[1,10],[2,20],[1,2],[1]]
Output: [null,null,null,null,[20,10]]
```
Once player 1 follows player 2, player 2's post shows up.

**Example 3:**
```
Input: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed","unsubscribe","latestFeed"]
       [[],[1,10],[2,20],[1,2],[1],[1,2],[1]]
Output: [null,null,null,null,[20,10],null,[10]]
```
Unfollowing immediately drops player 2's post from player 1's feed.$$
WHERE slug = $$micro-feed$$;

-- min-cheat-code-edits
UPDATE problems SET
    description = $$You're retyping a lowercase cheat code to match a new version from your game wiki. Each keystroke inserts a letter, deletes a letter, or replaces one letter with another.

Given `source` and `target`, return the fewest keystrokes needed to turn `source` into `target`.

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
Explanation: Delete the trailing 't' (sunset -> sunse), insert 'r' after the 'n' (sunse -> sunrse), then insert 'i' after that 'r' (sunrse -> sunrise).
```$$
WHERE slug = $$min-cheat-code-edits$$;

-- min-daily-brew
UPDATE problems SET
    description = $$A cafe must brew every drink in the queue `volumes` within `days` days, in the given left-to-right order. Each day the barista picks one integer capacity; drinks are packed consecutively into the day until adding the next would exceed that capacity, then the day ends.

Return the smallest daily capacity that still ships every drink within `days` days.

**Example 1:**
```
Input: volumes = [2,4,5,7,9,11,13,16,18,20], days = 5
Output: 27
Explanation: Capacity 27 ships in 5 days: [2,4,5,7,9], [11,13], [16], [18], [20].
```

**Example 2:**
```
Input: volumes = [4,3,3,5,2,5], days = 3
Output: 8
Explanation: Capacity 8 ships in 3 days: [4,3], [3,5], [2,5].
```

**Example 3:**
```
Input: volumes = [2,3,4,2,2], days = 4
Output: 4
Explanation: Capacity 4 ships in 4 days: [2], [3], [4], [2,2].
```$$
WHERE slug = $$min-daily-brew$$;

-- min-stamina-checkpoints
UPDATE problems SET
    description = $$A platformer has `n` checkpoints numbered `0` to `n-1`. Landing on checkpoint `i` costs `effort[i]` stamina. You start at checkpoint `0` or `1`, and from any checkpoint you hop one or two tiles forward (paying that checkpoint's cost when you land).

Return the minimum total stamina needed to step past the last checkpoint (position `n`).

**Example 1:**
```
Input: effort = [4,2,8,3,5,6]
Output: 10
Explanation: Start at checkpoint 1 (pay 2), hop to checkpoint 3 (pay 3), then to checkpoint 5 (pay 5) and step off. Total 2 + 3 + 5 = 10.
```

**Example 2:**
```
Input: effort = [7,1,7,1,7]
Output: 2
Explanation: Start at checkpoint 1 (pay 1), hop two to checkpoint 3 (pay 1), then hop two more to finish. Total 2.
```$$
WHERE slug = $$min-stamina-checkpoints$$;

-- min-wait-drive
UPDATE problems SET
    description = $$Your maps app shows the wait (in minutes) at every intersection on a grid. Drive from the top-left to the bottom-right, moving only one block east or one block south at each step.

Given `grid`, return the smallest total wait along any valid route, counting every intersection passed through including both endpoints.

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
```$$
WHERE slug = $$min-wait-drive$$;

-- mirror-menu-tree
UPDATE problems SET
    description = $$A cafe menu is a binary tree of drinks: left child is the chill option, right child is the bold option. Flip the board so left and right swap at every level.

Given the `root` of the menu tree, implement `reflectBlend` to swap each node's left and right children recursively and return the mirrored root.

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
```$$
WHERE slug = $$mirror-menu-tree$$;

-- missing-sock-number
UPDATE problems SET
    description = $$`socks` lists the numbers on a pile of socks in the laundry basket. Return the smallest positive integer missing from the pile. Zeros and negatives are mystery lint — ignore them.

Implement `lowestMissingTarget`. The array is unsorted and may repeat. Aim for O(n) time and O(1) extra space.

**Example 1:**
```
Input: socks = [2,3,1,5]
Output: 4
Explanation: 1, 2, 3 are all there. 4 is the smallest positive number missing.
```

**Example 2:**
```
Input: socks = [6,-2,8,10]
Output: 1
Explanation: No sock numbered 1 appears, so 1 is the first missing one.
```$$
WHERE slug = $$missing-sock-number$$;

-- move-voided-scans
UPDATE problems SET
    description = $$The cafe's point-of-sale stores each order's price in `scans` in the order it was rung up, with voided orders as `0`. Slide every `0` to the end while the real prices keep their original order.

Mutate `scans` **in place** — don't allocate a new array. The driver prints the array after your method returns.

**Example 1:**
```
Input: scans = [4,0,0,2,9,0,7]
Output: [4,2,9,7,0,0,0]
Explanation: The four real prices keep their order, and the three voids slide to the end.
```

**Example 2:**
```
Input: scans = [0,0,5]
Output: [5,0,0]
```$$
WHERE slug = $$move-voided-scans$$;

-- multiply-as-text
UPDATE problems SET
    description = $$Two huge non-negative numbers are given as digit strings `left` and `right` — too long for a normal `int`. Return their product as a decimal string.

Don't cast either input to a numeric type, don't use a big-integer library, and don't call any built-in helper for arbitrary-length multiplication. Simulate long multiplication digit by digit.

**Example 1:**
```
Input: left = "12", right = "34"
Output: "408"
```

**Example 2:**
```
Input: left = "25", right = "13"
Output: "325"
```$$
WHERE slug = $$multiply-as-text$$;

-- nearest-cafe-stops
UPDATE problems SET
    description = $$A barista plans a morning delivery run. Each shop sits at an `[x, y]` coordinate, with the cafe at the origin. Return the `k` shops closest to the cafe.

Distance is Euclidean, `sqrt(x^2 + y^2)`. Return the `k` nearest stops in any order; the answer is unique up to ordering.

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
```$$
WHERE slug = $$nearest-cafe-stops$$;

-- nearest-cat-feeder
UPDATE problems SET
    description = $$An `m x n` grid `grid` represents rooms in your apartment complex. Each cell holds one of:

- `-1` — a **locked room** (cats can't pass through)
- `0` — a **feeder room** (food is here)
- `2147483647` — an **open room** to be measured

For each open room, replace its value with the number of 4-directional steps (up, down, left, right) to the nearest feeder, moving only through open rooms. If no feeder is reachable, leave `2147483647`. Update `grid` in place and return it.

**Example 1:**
```
Input: grid = [[2147483647,0,-1,2147483647],[2147483647,2147483647,2147483647,2147483647],[-1,2147483647,0,2147483647],[2147483647,2147483647,2147483647,-1]]
Output: [[1,0,-1,3],[2,1,1,2],[-1,2,0,1],[3,2,1,-1]]
Explanation: Feeders sit at (0,1) and (2,2). Each open room gets its step count to the closer feeder; (0,3) is three steps from (0,1) because (0,2) is locked.
```

**Example 2:**
```
Input: grid = [[0,2147483647,2147483647],[-1,2147483647,-1],[2147483647,2147483647,0]]
Output: [[0,1,2],[-1,2,-1],[2,1,0]]
Explanation: The locked rooms in the middle row force a detour, but every open room still reaches a feeder.
```$$
WHERE slug = $$nearest-cat-feeder$$;

-- next-speaker-order
UPDATE problems SET
    description = $$The standup lineup is stored as integer ids in `shotOrder`. Each morning it advances to the next lexicographically greater permutation of the same ids. If the current lineup is already the largest permutation, it resets to the smallest.

Implement `advanceShotOrder` to rearrange `shotOrder` **in place** to the next greater permutation, or to the smallest permutation if none exists. Use only constant extra memory.

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
```$$
WHERE slug = $$next-speaker-order$$;

-- nth-lowest-score
UPDATE problems SET
    description = $$Scores are stored in a binary search tree keyed by score, so an in-order walk visits them from lowest to highest.

Given the `root` of the tree and a 1-indexed position `k`, implement `pickNthTarget` to return the `k`-th lowest score. Assume `k` is between `1` and the total number of scores in the tree.

**Example 1:**
```
Input: root = [8,4,12,2,6,10,14], k = 4
Output: 8
Explanation: In-order traversal yields [2,4,6,8,10,12,14]. The 4th entry is 8.
```

**Example 2:**
```
Input: root = [20,10,30,5,15,25,35,null,7], k = 2
Output: 7
Explanation: In-order traversal yields [5,7,10,15,20,25,30,35]. The 2nd entry is 7.
```$$
WHERE slug = $$nth-lowest-score$$;

-- nth-unlockable-level
UPDATE problems SET
    description = $$A level is **unlockable** if all its prime factors come from `{2, 3, 5}`. By convention, `1` is also unlockable. The unlockable levels in order are `1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, ...` (`7` is skipped).

Return the `n`-th unlockable level (1-indexed).

**Example 1:**
```
Input: n = 7
Output: 8
Explanation: The first seven unlockable levels are 1, 2, 3, 4, 5, 6, 8, so the 7th is 8.
```

**Example 2:**
```
Input: n = 12
Output: 16
Explanation: The first twelve unlockable levels are 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, so the 12th is 16.
```$$
WHERE slug = $$nth-unlockable-level$$;

-- online-friend-mask
UPDATE problems SET
    description = $$An integer `sensorMask` packs online teammates as bits — each set bit means a friend is online.

Implement `countActiveSensors(sensorMask)` to return the number of `1` bits in `sensorMask`, treating it as unsigned.

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
Explanation: 256 is 100000000 in binary; only one friend is online.
```$$
WHERE slug = $$online-friend-mask$$;

-- open-all-rooms
UPDATE problems SET
    description = $$There are `n` rooms numbered `0..n-1`. Every room starts locked except room `0`. Each room contains keys that unlock **other** rooms: `rooms[i]` lists the key ids found in room `i`.

Entering a room collects every key inside it, and any collected key can unlock the matching room later. Return `true` if you can visit every room, otherwise `false`.

**Example 1:**
```
Input: rooms = [[2,1],[4],[3],[],[3,0]]
Output: true
Explanation: Start in room 0 and grab keys 2 and 1. Room 1 gives key 4; room 2 gives key 3. Visiting 3 and 4 covers all five rooms.
```

**Example 2:**
```
Input: rooms = [[2],[3],[],[4],[1]]
Output: false
Explanation: Room 0 only yields key 2, and room 2 is empty. The keys for rooms 1, 3, and 4 are trapped inside those rooms.
```$$
WHERE slug = $$open-all-rooms$$;

-- order-group-tasks
UPDATE problems SET
    description = $$There are `numSteps` tasks labelled `0` to `numSteps - 1`. Each `prereqs[i] = [a, b]` means task `b` must finish before task `a` starts.

Return any valid order that completes every task while respecting the prereqs. If a cycle makes this impossible, return an empty array.

**Example 1:**
```
Input: numSteps = 3, prereqs = [[2,0],[1,0]]
Output: [0,1,2]
Explanation: Task 0 has no prereqs so it runs first. Tasks 1 and 2 can then run in any order; [0,1,2] works.
```

**Example 2:**
```
Input: numSteps = 5, prereqs = [[1,0],[2,1],[3,1],[4,2],[4,3]]
Output: [0,1,2,3,4]
Explanation: 0 must come before 1, which must come before 2 and 3, which both must come before 4. [0,1,2,3,4] respects every edge.
```$$
WHERE slug = $$order-group-tasks$$;

-- pair-lunchbox-snacks
UPDATE problems SET
    description = $$You're packing snacks into lunchboxes. Each lunchbox holds **at most two snacks** and cannot exceed `capacity` grams total. Every snack must be packed.

Given `crates` where `crates[i]` is snack `i`'s weight, return the **minimum number of lunchboxes** needed.

**Example 1:**
```
Input: crates = [2,4], capacity = 6
Output: 1
Explanation: Both snacks weigh 6 grams together, which fits one lunchbox.
```

**Example 2:**
```
Input: crates = [4,3,1,2], capacity = 4
Output: 3
Explanation: Pair the 3 with the 1 in one lunchbox. The 2 goes alone, the 4 goes alone — three lunchboxes.
```$$
WHERE slug = $$pair-lunchbox-snacks$$;

-- palindrome-episode-number
UPDATE problems SET
    description = $$Given an integer `code`, return `true` if `code` reads the same forwards and backwards, otherwise `false`. Any negative `code` is not a palindrome, since the minus sign has no matching character on the right.

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
```$$
WHERE slug = $$palindrome-episode-number$$;

-- palindrome-menu-splits
UPDATE problems SET
    description = $$Given a lowercase string `menu`, implement `splitMirrorPhrases` to return every ordered split of `menu` into pieces where each piece is a palindrome. The split must cover the whole string left to right, and a single letter counts as a palindrome. Outer list order doesn't matter.

**Example 1:**
```
Input: menu = "dbbc"
Output: [["d","b","b","c"],["d","bb","c"]]
Explanation: Two valid splits. Every piece - "d", "b", "bb", "c" - is a palindrome.
```

**Example 2:**
```
Input: menu = "ef"
Output: [["e","f"]]
Explanation: "ef" is not a palindrome, so the only valid split is letter-by-letter.
```$$
WHERE slug = $$palindrome-menu-splits$$;

-- peak-combo-window
UPDATE problems SET
    description = $$You're reviewing a rhythm-game replay. `combo[i]` is the combo count at beat `i`, and `k` is the window size the highlights reel uses.

Implement `peakFlowPerStretch` so its `i`-th output is the max of `combo[i..i+k-1]` as the window slides from start to end.

**Example 1:**
```
Input: combo = [4,2,8,5,1,7,9,3], k = 4
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
Input: combo = [6,6,6], k = 2
Output: [6,6]
Explanation: Every two-beat window has the same peak combo.
```$$
WHERE slug = $$peak-combo-window$$;

-- peak-score-streak
UPDATE problems SET
    description = $$Each entry in `scores` is the points gained or lost on a single note in a rhythm game. Find the contiguous, non-empty window of notes with the largest sum and return that sum.

**Example 1:**
```
Input: scores = [3,-2,5,-1,2,-8,4,3]
Output: 7
Explanation: The window [3,-2,5,-1,2] sums to 7, the max.
```

**Example 2:**
```
Input: scores = [2,1,-3,6,4]
Output: 10
Explanation: The window [6,4] sums to 10. The whole array also sums to 10.
```$$
WHERE slug = $$peak-score-streak$$;

-- peak-table-demand
UPDATE problems SET
    description = $$A cafe wants to know how many tables it needs at peak. `visits[i] = [arrive, leave]` is the minute a group sits down and the minute they leave. A group occupies a table for the half-open interval `[arrive, leave)`, so a new group may take the same table the minute the previous one leaves.

Return the **minimum** number of tables needed so every group has a seat for their full stay.

**Example 1:**
```
Input: visits = [[60,180],[90,150],[120,240],[200,300]]
Output: 3
Explanation: Between minute 120 and 150, three groups are seated at once, so three tables are required.
```

**Example 2:**
```
Input: visits = [[500,600],[100,200]]
Output: 1
Explanation: The two groups never overlap, so one table is enough.
```$$
WHERE slug = $$peak-table-demand$$;

-- peak-temp-jump
UPDATE problems SET
    description = $$`readings` holds hourly thermostat values from your apartment. Return the largest `readings[j] - readings[i]` with `i < j`.

If the temperature only ever drops, return `0`.

**Example 1:**
```
Input: readings = [14,9,11,8,12,15,10]
Output: 7
Explanation: Index 3 dips to 8, then index 5 climbs to 15 — a swing of 7.
```

**Example 2:**
```
Input: readings = [20,18,15,11]
Output: 0
Explanation: Only going down, so no positive swing.
```$$
WHERE slug = $$peak-temp-jump$$;

-- pick-charging-start
UPDATE problems SET
    description = $$A loop has `n` rest stops. Stop `i` charges your phone by `energy[i]` units, and driving to the next stop drains `drain[i]` units. Your phone starts empty and must never hit zero while completing one full clockwise loop.

Return the index of a valid starting stop, or `-1` if no choice finishes the loop. If a valid start exists, it is unique.

**Example 1:**
```
Input: energy = [4,6,1,3,5], drain = [3,5,2,2,6]
Output: 0
```

**Example 2:**
```
Input: energy = [5,2,8], drain = [6,4,7]
Output: -1
```$$
WHERE slug = $$pick-charging-start$$;

-- pick-circular-donuts
UPDATE problems SET
    description = $$`n` donuts sit on a circular tray. `yields[i]` is the tastiness of donut `i`. You can't pick two donuts that sit next to each other, and since the tray wraps, the first and last donuts count as neighbors.

Return the maximum total tastiness you can collect under the no-neighbors rule.

**Example 1:**
```
Input: yields = [4,1,5,6,2]
Output: 10
Explanation: Take yields[0]=4 and yields[3]=6 for a total of 10. You can't also take yields[4]=2 because it sits next to yields[0].
```

**Example 2:**
```
Input: yields = [3,8,2,7,1,9]
Output: 24
Explanation: Taking yields[1]=8, yields[3]=7, yields[5]=9 totals 24. That only works because you skipped yields[0], which is a neighbor of yields[5].
```$$
WHERE slug = $$pick-circular-donuts$$;

-- pick-snack-haul
UPDATE problems SET
    description = $$A hallway has a row of vending machines. `snacks[i]` is the haul at machine `i`. The old wiring trips a fuse if you hit two neighboring machines on the same run.

Return the maximum total snacks you can grab without picking two adjacent machines.

**Example 1:**
```
Input: snacks = [4,1,1,9,1,3]
Output: 16
Explanation: Hitting machines 0, 3, and 5 yields 4 + 9 + 3 = 16. No other no-adjacent selection scores higher.
```

**Example 2:**
```
Input: snacks = [5,5,10,100,10,5]
Output: 110
Explanation: Hitting machines 1, 3, and 5 yields 5 + 100 + 5 = 110. Taking machine 3 alone scores 100, and any selection that skips machine 3 cannot catch up.
```$$
WHERE slug = $$pick-snack-haul$$;

-- place-n-scouts
UPDATE problems SET
    description = $$Place `n` scouts on an `n x n` board, one per row, so no two scouts can see each other. Two scouts conflict if they share a column, a NW-to-SE diagonal, or a NE-to-SW diagonal.

Return every distinct conflict-free layout. Each layout is a list of `n` strings of length `n`, where `'Q'` marks a scout and `'.'` marks an empty cell. Return an empty list if none exist. Layouts may be returned in any order.

**Example 1:**
```
Input: n = 5
Output: [["Q....","..Q..","....Q",".Q...","...Q."],["Q....","...Q.",".Q...","....Q","..Q.."],[".Q...","...Q.","Q....","..Q..","....Q"],[".Q...","....Q","..Q..","Q....","...Q."],["..Q..","Q....","...Q.",".Q...","....Q"],["..Q..","....Q",".Q...","...Q.","Q...."],["...Q.","Q....","..Q..","....Q",".Q..."],["...Q.",".Q...","....Q","..Q..","Q...."],["....Q",".Q...","...Q.","Q....","..Q.."],["....Q","..Q..","Q....","...Q.",".Q..."]]
Explanation: Ten non-conflicting layouts exist on a 5 x 5 board.
```

**Example 2:**
```
Input: n = 3
Output: []
Explanation: No conflict-free layout exists on a 3 x 3 board.
```$$
WHERE slug = $$place-n-scouts$$;

-- power-of-two-tank
UPDATE problems SET
    description = $$A fish shop only keeps a tank if the fish count is a power of two (`1`, `2`, `4`, `8`, `16`, ...), since that's how the broods split. Any other count means the tank is mixed.

Implement `isSoloSpecies(specimenCount)` that returns `true` when `specimenCount == 2^k` for some non-negative integer `k`, and `false` otherwise.

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
Explanation: 12 sits between 2^3 = 8 and 2^4 = 16, so it's not a power of two.
```$$
WHERE slug = $$power-of-two-tank$$;

-- puddle-between-fences
UPDATE problems SET
    description = $$A row of hamster-cage fences stands side by side, each one meter wide. `wallHeight[i]` is the fence height at position `i`. After a spill, water pools in the dips up to the shorter of the taller fences on either side.

Return the total volume of water (in unit cells) trapped once everything settles.

**Example 1:**
```
Input: wallHeight = [0,2,0,3,1,0,2,4,1,2,0,1]
Output: 10
Explanation: The tallest flanking fences cap each dip. Summing trapped depth above every plot gives 10 unit cells.
```

**Example 2:**
```
Input: wallHeight = [3,1,0,2,1,4]
Output: 8
Explanation: Water pools between the leftmost fence of height 3 and the rightmost of height 4, trapping 8 unit cells in the dip.
```$$
WHERE slug = $$puddle-between-fences$$;

-- queue-from-stacks
UPDATE problems SET
    description = $$At your cafe's drink pickup counter, customers must be served in order, but your only trays are pushdown stacks where you can only touch the top cup. Build `QueueFromStacks` to behave as a FIFO queue using exactly two such stacks and nothing else (no arrays, lists, or deques). You may only push, pop, peek, or check emptiness on the two internal stacks.

- `QueueFromStacks()` starts an empty queue.
- `void push(int x)` adds order `x` to the back.
- `int pop()` removes and returns the front order.
- `int peek()` returns the front order without removing it.
- `boolean empty()` returns `true` if the queue is empty.

The caller will never call `pop` or `peek` on an empty queue.

**Example:**
```
q = new QueueFromStacks()
q.push(1)
q.push(2)
q.peek()   // 1  -- front of the line
q.pop()    // 1  -- front is served
q.empty()  // false -- 2 still waiting
```$$
WHERE slug = $$queue-from-stacks$$;

-- random-pick-bag
UPDATE problems SET
    description = $$Your gaming group keeps a bag of distinct card numbers and wants to draw one at random on demand. Build `RandomBag` so every card currently in the bag has equal chance of being drawn, and so insert, remove, and draw all run in average constant time.

- `RandomBag()` starts with an empty bag.
- `boolean insert(int val)` adds card `val`. Returns `true` if it wasn't already present, `false` otherwise.
- `boolean remove(int val)` removes card `val`. Returns `true` if it was present, `false` otherwise.
- `int drawRandom()` returns one card uniformly at random from the current bag. Only called when the bag is non-empty.

**Example:**
```
Calls:  ["RandomBag","insert","insert","remove","drawRandom"]
Args:   [[],[1],[2],[1],[]]
Result: [null,true,true,true,2]
```
Cards `1` and `2` go in, then `1` is pulled out. Only `2` remains, so the draw returns `2`.$$
WHERE slug = $$random-pick-bag$$;

-- rebuild-boss-tree
UPDATE problems SET
    description = $$Your video-game save corrupted its boss-fight tree, but two log files survived: one in **preorder** (node, left, right) and one in **inorder** (left, node, right). Rebuild the tree from these two logs.

Given integer arrays `preorder` and `inorder` listing the same unique node ids in those traversal orders, implement `assembleBreakdown(preorder, inorder)` and return the reconstructed tree.

**Example 1:**
```
Input: preorder = [10,5,3,7,20,15], inorder = [3,5,7,10,15,20]
Output: [10,5,20,3,7,15]
Explanation: 10 is the root. Inorder splits into [3,5,7] (left) and [15,20] (right), giving left = (5, left 3, right 7) and right = (20, left 15).
```

**Example 2:**
```
Input: preorder = [42], inorder = [42]
Output: [42]
Explanation: A single node is the whole tree.
```$$
WHERE slug = $$rebuild-boss-tree$$;

-- rebuild-tournament-line
UPDATE problems SET
    description = $$You're rebuilding the queue at a video-game tournament. Each player is a pair `[h, k]`, where `h` is their height and `k` is the number of players **ahead** of them whose height is at least `h`. The current queue is scrambled.

Given `players`, return the correctly ordered queue as a list of `[h, k]` pairs from front to back. A valid ordering is guaranteed to exist.

**Example 1:**
```
Input: players = [[8,0],[6,0],[8,1],[4,2],[6,2]]
Output: [[6,0],[8,0],[4,2],[6,2],[8,1]]
```

**Example 2:**
```
Input: players = [[5,0],[4,1],[5,1],[3,2]]
Output: [[5,0],[4,1],[3,2],[5,1]]
```$$
WHERE slug = $$rebuild-tournament-line$$;

-- recent-save-slots
UPDATE problems SET
    description = $$Your handheld console has a fixed number of quick-save slots, so old saves get bumped when you make new ones. Build `RecentRegistry` to track saves by key and evict the one you haven't used in the longest.

- `RecentRegistry(int capacity)` — starts an empty table holding up to `capacity` slots.
- `int lookup(int key)` — returns the value at `key`, or `-1` if absent. A successful lookup marks that slot as most recently used.
- `void store(int key, int value)` — writes `value` at `key`. If `key` already exists, overwrite its value and mark it most recently used. If `key` is new and the table is full, evict the least recently used slot first.

Both `lookup` and `store` must run in average `O(1)` time.

**Example:**
```
registry = new RecentRegistry(2)
registry.store(1, 10)   // {1=10}
registry.store(2, 20)   // {1=10, 2=20}
registry.lookup(1)      // returns 10; 1 is now most recent
registry.store(3, 30)   // evicts key 2 -> {1=10, 3=30}
registry.lookup(2)      // returns -1
```$$
WHERE slug = $$recent-save-slots$$;

-- recover-tier-order
UPDATE problems SET
    description = $$A friend sorted lowercase hero tags using a custom tier order — some unknown permutation of the 26 letters. Given `tags`, the already-sorted list, recover that ordering as a single string.

If two adjacent tags contradict any possible ordering (for example, a longer tag appearing before a shorter tag that is its prefix), return `""`. When a valid ordering exists, the input guarantees exactly one ordering works for the letters in `tags`.

**Example 1:**
```
Input: tags = ["ab","ba","bc","cb","cd","dc"]
Output: "abcd"
Explanation: The adjacent pairs force a before b, b before c, and c before d, giving a -> b -> c -> d.
```

**Example 2:**
```
Input: tags = ["studio","stud"]
Output: ""
Explanation: "stud" is a prefix of "studio" but comes after it, which no ordering can justify.
```$$
WHERE slug = $$recover-tier-order$$;

-- redundant-friendship
UPDATE problems SET
    description = $$Your class's friendship map over `n` students labeled `1` through `n` was meant to be a tree, but one extra friendship edge was added and now there's exactly one cycle. The edges are given as `links`, where each `links[i] = [a, b]` is an undirected friendship.

Return the edge to remove so the graph becomes a tree again. If more than one edge could break the cycle, return the one that appears **last** in `links`.

**Example 1:**
```
Input: links = [[1,2],[2,3],[1,3]]
Output: [1,3]
Explanation: Students 1, 2, and 3 form the cycle 1 - 2 - 3 - 1. Dropping [1,3] leaves the tree 1 - 2 - 3.
```

**Example 2:**
```
Input: links = [[1,2],[2,3],[3,4],[4,5],[2,5],[1,6]]
Output: [2,5]
Explanation: The cycle is 2 - 3 - 4 - 5 - 2. Both [3,4] and [2,5] belong to it, but [2,5] appears later, so it's the one to drop.
```$$
WHERE slug = $$redundant-friendship$$;

-- repeat-attendance-codes
UPDATE problems SET
    description = $$Your classroom's attendance list has `n` students numbered `1..n`. The integer array `codes` of length `n` records each id card scan. Some students scanned twice; the rest scanned exactly once.

Return every id that was scanned exactly twice, in any order. Aim for linear time and constant extra memory beyond the output list.

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
```$$
WHERE slug = $$repeat-attendance-codes$$;

-- restore-wifi-ip
UPDATE problems SET
    description = $$Your roommate wrote the Wi-Fi IP as one long string of digits. Recover every valid address those digits could form. A valid address has exactly four segments separated by dots, each between `0` and `255`, with no leading zero unless the segment is `"0"`.

Given a string `digits`, return every valid address formed by inserting exactly three dots. Return the list sorted lexicographically, or an empty list if none are valid.

**Example 1:**
```
Input: digits = "19216811"
Output: ["1.92.168.11","19.2.168.11","19.21.68.11","19.216.8.11","19.216.81.1","192.1.68.11","192.16.8.11","192.16.81.1","192.168.1.1"]
```

**Example 2:**
```
Input: digits = "0202"
Output: ["0.2.0.2"]
Explanation: Single `"0"` is fine, but a two-digit segment can't start with `0`.
```$$
WHERE slug = $$restore-wifi-ip$$;

-- reverse-playlist
UPDATE problems SET
    description = $$Your music playlist is stored as a linked list, and you want to play it backwards. Reverse the list in place so the last song becomes the first, reusing the same nodes.

Implement `rewindConveyorChain(head)` to reverse the list by rewiring `next` pointers, then return the new head.

**Example 1:**
```
Input: head = [8,3,12,5,9]
Output: [9,5,12,3,8]
Explanation: Song 9 is now first and song 8 is last.
```

**Example 2:**
```
Input: head = [4,7]
Output: [7,4]
Explanation: A two-song playlist swaps order.
```

**Example 3:**
```
Input: head = []
Output: []
Explanation: Empty playlist, nothing to flip.
```$$
WHERE slug = $$reverse-playlist$$;

-- reverse-savefile-flags
UPDATE problems SET
    description = $$Your handheld console reads save-file flags in the opposite bit order from your PC emulator, so you need to mirror the 32-bit status word before comparing.

Given a 32-bit unsigned integer `statusWord`, implement `reversePrinterFlags(statusWord)` to return the value obtained by reversing all 32 bits — bit 0 moves to position 31, bit 1 to position 30, and so on. Return the result as a `long` in `[0, 2^32 - 1]`.

**Example 1:**
```
Input: statusWord = 8
Output: 268435456
Explanation: 8 has bit 3 set. After reversing, that bit lands at position 28, giving 2^28 = 268435456.
```

**Example 2:**
```
Input: statusWord = 6
Output: 1610612736
Explanation: 6 has bits 1 and 2 set. Reversed, they become bits 30 and 29, giving 2^30 + 2^29 = 1610612736.
```$$
WHERE slug = $$reverse-savefile-flags$$;

-- right-side-skill-view
UPDATE problems SET
    description = $$Viewed from the right edge of the screen, a skill tree shows only the rightmost node on each tier — everything behind it is hidden.

Given the `root` of the skill tree, return the value of the rightmost node on each tier, top to bottom. Return an empty list if the tree is empty.

**Example 1:**
```
Input: root = [7,8,9,null,6,null,3]
Output: [7,9,3]
Explanation: Tier 0 shows 7. Tier 1 shows 8 and 9, with 9 on the right. Tier 2 shows 6 and 3, with 3 on the right.
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
```$$
WHERE slug = $$right-side-skill-view$$;

-- rising-water-path
UPDATE problems SET
    description = $$You're crossing an `n x n` grid as the water rises. `elevation[r][c]` is the tile height at row `r`, column `c`. At time `t`, a tile is walkable if its elevation is `<= t`; otherwise it's flooded.

Start at `(0, 0)` and reach `(n - 1, n - 1)`, moving between 4-connected walkable tiles. Return the minimum `t` at which a valid route first exists.

**Example 1:**
```
Input: elevation = [[1,0],[2,3]]
Output: 3
Explanation: The destination itself has height 3, so no route can exist before t = 3. At t = 3 every tile is walkable.
```

**Example 2:**
```
Input: elevation = [[0,3,1,2],[7,4,5,8],[11,13,15,12],[6,9,10,14]]
Output: 14
Explanation: The lowest peak along the best route (0,0) -> (1,0) -> (2,0) -> (3,0) -> (3,1) -> (3,2) -> (3,3) is 14, the destination's height.
```$$
WHERE slug = $$rising-water-path$$;

-- rotate-pet-cafe-map
UPDATE problems SET
    description = $$Your pet cafe's seating grid saved sideways and there's no room on the tablet for a second copy. Rotate it 90 degrees clockwise in place.

Given an `n x n` integer grid `cafeMap`, implement `rotateParkMap` to rotate it 90 degrees clockwise in-place. Mutate `cafeMap` directly — do not allocate a second `n x n` grid.

**Example 1:**
```
Input: cafeMap = [[2,4,6],[8,1,3],[5,7,9]]
Output: [[5,8,2],[7,1,4],[9,3,6]]
```

**Example 2:**
```
Input: cafeMap = [[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]
Output: [[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]
```$$
WHERE slug = $$rotate-pet-cafe-map$$;

-- rotting-donuts
UPDATE problems SET
    description = $$An `m x n` tray holds donuts. Each cell is one of three states:

- `0` — an **empty slot** (no donut)
- `1` — a **fresh donut**
- `2` — a **stale donut**

Each minute, every fresh donut that shares a 4-directional edge with a stale donut also becomes stale. Return the minimum minutes until no fresh donuts remain, or `-1` if some fresh donut can never be reached.

**Example 1:**
```
Input: ward = [[2,1,1],[1,0,1],[1,1,1]]
Output: 4
Explanation: Starting from the single stale donut at (0,0), the last fresh one at (2,2) goes stale after four minutes.
```

**Example 2:**
```
Input: ward = [[2,0,1],[0,0,1],[1,1,1]]
Output: -1
Explanation: The stale donut at (0,0) is walled off by empty slots, so the fresh ones never get reached.
```

**Example 3:**
```
Input: ward = [[0,0,2],[0,0,0]]
Output: 0
Explanation: There are no fresh donuts, so zero minutes pass.
```$$
WHERE slug = $$rotting-donuts$$;

-- round-nicknames
UPDATE problems SET
    description = $$You're labeling rounds for a silly party game. Given a positive integer `n`, return a list of labels for rounds `1` through `n` using these rules:

- If the round is divisible by both 3 and 5, label it `"FizzBuzz"`.
- If the round is divisible by 3 only, label it `"Fizz"`.
- If the round is divisible by 5 only, label it `"Buzz"`.
- Otherwise, label it with the round number as a decimal string.

Return the labels in order.

**Example 1:**
```
Input: n = 4
Output: ["1","2","Fizz","4"]
```

**Example 2:**
```
Input: n = 6
Output: ["1","2","Fizz","4","Buzz","Fizz"]
```$$
WHERE slug = $$round-nicknames$$;

-- running-median-timer
UPDATE problems SET
    description = $$Your speedrun timer logs the seconds of each attempt, and you want the median run time on demand as new attempts stream in. Build `StreamMedian` to track runs and report the median so far. For an even count, the median is the average of the two middle values; otherwise it's the single middle value. Both are returned as doubles.

Implement the `StreamMedian` class:

- `StreamMedian()` starts with no runs logged.
- `void record(int num)` logs a new run time `num`.
- `double median()` returns the median of all runs logged so far. Only called after at least one `record`.

**Example:**
```
collector = new StreamMedian()
collector.record(1)
collector.median()    // 1.0
collector.record(2)
collector.median()    // (1 + 2) / 2 = 1.5
collector.record(3)
collector.median()    // middle of [1, 2, 3] = 2.0
```$$
WHERE slug = $$running-median-timer$$;

-- same-skill-trees
UPDATE problems SET
    description = $$Two players exported their characters' skill trees as binary trees. Check whether the exports are identical — same shape and same node values everywhere.

Given the roots of two skill trees `p` and `q`, return `true` if they match node for node, `false` otherwise. Either tree may be empty.

**Example 1:**
```
Input: p = [8,4,12], q = [8,4,12]
Output: true
Explanation: Same shape and same values at every node.
```

**Example 2:**
```
Input: p = [3,5], q = [3,null,5]
Output: false
Explanation: In p, 5 is a left child; in q, it's a right child. Shapes differ.
```

**Example 3:**
```
Input: p = [6,2,9], q = [6,9,2]
Output: false
Explanation: The left and right children are swapped, so the trees don't match.
```$$
WHERE slug = $$same-skill-trees$$;

-- same-snack-mix
UPDATE problems SET
    description = $$Two trail-mix bags are the same if they use the exact same letters with the exact same counts, regardless of order. Each letter is one ingredient.

Given two lowercase ingredient strings `mixA` and `mixB`, implement `matchRecipe` to return `true` when the two mixes form the same multiset of ingredients, and `false` otherwise. Different lengths means `false`.

**Example 1:**
```
Input: mixA = "butter", mixB = "bruett"
Output: true
Explanation: Both bags use one 'b', one 'u', one 'e', one 'r', and two 't'.
```

**Example 2:**
```
Input: mixA = "yeast", mixB = "toast"
Output: false
Explanation: `mixA` has 'y' and 'e' that `mixB` doesn't, so the mixes differ.
```$$
WHERE slug = $$same-snack-mix$$;

-- search-rotated-catalog
UPDATE problems SET
    description = $$Your RPG's item catalog is normally sorted by ID, but tonight it was rotated around some pivot — e.g. `[10,14,18,22,25,28,33]` might open as `[25,28,33,10,14,18,22]`.

Given the rotated `catalog` and a `target` ID, return the index of `target` in `catalog`, or `-1` if it isn't present. Run in `O(log n)` time.

**Example 1:**
```
Input: catalog = [12,18,24,31,3,7,9], target = 3
Output: 4
Explanation: The catalog stores 3 at index 4 after the rotation.
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
```$$
WHERE slug = $$search-rotated-catalog$$;

-- shared-guild-ancestor
UPDATE problems SET
    description = $$Your MMO guild's hierarchy is a tree: the root is the guild master, children are officers, and deeper nodes are squad leaders down to members. Given `root` and two members `p` and `q`, return their **lowest common ancestor** — the deepest node whose subtree contains both.

A node counts as an ancestor of itself, so if `p` is above `q` (or vice versa), return that upper node. All values are unique and both `p` and `q` exist in the tree.

**Example 1:**
```
Input: root = [12,7,20,4,9,16,25,null,null,8,11], p = 4, q = 11
Output: 7
Explanation: Member 4 sits under officer 7, and member 11 sits under squad leader 9 which sits under officer 7, so 7 is the deepest shared captain.
```

**Example 2:**
```
Input: root = [12,7,20,4,9,16,25,null,null,8,11], p = 9, q = 7
Output: 7
Explanation: Node 9 is already under node 7, so 7 is its own lowest common ancestor with 9.
```$$
WHERE slug = $$shared-guild-ancestor$$;

-- shortest-book-span
UPDATE problems SET
    description = $$A shelf string `shelf` lists one letter-tag per volume in order. A requirements string `needed` lists the tags you must cover, counted with multiplicity (two `'O'`s in `needed` means you need at least two `'O'` volumes).

Return the shortest contiguous substring of `shelf` that covers every letter in `needed` with the required counts, or `""` if none exists. On ties, return the earliest one.

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
```$$
WHERE slug = $$shortest-book-span$$;

-- shortest-cookie-span
UPDATE problems SET
    description = $$The array `trays` lists how many cookies each slot holds, left to right. You need at least `target` cookies total from one contiguous run of slots.

Implement `shortestBakeSpan` to return the length of the shortest contiguous span of `trays` whose sum is at least `target`. Return `0` if no span reaches `target`.

**Example 1:**
```
Input: trays = [3,1,4,1,5,9,2,6], target = 15
Output: 3
Explanation: The span [1,5,9] sums to 15, and no shorter span reaches 15.
```

**Example 2:**
```
Input: trays = [2,2,2], target = 10
Output: 0
Explanation: The whole tray only gives 6 cookies, short of the order.
```

**Example 3:**
```
Input: trays = [8,3,2], target = 8
Output: 1
Explanation: The first slot already meets the target by itself.
```$$
WHERE slug = $$shortest-cookie-span$$;

-- shortest-dungeon-path
UPDATE problems SET
    description = $$`board` is an `n x n` grid where each tile is `0` (walkable) or `1` (blocked). From any tile, your hero can step to any of the 8 surrounding tiles. Find the shortest walkable path from `(0, 0)` to `(n - 1, n - 1)`.

Return the number of tiles on that path, counting both ends. Every tile on the path must be `0`. Return `-1` if either corner is blocked or no path exists.

**Example 1:**
```
Input: board = [[0,0],[0,0]]
Output: 2
Explanation: One diagonal step from (0,0) to (1,1) covers 2 walkable tiles.
```

**Example 2:**
```
Input: board = [[0,1,0],[0,0,0],[1,0,0]]
Output: 3
Explanation: The path (0,0) -> (1,1) -> (2,2) visits 3 walkable tiles.
```$$
WHERE slug = $$shortest-dungeon-path$$;

-- shortest-table-booking
UPDATE problems SET
    description = $$The cafe's `bookings[i] = [start, end]` gives each booked table as an inclusive minute range on a shared timeline. A booking's length is `end - start + 1`.

For each minute in `probes`, return the length of the **shortest** booking covering that minute, or `-1` if no booking covers it. Output an array aligned with `probes`.

**Example 1:**
```
Input: bookings = [[2,5],[4,7],[1,9],[6,10]], probes = [3,6,9,11]
Output: [4,4,5,-1]
Explanation: Minute 3 sits in [2,5] (length 4) and [1,9] (length 9); tightest is 4. Minute 11 isn't in any booking.
```

**Example 2:**
```
Input: bookings = [[10,12],[8,20]], probes = [9,11,25]
Output: [13,3,-1]
Explanation: Minute 9 is only inside [8,20] (length 13). Minute 11 is in [10,12] (length 3) and [8,20] (length 13); tightest is 3. Minute 25 isn't covered.
```$$
WHERE slug = $$shortest-table-booking$$;

-- skill-tree-codec
UPDATE problems SET
    description = $$You want to save a video-game skill tree as plain text so a friend can load the same build later. Pack the tree into a string and unpack it back without losing anything.

Implement the `TreeSerializer` class with two methods:

- `String pack(TreeNode root)` — encodes the tree rooted at `root` as a single string. `root` may be `null`; in that case `pack` returns some well-defined string meaning "empty tree".
- `TreeNode unpack(String data)` — rebuilds the tree from a string produced by `pack`, returning `null` for the empty-tree string.

Pick any format you like, but `unpack(pack(t))` must always return a tree identical to `t`, and both methods must be stateless.$$
WHERE slug = $$skill-tree-codec$$;

-- slot-a-meeting
UPDATE problems SET
    description = $$The team calendar `slots` lists meetings as `[start, end]`, sorted by `start` and non-overlapping. A new meeting `newSlot = [start, end]` needs to be inserted.

Insert `newSlot` into `slots` and return the updated list, still sorted and non-overlapping. Merge `newSlot` with any entry it touches or overlaps into a single entry.

**Example 1:**
```
Input: slots = [[1,4],[7,10]], newSlot = [3,6]
Output: [[1,6],[7,10]]
Explanation: newSlot overlaps [1,4], merging into [1,6]. [7,10] is untouched.
```

**Example 2:**
```
Input: slots = [[2,4],[6,8],[10,12],[14,18]], newSlot = [5,11]
Output: [[2,4],[5,12],[14,18]]
Explanation: newSlot swallows [6,8] and [10,12] to form [5,12].
```$$
WHERE slug = $$slot-a-meeting$$;

-- slowest-snack-rate
UPDATE problems SET
    description = $$`piles[i]` is the piece count of pile `i` of leftover Halloween candy, and you have `hours` hours to finish it all. Each hour you pick one pile and eat up to `k` pieces from it; if the pile has fewer than `k` left, you clear it and the rest of the hour is idle.

Return the smallest integer eating rate `k` that lets you finish every pile within `hours` hours.

**Example 1:**
```
Input: piles = [5,8,12,20], hours = 9
Output: 6
Explanation: At rate 6 the hours per pile are ceil(5/6)=1, ceil(8/6)=2, ceil(12/6)=2, ceil(20/6)=4, totaling 9.
```

**Example 2:**
```
Input: piles = [40,25,18,33,12], hours = 5
Output: 40
Explanation: With 5 piles and only 5 hours, every pile must clear in a single hour.
```

**Example 3:**
```
Input: piles = [40,25,18,33,12], hours = 7
Output: 25
```$$
WHERE slug = $$slowest-snack-rate$$;

-- snack-combo-picks
UPDATE problems SET
    description = $$You have a pile of snack-pack tickets `snacks`, each with a flavor code, and some flavors repeat. List every distinct combo you could grab.

Given the integer array `snacks`, implement `listMontageScenes` to return every distinct multiset of tickets as a list of lists, including the empty combo. Any order is fine.

**Example 1:**
```
Input: snacks = [2,5,5]
Output: [[],[2],[2,5],[2,5,5],[5],[5,5]]
```

**Example 2:**
```
Input: snacks = [5]
Output: [[],[5]]
```

**Example 3:**
```
Input: snacks = [2,2,2,1,2]
Output: [[],[1],[1,2],[1,2,2],[1,2,2,2],[1,2,2,2,2],[2],[2,2],[2,2,2],[2,2,2,2]]
Explanation: The flavor 2 appears four times and 1 appears once; each distinct multiset shows up exactly once.
```$$
WHERE slug = $$snack-combo-picks$$;

-- snack-drawer-pair
UPDATE problems SET
    description = $$The array `snacks` lists the calories of each snack in a shared drawer. You and a friend want to eat exactly `target` calories together.

Pick two different snacks whose calories sum to `target` and return their indices. Exactly one pair works, and the order doesn't matter.

**Example 1:**
```
Input: snacks = [4, 11, 19, 23], target = 30
Output: [1, 2]
Explanation: snacks[1] + snacks[2] = 11 + 19 = 30.
```

**Example 2:**
```
Input: snacks = [8, 14, 6], target = 14
Output: [0, 2]
Explanation: snacks[0] + snacks[2] = 8 + 6 = 14.
```$$
WHERE slug = $$snack-drawer-pair$$;

-- snack-stock-map
UPDATE problems SET
    description = $$Build a lookup table for a vending machine's snack counts. The built-in dictionary library is off-limits.

Implement the `ChainedMap` class:

- `ChainedMap()` — creates an empty map.
- `void set(int key, int value)` — sets snack `key` to quantity `value`, overwriting any previous count.
- `int lookup(int key)` — returns the quantity for snack `key`, or `-1` if it isn't tracked.
- `void erase(int key)` — removes snack `key`; does nothing if it wasn't there.

**Example 1:**
```
Input: ["ChainedMap","set","set","lookup","lookup","set","lookup","erase","lookup"] / [[],[1,10],[2,20],[1],[3],[2,30],[2],[2],[2]]
Output: [null,null,null,10,-1,null,30,null,-1]
```
After recording `(1,10)` and `(2,20)`, snack 1 returns its count and snack 3 returns `-1`. Overwriting snack 2 with 30 is reflected next read, and erasing it makes the follow-up return `-1`.

**Example 2:**
```
Input: ["ChainedMap","set","set","set","lookup","lookup","lookup"] / [[],[5,50],[10,100],[15,150],[5],[10],[15]]
Output: [null,null,null,null,50,100,150]
```
Three separate snacks are stored and each one reads back its own count.

**Example 3:**
```
Input: ["ChainedMap","lookup","erase","lookup"] / [[],[7],[7],[7]]
Output: [null,-1,null,-1]
```
Lookups and erases for a snack that was never added do no harm.$$
WHERE slug = $$snack-stock-map$$;

-- snapshot-town-map
UPDATE problems SET
    description = $$You're given one `node` from a connected undirected graph of town spots. Each spot has an integer `val` and a list of `neighbors`.

Return a **deep copy** of the entire connected graph reachable from the given spot. Every node in the copy must be a newly allocated object with the same `val` and neighbor structure; no node may be shared with the original.

The graph is passed as an adjacency list, where index `i` (0-based) holds the neighbors of the node with `val = i + 1`. The entry point always has `val = 1` when the graph is non-empty.

**Example 1:**
```
Input: adjList = [[2,3],[1,4],[1,5],[2,5],[3,4]]
Output: [[2,3],[1,4],[1,5],[2,5],[3,4]]
Explanation: Spot 1 connects to 2 and 3; spot 2 connects to 1 and 4. The copy mirrors every edge with new node objects.
```

**Example 2:**
```
Input: adjList = [[2],[1,3],[2]]
Output: [[2],[1,3],[2]]
Explanation: A three-spot line is cloned edge-for-edge.
```$$
WHERE slug = $$snapshot-town-map$$;

-- sort-latte-squared
UPDATE problems SET
    description = $$`drifts` is sorted in non-decreasing order and contains each latte's temperature difference from the target (negative for cold, positive for hot).

Return the squared drifts in non-decreasing order. Aim for O(n) — no general-purpose sort.

**Example 1:**
```
Input: drifts = [-5,-2,0,4,9]
Output: [0,4,16,25,81]
```

**Example 2:**
```
Input: drifts = [-6,-4,1,3,8]
Output: [1,9,16,36,64]
```

**Example 3:**
```
Input: drifts = [2,3,5,7]
Output: [4,9,25,49]
Explanation: Every value is non-negative, so squaring keeps the order.
```$$
WHERE slug = $$sort-latte-squared$$;

-- sort-recycle-bins
UPDATE problems SET
    description = $$`supplies` is an integer array containing only `0` (paper), `1` (plastic), and `2` (metal). Rearrange it **in place** so all `0`s come first, then `1`s, then `2`s.

Do not call any library sort. The function returns nothing; the caller inspects `supplies` afterwards.

**Example 1:**
```
Input: supplies = [1,2,0,2,1,0,1]
Output: [0,0,1,1,1,2,2]
Explanation: Two paper codes, three plastic codes, then two metal codes.
```

**Example 2:**
```
Input: supplies = [2,1,0]
Output: [0,1,2]
```$$
WHERE slug = $$sort-recycle-bins$$;

-- space-cookie-bakes
UPDATE problems SET
    description = $$Given the string `cookies`, rearrange its letters so no two adjacent letters are equal. Return any valid arrangement, or `""` if none exists.

**Example 1:**
```
Input: cookies = "bread"
Output: "brade"
Explanation: Any arrangement with no two equal adjacent letters is accepted — e.g. "brade" or "dabre".
```

**Example 2:**
```
Input: cookies = "aaaab"
Output: ""
Explanation: The letter 'a' appears 4 times in a length-5 string, so any arrangement must place two 'a's next to each other.
```

**Example 3:**
```
Input: cookies = "flour"
Output: "flour"
Explanation: All letters are distinct, so the input itself is valid.
```$$
WHERE slug = $$space-cookie-bakes$$;

-- spawn-code-ladder
UPDATE problems SET
    description = $$You're changing a lowercase spawn tag one letter at a time. Each intermediate tag must appear in `codeBank`.

Given `startCode` and `targetCode` of equal length, return the number of tags in the shortest chain from `startCode` to `targetCode` where each step changes exactly one letter and every step after the first is in `codeBank`. `startCode` need not be in `codeBank`, but `targetCode` must be. Return `0` if no such chain exists.

**Example 1:**
```
Input: startCode = "pet", targetCode = "pot", codeBank = ["pit","pot","pat"]
Output: 3
Explanation: pet -> pit -> pot changes one letter per step and every stop is in codeBank.
```

**Example 2:**
```
Input: startCode = "pet", targetCode = "pot", codeBank = ["pit","pat"]
Output: 0
Explanation: "pot" isn't in codeBank, so no chain can end there.
```$$
WHERE slug = $$spawn-code-ladder$$;

-- spiral-shelf-walk
UPDATE problems SET
    description = $$Given an `m x n` grid `board`, return its values in spiral order: across the top row, down the rightmost column, back along the bottom row, up the leftmost column, then inward and repeat. Each cell is visited exactly once.

**Example 1:**
```
Input: board = [[1,2],[3,4]]
Output: [1,2,4,3]
```

**Example 2:**
```
Input: board = [[5,6,7],[8,9,10],[11,12,13],[14,15,16]]
Output: [5,6,7,10,13,16,15,14,11,8,9,12]
```$$
WHERE slug = $$spiral-shelf-walk$$;

-- split-candy-bar
UPDATE problems SET
    description = $$Given a candy bar `span` squares long, split it into two or more contiguous chunks of positive integer length. The score of a split is the product of the chunk lengths.

Implement `splitProductMax(span)` to return the maximum product over all valid splits.

**Example 1:**
```
Input: span = 5
Output: 6
Explanation: The best split is 5 = 2 + 3, giving 2 * 3 = 6. All other splits (1+4, 1+1+3, 1+2+2, 1+1+1+2, 1+1+1+1+1) score lower.
```

**Example 2:**
```
Input: span = 11
Output: 54
Explanation: The best split is 11 = 3 + 3 + 3 + 2, giving 3 * 3 * 3 * 2 = 54. Splits like 3+4+4 yield 48 and 3+3+5 yield 45.
```$$
WHERE slug = $$split-candy-bar$$;

-- split-sticker-runs
UPDATE problems SET
    description = $$Partition the string `stickers` into the fewest consecutive chunks such that every distinct letter appears in exactly one chunk. The chunks concatenated must equal `stickers`.

Return the length of each chunk in order.

**Example 1:**
```
Input: stickers = "mnopmpoqrqrts"
Output: [7,4,1,1]
Explanation: 'm', 'n', 'o', 'p' all live inside the first 7 characters. 'q' and 'r' fill positions 7..10. 't' and 's' each appear once.
```

**Example 2:**
```
Input: stickers = "xyzzyx"
Output: [6]
Explanation: 'x' bookends the strip, pulling 'y' and 'z' into the same chunk, so it's all one piece.
```$$
WHERE slug = $$split-sticker-runs$$;

-- split-ticket-pile
UPDATE problems SET
    description = $$Each ticket in `tickets[i]` has an integer effort score. Decide whether the pile can be split into two disjoint groups with equal total effort.

Implement `canSplitLoads(tickets)` to return `true` if such a split exists, `false` otherwise.

**Example 1:**
```
Input: tickets = [3,1,1,2,2,1]
Output: true
Explanation: Total is 10, so each person needs 5. One split: {3, 2} for Alice and {1, 1, 2, 1} for Bob.
```

**Example 2:**
```
Input: tickets = [2,2,3,5]
Output: false
Explanation: Total is 12, so each would need 6, but no subset of {2, 2, 3, 5} sums to 6.
```$$
WHERE slug = $$split-ticket-pile$$;

-- spot-duplicate-locker
UPDATE problems SET
    description = $$You're handing out locker numbers to a homeroom class and want to catch duplicates. Given an integer array `lockers` of assigned numbers, implement `detectClash` to return `true` if any number repeats, otherwise `false`.

**Example 1:**
```
Input: lockers = [7,2,9,7]
Output: true
Explanation: The number 7 shows up at index 0 and index 3.
```

**Example 2:**
```
Input: lockers = [11,22,33,44]
Output: false
Explanation: Every locker number is distinct.
```$$
WHERE slug = $$spot-duplicate-locker$$;

-- sum-skill-tree-codes
UPDATE problems SET
    description = $$An RPG stores each character's skill tree as a binary tree where every node holds a digit (`0`-`9`). Each root-to-leaf path spells a build code by concatenating its digits into one integer.

Given the `root`, implement `totalZoneCodes` to return the sum of the build codes from every root-to-leaf path.

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
Explanation: A single node is both root and leaf, giving one code of 9.
```$$
WHERE slug = $$sum-skill-tree-codes$$;

-- swap-print-pairs
UPDATE problems SET
    description = $$The office print queue is a linked list of job ids. Swap every two adjacent jobs in the queue. If the queue has an odd number of jobs, the last one stays in place.

Implement `swapQueuePartners(head)` to relink `next` pointers so each adjacent pair is swapped, and return the new head. Only change links, not node values.

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
```$$
WHERE slug = $$swap-print-pairs$$;

-- task-cooldown-planner
UPDATE problems SET
    description = $$A shared office printer handles one job per slot, and each job is labeled by the coworker who sent it. The printer refuses to run two jobs with the same label within `n` slots of each other. Each slot either prints one job or sits idle, and jobs can be scheduled in any order.

Given `jobs` and `n`, return the minimum number of slots needed to print every job while respecting the cooldown.

**Example 1:**
```
Input: jobs = ["P","P","P","P","Q","Q"], n = 3
Output: 13
Explanation: One valid schedule is P -> Q -> idle -> idle -> P -> Q -> idle -> idle -> P -> idle -> idle -> idle -> P, using 13 slots.
```

**Example 2:**
```
Input: jobs = ["A","B","C","A","B","D"], n = 1
Output: 6
Explanation: The order A -> B -> C -> A -> B -> D already separates identical labels by at least 1 slot, so no idle slots are needed.
```$$
WHERE slug = $$task-cooldown-planner$$;

-- ticket-plus-or-minus
UPDATE problems SET
    description = $$Your team works through a backlog of tickets, each worth some points. For every ticket you either **add** or **subtract** its points from the team's score. Given an array `tickets` and an integer `target`, count the number of plus/minus assignments that produce a net score of exactly `target`.

Implement `partitionTankDoses` to return the count.

**Example 1:**
```
Input: tickets = [2,2,2,2], target = 4
Output: 4
Explanation: Net +4 means 3 tickets added and 1 subtracted; 4 choices for which is subtracted.
```

**Example 2:**
```
Input: tickets = [4,6,8], target = 10
Output: 1
Explanation: The only net +10 assignment is -4 + 6 + 8 = 10.
```$$
WHERE slug = $$ticket-plus-or-minus$$;

-- timestamp-value-store
UPDATE problems SET
    description = $$Your guild's co-op game autosaves each player's status tag at timestamped checkpoints, and you want to look up what a player's tag said at a given moment. Build `TimestampedStore` to save tagged snapshots and answer as-of queries.

- `TimestampedStore()` — starts an empty store.
- `void write(String key, String value, int timestamp)` — records `value` for `key` at `timestamp`. For any given `key`, timestamps on successive `write` calls are strictly increasing.
- `String readAt(String key, int timestamp)` — returns the latest value stored for `key` with timestamp `<= timestamp`, or `""` if none exists.

If the query falls between two writes, return the value from the most recent earlier write.$$
WHERE slug = $$timestamp-value-store$$;

-- top-espresso-machines
UPDATE problems SET
    description = $$A cafe logs every espresso machine used during the morning rush in `checkIns`, where each number is a machine id. The manager wants the `k` most-used machines posted on the break-room whiteboard.

Implement `busiestMachines` to return the `k` machine ids that appear most often in `checkIns`, in any order. The top `k` is guaranteed to be unique.

**Example 1:**
```
Input: checkIns = [4,4,4,7,7,5], k = 2
Output: [4,7]
Explanation: Machine 4 was used 3 times, machine 7 twice, machine 5 once. The top 2 are 4 and 7.
```

**Example 2:**
```
Input: checkIns = [9], k = 1
Output: [9]
```$$
WHERE slug = $$top-espresso-machines$$;

-- top-raid-score
UPDATE problems SET
    description = $$Your guild wrapped a raid and has everyone's damage numbers in `scores`. Return the `k`-th highest score, counting ties — for `[8, 3, 5, 5]` the 1st is `8` and the 2nd is `5`.

Implement `findBrightestTargets(scores, k)` to return the value at position `k` after sorting `scores` in descending order.

**Example 1:**
```
Input: scores = [7,2,9,4,9,6,3], k = 3
Output: 7
Explanation: Sorted descending: [9,9,7,6,4,3,2]. The 3rd entry is 7.
```

**Example 2:**
```
Input: scores = [12,5,8,5,8,15,3,11], k = 4
Output: 8
Explanation: Sorted descending: [15,12,11,8,8,5,5,3]. The 4th entry is 8.
```$$
WHERE slug = $$top-raid-score$$;

-- topic-catalog-lca
UPDATE problems SET
    description = $$A school library's topic catalog is a **binary search tree** where each node holds a topic ID — smaller IDs go left, larger IDs go right. Given the `root` and two topics `p` and `q`, return the deepest topic whose subtree contains both.

A node counts as its own descendant, so if one topic is an ancestor of the other, return that one. Both `p` and `q` are in the tree and are distinct.

**Example 1:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 8, q = 12
Output: 10
Explanation: 8 sits under the left side of 10 (via 5), and 12 sits under the right side of 10 (via 15). 10 is the deepest topic containing both.
```

**Example 2:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 25, q = 40
Output: 30
Explanation: Both topics sit in the right subtree of 20. Their lowest shared ancestor is 30.
```

**Example 3:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 10, q = 15
Output: 10
Explanation: 15 lives beneath 10, so 10 is itself the shared ancestor.
```$$
WHERE slug = $$topic-catalog-lca$$;

-- trending-chat-topics
UPDATE problems SET
    description = $$Your class group chat is nonstop and you want the `k` most-mentioned topic tags in today's messages. Break ties by label in ascending alphabetical order.

Implement `rankTrendingTopics(topics, k)` to return the `k` tags with the highest count, sorted by count descending, then label ascending on ties.

**Example 1:**
```
Input: topics = ["climate","climate","market","sports","market","climate","weather"], k = 2
Output: ["climate","market"]
Explanation: "climate" appears 3 times and "market" appears 2 times — the two loudest tags.
```

**Example 2:**
```
Input: topics = ["tech","tech","film","film","music","books","music"], k = 3
Output: ["film","music","tech"]
Explanation: "film", "music", and "tech" all appear twice, so they're returned in alphabetical order.
```$$
WHERE slug = $$trending-chat-topics$$;

-- two-menu-sum
UPDATE problems SET
    description = $$A **1-indexed** menu `menuPrice` is sorted in non-decreasing order, and your wallet holds exactly `budget`. Find two different items whose prices sum to `budget` and return their menu numbers as `[item1, item2]` where `1 <= item1 < item2 <= menuPrice.length`.

Exactly one pair works. Use only constant extra space beyond the input.

**Example 1:**
```
Input: menuPrice = [12,30,45,58,70,85], budget = 100
Output: [2,5]
Explanation: Item 2 costs 30 and item 5 costs 70, which together match the 100 budget.
```

**Example 2:**
```
Input: menuPrice = [5,14,22,40], budget = 54
Output: [2,4]
Explanation: Item 2 is 14 and item 4 is 40; 14 + 40 = 54.
```$$
WHERE slug = $$two-menu-sum$$;

-- two-shift-baristas
UPDATE problems SET
    description = $$Split `n` baristas (indexed `0` to `n - 1`) into exactly two shifts so no conflicting pair shares a shift. `conflicts[i]` lists the coworkers who can't work with barista `i`. The relation is symmetric and the graph may have disjoint clusters.

Implement `splitIntoTwoShifts(conflicts)` and return `true` if such a split exists, else `false`.

**Example 1:**
```
Input: conflicts = [[1],[0,2],[1,3],[2]]
Output: true
Explanation: Put baristas 0 and 2 on morning and 1 and 3 on evening; every conflict crosses shifts.
```

**Example 2:**
```
Input: conflicts = [[1,2],[0,2],[0,1]]
Output: false
Explanation: Baristas 0, 1, and 2 all conflict, so any two-shift split forces two of them together.
```$$
WHERE slug = $$two-shift-baristas$$;

-- unique-genre-window
UPDATE problems SET
    description = $$You have a string `queue` where each letter is a genre tag. Return the length of the longest contiguous substring of `queue` that contains at most `k` distinct characters. If `k` is 0, return 0.

**Example 1:**
```
Input: queue = "yyxzxxz", k = 2
Output: 5
Explanation: "xzxxz" only uses x and z and has length 5.
```

**Example 2:**
```
Input: queue = "rrrrrr", k = 1
Output: 6
Explanation: Every tag is the same genre, so the whole string fits inside one distinct tag.
```$$
WHERE slug = $$unique-genre-window$$;

-- username-trie
UPDATE problems SET
    description = $$Build an autocomplete index for a video game's username registry. The index must quickly answer two questions: does a given name exist as a full username, and does any username start with a given prefix?

Implement `PrefixIndex`:

- `PrefixIndex()` — creates an empty index.
- `void insert(String word)` — registers `word` as a full username. Re-inserting is harmless.
- `boolean search(String word)` — returns `true` only if `word` was inserted as a complete username.
- `boolean startsWith(String prefix)` — returns `true` if any inserted username begins with `prefix`.

**Example 1:**
```
Input:
["PrefixIndex", "insert", "search", "search", "startsWith", "insert", "search"]
[[], ["apple"], ["apple"], ["app"], ["app"], ["app"], ["app"]]
Output: [null, null, true, false, true, null, true]
```

After inserting `"apple"`, `search("apple")` is `true` but `search("app")` is `false` because `"app"` is only a prefix so far. `startsWith("app")` is `true`. Once `"app"` itself is inserted, `search("app")` becomes `true`.$$
WHERE slug = $$username-trie$$;

-- valid-brackets
UPDATE problems SET
    description = $$A string `tape` contains only the bracket characters `(`, `)`, `[`, `]`, `{`, `}`. Return `true` if the brackets are properly nested: every opener is closed by the matching type, and outer brackets never close before their inner ones. Return `false` otherwise.

**Example 1:**
```
Input: tape = "{[()]}"
Output: true
Explanation: Each opener is closed by the matching type in the correct nested order.
```

**Example 2:**
```
Input: tape = "{[(])}"
Output: false
Explanation: The `(` is closed by `]` before its matching `)`, breaking the nesting.
```$$
WHERE slug = $$valid-brackets$$;

-- valid-number-puzzle
UPDATE problems SET
    description = $$You're checking a classmate's 9x9 number puzzle. The `grid` is split into nine 3x3 boxes, and each cell holds a digit `1`-`9` or `.` for blank. The rule: no digit may repeat inside any row, column, or 3x3 box — blanks are ignored.

Return `true` if every filled cell obeys all three rules, else `false`. The puzzle does not need to be solvable; only the filled cells are checked.

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
Explanation: Every row, column, and box holds at most one of each digit, so the grid is valid.
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
Explanation: Row 1 has `1` in two columns, which breaks the uniqueness rule.
```$$
WHERE slug = $$valid-number-puzzle$$;

-- valid-pet-tree
UPDATE problems SET
    description = $$A pet-cafe map has `n` cafes labeled `0` to `n - 1`. Each entry `[u, v]` in `lanes` is a two-way walking path between cafe `u` and cafe `v`. Return `true` if `n` and `lanes` form one fully connected, loop-free structure (every cafe reachable from every other, with no cycles), and `false` otherwise.

**Example 1:**
```
Input: n = 6, lanes = [[0,1],[0,2],[1,3],[1,4],[2,5]]
Output: true
Explanation: All 6 cafes are reachable from cafe 0, and the 5 paths never form a loop.
```

**Example 2:**
```
Input: n = 4, lanes = [[0,1],[1,2],[2,0],[0,3]]
Output: false
Explanation: Cafes 0, 1, and 2 form a loop, so the map isn't loop-free.
```$$
WHERE slug = $$valid-pet-tree$$;

-- valid-score-bst
UPDATE problems SET
    description = $$An arcade stores player scores in a binary tree. It should be a BST: every node in a left subtree is **strictly lower** than its ancestor, and every node in a right subtree is **strictly higher**. All scores are distinct.

Given the `root`, implement `verifyWardOrder(root)` to return `true` if the BST rule holds across full subtrees (not just immediate children), or `false` otherwise.

**Example 1:**
```
Input: root = [50,30,70,20,40,60,80]
Output: true
Explanation: Every left subtree stays below its ancestor and every right subtree stays above.
```

**Example 2:**
```
Input: root = [10,5,15,null,null,6,20]
Output: false
Explanation: 6 lives in the right subtree of root 10, but 6 < 10, so the rule breaks.
```$$
WHERE slug = $$valid-score-bst$$;

-- valid-slogan-palindrome
UPDATE problems SET
    description = $$Given a bumper-sticker slogan `phrase`, lowercase all letters and drop every non-alphanumeric character. Return `true` if the result reads the same forwards and backwards, else `false`. An empty string counts as a palindrome.

**Example 1:**
```
Input: phrase = "Stacks: Level 2 level stack S"
Output: true
Explanation: After filtering, the phrase becomes "stackslevel2levelstacks", which mirrors itself.
```

**Example 2:**
```
Input: phrase = "Shelf 7A not mirrored"
Output: false
Explanation: After filtering the phrase becomes "shelf7anotmirrored", which is not a mirror.
```

**Example 3:**
```
Input: phrase = ",,,"
Output: true
Explanation: After removing non-alphanumeric characters the phrase is empty, which counts as a mirror.
```$$
WHERE slug = $$valid-slogan-palindrome$$;

-- validate-homework-id
UPDATE problems SET
    description = $$Your homework uses a small pattern language where `.` matches any single character and `*` means zero or more copies of the character right before it. The pattern must cover the entire ID, not just a prefix or middle chunk.

Given an ID string `s` and a pattern `p`, return `true` if `p` matches all of `s`, else `false`.

**Example 1:**
```
Input: s = "bbbc", p = "b*c"
Output: true
Explanation: `b*` consumes the three b's at the start, then `c` matches the trailing c, covering the full ID.
```

**Example 2:**
```
Input: s = "xyzw", p = "x.y"
Output: false
Explanation: The pattern describes only three characters and contains no `*` to stretch, so it cannot cover the four-character ID.
```$$
WHERE slug = $$validate-homework-id$$;

-- verify-pizza-rotation
UPDATE problems SET
    description = $$A conveyor oven holds pizzas in slots, with counts given in `trays`. You want the sequence to be non-decreasing.

Return `true` if you can make `trays` non-decreasing by changing **at most one** slot to any integer, and `false` otherwise.

**Example 1:**
```
Input: trays = [3,1,4,5]
Output: true
Explanation: Lowering the first slot to 1 gives [1,1,4,5], which is non-decreasing.
```

**Example 2:**
```
Input: trays = [6,4,2,3]
Output: false
Explanation: Two separate slots are out of order, so one tweak can't fix it.
```$$
WHERE slug = $$verify-pizza-rotation$$;

-- verify-task-order
UPDATE problems SET
    description = $$A group project has `numScenes` tasks numbered `0` to `numScenes - 1`. Each `prereqs[i] = [a, b]` means task `b` must finish before task `a` can start.

Return `true` if some ordering completes every task, or `false` if the dependencies contain a cycle.

**Example 1:**
```
Input: numScenes = 4, prereqs = [[1,0],[2,0],[3,1]]
Output: true
Explanation: Task `0` can go first, then `1` and `2` (which both only need `0`), and finally `3`. No circular dependency exists.
```

**Example 2:**
```
Input: numScenes = 3, prereqs = [[0,2],[2,1],[1,0]]
Output: false
Explanation: Task `0` needs `2`, `2` needs `1`, and `1` needs `0`. The three-way loop means no task can ever start first.
```$$
WHERE slug = $$verify-task-order$$;

-- versioned-cells
UPDATE problems SET
    description = $$You're building save-file support for a sandbox game. The world is a row of numeric cells. You can edit the live row, and you can freeze it as a snapshot to revisit later. All cells start at `0`, and snapshot ids count up from `0`.

Implement the `VersionedCells` class:

- `VersionedCells(int length)` creates a row of `length` cells, all initialized to `0`, with no snapshots taken.
- `void set(int index, int val)` sets the live value at position `index` to `val`. Previously committed snapshots are unchanged.
- `int commit()` freezes the current live row as a new snapshot and returns its id. The first call returns `0`, the second `1`, and so on.
- `int readAt(int index, int snapId)` returns the value of cell `index` in snapshot `snapId`.

**Example:**
```
cells = new VersionedCells(3)
cells.set(0, 5)
cells.commit()        // returns 0; snapshot 0 is [5, 0, 0]
cells.set(0, 6)       // live row is now [6, 0, 0]
cells.readAt(0, 0)    // 5 -- value of cell 0 in snapshot 0
```$$
WHERE slug = $$versioned-cells$$;

-- voucher-price-combos
UPDATE problems SET
    description = $$A cafe voucher lets you pick any combination of items whose prices total exactly `voucher`. `prices` is a list of distinct positive integer prices, and each item can be used any number of times.

Return every unique basket whose prices sum to `voucher`. Each basket is a list of prices (repeats allowed); two baskets differ if any price appears a different number of times. Return baskets in any order.

**Example 1:**
```
Input: prices = [2,4,5], voucher = 9
Output: [[2,2,5],[4,5]]
Explanation: 2 + 2 + 5 = 9 and 4 + 5 = 9 are the only two matching baskets.
```

**Example 2:**
```
Input: prices = [3,4,7], voucher = 10
Output: [[3,3,4],[3,7]]
```$$
WHERE slug = $$voucher-price-combos$$;

-- wildcard-lexicon
UPDATE problems SET
    description = $$Build a cheat-word checker for a word-tile game. Players save favorite words and later test guesses, where `.` matches any single letter. A guess passes if some saved word has the same length and matches position-by-position.

Implement the `WildcardLexicon` class:

- `WildcardLexicon()` starts with no saved words.
- `void enroll(String word)` saves `word` (lowercase letters only). Saving the same word twice is fine.
- `boolean match(String word)` returns `true` if any saved word matches `word` under the wildcard rule, `false` otherwise (including when nothing is saved).

`match` inputs may mix lowercase letters and `.`; `enroll` inputs never contain `.`. Calls can interleave in any order, and `match` never modifies the saved set.$$
WHERE slug = $$wildcard-lexicon$$;

-- word-break-chat
UPDATE problems SET
    description = $$A chat message `headline` has its spaces stripped out. `topics` lists the known slang words.

Return `true` if `headline` can be split into a sequence of one or more words from `topics` (words may repeat), and `false` otherwise.

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
Explanation: Every prefix match leaves a suffix that can't be fully covered — "news" never appears as a prefix of any word, and neither does a trailing "s".
```$$
WHERE slug = $$word-break-chat$$;

-- word-hunt-board
UPDATE problems SET
    description = $$In a word-hunt game you trace words on an `m x n` letter board by stepping between orthogonally adjacent cells (up, down, left, right), never reusing a cell in the same trace.

Given `board` and a target `word`, implement `traceZonePath` to return `true` if some path of adjacent cells spells `word` exactly using each cell at most once, and `false` otherwise.

**Example 1:**
```
Input: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "PEAK"
Output: true
```

**Example 2:**
```
Input: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "NOID"
Output: true
```

**Example 3:**
```
Input: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "PARK"
Output: false
```$$
WHERE slug = $$word-hunt-board$$;

-- zero-out-rows-cols
UPDATE problems SET
    description = $$In a puzzle game, any tile showing `0` wipes its entire row and column. Given an `m x n` grid `board`, modify it **in-place** so every cell that shares a row or column with an original zero becomes `0`.

Cells whose row and column had no zeros keep their original value.

**Example 1:**
```
Input: board = [[2,3],[4,5]]
Output: [[2,3],[4,5]]
Explanation: No zero tiles, so the board is unchanged.
```

**Example 2:**
```
Input: board = [[4,6,8],[2,0,5],[7,9,3]]
Output: [[4,0,8],[0,0,0],[7,0,3]]
Explanation: The zero is at row 1, column 1, so row 1 and column 1 are wiped.
```$$
WHERE slug = $$zero-out-rows-cols$$;

-- zero-sum-trio
UPDATE problems SET
    description = $$A co-op game tracks each player's score delta as a signed integer in `deltas` (negatives mean behind, positives mean ahead).

Return every unique trio of three distinct players whose deltas sum to exactly zero, as `[deltas[i], deltas[j], deltas[k]]`. Each trio appears at most once regardless of which indices produce it. Trios may be returned in any order.

**Example 1:**
```
Input: deltas = [-3,1,2,-2,0,-1,1]
Output: [[-3,1,2],[-2,0,2],[-2,1,1],[-1,0,1]]
Explanation: Four distinct balanced trios exist; each sums to zero.
```

**Example 2:**
```
Input: deltas = [2,3,4]
Output: []
Explanation: Every delta is positive, so no trio sums to zero.
```

**Example 3:**
```
Input: deltas = [0,0,0,0]
Output: [[0,0,0]]
```$$
WHERE slug = $$zero-sum-trio$$;

-- zigzag-yearbook-order
UPDATE problems SET
    description = $$Your class is arranged as a binary tree for a yearbook photo. The photographer reads names row by row, but flips direction each row.

Given `root`, return the node values grouped by level in zigzag order: the top row left-to-right, the next row right-to-left, and so on. Each level is an inner list, the outer list runs top-down, and an empty tree yields an empty list.

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
Explanation: A single student gets their own row.
```$$
WHERE slug = $$zigzag-yearbook-order$$;

