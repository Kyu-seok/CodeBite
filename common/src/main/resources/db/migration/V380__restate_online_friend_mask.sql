-- V380: online-friend-mask restated, title unchanged. The statement spoke of sensors
-- (sensorMask, countActiveSensors) while the story is friends, the Python Starter Code
-- named hamming_weight, and the constraint 1 <= sensorMask <= 2.1 * 10^9 was false:
-- cases hold 0 and 4294967295. The constraint is now 0 <= friendMask < 2^32, and the
-- statement says how Java and C++ receive a mask of 2^31 or more (a negative int with
-- the same bits). Korean title 접속 중인 친구 마스크 -> 접속 중인 친구 수, matching "Count".
-- Starter method countActiveSensors / hamming_weight -> countOnlineFriends, parameter
-- sensorMask -> friendMask, in all 4 Starter Codes and Drivers. Examples match the
-- sample test cases, which are unchanged.

UPDATE problems SET
    description = $$`friendMask` is a 32-bit mask of your friends list: bit `i` is `1` when friend `i` is online. Return the number of friends online, that is, the number of `1` bits in `friendMask`.

In Java and C++, `friendMask` arrives as an `int` holding the same 32 bits, so a mask of `2^31` or more is a negative number there. Count its bits all the same.

**Example 1:**
```
Input: friendMask = 29
Output: 4
Explanation: 29 is 11101 in binary: four friends are online.
```

**Example 2:**
```
Input: friendMask = 256
Output: 1
Explanation: 256 is 100000000 in binary: only friend 8 is online.
```$$,
    constraints = $$- `0 <= friendMask < 2^32`$$
WHERE slug = $$online-friend-mask$$;

UPDATE problem_translations SET
    title = $$접속 중인 친구 수$$,
    description = $$`friendMask`는 친구 목록을 나타내는 32비트 마스크로, 친구 `i`가 접속 중이면 비트 `i`가 `1`입니다. 접속 중인 친구 수, 즉 `friendMask`에서 `1`인 비트의 개수를 반환하세요.

Java와 C++에서는 `friendMask`가 같은 32비트를 담은 `int`로 전달되므로, `2^31` 이상인 마스크는 음수가 됩니다. 이때도 비트를 똑같이 세면 됩니다.

**예시 1:**
```
입력: friendMask = 29
출력: 4
설명: 29는 이진수로 11101이므로 친구 네 명이 접속 중입니다.
```

**예시 2:**
```
입력: friendMask = 256
출력: 1
설명: 256은 이진수로 100000000이므로 친구 8 한 명만 접속 중입니다.
```$$,
    constraints = $$- `0 <= friendMask < 2^32`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$online-friend-mask$$);
