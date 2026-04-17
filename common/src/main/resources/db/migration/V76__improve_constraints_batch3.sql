-- Reformat constraints for Phase 3 problems (#101-200) with markdown bullets and backticks

------------------------------------------------------------
-- #101 popular-vote
UPDATE problems SET constraints =
'- `1 <= nums.length <= 50000`
- `-10^9 <= nums[i] <= 10^9`'
WHERE slug = 'popular-vote';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 50000`
- `-10^9 <= nums[i] <= 10^9`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'popular-vote') AND locale = 'en';

------------------------------------------------------------
-- #102 remove-sorted-dupes
UPDATE problems SET constraints =
'- `1 <= nums.length <= 3 * 10^4`
- `-100 <= nums[i] <= 100`
- nums is sorted in non-decreasing order'
WHERE slug = 'remove-sorted-dupes';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 3 * 10^4`
- `-100 <= nums[i] <= 100`
- nums is sorted in non-decreasing order'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'remove-sorted-dupes') AND locale = 'en';

------------------------------------------------------------
-- #103 duplicate-finder
UPDATE problems SET constraints =
'- `n == nums.length`
- `1 <= n <= 10^5`
- `1 <= nums[i] <= n`
- Each element appears once or twice'
WHERE slug = 'duplicate-finder';

UPDATE problem_translations SET constraints =
'- `n == nums.length`
- `1 <= n <= 10^5`
- `1 <= nums[i] <= n`
- Each element appears once or twice'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'duplicate-finder') AND locale = 'en';

------------------------------------------------------------
-- #104 target-subarray
UPDATE problems SET constraints =
'- `1 <= nums.length <= 20000`
- `-1000 <= nums[i] <= 1000`
- `-10^7 <= k <= 10^7`'
WHERE slug = 'target-subarray';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 20000`
- `-1000 <= nums[i] <= 1000`
- `-10^7 <= k <= 10^7`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'target-subarray') AND locale = 'en';

------------------------------------------------------------
-- #105 k-distinct-window
UPDATE problems SET constraints =
'- `1 <= s.length <= 50000`
- `0 <= k <= 50`
- s consists of lowercase English letters'
WHERE slug = 'k-distinct-window';

UPDATE problem_translations SET constraints =
'- `1 <= s.length <= 50000`
- `0 <= k <= 50`
- s consists of lowercase English letters'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'k-distinct-window') AND locale = 'en';

------------------------------------------------------------
-- #106 quad-sum
UPDATE problems SET constraints =
'- `1 <= nums.length <= 200`
- `-10^9 <= nums[i] <= 10^9`
- `-10^9 <= target <= 10^9`'
WHERE slug = 'quad-sum';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 200`
- `-10^9 <= nums[i] <= 10^9`
- `-10^9 <= target <= 10^9`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'quad-sum') AND locale = 'en';

------------------------------------------------------------
-- #107 boat-loading
UPDATE problems SET constraints =
'- `1 <= weights.length <= 50000`
- `1 <= weights[i] <= capacity <= 30000`'
WHERE slug = 'boat-loading';

UPDATE problem_translations SET constraints =
'- `1 <= weights.length <= 50000`
- `1 <= weights[i] <= capacity <= 30000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'boat-loading') AND locale = 'en';

------------------------------------------------------------
-- #108 sorted-squares
UPDATE problems SET constraints =
'- `1 <= nums.length <= 10000`
- `-10000 <= nums[i] <= 10000`
- nums is sorted in non-decreasing order'
WHERE slug = 'sorted-squares';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 10000`
- `-10000 <= nums[i] <= 10000`
- nums is sorted in non-decreasing order'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sorted-squares') AND locale = 'en';

------------------------------------------------------------
-- #109 shortest-cover
UPDATE problems SET constraints =
'- `1 <= nums.length <= 100000`
- `1 <= nums[i] <= 10000`
- `1 <= target <= 10^9`'
WHERE slug = 'shortest-cover';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 100000`
- `1 <= nums[i] <= 10000`
- `1 <= target <= 10^9`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shortest-cover') AND locale = 'en';

------------------------------------------------------------
-- #110 fruit-picker
UPDATE problems SET constraints =
'- `1 <= items.length <= 10^5`
- `0 <= items[i] < items.length`'
WHERE slug = 'fruit-picker';

UPDATE problem_translations SET constraints =
'- `1 <= items.length <= 10^5`
- `0 <= items[i] < items.length`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fruit-picker') AND locale = 'en';

------------------------------------------------------------
-- #111 car-convoy
UPDATE problems SET constraints =
'- `1 <= n <= 10^5`
- `0 <= position[i] < target <= 10^9`
- `1 <= speed[i] <= 10^6`
- All values in `position` are distinct'
WHERE slug = 'car-convoy';

UPDATE problem_translations SET constraints =
'- `1 <= n <= 10^5`
- `0 <= position[i] < target <= 10^9`
- `1 <= speed[i] <= 10^6`
- All values in `position` are distinct'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'car-convoy') AND locale = 'en';

------------------------------------------------------------
-- #112 tallest-bar
UPDATE problems SET constraints =
'- `1 <= heights.length <= 10^5`
- `0 <= heights[i] <= 10^4`'
WHERE slug = 'tallest-bar';

UPDATE problem_translations SET constraints =
'- `1 <= heights.length <= 10^5`
- `0 <= heights[i] <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tallest-bar') AND locale = 'en';

------------------------------------------------------------
-- #113 space-rocks
UPDATE problems SET constraints =
'- `2 <= rocks.length <= 10^4`
- `-1000 <= rocks[i] <= 1000`
- `rocks[i] != 0`'
WHERE slug = 'space-rocks';

UPDATE problem_translations SET constraints =
'- `2 <= rocks.length <= 10^4`
- `-1000 <= rocks[i] <= 1000`
- `rocks[i] != 0`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'space-rocks') AND locale = 'en';

------------------------------------------------------------
-- #114 time-map
UPDATE problems SET constraints =
'- `1 <= key.length, value.length <= 100`
- `1 <= timestamp <= 10^7`
- All timestamps for set operations are strictly increasing per key
- At most `2 * 10^5` calls to set and get'
WHERE slug = 'time-map';

