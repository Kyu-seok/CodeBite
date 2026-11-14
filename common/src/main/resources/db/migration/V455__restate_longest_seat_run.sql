-- V455: longest-seat-run, text restated. The statement called the input "free lobby slot
-- numbers" though everything else says seats, and never said what an empty list returns
-- (a hidden case expects 0). Starter method longestSeatBlock -> longestSeatRun, to match
-- the title. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$`seatIds` lists the numbers of the free seats in a row, in any order. Implement `longestSeatRun` to return the length of the **longest run of consecutive seat numbers** among them.

- A number listed more than once counts once.
- Return `0` for an empty list.
- Your solution must run in O(n) time.

**Example 1:**
```
Input: seatIds = [42,7,41,40,9,8,43]
Output: 4
Explanation: The run 40, 41, 42, 43 has length 4; the other run, 7, 8, 9, has length 3.
```

**Example 2:**
```
Input: seatIds = [11,13,12,15,16,14,20,19,18]
Output: 6
Explanation: The run 11, 12, 13, 14, 15, 16 has length 6; the other run, 18, 19, 20, has length 3.
```$$
WHERE slug = $$longest-seat-run$$;

UPDATE problem_translations SET
    description = $$`seatIds`는 한 줄에 있는 빈 좌석들의 번호를 순서 없이 나열한 목록입니다. 그중 **번호가 연속된 좌석 구간** 중 가장 긴 구간의 길이를 반환하는 `longestSeatRun`을 구현하세요.

- 여러 번 나오는 번호는 한 번으로 셉니다.
- 목록이 비어 있으면 `0`을 반환하세요.
- 풀이는 O(n) 시간에 동작해야 합니다.

**예시 1:**
```
입력: seatIds = [42,7,41,40,9,8,43]
출력: 4
설명: 구간 `40, 41, 42, 43`의 길이가 4로 가장 깁니다. 다른 구간 `7, 8, 9`의 길이는 3입니다.
```

**예시 2:**
```
입력: seatIds = [11,13,12,15,16,14,20,19,18]
출력: 6
설명: 구간 `11, 12, 13, 14, 15, 16`의 길이가 6으로 가장 깁니다. 다른 구간 `18, 19, 20`의 길이는 3입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-seat-run$$);
