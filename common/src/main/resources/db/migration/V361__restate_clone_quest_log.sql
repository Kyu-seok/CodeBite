-- V361: clone-quest-log keeps its Slug and title. The statement called the extra pointer
-- `related` while the Starter Code's Node had `random`, and a constraint spoke of a "web":
-- the Node field is renamed random -> related in all 4 Starter Codes and Drivers, the
-- constraint says "in the log", and the task comes first. Starter method duplicateTopicWeb
-- (copy_random_list in Python) -> cloneQuestLog. Examples match the sample test cases,
-- which are unchanged.

UPDATE problems SET
    description = $$Given the `head` of a quest log, return the head of a deep copy of it.

The log is a linked list of `n` missions. Each `Node` has a value `val`, a `next` pointer to the following mission, and a `related` pointer to any mission in the log (possibly itself) or `null`.

The copy must be made of exactly `n` new nodes with the same values, and every `next` and `related` pointer in the copy must point to a node of the copy, never to an original node.

The examples write a log as a list of `[val, related_index]` pairs, one per node from the head, where `related_index` is the 0-based position of the node `related` points to, or `null`.

**Example 1:**
```
Input: head = [[9,2],[4,null],[6,0],[2,1]]
Output: [[9,2],[4,null],[6,0],[2,1]]
Explanation: The copy has 4 new nodes. The copy of 9 has `related` pointing to the copy of 6 (position 2), not to the original 6.
```

**Example 2:**
```
Input: head = [[5,0]]
Output: [[5,0]]
Explanation: The single node's `related` points to itself, so the copy's `related` points to the copy.
```

**Example 3:**
```
Input: head = [[3,null],[7,null]]
Output: [[3,null],[7,null]]
Explanation: No `related` pointers are set, so only `next` is copied.
```$$,
    constraints = $$- `0 <= n <= 1200`
- `-8 * 10^4 <= Node.val <= 8 * 10^4`
- `Node.related` is `null` or points to a node in the log.$$
WHERE slug = $$clone-quest-log$$;

UPDATE problem_translations SET
    description = $$퀘스트 로그의 `head`가 주어질 때, 로그를 깊은 복사한 사본의 헤드를 반환하세요.

로그는 미션 `n`개로 이루어진 연결 리스트입니다. 각 `Node`에는 값 `val`, 다음 미션을 가리키는 `next` 포인터, 그리고 로그 안의 아무 미션(자기 자신일 수도 있음)이나 `null`을 가리키는 `related` 포인터가 있습니다.

사본은 값이 같은 새 노드 정확히 `n`개로 이루어져야 하며, 사본의 모든 `next`와 `related` 포인터는 원본 노드가 아닌 사본의 노드를 가리켜야 합니다.

예시에서는 로그를 헤드부터 노드마다 `[val, related_index]` 쌍 하나씩으로 적습니다. `related_index`는 `related`가 가리키는 노드의 0부터 시작하는 위치이거나 `null`입니다.

**예시 1:**
```
입력: head = [[9,2],[4,null],[6,0],[2,1]]
출력: [[9,2],[4,null],[6,0],[2,1]]
설명: 사본은 새 노드 4개로 이루어집니다. 9의 사본의 `related`는 원본 6이 아니라 6의 사본(위치 2)을 가리킵니다.
```

**예시 2:**
```
입력: head = [[5,0]]
출력: [[5,0]]
설명: 하나뿐인 노드의 `related`가 자기 자신을 가리키므로, 사본의 `related`도 사본 자신을 가리킵니다.
```

**예시 3:**
```
입력: head = [[3,null],[7,null]]
출력: [[3,null],[7,null]]
설명: 설정된 `related` 포인터가 없으므로 `next`만 복사됩니다.
```$$,
    constraints = $$- `0 <= n <= 1200`
- `-8 * 10^4 <= Node.val <= 8 * 10^4`
- `Node.related`는 `null`이거나 로그 안의 노드를 가리킵니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$clone-quest-log$$);