UPDATE problem_translations SET constraints =
'- `1 <= key.length, value.length <= 100`
- `1 <= timestamp <= 10^7`
- All timestamps for set operations are strictly increasing per key
- At most `2 * 10^5` calls to set and get'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'time-map') AND locale = 'en';

------------------------------------------------------------
-- #115 sorted-median
UPDATE problems SET constraints =
'- `0 <= nums1.length, nums2.length <= 1000`
- `1 <= nums1.length + nums2.length <= 2000`
- `-10^6 <= nums1[i], nums2[i] <= 10^6`
- Both arrays are sorted in non-decreasing order'
WHERE slug = 'sorted-median';

UPDATE problem_translations SET constraints =
'- `0 <= nums1.length, nums2.length <= 1000`
- `1 <= nums1.length + nums2.length <= 2000`
- `-10^6 <= nums1[i], nums2[i] <= 10^6`
- Both arrays are sorted in non-decreasing order'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sorted-median') AND locale = 'en';

------------------------------------------------------------
-- #116 matrix-search-ii
UPDATE problems SET constraints =
'- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= m, n <= 300`
- `-10^9 <= matrix[i][j] <= 10^9`
- `-10^9 <= target <= 10^9`'
WHERE slug = 'matrix-search-ii';

UPDATE problem_translations SET constraints =
'- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= m, n <= 300`
- `-10^9 <= matrix[i][j] <= 10^9`
- `-10^9 <= target <= 10^9`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'matrix-search-ii') AND locale = 'en';

------------------------------------------------------------
-- #117 ship-capacity
UPDATE problems SET constraints =
'- `1 <= days <= weights.length <= 5 * 10^4`
- `1 <= weights[i] <= 500`'
WHERE slug = 'ship-capacity';

UPDATE problem_translations SET constraints =
'- `1 <= days <= weights.length <= 5 * 10^4`
- `1 <= weights[i] <= 500`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ship-capacity') AND locale = 'en';

------------------------------------------------------------
-- #118 recent-cache
UPDATE problems SET constraints =
'- `1 <= capacity <= 3000`
- `0 <= key <= 10^4`
- `0 <= value <= 10^5`
- At most `2 * 10^5` calls to get and put'
WHERE slug = 'recent-cache';

UPDATE problem_translations SET constraints =
'- `1 <= capacity <= 3000`
- `0 <= key <= 10^4`
- `0 <= value <= 10^5`
- At most `2 * 10^5` calls to get and put'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'recent-cache') AND locale = 'en';

------------------------------------------------------------
-- #119 reverse-k-nodes
UPDATE problems SET constraints =
'- The number of nodes in the list is `n`
- `1 <= k <= n <= 5000`
- `0 <= Node.val <= 1000`'
WHERE slug = 'reverse-k-nodes';

UPDATE problem_translations SET constraints =
'- The number of nodes in the list is `n`
- `1 <= k <= n <= 5000`
- `0 <= Node.val <= 1000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reverse-k-nodes') AND locale = 'en';

------------------------------------------------------------
-- #120 swap-pairs
UPDATE problems SET constraints =
'- `0 <= Number of nodes <= 100`
- `0 <= Node.val <= 100`'
WHERE slug = 'swap-pairs';

UPDATE problem_translations SET constraints =
'- `0 <= Number of nodes <= 100`
- `0 <= Node.val <= 100`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'swap-pairs') AND locale = 'en';

------------------------------------------------------------
-- #121 tree-codec
UPDATE problems SET constraints =
'- The number of nodes is in the range `[0, 10000]`
- `-1000 <= Node.val <= 1000`'
WHERE slug = 'tree-codec';

UPDATE problem_translations SET constraints =
'- The number of nodes is in the range `[0, 10000]`
- `-1000 <= Node.val <= 1000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-codec') AND locale = 'en';

------------------------------------------------------------
-- #122 good-node-count
UPDATE problems SET constraints =
'- The number of nodes in the tree is in the range `[1, 10^5]`
- Each node''s value is between `-10^4` and `10^4`'
WHERE slug = 'good-node-count';

UPDATE problem_translations SET constraints =
'- The number of nodes in the tree is in the range `[1, 10^5]`
- Each node''s value is between `-10^4` and `10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'good-node-count') AND locale = 'en';

------------------------------------------------------------
-- #123 height-check
UPDATE problems SET constraints =
'- `0 <= number of nodes <= 5000`
- `-10^4 <= Node.val <= 10^4`'
WHERE slug = 'height-check';

UPDATE problem_translations SET constraints =
'- `0 <= number of nodes <= 5000`
- `-10^4 <= Node.val <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'height-check') AND locale = 'en';

------------------------------------------------------------
-- #124 zigzag-levels
UPDATE problems SET constraints =
'- `0 <= number of nodes <= 2000`
- `-100 <= Node.val <= 100`'
WHERE slug = 'zigzag-levels';

UPDATE problem_translations SET constraints =
'- `0 <= number of nodes <= 2000`
- `-100 <= Node.val <= 100`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'zigzag-levels') AND locale = 'en';

------------------------------------------------------------
-- #125 target-path
UPDATE problems SET constraints =
'- `0 <= number of nodes <= 5000`
- `-1000 <= Node.val <= 1000`
- `-1000 <= target <= 1000`'
WHERE slug = 'target-path';

