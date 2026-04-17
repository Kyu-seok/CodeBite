-- Improve descriptions: batch 14

------------------------------------------------------------
-- feed-designer
------------------------------------------------------------
UPDATE problems
SET description = 'Design a simple social feed system that supports posting messages, following and unfollowing users, and retrieving a personalized news feed.

Implement the `FeedDesigner` class with the following methods:

- `FeedDesigner()` initializes the feed system.
- `postMessage(userId, messageId)` creates a new message with the given `messageId`, posted by user `userId`. Each `messageId` is unique.
- `getNewsFeed(userId)` returns a list of the **10 most recent** message IDs in the user''s news feed. The feed includes messages posted by the user and by anyone they follow. Messages are ordered from most recent to least recent.
- `follow(followerId, followeeId)` makes user `followerId` start following user `followeeId`. If `followerId == followeeId`, do nothing.
- `unfollow(followerId, followeeId)` makes user `followerId` stop following user `followeeId`. If `followerId == followeeId`, do nothing.

**Example 1:**
```
Input: ["FeedDesigner","postMessage","postMessage","getNewsFeed"]
       [[],[1,10],[1,20],[1]]
Output: [null,null,null,[20,10]]
Explanation: User 1 posts two messages. Their feed shows the most recent first.
```

**Example 2:**
```
Input: ["FeedDesigner","postMessage","postMessage","follow","getNewsFeed"]
       [[],[1,10],[2,20],[1,2],[1]]
Output: [null,null,null,null,[20,10]]
Explanation: User 1 follows user 2. User 1''s feed now includes user 2''s posts.
```

**Example 3:**
```
Input: ["FeedDesigner","postMessage","postMessage","follow","getNewsFeed","unfollow","getNewsFeed"]
       [[],[1,10],[2,20],[1,2],[1],[1,2],[1]]
Output: [null,null,null,null,[20,10],null,[10]]
Explanation: After unfollowing user 2, user 1''s feed no longer shows user 2''s messages.
```',
    constraints = '1 <= userId, followerId, followeeId <= 500
0 <= messageId <= 10^4
At most 3 * 10^4 calls total across all methods'
WHERE slug = 'feed-designer';

UPDATE problem_translations
SET description = 'Design a simple social feed system that supports posting messages, following and unfollowing users, and retrieving a personalized news feed.

Implement the `FeedDesigner` class with the following methods:

- `FeedDesigner()` initializes the feed system.
- `postMessage(userId, messageId)` creates a new message with the given `messageId`, posted by user `userId`. Each `messageId` is unique.
- `getNewsFeed(userId)` returns a list of the **10 most recent** message IDs in the user''s news feed. The feed includes messages posted by the user and by anyone they follow. Messages are ordered from most recent to least recent.
- `follow(followerId, followeeId)` makes user `followerId` start following user `followeeId`. If `followerId == followeeId`, do nothing.
- `unfollow(followerId, followeeId)` makes user `followerId` stop following user `followeeId`. If `followerId == followeeId`, do nothing.

**Example 1:**
```
Input: ["FeedDesigner","postMessage","postMessage","getNewsFeed"]
       [[],[1,10],[1,20],[1]]
Output: [null,null,null,[20,10]]
Explanation: User 1 posts two messages. Their feed shows the most recent first.
```

**Example 2:**
```
Input: ["FeedDesigner","postMessage","postMessage","follow","getNewsFeed"]
       [[],[1,10],[2,20],[1,2],[1]]
Output: [null,null,null,null,[20,10]]
Explanation: User 1 follows user 2. User 1''s feed now includes user 2''s posts.
```

**Example 3:**
```
Input: ["FeedDesigner","postMessage","postMessage","follow","getNewsFeed","unfollow","getNewsFeed"]
       [[],[1,10],[2,20],[1,2],[1],[1,2],[1]]
Output: [null,null,null,null,[20,10],null,[10]]
Explanation: After unfollowing user 2, user 1''s feed no longer shows user 2''s messages.
```',
    constraints = '1 <= userId, followerId, followeeId <= 500
0 <= messageId <= 10^4
At most 3 * 10^4 calls total across all methods'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'feed-designer')
  AND locale = 'en';

