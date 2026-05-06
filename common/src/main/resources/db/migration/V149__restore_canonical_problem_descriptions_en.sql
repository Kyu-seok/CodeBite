-- V149: Restore canonical English descriptions for the 10 classic CS puzzles
-- whose iconic framings predate LeetCode. The casual rebrand from V133/V135
-- (number puzzle, hamster fences, recycle bins, etc.) is replaced with the
-- canonical setup (Sudoku, Trapping Rain Water, Sort Colors, etc.) using
-- canonical parameter names that match the renamed method signatures.
-- Prose is fresh — not paraphrased from LeetCode/NeetCode. Korean
-- translations are refreshed in V150.

-- valid-sudoku
UPDATE problems SET
    description = $$A 9×9 Sudoku board is partly filled in. Decide whether the digits placed so far are legal — empty cells (`.`) impose no constraint, but every filled cell must coexist with the rest of its row, column, and 3×3 sub-box.

Each entry of `board[i][j]` is either a digit `'1'`–`'9'` or `'.'`. Return `true` if no row, column, or 3×3 sub-box contains a repeated digit, and `false` otherwise. The board is *not* required to be solvable — you're only validating what's already there.

**Example 1:**
```
Input: board = [["5","3",".",".","7",".",".",".","."],["6",".",".","1","9","5",".",".","."],[".","9","8",".",".",".",".","6","."],["8",".",".",".","6",".",".",".","3"],["4",".",".","8",".","3",".",".","1"],["7",".",".",".","2",".",".",".","6"],[".","6",".",".",".",".","2","8","."],[".",".",".","4","1","9",".",".","5"],[".",".",".",".","8",".",".","7","9"]]
Output: true
```

**Example 2:**
```
Input: board = [["8","3",".",".","7",".",".",".","."],["6",".",".","1","9","5",".",".","."],[".","9","8",".",".",".",".","6","."],["8",".",".",".","6",".",".",".","3"],["4",".",".","8",".","3",".",".","1"],["7",".",".",".","2",".",".",".","6"],[".","6",".",".",".",".","2","8","."],[".",".",".","4","1","9",".",".","5"],[".",".",".",".","8",".",".","7","9"]]
Output: false
Explanation: Two 8s appear in the leftmost column, so the column constraint is violated.
```$$
WHERE slug = $$valid-sudoku$$;

-- sort-colors
UPDATE problems SET
    description = $$An array `nums` contains only `0`, `1`, and `2` — three categories with a natural sort order (red, white, blue, by convention). Rearrange the entries **in place** so all `0`s come first, then all `1`s, then all `2`s. You may not call any built-in sort routine.

Aim for a single linear pass with constant extra space — the classic Dutch national flag partition.

**Example 1:**
```
Input: nums = [2,0,2,1,1,0]
Output: [0,0,1,1,2,2]
```

**Example 2:**
```
Input: nums = [2,0,1]
Output: [0,1,2]
```$$
WHERE slug = $$sort-colors$$;

-- trapping-rain-water
UPDATE problems SET
    description = $$An elevation map is given as `height`, where `height[i]` is the height of the `i`-th bar and every bar is one unit wide. After it rains, water collects in the dips between taller bars. Return the total amount of water trapped.

A bar at index `i` traps water up to `min(maxLeft, maxRight) - height[i]`, where `maxLeft` and `maxRight` are the tallest bars to its left and right. If no taller bar exists on one side, that side cannot hold water.

**Example 1:**
```
Input: height = [0,1,0,2,1,0,1,3,2,1,2,1]
Output: 6
Explanation: Six units of water sit in the dips between the bars of heights 2, 3, and 2.
```

**Example 2:**
```
Input: height = [4,2,0,3,2,5]
Output: 9
```$$
WHERE slug = $$trapping-rain-water$$;

-- word-search-ii
UPDATE problems SET
    description = $$You're given an `m x n` `board` of letters and a list of `words`. Find every word from the list that can be formed by walking from cell to cell on the board, stepping only between orthogonally adjacent cells (up/down/left/right). A cell can appear at most once per word. Return the matched words in any order.

Multiple words may overlap on the board — each is checked independently.

**Example 1:**
```
Input: board = [["o","a","a","n"],["e","t","a","e"],["i","h","k","r"],["i","f","l","v"]], words = ["oath","pea","eat","rain"]
Output: ["eat","oath"]
```

**Example 2:**
```
Input: board = [["a","b"],["c","d"]], words = ["abcb"]
Output: []
Explanation: Tracing "abcb" would require revisiting the cell containing "b", which isn't allowed.
```$$
WHERE slug = $$word-search-ii$$;

-- n-queens
UPDATE problems SET
    description = $$Place `n` queens on an `n × n` chessboard so that no two queens attack each other — meaning no two share a row, column, or diagonal. Return every distinct arrangement.

