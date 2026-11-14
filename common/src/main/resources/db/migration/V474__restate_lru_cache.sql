-- V474: lru-cache restated. The statement never said whether put on an existing key
-- counts as a use: it now says put updates the value and marks the key most recently used,
-- as every reference solution does. The example's cache contents are now said to run from
-- least to most recently used. Class and method names stay: the Test Cases name them.
-- Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Design `LRUCache`, a key/value store with a fixed `capacity` that evicts the least-recently-used entry whenever it grows past its limit.

Implement:
- `LRUCache(int capacity)` — create the cache with positive size `capacity`.
- `int get(int key)` — return the value for `key`, or `-1` if `key` is absent. A successful `get` counts as a use of `key`.
- `void put(int key, int value)` — if `key` is present, update its value; otherwise insert it. Either way `put` counts as a use of `key`. If the cache then holds more than `capacity` keys, evict the least-recently-used one.

Both `get` and `put` should run in **O(1) average time**.

**Example 1:**
```
Input
["LRUCache","put","put","get","put","get","put","get","get","get"]
[[2],[1,10],[2,20],[1],[3,30],[2],[4,40],[1],[3],[4]]
Output
[null,null,null,10,null,-1,null,-1,30,40]

Explanation (cache listed from least to most recently used)
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
    description = $$고정된 `capacity`를 가진 키/값 저장소 `LRUCache`를 설계하세요. 용량을 넘으면 가장 오래 사용되지 않은(LRU) 엔트리를 삭제합니다.

다음 메서드를 구현하세요:
- `LRUCache(int capacity)` — 양의 정수 용량 `capacity`로 캐시를 초기화합니다.
- `int get(int key)` — `key`에 해당하는 값을 반환하거나, 없으면 `-1`을 반환합니다. 성공한 `get`은 `key`를 사용한 것으로 칩니다.
- `void put(int key, int value)` — `key`가 이미 있으면 값을 갱신하고, 없으면 새로 넣습니다. 어느 쪽이든 `put`은 `key`를 사용한 것으로 칩니다. 그 결과 캐시의 키가 `capacity`개를 넘으면 가장 오래 사용되지 않은 키를 제거합니다.

`get`과 `put` 모두 평균적으로 **O(1)** 시간에 동작해야 합니다.

**예시 1:**
```
입력
["LRUCache","put","put","get","put","get","put","get","get","get"]
[[2],[1,10],[2,20],[1],[3,30],[2],[4,40],[1],[3],[4]]
출력
[null,null,null,10,null,-1,null,-1,30,40]

설명 (캐시는 오래 사용되지 않은 키부터 나열)
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
