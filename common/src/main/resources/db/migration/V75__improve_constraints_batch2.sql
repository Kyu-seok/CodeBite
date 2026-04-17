-- Reformat constraints for problems #51–#100: add markdown bullets and backtick-wrap technical expressions

------------------------------------------------------------
-- #51 color-sort
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 300`
- `nums[i]` is `0`, `1`, or `2`.'
WHERE slug = 'color-sort';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 300`
- `nums[i]` is `0`, `1`, or `2`.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'color-sort')
  AND locale = 'en';

------------------------------------------------------------
-- #52 next-arrangement
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 100`
- `0 <= nums[i] <= 100`'
WHERE slug = 'next-arrangement';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 100`
- `0 <= nums[i] <= 100`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'next-arrangement')
  AND locale = 'en';

------------------------------------------------------------
-- #53 first-missing-positive
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 10^5`
- `-2^31 <= nums[i] <= 2^31 - 1`'
WHERE slug = 'first-missing-positive';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 10^5`
- `-2^31 <= nums[i] <= 2^31 - 1`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'first-missing-positive')
  AND locale = 'en';

------------------------------------------------------------
-- #54 rain-collector
------------------------------------------------------------
UPDATE problems SET constraints =
'- `n == height.length`
- `1 <= n <= 2 * 10^4`
- `0 <= height[i] <= 10^5`'
WHERE slug = 'rain-collector';

UPDATE problem_translations SET constraints =
'- `n == height.length`
- `1 <= n <= 2 * 10^4`
- `0 <= height[i] <= 10^5`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rain-collector')
  AND locale = 'en';

------------------------------------------------------------
-- #55 move-zeroes
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 10^4`
- `-2^31 <= nums[i] <= 2^31 - 1`'
WHERE slug = 'move-zeroes';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 10^4`
- `-2^31 <= nums[i] <= 2^31 - 1`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'move-zeroes')
  AND locale = 'en';

------------------------------------------------------------
-- #56 substring-permutation
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= s1.length, s2.length <= 10^4`
- `s1` and `s2` consist of lowercase English letters.'
WHERE slug = 'substring-permutation';

UPDATE problem_translations SET constraints =
'- `1 <= s1.length, s2.length <= 10^4`
- `s1` and `s2` consist of lowercase English letters.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'substring-permutation')
  AND locale = 'en';

------------------------------------------------------------
-- #57 window-maximum
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`
- `1 <= k <= nums.length`'
WHERE slug = 'window-maximum';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`
- `1 <= k <= nums.length`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'window-maximum')
  AND locale = 'en';

------------------------------------------------------------
-- #58 polish-notation
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= tokens.length <= 10^4`
- `tokens[i]` is an operator (`+`, `-`, `*`, `/`) or an integer in the range `[-200, 200]`.'
WHERE slug = 'polish-notation';

UPDATE problem_translations SET constraints =
'- `1 <= tokens.length <= 10^4`
- `tokens[i]` is an operator (`+`, `-`, `*`, `/`) or an integer in the range `[-200, 200]`.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'polish-notation')
  AND locale = 'en';

------------------------------------------------------------
-- #59 parentheses-generator
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= n <= 8`'
WHERE slug = 'parentheses-generator';

UPDATE problem_translations SET constraints =
'- `1 <= n <= 8`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'parentheses-generator')
  AND locale = 'en';

------------------------------------------------------------
-- #60 temperature-wait
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= temperatures.length <= 10^5`
- `30 <= temperatures[i] <= 100`'
WHERE slug = 'temperature-wait';

UPDATE problem_translations SET constraints =
'- `1 <= temperatures.length <= 10^5`
- `30 <= temperatures[i] <= 100`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'temperature-wait')
  AND locale = 'en';