UPDATE problem_translations SET constraints =
'- `0 <= number of nodes <= 5000`
- `-1000 <= Node.val <= 1000`
- `-1000 <= target <= 1000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'target-path') AND locale = 'en';

------------------------------------------------------------
-- #126 right-pointers
UPDATE problems SET constraints =
'- The number of nodes is in the range `[1, 4096]`
- `-1000 <= Node.val <= 1000`
- The tree is guaranteed to be a perfect binary tree'
WHERE slug = 'right-pointers';

UPDATE problem_translations SET constraints =
'- The number of nodes is in the range `[1, 4096]`
- `-1000 <= Node.val <= 1000`
- The tree is guaranteed to be a perfect binary tree'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'right-pointers') AND locale = 'en';

------------------------------------------------------------
-- #127 root-sum
UPDATE problems SET constraints =
'- `1 <= number of nodes <= 1000`
- `0 <= Node.val <= 9`'
WHERE slug = 'root-sum';

UPDATE problem_translations SET constraints =
'- `1 <= number of nodes <= 1000`
- `0 <= Node.val <= 9`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'root-sum') AND locale = 'en';

------------------------------------------------------------
-- #128 flatten-tree
UPDATE problems SET constraints =
'- The number of nodes in the tree is in the range `[0, 2000]`
- `-100 <= Node.val <= 100`'
WHERE slug = 'flatten-tree';

UPDATE problem_translations SET constraints =
'- The number of nodes in the tree is in the range `[0, 2000]`
- `-100 <= Node.val <= 100`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flatten-tree') AND locale = 'en';

------------------------------------------------------------
-- #129 tree-ancestor
UPDATE problems SET constraints =
'- The number of nodes in the tree is in the range `[2, 10000]`
- `-10^9 <= Node.val <= 10^9`
- All `Node.val` are unique
- `p != q`
- Both `p` and `q` exist in the tree'
WHERE slug = 'tree-ancestor';

UPDATE problem_translations SET constraints =
'- The number of nodes in the tree is in the range `[2, 10000]`
- `-10^9 <= Node.val <= 10^9`
- All `Node.val` are unique
- `p != q`
- Both `p` and `q` exist in the tree'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-ancestor') AND locale = 'en';

------------------------------------------------------------
-- #130 job-scheduler
UPDATE problems SET constraints =
'- `1 <= jobs.length <= 10^4`
- `jobs[i]` is an uppercase English letter
- `0 <= n <= 100`'
WHERE slug = 'job-scheduler';

UPDATE problem_translations SET constraints =
'- `1 <= jobs.length <= 10^4`
- `jobs[i]` is an uppercase English letter
- `0 <= n <= 100`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'job-scheduler') AND locale = 'en';

------------------------------------------------------------
-- #131 feed-designer
UPDATE problems SET constraints =
'- `1 <= userId, followerId, followeeId <= 500`
- `0 <= messageId <= 10^4`
- At most `3 * 10^4` calls total across all methods'
WHERE slug = 'feed-designer';

UPDATE problem_translations SET constraints =
'- `1 <= userId, followerId, followeeId <= 500`
- `0 <= messageId <= 10^4`
- At most `3 * 10^4` calls total across all methods'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'feed-designer') AND locale = 'en';

------------------------------------------------------------
-- #132 running-median
UPDATE problems SET constraints =
'- `-10^5 <= num <= 10^5`
- At most `5 * 10^4` calls will be made to addNum and findMedian
- findMedian is always called after at least one addNum call'
WHERE slug = 'running-median';

UPDATE problem_translations SET constraints =
'- `-10^5 <= num <= 10^5`
- At most `5 * 10^4` calls will be made to addNum and findMedian
- findMedian is always called after at least one addNum call'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'running-median') AND locale = 'en';

------------------------------------------------------------
-- #133 rearrange-letters
UPDATE problems SET constraints =
'- `1 <= s.length <= 500`
- s consists of lowercase English letters only'
WHERE slug = 'rearrange-letters';

UPDATE problem_translations SET constraints =
'- `1 <= s.length <= 500`
- s consists of lowercase English letters only'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rearrange-letters') AND locale = 'en';

------------------------------------------------------------
-- #134 frequent-words
UPDATE problems SET constraints =
'- `1 <= words.length <= 500`
- `1 <= words[i].length <= 10`
- `words[i]` consists of lowercase English letters
- `k` is in the range `[1, number of unique words]`
- The answer is guaranteed to be unique'
WHERE slug = 'frequent-words';

UPDATE problem_translations SET constraints =
'- `1 <= words.length <= 500`
- `1 <= words[i].length <= 10`
- `words[i]` consists of lowercase English letters
- `k` is in the range `[1, number of unique words]`
- The answer is guaranteed to be unique'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'frequent-words') AND locale = 'en';

------------------------------------------------------------
-- #135 unique-subsets
UPDATE problems SET constraints =
'- `1 <= nums.length <= 10`
- `-10 <= nums[i] <= 10`'
WHERE slug = 'unique-subsets';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 10`
- `-10 <= nums[i] <= 10`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-subsets') AND locale = 'en';

------------------------------------------------------------
-- #136 unique-combinations
UPDATE problems SET constraints =
'- `1 <= candidates.length <= 100`
- `1 <= candidates[i] <= 50`
- `1 <= target <= 30`'
WHERE slug = 'unique-combinations';

UPDATE problem_translations SET constraints =
'- `1 <= candidates.length <= 100`
- `1 <= candidates[i] <= 50`
- `1 <= target <= 30`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-combinations') AND locale = 'en';

------------------------------------------------------------
-- #137 palindrome-split
UPDATE problems SET constraints =
'- `1 <= s.length <= 16`
- s contains only lowercase English letters'
WHERE slug = 'palindrome-split';

UPDATE problem_translations SET constraints =
'- `1 <= s.length <= 16`
- s contains only lowercase English letters'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'palindrome-split') AND locale = 'en';

------------------------------------------------------------
-- #138 ip-builder
UPDATE problems SET constraints =
'- `1 <= s.length <= 20`
- s consists of digits only'
WHERE slug = 'ip-builder';

UPDATE problem_translations SET constraints =
'- `1 <= s.length <= 20`
- s consists of digits only'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ip-builder') AND locale = 'en';

------------------------------------------------------------
-- #139 valid-tree
UPDATE problems SET constraints =
'- `1 <= n <= 2000`
- `0 <= edges.length <= 5000`
- `edges[i].length == 2`
- `0 <= edges[i][0], edges[i][1] < n`
- There are no self-loops or duplicate edges'
WHERE slug = 'valid-tree';

