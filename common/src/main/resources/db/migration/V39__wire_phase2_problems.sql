-- V39: Wire all Phase 2 problems — assign problem_numbers, roadmap categories, tags, and add 4 new categories.

------------------------------------------------------------
-- 1. ASSIGN PROBLEM NUMBERS (51-99)
------------------------------------------------------------

-- Batch 1: Arrays & Hashing, Two Pointers, Sliding Window, Stack
UPDATE problems SET problem_number = 51 WHERE slug = 'color-sort';
UPDATE problems SET problem_number = 52 WHERE slug = 'next-arrangement';
UPDATE problems SET problem_number = 53 WHERE slug = 'first-missing-positive';
UPDATE problems SET problem_number = 54 WHERE slug = 'rain-collector';
UPDATE problems SET problem_number = 55 WHERE slug = 'move-zeroes';
UPDATE problems SET problem_number = 56 WHERE slug = 'substring-permutation';
UPDATE problems SET problem_number = 57 WHERE slug = 'window-maximum';
UPDATE problems SET problem_number = 58 WHERE slug = 'polish-notation';
UPDATE problems SET problem_number = 59 WHERE slug = 'parentheses-generator';
UPDATE problems SET problem_number = 60 WHERE slug = 'temperature-wait';

-- Batch 2: Binary Search, Linked Lists
UPDATE problems SET problem_number = 61 WHERE slug = 'search-rotated-array';
UPDATE problems SET problem_number = 62 WHERE slug = 'koko-bananas';
UPDATE problems SET problem_number = 63 WHERE slug = 'find-peak';
UPDATE problems SET problem_number = 64 WHERE slug = 'reorder-list';
UPDATE problems SET problem_number = 65 WHERE slug = 'add-two-numbers';
UPDATE problems SET problem_number = 66 WHERE slug = 'copy-random-list';
UPDATE problems SET problem_number = 67 WHERE slug = 'merge-k-lists';

-- Batch 3: Trees, Tries
UPDATE problems SET problem_number = 68 WHERE slug = 'kth-smallest-bst';
UPDATE problems SET problem_number = 69 WHERE slug = 'build-tree';
UPDATE problems SET problem_number = 70 WHERE slug = 'right-side-view';
UPDATE problems SET problem_number = 71 WHERE slug = 'tree-diameter';
UPDATE problems SET problem_number = 72 WHERE slug = 'max-path-sum';
UPDATE problems SET problem_number = 73 WHERE slug = 'prefix-tree';
UPDATE problems SET problem_number = 74 WHERE slug = 'word-dictionary';
UPDATE problems SET problem_number = 75 WHERE slug = 'word-finder';

-- Batch 4: Backtracking, Graphs
UPDATE problems SET problem_number = 76 WHERE slug = 'word-search';
UPDATE problems SET problem_number = 77 WHERE slug = 'phone-combos';
UPDATE problems SET problem_number = 78 WHERE slug = 'pacific-atlantic';
UPDATE problems SET problem_number = 79 WHERE slug = 'queen-placement';
UPDATE problems SET problem_number = 80 WHERE slug = 'course-order';
UPDATE problems SET problem_number = 81 WHERE slug = 'connected-components';
UPDATE problems SET problem_number = 82 WHERE slug = 'rotting-oranges';

-- Batch 5: DP, 2D DP
UPDATE problems SET problem_number = 83 WHERE slug = 'house-thief-ii';
UPDATE problems SET problem_number = 84 WHERE slug = 'decode-ways';
UPDATE problems SET problem_number = 85 WHERE slug = 'max-product-subarray';
UPDATE problems SET problem_number = 86 WHERE slug = 'account-merger';
UPDATE problems SET problem_number = 87 WHERE slug = 'palindrome-count';
UPDATE problems SET problem_number = 88 WHERE slug = 'unique-paths';
UPDATE problems SET problem_number = 89 WHERE slug = 'longest-common-subseq';
UPDATE problems SET problem_number = 90 WHERE slug = 'edit-distance';

-- Batch 6: Greedy, Intervals, Heap, Math, Bits
UPDATE problems SET problem_number = 91 WHERE slug = 'jump-game-ii';
UPDATE problems SET problem_number = 92 WHERE slug = 'gas-station';
UPDATE problems SET problem_number = 93 WHERE slug = 'insert-interval';
UPDATE problems SET problem_number = 94 WHERE slug = 'non-overlapping';
UPDATE problems SET problem_number = 95 WHERE slug = 'meeting-rooms';
UPDATE problems SET problem_number = 96 WHERE slug = 'last-stone';
UPDATE problems SET problem_number = 97 WHERE slug = 'k-closest-points';
UPDATE problems SET problem_number = 98 WHERE slug = 'spiral-matrix';
UPDATE problems SET problem_number = 99 WHERE slug = 'count-bits';

