-- Improve descriptions: batch 1
-- Slugs: pair-sum, find-duplicates, anagram-check, anagram-groups,
--         k-most-frequent, array-product, longest-streak, string-codec,
--         sudoku-validator, palindrome-checker

------------------------------------------------------------
-- pair-sum
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of integers `nums` and an integer `target`, return the indices of the two numbers that add up to `target`.

Each input has exactly one solution, and you may not use the same element twice. You can return the answer in any order.

**Example 1:**
```
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
```

**Example 2:**
```
Input: nums = [3,2,4], target = 6
Output: [1,2]
```'
WHERE slug = 'pair-sum';

UPDATE problem_translations
SET description = 'Given an array of integers `nums` and an integer `target`, return the indices of the two numbers that add up to `target`.

Each input has exactly one solution, and you may not use the same element twice. You can return the answer in any order.

**Example 1:**
```
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
```

**Example 2:**
```
Input: nums = [3,2,4], target = 6
Output: [1,2]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pair-sum')
  AND locale = 'en';

------------------------------------------------------------
-- find-duplicates
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums`, return `true` if any value appears at least twice in the array. Return `false` if every element is distinct.

**Example 1:**
```
Input: nums = [1,2,3,1]
Output: true
Explanation: The element 1 appears at index 0 and 3.
```

**Example 2:**
```
Input: nums = [1,2,3,4]
Output: false
Explanation: All elements are distinct.
```

**Example 3:**
```
Input: nums = [1,1,1,3,3,4,3,2,4,2]
Output: true
```'
WHERE slug = 'find-duplicates';

UPDATE problem_translations
SET description = 'Given an integer array `nums`, return `true` if any value appears at least twice in the array. Return `false` if every element is distinct.

**Example 1:**
```
Input: nums = [1,2,3,1]
Output: true
Explanation: The element 1 appears at index 0 and 3.
```

**Example 2:**
```
Input: nums = [1,2,3,4]
Output: false
Explanation: All elements are distinct.
```

**Example 3:**
```
Input: nums = [1,1,1,3,3,4,3,2,4,2]
Output: true
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'find-duplicates')
  AND locale = 'en';

------------------------------------------------------------
-- anagram-check
------------------------------------------------------------
UPDATE problems
SET description = 'Given two strings `s` and `t`, return `true` if `t` is an anagram of `s`, and `false` otherwise.

An **anagram** is a word formed by rearranging the letters of another word, using all the original letters exactly once.

**Example 1:**
```
Input: s = "anagram", t = "nagaram"
Output: true
```

**Example 2:**
```
Input: s = "rat", t = "car"
Output: false
```'
WHERE slug = 'anagram-check';

UPDATE problem_translations
SET description = 'Given two strings `s` and `t`, return `true` if `t` is an anagram of `s`, and `false` otherwise.

An **anagram** is a word formed by rearranging the letters of another word, using all the original letters exactly once.

**Example 1:**
```
Input: s = "anagram", t = "nagaram"
Output: true
```

**Example 2:**
```
Input: s = "rat", t = "car"
Output: false
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'anagram-check')
  AND locale = 'en';

------------------------------------------------------------
-- anagram-groups
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of strings `strs`, group the strings that are anagrams of each other. You can return the groups in any order.

An **anagram** is a word formed by rearranging the letters of another word, using all the original letters exactly once.

**Example 1:**
```
Input: strs = ["eat","tea","tan","ate","nat","bat"]
Output: [["ate","eat","tea"],["bat"],["nat","tan"]]
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
```'
WHERE slug = 'anagram-groups';

UPDATE problem_translations
SET description = 'Given an array of strings `strs`, group the strings that are anagrams of each other. You can return the groups in any order.

An **anagram** is a word formed by rearranging the letters of another word, using all the original letters exactly once.

**Example 1:**
```
Input: strs = ["eat","tea","tan","ate","nat","bat"]
Output: [["ate","eat","tea"],["bat"],["nat","tan"]]
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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'anagram-groups')
  AND locale = 'en';

------------------------------------------------------------
-- k-most-frequent
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums` and an integer `k`, return the `k` most frequent elements. You may return the answer in any order.

It is guaranteed that the answer is unique.

