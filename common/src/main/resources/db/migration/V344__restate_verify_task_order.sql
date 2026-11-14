-- V344: verify-task-order restated. The text spoke of a group project's tasks, but the
-- count was `numScenes` and the method verifyShootPlan, leftovers from a film-shoot
-- theme. The task is now stated first and the count is `numTasks` in text, constraints
-- and Starter Code. Starter method verifyShootPlan -> canFinishAllTasks, parameter
-- numScenes -> numTasks; the Drivers' numCourses -> numTasks and prerequisites ->
-- prereqs. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Return `true` if every task of a group project can be finished in some order, or `false` if that is impossible because the dependencies form a cycle.

The project has `numTasks` tasks, numbered `0` to `numTasks - 1`. Each `prereqs[i] = [a, b]` means task `b` must be finished before task `a` can start.

**Example 1:**
```
Input: numTasks = 4, prereqs = [[1,0],[2,0],[3,1]]
Output: true
Explanation: Task `0` can go first, then `1` and `2` (which both only need `0`), and finally `3`. No circular dependency exists.
```

```diagram-graph
edges: [[1,0],[2,0],[3,1]]
directed: true
```

**Example 2:**
```
Input: numTasks = 3, prereqs = [[0,2],[2,1],[1,0]]
Output: false
Explanation: Task `0` needs `2`, `2` needs `1`, and `1` needs `0`. The three-way loop means none of them can ever start.
```$$,
    constraints = $$- `1 <= numTasks <= 2000`
- `0 <= prereqs.length <= 5000`
- `prereqs[i].length == 2`
- `0 <= a, b < numTasks`
- All pairs `prereqs[i]` are distinct.$$
WHERE slug = $$verify-task-order$$;

UPDATE problem_translations SET
    description = $$조별 과제의 모든 작업을 어떤 순서로든 끝낼 수 있으면 `true`를, 의존 관계에 순환이 있어 불가능하면 `false`를 반환하세요.

과제에는 `0`부터 `numTasks - 1`까지 번호가 매겨진 `numTasks`개의 작업이 있습니다. `prereqs[i] = [a, b]`는 작업 `a`를 시작하려면 먼저 작업 `b`가 끝나 있어야 한다는 뜻입니다.

**예시 1:**
```
입력: numTasks = 4, prereqs = [[1,0],[2,0],[3,1]]
출력: true
설명: 먼저 작업 `0`을 끝내면, 모두 `0`만 필요한 작업 `1`과 `2`를 이어서 처리할 수 있고 마지막으로 작업 `3`을 처리하면 됩니다. 순환 의존이 없습니다.
```

```diagram-graph
edges: [[1,0],[2,0],[3,1]]
directed: true
```

**예시 2:**
```
입력: numTasks = 3, prereqs = [[0,2],[2,1],[1,0]]
출력: false
설명: 작업 `0`은 `2`를, `2`는 `1`을, `1`은 `0`을 필요로 해서 세 작업이 순환을 이루므로 어느 것도 시작할 수 없습니다.
```$$,
    constraints = $$- `1 <= numTasks <= 2000`
- `0 <= prereqs.length <= 5000`
- `prereqs[i].length == 2`
- `0 <= a, b < numTasks`
- 모든 `prereqs[i]` 쌍은 서로 다릅니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$verify-task-order$$);
