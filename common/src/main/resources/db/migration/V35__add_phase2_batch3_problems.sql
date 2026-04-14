-- Phase 2 Batch 3: 8 problems — Trees (5) + Tries (3)

------------------------------------------------------------
-- TREES
------------------------------------------------------------

-- Kth Smallest BST (Kth Smallest Element in a BST)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Kth Smallest BST',
    'kth-smallest-bst',
    'Given the `root` of a binary search tree, and an integer `k`, return the `k`-th smallest value (1-indexed) of all the values of the nodes in the tree.

**Example 1:**
```
Input: root = [3,1,4,null,2], k = 1
Output: 1
```

**Example 2:**
```
Input: root = [5,3,6,2,4,null,null,1], k = 3
Output: 3
```',
    'MEDIUM',
    'The number of nodes in the tree is n.
1 <= k <= n <= 10^4
0 <= Node.val <= 10^4',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'kth-smallest-bst'), '[3,1,4,null,2]
1', '1', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'kth-smallest-bst'), '[5,3,6,2,4,null,null,1]
3', '3', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'kth-smallest-bst'), '[1]
1', '1', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'kth-smallest-bst'), '[2,1,3]
2', '2', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'kth-smallest-bst'), '[3,1,4,null,2]
4', '4', FALSE, 5);

-- Build Tree (Construct Binary Tree from Preorder and Inorder)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Build Tree',
    'build-tree',
    'Given two integer arrays `preorder` and `inorder` where `preorder` is the preorder traversal of a binary tree and `inorder` is the inorder traversal of the same tree, construct and return the binary tree.

**Example 1:**
```
Input: preorder = [3,9,20,15,7], inorder = [9,3,15,20,7]
Output: [3,9,20,null,null,15,7]
```

**Example 2:**
```
Input: preorder = [-1], inorder = [-1]
Output: [-1]
```',
    'MEDIUM',
    '1 <= preorder.length <= 3000
inorder.length == preorder.length
-3000 <= preorder[i], inorder[i] <= 3000
preorder and inorder consist of unique values.
Each value of inorder also appears in preorder.
preorder is guaranteed to be the preorder traversal of the tree.
inorder is guaranteed to be the inorder traversal of the tree.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'build-tree'), '[3,9,20,15,7]
[9,3,15,20,7]', '[3,9,20,null,null,15,7]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'build-tree'), '[-1]
[-1]', '[-1]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'build-tree'), '[1,2]
[2,1]', '[1,2]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'build-tree'), '[1,2,3]
[2,1,3]', '[1,2,3]', FALSE, 4);

-- Right Side View (Binary Tree Right Side View)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Right Side View',
    'right-side-view',
    'Given the `root` of a binary tree, imagine yourself standing on the right side of it. Return the values of the nodes you can see ordered from top to bottom.

**Example 1:**
```
Input: root = [1,2,3,null,5,null,4]
Output: [1,3,4]
```

**Example 2:**
```
Input: root = [1,null,3]
Output: [1,3]
```

**Example 3:**
```
Input: root = []
Output: []
```',
    'MEDIUM',
    'The number of nodes in the tree is in the range [0, 100].
-100 <= Node.val <= 100',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'right-side-view'), '[1,2,3,null,5,null,4]', '[1,3,4]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'right-side-view'), '[1,null,3]', '[1,3]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'right-side-view'), '[]', '[]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'right-side-view'), '[1,2,3,4]', '[1,3,4]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'right-side-view'), '[1]', '[1]', FALSE, 5);

-- Tree Diameter (Diameter of Binary Tree)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Tree Diameter',
    'tree-diameter',
    'Given the `root` of a binary tree, return the length of the **diameter** of the tree.

The diameter of a binary tree is the **length** of the longest path between any two nodes in a tree. This path may or may not pass through the root.

The length of a path between two nodes is represented by the number of edges between them.

**Example 1:**
```
Input: root = [1,2,3,4,5]
Output: 3
Explanation: 3 is the length of the path [4,2,1,3] or [5,2,1,3].
```

**Example 2:**
```
Input: root = [1,2]
Output: 1
```',
    'EASY',
    'The number of nodes in the tree is in the range [1, 10^4].
-100 <= Node.val <= 100',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'tree-diameter'), '[1,2,3,4,5]', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'tree-diameter'), '[1,2]', '1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'tree-diameter'), '[1]', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'tree-diameter'), '[1,2,3,null,null,4,5]', '3', FALSE, 4);

-- Max Path Sum (Binary Tree Maximum Path Sum)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Max Path Sum',
    'max-path-sum',
    'A **path** in a binary tree is a sequence of nodes where each pair of adjacent nodes in the sequence has an edge connecting them. A node can only appear in the sequence **at most once**. Note that the path does not need to pass through the root.

The **path sum** of a path is the sum of the node values in the path.

Given the `root` of a binary tree, return the maximum **path sum** of any non-empty path.

**Example 1:**
```
Input: root = [1,2,3]
Output: 6
Explanation: The optimal path is 2 -> 1 -> 3 with a path sum of 2 + 1 + 3 = 6.
```

**Example 2:**
```
Input: root = [-10,9,20,null,null,15,7]
Output: 42
Explanation: The optimal path is 15 -> 20 -> 7 with a path sum of 15 + 20 + 7 = 42.
```',
    'HARD',
    'The number of nodes in the tree is in the range [1, 3 * 10^4].
