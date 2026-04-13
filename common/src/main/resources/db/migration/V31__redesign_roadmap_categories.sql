-- Redesign roadmap: remove Foundations/Sorting/Recursion/Math&Bits,
-- add Sliding Window, rename categories to match NeetCode conventions.

-- 1. Clear existing assignments and prerequisites
DELETE FROM roadmap_category_problems;
DELETE FROM roadmap_category_prerequisites;

-- 2. Remove categories
DELETE FROM roadmap_categories WHERE slug IN ('foundations', 'sorting', 'recursion', 'math-and-bits');

-- 3. Add Sliding Window
INSERT INTO roadmap_categories (name, slug, description, display_order)
VALUES ('Sliding Window', 'sliding-window', 'Optimize with a moving window over your data', 3);

-- 4. Rename and reorder existing categories
UPDATE roadmap_categories SET name = 'Arrays & Hashing', slug = 'arrays-and-hashing',
  description = 'Map keys to values, manipulate arrays for O(1) lookups', display_order = 1
  WHERE slug = 'hash-maps';

UPDATE roadmap_categories SET name = 'Two Pointers', display_order = 2
  WHERE slug = 'two-pointers';

UPDATE roadmap_categories SET name = 'Stack',
  description = 'Last in, first out — track state as you go', display_order = 4
  WHERE slug = 'stacks';

UPDATE roadmap_categories SET display_order = 5 WHERE slug = 'binary-search';

UPDATE roadmap_categories SET display_order = 6 WHERE slug = 'linked-lists';

UPDATE roadmap_categories SET display_order = 7 WHERE slug = 'trees';

UPDATE roadmap_categories SET display_order = 8 WHERE slug = 'tries';

UPDATE roadmap_categories SET name = 'Heap / Priority Queue',
  description = 'Always know your min or max in O(1)', display_order = 9
  WHERE slug = 'heaps';

UPDATE roadmap_categories SET display_order = 10 WHERE slug = 'backtracking';

UPDATE roadmap_categories SET display_order = 11 WHERE slug = 'graphs';

UPDATE roadmap_categories SET display_order = 12 WHERE slug = 'greedy';

UPDATE roadmap_categories SET display_order = 13 WHERE slug = 'dynamic-programming';

-- 5. Insert new prerequisite edges (NeetCode-inspired DAG)
INSERT INTO roadmap_category_prerequisites (category_id, prerequisite_id)
SELECT c.id, p.id FROM roadmap_categories c, roadmap_categories p WHERE
    -- Arrays & Hashing → Two Pointers, Stack
    (c.slug = 'two-pointers'           AND p.slug = 'arrays-and-hashing') OR
    (c.slug = 'stacks'                 AND p.slug = 'arrays-and-hashing') OR
    -- Two Pointers → Sliding Window
    (c.slug = 'sliding-window'         AND p.slug = 'two-pointers') OR
    -- Two Pointers → Binary Search
    (c.slug = 'binary-search'          AND p.slug = 'two-pointers') OR
    -- Stack → Linked Lists
    (c.slug = 'linked-lists'           AND p.slug = 'stacks') OR
    -- Binary Search + Linked Lists → Trees
    (c.slug = 'trees'                  AND p.slug = 'binary-search') OR
    (c.slug = 'trees'                  AND p.slug = 'linked-lists') OR
    -- Trees → Tries, Backtracking, Heap/PQ
    (c.slug = 'tries'                  AND p.slug = 'trees') OR
    (c.slug = 'backtracking'           AND p.slug = 'trees') OR
    (c.slug = 'heaps'                  AND p.slug = 'trees') OR
    -- Backtracking → Graphs, DP
    (c.slug = 'graphs'                 AND p.slug = 'backtracking') OR
    (c.slug = 'dynamic-programming'    AND p.slug = 'backtracking') OR
    -- Heap/PQ → Greedy
    (c.slug = 'greedy'                 AND p.slug = 'heaps');

-- 6. Re-insert problem assignments with new categorization
INSERT INTO roadmap_category_problems (category_id, problem_id, order_index)
SELECT rc.id, p.id, sub.ord FROM (VALUES
    -- Arrays & Hashing (11)
    ('arrays-and-hashing', 'pair-sum', 1),
    ('arrays-and-hashing', 'find-duplicates', 2),
    ('arrays-and-hashing', 'anagram-check', 3),
    ('arrays-and-hashing', 'anagram-groups', 4),
    ('arrays-and-hashing', 'k-most-frequent', 5),
    ('arrays-and-hashing', 'array-product', 6),
    ('arrays-and-hashing', 'longest-streak', 7),
    ('arrays-and-hashing', 'string-codec', 8),
    ('arrays-and-hashing', 'sudoku-validator', 9),
    ('arrays-and-hashing', 'overlap-merge', 10),
    ('arrays-and-hashing', 'rotate-grid', 11),
    -- Two Pointers (5)
    ('two-pointers', 'palindrome-checker', 1),
    ('two-pointers', 'sorted-pair-sum', 2),
    ('two-pointers', 'three-sum', 3),
    ('two-pointers', 'water-container', 4),
    ('two-pointers', 'character-swap', 5),
    -- Sliding Window (3)
    ('sliding-window', 'stock-profit', 1),
    ('sliding-window', 'unique-substring', 2),
    ('sliding-window', 'smallest-window', 3),
    -- Stack (2)
    ('stacks', 'bracket-validator', 1),
    ('stacks', 'minimum-stack', 2),
    -- Binary Search (3)
    ('binary-search', 'basic-binary-search', 1),
    ('binary-search', 'matrix-search', 2),
    ('binary-search', 'rotated-array-min', 3),
    -- Linked Lists (4)
    ('linked-lists', 'reverse-list', 1),
    ('linked-lists', 'merge-sorted-lists', 2),
    ('linked-lists', 'cycle-detection', 3),
    ('linked-lists', 'remove-from-end', 4),
    -- Trees (7)
    ('trees', 'mirror-tree', 1),
    ('trees', 'tree-depth', 2),
    ('trees', 'identical-trees', 3),
    ('trees', 'tree-within-tree', 4),
    ('trees', 'level-traversal', 5),
    ('trees', 'bst-validator', 6),
    ('trees', 'bst-ancestor', 7),
    -- Backtracking (4)
    ('backtracking', 'all-subsets', 1),
    ('backtracking', 'target-combinations', 2),
    ('backtracking', 'all-arrangements', 3),
    ('backtracking', 'queen-placement', 4),
    -- Graphs (4)
    ('graphs', 'island-counter', 1),
    ('graphs', 'graph-copy', 2),
    ('graphs', 'course-planner', 3),
    ('graphs', 'account-merger', 4),
    -- Greedy (2)
    ('greedy', 'largest-subarray', 1),
    ('greedy', 'reach-the-end', 2),
    -- Dynamic Programming (5)
    ('dynamic-programming', 'staircase', 1),
    ('dynamic-programming', 'house-thief', 2),
    ('dynamic-programming', 'coin-picker', 3),
    ('dynamic-programming', 'longest-ascending', 4),
    ('dynamic-programming', 'word-segmentation', 5),
    -- Heap / Priority Queue (1)
    ('heaps', 'kth-largest-stream', 1),
    -- Bit Manipulation (1)
    ('arrays-and-hashing', 'lone-element', 12)
) AS sub(cat_slug, prob_slug, ord)
JOIN roadmap_categories rc ON rc.slug = sub.cat_slug
JOIN problems p ON p.slug = sub.prob_slug;
