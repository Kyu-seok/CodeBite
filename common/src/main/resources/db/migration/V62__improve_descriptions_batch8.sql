-- Improve descriptions: batch 8
-- Slugs: tree-diameter, max-path-sum, prefix-tree, word-dictionary,
--         word-finder, last-stone, k-closest-points, array-kth-largest,
--         queen-placement, word-search

------------------------------------------------------------
-- tree-diameter
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `root` of a binary tree, return the length of its **diameter**.

The **diameter** of a binary tree is the length of the longest path between any two nodes in the tree. This path may or may not pass through the root.

The length of a path is measured by the number of edges between the two nodes.

**Example 1:**
```
Input: root = [1,2,3,4,5]
Output: 3
Explanation: 3 is the length of the path [4,2,1,3] or [5,2,1,3].
```

**Example 2:**
```
Input: root = [1,2]
Output: 1
```'
WHERE slug = 'tree-diameter';

UPDATE problem_translations
SET description = 'Given the `root` of a binary tree, return the length of its **diameter**.

The **diameter** of a binary tree is the length of the longest path between any two nodes in the tree. This path may or may not pass through the root.

The length of a path is measured by the number of edges between the two nodes.

**Example 1:**
```
Input: root = [1,2,3,4,5]
Output: 3
Explanation: 3 is the length of the path [4,2,1,3] or [5,2,1,3].
```

**Example 2:**
```
Input: root = [1,2]
Output: 1
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-diameter')
  AND locale = 'en';

------------------------------------------------------------
-- max-path-sum
------------------------------------------------------------
UPDATE problems
SET description = 'A **path** in a binary tree is a sequence of nodes where each pair of adjacent nodes is connected by an edge. A node can appear in the path **at most once**. The path does not need to pass through the root.

The **path sum** is the sum of all node values along the path.

Given the `root` of a binary tree, return the maximum path sum of any non-empty path.

**Example 1:**
```
Input: root = [1,2,3]
Output: 6
Explanation: The optimal path is 2 -> 1 -> 3 with a path sum of 2 + 1 + 3 = 6.
```

**Example 2:**
```
Input: root = [-10,9,20,null,null,15,7]
Output: 42
Explanation: The optimal path is 15 -> 20 -> 7 with a path sum of 15 + 20 + 7 = 42.
```'
WHERE slug = 'max-path-sum';

UPDATE problem_translations
SET description = 'A **path** in a binary tree is a sequence of nodes where each pair of adjacent nodes is connected by an edge. A node can appear in the path **at most once**. The path does not need to pass through the root.

The **path sum** is the sum of all node values along the path.

Given the `root` of a binary tree, return the maximum path sum of any non-empty path.

**Example 1:**
```
Input: root = [1,2,3]
Output: 6
Explanation: The optimal path is 2 -> 1 -> 3 with a path sum of 2 + 1 + 3 = 6.
```

**Example 2:**
```
Input: root = [-10,9,20,null,null,15,7]
Output: 42
Explanation: The optimal path is 15 -> 20 -> 7 with a path sum of 15 + 20 + 7 = 42.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'max-path-sum')
  AND locale = 'en';

------------------------------------------------------------
-- prefix-tree
------------------------------------------------------------
UPDATE problems
SET description = 'A **trie** (pronounced "try"), also known as a **prefix tree**, is a tree data structure used to efficiently store and retrieve keys in a dataset of strings.

Implement the `Trie` class with the following methods:

- `Trie()` — Initializes the trie object.
- `void insert(String word)` — Inserts the string `word` into the trie.
- `boolean search(String word)` — Returns `true` if `word` exists in the trie, and `false` otherwise.
- `boolean startsWith(String prefix)` — Returns `true` if any previously inserted string starts with the given `prefix`, and `false` otherwise.

**Example 1:**
```
Input:
["Trie", "insert", "search", "search", "startsWith", "insert", "search"]
[[], ["apple"], ["apple"], ["app"], ["app"], ["app"], ["app"]]
Output: [null, null, true, false, true, null, true]
```'
WHERE slug = 'prefix-tree';

