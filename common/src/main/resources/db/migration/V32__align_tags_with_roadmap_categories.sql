-- Replace tags with the 13 roadmap categories so the problem list
-- filter badges match the roadmap learning path.

-- 1. Clear existing problem-tag assignments
DELETE FROM problem_tags;

-- 2. Remove old tags
DELETE FROM tags;

-- 3. Insert new tags matching roadmap categories
INSERT INTO tags (name, slug) VALUES
    ('Arrays & Hashing', 'arrays-and-hashing'),
    ('Two Pointers', 'two-pointers'),
    ('Sliding Window', 'sliding-window'),
    ('Stack', 'stack'),
    ('Binary Search', 'binary-search'),
    ('Linked Lists', 'linked-lists'),
    ('Trees', 'trees'),
    ('Tries', 'tries'),
    ('Heap / Priority Queue', 'heap-priority-queue'),
    ('Backtracking', 'backtracking'),
    ('Graphs', 'graphs'),
    ('Greedy', 'greedy'),
    ('Dynamic Programming', 'dynamic-programming');

-- 4. Assign problems to tags (one tag per problem, matching roadmap category)
INSERT INTO problem_tags (problem_id, tag_id)
SELECT p.id, t.id FROM problems p, tags t WHERE
    -- Arrays & Hashing
    (p.slug IN ('pair-sum', 'find-duplicates', 'anagram-check', 'anagram-groups',
                'k-most-frequent', 'array-product', 'longest-streak', 'string-codec',
                'sudoku-validator', 'overlap-merge', 'rotate-grid', 'lone-element')
     AND t.slug = 'arrays-and-hashing') OR
    -- Two Pointers
    (p.slug IN ('palindrome-checker', 'sorted-pair-sum', 'three-sum',
                'water-container', 'character-swap')
     AND t.slug = 'two-pointers') OR
    -- Sliding Window
    (p.slug IN ('stock-profit', 'unique-substring', 'smallest-window')
     AND t.slug = 'sliding-window') OR
    -- Stack
    (p.slug IN ('bracket-validator', 'minimum-stack')
     AND t.slug = 'stack') OR
    -- Binary Search
    (p.slug IN ('basic-binary-search', 'matrix-search', 'rotated-array-min')
     AND t.slug = 'binary-search') OR
    -- Linked Lists
    (p.slug IN ('reverse-list', 'merge-sorted-lists', 'cycle-detection', 'remove-from-end')
     AND t.slug = 'linked-lists') OR
    -- Trees
    (p.slug IN ('mirror-tree', 'tree-depth', 'identical-trees', 'tree-within-tree',
                'level-traversal', 'bst-validator', 'bst-ancestor')
     AND t.slug = 'trees') OR
    -- Backtracking
    (p.slug IN ('all-subsets', 'target-combinations', 'all-arrangements', 'queen-placement')
     AND t.slug = 'backtracking') OR
    -- Graphs
    (p.slug IN ('island-counter', 'graph-copy', 'course-planner', 'account-merger')
     AND t.slug = 'graphs') OR
    -- Greedy
    (p.slug IN ('largest-subarray', 'reach-the-end')
     AND t.slug = 'greedy') OR
    -- Dynamic Programming
    (p.slug IN ('staircase', 'house-thief', 'coin-picker', 'longest-ascending', 'word-segmentation')
     AND t.slug = 'dynamic-programming') OR
    -- Heap / Priority Queue
    (p.slug IN ('kth-largest-stream')
     AND t.slug = 'heap-priority-queue');
