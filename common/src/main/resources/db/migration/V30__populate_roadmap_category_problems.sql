-- Populate roadmap_category_problems for all Phase 1 problems.
-- Clean slate: remove stale V18 assignments (7 deleted problems cascaded,
-- 14 remain with old order_index values) and re-insert with correct ordering.

DELETE FROM roadmap_category_problems;

INSERT INTO roadmap_category_problems (category_id, problem_id, order_index)
SELECT rc.id, p.id, sub.ord FROM (VALUES
    -- Hash Maps (9)
    ('hash-maps', 'pair-sum', 1),
    ('hash-maps', 'find-duplicates', 2),
    ('hash-maps', 'anagram-check', 3),
    ('hash-maps', 'anagram-groups', 4),
    ('hash-maps', 'k-most-frequent', 5),
    ('hash-maps', 'array-product', 6),
    ('hash-maps', 'longest-streak', 7),
    ('hash-maps', 'string-codec', 8),
    ('hash-maps', 'sudoku-validator', 9),
    -- Two Pointers + Sliding Window (8)
    ('two-pointers', 'palindrome-checker', 1),
    ('two-pointers', 'sorted-pair-sum', 2),
    ('two-pointers', 'three-sum', 3),
    ('two-pointers', 'water-container', 4),
    ('two-pointers', 'stock-profit', 5),
    ('two-pointers', 'unique-substring', 6),
    ('two-pointers', 'character-swap', 7),
    ('two-pointers', 'smallest-window', 8),
    -- Sorting (1)
    ('sorting', 'overlap-merge', 1),
    -- Stacks (2)
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
    -- Math & Bits (2)
    ('math-and-bits', 'rotate-grid', 1),
    ('math-and-bits', 'lone-element', 2),
    -- Heaps (1)
    ('heaps', 'kth-largest-stream', 1)
) AS sub(cat_slug, prob_slug, ord)
JOIN roadmap_categories rc ON rc.slug = sub.cat_slug
JOIN problems p ON p.slug = sub.prob_slug;