UPDATE problem_translations
SET description = 'A **trie** (pronounced "try"), also known as a **prefix tree**, is a tree data structure used to efficiently store and retrieve keys in a dataset of strings.

Implement the `Trie` class with the following methods:

- `Trie()` — Initializes the trie object.
- `void insert(String word)` — Inserts the string `word` into the trie.
- `boolean search(String word)` — Returns `true` if `word` exists in the trie, and `false` otherwise.
- `boolean startsWith(String prefix)` — Returns `true` if any previously inserted string starts with the given `prefix`, and `false` otherwise.

**Example 1:**
```
Input:
["Trie", "insert", "search", "search", "startsWith", "insert", "search"]
[[], ["apple"], ["apple"], ["app"], ["app"], ["app"], ["app"]]
Output: [null, null, true, false, true, null, true]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'prefix-tree')
  AND locale = 'en';

------------------------------------------------------------
-- word-dictionary
------------------------------------------------------------
UPDATE problems
SET description = 'Design a data structure that supports adding new words and searching for strings that may contain wildcard characters.

Implement the `WordDictionary` class:

- `WordDictionary()` — Initializes the object.
- `void addWord(word)` — Adds `word` to the data structure so it can be matched later.
- `bool search(word)` — Returns `true` if any string in the data structure matches `word`, or `false` otherwise. The search `word` may contain dots `''.''`, where each dot can match any single letter.

**Example 1:**
```
Input:
["WordDictionary","addWord","addWord","addWord","search","search","search","search"]
[[],["bad"],["dad"],["mad"],["pad"],["bad"],[".ad"],["b.."]]
Output: [null,null,null,null,false,true,true,true]
```'
WHERE slug = 'word-dictionary';

UPDATE problem_translations
SET description = 'Design a data structure that supports adding new words and searching for strings that may contain wildcard characters.

Implement the `WordDictionary` class:

- `WordDictionary()` — Initializes the object.
- `void addWord(word)` — Adds `word` to the data structure so it can be matched later.
- `bool search(word)` — Returns `true` if any string in the data structure matches `word`, or `false` otherwise. The search `word` may contain dots `''.''`, where each dot can match any single letter.

**Example 1:**
```
Input:
["WordDictionary","addWord","addWord","addWord","search","search","search","search"]
[[],["bad"],["dad"],["mad"],["pad"],["bad"],[".ad"],["b.."]]
Output: [null,null,null,null,false,true,true,true]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-dictionary')
  AND locale = 'en';

------------------------------------------------------------
-- word-finder
------------------------------------------------------------
UPDATE problems
SET description = 'Given an `m x n` grid of characters `board` and a list of strings `words`, return all words that can be found on the board.

Each word must be formed by following a path of **horizontally or vertically adjacent** cells. The same cell may not be used more than once within a single word.

Return the found words in any order.

**Example 1:**
```
Input: board = [["o","a","a","n"],["e","t","a","e"],["i","h","k","r"],["i","f","l","v"]], words = ["oath","pea","eat","rain"]
Output: ["eat","oath"]
```

**Example 2:**
```
Input: board = [["a","b"],["c","d"]], words = ["abcb"]
Output: []
```'
WHERE slug = 'word-finder';

UPDATE problem_translations
SET description = 'Given an `m x n` grid of characters `board` and a list of strings `words`, return all words that can be found on the board.

Each word must be formed by following a path of **horizontally or vertically adjacent** cells. The same cell may not be used more than once within a single word.

Return the found words in any order.

**Example 1:**
```
Input: board = [["o","a","a","n"],["e","t","a","e"],["i","h","k","r"],["i","f","l","v"]], words = ["oath","pea","eat","rain"]
Output: ["eat","oath"]
```

