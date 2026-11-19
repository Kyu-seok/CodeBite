-- V524: missing-sock-number restated, Slug and title unchanged. The method was named
-- lowestMissingTarget, a word the statement never uses: renamed smallestMissingNumber
-- in the Starter Code and Drivers (Driver local nums renamed socks). "Zeros and
-- negatives are mystery lint" now says plainly that they are ignored. Examples match
-- the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$`socks` lists the numbers on a pile of socks in the laundry basket. Return the smallest positive integer that no sock in the pile carries. Zeros and negative numbers may appear: ignore them.

Implement `smallestMissingNumber(socks)`. The array is unsorted and may contain repeats. Aim for O(n) time and O(1) extra space.

**Example 1:**
```
Input: socks = [2,3,1,5]
Output: 4
Explanation: 1, 2 and 3 are all there, so 4 is the smallest positive number missing.
```

**Example 2:**
```
Input: socks = [6,-2,8,10]
Output: 1
Explanation: No sock is numbered 1, so 1 is the smallest positive number missing.
```$$
WHERE slug = $$missing-sock-number$$;

UPDATE problem_translations SET
    description = $$빨래 바구니에 든 양말들에 적힌 번호가 정수 배열 `socks`에 담겨 있습니다. 어떤 양말에도 적혀 있지 않은 가장 작은 양의 정수를 반환하세요. `0`과 음수가 들어 있을 수 있으며, 이들은 무시합니다.

`smallestMissingNumber(socks)`를 구현하세요. 배열은 정렬되어 있지 않으며 같은 값이 반복될 수도 있습니다. O(n) 시간과 O(1) 보조 공간을 목표로 하세요.

**예시 1:**
```
입력: socks = [2,3,1,5]
출력: 4
설명: `1`, `2`, `3`은 모두 있지만 `4`가 없으니, 빠진 가장 작은 양의 정수는 `4`입니다.
```

**예시 2:**
```
입력: socks = [6,-2,8,10]
출력: 1
설명: `1`번 양말이 없으므로, 빠진 가장 작은 양의 정수는 `1`입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$missing-sock-number$$);
