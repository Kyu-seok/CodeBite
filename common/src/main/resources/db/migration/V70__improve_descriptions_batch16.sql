-- Improve descriptions: batch 16

------------------------------------------------------------
-- symbol-order
------------------------------------------------------------
UPDATE problems
SET description = 'You are given a list of words sorted according to the alphabetical order of an unknown language. The language uses the same lowercase English letters as English, but the characters may be ordered differently.

Analyze the sorted word list to determine the character ordering in this language. Return a string containing the characters arranged in the correct order for this language. If no valid ordering exists (for example, the input contains contradictory rules), return an empty string `""`.

If a longer word appears before a word that is its prefix (e.g., `"abc"` before `"ab"`), the ordering is invalid because a prefix must always come first in a sorted list.

**Example 1:**
```
Input: words = ["wrt","wrf","er","ett","rftt"]
Output: "wertf"
Explanation: Comparing adjacent pairs gives us: t before f, w before e, r before t, and e before r. Combining these yields the order w -> e -> r -> t -> f.
```

**Example 2:**
```
Input: words = ["z","x"]
Output: "zx"
Explanation: From the pair z, x we learn that z comes before x in this language.
```

**Example 3:**
```
Input: words = ["abc","ab"]
Output: ""
Explanation: "abc" appears before "ab", but "ab" is a prefix of "abc". A shorter prefix must come first in a valid ordering, so this input is contradictory.
```'
WHERE slug = 'symbol-order';

UPDATE problem_translations
SET description = 'You are given a list of words sorted according to the alphabetical order of an unknown language. The language uses the same lowercase English letters as English, but the characters may be ordered differently.

Analyze the sorted word list to determine the character ordering in this language. Return a string containing the characters arranged in the correct order for this language. If no valid ordering exists (for example, the input contains contradictory rules), return an empty string `""`.

If a longer word appears before a word that is its prefix (e.g., `"abc"` before `"ab"`), the ordering is invalid because a prefix must always come first in a sorted list.

**Example 1:**
```
Input: words = ["wrt","wrf","er","ett","rftt"]
Output: "wertf"
Explanation: Comparing adjacent pairs gives us: t before f, w before e, r before t, and e before r. Combining these yields the order w -> e -> r -> t -> f.
```

**Example 2:**
```
Input: words = ["z","x"]
Output: "zx"
Explanation: From the pair z, x we learn that z comes before x in this language.
```

**Example 3:**
```
Input: words = ["abc","ab"]
Output: ""
Explanation: "abc" appears before "ab", but "ab" is a prefix of "abc". A shorter prefix must come first in a valid ordering, so this input is contradictory.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'symbol-order')
  AND locale = 'en';

------------------------------------------------------------
-- extra-edge
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an undirected graph that was originally a tree with `n` nodes labeled from `1` to `n`. One additional edge was then added, creating exactly one cycle. The graph is represented as an array `edges` where `edges[i] = [a, b]` indicates an undirected connection between nodes `a` and `b`.

Find and return the extra edge that, when removed, restores the graph to a valid tree. If multiple edges could be removed to break the cycle, return the one that appears **last** in the `edges` array.

**Example 1:**
```
Input: edges = [[1,2],[1,3],[2,3]]
Output: [2,3]
Explanation: The tree originally connected 1-2 and 1-3. The edge [2,3] creates a cycle 1-2-3-1.
```

**Example 2:**
```
Input: edges = [[1,2],[2,3],[3,4],[1,4],[1,5]]
Output: [1,4]
Explanation: Removing [1,4] breaks the cycle 1-2-3-4-1 and restores a valid tree.
```

**Example 3:**
```
Input: edges = [[1,2],[1,3],[1,4],[3,4]]
Output: [3,4]
Explanation: The edge [3,4] forms a cycle with the paths through node 1.
```'
WHERE slug = 'extra-edge';

UPDATE problem_translations
SET description = 'You are given an undirected graph that was originally a tree with `n` nodes labeled from `1` to `n`. One additional edge was then added, creating exactly one cycle. The graph is represented as an array `edges` where `edges[i] = [a, b]` indicates an undirected connection between nodes `a` and `b`.

Find and return the extra edge that, when removed, restores the graph to a valid tree. If multiple edges could be removed to break the cycle, return the one that appears **last** in the `edges` array.

**Example 1:**
```
Input: edges = [[1,2],[1,3],[2,3]]
Output: [2,3]
Explanation: The tree originally connected 1-2 and 1-3. The edge [2,3] creates a cycle 1-2-3-1.
```

**Example 2:**
```
Input: edges = [[1,2],[2,3],[3,4],[1,4],[1,5]]
Output: [1,4]
Explanation: Removing [1,4] breaks the cycle 1-2-3-4-1 and restores a valid tree.
```

**Example 3:**
```
Input: edges = [[1,2],[1,3],[1,4],[3,4]]
Output: [3,4]
Explanation: The edge [3,4] forms a cycle with the paths through node 1.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'extra-edge')
  AND locale = 'en';