------------------------------------------------------------
-- running-median
------------------------------------------------------------
UPDATE problems
SET description = 'Design a data structure that supports adding integers one at a time and efficiently retrieving the **median** of all elements added so far.

Implement the `MedianTracker` class:

- `MedianTracker()` initializes the data structure.
- `addNum(num)` adds the integer `num` to the collection.
- `findMedian()` returns the median of all elements added so far. If the total count is even, return the average of the two middle values as a floating-point number.

**Example 1:**
```
Input: ["MedianTracker","addNum","findMedian","addNum","findMedian","addNum","findMedian"]
       [[],[1],[],[2],[],[3],[]]
Output: [null,null,1.0,null,1.5,null,2.0]
Explanation: After adding 1, the median is 1.0. After adding 2, the median of [1, 2] is 1.5. After adding 3, the median of [1, 2, 3] is 2.0.
```

**Example 2:**
```
Input: ["MedianTracker","addNum","addNum","addNum","addNum","findMedian"]
       [[],[4],[2],[5],[3],[]]
Output: [null,null,null,null,null,3.5]
Explanation: The sorted collection is [2, 3, 4, 5]. The median of four elements is (3 + 4) / 2 = 3.5.
```

**Example 3:**
```
Input: ["MedianTracker","addNum","findMedian","addNum","findMedian"]
       [[],[7],[],[3],[]]
Output: [null,null,7.0,null,5.0]
Explanation: After adding 7, the median is 7.0. After adding 3, the median of [3, 7] is (3 + 7) / 2 = 5.0.
```'
WHERE slug = 'running-median';

UPDATE problem_translations
SET description = 'Design a data structure that supports adding integers one at a time and efficiently retrieving the **median** of all elements added so far.

Implement the `MedianTracker` class:

- `MedianTracker()` initializes the data structure.
- `addNum(num)` adds the integer `num` to the collection.
- `findMedian()` returns the median of all elements added so far. If the total count is even, return the average of the two middle values as a floating-point number.

**Example 1:**
```
Input: ["MedianTracker","addNum","findMedian","addNum","findMedian","addNum","findMedian"]
       [[],[1],[],[2],[],[3],[]]
Output: [null,null,1.0,null,1.5,null,2.0]
Explanation: After adding 1, the median is 1.0. After adding 2, the median of [1, 2] is 1.5. After adding 3, the median of [1, 2, 3] is 2.0.
```

**Example 2:**
```
Input: ["MedianTracker","addNum","addNum","addNum","addNum","findMedian"]
       [[],[4],[2],[5],[3],[]]
Output: [null,null,null,null,null,3.5]
Explanation: The sorted collection is [2, 3, 4, 5]. The median of four elements is (3 + 4) / 2 = 3.5.
```

**Example 3:**
```
Input: ["MedianTracker","addNum","findMedian","addNum","findMedian"]
       [[],[7],[],[3],[]]
Output: [null,null,7.0,null,5.0]
Explanation: After adding 7, the median is 7.0. After adding 3, the median of [3, 7] is (3 + 7) / 2 = 5.0.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'running-median')
  AND locale = 'en';

------------------------------------------------------------
-- rearrange-letters
------------------------------------------------------------
UPDATE problems
SET description = 'Given a string `s`, rearrange its characters so that no two **adjacent** characters are the same.

Return any valid rearrangement of the string. If no valid rearrangement exists, return an empty string `""`.

**Example 1:**
```
Input: s = "aab"
Output: "aba"
```

**Example 2:**
```
Input: s = "aaab"
Output: ""
Explanation: No matter how the letters are arranged, two ''a''s will always be next to each other.
```

**Example 3:**
```
Input: s = "aabb"
Output: "abab"
```'
WHERE slug = 'rearrange-letters';

UPDATE problem_translations
SET description = 'Given a string `s`, rearrange its characters so that no two **adjacent** characters are the same.

Return any valid rearrangement of the string. If no valid rearrangement exists, return an empty string `""`.

**Example 1:**
```
Input: s = "aab"
Output: "aba"
```

**Example 2:**
```
Input: s = "aaab"
Output: ""
Explanation: No matter how the letters are arranged, two ''a''s will always be next to each other.
```

**Example 3:**
```
Input: s = "aabb"
Output: "abab"
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rearrange-letters')
  AND locale = 'en';

