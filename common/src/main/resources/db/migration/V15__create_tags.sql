CREATE TABLE tags (
    id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    slug VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE problem_tags (
    problem_id BIGINT NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    tag_id     BIGINT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (problem_id, tag_id)
);

-- Seed tags
INSERT INTO tags (name, slug) VALUES
    ('Array', 'array'),
    ('String', 'string'),
    ('Hash Table', 'hash-table'),
    ('Math', 'math'),
    ('Dynamic Programming', 'dynamic-programming'),
    ('Sorting', 'sorting'),
    ('Binary Search', 'binary-search'),
    ('Tree', 'tree'),
    ('Stack', 'stack'),
    ('Linked List', 'linked-list'),
    ('Two Pointers', 'two-pointers'),
    ('Recursion', 'recursion'),
    ('Graph', 'graph'),
    ('Greedy', 'greedy'),
    ('Backtracking', 'backtracking');

-- Assign tags to existing problems
-- Two Sum (id=1): Array, Hash Table
INSERT INTO problem_tags (problem_id, tag_id) SELECT 1, id FROM tags WHERE slug = 'array';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 1, id FROM tags WHERE slug = 'hash-table';

-- FizzBuzz (id=2): Math, String
INSERT INTO problem_tags (problem_id, tag_id) SELECT 2, id FROM tags WHERE slug = 'math';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 2, id FROM tags WHERE slug = 'string';

-- Reverse String (id=3): String, Two Pointers
INSERT INTO problem_tags (problem_id, tag_id) SELECT 3, id FROM tags WHERE slug = 'string';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 3, id FROM tags WHERE slug = 'two-pointers';

-- Valid Parentheses (id=4): String, Stack
INSERT INTO problem_tags (problem_id, tag_id) SELECT 4, id FROM tags WHERE slug = 'string';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 4, id FROM tags WHERE slug = 'stack';

-- Palindrome Number (id=5): Math
INSERT INTO problem_tags (problem_id, tag_id) SELECT 5, id FROM tags WHERE slug = 'math';

-- Sqrt(x) (id=6): Math, Binary Search
INSERT INTO problem_tags (problem_id, tag_id) SELECT 6, id FROM tags WHERE slug = 'math';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 6, id FROM tags WHERE slug = 'binary-search';

-- Reverse Words in a String (id=7): String, Two Pointers
INSERT INTO problem_tags (problem_id, tag_id) SELECT 7, id FROM tags WHERE slug = 'string';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 7, id FROM tags WHERE slug = 'two-pointers';

-- Plus One (id=8): Array, Math
INSERT INTO problem_tags (problem_id, tag_id) SELECT 8, id FROM tags WHERE slug = 'array';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 8, id FROM tags WHERE slug = 'math';

-- Pascal's Triangle (id=9): Array, Dynamic Programming
INSERT INTO problem_tags (problem_id, tag_id) SELECT 9, id FROM tags WHERE slug = 'array';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 9, id FROM tags WHERE slug = 'dynamic-programming';

-- Reverse Linked List (id=10): Linked List, Recursion
INSERT INTO problem_tags (problem_id, tag_id) SELECT 10, id FROM tags WHERE slug = 'linked-list';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 10, id FROM tags WHERE slug = 'recursion';

-- Invert Binary Tree (id=11): Tree, Recursion
INSERT INTO problem_tags (problem_id, tag_id) SELECT 11, id FROM tags WHERE slug = 'tree';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 11, id FROM tags WHERE slug = 'recursion';

-- Binary Tree Level Order Traversal (id=12): Tree
INSERT INTO problem_tags (problem_id, tag_id) SELECT 12, id FROM tags WHERE slug = 'tree';

-- Group Anagrams (id=13): Array, Hash Table, String, Sorting
INSERT INTO problem_tags (problem_id, tag_id) SELECT 13, id FROM tags WHERE slug = 'array';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 13, id FROM tags WHERE slug = 'hash-table';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 13, id FROM tags WHERE slug = 'string';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 13, id FROM tags WHERE slug = 'sorting';

-- Merge Intervals (id=14): Array, Sorting
INSERT INTO problem_tags (problem_id, tag_id) SELECT 14, id FROM tags WHERE slug = 'array';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 14, id FROM tags WHERE slug = 'sorting';

-- 3Sum (id=15): Array, Two Pointers, Sorting
INSERT INTO problem_tags (problem_id, tag_id) SELECT 15, id FROM tags WHERE slug = 'array';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 15, id FROM tags WHERE slug = 'two-pointers';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 15, id FROM tags WHERE slug = 'sorting';

-- Permutations (id=16): Array, Backtracking
INSERT INTO problem_tags (problem_id, tag_id) SELECT 16, id FROM tags WHERE slug = 'array';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 16, id FROM tags WHERE slug = 'backtracking';

-- Subsets (id=17): Array, Backtracking
INSERT INTO problem_tags (problem_id, tag_id) SELECT 17, id FROM tags WHERE slug = 'array';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 17, id FROM tags WHERE slug = 'backtracking';

-- Combination Sum (id=18): Array, Backtracking
INSERT INTO problem_tags (problem_id, tag_id) SELECT 18, id FROM tags WHERE slug = 'array';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 18, id FROM tags WHERE slug = 'backtracking';

-- Clone Graph (id=19): Graph
INSERT INTO problem_tags (problem_id, tag_id) SELECT 19, id FROM tags WHERE slug = 'graph';

-- N-Queens (id=20): Array, Backtracking
INSERT INTO problem_tags (problem_id, tag_id) SELECT 20, id FROM tags WHERE slug = 'array';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 20, id FROM tags WHERE slug = 'backtracking';

-- Accounts Merge (id=21): Array, String, Graph
INSERT INTO problem_tags (problem_id, tag_id) SELECT 21, id FROM tags WHERE slug = 'array';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 21, id FROM tags WHERE slug = 'string';
INSERT INTO problem_tags (problem_id, tag_id) SELECT 21, id FROM tags WHERE slug = 'graph';