UPDATE problem_translations SET constraints =
'- `1 <= n <= 2000`
- `0 <= edges.length <= 5000`
- `edges[i].length == 2`
- `0 <= edges[i][0], edges[i][1] < n`
- There are no self-loops or duplicate edges'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'valid-tree') AND locale = 'en';

------------------------------------------------------------
-- #140 gate-distance
UPDATE problems SET constraints =
'- `1 <= m, n <= 250`
- `grid[i][j]` is `-1`, `0`, or `2147483647`'
WHERE slug = 'gate-distance';

UPDATE problem_translations SET constraints =
'- `1 <= m, n <= 250`
- `grid[i][j]` is `-1`, `0`, or `2147483647`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'gate-distance') AND locale = 'en';

------------------------------------------------------------
-- #141 border-capture
UPDATE problems SET constraints =
'- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 200`
- `board[i][j]` is ''X'' or ''O'''
WHERE slug = 'border-capture';

UPDATE problem_translations SET constraints =
'- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 200`
- `board[i][j]` is ''X'' or ''O'''
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'border-capture') AND locale = 'en';

------------------------------------------------------------
-- #142 word-chain
UPDATE problems SET constraints =
'- `1 <= beginWord.length <= 10`
- `endWord.length == beginWord.length`
- `1 <= wordList.length <= 5000`
- `wordList[i].length == beginWord.length`
- `beginWord`, `endWord`, and `wordList[i]` consist of lowercase English letters
- `beginWord != endWord`'
WHERE slug = 'word-chain';

UPDATE problem_translations SET constraints =
'- `1 <= beginWord.length <= 10`
- `endWord.length == beginWord.length`
- `1 <= wordList.length <= 5000`
- `wordList[i].length == beginWord.length`
- `beginWord`, `endWord`, and `wordList[i]` consist of lowercase English letters
- `beginWord != endWord`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-chain') AND locale = 'en';

------------------------------------------------------------
-- #143 shortest-grid-path
UPDATE problems SET constraints =
'- `n == grid.length`
- `n == grid[i].length`
- `1 <= n <= 100`
- `grid[i][j]` is `0` or `1`'
WHERE slug = 'shortest-grid-path';

UPDATE problem_translations SET constraints =
'- `n == grid.length`
- `n == grid[i].length`
- `1 <= n <= 100`
- `grid[i][j]` is `0` or `1`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shortest-grid-path') AND locale = 'en';

------------------------------------------------------------
-- #144 room-explorer
UPDATE problems SET constraints =
'- `1 <= n <= 1000`
- `0 <= rooms[i].length <= n`
- `0 <= rooms[i][j] < n`
- All values in `rooms[i]` are unique'
WHERE slug = 'room-explorer';

UPDATE problem_translations SET constraints =
'- `1 <= n <= 1000`
- `0 <= rooms[i].length <= n`
- `0 <= rooms[i][j] < n`
- All values in `rooms[i]` are unique'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'room-explorer') AND locale = 'en';

------------------------------------------------------------
-- #145 two-colorable
UPDATE problems SET constraints =
'- `1 <= graph.length <= 100`
- `0 <= graph[i].length < graph.length`
- `graph[i]` does not contain `i` (no self-loops)
- If `graph[i]` contains `j`, then `graph[j]` contains `i` (undirected)
- The graph may not be connected'
WHERE slug = 'two-colorable';

UPDATE problem_translations SET constraints =
'- `1 <= graph.length <= 100`
- `0 <= graph[i].length < graph.length`
- `graph[i]` does not contain `i` (no self-loops)
- If `graph[i]` contains `j`, then `graph[j]` contains `i` (undirected)
- The graph may not be connected'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'two-colorable') AND locale = 'en';

------------------------------------------------------------
-- #146 equation-solver
UPDATE problems SET constraints =
'- `1 <= equations.length <= 20`
- `equations[i].length == 2`
- `1 <= equations[i][0].length, equations[i][1].length <= 5`
- `values.length == equations.length`
- `0.0 < values[i] <= 20.0`
- `1 <= queries.length <= 20`
- `queries[i].length == 2`
- `1 <= queries[i][0].length, queries[i][1].length <= 5`
- Variables consist of lowercase English letters and digits'
WHERE slug = 'equation-solver';

UPDATE problem_translations SET constraints =
'- `1 <= equations.length <= 20`
- `equations[i].length == 2`
- `1 <= equations[i][0].length, equations[i][1].length <= 5`
- `values.length == equations.length`
- `0.0 < values[i] <= 20.0`
- `1 <= queries.length <= 20`
- `queries[i].length == 2`
- `1 <= queries[i][0].length, queries[i][1].length <= 5`
- Variables consist of lowercase English letters and digits'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'equation-solver') AND locale = 'en';

------------------------------------------------------------
-- #147 point-connector
UPDATE problems SET constraints =
'- `1 <= points.length <= 1000`
- `-10^6 <= xi, yi <= 10^6`
- All points are distinct'
WHERE slug = 'point-connector';

UPDATE problem_translations SET constraints =
'- `1 <= points.length <= 1000`
- `-10^6 <= xi, yi <= 10^6`
- All points are distinct'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'point-connector') AND locale = 'en';

------------------------------------------------------------
-- #148 signal-time
UPDATE problems SET constraints =
'- `1 <= n <= 100`
- `1 <= edges.length <= 6000`
- `edges[i].length == 3`
- `1 <= source_i, dest_i <= n`
- `source_i != dest_i`
- `1 <= weight_i <= 100`
- All `(source_i, dest_i)` pairs are unique'
WHERE slug = 'signal-time';

UPDATE problem_translations SET constraints =
'- `1 <= n <= 100`
- `1 <= edges.length <= 6000`
- `edges[i].length == 3`
- `1 <= source_i, dest_i <= n`
- `source_i != dest_i`
- `1 <= weight_i <= 100`
- All `(source_i, dest_i)` pairs are unique'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'signal-time') AND locale = 'en';

