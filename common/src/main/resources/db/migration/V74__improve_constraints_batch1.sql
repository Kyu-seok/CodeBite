-- Reformat constraints for problems #1–#50: add markdown bullets and backtick-wrap technical expressions

------------------------------------------------------------
-- #1 pair-sum
------------------------------------------------------------
UPDATE problems SET constraints =
'- `2 <= nums.length <= 10^4`
- `-10^9 <= nums[i] <= 10^9`
- `-10^9 <= target <= 10^9`
- Only one valid answer exists.'
WHERE slug = 'pair-sum';

UPDATE problem_translations SET constraints =
'- `2 <= nums.length <= 10^4`
- `-10^9 <= nums[i] <= 10^9`
- `-10^9 <= target <= 10^9`
- Only one valid answer exists.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pair-sum')
  AND locale = 'en';

------------------------------------------------------------
-- #2 find-duplicates
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 10^5`
- `-10^9 <= nums[i] <= 10^9`'
WHERE slug = 'find-duplicates';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 10^5`
- `-10^9 <= nums[i] <= 10^9`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'find-duplicates')
  AND locale = 'en';

------------------------------------------------------------
-- #3 anagram-check
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= s.length, t.length <= 5 * 10^4`
- `s` and `t` consist of lowercase English letters.'
WHERE slug = 'anagram-check';

UPDATE problem_translations SET constraints =
'- `1 <= s.length, t.length <= 5 * 10^4`
- `s` and `t` consist of lowercase English letters.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'anagram-check')
  AND locale = 'en';

------------------------------------------------------------
-- #4 anagram-groups
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= strs.length <= 10^4`
- `0 <= strs[i].length <= 100`
- `strs[i]` consists of lowercase English letters.'
WHERE slug = 'anagram-groups';

UPDATE problem_translations SET constraints =
'- `1 <= strs.length <= 10^4`
- `0 <= strs[i].length <= 100`
- `strs[i]` consists of lowercase English letters.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'anagram-groups')
  AND locale = 'en';

------------------------------------------------------------
-- #5 k-most-frequent
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`
- `k` is in the range `[1, the number of unique elements in the array]`.
- It is guaranteed that the answer is unique.'
WHERE slug = 'k-most-frequent';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`
- `k` is in the range `[1, the number of unique elements in the array]`.
- It is guaranteed that the answer is unique.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'k-most-frequent')
  AND locale = 'en';

------------------------------------------------------------
-- #6 array-product
------------------------------------------------------------
UPDATE problems SET constraints =
'- `2 <= nums.length <= 10^5`
- `-30 <= nums[i] <= 30`
- The product of any prefix or suffix of `nums` is guaranteed to fit in a 32-bit integer.'
WHERE slug = 'array-product';

UPDATE problem_translations SET constraints =
'- `2 <= nums.length <= 10^5`
- `-30 <= nums[i] <= 30`
- The product of any prefix or suffix of `nums` is guaranteed to fit in a 32-bit integer.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'array-product')
  AND locale = 'en';

------------------------------------------------------------
-- #7 longest-streak
------------------------------------------------------------
UPDATE problems SET constraints =
'- `0 <= nums.length <= 10^5`
- `-10^9 <= nums[i] <= 10^9`'
WHERE slug = 'longest-streak';

UPDATE problem_translations SET constraints =
'- `0 <= nums.length <= 10^5`
- `-10^9 <= nums[i] <= 10^9`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-streak')
  AND locale = 'en';

------------------------------------------------------------
-- #8 string-codec
------------------------------------------------------------
UPDATE problems SET constraints =
'- `0 <= strs.length <= 200`
- `0 <= strs[i].length <= 200`
- `strs[i]` contains any possible characters including the delimiter characters.'
WHERE slug = 'string-codec';

UPDATE problem_translations SET constraints =
'- `0 <= strs.length <= 200`
- `0 <= strs[i].length <= 200`
- `strs[i]` contains any possible characters including the delimiter characters.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'string-codec')
  AND locale = 'en';

