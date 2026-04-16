-- V54: Wire all Phase 3 problems — add 2 new roadmap categories, assign problems, add tags.

------------------------------------------------------------
-- 1. ADD 2 NEW ROADMAP CATEGORIES
------------------------------------------------------------

INSERT INTO roadmap_categories (name, slug, description, display_order) VALUES
    ('Advanced Graphs', 'advanced-graphs', 'Shortest paths, minimum spanning trees, and topological ordering', 18),
    ('Design', 'design', 'Implement data structures and system components from scratch', 19);

------------------------------------------------------------
-- 2. ADD PREREQUISITE EDGES FOR NEW CATEGORIES
------------------------------------------------------------

INSERT INTO roadmap_category_prerequisites (category_id, prerequisite_id)
SELECT c.id, p.id FROM roadmap_categories c, roadmap_categories p WHERE
    (c.slug = 'advanced-graphs' AND p.slug = 'graphs') OR
    (c.slug = 'design'          AND p.slug = 'arrays-and-hashing');

------------------------------------------------------------
-- 3. ASSIGN PHASE 3 PROBLEMS TO ROADMAP CATEGORIES
------------------------------------------------------------

INSERT INTO roadmap_category_problems (category_id, problem_id, order_index)
SELECT rc.id, p.id, sub.ord FROM (VALUES
    -- Arrays & Hashing (+5)
    ('arrays-and-hashing', 'popular-vote', 16),
    ('arrays-and-hashing', 'remove-sorted-dupes', 17),
    ('arrays-and-hashing', 'duplicate-finder', 18),
    ('arrays-and-hashing', 'target-subarray', 19),
    ('arrays-and-hashing', 'k-distinct-window', 20),
    -- Two Pointers (+3)
    ('two-pointers', 'quad-sum', 8),
    ('two-pointers', 'boat-loading', 9),
    ('two-pointers', 'sorted-squares', 10),
    -- Sliding Window (+2)
    ('sliding-window', 'shortest-cover', 6),
    ('sliding-window', 'fruit-picker', 7),
    -- Stack (+3)
    ('stacks', 'car-convoy', 6),
    ('stacks', 'tallest-bar', 7),
    ('stacks', 'space-rocks', 8),
    -- Binary Search (+4)
    ('binary-search', 'time-map', 7),
    ('binary-search', 'sorted-median', 8),
    ('binary-search', 'matrix-search-ii', 9),
    ('binary-search', 'ship-capacity', 10),
    -- Linked Lists (+3)
    ('linked-lists', 'recent-cache', 9),
    ('linked-lists', 'reverse-k-nodes', 10),
    ('linked-lists', 'swap-pairs', 11),
    -- Trees (+9)
    ('trees', 'tree-codec', 13),
    ('trees', 'good-node-count', 14),
    ('trees', 'height-check', 15),
    ('trees', 'zigzag-levels', 16),
    ('trees', 'target-path', 17),
    ('trees', 'right-pointers', 18),
    ('trees', 'root-sum', 19),
    ('trees', 'flatten-tree', 20),
    ('trees', 'tree-ancestor', 21),
    -- Heap / Priority Queue (+5)
    ('heaps', 'array-kth-largest', 4),
    ('heaps', 'job-scheduler', 5),
    ('heaps', 'feed-designer', 6),
    ('heaps', 'running-median', 7),
    ('heaps', 'rearrange-letters', 8),
    ('heaps', 'frequent-words', 9),
    -- Backtracking (+4)
    ('backtracking', 'unique-subsets', 7),
    ('backtracking', 'unique-combinations', 8),
    ('backtracking', 'palindrome-split', 9),
    ('backtracking', 'ip-builder', 10),
    -- Graphs (+8)
    ('graphs', 'valid-tree', 9),
    ('graphs', 'gate-distance', 10),
    ('graphs', 'border-capture', 11),
    ('graphs', 'word-chain', 12),
    ('graphs', 'shortest-grid-path', 13),
    ('graphs', 'room-explorer', 14),
    ('graphs', 'two-colorable', 15),
    ('graphs', 'equation-solver', 16),
    -- Advanced Graphs (+7) — NEW CATEGORY
    ('advanced-graphs', 'point-connector', 1),
    ('advanced-graphs', 'signal-time', 2),
    ('advanced-graphs', 'budget-flights', 3),
    ('advanced-graphs', 'rising-tide', 4),
    ('advanced-graphs', 'symbol-order', 5),
    ('advanced-graphs', 'extra-edge', 6),
    ('advanced-graphs', 'airport-route', 7),
    -- Dynamic Programming (+8)
    ('dynamic-programming', 'longest-palindrome', 10),
    ('dynamic-programming', 'cheap-stairs', 11),
    ('dynamic-programming', 'equal-partition', 12),
    ('dynamic-programming', 'perfect-sum', 13),
    ('dynamic-programming', 'nth-ugly', 14),
    ('dynamic-programming', 'room-builder', 15),
    ('dynamic-programming', 'break-integer', 16),
    ('dynamic-programming', 'longest-chain-count', 17),
    -- 2D Dynamic Programming (+10)
    ('2d-dynamic-programming', 'stock-cooldown', 4),
    ('2d-dynamic-programming', 'sign-assignments', 5),
    ('2d-dynamic-programming', 'string-weave', 6),
    ('2d-dynamic-programming', 'subsequence-count', 7),
    ('2d-dynamic-programming', 'pattern-matcher', 8),
    ('2d-dynamic-programming', 'balloon-popper', 9),
    ('2d-dynamic-programming', 'largest-square', 10),
    ('2d-dynamic-programming', 'change-maker', 11),
    ('2d-dynamic-programming', 'cheapest-path', 12),
    ('2d-dynamic-programming', 'longest-climb', 13),
    -- Greedy (+6)
    ('greedy', 'hand-grouping', 5),
    ('greedy', 'label-splitter', 6),
    ('greedy', 'flexible-brackets', 7),
    ('greedy', 'triplet-former', 8),
    ('greedy', 'height-queue', 9),
    ('greedy', 'almost-sorted', 10),
    -- Intervals (+3)
    ('intervals', 'room-checker', 4),
    ('intervals', 'query-intervals', 5),
    ('intervals', 'arrow-shooter', 6),
    -- Math & Geometry (+8)
    ('math-and-geometry', 'zero-matrix', 2),
    ('math-and-geometry', 'power-function', 3),
    ('math-and-geometry', 'string-multiply', 4),
    ('math-and-geometry', 'joyful-number', 5),
    ('math-and-geometry', 'increment-digits', 6),
    ('math-and-geometry', 'fizz-buzz-game', 7),
    ('math-and-geometry', 'mirror-number', 8),
    ('math-and-geometry', 'numeral-converter', 9),
    -- Bit Manipulation (+6)
    ('bit-manipulation', 'bit-tracker', 2),
    ('bit-manipulation', 'flip-bits', 3),
    ('bit-manipulation', 'absent-number', 4),
    ('bit-manipulation', 'bitwise-sum', 5),
    ('bit-manipulation', 'power-check', 6),
    ('bit-manipulation', 'bit-distance', 7),
    -- Design (+6) — NEW CATEGORY
    ('design', 'stack-queue', 1),
    ('design', 'ring-buffer', 2),
    ('design', 'hash-table', 3),
    ('design', 'random-set', 4),
    ('design', 'state-snapshots', 5),
    ('design', 'click-counter', 6)
) AS sub(cat_slug, prob_slug, ord)
JOIN roadmap_categories rc ON rc.slug = sub.cat_slug
JOIN problems p ON p.slug = sub.prob_slug;