**Example 2:**
```
Input: board = [["a","b"],["c","d"]], words = ["abcb"]
Output: []
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-finder')
  AND locale = 'en';

------------------------------------------------------------
-- last-stone
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an array of integers `stones` where `stones[i]` is the weight of the `i`-th stone.

On each turn, pick the **two heaviest** stones and smash them together. If the two stones have weights `x` and `y` where `x <= y`, the result is:

- If `x == y`, both stones are destroyed.
- If `x != y`, the stone of weight `x` is destroyed, and the stone of weight `y` becomes `y - x`.

Repeat until at most one stone remains. Return the weight of the last remaining stone, or `0` if no stones are left.

**Example 1:**
```
Input: stones = [2,7,4,1,8,1]
Output: 1
Explanation:
We combine 7 and 8 to get 1 so the array converts to [2,4,1,1,1] then,
we combine 2 and 4 to get 2 so the array converts to [2,1,1,1] then,
we combine 2 and 1 to get 1 so the array converts to [1,1,1] then,
we combine 1 and 1 to get 0 so the array converts to [1] then that is the value of the last stone.
```

**Example 2:**
```
Input: stones = [1]
Output: 1
```'
WHERE slug = 'last-stone';

UPDATE problem_translations
SET description = 'You are given an array of integers `stones` where `stones[i]` is the weight of the `i`-th stone.

On each turn, pick the **two heaviest** stones and smash them together. If the two stones have weights `x` and `y` where `x <= y`, the result is:

- If `x == y`, both stones are destroyed.
- If `x != y`, the stone of weight `x` is destroyed, and the stone of weight `y` becomes `y - x`.

Repeat until at most one stone remains. Return the weight of the last remaining stone, or `0` if no stones are left.

**Example 1:**
```
Input: stones = [2,7,4,1,8,1]
Output: 1
Explanation:
We combine 7 and 8 to get 1 so the array converts to [2,4,1,1,1] then,
we combine 2 and 4 to get 2 so the array converts to [2,1,1,1] then,
we combine 2 and 1 to get 1 so the array converts to [1,1,1] then,
we combine 1 and 1 to get 0 so the array converts to [1] then that is the value of the last stone.
```

**Example 2:**
```
Input: stones = [1]
Output: 1
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'last-stone')
  AND locale = 'en';

------------------------------------------------------------
-- k-closest-points
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of `points` where `points[i] = [x, y]` represents a point on the X-Y plane and an integer `k`, return the `k` closest points to the origin `(0, 0)`.

The distance between a point and the origin is the **Euclidean distance**: `sqrt(x^2 + y^2)`.

You may return the answer in **any order**. The answer is guaranteed to be unique (except for the order).

**Example 1:**
```
Input: points = [[1,3],[-2,2]], k = 1
Output: [[-2,2]]
Explanation: The distance between (1, 3) and the origin is sqrt(10). The distance between (-2, 2) and the origin is sqrt(8). Since sqrt(8) < sqrt(10), (-2, 2) is closer.
```

**Example 2:**
```
Input: points = [[3,3],[5,-1],[-2,4]], k = 2
Output: [[3,3],[-2,4]]
```'
WHERE slug = 'k-closest-points';

UPDATE problem_translations
SET description = 'Given an array of `points` where `points[i] = [x, y]` represents a point on the X-Y plane and an integer `k`, return the `k` closest points to the origin `(0, 0)`.

The distance between a point and the origin is the **Euclidean distance**: `sqrt(x^2 + y^2)`.

You may return the answer in **any order**. The answer is guaranteed to be unique (except for the order).

**Example 1:**
```
Input: points = [[1,3],[-2,2]], k = 1
Output: [[-2,2]]
Explanation: The distance between (1, 3) and the origin is sqrt(10). The distance between (-2, 2) and the origin is sqrt(8). Since sqrt(8) < sqrt(10), (-2, 2) is closer.
```

