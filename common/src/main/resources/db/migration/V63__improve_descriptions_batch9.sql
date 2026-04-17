-- Improve descriptions: batch 9

------------------------------------------------------------
-- phone-combos (Phone Combos)
------------------------------------------------------------
UPDATE problems
SET description = 'Given a string containing digits from `2` to `9` inclusive, return all possible letter combinations that the number could represent. Return the answer in any order.

Each digit maps to a set of letters, just like on a telephone keypad:

- `2`: abc
- `3`: def
- `4`: ghi
- `5`: jkl
- `6`: mno
- `7`: pqrs
- `8`: tuv
- `9`: wxyz

Note that `1` does not map to any letters.

**Example 1:**
```
Input: digits = "23"
Output: ["ad","ae","af","bd","be","bf","cd","ce","cf"]
Explanation: Digit 2 maps to "abc" and digit 3 maps to "def". Every combination of one letter from each digit is included.
```

**Example 2:**
```
Input: digits = ""
Output: []
Explanation: An empty input has no letter combinations.
```

**Example 3:**
```
Input: digits = "2"
Output: ["a","b","c"]
```'
WHERE slug = 'phone-combos';

UPDATE problem_translations
SET description = 'Given a string containing digits from `2` to `9` inclusive, return all possible letter combinations that the number could represent. Return the answer in any order.

Each digit maps to a set of letters, just like on a telephone keypad:

- `2`: abc
- `3`: def
- `4`: ghi
- `5`: jkl
- `6`: mno
- `7`: pqrs
- `8`: tuv
- `9`: wxyz

Note that `1` does not map to any letters.

**Example 1:**
```
Input: digits = "23"
Output: ["ad","ae","af","bd","be","bf","cd","ce","cf"]
Explanation: Digit 2 maps to "abc" and digit 3 maps to "def". Every combination of one letter from each digit is included.
```

**Example 2:**
```
Input: digits = ""
Output: []
Explanation: An empty input has no letter combinations.
```

**Example 3:**
```
Input: digits = "2"
Output: ["a","b","c"]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'phone-combos') AND locale = 'en';

------------------------------------------------------------
-- pacific-atlantic (Pacific Atlantic)
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an `m x n` rectangular island that borders two oceans. The **Pacific Ocean** touches the island''s top and left edges, and the **Atlantic Ocean** touches the island''s right and bottom edges.

The island is represented as a grid of integer heights, where `heights[r][c]` is the elevation of the cell at row `r` and column `c`.

When it rains, water flows from a cell to any of its four neighbors (north, south, east, west) whose height is **less than or equal to** the current cell''s height. Water can also flow from any cell directly adjacent to an ocean into that ocean.

Return a list of all grid coordinates `[r, c]` from which rain water can reach **both** the Pacific and Atlantic oceans.

**Example 1:**
```
Input: heights = [[1,2,2,3,5],[3,2,3,4,4],[2,4,5,3,1],[6,7,1,4,5],[5,1,1,2,4]]
Output: [[0,4],[1,3],[1,4],[2,2],[3,0],[3,1],[4,0]]
Explanation: Water from cell [2,2] (height 5) can flow left and up to reach the Pacific, and right and down to reach the Atlantic.
```

**Example 2:**
```
Input: heights = [[1]]
Output: [[0,0]]
Explanation: A single cell borders both oceans.
```'
WHERE slug = 'pacific-atlantic';

UPDATE problem_translations
SET description = 'You are given an `m x n` rectangular island that borders two oceans. The **Pacific Ocean** touches the island''s top and left edges, and the **Atlantic Ocean** touches the island''s right and bottom edges.

The island is represented as a grid of integer heights, where `heights[r][c]` is the elevation of the cell at row `r` and column `c`.

When it rains, water flows from a cell to any of its four neighbors (north, south, east, west) whose height is **less than or equal to** the current cell''s height. Water can also flow from any cell directly adjacent to an ocean into that ocean.

Return a list of all grid coordinates `[r, c]` from which rain water can reach **both** the Pacific and Atlantic oceans.

**Example 1:**
```
Input: heights = [[1,2,2,3,5],[3,2,3,4,4],[2,4,5,3,1],[6,7,1,4,5],[5,1,1,2,4]]
Output: [[0,4],[1,3],[1,4],[2,2],[3,0],[3,1],[4,0]]
Explanation: Water from cell [2,2] (height 5) can flow left and up to reach the Pacific, and right and down to reach the Atlantic.
```

**Example 2:**
```
Input: heights = [[1]]
Output: [[0,0]]
Explanation: A single cell borders both oceans.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pacific-atlantic') AND locale = 'en';