------------------------------------------------------------
-- #149 budget-flights
UPDATE problems SET constraints =
'- `1 <= n <= 100`
- `0 <= flights.length <= n * (n - 1) / 2`
- `flights[i].length == 3`
- `0 <= from, to < n`
- `from != to`
- `1 <= price <= 10000`
- `0 <= src, dst, k < n`
- `src != dst`'
WHERE slug = 'budget-flights';

UPDATE problem_translations SET constraints =
'- `1 <= n <= 100`
- `0 <= flights.length <= n * (n - 1) / 2`
- `flights[i].length == 3`
- `0 <= from, to < n`
- `from != to`
- `1 <= price <= 10000`
- `0 <= src, dst, k < n`
- `src != dst`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'budget-flights') AND locale = 'en';

------------------------------------------------------------
-- #150 rising-tide
UPDATE problems SET constraints =
'- `n == elevation.length == elevation[i].length`
- `1 <= n <= 50`
- `0 <= elevation[i][j] < n * n`
- All values in elevation are unique'
WHERE slug = 'rising-tide';

UPDATE problem_translations SET constraints =
'- `n == elevation.length == elevation[i].length`
- `1 <= n <= 50`
- `0 <= elevation[i][j] < n * n`
- All values in elevation are unique'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rising-tide') AND locale = 'en';

------------------------------------------------------------
-- #151 symbol-order
UPDATE problems SET constraints =
'- The input list contains at least 1 word
- All words consist of lowercase English letters only
- There may be characters that have no ordering constraints relative to each other; in such cases, the test inputs are designed so that only one valid ordering exists'
WHERE slug = 'symbol-order';

UPDATE problem_translations SET constraints =
'- The input list contains at least 1 word
- All words consist of lowercase English letters only
- There may be characters that have no ordering constraints relative to each other; in such cases, the test inputs are designed so that only one valid ordering exists'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'symbol-order') AND locale = 'en';

------------------------------------------------------------
-- #152 extra-edge
UPDATE problems SET constraints =
'- `n == edges.length`
- `3 <= n <= 1000`
- `edges[i].length == 2`
- `1 <= edges[i][0], edges[i][1] <= n`
- `edges[i][0] != edges[i][1]`
- No duplicate edges exist
- The graph is connected and contains exactly one cycle'
WHERE slug = 'extra-edge';

UPDATE problem_translations SET constraints =
'- `n == edges.length`
- `3 <= n <= 1000`
- `edges[i].length == 2`
- `1 <= edges[i][0], edges[i][1] <= n`
- `edges[i][0] != edges[i][1]`
- No duplicate edges exist
- The graph is connected and contains exactly one cycle'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'extra-edge') AND locale = 'en';

------------------------------------------------------------
-- #153 airport-route
UPDATE problems SET constraints =
'- `1 <= tickets.length <= 300`
- `tickets[i].length == 2`
- `departure_i` and `arrival_i` consist of 3 uppercase English letters
- `departure_i != arrival_i`
- All tickets form at least one valid itinerary
- The itinerary always starts from "JFK"'
WHERE slug = 'airport-route';

UPDATE problem_translations SET constraints =
'- `1 <= tickets.length <= 300`
- `tickets[i].length == 2`
- `departure_i` and `arrival_i` consist of 3 uppercase English letters
- `departure_i != arrival_i`
- All tickets form at least one valid itinerary
- The itinerary always starts from "JFK"'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'airport-route') AND locale = 'en';

------------------------------------------------------------
-- #154 longest-palindrome
UPDATE problems SET constraints =
'- `1 <= s.length <= 1000`
- s consists of only lowercase English letters'
WHERE slug = 'longest-palindrome';

UPDATE problem_translations SET constraints =
'- `1 <= s.length <= 1000`
- s consists of only lowercase English letters'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-palindrome') AND locale = 'en';

------------------------------------------------------------
-- #155 cheap-stairs
UPDATE problems SET constraints =
'- `2 <= cost.length <= 1000`
- `0 <= cost[i] <= 999`'
WHERE slug = 'cheap-stairs';

UPDATE problem_translations SET constraints =
'- `2 <= cost.length <= 1000`
- `0 <= cost[i] <= 999`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cheap-stairs') AND locale = 'en';

------------------------------------------------------------
-- #156 equal-partition
UPDATE problems SET constraints =
'- `1 <= nums.length <= 200`
- `1 <= nums[i] <= 100`'
WHERE slug = 'equal-partition';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 200`
- `1 <= nums[i] <= 100`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'equal-partition') AND locale = 'en';

------------------------------------------------------------
-- #157 perfect-sum
UPDATE problems SET constraints =
'- `1 <= n <= 10000`'
WHERE slug = 'perfect-sum';

UPDATE problem_translations SET constraints =
'- `1 <= n <= 10000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'perfect-sum') AND locale = 'en';

------------------------------------------------------------
-- #158 nth-ugly
UPDATE problems SET constraints =
'- `1 <= n <= 1690`'
WHERE slug = 'nth-ugly';

UPDATE problem_translations SET constraints =
'- `1 <= n <= 1690`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'nth-ugly') AND locale = 'en';

------------------------------------------------------------
-- #159 room-builder
UPDATE problems SET constraints =
'- `1 <= n <= 10^5`
- `prevRoom.length == n`
- `prevRoom[0] == -1`
- `0 <= prevRoom[i] < n` for `i >= 1`
- The input guarantees the rooms form a valid tree'
WHERE slug = 'room-builder';

UPDATE problem_translations SET constraints =
'- `1 <= n <= 10^5`
- `prevRoom.length == n`
- `prevRoom[0] == -1`
- `0 <= prevRoom[i] < n` for `i >= 1`
- The input guarantees the rooms form a valid tree'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'room-builder') AND locale = 'en';

------------------------------------------------------------
-- #160 break-integer
UPDATE problems SET constraints =
'- `2 <= n <= 58`'
WHERE slug = 'break-integer';

UPDATE problem_translations SET constraints =
'- `2 <= n <= 58`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'break-integer') AND locale = 'en';