------------------------------------------------------------
-- 2. ADD 4 NEW ROADMAP CATEGORIES
------------------------------------------------------------

INSERT INTO roadmap_categories (name, slug, description, display_order) VALUES
    ('Intervals', 'intervals', 'Merge, insert, and schedule overlapping ranges', 14),
    ('2D Dynamic Programming', '2d-dynamic-programming', 'Solve problems on grids and two-sequence comparisons', 15),
    ('Bit Manipulation', 'bit-manipulation', 'Leverage binary representation for efficient solutions', 16),
    ('Math & Geometry', 'math-and-geometry', 'Apply mathematical patterns and spatial reasoning', 17);

------------------------------------------------------------
-- 3. ADD PREREQUISITE EDGES FOR NEW CATEGORIES
------------------------------------------------------------

INSERT INTO roadmap_category_prerequisites (category_id, prerequisite_id)
SELECT c.id, p.id FROM roadmap_categories c, roadmap_categories p WHERE
    (c.slug = 'intervals'              AND p.slug = 'heaps') OR
    (c.slug = '2d-dynamic-programming' AND p.slug = 'dynamic-programming') OR
    (c.slug = 'bit-manipulation'       AND p.slug = 'dynamic-programming') OR
    (c.slug = 'math-and-geometry'      AND p.slug = 'arrays-and-hashing');

------------------------------------------------------------
-- 4. ASSIGN PHASE 2 PROBLEMS TO ROADMAP CATEGORIES
------------------------------------------------------------

INSERT INTO roadmap_category_problems (category_id, problem_id, order_index)
SELECT rc.id, p.id, sub.ord FROM (VALUES
    -- Arrays & Hashing (3 new)
    ('arrays-and-hashing', 'color-sort', 13),
    ('arrays-and-hashing', 'next-arrangement', 14),
    ('arrays-and-hashing', 'first-missing-positive', 15),
    -- Two Pointers (2 new)
    ('two-pointers', 'rain-collector', 6),
    ('two-pointers', 'move-zeroes', 7),
    -- Sliding Window (2 new)
    ('sliding-window', 'substring-permutation', 4),
    ('sliding-window', 'window-maximum', 5),
    -- Stack (3 new)
    ('stacks', 'polish-notation', 3),
    ('stacks', 'parentheses-generator', 4),
    ('stacks', 'temperature-wait', 5),
    -- Binary Search (3 new)
    ('binary-search', 'search-rotated-array', 4),
    ('binary-search', 'koko-bananas', 5),
    ('binary-search', 'find-peak', 6),
    -- Linked Lists (4 new)
    ('linked-lists', 'reorder-list', 5),
    ('linked-lists', 'add-two-numbers', 6),
    ('linked-lists', 'copy-random-list', 7),
    ('linked-lists', 'merge-k-lists', 8),
    -- Trees (5 new)
    ('trees', 'kth-smallest-bst', 8),
    ('trees', 'build-tree', 9),
    ('trees', 'right-side-view', 10),
    ('trees', 'tree-diameter', 11),
    ('trees', 'max-path-sum', 12),
    -- Tries (3 new)
    ('tries', 'prefix-tree', 1),
    ('tries', 'word-dictionary', 2),
    ('tries', 'word-finder', 3),
    -- Backtracking (2 new)
    ('backtracking', 'word-search', 5),
    ('backtracking', 'phone-combos', 6),
    -- Graphs (4 new)
    ('graphs', 'pacific-atlantic', 5),
    ('graphs', 'course-order', 6),
    ('graphs', 'connected-components', 7),
    ('graphs', 'rotting-oranges', 8),
    -- Dynamic Programming (4 new)
    ('dynamic-programming', 'house-thief-ii', 6),
    ('dynamic-programming', 'decode-ways', 7),
    ('dynamic-programming', 'max-product-subarray', 8),
    ('dynamic-programming', 'palindrome-count', 9),
    -- Greedy (2 new)
    ('greedy', 'jump-game-ii', 3),
    ('greedy', 'gas-station', 4),
    -- Heap / Priority Queue (2 new)
    ('heaps', 'last-stone', 2),
    ('heaps', 'k-closest-points', 3),
    -- Intervals (3 new)
    ('intervals', 'insert-interval', 1),
    ('intervals', 'non-overlapping', 2),
    ('intervals', 'meeting-rooms', 3),
    -- 2D Dynamic Programming (3 new)
    ('2d-dynamic-programming', 'unique-paths', 1),
    ('2d-dynamic-programming', 'longest-common-subseq', 2),
    ('2d-dynamic-programming', 'edit-distance', 3),
    -- Bit Manipulation (1 new)
    ('bit-manipulation', 'count-bits', 1),
    -- Math & Geometry (1 new)
    ('math-and-geometry', 'spiral-matrix', 1)
) AS sub(cat_slug, prob_slug, ord)
JOIN roadmap_categories rc ON rc.slug = sub.cat_slug
JOIN problems p ON p.slug = sub.prob_slug;