------------------------------------------------------------
-- 4. ADD 2 NEW TAGS + ASSIGN TAGS TO PHASE 3 PROBLEMS
------------------------------------------------------------

INSERT INTO tags (name, slug) VALUES
    ('Advanced Graphs', 'advanced-graphs'),
    ('Design', 'design');

INSERT INTO problem_tags (problem_id, tag_id)
SELECT p.id, t.id FROM problems p, tags t WHERE
    -- Arrays & Hashing
    (p.slug IN ('popular-vote', 'remove-sorted-dupes', 'duplicate-finder', 'target-subarray', 'k-distinct-window')
     AND t.slug = 'arrays-and-hashing') OR
    -- Two Pointers
    (p.slug IN ('quad-sum', 'boat-loading', 'sorted-squares')
     AND t.slug = 'two-pointers') OR
    -- Sliding Window
    (p.slug IN ('shortest-cover', 'fruit-picker')
     AND t.slug = 'sliding-window') OR
    -- Stack
    (p.slug IN ('car-convoy', 'tallest-bar', 'space-rocks')
     AND t.slug = 'stack') OR
    -- Binary Search
    (p.slug IN ('time-map', 'sorted-median', 'matrix-search-ii', 'ship-capacity')
     AND t.slug = 'binary-search') OR
    -- Linked Lists
    (p.slug IN ('recent-cache', 'reverse-k-nodes', 'swap-pairs')
     AND t.slug = 'linked-lists') OR
    -- Trees
    (p.slug IN ('tree-codec', 'good-node-count', 'height-check', 'zigzag-levels', 'target-path', 'right-pointers', 'root-sum', 'flatten-tree', 'tree-ancestor')
     AND t.slug = 'trees') OR
    -- Heap / Priority Queue
    (p.slug IN ('array-kth-largest', 'job-scheduler', 'feed-designer', 'running-median', 'rearrange-letters', 'frequent-words')
     AND t.slug = 'heap-priority-queue') OR
    -- Backtracking
    (p.slug IN ('unique-subsets', 'unique-combinations', 'palindrome-split', 'ip-builder')
     AND t.slug = 'backtracking') OR
    -- Graphs
    (p.slug IN ('valid-tree', 'gate-distance', 'border-capture', 'word-chain', 'shortest-grid-path', 'room-explorer', 'two-colorable', 'equation-solver')
     AND t.slug = 'graphs') OR
    -- Advanced Graphs (new)
    (p.slug IN ('point-connector', 'signal-time', 'budget-flights', 'rising-tide', 'symbol-order', 'extra-edge', 'airport-route')
     AND t.slug = 'advanced-graphs') OR
    -- Dynamic Programming
    (p.slug IN ('longest-palindrome', 'cheap-stairs', 'equal-partition', 'perfect-sum', 'nth-ugly', 'room-builder', 'break-integer', 'longest-chain-count')
     AND t.slug = 'dynamic-programming') OR
    -- 2D Dynamic Programming
    (p.slug IN ('stock-cooldown', 'sign-assignments', 'string-weave', 'subsequence-count', 'pattern-matcher', 'balloon-popper', 'largest-square', 'change-maker', 'cheapest-path', 'longest-climb')
     AND t.slug = '2d-dynamic-programming') OR
    -- Greedy
    (p.slug IN ('hand-grouping', 'label-splitter', 'flexible-brackets', 'triplet-former', 'height-queue', 'almost-sorted')
     AND t.slug = 'greedy') OR
    -- Intervals
    (p.slug IN ('room-checker', 'query-intervals', 'arrow-shooter')
     AND t.slug = 'intervals') OR
    -- Math & Geometry
    (p.slug IN ('zero-matrix', 'power-function', 'string-multiply', 'joyful-number', 'increment-digits', 'fizz-buzz-game', 'mirror-number', 'numeral-converter')
     AND t.slug = 'math-and-geometry') OR
    -- Bit Manipulation
    (p.slug IN ('bit-tracker', 'flip-bits', 'absent-number', 'bitwise-sum', 'power-check', 'bit-distance')
     AND t.slug = 'bit-manipulation') OR
    -- Design (new)
    (p.slug IN ('stack-queue', 'ring-buffer', 'hash-table', 'random-set', 'state-snapshots', 'click-counter')
     AND t.slug = 'design');