------------------------------------------------------------
-- airport-route
------------------------------------------------------------
UPDATE problems
SET description = 'You are given a list of airline `tickets`, where each ticket is represented as `[departure, arrival]` using three-letter airport codes. All tickets belong to a single traveler whose journey starts at `"JFK"`.

Reconstruct the complete travel itinerary that uses every ticket exactly once. If multiple valid itineraries exist, return the one that is **lexicographically smallest** when compared step by step.

The input guarantees that at least one valid itinerary exists.

**Example 1:**
```
Input: tickets = [["MUC","LHR"],["JFK","MUC"],["SFO","SJC"],["LHR","SFO"]]
Output: ["JFK","MUC","LHR","SFO","SJC"]
Explanation: The journey is JFK -> MUC -> LHR -> SFO -> SJC, using all four tickets.
```

**Example 2:**
```
Input: tickets = [["JFK","SFO"],["JFK","ATL"],["SFO","ATL"],["ATL","JFK"],["ATL","SFO"]]
Output: ["JFK","ATL","JFK","SFO","ATL","SFO"]
Explanation: Although ["JFK","SFO","ATL","JFK","ATL","SFO"] also uses all tickets, the answer ["JFK","ATL",...] is lexicographically smaller because "ATL" < "SFO" at the second position.
```

**Example 3:**
```
Input: tickets = [["JFK","KUL"],["JFK","NRT"],["NRT","JFK"]]
Output: ["JFK","NRT","JFK","KUL"]
Explanation: Choosing JFK -> KUL first would leave us stuck, so the valid path is JFK -> NRT -> JFK -> KUL.
```'
WHERE slug = 'airport-route';

UPDATE problem_translations
SET description = 'You are given a list of airline `tickets`, where each ticket is represented as `[departure, arrival]` using three-letter airport codes. All tickets belong to a single traveler whose journey starts at `"JFK"`.

Reconstruct the complete travel itinerary that uses every ticket exactly once. If multiple valid itineraries exist, return the one that is **lexicographically smallest** when compared step by step.

The input guarantees that at least one valid itinerary exists.

**Example 1:**
```
Input: tickets = [["MUC","LHR"],["JFK","MUC"],["SFO","SJC"],["LHR","SFO"]]
Output: ["JFK","MUC","LHR","SFO","SJC"]
Explanation: The journey is JFK -> MUC -> LHR -> SFO -> SJC, using all four tickets.
```

**Example 2:**
```
Input: tickets = [["JFK","SFO"],["JFK","ATL"],["SFO","ATL"],["ATL","JFK"],["ATL","SFO"]]
Output: ["JFK","ATL","JFK","SFO","ATL","SFO"]
Explanation: Although ["JFK","SFO","ATL","JFK","ATL","SFO"] also uses all tickets, the answer ["JFK","ATL",...] is lexicographically smaller because "ATL" < "SFO" at the second position.
```

