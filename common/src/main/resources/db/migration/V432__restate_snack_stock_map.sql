-- V432: snack-stock-map restated, Slug and title unchanged. The constraint
-- 0 <= key, value <= 800000 was false: hidden cases hold 999999, so it is now 10^6. "The
-- built-in dictionary library is off-limits" left unclear what remains allowed: both
-- languages now name the hash maps that may not be used and say arrays and lists may. Each
-- Example is traced call by call in a table. Class and method names stay: the Test Cases
-- name them. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Build a map from snack `key` to its stock count for a vending machine, without a built-in hash map: no Python `dict`, Java `HashMap` or `TreeMap`, JavaScript `Map` or object used as a map, or C++ `map` or `unordered_map`. Arrays and lists are allowed.

Implement the `ChainedMap` class:

- `ChainedMap()` creates an empty map.
- `void set(int key, int value)` sets the count of snack `key` to `value`, replacing any earlier count.
- `int lookup(int key)` returns the count of snack `key`, or `-1` if the map doesn't hold it.
- `void erase(int key)` removes snack `key`, and does nothing if the map doesn't hold it.

**Example 1:**
```
Input:
["ChainedMap","set","set","lookup","lookup","set","lookup","erase","lookup"]
[[],[1,10],[2,20],[1],[3],[2,30],[2],[2],[2]]
Output: [null,null,null,10,-1,null,30,null,-1]
```

| Call | Map | Returns |
|---|---|---|
| `ChainedMap()` | `{}` | `null` |
| `set(1, 10)` | `{1: 10}` | `null` |
| `set(2, 20)` | `{1: 10, 2: 20}` | `null` |
| `lookup(1)` | `{1: 10, 2: 20}` | `10` |
| `lookup(3)` | `{1: 10, 2: 20}` | `-1` (not held) |
| `set(2, 30)` | `{1: 10, 2: 30}` | `null` |
| `lookup(2)` | `{1: 10, 2: 30}` | `30` |
| `erase(2)` | `{1: 10}` | `null` |
| `lookup(2)` | `{1: 10}` | `-1` (not held) |

**Example 2:**
```
Input:
["ChainedMap","set","set","set","lookup","lookup","lookup"]
[[],[5,50],[10,100],[15,150],[5],[10],[15]]
Output: [null,null,null,null,50,100,150]
```

Three snacks are set, and each lookup returns that snack's own count.

**Example 3:**
```
Input:
["ChainedMap","lookup","erase","lookup"]
[[],[7],[7],[7]]
Output: [null,-1,null,-1]
```

Snack `7` was never set: `lookup` returns `-1` and `erase` changes nothing.$$,
    constraints = $$- `0 <= key, value <= 10^6`
- At most `8000` calls in total to `set`, `lookup`, and `erase`.$$
WHERE slug = $$snack-stock-map$$;

UPDATE problem_translations SET
    description = $$자판기의 간식 `key`마다 재고 수량을 저장하는 맵을 내장 해시 맵 없이 만드세요. Python `dict`, Java `HashMap`이나 `TreeMap`, JavaScript `Map`이나 맵 용도의 객체, C++ `map`이나 `unordered_map`은 쓸 수 없습니다. 배열과 리스트는 써도 됩니다.

`ChainedMap` 클래스를 구현하세요.

- `ChainedMap()` — 빈 맵을 만듭니다.
- `void set(int key, int value)` — 간식 `key`의 수량을 `value`로 정합니다. 이미 수량이 있으면 덮어씁니다.
- `int lookup(int key)` — 간식 `key`의 수량을 반환합니다. 맵에 없으면 `-1`을 반환합니다.
- `void erase(int key)` — 간식 `key`를 제거합니다. 맵에 없으면 아무 일도 하지 않습니다.

**예시 1:**
```
입력:
["ChainedMap","set","set","lookup","lookup","set","lookup","erase","lookup"]
[[],[1,10],[2,20],[1],[3],[2,30],[2],[2],[2]]
출력: [null,null,null,10,-1,null,30,null,-1]
```

| 호출 | 맵 | 반환 |
|---|---|---|
| `ChainedMap()` | `{}` | `null` |
| `set(1, 10)` | `{1: 10}` | `null` |
| `set(2, 20)` | `{1: 10, 2: 20}` | `null` |
| `lookup(1)` | `{1: 10, 2: 20}` | `10` |
| `lookup(3)` | `{1: 10, 2: 20}` | `-1` (없음) |
| `set(2, 30)` | `{1: 10, 2: 30}` | `null` |
| `lookup(2)` | `{1: 10, 2: 30}` | `30` |
| `erase(2)` | `{1: 10}` | `null` |
| `lookup(2)` | `{1: 10}` | `-1` (없음) |

**예시 2:**
```
입력:
["ChainedMap","set","set","set","lookup","lookup","lookup"]
[[],[5,50],[10,100],[15,150],[5],[10],[15]]
출력: [null,null,null,null,50,100,150]
```

간식 세 개의 수량을 정하고, 조회하면 각 간식의 수량이 그대로 나옵니다.

**예시 3:**
```
입력:
["ChainedMap","lookup","erase","lookup"]
[[],[7],[7],[7]]
출력: [null,-1,null,-1]
```

간식 `7`은 한 번도 정해진 적이 없으므로 `lookup`은 `-1`을 반환하고 `erase`는 아무것도 바꾸지 않습니다.$$,
    constraints = $$- `0 <= key, value <= 10^6`
- 합쳐서 최대 `8000`번까지 `set`, `lookup`, `erase`가 호출됩니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$snack-stock-map$$);