------------------------------------------------------------
-- #61 search-rotated-array
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 5000`
- `-10^4 <= nums[i] <= 10^4`
- All values of `nums` are unique.
- `nums` is guaranteed to be rotated at some pivot.
- `-10^4 <= target <= 10^4`'
WHERE slug = 'search-rotated-array';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 5000`
- `-10^4 <= nums[i] <= 10^4`
- All values of `nums` are unique.
- `nums` is guaranteed to be rotated at some pivot.
- `-10^4 <= target <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'search-rotated-array')
  AND locale = 'en';

------------------------------------------------------------
-- #62 koko-bananas
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= piles.length <= 10^4`
- `piles.length <= h <= 10^9`
- `1 <= piles[i] <= 10^9`'
WHERE slug = 'koko-bananas';

UPDATE problem_translations SET constraints =
'- `1 <= piles.length <= 10^4`
- `piles.length <= h <= 10^9`
- `1 <= piles[i] <= 10^9`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'koko-bananas')
  AND locale = 'en';

------------------------------------------------------------
-- #63 find-peak
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 1000`
- `-2^31 <= nums[i] <= 2^31 - 1`
- `nums[i] != nums[i + 1]` for all valid `i`.'
WHERE slug = 'find-peak';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 1000`
- `-2^31 <= nums[i] <= 2^31 - 1`
- `nums[i] != nums[i + 1]` for all valid `i`.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'find-peak')
  AND locale = 'en';

------------------------------------------------------------
-- #64 reorder-list
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes is in the range `[1, 5 * 10^4]`.
- `1 <= Node.val <= 1000`'
WHERE slug = 'reorder-list';

UPDATE problem_translations SET constraints =
'- The number of nodes is in the range `[1, 5 * 10^4]`.
- `1 <= Node.val <= 1000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reorder-list')
  AND locale = 'en';

------------------------------------------------------------
-- #65 add-two-numbers
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes in each linked list is in the range `[1, 100]`.
- `0 <= Node.val <= 9`
- It is guaranteed that the list represents a number that does not have leading zeros.'
WHERE slug = 'add-two-numbers';

UPDATE problem_translations SET constraints =
'- The number of nodes in each linked list is in the range `[1, 100]`.
- `0 <= Node.val <= 9`
- It is guaranteed that the list represents a number that does not have leading zeros.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'add-two-numbers')
  AND locale = 'en';

------------------------------------------------------------
-- #66 copy-random-list
------------------------------------------------------------
UPDATE problems SET constraints =
'- `0 <= n <= 1000`
- `-10^4 <= Node.val <= 10^4`
- `Node.random` is `null` or is pointing to some node in the linked list.'
WHERE slug = 'copy-random-list';

UPDATE problem_translations SET constraints =
'- `0 <= n <= 1000`
- `-10^4 <= Node.val <= 10^4`
- `Node.random` is `null` or is pointing to some node in the linked list.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'copy-random-list')
  AND locale = 'en';

------------------------------------------------------------
-- #67 merge-k-lists
------------------------------------------------------------
UPDATE problems SET constraints =
'- `k == lists.length`
- `0 <= k <= 10^4`
- `0 <= lists[i].length <= 500`
- `-10^4 <= lists[i][j] <= 10^4`
- `lists[i]` is sorted in ascending order.
- The sum of `lists[i].length` will not exceed `10^4`.'
WHERE slug = 'merge-k-lists';

UPDATE problem_translations SET constraints =
'- `k == lists.length`
- `0 <= k <= 10^4`
- `0 <= lists[i].length <= 500`
- `-10^4 <= lists[i][j] <= 10^4`
- `lists[i]` is sorted in ascending order.
- The sum of `lists[i].length` will not exceed `10^4`.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-k-lists')
  AND locale = 'en';

------------------------------------------------------------
-- #68 kth-smallest-bst
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes in the tree is `n`.
- `1 <= k <= n <= 10^4`
- `0 <= Node.val <= 10^4`'
WHERE slug = 'kth-smallest-bst';

UPDATE problem_translations SET constraints =
'- The number of nodes in the tree is `n`.
- `1 <= k <= n <= 10^4`
- `0 <= Node.val <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'kth-smallest-bst')
  AND locale = 'en';

