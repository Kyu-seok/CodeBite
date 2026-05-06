-- V152: Restore canonical English descriptions for the 13 over-themed
-- problems renamed in V151. The casual rebrand from V133/V135 (snack-mix
-- bags, drink labels, guild siblings, trail-mix combos, etc.) is replaced
-- with the canonical setup using canonical parameter names that match the
-- renamed method signatures. Prose is fresh — not paraphrased from
-- LeetCode/NeetCode. Korean translations are refreshed in V153.

-- valid-anagram
UPDATE problems SET
    description = $$Two strings are *anagrams* of each other when one can be rearranged into the other — i.e. they use the exact same letters with the exact same counts.

Given two lowercase strings `s` and `t`, return `true` if `t` is an anagram of `s`, and `false` otherwise. Strings of different length are never anagrams.

**Example 1:**
```
Input: s = "anagram", t = "nagaram"
Output: true
```

**Example 2:**
```
Input: s = "rat", t = "car"
Output: false
Explanation: 'a' and 't' appear in `s` but not in `t`, so the letter multisets differ.
```$$
WHERE slug = $$valid-anagram$$;

-- group-anagrams
UPDATE problems SET
    description = $$Given an array of lowercase strings `strs`, group together every set of strings that are anagrams of one another. Two strings are anagrams when one can be rearranged into the other (same letters, same counts).

Return the groups as a list of lists. Order of groups, and order within each group, does not matter.

**Example 1:**
```
Input: strs = ["eat","tea","tan","ate","nat","bat"]
Output: [["bat"],["nat","tan"],["ate","eat","tea"]]
```

**Example 2:**
```
Input: strs = [""]
Output: [[""]]
```

**Example 3:**
```
Input: strs = ["a"]
Output: [["a"]]
```$$
WHERE slug = $$group-anagrams$$;

-- lca-bst
UPDATE problems SET
    description = $$Given the `root` of a binary search tree and two nodes `p` and `q` that both exist in the tree, return the lowest common ancestor (LCA) of `p` and `q`.

The LCA is the deepest node that has both `p` and `q` as descendants — and a node is allowed to be a descendant of itself. Because the tree is a BST, you can walk down from the root and decide at each step which subtree contains both nodes.

**Example 1:**
```
Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 8
Output: 6
Explanation: 2 and 8 split at the root, so the LCA is 6.
```

**Example 2:**
```
Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 4
Output: 2
Explanation: 4 is in the subtree rooted at 2, and a node can be its own descendant.
```$$
WHERE slug = $$lca-bst$$;

-- populating-next-pointers
UPDATE problems SET
    description = $$You are given the `root` of a **perfect** binary tree where every parent has two children and every leaf sits at the same depth. Each node has fields `val`, `left`, `right`, and `next`. Initially every `next` pointer is null.

Set every `next` pointer to point to the node immediately to its right on the same level. If no such node exists (the rightmost on its level), leave `next` as null. Return the modified `root`.

**Example 1:**
```
Input: root = [1,2,3,4,5,6,7]
Output: [1,#,2,3,#,4,5,6,7,#]
Explanation: The "#" markers separate levels in the level-order serialization with next pointers attached. 1 has no right neighbor; 2 → 3, 4 → 5 → 6 → 7.
```

**Example 2:**
```
Input: root = []
Output: []
```$$
WHERE slug = $$populating-next-pointers$$;

-- sum-root-to-leaf
UPDATE problems SET
    description = $$The root-to-leaf path of a binary tree spells a non-negative integer when its node values are read top to bottom (each node holds a single digit `0`–`9`). For example, the path `4 → 9 → 5` spells `495`.

Given the `root`, sum the integers spelled by every root-to-leaf path. The tree has at most a few thousand nodes and the sum fits in a 32-bit integer.

**Example 1:**
```
Input: root = [1,2,3]
Output: 25
Explanation: Paths 1→2 and 1→3 spell 12 and 13. 12 + 13 = 25.
```

**Example 2:**
```
Input: root = [4,9,0,5,1]
Output: 1026
Explanation: Paths spell 495, 491, and 40. Sum = 1026.
```$$
WHERE slug = $$sum-root-to-leaf$$;

-- lca-binary-tree
UPDATE problems SET
    description = $$Given the `root` of a binary tree (not necessarily a BST) and two nodes `p` and `q` that both exist in the tree, return the lowest common ancestor (LCA) of `p` and `q`.

The LCA is the deepest node that has both `p` and `q` in its subtree — and a node may be its own descendant. All node values are unique.

**Example 1:**
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1
Output: 3
Explanation: 5 and 1 belong to different subtrees of 3, so 3 is the deepest node that contains both.
```

**Example 2:**
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4
Output: 5
Explanation: 4 lives inside the subtree rooted at 5, and a node can be a descendant of itself.
```$$
WHERE slug = $$lca-binary-tree$$;