Each arrangement is a list of `n` strings of length `n`, where `'Q'` marks a queen and `'.'` marks an empty square. Order of arrangements in the output does not matter.

**Example 1:**
```
Input: n = 4
Output: [[".Q..","...Q","Q...","..Q."],["..Q.","Q...","...Q",".Q.."]]
Explanation: Two distinct safe placements exist for n = 4.
```

**Example 2:**
```
Input: n = 1
Output: [["Q"]]
```$$
WHERE slug = $$n-queens$$;

-- word-search
UPDATE problems SET
    description = $$Given an `m x n` `board` of letters and a target `word`, return `true` if `word` can be traced on the board by walking between orthogonally adjacent cells (up/down/left/right). Each cell may be used at most once per trace.

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
Explanation: Reaching the second "B" would require revisiting the starting cell.
```$$
WHERE slug = $$word-search$$;

-- largest-rectangle-histogram
UPDATE problems SET
    description = $$A histogram is described by an array `heights`, where `heights[i]` is the height of the `i`-th bar and every bar is one unit wide. Find the area of the largest rectangle that fits entirely inside the histogram, possibly spanning several adjacent bars.

A rectangle covering bars `i..j` has height `min(heights[i..j])` and width `j - i + 1`.

**Example 1:**
```
Input: heights = [2,1,5,6,2,3]
Output: 10
Explanation: The bars at indices 2 and 3 (heights 5 and 6) together support a 2×5 rectangle of area 10.
```

**Example 2:**
```
Input: heights = [2,4]
Output: 4
```$$
WHERE slug = $$largest-rectangle-histogram$$;

-- lru-cache
UPDATE problems SET
    description = $$Design `LRUCache`, a key/value store with a fixed `capacity` that evicts the least-recently-used entry whenever it grows past its limit.

Implement:
- `LRUCache(int capacity)` — create the cache with positive size `capacity`.
- `int get(int key)` — return the value for `key`, or `-1` if `key` is absent. A successful `get` counts as a recent use.
- `void put(int key, int value)` — insert or update the entry. If the cache exceeds `capacity` after the insert, evict the least-recently-used key.

Both `get` and `put` should run in **O(1) average time**.

**Example 1:**
```
Input
["LRUCache","put","put","get","put","get","put","get","get","get"]
[[2],[1,1],[2,2],[1],[3,3],[2],[4,4],[1],[3],[4]]
Output
[null,null,null,1,null,-1,null,-1,3,4]

Explanation
LRUCache cache = new LRUCache(2);
cache.put(1, 1); // cache = {1=1}
cache.put(2, 2); // cache = {1=1, 2=2}
cache.get(1);    // returns 1, cache = {2=2, 1=1}
cache.put(3, 3); // evicts key 2, cache = {1=1, 3=3}
cache.get(2);    // returns -1 (not found)
cache.put(4, 4); // evicts key 1, cache = {3=3, 4=4}
cache.get(1);    // returns -1
cache.get(3);    // returns 3
cache.get(4);    // returns 4
```$$
WHERE slug = $$lru-cache$$;

-- word-ladder
UPDATE problems SET
    description = $$You're given two words `beginWord` and `endWord` of equal length, plus a dictionary `wordList`. A *transformation* changes exactly one letter at a time, and every intermediate result must appear in `wordList`. `endWord` itself must also be in `wordList` for any transformation to succeed. `beginWord` does NOT need to be in the list.

Return the length of the shortest transformation sequence from `beginWord` to `endWord`, counting both endpoints. If no valid sequence exists, return `0`.

**Example 1:**
```
Input: beginWord = "hit", endWord = "cog", wordList = ["hot","dot","dog","lot","log","cog"]
Output: 5
Explanation: One shortest path is "hit" → "hot" → "dot" → "dog" → "cog", length 5.
```

**Example 2:**
```
Input: beginWord = "hit", endWord = "cog", wordList = ["hot","dot","dog","lot","log"]
Output: 0
Explanation: "cog" is missing from the dictionary, so no valid sequence exists.
```$$
WHERE slug = $$word-ladder$$;

-- fizz-buzz
UPDATE problems SET
    description = $$Given a positive integer `n`, return an array `answer` of length `n` where, for each `i` from `1` through `n`:
- `answer[i-1]` is `"FizzBuzz"` when `i` is divisible by both 3 and 5,
- `"Fizz"` when `i` is divisible only by 3,
- `"Buzz"` when `i` is divisible only by 5,
- the decimal string of `i` otherwise.

**Example 1:**
```
Input: n = 3
Output: ["1","2","Fizz"]
```

**Example 2:**
```
Input: n = 5
Output: ["1","2","Fizz","4","Buzz"]
```

**Example 3:**
```
Input: n = 15
Output: ["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]
```$$
WHERE slug = $$fizz-buzz$$;