------------------------------------------------------------
-- #161 longest-chain-count
UPDATE problems SET constraints =
'- `1 <= nums.length <= 2000`
- `-10^6 <= nums[i] <= 10^6`'
WHERE slug = 'longest-chain-count';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 2000`
- `-10^6 <= nums[i] <= 10^6`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-chain-count') AND locale = 'en';

------------------------------------------------------------
-- #162 stock-cooldown
UPDATE problems SET constraints =
'- `1 <= prices.length <= 5000`
- `0 <= prices[i] <= 1000`'
WHERE slug = 'stock-cooldown';

UPDATE problem_translations SET constraints =
'- `1 <= prices.length <= 5000`
- `0 <= prices[i] <= 1000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'stock-cooldown') AND locale = 'en';

------------------------------------------------------------
-- #163 sign-assignments
UPDATE problems SET constraints =
'- `1 <= nums.length <= 20`
- `0 <= nums[i] <= 1000`
- `-1000 <= target <= 1000`'
WHERE slug = 'sign-assignments';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 20`
- `0 <= nums[i] <= 1000`
- `-1000 <= target <= 1000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sign-assignments') AND locale = 'en';

------------------------------------------------------------
-- #164 string-weave
UPDATE problems SET constraints =
'- `0 <= s1.length, s2.length <= 100`
- `0 <= s3.length <= 200`
- s1, s2, and s3 consist of lowercase English letters'
WHERE slug = 'string-weave';

UPDATE problem_translations SET constraints =
'- `0 <= s1.length, s2.length <= 100`
- `0 <= s3.length <= 200`
- s1, s2, and s3 consist of lowercase English letters'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'string-weave') AND locale = 'en';

------------------------------------------------------------
-- #165 subsequence-count
UPDATE problems SET constraints =
'- `1 <= s.length, t.length <= 1000`
- s and t consist of lowercase English letters'
WHERE slug = 'subsequence-count';

UPDATE problem_translations SET constraints =
'- `1 <= s.length, t.length <= 1000`
- s and t consist of lowercase English letters'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'subsequence-count') AND locale = 'en';

------------------------------------------------------------
-- #166 pattern-matcher
UPDATE problems SET constraints =
'- `1 <= s.length <= 20`
- `1 <= p.length <= 20`
- s contains only lowercase English letters
- p contains only lowercase English letters, ''.'', and ''*''
- Each ''*'' has a valid preceding character (it is guaranteed that ''*'' does not appear as the first character or immediately after another ''*'')'
WHERE slug = 'pattern-matcher';

UPDATE problem_translations SET constraints =
'- `1 <= s.length <= 20`
- `1 <= p.length <= 20`
- s contains only lowercase English letters
- p contains only lowercase English letters, ''.'', and ''*''
- Each ''*'' has a valid preceding character (it is guaranteed that ''*'' does not appear as the first character or immediately after another ''*'')'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pattern-matcher') AND locale = 'en';

------------------------------------------------------------
-- #167 balloon-popper
UPDATE problems SET constraints =
'- `1 <= nums.length <= 300`
- `0 <= nums[i] <= 100`'
WHERE slug = 'balloon-popper';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 300`
- `0 <= nums[i] <= 100`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'balloon-popper') AND locale = 'en';

------------------------------------------------------------
-- #168 largest-square
UPDATE problems SET constraints =
'- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= m, n <= 300`
- `matrix[i][j]` is ''0'' or ''1'''
WHERE slug = 'largest-square';

UPDATE problem_translations SET constraints =
'- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= m, n <= 300`
- `matrix[i][j]` is ''0'' or ''1'''
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'largest-square') AND locale = 'en';

------------------------------------------------------------
-- #169 change-maker
UPDATE problems SET constraints =
'- `1 <= coins.length <= 300`
- `1 <= coins[i] <= 5000`
- All values in coins are unique
- `0 <= amount <= 5000`'
WHERE slug = 'change-maker';

UPDATE problem_translations SET constraints =
'- `1 <= coins.length <= 300`
- `1 <= coins[i] <= 5000`
- All values in coins are unique
- `0 <= amount <= 5000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'change-maker') AND locale = 'en';

------------------------------------------------------------
-- #170 cheapest-path
UPDATE problems SET constraints =
'- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 200`
- `0 <= grid[i][j] <= 200`'
WHERE slug = 'cheapest-path';

UPDATE problem_translations SET constraints =
'- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 200`
- `0 <= grid[i][j] <= 200`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cheapest-path') AND locale = 'en';

------------------------------------------------------------
-- #171 longest-climb
UPDATE problems SET constraints =
'- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= m, n <= 200`
- `0 <= matrix[i][j] <= 2^31 - 1`'
WHERE slug = 'longest-climb';

UPDATE problem_translations SET constraints =
'- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= m, n <= 200`
- `0 <= matrix[i][j] <= 2^31 - 1`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-climb') AND locale = 'en';

------------------------------------------------------------
-- #172 hand-grouping
UPDATE problems SET constraints =
'- `1 <= hand.length <= 10^4`
- `0 <= hand[i] <= 10^9`
- `1 <= groupSize <= hand.length`'
WHERE slug = 'hand-grouping';

UPDATE problem_translations SET constraints =
'- `1 <= hand.length <= 10^4`
- `0 <= hand[i] <= 10^9`
- `1 <= groupSize <= hand.length`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'hand-grouping') AND locale = 'en';

------------------------------------------------------------
-- #173 label-splitter
UPDATE problems SET constraints =
'- `1 <= s.length <= 500`
- s consists of lowercase English letters'
WHERE slug = 'label-splitter';

UPDATE problem_translations SET constraints =
'- `1 <= s.length <= 500`
- s consists of lowercase English letters'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'label-splitter') AND locale = 'en';

------------------------------------------------------------
-- #174 flexible-brackets
UPDATE problems SET constraints =
'- `1 <= s.length <= 100`
- `s[i]` is ''('', '')'', or ''*'''
WHERE slug = 'flexible-brackets';

UPDATE problem_translations SET constraints =
'- `1 <= s.length <= 100`
- `s[i]` is ''('', '')'', or ''*'''
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flexible-brackets') AND locale = 'en';