-1000 <= Node.val <= 1000',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'max-path-sum'), '[1,2,3]', '6', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'max-path-sum'), '[-10,9,20,null,null,15,7]', '42', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'max-path-sum'), '[2,-1]', '2', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'max-path-sum'), '[-3]', '-3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'max-path-sum'), '[5,4,8,11,null,13,4,7,2,null,null,null,1]', '48', FALSE, 5);

------------------------------------------------------------
-- TRIES
------------------------------------------------------------

-- Prefix Tree (Implement Trie)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Prefix Tree',
    'prefix-tree',
    'A **trie** (pronounced "try") or **prefix tree** is a tree data structure used to efficiently store and retrieve keys in a dataset of strings.

Implement the `Trie` class:

- `Trie()` Initializes the trie object.
- `void insert(String word)` Inserts the string `word` into the trie.
- `boolean search(String word)` Returns `true` if the string `word` is in the trie, and `false` otherwise.
- `boolean startsWith(String prefix)` Returns `true` if there is a previously inserted string that has the prefix `prefix`, and `false` otherwise.

**Example 1:**
```
Input:
["Trie", "insert", "search", "search", "startsWith", "insert", "search"]
[[], ["apple"], ["apple"], ["app"], ["app"], ["app"], ["app"]]
Output: [null, null, true, false, true, null, true]
```',
    'MEDIUM',
    '1 <= word.length, prefix.length <= 2000
word and prefix consist only of lowercase English letters.
At most 3 * 10^4 calls in total will be made to insert, search, and startsWith.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'prefix-tree'), '["Trie","insert","search","search","startsWith","insert","search"]
[[],["apple"],["apple"],["app"],["app"],["app"],["app"]]', '[null,null,true,false,true,null,true]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'prefix-tree'), '["Trie","insert","insert","search","startsWith","search"]
[[],["hello"],["help"],["hello"],["hel"],["help"]]', '[null,null,null,true,true,true]', FALSE, 2),
    ((SELECT id FROM problems WHERE slug = 'prefix-tree'), '["Trie","search","insert","search"]
[[],["a"],["a"],["a"]]', '[null,false,null,true]', FALSE, 3);

-- Word Dictionary (Design Add and Search Words Data Structure)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Word Dictionary',
    'word-dictionary',
    'Design a data structure that supports adding new words and finding if a string matches any previously added string.

Implement the `WordDictionary` class:

- `WordDictionary()` Initializes the object.
- `void addWord(word)` Adds `word` to the data structure, it can be matched later.
- `bool search(word)` Returns `true` if there is any string in the data structure that matches `word` or `false` otherwise. `word` may contain dots `''.''` where dots can be matched with any letter.

**Example:**
```
Input:
["WordDictionary","addWord","addWord","addWord","search","search","search","search"]
[[],["bad"],["dad"],["mad"],["pad"],["bad"],[".ad"],["b.."]]
Output: [null,null,null,null,false,true,true,true]
```',
    'MEDIUM',
    '1 <= word.length <= 25
word in addWord consists of lowercase English letters.
word in search consist of ''.'' or lowercase English letters.
At most 10^4 calls will be made to addWord and search.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'word-dictionary'), '["WordDictionary","addWord","addWord","addWord","search","search","search","search"]
[[],["bad"],["dad"],["mad"],["pad"],["bad"],[".ad"],["b.."]]', '[null,null,null,null,false,true,true,true]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'word-dictionary'), '["WordDictionary","addWord","search","search"]
[[],["a"],["a"],["."]]', '[null,null,true,true]', FALSE, 2),
    ((SELECT id FROM problems WHERE slug = 'word-dictionary'), '["WordDictionary","addWord","addWord","search","search","search"]
[[],["at"],["and"],["a"],["an"],["a."]]', '[null,null,null,false,false,true]', FALSE, 3);

-- Word Finder (Word Search II)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Word Finder',
    'word-finder',
    'Given an `m x n` grid of characters `board` and a list of strings `words`, return all words on the board.

Each word must be constructed from letters of sequentially adjacent cells, where adjacent cells are horizontally or vertically neighboring. The same letter cell may not be used more than once in a word.

**Example 1:**
```
Input: board = [["o","a","a","n"],["e","t","a","e"],["i","h","k","r"],["i","f","l","v"]], words = ["oath","pea","eat","rain"]
Output: ["eat","oath"]
```

**Example 2:**
```
Input: board = [["a","b"],["c","d"]], words = ["abcb"]
Output: []
```',
    'HARD',
    'm == board.length
n == board[i].length
1 <= m, n <= 12
board[i][j] is a lowercase English letter.
1 <= words.length <= 3 * 10^4
1 <= words[i].length <= 10
words[i] consists of lowercase English letters.
All the strings of words are unique.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'word-finder'), '[["o","a","a","n"],["e","t","a","e"],["i","h","k","r"],["i","f","l","v"]]
["oath","pea","eat","rain"]', '["eat","oath"]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'word-finder'), '[["a","b"],["c","d"]]
["abcb"]', '[]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'word-finder'), '[["a"]]
["a"]', '["a"]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'word-finder'), '[["a","b"],["c","d"]]
["ab","cb","ad","bd","ac","ca","da","bc","db","adcb","dabc","abb","acb"]', '["ab","ac","bd","ca","da","db"]', FALSE, 4);

------------------------------------------------------------
-- ENGLISH TRANSLATIONS
------------------------------------------------------------

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems
WHERE slug IN (
    'kth-smallest-bst', 'build-tree', 'right-side-view', 'tree-diameter', 'max-path-sum',
    'prefix-tree', 'word-dictionary', 'word-finder'
);