**Example 3:**
```
Input: tickets = [["JFK","KUL"],["JFK","NRT"],["NRT","JFK"]]
Output: ["JFK","NRT","JFK","KUL"]
Explanation: Choosing JFK -> KUL first would leave us stuck, so the valid path is JFK -> NRT -> JFK -> KUL.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'airport-route')
  AND locale = 'en';

------------------------------------------------------------
-- longest-palindrome
------------------------------------------------------------
UPDATE problems
SET description = 'Given a string `s`, return the length of the longest **palindromic substring**.

A **palindromic substring** is a contiguous sequence of characters within `s` that reads the same forwards and backwards. For example, `"racecar"` is a palindrome, while `"hello"` is not.

**Example 1:**
```
Input: s = "babad"
Output: 3
Explanation: "bab" is a palindromic substring of length 3. "aba" is also valid.
```

**Example 2:**
```
Input: s = "cbbd"
Output: 2
Explanation: "bb" is the longest palindromic substring.
```

**Example 3:**
```
Input: s = "x"
Output: 1
Explanation: Every single character is a palindrome.
```'
WHERE slug = 'longest-palindrome';

UPDATE problem_translations
SET description = 'Given a string `s`, return the length of the longest **palindromic substring**.

A **palindromic substring** is a contiguous sequence of characters within `s` that reads the same forwards and backwards. For example, `"racecar"` is a palindrome, while `"hello"` is not.

**Example 1:**
```
Input: s = "babad"
Output: 3
Explanation: "bab" is a palindromic substring of length 3. "aba" is also valid.
```

**Example 2:**
```
Input: s = "cbbd"
Output: 2
Explanation: "bb" is the longest palindromic substring.
```

**Example 3:**
```
Input: s = "x"
Output: 1
Explanation: Every single character is a palindrome.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-palindrome')
  AND locale = 'en';

------------------------------------------------------------
-- cheap-stairs
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an integer array `cost` where `cost[i]` is the toll to step on the `i`-th stair. Once you pay the toll for a stair, you can climb either one or two stairs forward.

You may start from stair `0` or stair `1`. The **top** of the staircase is the position just beyond the last element of `cost` (i.e., index `cost.length`).

Return the minimum total cost to reach the top.

**Example 1:**
```
Input: cost = [10,15,20]
Output: 15
Explanation: Start at stair 1 (cost 15), then climb two stairs to the top. Total = 15.
```

**Example 2:**
```
Input: cost = [1,100,1,1,1,100,1,1,100,1]
Output: 6
Explanation: Start at stair 0, then step on stairs 2, 3, 5 is skipped by jumping from 4 to 6, then 7 to 9. Total = 1 + 1 + 1 + 1 + 1 + 1 = 6.
```

**Example 3:**
```
Input: cost = [0,0]
Output: 0
Explanation: Start at either stair and jump to the top for free.
```'
WHERE slug = 'cheap-stairs';

UPDATE problem_translations
SET description = 'You are given an integer array `cost` where `cost[i]` is the toll to step on the `i`-th stair. Once you pay the toll for a stair, you can climb either one or two stairs forward.

You may start from stair `0` or stair `1`. The **top** of the staircase is the position just beyond the last element of `cost` (i.e., index `cost.length`).

Return the minimum total cost to reach the top.

**Example 1:**
```
Input: cost = [10,15,20]
Output: 15
Explanation: Start at stair 1 (cost 15), then climb two stairs to the top. Total = 15.
```

**Example 2:**
```
Input: cost = [1,100,1,1,1,100,1,1,100,1]
Output: 6
Explanation: Start at stair 0, then step on stairs 2, 3, 5 is skipped by jumping from 4 to 6, then 7 to 9. Total = 1 + 1 + 1 + 1 + 1 + 1 = 6.
```

**Example 3:**
```
Input: cost = [0,0]
Output: 0
Explanation: Start at either stair and jump to the top for free.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cheap-stairs')
  AND locale = 'en';

------------------------------------------------------------
-- equal-partition
------------------------------------------------------------
UPDATE problems
SET description = 'Given a non-empty array of positive integers `nums`, determine whether it can be split into two subsets with equal sums.

A subset is any selection of elements from the array (each element may be used at most once). The two subsets do not need to be contiguous or equal in size -- they only need to have the same total sum, and together they must include every element.

Return `true` if such a partition exists, or `false` otherwise.

**Example 1:**
```
Input: nums = [1,5,11,5]
Output: true
Explanation: The array can be split into [1,5,5] and [11], both summing to 11.
```

**Example 2:**
```
Input: nums = [1,2,3,5]
Output: false
Explanation: There is no way to divide the array into two equal-sum subsets.
```

**Example 3:**
```
Input: nums = [1,1]
Output: true
Explanation: Each subset contains a single 1, and both sums are equal.
```'
WHERE slug = 'equal-partition';

UPDATE problem_translations
SET description = 'Given a non-empty array of positive integers `nums`, determine whether it can be split into two subsets with equal sums.

A subset is any selection of elements from the array (each element may be used at most once). The two subsets do not need to be contiguous or equal in size -- they only need to have the same total sum, and together they must include every element.

Return `true` if such a partition exists, or `false` otherwise.

**Example 1:**
```
Input: nums = [1,5,11,5]
Output: true
Explanation: The array can be split into [1,5,5] and [11], both summing to 11.
```

**Example 2:**
```
Input: nums = [1,2,3,5]
Output: false
Explanation: There is no way to divide the array into two equal-sum subsets.
```

**Example 3:**
```
Input: nums = [1,1]
Output: true
Explanation: Each subset contains a single 1, and both sums are equal.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'equal-partition')
  AND locale = 'en';