------------------------------------------------------------
-- #69 build-tree
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= preorder.length <= 3000`
- `inorder.length == preorder.length`
- `-3000 <= preorder[i], inorder[i] <= 3000`
- `preorder` and `inorder` consist of unique values.
- Each value of `inorder` also appears in `preorder`.
- `preorder` is guaranteed to be the preorder traversal of the tree.
- `inorder` is guaranteed to be the inorder traversal of the tree.'
WHERE slug = 'build-tree';

UPDATE problem_translations SET constraints =
'- `1 <= preorder.length <= 3000`
- `inorder.length == preorder.length`
- `-3000 <= preorder[i], inorder[i] <= 3000`
- `preorder` and `inorder` consist of unique values.
- Each value of `inorder` also appears in `preorder`.
- `preorder` is guaranteed to be the preorder traversal of the tree.
- `inorder` is guaranteed to be the inorder traversal of the tree.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'build-tree')
  AND locale = 'en';

------------------------------------------------------------
-- #70 right-side-view
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes in the tree is in the range `[0, 100]`.
- `-100 <= Node.val <= 100`'
WHERE slug = 'right-side-view';

UPDATE problem_translations SET constraints =
'- The number of nodes in the tree is in the range `[0, 100]`.
- `-100 <= Node.val <= 100`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'right-side-view')
  AND locale = 'en';

------------------------------------------------------------
-- #71 tree-diameter
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes in the tree is in the range `[1, 10^4]`.
- `-100 <= Node.val <= 100`'
WHERE slug = 'tree-diameter';

UPDATE problem_translations SET constraints =
'- The number of nodes in the tree is in the range `[1, 10^4]`.
- `-100 <= Node.val <= 100`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-diameter')
  AND locale = 'en';

------------------------------------------------------------
-- #72 max-path-sum
------------------------------------------------------------
UPDATE problems SET constraints =
'- The number of nodes in the tree is in the range `[1, 3 * 10^4]`.
- `-1000 <= Node.val <= 1000`'
WHERE slug = 'max-path-sum';

UPDATE problem_translations SET constraints =
'- The number of nodes in the tree is in the range `[1, 3 * 10^4]`.
- `-1000 <= Node.val <= 1000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'max-path-sum')
  AND locale = 'en';

------------------------------------------------------------
-- #73 prefix-tree
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= word.length, prefix.length <= 2000`
- `word` and `prefix` consist only of lowercase English letters.
- At most `3 * 10^4` calls in total will be made to `insert`, `search`, and `startsWith`.'
WHERE slug = 'prefix-tree';

UPDATE problem_translations SET constraints =
'- `1 <= word.length, prefix.length <= 2000`
- `word` and `prefix` consist only of lowercase English letters.
- At most `3 * 10^4` calls in total will be made to `insert`, `search`, and `startsWith`.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'prefix-tree')
  AND locale = 'en';

------------------------------------------------------------
-- #74 word-dictionary
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= word.length <= 25`
- `word` in `addWord` consists of lowercase English letters.
- `word` in `search` consist of `''.''` or lowercase English letters.
- At most `10^4` calls will be made to `addWord` and `search`.'
WHERE slug = 'word-dictionary';

UPDATE problem_translations SET constraints =
'- `1 <= word.length <= 25`
- `word` in `addWord` consists of lowercase English letters.
- `word` in `search` consist of `''.''` or lowercase English letters.
- At most `10^4` calls will be made to `addWord` and `search`.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-dictionary')
  AND locale = 'en';

