-- V472: timestamp-value-store restated. It opened with a guild-game story before the task
-- and repeated the readAt rule in a sentence of its own; it now leads with the task and
-- states each rule once. Class and method names stay: the Test Cases name them. Examples
-- match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Build `TimestampedStore`, a key-value store that returns the value a key had as of a given timestamp.

- `TimestampedStore()` starts an empty store.
- `void write(String key, String value, int timestamp)` records `value` for `key` at `timestamp`.
- `String readAt(String key, int timestamp)` returns the value of the latest write to `key` at or before `timestamp`, or `""` if there is none.

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
```$$,
    constraints = $$- `1 <= key.length, value.length <= 100`
- `1 <= timestamp <= 10^7`
- Timestamps passed to `write` are strictly increasing per `key`.
- The total number of `write` and `readAt` calls combined is at most `2 * 10^5`.$$
WHERE slug = $$timestamp-value-store$$;

UPDATE problem_translations SET
    description = $$키의 값을 주어진 시점 기준으로 돌려주는 키-값 저장소 `TimestampedStore`를 구현하세요.

- `TimestampedStore()` — 빈 저장소를 생성합니다.
- `void write(String key, String value, int timestamp)` — `timestamp` 시점에 `key`의 값으로 `value`를 기록합니다.
- `String readAt(String key, int timestamp)` — `key`에 대한 기록 중 `timestamp` 이하인 시점의 가장 최근 값을 반환하고, 그런 기록이 없으면 `""`을 반환합니다.

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