------------------------------------------------------------
-- #9 sudoku-validator
------------------------------------------------------------
UPDATE problems SET constraints =
'- `board.length == 9`
- `board[i].length == 9`
- `board[i][j]` is a digit `1-9` or `''.''`.'
WHERE slug = 'sudoku-validator';

UPDATE problem_translations SET constraints =
'- `board.length == 9`
- `board[i].length == 9`
- `board[i][j]` is a digit `1-9` or `''.''`.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sudoku-validator')
  AND locale = 'en';

------------------------------------------------------------
-- #10 palindrome-checker
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= s.length <= 2 * 10^5`
- `s` consists only of printable ASCII characters.'
WHERE slug = 'palindrome-checker';

UPDATE problem_translations SET constraints =
'- `1 <= s.length <= 2 * 10^5`
- `s` consists only of printable ASCII characters.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'palindrome-checker')
  AND locale = 'en';

------------------------------------------------------------
-- #11 sorted-pair-sum
------------------------------------------------------------
UPDATE problems SET constraints =
'- `2 <= numbers.length <= 3 * 10^4`
- `-1000 <= numbers[i] <= 1000`
- `numbers` is sorted in non-decreasing order.
- `-1000 <= target <= 1000`
- The tests are generated such that there is exactly one solution.'
WHERE slug = 'sorted-pair-sum';

UPDATE problem_translations SET constraints =
'- `2 <= numbers.length <= 3 * 10^4`
- `-1000 <= numbers[i] <= 1000`
- `numbers` is sorted in non-decreasing order.
- `-1000 <= target <= 1000`
- The tests are generated such that there is exactly one solution.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sorted-pair-sum')
  AND locale = 'en';

------------------------------------------------------------
-- #12 three-sum
------------------------------------------------------------
UPDATE problems SET constraints =
'- `3 <= nums.length <= 3000`
- `-10^5 <= nums[i] <= 10^5`'
WHERE slug = 'three-sum';

UPDATE problem_translations SET constraints =
'- `3 <= nums.length <= 3000`
- `-10^5 <= nums[i] <= 10^5`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'three-sum')
  AND locale = 'en';

------------------------------------------------------------
-- #13 water-container
------------------------------------------------------------
UPDATE problems SET constraints =
'- `n == height.length`
- `2 <= n <= 10^5`
- `0 <= height[i] <= 10^4`'
WHERE slug = 'water-container';

UPDATE problem_translations SET constraints =
'- `n == height.length`
- `2 <= n <= 10^5`
- `0 <= height[i] <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'water-container')
  AND locale = 'en';

------------------------------------------------------------
-- #14 stock-profit
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= prices.length <= 10^5`
- `0 <= prices[i] <= 10^4`'
WHERE slug = 'stock-profit';

UPDATE problem_translations SET constraints =
'- `1 <= prices.length <= 10^5`
- `0 <= prices[i] <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'stock-profit')
  AND locale = 'en';

------------------------------------------------------------
-- #15 unique-substring
------------------------------------------------------------
UPDATE problems SET constraints =
'- `0 <= s.length <= 5 * 10^4`
- `s` consists of English letters, digits, symbols and spaces.'
WHERE slug = 'unique-substring';

UPDATE problem_translations SET constraints =
'- `0 <= s.length <= 5 * 10^4`
- `s` consists of English letters, digits, symbols and spaces.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-substring')
  AND locale = 'en';

