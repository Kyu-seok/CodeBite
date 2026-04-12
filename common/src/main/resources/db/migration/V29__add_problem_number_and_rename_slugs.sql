-- Add problem_number column for curated display ordering
ALTER TABLE problems ADD COLUMN problem_number INTEGER;

-- Assign problem numbers following docs/PROBLEMS_MAPPING.md
-- Phase 1 (#1-#50)
UPDATE problems SET problem_number = 1 WHERE slug = 'two-sum';
UPDATE problems SET problem_number = 2 WHERE slug = 'find-duplicates';
UPDATE problems SET problem_number = 3 WHERE slug = 'anagram-check';
UPDATE problems SET problem_number = 4 WHERE slug = 'group-anagrams';
UPDATE problems SET problem_number = 5 WHERE slug = 'k-most-frequent';
UPDATE problems SET problem_number = 6 WHERE slug = 'array-product';
UPDATE problems SET problem_number = 7 WHERE slug = 'longest-streak';
UPDATE problems SET problem_number = 8 WHERE slug = 'string-codec';
UPDATE problems SET problem_number = 9 WHERE slug = 'sudoku-validator';
UPDATE problems SET problem_number = 10 WHERE slug = 'palindrome-checker';
UPDATE problems SET problem_number = 11 WHERE slug = 'sorted-pair-sum';
UPDATE problems SET problem_number = 12 WHERE slug = '3sum';
UPDATE problems SET problem_number = 13 WHERE slug = 'water-container';
UPDATE problems SET problem_number = 14 WHERE slug = 'stock-profit';
UPDATE problems SET problem_number = 15 WHERE slug = 'unique-substring';
UPDATE problems SET problem_number = 16 WHERE slug = 'character-swap';
UPDATE problems SET problem_number = 17 WHERE slug = 'smallest-window';
UPDATE problems SET problem_number = 18 WHERE slug = 'valid-parentheses';
UPDATE problems SET problem_number = 19 WHERE slug = 'minimum-stack';
UPDATE problems SET problem_number = 20 WHERE slug = 'basic-binary-search';
UPDATE problems SET problem_number = 21 WHERE slug = 'matrix-search';
UPDATE problems SET problem_number = 22 WHERE slug = 'rotated-array-min';
UPDATE problems SET problem_number = 23 WHERE slug = 'reverse-linked-list';
UPDATE problems SET problem_number = 24 WHERE slug = 'merge-sorted-lists';
UPDATE problems SET problem_number = 25 WHERE slug = 'cycle-detection';
UPDATE problems SET problem_number = 26 WHERE slug = 'remove-from-end';
UPDATE problems SET problem_number = 27 WHERE slug = 'invert-binary-tree';
UPDATE problems SET problem_number = 28 WHERE slug = 'tree-depth';
UPDATE problems SET problem_number = 29 WHERE slug = 'identical-trees';
UPDATE problems SET problem_number = 30 WHERE slug = 'tree-within-tree';
UPDATE problems SET problem_number = 31 WHERE slug = 'binary-tree-level-order-traversal';
UPDATE problems SET problem_number = 32 WHERE slug = 'bst-validator';
UPDATE problems SET problem_number = 33 WHERE slug = 'bst-ancestor';
UPDATE problems SET problem_number = 34 WHERE slug = 'subsets';
UPDATE problems SET problem_number = 35 WHERE slug = 'combination-sum';
UPDATE problems SET problem_number = 36 WHERE slug = 'permutations';
UPDATE problems SET problem_number = 37 WHERE slug = 'island-counter';
UPDATE problems SET problem_number = 38 WHERE slug = 'clone-graph';
UPDATE problems SET problem_number = 39 WHERE slug = 'course-planner';
UPDATE problems SET problem_number = 40 WHERE slug = 'staircase';
UPDATE problems SET problem_number = 41 WHERE slug = 'house-thief';
UPDATE problems SET problem_number = 42 WHERE slug = 'coin-picker';
UPDATE problems SET problem_number = 43 WHERE slug = 'longest-ascending';
UPDATE problems SET problem_number = 44 WHERE slug = 'word-segmentation';
UPDATE problems SET problem_number = 45 WHERE slug = 'largest-subarray';
UPDATE problems SET problem_number = 46 WHERE slug = 'reach-the-end';
UPDATE problems SET problem_number = 47 WHERE slug = 'merge-intervals';
UPDATE problems SET problem_number = 48 WHERE slug = 'rotate-grid';
UPDATE problems SET problem_number = 49 WHERE slug = 'lone-element';
UPDATE problems SET problem_number = 50 WHERE slug = 'kth-largest-stream';

-- Phase 2 holdovers
UPDATE problems SET problem_number = 79 WHERE slug = 'n-queens';
UPDATE problems SET problem_number = 86 WHERE slug = 'accounts-merge';

CREATE UNIQUE INDEX idx_problems_problem_number ON problems (problem_number);

-- Rename legacy slugs and titles to match PROBLEMS_MAPPING.md
UPDATE problems SET slug = 'pair-sum', title = 'Pair Sum' WHERE slug = 'two-sum';
UPDATE problems SET slug = 'anagram-groups', title = 'Anagram Groups' WHERE slug = 'group-anagrams';
UPDATE problems SET slug = 'three-sum', title = 'Three Sum' WHERE slug = '3sum';
UPDATE problems SET slug = 'bracket-validator', title = 'Bracket Validator' WHERE slug = 'valid-parentheses';
UPDATE problems SET slug = 'reverse-list', title = 'Reverse List' WHERE slug = 'reverse-linked-list';
UPDATE problems SET slug = 'mirror-tree', title = 'Mirror Tree' WHERE slug = 'invert-binary-tree';
UPDATE problems SET slug = 'level-traversal', title = 'Level Traversal' WHERE slug = 'binary-tree-level-order-traversal';
UPDATE problems SET slug = 'all-subsets', title = 'All Subsets' WHERE slug = 'subsets';
UPDATE problems SET slug = 'target-combinations', title = 'Target Combinations' WHERE slug = 'combination-sum';
UPDATE problems SET slug = 'all-arrangements', title = 'All Arrangements' WHERE slug = 'permutations';
UPDATE problems SET slug = 'graph-copy', title = 'Graph Copy' WHERE slug = 'clone-graph';
UPDATE problems SET slug = 'overlap-merge', title = 'Overlap Merge' WHERE slug = 'merge-intervals';
UPDATE problems SET slug = 'queen-placement', title = 'Queen Placement' WHERE slug = 'n-queens';
UPDATE problems SET slug = 'account-merger', title = 'Account Merger' WHERE slug = 'accounts-merge';

-- Update English translations to match new titles
UPDATE problem_translations SET title = 'Pair Sum'
WHERE locale = 'en' AND problem_id = (SELECT id FROM problems WHERE slug = 'pair-sum');
UPDATE problem_translations SET title = 'Anagram Groups'
WHERE locale = 'en' AND problem_id = (SELECT id FROM problems WHERE slug = 'anagram-groups');
UPDATE problem_translations SET title = 'Three Sum'
WHERE locale = 'en' AND problem_id = (SELECT id FROM problems WHERE slug = 'three-sum');
UPDATE problem_translations SET title = 'Bracket Validator'
WHERE locale = 'en' AND problem_id = (SELECT id FROM problems WHERE slug = 'bracket-validator');
UPDATE problem_translations SET title = 'Reverse List'
WHERE locale = 'en' AND problem_id = (SELECT id FROM problems WHERE slug = 'reverse-list');
UPDATE problem_translations SET title = 'Mirror Tree'
WHERE locale = 'en' AND problem_id = (SELECT id FROM problems WHERE slug = 'mirror-tree');
UPDATE problem_translations SET title = 'Level Traversal'
WHERE locale = 'en' AND problem_id = (SELECT id FROM problems WHERE slug = 'level-traversal');
UPDATE problem_translations SET title = 'All Subsets'
WHERE locale = 'en' AND problem_id = (SELECT id FROM problems WHERE slug = 'all-subsets');
UPDATE problem_translations SET title = 'Target Combinations'
WHERE locale = 'en' AND problem_id = (SELECT id FROM problems WHERE slug = 'target-combinations');
UPDATE problem_translations SET title = 'All Arrangements'
WHERE locale = 'en' AND problem_id = (SELECT id FROM problems WHERE slug = 'all-arrangements');
UPDATE problem_translations SET title = 'Graph Copy'
WHERE locale = 'en' AND problem_id = (SELECT id FROM problems WHERE slug = 'graph-copy');
UPDATE problem_translations SET title = 'Overlap Merge'
WHERE locale = 'en' AND problem_id = (SELECT id FROM problems WHERE slug = 'overlap-merge');
UPDATE problem_translations SET title = 'Queen Placement'
WHERE locale = 'en' AND problem_id = (SELECT id FROM problems WHERE slug = 'queen-placement');
UPDATE problem_translations SET title = 'Account Merger'
WHERE locale = 'en' AND problem_id = (SELECT id FROM problems WHERE slug = 'account-merger');