------------------------------------------------------------
-- course-order (Course Order)
------------------------------------------------------------
UPDATE problems
SET description = 'There are `numCourses` courses labeled from `0` to `numCourses - 1`. You are given an array `prerequisites` where `prerequisites[i] = [a, b]` means you must complete course `b` before taking course `a`.

Return an ordering of courses that allows you to finish all of them. If there are multiple valid orderings, return any of them. If it is impossible to finish all courses (due to a cycle in the prerequisites), return an empty array.

**Example 1:**
```
Input: numCourses = 2, prerequisites = [[1,0]]
Output: [0,1]
Explanation: There are 2 courses to take. To take course 1 you should have finished course 0. So the correct order is [0,1].
```

**Example 2:**
```
Input: numCourses = 4, prerequisites = [[1,0],[2,0],[3,1],[3,2]]
Output: [0,1,2,3] or [0,2,1,3]
Explanation: Both orderings satisfy all prerequisites. Course 0 has no prerequisites, so it comes first. Course 3 depends on both 1 and 2.
```

**Example 3:**
```
Input: numCourses = 1, prerequisites = []
Output: [0]
```'
WHERE slug = 'course-order';

UPDATE problem_translations
SET description = 'There are `numCourses` courses labeled from `0` to `numCourses - 1`. You are given an array `prerequisites` where `prerequisites[i] = [a, b]` means you must complete course `b` before taking course `a`.

Return an ordering of courses that allows you to finish all of them. If there are multiple valid orderings, return any of them. If it is impossible to finish all courses (due to a cycle in the prerequisites), return an empty array.

**Example 1:**
```
Input: numCourses = 2, prerequisites = [[1,0]]
Output: [0,1]
Explanation: There are 2 courses to take. To take course 1 you should have finished course 0. So the correct order is [0,1].
```

**Example 2:**
```
Input: numCourses = 4, prerequisites = [[1,0],[2,0],[3,1],[3,2]]
Output: [0,1,2,3] or [0,2,1,3]
Explanation: Both orderings satisfy all prerequisites. Course 0 has no prerequisites, so it comes first. Course 3 depends on both 1 and 2.
```

**Example 3:**
```
Input: numCourses = 1, prerequisites = []
Output: [0]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'course-order') AND locale = 'en';

------------------------------------------------------------
-- connected-components (Connected Components)
------------------------------------------------------------
UPDATE problems
SET description = 'You have a graph with `n` nodes labeled from `0` to `n - 1`. You are given the integer `n` and an array `edges` where `edges[i] = [a, b]` represents an undirected edge between nodes `a` and `b`.

Return the number of **connected components** in the graph. A connected component is a group of nodes where every node can be reached from every other node in the group through some path.

**Example 1:**
```
Input: n = 5, edges = [[0,1],[1,2],[3,4]]
Output: 2
Explanation: Nodes 0, 1, and 2 form one component. Nodes 3 and 4 form another.
```

**Example 2:**
```
Input: n = 5, edges = [[0,1],[1,2],[2,3],[3,4]]
Output: 1
Explanation: All nodes are connected through a chain of edges, forming a single component.
```'
WHERE slug = 'connected-components';

UPDATE problem_translations
SET description = 'You have a graph with `n` nodes labeled from `0` to `n - 1`. You are given the integer `n` and an array `edges` where `edges[i] = [a, b]` represents an undirected edge between nodes `a` and `b`.

Return the number of **connected components** in the graph. A connected component is a group of nodes where every node can be reached from every other node in the group through some path.

**Example 1:**
```
Input: n = 5, edges = [[0,1],[1,2],[3,4]]
Output: 2
Explanation: Nodes 0, 1, and 2 form one component. Nodes 3 and 4 form another.
```

**Example 2:**
```
Input: n = 5, edges = [[0,1],[1,2],[2,3],[3,4]]
Output: 1
Explanation: All nodes are connected through a chain of edges, forming a single component.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'connected-components') AND locale = 'en';

------------------------------------------------------------
-- rotting-oranges (Rotting Oranges)
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an `m x n` grid where each cell contains one of three values:

- `0` represents an empty cell
- `1` represents a fresh orange
- `2` represents a rotten orange

Every minute, any fresh orange that is **4-directionally adjacent** (up, down, left, right) to a rotten orange becomes rotten.

