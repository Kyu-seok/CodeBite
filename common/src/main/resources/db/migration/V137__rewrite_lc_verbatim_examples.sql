-- V137: Rewrite description example blocks that were verbatim LC canonical
-- examples. Replaced 27 example blocks across 20 problems with fresh, simple
-- test cases whose outputs have been verified against reference solutions.

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
Input: tags = "(("
Output: false
Explanation: Two openers and nothing to close them — even using stars as empty can't fix it.
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
Input: root = [1,2]
Output: true
Explanation: A root with one child differs in height by exactly one — still balanced.
```$$
WHERE slug = $$balanced-hamster-tree$$;

-- drop-conflicting-classes
UPDATE problems SET
    description = $$You're picking classes for next semester but can only attend one at a time. Each class in `classes` is `[start, end]` in minutes. Two classes conflict only if their windows overlap — touching at the boundary (one ends when the next starts) is fine.

Return the **minimum** number of classes to drop so the rest have no overlap.

**Example 1:**
```
Input: classes = [[10,20],[12,18],[22,30]]
Output: 1
Explanation: Keep [10,20] and [22,30]; drop [12,18] because it sits inside the first slot.
```

**Example 2:**
```
Input: classes = [[1,4],[1,4],[1,4],[1,4]]
Output: 3
Explanation: Four classes share the same slot — keep one, drop the other three.
```

**Example 3:**
```
Input: classes = [[1,5],[6,10]]
Output: 0
Explanation: The two classes are disjoint, so nothing has to go.
```$$
WHERE slug = $$drop-conflicting-classes$$;

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
Input: root = [1]
Output: [1]
Explanation: A single task flattens to a one-node chain.
```

**Example 3:**
```
Input: root = [5]
Output: [5]
```$$
WHERE slug = $$flatten-agenda-tree$$;

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
Input: digits = "2"
Output: ["a","b","c"]
Explanation: Digit 2 maps to the letters a, b, c.
```$$
WHERE slug = $$flip-phone-codes$$;

-- grocery-bag-triple
UPDATE problems SET
    description = $$Each grocery bag has three readings `[produce, dairy, frozen]`. A bag is usable only if none of its readings exceed `target` on any channel. Pick a subset of usable bags whose channel-wise max equals `target` exactly.

Write `canBuildBales(bags, target)` that returns `true` if such a subset exists, else `false`.

**Example 1:**
```
Input: bags = [[1,2,3],[4,2,1],[1,5,3],[2,1,4]], target = [4,5,4]
Output: true
Explanation: Bag 2 reaches channel 0's target of 4, bag 3 reaches channel 1's 5, bag 4 reaches channel 2's 4. Every bag stays within all three caps.
```

**Example 2:**
```
Input: bags = [[1,2,3],[4,5,6]], target = [3,4,5]
Output: false
Explanation: Bag 2 overshoots every channel of target, so it can't be used. Bag 1 alone gives [1,2,3] — channel 2 stops at 3, never reaching 5.
```$$
WHERE slug = $$grocery-bag-triple$$;

-- group-study-cards
UPDATE problems SET
    description = $$A study group wants to deal flashcards into groups of `groupSize` consecutive numbers (like `{7,8,9}` when `groupSize = 3`). Every card must go in exactly one group.

Given the integer array `cards` and the integer `groupSize`, return `true` if the pile can be split this way, else `false`.

**Example 1:**
```
Input: cards = [1,2,3,4,5,6,7,8], groupSize = 2
Output: true
Explanation: Pair them up as [1,2], [3,4], [5,6], [7,8].
```

**Example 2:**
```
Input: cards = [1,2,3,4], groupSize = 3
Output: false
Explanation: Four cards can't split evenly into groups of three.
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
Input: root = [7]
Output: [[7]]
Explanation: Only the root row exists.
```$$
WHERE slug = $$group-tree-by-level$$;

-- kth-top-score-stream
UPDATE problems SET
    description = $$A guild posts raid scores one at a time. Track the `k`-th highest score as each new score arrives. Duplicates keep their own rank, so the `k`-th largest is the value at position `k` in the sorted list.

Build `TopKStream`:

- `TopKStream(int k, int[] scores)` seeds the tracker with rank `k` and a starting batch of raid scores.
- `int record(int val)` adds `val` to the stream and returns the current `k`-th largest score overall.

**Example 1:**
```
Input:
["TopKStream", "record", "record", "record"]
[[2, [100, 50]], [75], [120], [60]]
Output: [null, 75, 100, 100]

Explanation:
TopKStream tracker = new TopKStream(2, [100, 50]);
tracker.record(75);   // stream becomes [100,50,75]; 2nd largest is 75
tracker.record(120);  // stream becomes [100,50,75,120]; 2nd largest is 100
tracker.record(60);   // stream becomes [100,50,75,120,60]; 2nd largest is 100
```

The leaderboard refreshes constantly, so re-sorting everything on each post won't keep up.$$
WHERE slug = $$kth-top-score-stream$$;

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
Input: queues = [[1,3,5],[2,4,6]]
Output: [1,2,3,4,5,6]
Explanation: Two queues interleave into one ordered line.
```