------------------------------------------------------------
-- #75 word-finder
------------------------------------------------------------
UPDATE problems SET constraints =
'- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 12`
- `board[i][j]` is a lowercase English letter.
- `1 <= words.length <= 3 * 10^4`
- `1 <= words[i].length <= 10`
- `words[i]` consists of lowercase English letters.
- All the strings of `words` are unique.'
WHERE slug = 'word-finder';

UPDATE problem_translations SET constraints =
'- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 12`
- `board[i][j]` is a lowercase English letter.
- `1 <= words.length <= 3 * 10^4`
- `1 <= words[i].length <= 10`
- `words[i]` consists of lowercase English letters.
- All the strings of `words` are unique.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-finder')
  AND locale = 'en';

------------------------------------------------------------
-- #76 last-stone
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= stones.length <= 30`
- `1 <= stones[i] <= 1000`'
WHERE slug = 'last-stone';

UPDATE problem_translations SET constraints =
'- `1 <= stones.length <= 30`
- `1 <= stones[i] <= 1000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'last-stone')
  AND locale = 'en';

------------------------------------------------------------
-- #77 k-closest-points
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= k <= points.length <= 10^4`
- `-10^4 <= x, y <= 10^4`'
WHERE slug = 'k-closest-points';

UPDATE problem_translations SET constraints =
'- `1 <= k <= points.length <= 10^4`
- `-10^4 <= x, y <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'k-closest-points')
  AND locale = 'en';

------------------------------------------------------------
-- #78 array-kth-largest
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= k <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`'
WHERE slug = 'array-kth-largest';

UPDATE problem_translations SET constraints =
'- `1 <= k <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'array-kth-largest')
  AND locale = 'en';

------------------------------------------------------------
-- #79 queen-placement
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= n <= 9`'
WHERE slug = 'queen-placement';

UPDATE problem_translations SET constraints =
'- `1 <= n <= 9`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'queen-placement')
  AND locale = 'en';

------------------------------------------------------------
-- #80 word-search
------------------------------------------------------------
UPDATE problems SET constraints =
'- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 6`
- `1 <= word.length <= 15`
- `board` and `word` consists of only lowercase and uppercase English letters.'
WHERE slug = 'word-search';

UPDATE problem_translations SET constraints =
'- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 6`
- `1 <= word.length <= 15`
- `board` and `word` consists of only lowercase and uppercase English letters.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-search')
  AND locale = 'en';

------------------------------------------------------------
-- #81 phone-combos
------------------------------------------------------------
UPDATE problems SET constraints =
'- `0 <= digits.length <= 4`
- `digits[i]` is a digit in the range `[''2'', ''9'']`.'
WHERE slug = 'phone-combos';

UPDATE problem_translations SET constraints =
'- `0 <= digits.length <= 4`
- `digits[i]` is a digit in the range `[''2'', ''9'']`.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'phone-combos')
  AND locale = 'en';

------------------------------------------------------------
-- #82 pacific-atlantic
------------------------------------------------------------
UPDATE problems SET constraints =
'- `m == heights.length`
- `n == heights[r].length`
- `1 <= m, n <= 200`
- `0 <= heights[r][c] <= 10^5`'
WHERE slug = 'pacific-atlantic';

UPDATE problem_translations SET constraints =
'- `m == heights.length`
- `n == heights[r].length`
- `1 <= m, n <= 200`
- `0 <= heights[r][c] <= 10^5`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pacific-atlantic')
  AND locale = 'en';

------------------------------------------------------------
-- #83 course-order
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= numCourses <= 2000`
- `0 <= prerequisites.length <= numCourses * (numCourses - 1)`
- `prerequisites[i].length == 2`
- `0 <= a, b < numCourses`
- `a != b`
- All the pairs `[a, b]` are distinct.'
WHERE slug = 'course-order';

UPDATE problem_translations SET constraints =
'- `1 <= numCourses <= 2000`
- `0 <= prerequisites.length <= numCourses * (numCourses - 1)`
- `prerequisites[i].length == 2`
- `0 <= a, b < numCourses`
- `a != b`
- All the pairs `[a, b]` are distinct.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'course-order')
  AND locale = 'en';

------------------------------------------------------------
-- #84 connected-components
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= n <= 2000`
- `0 <= edges.length <= 5000`
- `edges[i].length == 2`
- `0 <= a, b < n`
- `a != b`
- There are no repeated edges.'
WHERE slug = 'connected-components';