------------------------------------------------------------
-- #16 character-swap
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= s.length <= 10^5`
- `s` consists of only uppercase English letters.
- `0 <= k <= s.length`'
WHERE slug = 'character-swap';

UPDATE problem_translations SET constraints =
'- `1 <= s.length <= 10^5`
- `s` consists of only uppercase English letters.
- `0 <= k <= s.length`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'character-swap')
  AND locale = 'en';

------------------------------------------------------------
-- #17 smallest-window
------------------------------------------------------------
UPDATE problems SET constraints =
'- `m == s.length`
- `n == t.length`
- `1 <= m, n <= 10^5`
- `s` and `t` consist of uppercase and lowercase English letters.'
WHERE slug = 'smallest-window';

UPDATE problem_translations SET constraints =
'- `m == s.length`
- `n == t.length`
- `1 <= m, n <= 10^5`
- `s` and `t` consist of uppercase and lowercase English letters.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'smallest-window')
  AND locale = 'en';

------------------------------------------------------------
-- #18 bracket-validator
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= s.length <= 10^4`
- `s` consists of parentheses only `''()[]{}''`.'
WHERE slug = 'bracket-validator';

UPDATE problem_translations SET constraints =
'- `1 <= s.length <= 10^4`
- `s` consists of parentheses only `''()[]{}''`.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bracket-validator')
  AND locale = 'en';

------------------------------------------------------------
-- #19 minimum-stack
------------------------------------------------------------
UPDATE problems SET constraints =
'- `-2^31 <= val <= 2^31 - 1`
- Methods `pop`, `top` and `getMin` operations will always be called on non-empty stacks.
- At most `3 * 10^4` calls will be made to `push`, `pop`, `top`, and `getMin`.'
WHERE slug = 'minimum-stack';

UPDATE problem_translations SET constraints =
'- `-2^31 <= val <= 2^31 - 1`
- Methods `pop`, `top` and `getMin` operations will always be called on non-empty stacks.
- At most `3 * 10^4` calls will be made to `push`, `pop`, `top`, and `getMin`.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'minimum-stack')
  AND locale = 'en';

------------------------------------------------------------
-- #20 basic-binary-search
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 10^4`
- `-10^4 < nums[i], target < 10^4`
- All the integers in `nums` are unique.
- `nums` is sorted in ascending order.'
WHERE slug = 'basic-binary-search';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 10^4`
- `-10^4 < nums[i], target < 10^4`
- All the integers in `nums` are unique.
- `nums` is sorted in ascending order.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'basic-binary-search')
  AND locale = 'en';

------------------------------------------------------------
-- #21 matrix-search
------------------------------------------------------------
UPDATE problems SET constraints =
'- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= m, n <= 100`
- `-10^4 <= matrix[i][j], target <= 10^4`'
WHERE slug = 'matrix-search';

UPDATE problem_translations SET constraints =
'- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= m, n <= 100`
- `-10^4 <= matrix[i][j], target <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'matrix-search')
  AND locale = 'en';

------------------------------------------------------------
-- #22 rotated-array-min
------------------------------------------------------------
UPDATE problems SET constraints =
'- `n == nums.length`
- `1 <= n <= 5000`
- `-5000 <= nums[i] <= 5000`
- All the integers of `nums` are unique.
- `nums` is sorted and rotated between `1` and `n` times.'
WHERE slug = 'rotated-array-min';

UPDATE problem_translations SET constraints =
'- `n == nums.length`
- `1 <= n <= 5000`
- `-5000 <= nums[i] <= 5000`
- All the integers of `nums` are unique.
- `nums` is sorted and rotated between `1` and `n` times.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rotated-array-min')
  AND locale = 'en';

------------------------------------------------------------
-- #23 reverse-list
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes in the list is the range `[0, 5000]`.
- `-5000 <= Node.val <= 5000`'
WHERE slug = 'reverse-list';

UPDATE problem_translations SET constraints =
'- The number of nodes in the list is the range `[0, 5000]`.
- `-5000 <= Node.val <= 5000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reverse-list')
  AND locale = 'en';

------------------------------------------------------------
-- #24 merge-sorted-lists
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes in both lists is in the range `[0, 50]`.
- `-100 <= Node.val <= 100`
- Both `list1` and `list2` are sorted in non-decreasing order.'
WHERE slug = 'merge-sorted-lists';

UPDATE problem_translations SET constraints =
'- The number of nodes in both lists is in the range `[0, 50]`.
- `-100 <= Node.val <= 100`
- Both `list1` and `list2` are sorted in non-decreasing order.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-sorted-lists')
  AND locale = 'en';

