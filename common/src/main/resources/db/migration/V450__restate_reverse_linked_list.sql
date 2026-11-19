-- V450: reverse-linked-list, text restated. The constraints counted "songs" and bounded
-- `Song.val`, a theme the statement never mentions: they now count nodes and bound
-- `ListNode.val`, the Starter Code's class. The English examples gain the explanations
-- the Korean already had. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given the `head` of a singly linked list, reverse the list and return its new head. The reversal must rewire the existing nodes in place — do not allocate a fresh list.

**Example 1:**
```
Input: head = [8,3,12,5,9]
Output: [9,5,12,3,8]
Explanation: The list that ran from 8 to 9 now runs from 9 back to 8.
```

```diagram-linked-list
nodes: [8,3,12,5,9]
after: [9,5,12,3,8]
```

**Example 2:**
```
Input: head = [4,7]
Output: [7,4]
Explanation: The two nodes swap places, so 7 is the new head.
```

**Example 3:**
```
Input: head = [1]
Output: [1]
Explanation: A list of one node reads the same reversed.
```$$,
    constraints = $$- The number of nodes in the list is in the range `[0, 6000]`.
- `-6000 <= ListNode.val <= 6000`$$
WHERE slug = $$reverse-linked-list$$;

UPDATE problem_translations SET
    constraints = $$- 리스트의 노드 개수는 `[0, 6000]` 범위 안에 있습니다.
- `-6000 <= ListNode.val <= 6000`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$reverse-linked-list$$);