UPDATE problem_translations SET constraints =
'- `1 <= n <= 2000`
- `0 <= edges.length <= 5000`
- `edges[i].length == 2`
- `0 <= a, b < n`
- `a != b`
- There are no repeated edges.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'connected-components')
  AND locale = 'en';

------------------------------------------------------------
-- #85 rotting-oranges
------------------------------------------------------------
UPDATE problems SET constraints =
'- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 10`
- `grid[i][j]` is `0`, `1`, or `2`.'
WHERE slug = 'rotting-oranges';

UPDATE problem_translations SET constraints =
'- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 10`
- `grid[i][j]` is `0`, `1`, or `2`.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rotting-oranges')
  AND locale = 'en';

------------------------------------------------------------
-- #86 account-merger
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= accounts.length <= 1000`
- `2 <= accounts[i].length <= 10`
- `1 <= accounts[i][j].length <= 30`
- `accounts[i][0]` consists of English letters.
- `accounts[i][j]` (for `j > 0`) is a valid email.'
WHERE slug = 'account-merger';

UPDATE problem_translations SET constraints =
'- `1 <= accounts.length <= 1000`
- `2 <= accounts[i].length <= 10`
- `1 <= accounts[i][j].length <= 30`
- `accounts[i][0]` consists of English letters.
- `accounts[i][j]` (for `j > 0`) is a valid email.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'account-merger')
  AND locale = 'en';

------------------------------------------------------------
-- #87 house-thief-ii
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 100`
- `0 <= nums[i] <= 1000`'
WHERE slug = 'house-thief-ii';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 100`
- `0 <= nums[i] <= 1000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'house-thief-ii')
  AND locale = 'en';

------------------------------------------------------------
-- #88 decode-ways
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= s.length <= 100`
- `s` contains only digits and may contain leading zeros.'
WHERE slug = 'decode-ways';

UPDATE problem_translations SET constraints =
'- `1 <= s.length <= 100`
- `s` contains only digits and may contain leading zeros.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'decode-ways')
  AND locale = 'en';

------------------------------------------------------------
-- #89 max-product-subarray
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 2 * 10^4`
- `-10 <= nums[i] <= 10`
- The product of any subarray of `nums` is guaranteed to fit in a 32-bit integer.'
WHERE slug = 'max-product-subarray';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 2 * 10^4`
- `-10 <= nums[i] <= 10`
- The product of any subarray of `nums` is guaranteed to fit in a 32-bit integer.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'max-product-subarray')
  AND locale = 'en';

------------------------------------------------------------
-- #90 palindrome-count
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= s.length <= 1000`
- `s` consists of lowercase English letters.'
WHERE slug = 'palindrome-count';

UPDATE problem_translations SET constraints =
'- `1 <= s.length <= 1000`
- `s` consists of lowercase English letters.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'palindrome-count')
  AND locale = 'en';

------------------------------------------------------------
-- #91 unique-paths
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= m, n <= 100`'
WHERE slug = 'unique-paths';

UPDATE problem_translations SET constraints =
'- `1 <= m, n <= 100`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-paths')
  AND locale = 'en';

------------------------------------------------------------
-- #92 longest-common-subseq
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= text1.length, text2.length <= 1000`
- `text1` and `text2` consist of only lowercase English characters.'
WHERE slug = 'longest-common-subseq';

UPDATE problem_translations SET constraints =
'- `1 <= text1.length, text2.length <= 1000`
- `text1` and `text2` consist of only lowercase English characters.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-common-subseq')
  AND locale = 'en';

