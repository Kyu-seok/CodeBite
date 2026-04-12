-- English translations for Phase 1 new problems
-- Copies title, description, constraints from problems table (same as V22 pattern)

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems
WHERE slug IN (
    'find-duplicates', 'anagram-check', 'k-most-frequent', 'array-product',
    'longest-streak', 'string-codec', 'sudoku-validator',
    'palindrome-checker', 'sorted-pair-sum', 'water-container',
    'stock-profit', 'unique-substring', 'character-swap', 'smallest-window',
    'minimum-stack', 'basic-binary-search', 'matrix-search', 'rotated-array-min',
    'merge-sorted-lists', 'cycle-detection', 'remove-from-end',
    'tree-depth', 'identical-trees', 'tree-within-tree', 'bst-validator', 'bst-ancestor',
    'island-counter', 'course-planner',
    'staircase', 'house-thief', 'coin-picker', 'longest-ascending', 'word-segmentation',
    'largest-subarray', 'reach-the-end',
    'rotate-grid', 'lone-element'
);