Return the minimum number of minutes that must pass until no fresh orange remains. If it is impossible for all oranges to rot, return `-1`.

**Example 1:**
```
Input: grid = [[2,1,1],[1,1,0],[0,1,1]]
Output: 4
Explanation: The rot spreads outward from the top-left corner, reaching the bottom-right orange after 4 minutes.
```

**Example 2:**
```
Input: grid = [[2,1,1],[0,1,1],[1,0,1]]
Output: -1
Explanation: The orange in the bottom left corner is never reached.
```

**Example 3:**
```
Input: grid = [[0,2]]
Output: 0
Explanation: Since there are no fresh oranges, the answer is 0.
```'
WHERE slug = 'rotting-oranges';

UPDATE problem_translations
SET description = 'You are given an `m x n` grid where each cell contains one of three values:

- `0` represents an empty cell
- `1` represents a fresh orange
- `2` represents a rotten orange

Every minute, any fresh orange that is **4-directionally adjacent** (up, down, left, right) to a rotten orange becomes rotten.

Return the minimum number of minutes that must pass until no fresh orange remains. If it is impossible for all oranges to rot, return `-1`.

**Example 1:**
```
Input: grid = [[2,1,1],[1,1,0],[0,1,1]]
Output: 4
Explanation: The rot spreads outward from the top-left corner, reaching the bottom-right orange after 4 minutes.
```

**Example 2:**
```
Input: grid = [[2,1,1],[0,1,1],[1,0,1]]
Output: -1
Explanation: The orange in the bottom left corner is never reached.
```

**Example 3:**
```
Input: grid = [[0,2]]
Output: 0
Explanation: Since there are no fresh oranges, the answer is 0.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rotting-oranges') AND locale = 'en';

------------------------------------------------------------
-- account-merger (Account Merger)
------------------------------------------------------------
UPDATE problems
SET description = 'You are given a list of `accounts` where each element `accounts[i]` is a list of strings. The first element `accounts[i][0]` is the account holder''s name, and the remaining elements are email addresses associated with that account.

Your task is to merge accounts that belong to the same person. Two accounts belong to the same person if they share at least one common email address. Note that two accounts may have the same name but belong to different people.

After merging, return the accounts in the following format: the first element of each account is the name, and the remaining elements are the merged email addresses in **sorted order**. The accounts themselves can be returned in any order.

**Example 1:**
```
Input: accounts = [["John","johnsmith@mail.com","john_newyork@mail.com"],["John","johnsmith@mail.com","john00@mail.com"],["Mary","mary@mail.com"],["John","johnnybravo@mail.com"]]
Output: [["John","john00@mail.com","john_newyork@mail.com","johnsmith@mail.com"],["John","johnnybravo@mail.com"],["Mary","mary@mail.com"]]
Explanation: The first two "John" accounts share "johnsmith@mail.com", so their emails are merged. The third "John" has no overlap and remains separate.
```

**Example 2:**
```
Input: accounts = [["Gabe","Gabe0@m.co","Gabe3@m.co","Gabe1@m.co"],["Kevin","Kevin3@m.co","Kevin5@m.co","Kevin0@m.co"],["Ethan","Ethan5@m.co","Ethan4@m.co","Ethan0@m.co"],["Hanzo","Hanzo3@m.co","Hanzo1@m.co","Hanzo0@m.co"],["Fern","Fern5@m.co","Fern1@m.co","Fern0@m.co"]]
Output: [["Ethan","Ethan0@m.co","Ethan4@m.co","Ethan5@m.co"],["Fern","Fern0@m.co","Fern1@m.co","Fern5@m.co"],["Gabe","Gabe0@m.co","Gabe1@m.co","Gabe3@m.co"],["Hanzo","Hanzo0@m.co","Hanzo1@m.co","Hanzo3@m.co"],["Kevin","Kevin0@m.co","Kevin3@m.co","Kevin5@m.co"]]
Explanation: No accounts share email addresses, so each account''s emails are simply sorted.
```'
WHERE slug = 'account-merger';

UPDATE problem_translations
SET description = 'You are given a list of `accounts` where each element `accounts[i]` is a list of strings. The first element `accounts[i][0]` is the account holder''s name, and the remaining elements are email addresses associated with that account.

Your task is to merge accounts that belong to the same person. Two accounts belong to the same person if they share at least one common email address. Note that two accounts may have the same name but belong to different people.

After merging, return the accounts in the following format: the first element of each account is the name, and the remaining elements are the merged email addresses in **sorted order**. The accounts themselves can be returned in any order.

**Example 1:**
```
Input: accounts = [["John","johnsmith@mail.com","john_newyork@mail.com"],["John","johnsmith@mail.com","john00@mail.com"],["Mary","mary@mail.com"],["John","johnnybravo@mail.com"]]
Output: [["John","john00@mail.com","john_newyork@mail.com","johnsmith@mail.com"],["John","johnnybravo@mail.com"],["Mary","mary@mail.com"]]
Explanation: The first two "John" accounts share "johnsmith@mail.com", so their emails are merged. The third "John" has no overlap and remains separate.
```

**Example 2:**
```
Input: accounts = [["Gabe","Gabe0@m.co","Gabe3@m.co","Gabe1@m.co"],["Kevin","Kevin3@m.co","Kevin5@m.co","Kevin0@m.co"],["Ethan","Ethan5@m.co","Ethan4@m.co","Ethan0@m.co"],["Hanzo","Hanzo3@m.co","Hanzo1@m.co","Hanzo0@m.co"],["Fern","Fern5@m.co","Fern1@m.co","Fern0@m.co"]]
Output: [["Ethan","Ethan0@m.co","Ethan4@m.co","Ethan5@m.co"],["Fern","Fern0@m.co","Fern1@m.co","Fern5@m.co"],["Gabe","Gabe0@m.co","Gabe1@m.co","Gabe3@m.co"],["Hanzo","Hanzo0@m.co","Hanzo1@m.co","Hanzo3@m.co"],["Kevin","Kevin0@m.co","Kevin3@m.co","Kevin5@m.co"]]
Explanation: No accounts share email addresses, so each account''s emails are simply sorted.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'account-merger') AND locale = 'en';

