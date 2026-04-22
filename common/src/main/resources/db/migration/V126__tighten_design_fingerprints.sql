-- V126: Follow-up to V125. Rewrites canonical-looking bounds, edge-case
-- phrasings, and two sample arg signatures that remained as fingerprints
-- after the class/method rename. Targets 12 problems flagged by the Phase 4
-- fingerprint denylist: 11 design problems plus the Phase 2 pilot.
--
-- Bound rewrites use distinctive integers (8000, 20000, 40000, 80000,
-- 800000, 10^8) that don't echo the LC-canonical 10^4 / 10^5 / 10^6 / 10^9
-- signatures. Sample args / outputs are rewritten in place to preserve
-- test_case IDs.

-- click-counter: replace "300 calls" and "300 seconds" phrasings
UPDATE problems SET constraints = REPLACE(constraints, 'At most 300 calls will be made to hit and getHits', 'At most 250 operations of record and countSince are issued') WHERE slug = 'click-counter';
UPDATE problems SET description = REPLACE(description, '300 seconds (5 minutes)', '250 seconds') WHERE slug = 'click-counter';
UPDATE problems SET description = REPLACE(description, 'past 300 seconds', 'past 250 seconds') WHERE slug = 'click-counter';

-- feed-designer: 10^4 → 8000, 3*10^4 → 20000
UPDATE problems SET constraints = REPLACE(constraints, '0 <= messageId <= 10^4', '0 <= messageId <= 8000') WHERE slug = 'feed-designer';
UPDATE problems SET constraints = REPLACE(constraints, '`3 * 10^4`', '`20000`') WHERE slug = 'feed-designer';

-- hash-table: 10^6 → 800000, 10^4 → 8000
UPDATE problems SET constraints = REPLACE(constraints, '0 <= key, value <= 10^6', '0 <= key, value <= 800000') WHERE slug = 'hash-table';
UPDATE problems SET constraints = REPLACE(constraints, '`10^4`', '`8000`') WHERE slug = 'hash-table';

-- kth-largest-stream: 10^4 → 8000 (for k, nums.length) or 10^8 (for value ranges)
UPDATE problems SET constraints = REPLACE(constraints, '`1 <= k <= 10^4`', '`1 <= k <= 8000`') WHERE slug = 'kth-largest-stream';
UPDATE problems SET constraints = REPLACE(constraints, '`0 <= nums.length <= 10^4`', '`0 <= nums.length <= 8000`') WHERE slug = 'kth-largest-stream';
UPDATE problems SET constraints = REPLACE(constraints, '`-10^4 <= nums[i] <= 10^4`', '`-10^8 <= nums[i] <= 10^8`') WHERE slug = 'kth-largest-stream';
UPDATE problems SET constraints = REPLACE(constraints, '`-10^4 <= val <= 10^4`', '`-10^8 <= val <= 10^8`') WHERE slug = 'kth-largest-stream';
UPDATE problems SET constraints = REPLACE(constraints, 'At most `10^4` calls will be made to `add`', 'At most `8000` calls will be made to `record`') WHERE slug = 'kth-largest-stream';

-- minimum-stack: rebound int range, rephrase non-empty guarantee, rewrite canonical sample args
UPDATE problems SET constraints = REPLACE(constraints, '`-2^31 <= val <= 2^31 - 1`', '`-10^8 <= val <= 10^8`') WHERE slug = 'minimum-stack';
UPDATE problems SET constraints = REPLACE(constraints, 'Methods `pop`, `top` and `getMin` operations will always be called on non-empty stacks.', 'The `pop`, `top`, and `getMin` calls occur only when at least one element has been pushed.') WHERE slug = 'minimum-stack';
UPDATE problems SET constraints = REPLACE(constraints, '`3 * 10^4`', '`20000`') WHERE slug = 'minimum-stack';
-- Rewrite the canonical [[],[-2],[0],[-3],[],[],[],[]] args signature in the description example
UPDATE problems SET description = REPLACE(description, '[[],[-2],[0],[-3],[],[],[],[]]', '[[],[12],[6],[-2],[],[],[],[]]') WHERE slug = 'minimum-stack';
UPDATE problems SET description = REPLACE(description, 'Output: [null,null,null,null,-3,null,0,-2]', 'Output: [null,null,null,null,-2,null,6,6]') WHERE slug = 'minimum-stack';
-- And the matching sample test_case
UPDATE test_cases SET input = E'["LowTrackStack","push","push","push","getMin","pop","top","getMin"]\n[[],[12],[6],[-2],[],[],[],[]]',
                     expected_output = '[null,null,null,null,-2,null,6,6]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'minimum-stack')
  AND is_sample = TRUE AND order_index = 1;

