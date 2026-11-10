-- V295: restate timestamp-value-store (#227, part of #193). The statement had no Example;
-- both languages now show samples 1 and 2 exactly as Example 1 and Example 2, each with an
-- Explanation. Only the descriptions change; Slug, title, constraints, Test Cases, Starter
-- Code and Drivers are unchanged.

UPDATE problems SET
    description = $$Your guild's co-op game autosaves each player's status tag at timestamped checkpoints, and you want to look up what a player's tag said at a given moment. Build `TimestampedStore` to save tagged snapshots and answer as-of queries.

- `TimestampedStore()` — starts an empty store.
- `void write(String key, String value, int timestamp)` — records `value` for `key` at `timestamp`. For any given `key`, timestamps on successive `write` calls are strictly increasing.
- `String readAt(String key, int timestamp)` — returns the latest value stored for `key` with timestamp `<= timestamp`, or `""` if none exists.

If the query falls between two writes, return the value from the most recent earlier write.

**Example 1:**
```
Input
["TimestampedStore","write","readAt","readAt","write","readAt"]
[[],["foo","bar",1],["foo",1],["foo",3],["foo","bar2",4],["foo",4]]
Output
[null,null,"bar","bar",null,"bar2"]

Explanation
TimestampedStore store = new TimestampedStore();
store.write("foo", "bar", 1);  // foo = "bar" at 1
store.readAt("foo", 1);        // returns "bar"
store.readAt("foo", 3);        // returns "bar" (latest write at or before 3 is at 1)
store.write("foo", "bar2", 4); // foo = "bar2" at 4
store.readAt("foo", 4);        // returns "bar2"
```

**Example 2:**
```
Input
["TimestampedStore","write","write","readAt","readAt","readAt"]
[[],["hello","world",1],["hello","code",2],["hello",1],["hello",2],["hello",3]]
Output
[null,null,null,"world","code","code"]

Explanation
TimestampedStore store = new TimestampedStore();
store.write("hello", "world", 1); // hello = "world" at 1
store.write("hello", "code", 2);  // hello = "code" at 2
store.readAt("hello", 1);         // returns "world"
store.readAt("hello", 2);         // returns "code"
store.readAt("hello", 3);         // returns "code" (latest write at or before 3 is at 2)
```$$
WHERE slug = $$timestamp-value-store$$;

UPDATE problem_translations SET
    description = $$길드 협동 게임은 플레이어의 상태 태그를 타임스탬프가 찍힌 체크포인트마다 자동 저장합니다. 특정 시점에 플레이어의 태그가 무엇이었는지 조회할 수 있도록, 태그 스냅샷을 저장하고 시점 질의에 답하는 `TimestampedStore`를 구현하세요.

- `TimestampedStore()` — 빈 저장소를 생성합니다.
- `void write(String key, String value, int timestamp)` — `timestamp` 시점에 `key`의 값으로 `value`를 기록합니다. 동일한 `key`에 대한 연속된 `write` 호출의 `timestamp`는 항상 엄격히 증가한다고 보장됩니다.
- `String readAt(String key, int timestamp)` — `key`에 대해 기록된 값 중 타임스탬프가 `timestamp` 이하인 가장 최근 값을 반환하고, 해당하는 기록이 없으면 `""`을 반환합니다.

조회 시점이 두 기록 사이에 있다면 바로 직전 기록의 값을 반환하면 됩니다.

**예시 1:**
```
입력
["TimestampedStore","write","readAt","readAt","write","readAt"]
[[],["foo","bar",1],["foo",1],["foo",3],["foo","bar2",4],["foo",4]]
출력
[null,null,"bar","bar",null,"bar2"]

설명
TimestampedStore store = new TimestampedStore();
store.write("foo", "bar", 1);  // 시점 1에 foo = "bar"
store.readAt("foo", 1);        // "bar" 반환
store.readAt("foo", 3);        // "bar" 반환 (3 이하의 가장 최근 기록은 시점 1)
store.write("foo", "bar2", 4); // 시점 4에 foo = "bar2"
store.readAt("foo", 4);        // "bar2" 반환
```

**예시 2:**
```
입력
["TimestampedStore","write","write","readAt","readAt","readAt"]
[[],["hello","world",1],["hello","code",2],["hello",1],["hello",2],["hello",3]]
출력
[null,null,null,"world","code","code"]

설명
TimestampedStore store = new TimestampedStore();
store.write("hello", "world", 1); // 시점 1에 hello = "world"
store.write("hello", "code", 2);  // 시점 2에 hello = "code"
store.readAt("hello", 1);         // "world" 반환
store.readAt("hello", 2);         // "code" 반환
store.readAt("hello", 3);         // "code" 반환 (3 이하의 가장 최근 기록은 시점 2)
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$timestamp-value-store$$);