------------------------------------------------------------
-- house-thief-ii (Circular Thief / House Thief II)
------------------------------------------------------------
UPDATE problems
SET description = 'You are a robber planning to rob houses along a street. Each house has a certain amount of money stashed. The houses are **arranged in a circle**, meaning the first house and the last house are neighbors.

Adjacent houses are connected to a security system that will alert the police if **two adjacent houses** are robbed on the same night.

Given an integer array `nums` where `nums[i]` is the amount of money in the `i`-th house, return the maximum amount you can rob tonight without triggering the alarm.

**Example 1:**
```
Input: nums = [2,3,2]
Output: 3
Explanation: You cannot rob house 1 (money = 2) and then rob house 3 (money = 2), because they are adjacent houses.
```

**Example 2:**
```
Input: nums = [1,2,3,1]
Output: 4
Explanation: Rob house 1 (money = 1) and then rob house 3 (money = 3). Total = 1 + 3 = 4.
```

**Example 3:**
```
Input: nums = [1,2,3]
Output: 3
```'
WHERE slug = 'house-thief-ii';

UPDATE problem_translations
SET description = 'You are a robber planning to rob houses along a street. Each house has a certain amount of money stashed. The houses are **arranged in a circle**, meaning the first house and the last house are neighbors.

Adjacent houses are connected to a security system that will alert the police if **two adjacent houses** are robbed on the same night.

Given an integer array `nums` where `nums[i]` is the amount of money in the `i`-th house, return the maximum amount you can rob tonight without triggering the alarm.

**Example 1:**
```
Input: nums = [2,3,2]
Output: 3
Explanation: You cannot rob house 1 (money = 2) and then rob house 3 (money = 2), because they are adjacent houses.
```

**Example 2:**
```
Input: nums = [1,2,3,1]
Output: 4
Explanation: Rob house 1 (money = 1) and then rob house 3 (money = 3). Total = 1 + 3 = 4.
```

