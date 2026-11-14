-- V382: four-tray-sum restated, title unchanged. Its constraints were false: case 4 is
-- an empty array, and case 9 holds 10^9 values with demand -294967296 (four of them
-- overflow 32 bits). They now read 0 <= trays.length <= 200 and +-10^9 for values and
-- demand, and the statement warns that a sum can pass the 32-bit range. The extras/short
-- gloss is gone; the statement says when two quadruplets are the same, that both the list
-- and each quadruplet may come in any order (the Driver sorts both), and what no match returns.
-- Starter method quadTrayDemand -> fourTraySum in all 4 Starter Codes and Drivers.
-- Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given an integer array `trays`, one count per tray (a count may be negative), and an integer `demand`, return every **unique quadruplet** `[trays[a], trays[b], trays[c], trays[d]]` of four different indices `a`, `b`, `c`, `d` whose values sum to `demand`.

Two quadruplets are the same when they hold the same four values, so list each one once. Return the quadruplets in any order, and the values within each in any order. If no four values sum to `demand`, return an empty list. A sum of four values can pass the 32-bit integer range.

**Example 1:**
```
Input: trays = [1,-1,2,-2,3,-3], demand = 0
Output: [[-3,-2,2,3],[-3,-1,1,3],[-2,-1,1,2]]
Explanation: These are the three different sets of four values that sum to 0.
```

**Example 2:**
```
Input: trays = [3,3,3,3,3], demand = 12
Output: [[3,3,3,3]]
Explanation: Any four of the five trays sum to 12, and every choice holds the same values, so the quadruplet is listed once.
```$$,
    constraints = $$- `0 <= trays.length <= 200`
- `-10^9 <= trays[i] <= 10^9`
- `-10^9 <= demand <= 10^9`$$
WHERE slug = $$four-tray-sum$$;

UPDATE problem_translations SET
    description = $$트레이마다 수량 하나씩을 담은 정수 배열 `trays`(수량은 음수일 수 있음)와 정수 `demand`가 주어질 때, 서로 다른 네 인덱스 `a`, `b`, `c`, `d`의 값 합이 `demand`가 되는 **고유한 4원소 조합** `[trays[a], trays[b], trays[c], trays[d]]`를 모두 반환하세요.

네 값이 같은 두 조합은 같은 조합이므로 한 번만 포함하세요. 조합의 순서도, 각 조합 안의 값 순서도 자유입니다. 합이 `demand`가 되는 네 값이 없으면 빈 리스트를 반환합니다. 네 값의 합은 32비트 정수 범위를 넘을 수 있습니다.

**예시 1:**
```
입력: trays = [1,-1,2,-2,3,-3], demand = 0
출력: [[-3,-2,2,3],[-3,-1,1,3],[-2,-1,1,2]]
설명: 합이 0이 되는 서로 다른 네 값 묶음은 이 세 가지입니다.
```

**예시 2:**
```
입력: trays = [3,3,3,3,3], demand = 12
출력: [[3,3,3,3]]
설명: 다섯 트레이 중 어떤 네 개를 골라도 합이 12이고, 어느 쪽이든 값이 같으므로 조합은 한 번만 포함합니다.
```$$,
    constraints = $$- `0 <= trays.length <= 200`
- `-10^9 <= trays[i] <= 10^9`
- `-10^9 <= demand <= 10^9`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$four-tray-sum$$);
