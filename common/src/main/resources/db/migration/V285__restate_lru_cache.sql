-- V285: restate lru-cache (#217, part of #193). Example 1 showed LeetCode's values
-- (1, 2, 3, 4) where sample test case 1 stores 10, 20, 30 and 40; the Example, its
-- Explanation and the Korean Example now show sample 1 exactly. Only the descriptions
-- change; Slug, title, constraints, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problems SET
    description = $$Design `LRUCache`, a key/value store with a fixed `capacity` that evicts the least-recently-used entry whenever it grows past its limit.

Implement:
- `LRUCache(int capacity)` — create the cache with positive size `capacity`.
- `int get(int key)` — return the value for `key`, or `-1` if `key` is absent. A successful `get` counts as a recent use.
- `void put(int key, int value)` — insert or update the entry. If the cache exceeds `capacity` after the insert, evict the least-recently-used key.

Both `get` and `put` should run in **O(1) average time**.

**Example 1:**
```
Input
["LRUCache","put","put","get","put","get","put","get","get","get"]
[[2],[1,10],[2,20],[1],[3,30],[2],[4,40],[1],[3],[4]]
Output
[null,null,null,10,null,-1,null,-1,30,40]

Explanation
LRUCache cache = new LRUCache(2);
cache.put(1, 10); // cache = {1=10}
cache.put(2, 20); // cache = {1=10, 2=20}
cache.get(1);     // returns 10, cache = {2=20, 1=10}
cache.put(3, 30); // evicts key 2, cache = {1=10, 3=30}
cache.get(2);     // returns -1 (not found)
cache.put(4, 40); // evicts key 1, cache = {3=30, 4=40}
cache.get(1);     // returns -1
cache.get(3);     // returns 30
cache.get(4);     // returns 40
```$$
WHERE slug = $$lru-cache$$;

UPDATE problem_translations SET
    description = $$고정된 `capacity`를 가진 키/값 저장소 `LRUCache`를 설계하세요. 용량을 초과하는 순간 가장 오래 사용되지 않은(LRU) 엔트리를 자동으로 삭제합니다.

다음 메서드를 구현하세요:
- `LRUCache(int capacity)` — 양의 정수 용량 `capacity`로 캐시를 초기화합니다.
- `int get(int key)` — `key`에 해당하는 값을 반환하거나, 없으면 `-1`을 반환합니다. 성공한 `get`도 최근 사용으로 간주됩니다.
- `void put(int key, int value)` — 엔트리를 새로 넣거나 갱신합니다. 삽입 후 크기가 `capacity`를 넘으면 가장 오래 사용되지 않은 키를 제거합니다.

`get`과 `put` 모두 평균적으로 **O(1)** 시간에 동작해야 합니다.

**예시 1:**
```
입력
["LRUCache","put","put","get","put","get","put","get","get","get"]
[[2],[1,10],[2,20],[1],[3,30],[2],[4,40],[1],[3],[4]]
출력
[null,null,null,10,null,-1,null,-1,30,40]

설명
LRUCache cache = new LRUCache(2);
cache.put(1, 10); // 캐시 = {1=10}
cache.put(2, 20); // 캐시 = {1=10, 2=20}
cache.get(1);     // 10 반환, 캐시 = {2=20, 1=10}
cache.put(3, 30); // 키 2 제거, 캐시 = {1=10, 3=30}
cache.get(2);     // -1 반환 (없음)
cache.put(4, 40); // 키 1 제거, 캐시 = {3=30, 4=40}
cache.get(1);     // -1 반환
cache.get(3);     // 30 반환
cache.get(4);     // 40 반환
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$lru-cache$$);