**Example 3:**
```
Input: nums = [1,2,3]
Output: 3
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'house-thief-ii') AND locale = 'en';

------------------------------------------------------------
-- decode-ways (Message Decoder / Decode Ways)
------------------------------------------------------------
UPDATE problems
SET description = 'A message containing letters from `A` to `Z` can be encoded into numbers using the following mapping:

```
''A'' -> "1"
''B'' -> "2"
...
''Z'' -> "26"
```

To decode an encoded message, all digits must be grouped and then mapped back into letters using the reverse of the mapping above. There may be multiple valid ways to group the digits.

Given a string `s` containing only digits, return the **number of ways** to decode it. The answer is guaranteed to fit in a 32-bit integer.

Note that groupings that produce numbers with leading zeros (like `"06"`) are invalid, since `"06"` does not map to any letter.

**Example 1:**
```
Input: s = "12"
Output: 2
Explanation: "12" could be decoded as "AB" (1 2) or "L" (12).
```

**Example 2:**
```
Input: s = "226"
Output: 3
Explanation: "226" could be decoded as "BZ" (2 26), "VF" (22 6), or "BBF" (2 2 6).
```

**Example 3:**
```
Input: s = "06"
Output: 0
Explanation: "06" cannot be mapped to "F" because of the leading zero.
```'
WHERE slug = 'decode-ways';

UPDATE problem_translations
SET description = 'A message containing letters from `A` to `Z` can be encoded into numbers using the following mapping:

```
''A'' -> "1"
''B'' -> "2"
...
''Z'' -> "26"
```

To decode an encoded message, all digits must be grouped and then mapped back into letters using the reverse of the mapping above. There may be multiple valid ways to group the digits.

Given a string `s` containing only digits, return the **number of ways** to decode it. The answer is guaranteed to fit in a 32-bit integer.

Note that groupings that produce numbers with leading zeros (like `"06"`) are invalid, since `"06"` does not map to any letter.

**Example 1:**
```
Input: s = "12"
Output: 2
Explanation: "12" could be decoded as "AB" (1 2) or "L" (12).
```

**Example 2:**
```
Input: s = "226"
Output: 3
Explanation: "226" could be decoded as "BZ" (2 26), "VF" (22 6), or "BBF" (2 2 6).
```

**Example 3:**
```
Input: s = "06"
Output: 0
Explanation: "06" cannot be mapped to "F" because of the leading zero.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'decode-ways') AND locale = 'en';

------------------------------------------------------------
-- max-product-subarray (Max Product Subarray)
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums`, find the contiguous subarray (containing at least one element) that has the largest product, and return that product.

A **subarray** is a contiguous sequence of elements within the array. The array may contain positive numbers, negative numbers, and zeros.

**Example 1:**
```
Input: nums = [2,3,-2,4]
Output: 6
Explanation: The subarray [2,3] has the largest product 6.
```

**Example 2:**
```
Input: nums = [-2,0,-1]
Output: 0
Explanation: The result cannot be 2 because [-2,-1] is not a contiguous subarray. The best subarray is [0] with product 0.
```'
WHERE slug = 'max-product-subarray';

UPDATE problem_translations
SET description = 'Given an integer array `nums`, find the contiguous subarray (containing at least one element) that has the largest product, and return that product.

A **subarray** is a contiguous sequence of elements within the array. The array may contain positive numbers, negative numbers, and zeros.

**Example 1:**
```
Input: nums = [2,3,-2,4]
Output: 6
Explanation: The subarray [2,3] has the largest product 6.
```

**Example 2:**
```
Input: nums = [-2,0,-1]
Output: 0
Explanation: The result cannot be 2 because [-2,-1] is not a contiguous subarray. The best subarray is [0] with product 0.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'max-product-subarray') AND locale = 'en';

------------------------------------------------------------
-- palindrome-count (Palindrome Count)
------------------------------------------------------------
UPDATE problems
SET description = 'Given a string `s`, return the number of **palindromic substrings** in it.

A **palindrome** is a string that reads the same forward and backward. A **substring** is a contiguous sequence of characters within the string. Note that single characters are always palindromes, and identical substrings at different positions are counted separately.

**Example 1:**
```
Input: s = "abc"
Output: 3
Explanation: The three palindromic substrings are: "a", "b", "c".
```

**Example 2:**
```
Input: s = "aaa"
Output: 6
Explanation: The six palindromic substrings are: "a" (3 times), "aa" (2 times), and "aaa" (1 time).
```'
WHERE slug = 'palindrome-count';

UPDATE problem_translations
SET description = 'Given a string `s`, return the number of **palindromic substrings** in it.

A **palindrome** is a string that reads the same forward and backward. A **substring** is a contiguous sequence of characters within the string. Note that single characters are always palindromes, and identical substrings at different positions are counted separately.

**Example 1:**
```
Input: s = "abc"
Output: 3
Explanation: The three palindromic substrings are: "a", "b", "c".
```

**Example 2:**
```
Input: s = "aaa"
Output: 6
Explanation: The six palindromic substrings are: "a" (3 times), "aa" (2 times), and "aaa" (1 time).
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'palindrome-count') AND locale = 'en';