------------------------------------------------------------
-- frequent-words
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of strings `words` and an integer `k`, return the `k` most frequently occurring words.

The result should be sorted by frequency in **descending** order. If two or more words have the same frequency, sort them in **alphabetical** order.

**Example 1:**
```
Input: words = ["apple","banana","apple","cherry","banana","apple"], k = 2
Output: ["apple","banana"]
Explanation: "apple" appears 3 times, "banana" appears 2 times. These are the 2 most frequent words.
```

**Example 2:**
```
Input: words = ["yes","yes","no","no","maybe"], k = 3
Output: ["no","yes","maybe"]
Explanation: "yes" and "no" both appear 2 times, so they are ordered alphabetically. "maybe" appears once.
```

**Example 3:**
```
Input: words = ["hello","world","hello"], k = 1
Output: ["hello"]
```'
WHERE slug = 'frequent-words';

UPDATE problem_translations
SET description = 'Given an array of strings `words` and an integer `k`, return the `k` most frequently occurring words.

The result should be sorted by frequency in **descending** order. If two or more words have the same frequency, sort them in **alphabetical** order.

**Example 1:**
```
Input: words = ["apple","banana","apple","cherry","banana","apple"], k = 2
Output: ["apple","banana"]
Explanation: "apple" appears 3 times, "banana" appears 2 times. These are the 2 most frequent words.
```

**Example 2:**
```
Input: words = ["yes","yes","no","no","maybe"], k = 3
Output: ["no","yes","maybe"]
Explanation: "yes" and "no" both appear 2 times, so they are ordered alphabetically. "maybe" appears once.
```

**Example 3:**
```
Input: words = ["hello","world","hello"], k = 1
Output: ["hello"]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'frequent-words')
  AND locale = 'en';

------------------------------------------------------------
-- unique-subsets
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums` that may contain **duplicate** values, return all possible subsets (the power set).

The result must not contain duplicate subsets. You may return the subsets in any order.

**Example 1:**
```
Input: nums = [1,2,2]
Output: [[],[1],[1,2],[1,2,2],[2],[2,2]]
```

**Example 2:**
```
Input: nums = [0]
Output: [[],[0]]
```

**Example 3:**
```
Input: nums = [4,4,4,1,4]
Output: [[],[1],[1,4],[1,4,4],[1,4,4,4],[1,4,4,4,4],[4],[4,4],[4,4,4],[4,4,4,4]]
Explanation: Despite duplicates in the input, each subset appears only once.
```'
WHERE slug = 'unique-subsets';

UPDATE problem_translations
SET description = 'Given an integer array `nums` that may contain **duplicate** values, return all possible subsets (the power set).

The result must not contain duplicate subsets. You may return the subsets in any order.

**Example 1:**
```
Input: nums = [1,2,2]
Output: [[],[1],[1,2],[1,2,2],[2],[2,2]]
```

**Example 2:**
```
Input: nums = [0]
Output: [[],[0]]
```

**Example 3:**
```
Input: nums = [4,4,4,1,4]
Output: [[],[1],[1,4],[1,4,4],[1,4,4,4],[1,4,4,4,4],[4],[4,4],[4,4,4],[4,4,4,4]]
Explanation: Despite duplicates in the input, each subset appears only once.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-subsets')
  AND locale = 'en';

------------------------------------------------------------
-- unique-combinations
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of integers `candidates` that may contain duplicates and a `target` number, find all unique combinations in `candidates` where the chosen values sum to `target`.

Each number in `candidates` may only be used **once** per combination. The result must not contain duplicate combinations.

**Example 1:**
```
Input: candidates = [10,1,2,7,6,1,5], target = 8
Output: [[1,1,6],[1,2,5],[1,7],[2,6]]
```

**Example 2:**
```
Input: candidates = [2,5,2,1,2], target = 5
Output: [[1,2,2],[5]]
```

**Example 3:**
```
Input: candidates = [1,1,1,1], target = 2
Output: [[1,1]]
Explanation: Although 1 appears four times, the only way to reach 2 is by picking two 1s. Duplicate combinations are excluded.
```'
WHERE slug = 'unique-combinations';

UPDATE problem_translations
SET description = 'Given an array of integers `candidates` that may contain duplicates and a `target` number, find all unique combinations in `candidates` where the chosen values sum to `target`.

Each number in `candidates` may only be used **once** per combination. The result must not contain duplicate combinations.

**Example 1:**
```
Input: candidates = [10,1,2,7,6,1,5], target = 8
Output: [[1,1,6],[1,2,5],[1,7],[2,6]]
```

**Example 2:**
```
Input: candidates = [2,5,2,1,2], target = 5
Output: [[1,2,2],[5]]
```

**Example 3:**
```
Input: candidates = [1,1,1,1], target = 2
Output: [[1,1]]
Explanation: Although 1 appears four times, the only way to reach 2 is by picking two 1s. Duplicate combinations are excluded.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-combinations')
  AND locale = 'en';