**Example 2:**
```
Input: points = [[3,3],[5,-1],[-2,4]], k = 2
Output: [[3,3],[-2,4]]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'k-closest-points')
  AND locale = 'en';

------------------------------------------------------------
-- array-kth-largest
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums` and an integer `k`, return the `k`th largest element in the array.

Note that you are looking for the `k`th largest element in **sorted order**, not the `k`th distinct element. For example, in `[3, 1, 2, 2]` the 1st largest is `3` and the 2nd largest is `2`.

**Example 1:**
```
Input: nums = [3,2,1,5,6,4], k = 2
Output: 5
```

**Example 2:**
```
Input: nums = [3,2,3,1,2,4,5,5,6], k = 4
Output: 4
```

**Example 3:**
```
Input: nums = [1], k = 1
Output: 1
```'
WHERE slug = 'array-kth-largest';

UPDATE problem_translations
SET description = 'Given an integer array `nums` and an integer `k`, return the `k`th largest element in the array.

Note that you are looking for the `k`th largest element in **sorted order**, not the `k`th distinct element. For example, in `[3, 1, 2, 2]` the 1st largest is `3` and the 2nd largest is `2`.

**Example 1:**
```
Input: nums = [3,2,1,5,6,4], k = 2
Output: 5
```

**Example 2:**
```
Input: nums = [3,2,3,1,2,4,5,5,6], k = 4
Output: 4
```

**Example 3:**
```
Input: nums = [1], k = 1
Output: 1
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'array-kth-largest')
  AND locale = 'en';

------------------------------------------------------------
-- queen-placement
------------------------------------------------------------
UPDATE problems
SET description = 'The **n-queens puzzle** asks you to place `n` queens on an `n x n` chessboard so that no two queens threaten each other. Two queens threaten each other if they share the same row, column, or diagonal.

Given an integer `n`, return all distinct solutions to the n-queens puzzle. You may return the solutions in any order.

Each solution is a list of strings representing the board. In each string, `''Q''` marks a queen and `''.''` marks an empty square.

**Example 1:**
```
Input: n = 4
Output: [["..Q.","Q...","...Q",".Q.."],[".Q..","...Q","Q...","..Q."]]
```

**Example 2:**
```
Input: n = 1
Output: [["Q"]]
```'
WHERE slug = 'queen-placement';

UPDATE problem_translations
SET description = 'The **n-queens puzzle** asks you to place `n` queens on an `n x n` chessboard so that no two queens threaten each other. Two queens threaten each other if they share the same row, column, or diagonal.

Given an integer `n`, return all distinct solutions to the n-queens puzzle. You may return the solutions in any order.

Each solution is a list of strings representing the board. In each string, `''Q''` marks a queen and `''.''` marks an empty square.

**Example 1:**
```
Input: n = 4
Output: [["..Q.","Q...","...Q",".Q.."],[".Q..","...Q","Q...","..Q."]]
```

**Example 2:**
```
Input: n = 1
Output: [["Q"]]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'queen-placement')
  AND locale = 'en';

------------------------------------------------------------
-- word-search
------------------------------------------------------------
UPDATE problems
SET description = 'Given an `m x n` grid of characters `board` and a string `word`, return `true` if `word` exists in the grid, or `false` otherwise.

The word must be formed by following a path of **horizontally or vertically adjacent** cells. Each cell may be used at most once in the path.

**Example 1:**
```
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCCED"
Output: true
```

**Example 2:**
```
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "SEE"
Output: true
```

**Example 3:**
```
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCB"
Output: false
```'
WHERE slug = 'word-search';

UPDATE problem_translations
SET description = 'Given an `m x n` grid of characters `board` and a string `word`, return `true` if `word` exists in the grid, or `false` otherwise.

The word must be formed by following a path of **horizontally or vertically adjacent** cells. Each cell may be used at most once in the path.

**Example 1:**
```
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCCED"
Output: true
```

**Example 2:**
```
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "SEE"
Output: true
```

**Example 3:**
```
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCB"
Output: false
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-search')
  AND locale = 'en';