------------------------------------------------------------
-- #25 cycle-detection
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of the nodes in the list is in the range `[0, 10^4]`.
- `-10^5 <= Node.val <= 10^5`
- `pos` is `-1` or a valid index in the linked-list.'
WHERE slug = 'cycle-detection';

UPDATE problem_translations SET constraints =
'- The number of the nodes in the list is in the range `[0, 10^4]`.
- `-10^5 <= Node.val <= 10^5`
- `pos` is `-1` or a valid index in the linked-list.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cycle-detection')
  AND locale = 'en';

------------------------------------------------------------
-- #26 remove-from-end
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes in the list is `sz`.
- `1 <= sz <= 30`
- `0 <= Node.val <= 100`
- `1 <= n <= sz`'
WHERE slug = 'remove-from-end';

UPDATE problem_translations SET constraints =
'- The number of nodes in the list is `sz`.
- `1 <= sz <= 30`
- `0 <= Node.val <= 100`
- `1 <= n <= sz`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'remove-from-end')
  AND locale = 'en';

------------------------------------------------------------
-- #27 mirror-tree
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes in the tree is in the range `[0, 100]`.
- `-100 <= Node.val <= 100`'
WHERE slug = 'mirror-tree';

UPDATE problem_translations SET constraints =
'- The number of nodes in the tree is in the range `[0, 100]`.
- `-100 <= Node.val <= 100`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'mirror-tree')
  AND locale = 'en';

------------------------------------------------------------
-- #28 tree-depth
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes in the tree is in the range `[0, 10^4]`.
- `-100 <= Node.val <= 100`'
WHERE slug = 'tree-depth';

UPDATE problem_translations SET constraints =
'- The number of nodes in the tree is in the range `[0, 10^4]`.
- `-100 <= Node.val <= 100`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-depth')
  AND locale = 'en';

------------------------------------------------------------
-- #29 identical-trees
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes in both trees is in the range `[0, 100]`.
- `-10^4 <= Node.val <= 10^4`'
WHERE slug = 'identical-trees';

UPDATE problem_translations SET constraints =
'- The number of nodes in both trees is in the range `[0, 100]`.
- `-10^4 <= Node.val <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'identical-trees')
  AND locale = 'en';

------------------------------------------------------------
-- #30 tree-within-tree
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes in the `root` tree is in the range `[1, 2000]`.
- The number of nodes in the `subRoot` tree is in the range `[1, 1000]`.
- `-10^4 <= root.val <= 10^4`
- `-10^4 <= subRoot.val <= 10^4`'
WHERE slug = 'tree-within-tree';

UPDATE problem_translations SET constraints =
'- The number of nodes in the `root` tree is in the range `[1, 2000]`.
- The number of nodes in the `subRoot` tree is in the range `[1, 1000]`.
- `-10^4 <= root.val <= 10^4`
- `-10^4 <= subRoot.val <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-within-tree')
  AND locale = 'en';

------------------------------------------------------------
-- #31 level-traversal
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes in the tree is in the range `[0, 2000]`.
- `-1000 <= Node.val <= 1000`'
WHERE slug = 'level-traversal';

