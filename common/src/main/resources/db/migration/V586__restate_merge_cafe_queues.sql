-- V586: merge-cafe-queues, text only. The last constraint counted "order nodes", a word left
-- over from an older story that the description never uses (statement cold-read, #350).

UPDATE problems SET
    constraints = $$- `k == queues.length`
- `0 <= k <= 2 * 10^3`
- `0 <= queues[i].length <= 500`
- `-8 * 10^4 <= queues[i][j] <= 8 * 10^4`
- Each `queues[i]` is sorted in ascending order.
- The total number of nodes across all queues does not exceed `2 * 10^3`.$$
WHERE slug = $$merge-cafe-queues$$;

UPDATE problem_translations SET
    constraints = $$- `k == queues.length`
- `0 <= k <= 2 * 10^3`
- `0 <= queues[i].length <= 500`
- `-8 * 10^4 <= queues[i][j] <= 8 * 10^4`
- 각 `queues[i]`는 오름차순으로 정렬되어 있습니다.
- 모든 큐의 노드 총 개수는 `2 * 10^3`을 넘지 않습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$merge-cafe-queues$$);