-- subsets-ii
UPDATE problems SET
    description = $$Given an integer array `nums` that may contain duplicates, return **all** possible subsets (the power set) of `nums` — but the result itself must not contain duplicate subsets.

Order of subsets, and order within each subset, does not matter.

**Example 1:**
```
Input: nums = [1,2,2]
Output: [[],[1],[1,2],[1,2,2],[2],[2,2]]
```

**Example 2:**
```
Input: nums = [0]
Output: [[],[0]]
```$$
WHERE slug = $$subsets-ii$$;

-- graph-valid-tree
UPDATE problems SET
    description = $$You're given an integer `n` (the number of nodes, labelled `0..n-1`) and an array `edges` where each `edges[i] = [u, v]` is an undirected edge between nodes `u` and `v`. Decide whether `(n, edges)` forms a valid tree.

A valid tree is **connected** (every node reachable from every other), **acyclic** (no cycles), and has exactly `n - 1` edges.

**Example 1:**
```
Input: n = 5, edges = [[0,1],[0,2],[0,3],[1,4]]
Output: true
```

**Example 2:**
```
Input: n = 5, edges = [[0,1],[1,2],[2,3],[1,3],[1,4]]
Output: false
Explanation: The edges 1-2, 2-3, 1-3 form a cycle.
```$$
WHERE slug = $$graph-valid-tree$$;

-- reverse-linked-list
UPDATE problems SET
    description = $$Given the `head` of a singly linked list, reverse the list and return its new head. The reversal must rewire the existing nodes in place — do not allocate a fresh list.

**Example 1:**
```
Input: head = [1,2,3,4,5]
Output: [5,4,3,2,1]
```

**Example 2:**
```
Input: head = [1,2]
Output: [2,1]
```

**Example 3:**
```
Input: head = []
Output: []
```$$
WHERE slug = $$reverse-linked-list$$;

-- binary-tree-level-order
UPDATE problems SET
    description = $$Given the `root` of a binary tree, return its level-order traversal: a list where the i-th entry contains all node values at depth `i`, read left to right.

An empty tree returns an empty list.

**Example 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: [[3],[9,20],[15,7]]
```

**Example 2:**
```
Input: root = [1]
Output: [[1]]
```

**Example 3:**
```
Input: root = []
Output: []
```$$
WHERE slug = $$binary-tree-level-order$$;

-- binary-tree-codec
UPDATE problems SET
    description = $$Design a `Codec` class with two methods:

- `String serialize(TreeNode root)` — convert a binary tree to a string.
- `TreeNode deserialize(String data)` — reconstruct a tree from such a string.

The serialization format is up to you. The judge calls `deserialize(serialize(root))` on each input tree and checks that the resulting tree is structurally identical to the original.

Node values may be any 32-bit integer. The tree may be empty (`root = null`).

**Example 1:**
```
Input: root = [1,2,3,null,null,4,5]
Output: [1,2,3,null,null,4,5]
Explanation: The exact serialized string can differ; only the round-trip tree must match.
```

**Example 2:**
```
Input: root = []
Output: []
```$$
WHERE slug = $$binary-tree-codec$$;

-- walls-and-gates
UPDATE problems SET
    description = $$You're given an `m × n` grid `rooms`, where each cell is one of:
- `-1` — a **wall** that blocks movement.
- `0` — a **gate**.
- `2147483647` (i.e. INT_MAX) — an **empty room**.

Mutate `rooms` **in place** so each empty room contains the distance, in steps (up/down/left/right), to its nearest gate. Empty rooms with no reachable gate stay at `2147483647`.

**Example 1:**
```
Input: rooms = [[2147483647,-1,0,2147483647],[2147483647,2147483647,2147483647,-1],[2147483647,-1,2147483647,-1],[0,-1,2147483647,2147483647]]
Output: [[3,-1,0,1],[2,2,1,-1],[1,-1,2,-1],[0,-1,3,4]]
```

**Example 2:**
```
Input: rooms = [[-1]]
Output: [[-1]]
```$$
WHERE slug = $$walls-and-gates$$;

-- longest-palindromic-substring
-- NOTE: This is a length-only variant of LC #5. Return the length of the
-- longest palindromic substring, not the substring itself, to match the
-- existing `int longestPalindrome(s)` signature and stored test cases.
UPDATE problems SET
    description = $$Given a string `s`, return the **length** of the longest palindromic substring of `s`. A palindromic substring reads the same forward and backward.

**Example 1:**
```
Input: s = "babad"
Output: 3
Explanation: "bab" and "aba" are both palindromic substrings of length 3.
```

**Example 2:**
```
Input: s = "cbbd"
Output: 2
Explanation: "bb" has length 2; no longer palindromic substring exists.
```

**Example 3:**
```
Input: s = "a"
Output: 1
```$$
WHERE slug = $$longest-palindromic-substring$$;