**Example 1:**
```
Input: nums = [1,1,1,2,2,3], k = 2
Output: [1,2]
Explanation: The two most frequent elements are 1 (appears 3 times) and 2 (appears 2 times).
```

**Example 2:**
```
Input: nums = [1], k = 1
Output: [1]
```'
WHERE slug = 'k-most-frequent';

UPDATE problem_translations
SET description = 'Given an integer array `nums` and an integer `k`, return the `k` most frequent elements. You may return the answer in any order.

It is guaranteed that the answer is unique.

**Example 1:**
```
Input: nums = [1,1,1,2,2,3], k = 2
Output: [1,2]
Explanation: The two most frequent elements are 1 (appears 3 times) and 2 (appears 2 times).
```

**Example 2:**
```
Input: nums = [1], k = 1
Output: [1]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'k-most-frequent')
  AND locale = 'en';

------------------------------------------------------------
-- array-product
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums`, return an array `answer` where `answer[i]` is equal to the product of all elements in `nums` except `nums[i]`.

The product of any prefix or suffix of `nums` is guaranteed to fit in a 32-bit integer.

You must solve this in O(n) time without using the division operation.

**Example 1:**
```
Input: nums = [1,2,3,4]
Output: [24,12,8,6]
Explanation: For index 0: 2 * 3 * 4 = 24, for index 1: 1 * 3 * 4 = 12, and so on.
```

**Example 2:**
```
Input: nums = [-1,1,0,-3,3]
Output: [0,0,9,0,0]
```'
WHERE slug = 'array-product';

UPDATE problem_translations
SET description = 'Given an integer array `nums`, return an array `answer` where `answer[i]` is equal to the product of all elements in `nums` except `nums[i]`.

The product of any prefix or suffix of `nums` is guaranteed to fit in a 32-bit integer.

You must solve this in O(n) time without using the division operation.

**Example 1:**
```
Input: nums = [1,2,3,4]
Output: [24,12,8,6]
Explanation: For index 0: 2 * 3 * 4 = 24, for index 1: 1 * 3 * 4 = 12, and so on.
```

**Example 2:**
```
Input: nums = [-1,1,0,-3,3]
Output: [0,0,9,0,0]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'array-product')
  AND locale = 'en';

------------------------------------------------------------
-- longest-streak
------------------------------------------------------------
UPDATE problems
SET description = 'Given an unsorted array of integers `nums`, return the length of the longest sequence of consecutive elements.

You must solve this in O(n) time.

**Example 1:**
```
Input: nums = [100,4,200,1,3,2]
Output: 4
Explanation: The longest consecutive sequence is [1, 2, 3, 4]. Therefore its length is 4.
```

**Example 2:**
```
Input: nums = [0,3,7,2,5,8,4,6,0,1]
Output: 9
```'
WHERE slug = 'longest-streak';

UPDATE problem_translations
SET description = 'Given an unsorted array of integers `nums`, return the length of the longest sequence of consecutive elements.

You must solve this in O(n) time.

**Example 1:**
```
Input: nums = [100,4,200,1,3,2]
Output: 4
Explanation: The longest consecutive sequence is [1, 2, 3, 4]. Therefore its length is 4.
```

**Example 2:**
```
Input: nums = [0,3,7,2,5,8,4,6,0,1]
Output: 9
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-streak')
  AND locale = 'en';

------------------------------------------------------------
-- string-codec
------------------------------------------------------------
UPDATE problems
SET description = 'Design an algorithm to encode a list of strings into a single string, and decode that single string back into the original list.

Implement two methods:
- `encode(strs)` takes a list of strings and returns a single encoded string.
- `decode(s)` takes the encoded string and returns the original list of strings.

The algorithm must be **stateless**: the encoded string must contain all the information needed for decoding. The strings may contain any possible characters, including delimiters.

**Example 1:**
```
Input: strs = ["hello","world"]
Output: ["hello","world"]
Explanation: encode(["hello","world"]) produces some encoded string, and decode on that string returns the original list.
```

**Example 2:**
```
Input: strs = [""]
Output: [""]
```

**Example 3:**
```
Input: strs = ["","",""]
Output: ["","",""]
```'
WHERE slug = 'string-codec';

UPDATE problem_translations
SET description = 'Design an algorithm to encode a list of strings into a single string, and decode that single string back into the original list.