------------------------------------------------------------
-- palindrome-split
------------------------------------------------------------
UPDATE problems
SET description = 'Given a string `s`, partition it into substrings where **every** substring is a palindrome. Return all possible palindrome partitions.

Each partition must cover the entire string from left to right without reordering characters. You may return the partitions in any order.

**Example 1:**
```
Input: s = "aab"
Output: [["a","a","b"],["aa","b"]]
```

**Example 2:**
```
Input: s = "a"
Output: [["a"]]
```

**Example 3:**
```
Input: s = "aba"
Output: [["a","b","a"],["aba"]]
Explanation: Both "a", "b", "a" (each single character) and "aba" (the whole string) are valid palindrome partitions.
```'
WHERE slug = 'palindrome-split';

UPDATE problem_translations
SET description = 'Given a string `s`, partition it into substrings where **every** substring is a palindrome. Return all possible palindrome partitions.

Each partition must cover the entire string from left to right without reordering characters. You may return the partitions in any order.

**Example 1:**
```
Input: s = "aab"
Output: [["a","a","b"],["aa","b"]]
```

**Example 2:**
```
Input: s = "a"
Output: [["a"]]
```

**Example 3:**
```
Input: s = "aba"
Output: [["a","b","a"],["aba"]]
Explanation: Both "a", "b", "a" (each single character) and "aba" (the whole string) are valid palindrome partitions.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'palindrome-split')
  AND locale = 'en';

------------------------------------------------------------
-- ip-builder
------------------------------------------------------------
UPDATE problems
SET description = 'Given a string `s` containing only digits, return all possible valid **IPv4 addresses** that can be formed by inserting exactly three dots into the string.

A valid IPv4 address consists of exactly four integers (called **octets**), each ranging from `0` to `255`, separated by dots. An octet must not have leading zeros unless the octet itself is `"0"`.

Return the results sorted in lexicographic order.

**Example 1:**
```
Input: s = "25525511135"
Output: ["255.255.11.135","255.255.111.35"]
```

**Example 2:**
```
Input: s = "0000"
Output: ["0.0.0.0"]
```

**Example 3:**
```
Input: s = "101023"
Output: ["1.0.10.23","1.0.102.3","10.1.0.23","10.10.2.3","10.102.0.3","101.0.2.3","101.0.23.0"]
```'
WHERE slug = 'ip-builder';

UPDATE problem_translations
SET description = 'Given a string `s` containing only digits, return all possible valid **IPv4 addresses** that can be formed by inserting exactly three dots into the string.

A valid IPv4 address consists of exactly four integers (called **octets**), each ranging from `0` to `255`, separated by dots. An octet must not have leading zeros unless the octet itself is `"0"`.

Return the results sorted in lexicographic order.

**Example 1:**
```
Input: s = "25525511135"
Output: ["255.255.11.135","255.255.111.35"]
```

**Example 2:**
```
Input: s = "0000"
Output: ["0.0.0.0"]
```

**Example 3:**
```
Input: s = "101023"
Output: ["1.0.10.23","1.0.102.3","10.1.0.23","10.10.2.3","10.102.0.3","101.0.2.3","101.0.23.0"]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ip-builder')
  AND locale = 'en';

------------------------------------------------------------
-- valid-tree
------------------------------------------------------------
UPDATE problems
SET description = 'You are given `n` nodes labeled from `0` to `n - 1` and a list of undirected `edges`, where each edge connects two nodes. Determine whether these nodes and edges form a **valid tree**.