------------------------------------------------------------
-- #93 edit-distance
------------------------------------------------------------
UPDATE problems SET constraints =
'- `0 <= word1.length, word2.length <= 500`
- `word1` and `word2` consist of lowercase English letters.'
WHERE slug = 'edit-distance';

UPDATE problem_translations SET constraints =
'- `0 <= word1.length, word2.length <= 500`
- `word1` and `word2` consist of lowercase English letters.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'edit-distance')
  AND locale = 'en';

------------------------------------------------------------
-- #94 jump-game-ii
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= nums.length <= 10^4`
- `0 <= nums[i] <= 1000`
- It is guaranteed that you can reach `nums[n - 1]`.'
WHERE slug = 'jump-game-ii';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 10^4`
- `0 <= nums[i] <= 1000`
- It is guaranteed that you can reach `nums[n - 1]`.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'jump-game-ii')
  AND locale = 'en';

------------------------------------------------------------
-- #95 gas-station
------------------------------------------------------------
UPDATE problems SET constraints =
'- `n == gas.length == cost.length`
- `1 <= n <= 10^5`
- `0 <= gas[i], cost[i] <= 10^4`'
WHERE slug = 'gas-station';

UPDATE problem_translations SET constraints =
'- `n == gas.length == cost.length`
- `1 <= n <= 10^5`
- `0 <= gas[i], cost[i] <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'gas-station')
  AND locale = 'en';

------------------------------------------------------------
-- #96 insert-interval
------------------------------------------------------------
UPDATE problems SET constraints =
'- `0 <= intervals.length <= 10^4`
- `intervals[i].length == 2`
- `0 <= start <= end <= 10^5`
- `intervals` is sorted by `start` in ascending order.
- `newInterval.length == 2`
- `0 <= start <= end <= 10^5`'
WHERE slug = 'insert-interval';

UPDATE problem_translations SET constraints =
'- `0 <= intervals.length <= 10^4`
- `intervals[i].length == 2`
- `0 <= start <= end <= 10^5`
- `intervals` is sorted by `start` in ascending order.
- `newInterval.length == 2`
- `0 <= start <= end <= 10^5`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'insert-interval')
  AND locale = 'en';

------------------------------------------------------------
-- #97 non-overlapping
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= intervals.length <= 10^5`
- `intervals[i].length == 2`
- `-5 * 10^4 <= start < end <= 5 * 10^4`'
WHERE slug = 'non-overlapping';

UPDATE problem_translations SET constraints =
'- `1 <= intervals.length <= 10^5`
- `intervals[i].length == 2`
- `-5 * 10^4 <= start < end <= 5 * 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'non-overlapping')
  AND locale = 'en';

------------------------------------------------------------
-- #98 meeting-rooms
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= intervals.length <= 10^4`
- `0 <= start < end <= 10^6`'
WHERE slug = 'meeting-rooms';

UPDATE problem_translations SET constraints =
'- `1 <= intervals.length <= 10^4`
- `0 <= start < end <= 10^6`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'meeting-rooms')
  AND locale = 'en';

------------------------------------------------------------
-- #99 spiral-matrix
------------------------------------------------------------
UPDATE problems SET constraints =
'- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= m, n <= 10`
- `-100 <= matrix[i][j] <= 100`'
WHERE slug = 'spiral-matrix';

UPDATE problem_translations SET constraints =
'- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= m, n <= 10`
- `-100 <= matrix[i][j] <= 100`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'spiral-matrix')
  AND locale = 'en';

------------------------------------------------------------
-- #100 count-bits
------------------------------------------------------------
UPDATE problems SET constraints =
'- `1 <= n <= 2^31 - 1`'
WHERE slug = 'count-bits';

UPDATE problem_translations SET constraints =
'- `1 <= n <= 2^31 - 1`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-bits')
  AND locale = 'en';
