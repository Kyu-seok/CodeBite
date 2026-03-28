-- Roadmap categories
CREATE TABLE roadmap_categories (
    id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name          VARCHAR(100) NOT NULL UNIQUE,
    slug          VARCHAR(100) NOT NULL UNIQUE,
    description   VARCHAR(255),
    display_order INT NOT NULL DEFAULT 0,
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Prerequisite edges (prerequisite_id must be completed before category_id)
CREATE TABLE roadmap_category_prerequisites (
    category_id     BIGINT NOT NULL REFERENCES roadmap_categories(id) ON DELETE CASCADE,
    prerequisite_id BIGINT NOT NULL REFERENCES roadmap_categories(id) ON DELETE CASCADE,
    PRIMARY KEY (category_id, prerequisite_id)
);

-- Problems assigned to categories with ordering
CREATE TABLE roadmap_category_problems (
    category_id BIGINT NOT NULL REFERENCES roadmap_categories(id) ON DELETE CASCADE,
    problem_id  BIGINT NOT NULL REFERENCES problems(id) ON DELETE CASCADE,
    order_index INT NOT NULL DEFAULT 0,
    PRIMARY KEY (category_id, problem_id)
);

CREATE INDEX idx_rcp_category ON roadmap_category_problems(category_id);
CREATE INDEX idx_rcp_problem ON roadmap_category_problems(problem_id);

-- Seed 16 categories
INSERT INTO roadmap_categories (name, slug, description, display_order) VALUES
('Foundations',            'foundations',            'Build your core programming toolkit',                1),
('Hash Maps',              'hash-maps',              'Map keys to values for O(1) lookups',                2),
('Stacks',                 'stacks',                 'Last in, first out — track state as you go',         3),
('Sorting',                'sorting',                'Arrange elements to reveal structure',                4),
('Two Pointers',           'two-pointers',           'Converge from both ends to find your answer',        5),
('Linked Lists',           'linked-lists',           'Chain nodes together, think in pointers',            6),
('Binary Search',          'binary-search',          'Halve the search space with every step',             7),
('Recursion',              'recursion',              'Solve the subproblem, trust the rest',               8),
('Trees',                  'trees',                  'Navigate hierarchies with DFS and BFS',              9),
('Backtracking',           'backtracking',           'Explore all paths, prune the dead ends',            10),
('Tries',                  'tries',                  'Store strings character by character',               11),
('Heaps',                  'heaps',                  'Always know your min or max in O(1)',                12),
('Graphs',                 'graphs',                 'Model connections and traverse them',                13),
('Greedy',                 'greedy',                 'Make the locally optimal choice at each step',       14),
('Dynamic Programming',    'dynamic-programming',    'Remember past answers to build new ones',            15),
('Math & Bits',            'math-and-bits',           'Leverage number theory and bitwise tricks',          16);

-- Seed prerequisite edges
INSERT INTO roadmap_category_prerequisites (category_id, prerequisite_id)
SELECT c.id, p.id FROM roadmap_categories c, roadmap_categories p WHERE
    (c.slug = 'hash-maps'              AND p.slug = 'foundations') OR
    (c.slug = 'stacks'                 AND p.slug = 'foundations') OR
    (c.slug = 'sorting'                AND p.slug = 'foundations') OR
    (c.slug = 'two-pointers'           AND p.slug = 'hash-maps') OR
    (c.slug = 'linked-lists'           AND p.slug = 'stacks') OR
    (c.slug = 'binary-search'          AND p.slug = 'sorting') OR
    (c.slug = 'recursion'              AND p.slug = 'two-pointers') OR
    (c.slug = 'recursion'              AND p.slug = 'linked-lists') OR
    (c.slug = 'recursion'              AND p.slug = 'binary-search') OR
    (c.slug = 'trees'                  AND p.slug = 'recursion') OR
    (c.slug = 'backtracking'           AND p.slug = 'recursion') OR
    (c.slug = 'tries'                  AND p.slug = 'trees') OR
    (c.slug = 'heaps'                  AND p.slug = 'trees') OR
    (c.slug = 'graphs'                 AND p.slug = 'backtracking') OR
    (c.slug = 'greedy'                 AND p.slug = 'heaps') OR
    (c.slug = 'greedy'                 AND p.slug = 'graphs') OR
    (c.slug = 'dynamic-programming'    AND p.slug = 'greedy') OR
    (c.slug = 'math-and-bits'          AND p.slug = 'dynamic-programming');

-- Assign existing 21 problems to categories
INSERT INTO roadmap_category_problems (category_id, problem_id, order_index)
SELECT rc.id, p.id, sub.ord FROM (VALUES
    -- Foundations
    ('foundations', 'fizzbuzz', 1),
    ('foundations', 'palindrome-number', 2),
    ('foundations', 'plus-one', 3),
    ('foundations', 'pascals-triangle', 4),
    -- Hash Maps
    ('hash-maps', 'two-sum', 1),
    ('hash-maps', 'group-anagrams', 2),
    -- Stacks
    ('stacks', 'valid-parentheses', 1),
    -- Sorting
    ('sorting', 'merge-intervals', 1),
    -- Two Pointers
    ('two-pointers', 'reverse-string', 1),
    ('two-pointers', 'reverse-words-in-a-string', 2),
    ('two-pointers', '3sum', 3),
    -- Linked Lists
    ('linked-lists', 'reverse-linked-list', 1),
    -- Binary Search
    ('binary-search', 'sqrtx', 1),
    -- Trees
    ('trees', 'invert-binary-tree', 1),
    ('trees', 'binary-tree-level-order-traversal', 2),
    -- Backtracking
    ('backtracking', 'permutations', 1),
    ('backtracking', 'subsets', 2),
    ('backtracking', 'combination-sum', 3),
    ('backtracking', 'n-queens', 4),
    -- Graphs
    ('graphs', 'clone-graph', 1),
    ('graphs', 'accounts-merge', 2)
) AS sub(cat_slug, prob_slug, ord)
JOIN roadmap_categories rc ON rc.slug = sub.cat_slug
JOIN problems p ON p.slug = sub.prob_slug;