------------------------------------------------------------
-- perfect-sum
------------------------------------------------------------
UPDATE problems
SET description = 'Given a positive integer `n`, return the fewest number of **perfect square** numbers that sum to `n`.

A **perfect square** is an integer that equals some integer squared. The first few perfect squares are `1`, `4`, `9`, `16`, `25`, and so on. You may reuse the same perfect square multiple times.

**Example 1:**
```
Input: n = 12
Output: 3
Explanation: 12 = 4 + 4 + 4 (three perfect squares).
```

**Example 2:**
```
Input: n = 13
Output: 2
Explanation: 13 = 4 + 9 (two perfect squares).
```

**Example 3:**
```
Input: n = 1
Output: 1
Explanation: 1 is itself a perfect square.
```'
WHERE slug = 'perfect-sum';

UPDATE problem_translations
SET description = 'Given a positive integer `n`, return the fewest number of **perfect square** numbers that sum to `n`.

A **perfect square** is an integer that equals some integer squared. The first few perfect squares are `1`, `4`, `9`, `16`, `25`, and so on. You may reuse the same perfect square multiple times.

**Example 1:**
```
Input: n = 12
Output: 3
Explanation: 12 = 4 + 4 + 4 (three perfect squares).
```

**Example 2:**
```
Input: n = 13
Output: 2
Explanation: 13 = 4 + 9 (two perfect squares).
```

**Example 3:**
```
Input: n = 1
Output: 1
Explanation: 1 is itself a perfect square.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'perfect-sum')
  AND locale = 'en';

------------------------------------------------------------
-- nth-ugly
------------------------------------------------------------
UPDATE problems
SET description = 'An **ugly number** is a positive integer whose only prime factors are `2`, `3`, and `5`. By convention, `1` is considered the first ugly number (it has no prime factors at all).

Given an integer `n`, return the `n`-th ugly number in ascending order.

The sequence begins: `1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, 24, ...`

Note that `7` is not in the sequence because `7` is a prime factor other than `2`, `3`, or `5`.

**Example 1:**
```
Input: n = 10
Output: 12
Explanation: The first 10 ugly numbers are 1, 2, 3, 4, 5, 6, 8, 9, 10, 12.
```

**Example 2:**
```
Input: n = 1
Output: 1
Explanation: 1 is the first ugly number by definition.
```

**Example 3:**
```
Input: n = 15
Output: 24
Explanation: The first 15 ugly numbers are 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, 24.
```'
WHERE slug = 'nth-ugly';

UPDATE problem_translations
SET description = 'An **ugly number** is a positive integer whose only prime factors are `2`, `3`, and `5`. By convention, `1` is considered the first ugly number (it has no prime factors at all).

Given an integer `n`, return the `n`-th ugly number in ascending order.

The sequence begins: `1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, 24, ...`

Note that `7` is not in the sequence because `7` is a prime factor other than `2`, `3`, or `5`.

**Example 1:**
```
Input: n = 10
Output: 12
Explanation: The first 10 ugly numbers are 1, 2, 3, 4, 5, 6, 8, 9, 10, 12.
```

**Example 2:**
```
Input: n = 1
Output: 1
Explanation: 1 is the first ugly number by definition.
```

**Example 3:**
```
Input: n = 15
Output: 24
Explanation: The first 15 ugly numbers are 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, 24.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'nth-ugly')
  AND locale = 'en';