UPDATE problem_translations SET constraints =
'- The number of nodes in the tree is in the range `[0, 2000]`.
- `-1000 <= Node.val <= 1000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'level-traversal')
  AND locale = 'en';

------------------------------------------------------------
-- #32 bst-validator
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes in the tree is in the range `[1, 10^4]`.
- `-2^31 <= Node.val <= 2^31 - 1`'
WHERE slug = 'bst-validator';

UPDATE problem_translations SET constraints =
'- The number of nodes in the tree is in the range `[1, 10^4]`.
- `-2^31 <= Node.val <= 2^31 - 1`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bst-validator')
  AND locale = 'en';

------------------------------------------------------------
-- #33 bst-ancestor
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes in the tree is in the range `[2, 10^5]`.
- `-10^9 <= Node.val <= 10^9`
- All `Node.val` are unique.
- `p != q`
- `p` and `q` will exist in the BST.'
WHERE slug = 'bst-ancestor';

UPDATE problem_translations SET constraints =
'- The number of nodes in the tree is in the range `[2, 10^5]`.
- `-10^9 <= Node.val <= 10^9`
- All `Node.val` are unique.
- `p != q`
- `p` and `q` will exist in the BST.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bst-ancestor')
  AND locale = 'en';

------------------------------------------------------------
-- #34 all-subsets
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 10`
- `-10 <= nums[i] <= 10`
- All the numbers of `nums` are unique.'
WHERE slug = 'all-subsets';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 10`
- `-10 <= nums[i] <= 10`
- All the numbers of `nums` are unique.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'all-subsets')
  AND locale = 'en';

------------------------------------------------------------
-- #35 target-combinations
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= candidates.length <= 30`
- `2 <= candidates[i] <= 40`
- All elements of `candidates` are distinct.
- `1 <= target <= 40`'
WHERE slug = 'target-combinations';

UPDATE problem_translations SET constraints =
'- `1 <= candidates.length <= 30`
- `2 <= candidates[i] <= 40`
- All elements of `candidates` are distinct.
- `1 <= target <= 40`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'target-combinations')
  AND locale = 'en';

------------------------------------------------------------
-- #36 all-arrangements
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 6`
- `-10 <= nums[i] <= 10`
- All the integers of `nums` are unique.'
WHERE slug = 'all-arrangements';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 6`
- `-10 <= nums[i] <= 10`
- All the integers of `nums` are unique.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'all-arrangements')
  AND locale = 'en';

------------------------------------------------------------
-- #37 island-counter
------------------------------------------------------------
UPDATE problems SET constraints =
'- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 300`
- `grid[i][j]` is `''0''` or `''1''`.'
WHERE slug = 'island-counter';

UPDATE problem_translations SET constraints =
'- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 300`
- `grid[i][j]` is `''0''` or `''1''`.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'island-counter')
  AND locale = 'en';

------------------------------------------------------------
-- #38 graph-copy
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes in the graph is in the range `[0, 100]`.
- `1 <= Node.val <= 100`
- `Node.val` is unique for each node.
- There are no repeated edges and no self-loops in the graph.'
WHERE slug = 'graph-copy';

UPDATE problem_translations SET constraints =
'- The number of nodes in the graph is in the range `[0, 100]`.
- `1 <= Node.val <= 100`
- `Node.val` is unique for each node.
- There are no repeated edges and no self-loops in the graph.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'graph-copy')
  AND locale = 'en';

------------------------------------------------------------
-- #39 course-planner
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= numCourses <= 2000`
- `0 <= prerequisites.length <= 5000`
- `prerequisites[i].length == 2`
- `0 <= a_i, b_i < numCourses`
- All the pairs `prerequisites[i]` are unique.'
WHERE slug = 'course-planner';

UPDATE problem_translations SET constraints =
'- `1 <= numCourses <= 2000`
- `0 <= prerequisites.length <= 5000`
- `prerequisites[i].length == 2`
- `0 <= a_i, b_i < numCourses`
- All the pairs `prerequisites[i]` are unique.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'course-planner')
  AND locale = 'en';

------------------------------------------------------------
-- #40 staircase
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= n <= 45`'
WHERE slug = 'staircase';

UPDATE problem_translations SET constraints =
'- `1 <= n <= 45`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'staircase')
  AND locale = 'en';

------------------------------------------------------------
-- #41 house-thief
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 100`
- `0 <= nums[i] <= 400`'
WHERE slug = 'house-thief';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 100`
- `0 <= nums[i] <= 400`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'house-thief')
  AND locale = 'en';

