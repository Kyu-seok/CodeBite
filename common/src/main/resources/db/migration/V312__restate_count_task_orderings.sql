-- V312: count-task-orderings restated. The modulus said 10^8 + 7, but the expected
-- outputs use 10^9 + 7 (case 11 expects 678300570, above 10^8 + 7). Both languages now
-- state the modulus correctly, say plainly that a task comes after its parent in an
-- order, and show how Example 1's 8 arises. Starter method countAssemblyOrders ->
-- countTaskOrders; the Drivers' prevRoom -> parent. Examples match the sample test
-- cases, which are unchanged.

UPDATE problems SET
    description = $$Return the number of orders in which `n` tasks can be done one at a time, when every task must come after its parent task. Return it modulo `10^9 + 7`.

The tasks are numbered `0` to `n - 1`. `parent[i]` is the task that must be done before task `i`. Task `0` has no parent (`parent[0] = -1`), and the parents form a tree rooted at task `0`, so task `0` always comes first.

An order lists every task exactly once, and each task appears somewhere after its parent (not necessarily right after it).

**Example 1:**
```
Input: parent = [-1,0,0,2,2]
Output: 8
Explanation: Task 0 comes first. Tasks 1 and 2 follow task 0, and tasks 3 and 4 follow task 2. Among tasks 2, 3 and 4, task 2 must come first and 3 and 4 follow in either order: 2 ways. Task 1 can then go into any of the 4 places around those three tasks (before, between or after them): 4 ways. That makes 2 × 4 = 8 orders.
```

**Example 2:**
```
Input: parent = [-1,0,1,2,3]
Output: 1
Explanation: Each task is the parent of the next, so 0, 1, 2, 3, 4 is the only order.
```

**Example 3:**
```
Input: parent = [-1,0,0,0,0]
Output: 24
Explanation: Tasks 1 to 4 all have task 0 as their parent, so after task 0 they can come in any order: 4! = 24.
```$$,
    constraints = $$- `n == parent.length`
- `1 <= n <= 2 * 10^5`
- `parent[0] == -1`
- `0 <= parent[i] < n` for `i >= 1`
- Following parents from any task leads to task `0`.$$
WHERE slug = $$count-task-orderings$$;

UPDATE problem_translations SET
    description = $$`n`개의 작업을 한 번에 하나씩 처리하되 모든 작업이 자기 부모 작업보다 뒤에 와야 할 때, 가능한 처리 순서의 개수를 `10^9 + 7`로 나눈 나머지로 반환하세요.

작업에는 `0`부터 `n - 1`까지 번호가 매겨져 있습니다. `parent[i]`는 작업 `i`보다 먼저 처리해야 하는 작업입니다. 작업 `0`에는 부모가 없고(`parent[0] = -1`), 부모 관계는 작업 `0`을 루트로 하는 트리를 이루므로 작업 `0`이 항상 가장 먼저 옵니다.

순서는 모든 작업을 정확히 한 번씩 나열한 것이며, 각 작업은 자기 부모보다 뒤 어딘가에 옵니다(바로 다음일 필요는 없습니다).

**예시 1:**
```
입력: parent = [-1,0,0,2,2]
출력: 8
설명: 작업 0이 가장 먼저 옵니다. 작업 1과 2는 작업 0 뒤에, 작업 3과 4는 작업 2 뒤에 와야 합니다. 작업 2, 3, 4 중에서는 2가 먼저 오고 3과 4는 어느 순서로든 올 수 있으므로 2가지입니다. 작업 1은 이 세 작업의 앞, 사이, 뒤 중 4곳 어디에나 들어갈 수 있으므로 4가지입니다. 따라서 2 × 4 = 8가지입니다.
```

**예시 2:**
```
입력: parent = [-1,0,1,2,3]
출력: 1
설명: 각 작업이 다음 작업의 부모이므로 가능한 순서는 0, 1, 2, 3, 4 하나뿐입니다.
```

**예시 3:**
```
입력: parent = [-1,0,0,0,0]
출력: 24
설명: 작업 1부터 4까지 모두 작업 0이 부모이므로, 작업 0 다음에는 어떤 순서로든 올 수 있습니다: 4! = 24가지입니다.
```$$,
    constraints = $$- `n == parent.length`
- `1 <= n <= 2 * 10^5`
- `parent[0] == -1`
- `0 <= parent[i] < n` (`i >= 1`인 경우)
- 어느 작업에서든 부모를 따라가면 작업 `0`에 도달합니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-task-orderings$$);