------------------------------------------------------------
-- #175 triplet-former
UPDATE problems SET constraints =
'- `1 <= triplets.length <= 10^5`
- `triplets[i].length == 3`
- `1 <= triplets[i][j], target[j] <= 1000`'
WHERE slug = 'triplet-former';

UPDATE problem_translations SET constraints =
'- `1 <= triplets.length <= 10^5`
- `triplets[i].length == 3`
- `1 <= triplets[i][j], target[j] <= 1000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'triplet-former') AND locale = 'en';

------------------------------------------------------------
-- #176 height-queue
UPDATE problems SET constraints =
'- `1 <= people.length <= 2000`
- `0 <= h <= 10^6`
- `0 <= k < people.length`
- A valid queue arrangement is guaranteed to exist'
WHERE slug = 'height-queue';

UPDATE problem_translations SET constraints =
'- `1 <= people.length <= 2000`
- `0 <= h <= 10^6`
- `0 <= k < people.length`
- A valid queue arrangement is guaranteed to exist'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'height-queue') AND locale = 'en';

------------------------------------------------------------
-- #177 almost-sorted
UPDATE problems SET constraints =
'- `1 <= nums.length <= 10^4`
- `-10^5 <= nums[i] <= 10^5`'
WHERE slug = 'almost-sorted';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 10^4`
- `-10^5 <= nums[i] <= 10^5`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'almost-sorted') AND locale = 'en';

------------------------------------------------------------
-- #178 room-checker
UPDATE problems SET constraints =
'- `0 <= intervals.length <= 10^4`
- `intervals[i].length == 2`
- `0 <= start < end <= 10^6`'
WHERE slug = 'room-checker';

UPDATE problem_translations SET constraints =
'- `0 <= intervals.length <= 10^4`
- `intervals[i].length == 2`
- `0 <= start < end <= 10^6`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'room-checker') AND locale = 'en';

------------------------------------------------------------
-- #179 query-intervals
UPDATE problems SET constraints =
'- `1 <= intervals.length <= 10^5`
- `1 <= queries.length <= 10^5`
- `1 <= start <= end <= 10^7`'
WHERE slug = 'query-intervals';

UPDATE problem_translations SET constraints =
'- `1 <= intervals.length <= 10^5`
- `1 <= queries.length <= 10^5`
- `1 <= start <= end <= 10^7`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'query-intervals') AND locale = 'en';

------------------------------------------------------------
-- #180 arrow-shooter
UPDATE problems SET constraints =
'- `1 <= targets.length <= 10^5`
- `targets[i].length == 2`
- `-2^31 <= start <= end <= 2^31 - 1`'
WHERE slug = 'arrow-shooter';

UPDATE problem_translations SET constraints =
'- `1 <= targets.length <= 10^5`
- `targets[i].length == 2`
- `-2^31 <= start <= end <= 2^31 - 1`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'arrow-shooter') AND locale = 'en';

------------------------------------------------------------
-- #181 zero-matrix
UPDATE problems SET constraints =
'- `m == matrix.length`
- `n == matrix[0].length`
- `1 <= m, n <= 200`
- `-2^31 <= matrix[i][j] <= 2^31 - 1`'
WHERE slug = 'zero-matrix';

UPDATE problem_translations SET constraints =
'- `m == matrix.length`
- `n == matrix[0].length`
- `1 <= m, n <= 200`
- `-2^31 <= matrix[i][j] <= 2^31 - 1`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'zero-matrix') AND locale = 'en';

------------------------------------------------------------
-- #182 power-function
UPDATE problems SET constraints =
'- `-100.0 < x < 100.0`
- `-2^31 <= n <= 2^31 - 1`
- `n` is an integer
- Either `x` is not zero or `n > 0`
- `-10^4 <= x^n <= 10^4`'
WHERE slug = 'power-function';