------------------------------------------------------------
-- #42 coin-picker
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= coins.length <= 12`
- `1 <= coins[i] <= 2^31 - 1`
- `0 <= amount <= 10^4`'
WHERE slug = 'coin-picker';

UPDATE problem_translations SET constraints =
'- `1 <= coins.length <= 12`
- `1 <= coins[i] <= 2^31 - 1`
- `0 <= amount <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'coin-picker')
  AND locale = 'en';

------------------------------------------------------------
-- #43 longest-ascending
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 2500`
- `-10^4 <= nums[i] <= 10^4`'
WHERE slug = 'longest-ascending';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 2500`
- `-10^4 <= nums[i] <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-ascending')
  AND locale = 'en';

------------------------------------------------------------
-- #44 word-segmentation
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= s.length <= 300`
- `1 <= wordDict.length <= 1000`
- `1 <= wordDict[i].length <= 20`
- `s` and `wordDict[i]` consist of only lowercase English letters.
- All the strings of `wordDict` are unique.'
WHERE slug = 'word-segmentation';

UPDATE problem_translations SET constraints =
'- `1 <= s.length <= 300`
- `1 <= wordDict.length <= 1000`
- `1 <= wordDict[i].length <= 20`
- `s` and `wordDict[i]` consist of only lowercase English letters.
- All the strings of `wordDict` are unique.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-segmentation')
  AND locale = 'en';

------------------------------------------------------------
-- #45 largest-subarray
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`'
WHERE slug = 'largest-subarray';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'largest-subarray')
  AND locale = 'en';

------------------------------------------------------------
-- #46 reach-the-end
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 10^4`
- `0 <= nums[i] <= 10^5`'
WHERE slug = 'reach-the-end';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 10^4`
- `0 <= nums[i] <= 10^5`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reach-the-end')
  AND locale = 'en';

------------------------------------------------------------
-- #47 overlap-merge
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= intervals.length <= 10^4`
- `intervals[i].length == 2`
- `0 <= start_i <= end_i <= 10^4`'
WHERE slug = 'overlap-merge';

UPDATE problem_translations SET constraints =
'- `1 <= intervals.length <= 10^4`
- `intervals[i].length == 2`
- `0 <= start_i <= end_i <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'overlap-merge')
  AND locale = 'en';

------------------------------------------------------------
-- #48 rotate-grid
------------------------------------------------------------
UPDATE problems SET constraints =
'- `n == matrix.length == matrix[i].length`
- `1 <= n <= 20`
- `-1000 <= matrix[i][j] <= 1000`'
WHERE slug = 'rotate-grid';

UPDATE problem_translations SET constraints =
'- `n == matrix.length == matrix[i].length`
- `1 <= n <= 20`
- `-1000 <= matrix[i][j] <= 1000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rotate-grid')
  AND locale = 'en';

------------------------------------------------------------
-- #49 lone-element
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 3 * 10^4`
- `-3 * 10^4 <= nums[i] <= 3 * 10^4`
- Each element in the array appears twice except for one element which appears only once.'
WHERE slug = 'lone-element';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 3 * 10^4`
- `-3 * 10^4 <= nums[i] <= 3 * 10^4`
- Each element in the array appears twice except for one element which appears only once.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'lone-element')
  AND locale = 'en';

------------------------------------------------------------
-- #50 kth-largest-stream
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= k <= 10^4`
- `0 <= nums.length <= 10^4`
- `-10^4 <= nums[i] <= 10^4`
- `-10^4 <= val <= 10^4`
- At most `10^4` calls will be made to `add`.
- It is guaranteed that there will be at least `k` elements in the array when you search for the kth element.'
WHERE slug = 'kth-largest-stream';

UPDATE problem_translations SET constraints =
'- `1 <= k <= 10^4`
- `0 <= nums.length <= 10^4`
- `-10^4 <= nums[i] <= 10^4`
- `-10^4 <= val <= 10^4`
- At most `10^4` calls will be made to `add`.
- It is guaranteed that there will be at least `k` elements in the array when you search for the kth element.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'kth-largest-stream')
  AND locale = 'en';