------------------------------------------------------------
-- room-builder
------------------------------------------------------------
UPDATE problems
SET description = 'You are constructing a building with `n` rooms numbered from `0` to `n - 1`. The rooms have a tree-shaped dependency structure: each room (except room `0`) has exactly one prerequisite room that must be built before it. Room `0` is the root and has no prerequisite.

You are given an array `prevRoom` of length `n`, where `prevRoom[i]` is the room that must be completed before room `i` can be built. `prevRoom[0] = -1` since room `0` has no prerequisite.

Return the number of **distinct valid build orders** for all `n` rooms. Since the answer may be very large, return it modulo `10^9 + 7`.

**Example 1:**
```
Input: prevRoom = [-1,0,0,1,1]
Output: 8
Explanation: Room 0 must be built first. Then rooms 1 and 2 can be built in any relative order, but rooms 3 and 4 require room 1 first. There are 8 valid orderings.
```

**Example 2:**
```
Input: prevRoom = [-1,0,1,2]
Output: 1
Explanation: The rooms form a chain 0 -> 1 -> 2 -> 3, so there is only one valid build order.
```

**Example 3:**
```
Input: prevRoom = [-1,0,0,0]
Output: 6
Explanation: Room 0 must be built first, and then the three remaining rooms can be built in any of 3! = 6 orderings.
```'
WHERE slug = 'room-builder';

UPDATE problem_translations
SET description = 'You are constructing a building with `n` rooms numbered from `0` to `n - 1`. The rooms have a tree-shaped dependency structure: each room (except room `0`) has exactly one prerequisite room that must be built before it. Room `0` is the root and has no prerequisite.

You are given an array `prevRoom` of length `n`, where `prevRoom[i]` is the room that must be completed before room `i` can be built. `prevRoom[0] = -1` since room `0` has no prerequisite.

Return the number of **distinct valid build orders** for all `n` rooms. Since the answer may be very large, return it modulo `10^9 + 7`.

**Example 1:**
```
Input: prevRoom = [-1,0,0,1,1]
Output: 8
Explanation: Room 0 must be built first. Then rooms 1 and 2 can be built in any relative order, but rooms 3 and 4 require room 1 first. There are 8 valid orderings.
```

**Example 2:**
```
Input: prevRoom = [-1,0,1,2]
Output: 1
Explanation: The rooms form a chain 0 -> 1 -> 2 -> 3, so there is only one valid build order.
```

**Example 3:**
```
Input: prevRoom = [-1,0,0,0]
Output: 6
Explanation: Room 0 must be built first, and then the three remaining rooms can be built in any of 3! = 6 orderings.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'room-builder')
  AND locale = 'en';

------------------------------------------------------------
-- break-integer
------------------------------------------------------------
UPDATE problems
SET description = 'Given a positive integer `n`, break it into the sum of at least two positive integers and return the **maximum product** of those parts.

You must split `n` into two or more positive integers that sum to `n`. Among all such splits, find the one where the product of the parts is as large as possible.

**Example 1:**
```
Input: n = 2
Output: 1
Explanation: 2 = 1 + 1, and 1 x 1 = 1.
```

**Example 2:**
```
Input: n = 7
Output: 12
Explanation: 7 = 3 + 4, and 3 x 4 = 12.
```

**Example 3:**
```
Input: n = 10
Output: 36
Explanation: 10 = 3 + 3 + 4, and 3 x 3 x 4 = 36.
```'
WHERE slug = 'break-integer';

UPDATE problem_translations
SET description = 'Given a positive integer `n`, break it into the sum of at least two positive integers and return the **maximum product** of those parts.

You must split `n` into two or more positive integers that sum to `n`. Among all such splits, find the one where the product of the parts is as large as possible.

**Example 1:**
```
Input: n = 2
Output: 1
Explanation: 2 = 1 + 1, and 1 x 1 = 1.
```

**Example 2:**
```
Input: n = 7
Output: 12
Explanation: 7 = 3 + 4, and 3 x 4 = 12.
```

**Example 3:**
```
Input: n = 10
Output: 36
Explanation: 10 = 3 + 3 + 4, and 3 x 3 x 4 = 36.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'break-integer')
  AND locale = 'en';