UPDATE problem_translations SET constraints =
'- `-100.0 < x < 100.0`
- `-2^31 <= n <= 2^31 - 1`
- `n` is an integer
- Either `x` is not zero or `n > 0`
- `-10^4 <= x^n <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'power-function') AND locale = 'en';

------------------------------------------------------------
-- #183 string-multiply
UPDATE problems SET constraints =
'- `1 <= num1.length, num2.length <= 200`
- num1 and num2 consist of digits only
- Neither num1 nor num2 has leading zeros, except the number 0 itself'
WHERE slug = 'string-multiply';

UPDATE problem_translations SET constraints =
'- `1 <= num1.length, num2.length <= 200`
- num1 and num2 consist of digits only
- Neither num1 nor num2 has leading zeros, except the number 0 itself'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'string-multiply') AND locale = 'en';

------------------------------------------------------------
-- #184 joyful-number
UPDATE problems SET constraints =
'- `1 <= n <= 2^31 - 1`'
WHERE slug = 'joyful-number';

UPDATE problem_translations SET constraints =
'- `1 <= n <= 2^31 - 1`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'joyful-number') AND locale = 'en';

------------------------------------------------------------
-- #185 increment-digits
UPDATE problems SET constraints =
'- `1 <= digits.length <= 100`
- `0 <= digits[i] <= 9`
- The input array does not have leading zeros except for the number 0 itself'
WHERE slug = 'increment-digits';

UPDATE problem_translations SET constraints =
'- `1 <= digits.length <= 100`
- `0 <= digits[i] <= 9`
- The input array does not have leading zeros except for the number 0 itself'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'increment-digits') AND locale = 'en';

------------------------------------------------------------
-- #186 fizz-buzz-game
UPDATE problems SET constraints =
'- `1 <= n <= 10^4`'
WHERE slug = 'fizz-buzz-game';

UPDATE problem_translations SET constraints =
'- `1 <= n <= 10^4`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fizz-buzz-game') AND locale = 'en';

------------------------------------------------------------
-- #187 mirror-number
UPDATE problems SET constraints =
'- `-2^31 <= x <= 2^31 - 1`'
WHERE slug = 'mirror-number';

UPDATE problem_translations SET constraints =
'- `-2^31 <= x <= 2^31 - 1`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'mirror-number') AND locale = 'en';

------------------------------------------------------------
-- #188 numeral-converter
UPDATE problems SET constraints =
'- `1 <= s.length <= 15`
- s contains only the characters I, V, X, L, C, D, M
- The input is guaranteed to be a valid Roman numeral in the range `[1, 3999]`'
WHERE slug = 'numeral-converter';

UPDATE problem_translations SET constraints =
'- `1 <= s.length <= 15`
- s contains only the characters I, V, X, L, C, D, M
- The input is guaranteed to be a valid Roman numeral in the range `[1, 3999]`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'numeral-converter') AND locale = 'en';

------------------------------------------------------------
-- #189 bit-tracker
UPDATE problems SET constraints =
'- `0 <= n <= 10^5`'
WHERE slug = 'bit-tracker';

UPDATE problem_translations SET constraints =
'- `0 <= n <= 10^5`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bit-tracker') AND locale = 'en';

------------------------------------------------------------
-- #190 flip-bits
UPDATE problems SET constraints =
'- The input is a 32-bit unsigned integer (`0 <= n <= 2^32 - 1`)'
WHERE slug = 'flip-bits';

UPDATE problem_translations SET constraints =
'- The input is a 32-bit unsigned integer (`0 <= n <= 2^32 - 1`)'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flip-bits') AND locale = 'en';

------------------------------------------------------------
-- #191 absent-number
UPDATE problems SET constraints =
'- `1 <= nums.length <= 10000`
- `0 <= nums[i] <= n`
- All values in nums are unique'
WHERE slug = 'absent-number';

UPDATE problem_translations SET constraints =
'- `1 <= nums.length <= 10000`
- `0 <= nums[i] <= n`
- All values in nums are unique'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'absent-number') AND locale = 'en';

------------------------------------------------------------
-- #192 bitwise-sum
UPDATE problems SET constraints =
'- `-1000 <= a, b <= 1000`'
WHERE slug = 'bitwise-sum';

UPDATE problem_translations SET constraints =
'- `-1000 <= a, b <= 1000`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bitwise-sum') AND locale = 'en';

------------------------------------------------------------
-- #193 power-check
UPDATE problems SET constraints =
'- `-2^31 <= n <= 2^31 - 1`'
WHERE slug = 'power-check';

UPDATE problem_translations SET constraints =
'- `-2^31 <= n <= 2^31 - 1`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'power-check') AND locale = 'en';

------------------------------------------------------------
-- #194 bit-distance
UPDATE problems SET constraints =
'- `0 <= x, y <= 2^31 - 1`'
WHERE slug = 'bit-distance';

UPDATE problem_translations SET constraints =
'- `0 <= x, y <= 2^31 - 1`'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bit-distance') AND locale = 'en';

------------------------------------------------------------
-- #195 stack-queue
UPDATE problems SET constraints =
'- `1 <= x <= 9`
- At most 100 calls will be made to push, pop, peek, and empty
- All calls to pop and peek are valid (the queue will not be empty when these are called)'
WHERE slug = 'stack-queue';

UPDATE problem_translations SET constraints =
'- `1 <= x <= 9`
- At most 100 calls will be made to push, pop, peek, and empty
- All calls to pop and peek are valid (the queue will not be empty when these are called)'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'stack-queue') AND locale = 'en';

------------------------------------------------------------
-- #196 ring-buffer
UPDATE problems SET constraints =
'- `1 <= k <= 1000`
- `0 <= value <= 1000`
- At most 3000 calls will be made to enQueue, deQueue, front, rear, isEmpty, and isFull'
WHERE slug = 'ring-buffer';

UPDATE problem_translations SET constraints =
'- `1 <= k <= 1000`
- `0 <= value <= 1000`
- At most 3000 calls will be made to enQueue, deQueue, front, rear, isEmpty, and isFull'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ring-buffer') AND locale = 'en';

------------------------------------------------------------
-- #197 hash-table
UPDATE problems SET constraints =
'- `0 <= key, value <= 10^6`
- At most `10^4` calls will be made to put, get, and remove'
WHERE slug = 'hash-table';

UPDATE problem_translations SET constraints =
'- `0 <= key, value <= 10^6`
- At most `10^4` calls will be made to put, get, and remove'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'hash-table') AND locale = 'en';

------------------------------------------------------------
-- #198 random-set
UPDATE problems SET constraints =
'- `-2^31 <= val <= 2^31 - 1`
- At most `2 * 10^5` calls will be made to insert, remove, and getRandom
- There will be at least one element in the set when getRandom is called'
WHERE slug = 'random-set';

UPDATE problem_translations SET constraints =
'- `-2^31 <= val <= 2^31 - 1`
- At most `2 * 10^5` calls will be made to insert, remove, and getRandom
- There will be at least one element in the set when getRandom is called'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'random-set') AND locale = 'en';

------------------------------------------------------------
-- #199 state-snapshots
UPDATE problems SET constraints =
'- `1 <= length <= 50000`
- `0 <= index < length`
- `0 <= val <= 10^9`
- `0 <= snapId < (number of times snap() is called)`
- At most 50000 total calls will be made to set, snap, and get'
WHERE slug = 'state-snapshots';

UPDATE problem_translations SET constraints =
'- `1 <= length <= 50000`
- `0 <= index < length`
- `0 <= val <= 10^9`
- `0 <= snapId < (number of times snap() is called)`
- At most 50000 total calls will be made to set, snap, and get'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'state-snapshots') AND locale = 'en';

------------------------------------------------------------
-- #200 click-counter
UPDATE problems SET constraints =
'- `1 <= timestamp <= 2 * 10^9`
- Each timestamp is greater than or equal to the previous one
- At most 300 calls will be made to hit and getHits'
WHERE slug = 'click-counter';

UPDATE problem_translations SET constraints =
'- `1 <= timestamp <= 2 * 10^9`
- Each timestamp is greater than or equal to the previous one
- At most 300 calls will be made to hit and getHits'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'click-counter') AND locale = 'en';