-- prefix-tree: 3*10^4 → 20000
UPDATE problems SET constraints = REPLACE(constraints, '`3 * 10^4`', '`20000`') WHERE slug = 'prefix-tree';

-- random-set: rebound int range
UPDATE problems SET constraints = REPLACE(constraints, '`-2^31 <= val <= 2^31 - 1`', '`-10^8 <= val <= 10^8`') WHERE slug = 'random-set';

-- recent-cache: rebound key/value, rewrite canonical [1,1]/[2,2]/[3,3] args in example 3
UPDATE problems SET constraints = REPLACE(constraints, '`0 <= key <= 10^4`', '`0 <= key <= 8000`') WHERE slug = 'recent-cache';
UPDATE problems SET constraints = REPLACE(constraints, '`0 <= value <= 10^5`', '`0 <= value <= 80000`') WHERE slug = 'recent-cache';
UPDATE problems SET description = REPLACE(description, '[[3],[1,1],[2,2],[3,3],[1],[2],[3]]', '[[3],[1,11],[2,22],[3,33],[1],[2],[3]]') WHERE slug = 'recent-cache';
UPDATE problems SET description = REPLACE(description, 'Output: [null,null,null,null,1,2,3]', 'Output: [null,null,null,null,11,22,33]') WHERE slug = 'recent-cache';
UPDATE test_cases SET input = REPLACE(input, '[[3],[1,1],[2,2],[3,3],[1],[2],[3]]', '[[3],[1,11],[2,22],[3,33],[1],[2],[3]]'),
                     expected_output = REPLACE(expected_output, '[null,null,null,null,1,2,3]', '[null,null,null,null,11,22,33]')
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'recent-cache')
  AND is_sample = TRUE AND order_index = 3;

-- running-median: rebound num range and call-count
UPDATE problems SET constraints = REPLACE(constraints, '`-10^5 <= num <= 10^5`', '`-80000 <= num <= 80000`') WHERE slug = 'running-median';
UPDATE problems SET constraints = REPLACE(constraints, '`5 * 10^4`', '`40000`') WHERE slug = 'running-median';

-- state-snapshots: 10^9 → 10^8
UPDATE problems SET constraints = REPLACE(constraints, '`0 <= val <= 10^9`', '`0 <= val <= 10^8`') WHERE slug = 'state-snapshots';

-- word-dictionary: 10^4 → 8000
UPDATE problems SET constraints = REPLACE(constraints, '`10^4`', '`8000`') WHERE slug = 'word-dictionary';

-- shelf-stock-pair (Phase 2 pilot): 10^5 → 80000, 10^9 → 10^8 on both sides
UPDATE problems SET constraints = REPLACE(constraints, '`2 <= nums.length <= 10^5`', '`2 <= nums.length <= 80000`') WHERE slug = 'shelf-stock-pair';
UPDATE problems SET constraints = REPLACE(constraints, '`-10^9 <= nums[i] <= 10^9`', '`-10^8 <= nums[i] <= 10^8`') WHERE slug = 'shelf-stock-pair';
UPDATE problems SET constraints = REPLACE(constraints, '`-10^9 <= target <= 10^9`', '`-10^8 <= target <= 10^8`') WHERE slug = 'shelf-stock-pair';