------------------------------------------------------------
-- 5. ADD 4 NEW TAGS + ASSIGN TAGS TO PHASE 2 PROBLEMS
------------------------------------------------------------

INSERT INTO tags (name, slug) VALUES
    ('Intervals', 'intervals'),
    ('2D Dynamic Programming', '2d-dynamic-programming'),
    ('Bit Manipulation', 'bit-manipulation'),
    ('Math & Geometry', 'math-and-geometry');

INSERT INTO problem_tags (problem_id, tag_id)
SELECT p.id, t.id FROM problems p, tags t WHERE
    -- Arrays & Hashing
    (p.slug IN ('color-sort', 'next-arrangement', 'first-missing-positive')
     AND t.slug = 'arrays-and-hashing') OR
    -- Two Pointers
    (p.slug IN ('rain-collector', 'move-zeroes')
     AND t.slug = 'two-pointers') OR
    -- Sliding Window
    (p.slug IN ('substring-permutation', 'window-maximum')
     AND t.slug = 'sliding-window') OR
    -- Stack
    (p.slug IN ('polish-notation', 'parentheses-generator', 'temperature-wait')
     AND t.slug = 'stack') OR
    -- Binary Search
    (p.slug IN ('search-rotated-array', 'koko-bananas', 'find-peak')
     AND t.slug = 'binary-search') OR
    -- Linked Lists
    (p.slug IN ('reorder-list', 'add-two-numbers', 'copy-random-list', 'merge-k-lists')
     AND t.slug = 'linked-lists') OR
    -- Trees
    (p.slug IN ('kth-smallest-bst', 'build-tree', 'right-side-view', 'tree-diameter', 'max-path-sum')
     AND t.slug = 'trees') OR
    -- Tries
    (p.slug IN ('prefix-tree', 'word-dictionary', 'word-finder')
     AND t.slug = 'tries') OR
    -- Backtracking
    (p.slug IN ('word-search', 'phone-combos')
     AND t.slug = 'backtracking') OR
    -- Graphs
    (p.slug IN ('pacific-atlantic', 'course-order', 'connected-components', 'rotting-oranges')
     AND t.slug = 'graphs') OR
    -- Dynamic Programming
    (p.slug IN ('house-thief-ii', 'decode-ways', 'max-product-subarray', 'palindrome-count')
     AND t.slug = 'dynamic-programming') OR
    -- Greedy
    (p.slug IN ('jump-game-ii', 'gas-station')
     AND t.slug = 'greedy') OR
    -- Heap / Priority Queue
    (p.slug IN ('last-stone', 'k-closest-points')
     AND t.slug = 'heap-priority-queue') OR
    -- Intervals (new)
    (p.slug IN ('insert-interval', 'non-overlapping', 'meeting-rooms')
     AND t.slug = 'intervals') OR
    -- 2D Dynamic Programming (new)
    (p.slug IN ('unique-paths', 'longest-common-subseq', 'edit-distance')
     AND t.slug = '2d-dynamic-programming') OR
    -- Bit Manipulation (new)
    (p.slug IN ('count-bits')
     AND t.slug = 'bit-manipulation') OR
    -- Math & Geometry (new)
    (p.slug IN ('spiral-matrix')
     AND t.slug = 'math-and-geometry');

-- Also tag account-merger (already in graphs roadmap, needs the graphs tag)
INSERT INTO problem_tags (problem_id, tag_id)
SELECT p.id, t.id FROM problems p, tags t
WHERE p.slug = 'account-merger' AND t.slug = 'graphs'
AND NOT EXISTS (SELECT 1 FROM problem_tags pt WHERE pt.problem_id = p.id AND pt.tag_id = t.id);
