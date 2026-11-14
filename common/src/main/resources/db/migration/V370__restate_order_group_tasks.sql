-- V370: order-group-tasks, text restated. The title's "Group" is now the study group the
-- tasks belong to, and the statement says "tasks" throughout. Starter method
-- sequenceAssemblySteps (find_order in Python) -> findTaskOrder, parameter numSteps
-- (num_courses in Python) -> numTasks, the statement's words. Examples match the sample
-- test cases, which are unchanged.

UPDATE problems SET
    description = $$Your study group has `numTasks` tasks to finish, labelled `0` to `numTasks - 1`. Each `prereqs[i] = [a, b]` means task `b` must be finished before task `a` can start.

Return an order of all `numTasks` tasks in which every task comes after the tasks it waits on. Any such order is accepted. If no such order exists, because the prerequisites form a cycle, return an empty array.

**Example 1:**
```
Input: numTasks = 3, prereqs = [[2,0],[1,0]]
Output: [0,1,2]
Explanation: Tasks 1 and 2 both wait on task 0 only, so task 0 comes first and the other two follow in either order. [0,1,2] and [0,2,1] are both accepted.
```

```diagram-graph
edges: [[2,0],[1,0]]
directed: true
```

**Example 2:**
```
Input: numTasks = 5, prereqs = [[1,0],[2,1],[3,1],[4,2],[4,3]]
Output: [0,1,2,3,4]
Explanation: Task 0 comes before task 1, task 1 before tasks 2 and 3, and tasks 2 and 3 before task 4. [0,1,2,3,4] keeps all five rules.
```$$,
    constraints = $$- `1 <= numTasks <= 2000`
- `0 <= prereqs.length <= numTasks * (numTasks - 1)`
- `prereqs[i].length == 2`
- `0 <= a, b < numTasks`
- `a != b`
- All pairs `[a, b]` in `prereqs` are distinct.$$
WHERE slug = $$order-group-tasks$$;

UPDATE problem_translations SET
    title = $$조별 과제 순서 정하기$$,
    description = $$여러분의 조에는 끝내야 할 과제가 `numTasks`개 있고, `0`번부터 `numTasks - 1`번까지 번호가 붙어 있습니다. 각 `prereqs[i] = [a, b]`는 과제 `b`를 끝내야 과제 `a`를 시작할 수 있다는 뜻입니다.

모든 과제가 자신이 기다리는 과제들보다 뒤에 오도록 `numTasks`개 과제 전체의 순서를 반환하세요. 그런 순서라면 어느 것이든 정답으로 인정합니다. 선행 관계가 사이클을 이루어 그런 순서가 없으면 빈 배열을 반환하세요.

**예시 1:**
```
입력: numTasks = 3, prereqs = [[2,0],[1,0]]
출력: [0,1,2]
설명: 과제 1과 2는 둘 다 과제 0만 기다리므로, 과제 0이 먼저 오고 나머지 둘은 어느 순서로 와도 됩니다. [0,1,2]와 [0,2,1] 모두 정답입니다.
```

```diagram-graph
edges: [[2,0],[1,0]]
directed: true
```

**예시 2:**
```
입력: numTasks = 5, prereqs = [[1,0],[2,1],[3,1],[4,2],[4,3]]
출력: [0,1,2,3,4]
설명: 과제 0은 과제 1보다, 과제 1은 과제 2와 3보다, 과제 2와 3은 과제 4보다 앞서야 합니다. [0,1,2,3,4]는 다섯 규칙을 모두 지킵니다.
```$$,
    constraints = $$- `1 <= numTasks <= 2000`
- `0 <= prereqs.length <= numTasks * (numTasks - 1)`
- `prereqs[i].length == 2`
- `0 <= a, b < numTasks`
- `a != b`
- 모든 쌍 `[a, b]`는 `prereqs` 안에서 서로 다릅니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$order-group-tasks$$);