Implement two methods:
- `encode(strs)` takes a list of strings and returns a single encoded string.
- `decode(s)` takes the encoded string and returns the original list of strings.

The algorithm must be **stateless**: the encoded string must contain all the information needed for decoding. The strings may contain any possible characters, including delimiters.

**Example 1:**
```
Input: strs = ["hello","world"]
Output: ["hello","world"]
Explanation: encode(["hello","world"]) produces some encoded string, and decode on that string returns the original list.
```

**Example 2:**
```
Input: strs = [""]
Output: [""]
```

**Example 3:**
```
Input: strs = ["","",""]
Output: ["","",""]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'string-codec')
  AND locale = 'en';

------------------------------------------------------------
-- sudoku-validator
------------------------------------------------------------
UPDATE problems
SET description = 'Determine if a 9 x 9 Sudoku board is valid. Only the filled cells need to be validated according to these rules:

1. Each row must contain the digits `1`-`9` without repetition.
2. Each column must contain the digits `1`-`9` without repetition.
3. Each of the nine 3 x 3 sub-boxes must contain the digits `1`-`9` without repetition.

A partially filled board can be valid even if it is not solvable. Empty cells are represented by `"."`.

**Example 1:**
```
Input: board =
[["5","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]
Output: true
```

**Example 2:**
```
Input: board =
[["8","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]
Output: false
Explanation: Same as Example 1, except the 5 in the top left corner is changed to 8. Since there are two 8''s in the top left 3x3 sub-box, it is invalid.
```',
    constraints = 'board.length == 9
board[i].length == 9
board[i][j] is a digit 1-9 or ''.''.'
WHERE slug = 'sudoku-validator';

UPDATE problem_translations
SET description = 'Determine if a 9 x 9 Sudoku board is valid. Only the filled cells need to be validated according to these rules:

1. Each row must contain the digits `1`-`9` without repetition.
2. Each column must contain the digits `1`-`9` without repetition.
3. Each of the nine 3 x 3 sub-boxes must contain the digits `1`-`9` without repetition.

A partially filled board can be valid even if it is not solvable. Empty cells are represented by `"."`.

**Example 1:**
```
Input: board =
[["5","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]
Output: true
```

**Example 2:**
```
Input: board =
[["8","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]
Output: false
Explanation: Same as Example 1, except the 5 in the top left corner is changed to 8. Since there are two 8''s in the top left 3x3 sub-box, it is invalid.
```',
    constraints = 'board.length == 9
board[i].length == 9
board[i][j] is a digit 1-9 or ''.''.'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sudoku-validator')
  AND locale = 'en';

------------------------------------------------------------
-- palindrome-checker
------------------------------------------------------------
UPDATE problems
SET description = 'A phrase is a **palindrome** if, after converting all uppercase letters to lowercase and removing all non-alphanumeric characters, it reads the same forward and backward. Alphanumeric characters include letters and numbers.

Given a string `s`, return `true` if it is a palindrome, or `false` otherwise.

**Example 1:**
```
Input: s = "A man, a plan, a canal: Panama"
Output: true
Explanation: "amanaplanacanalpanama" is a palindrome.
```

**Example 2:**
```
Input: s = "race a car"
Output: false
Explanation: "raceacar" is not a palindrome.
```

**Example 3:**
```
Input: s = " "
Output: true
Explanation: s is an empty string "" after removing non-alphanumeric characters. Since an empty string reads the same forward and backward, it is a palindrome.
```'
WHERE slug = 'palindrome-checker';

UPDATE problem_translations
SET description = 'A phrase is a **palindrome** if, after converting all uppercase letters to lowercase and removing all non-alphanumeric characters, it reads the same forward and backward. Alphanumeric characters include letters and numbers.

Given a string `s`, return `true` if it is a palindrome, or `false` otherwise.

**Example 1:**
```
Input: s = "A man, a plan, a canal: Panama"
Output: true
Explanation: "amanaplanacanalpanama" is a palindrome.
```

**Example 2:**
```
Input: s = "race a car"
Output: false
Explanation: "raceacar" is not a palindrome.
```

**Example 3:**
```
Input: s = " "
Output: true
Explanation: s is an empty string "" after removing non-alphanumeric characters. Since an empty string reads the same forward and backward, it is a palindrome.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'palindrome-checker')
  AND locale = 'en';