A valid tree satisfies two conditions:
- It is **fully connected** -- every node is reachable from every other node.
- It contains **no cycles**.

**Example 1:**
```
Input: n = 5, edges = [[0,1],[0,2],[0,3],[1,4]]
Output: true
Explanation: All 5 nodes are connected and there are no cycles.
```

**Example 2:**
```
Input: n = 5, edges = [[0,1],[1,2],[2,3],[1,3],[1,4]]
Output: false
Explanation: There is a cycle between nodes 1, 2, and 3.
```

**Example 3:**
```
Input: n = 4, edges = [[0,1],[2,3]]
Output: false
Explanation: The graph has two disconnected components, so it is not a valid tree.
```'
WHERE slug = 'valid-tree';

UPDATE problem_translations
SET description = 'You are given `n` nodes labeled from `0` to `n - 1` and a list of undirected `edges`, where each edge connects two nodes. Determine whether these nodes and edges form a **valid tree**.

A valid tree satisfies two conditions:
- It is **fully connected** -- every node is reachable from every other node.
- It contains **no cycles**.

**Example 1:**
```
Input: n = 5, edges = [[0,1],[0,2],[0,3],[1,4]]
Output: true
Explanation: All 5 nodes are connected and there are no cycles.
```

**Example 2:**
```
Input: n = 5, edges = [[0,1],[1,2],[2,3],[1,3],[1,4]]
Output: false
Explanation: There is a cycle between nodes 1, 2, and 3.
```

**Example 3:**
```
Input: n = 4, edges = [[0,1],[2,3]]
Output: false
Explanation: The graph has two disconnected components, so it is not a valid tree.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'valid-tree')
  AND locale = 'en';

------------------------------------------------------------
-- gate-distance
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an `m x n` grid where each cell contains one of three values:

- `-1` -- a **barrier** (impassable)
- `0` -- a **gate**
- `2147483647` -- an **open space**

Fill each open space with the distance (number of steps) to its **nearest gate**. If an open space cannot reach any gate, leave its value as `2147483647`. You may only move in the four cardinal directions: up, down, left, and right.

Modify the grid **in-place** and return it.

**Example 1:**
```
Input: grid = [[2147483647,-1,0,2147483647],[2147483647,2147483647,2147483647,-1],[2147483647,-1,2147483647,-1],[0,-1,2147483647,2147483647]]
Output: [[3,-1,0,1],[2,2,1,-1],[1,-1,2,-1],[0,-1,3,4]]
Explanation: The two gates are at positions (0,2) and (3,0). Each open space is labeled with its shortest path to the nearest gate.
```

**Example 2:**
```
Input: grid = [[0,-1],[2147483647,2147483647]]
Output: [[0,-1],[1,2]]
```

**Example 3:**
```
Input: grid = [[2147483647]]
Output: [[2147483647]]
Explanation: There are no gates, so the open space remains unreachable.
```'
WHERE slug = 'gate-distance';

UPDATE problem_translations
SET description = 'You are given an `m x n` grid where each cell contains one of three values:

- `-1` -- a **barrier** (impassable)
- `0` -- a **gate**
- `2147483647` -- an **open space**

Fill each open space with the distance (number of steps) to its **nearest gate**. If an open space cannot reach any gate, leave its value as `2147483647`. You may only move in the four cardinal directions: up, down, left, and right.

Modify the grid **in-place** and return it.

**Example 1:**
```
Input: grid = [[2147483647,-1,0,2147483647],[2147483647,2147483647,2147483647,-1],[2147483647,-1,2147483647,-1],[0,-1,2147483647,2147483647]]
Output: [[3,-1,0,1],[2,2,1,-1],[1,-1,2,-1],[0,-1,3,4]]
Explanation: The two gates are at positions (0,2) and (3,0). Each open space is labeled with its shortest path to the nearest gate.
```

**Example 2:**
```
Input: grid = [[0,-1],[2147483647,2147483647]]
Output: [[0,-1],[1,2]]
```

**Example 3:**
```
Input: grid = [[2147483647]]
Output: [[2147483647]]
Explanation: There are no gates, so the open space remains unreachable.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'gate-distance')
  AND locale = 'en';