**Example 3:**
```
Input: queues = [[1,4],[2,5],[3,6]]
Output: [1,2,3,4,5,6]
Explanation: Three queues weave together by head value each step.
```$$
WHERE slug = $$merge-cafe-queues$$;

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
Input: runA = [], runB = [2,4,6]
Output: [2,4,6]
Explanation: When one friend didn't play, the other's run carries through unchanged.
```

**Example 3:**
```
Input: runA = [], runB = [3]
Output: [3]
Explanation: Only the second friend has a time.
```$$
WHERE slug = $$merge-leaderboard-runs$$;

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
Input: root = [5]
Output: [5]
Explanation: A single-item menu is already its own mirror.
```$$
WHERE slug = $$mirror-menu-tree$$;

-- nearest-cat-feeder
UPDATE problems SET
    description = $$An `m x n` grid `grid` represents rooms in your apartment complex. Each cell holds one of:

- `-1` — a **locked room** (cats can't pass through)
- `0` — a **feeder room** (food is here)
- `2147483647` — an **open room** to be measured

For each open room, replace its value with the number of 4-directional steps (up, down, left, right) to the nearest feeder, moving only through open rooms. If no feeder is reachable, leave `2147483647`. Update `grid` in place and return it.

**Example 1:**
```
Input: grid = [[2147483647,0],[2147483647,2147483647]]
Output: [[1,0],[2,1]]
Explanation: The only feeder sits at (0,1). Each other cell records its step count from it.
```

**Example 2:**
```
Input: grid = [[0,2147483647,2147483647],[-1,2147483647,-1],[2147483647,2147483647,0]]
Output: [[0,1,2],[-1,2,-1],[2,1,0]]
Explanation: The locked rooms in the middle row force a detour, but every open room still reaches a feeder.
```$$
WHERE slug = $$nearest-cat-feeder$$;

-- rebuild-tournament-line
UPDATE problems SET
    description = $$You're rebuilding the queue at a video-game tournament. Each player is a pair `[h, k]`, where `h` is their height and `k` is the number of players **ahead** of them whose height is at least `h`. The current queue is scrambled.

Given `players`, return the correctly ordered queue as a list of `[h, k]` pairs from front to back. A valid ordering is guaranteed to exist.

**Example 1:**
```
Input: players = [[3,0],[6,0],[6,1],[4,1]]
Output: [[3,0],[6,0],[4,1],[6,1]]
Explanation: Place taller players first: [6,0], [6,1]. Then [4,1] slides in at index 1 (one player of height ≥4 before). [3,0] finally takes index 0 (no taller players before).
```

**Example 2:**
```
Input: players = [[2,0],[5,0],[2,1],[5,1]]
Output: [[2,0],[2,1],[5,0],[5,1]]
Explanation: Start with the two 5s: [5,0], [5,1]. Insert [2,0] at the front and [2,1] right after — each 2 now has the correct count of ≥2 players before it.
```$$
WHERE slug = $$rebuild-tournament-line$$;

-- redundant-friendship
UPDATE problems SET
    description = $$Your class's friendship map over `n` students labeled `1` through `n` was meant to be a tree, but one extra friendship edge was added and now there's exactly one cycle. The edges are given as `links`, where each `links[i] = [a, b]` is an undirected friendship.

Return the edge to remove so the graph becomes a tree again. If more than one edge could break the cycle, return the one that appears **last** in `links`.

**Example 1:**
```
Input: links = [[1,2],[1,3],[2,3]]
Output: [2,3]
Explanation: Edges [1,2] and [1,3] already connect all three. [2,3] is the later edge that closes the cycle.
```

**Example 2:**
```
Input: links = [[1,2],[2,3],[3,4],[4,5],[2,5],[1,6]]
Output: [2,5]
Explanation: The cycle is 2 - 3 - 4 - 5 - 2. Both [3,4] and [2,5] belong to it, but [2,5] appears later, so it's the one to drop.
```$$
WHERE slug = $$redundant-friendship$$;

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
Input: head = [1]
Output: [1]
Explanation: A single song reverses to itself.
```$$
WHERE slug = $$reverse-playlist$$;

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
Input: root = [1,null,2]
Output: [1,2]
Explanation: Each row exposes its rightmost node: 1 on row 0, 2 on row 1.
```$$
WHERE slug = $$right-side-skill-view$$;

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
Input: ward = [[2,0],[0,1]]
Output: -1
Explanation: The rotten donut is walled off by empty cells, so the fresh one never spoils.
```$$
WHERE slug = $$rotting-donuts$$;

-- split-sticker-runs
UPDATE problems SET
    description = $$Partition the string `stickers` into the fewest consecutive chunks such that every distinct letter appears in exactly one chunk. The chunks concatenated must equal `stickers`.

Return the length of each chunk in order.

**Example 1:**
```
Input: stickers = "abacbcd"
Output: [6,1]
Explanation: 'a', 'b', 'c' all finish by position 5, so the first chunk covers 0..5 (6 stickers). 'd' stands alone at the end.
```

**Example 2:**
```
Input: stickers = "rsrsr"
Output: [5]
Explanation: Both 'r' and 's' reappear throughout, so the whole strip is a single chunk.
```$$
WHERE slug = $$split-sticker-runs$$;

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
["PrefixIndex", "insert", "insert", "search", "search", "startsWith", "search", "startsWith"]
[[], ["cat"], ["car"], ["cat"], ["ca"], ["ca"], ["car"], ["dog"]]
Output: [null, null, null, true, false, true, true, false]
```

After inserting `"cat"` and `"car"`, `search("cat")` is `true`, but `search("ca")` is `false` because `"ca"` was never registered as a full username — it is only a shared prefix. `startsWith("ca")` is still `true`. `startsWith("dog")` is `false` because no inserted username starts with `"dog"`.$$
WHERE slug = $$username-trie$$;

