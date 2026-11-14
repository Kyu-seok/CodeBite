-- V454: product-of-all-other-elements, text restated. The no-division and O(n) rule moves
-- up under the task sentence instead of sitting after the examples, and both examples gain
-- an explanation (why the 0 makes every other entry 0). Examples now print the sample
-- input and output as the Driver reads and writes them, and match the sample test cases,
-- which are unchanged.

UPDATE problems SET
    description = $$Given an integer array `nums`, return an array `answer` of the same length, where `answer[i]` is the product of all elements of `nums` except `nums[i]`.

Solve it without using division, in O(n) time.

**Example 1:**
```
Input: nums = [2,3,5,4]
Output: [60,40,24,30]
Explanation: answer[0] = 3 × 5 × 4 = 60, answer[1] = 2 × 5 × 4 = 40, answer[2] = 2 × 3 × 4 = 24, answer[3] = 2 × 3 × 5 = 30.
```

**Example 2:**
```
Input: nums = [-2,1,0,4,-1]
Output: [0,0,8,0,0]
Explanation: Every product except the one for position 2 includes the 0, so it is 0. answer[2] = -2 × 1 × 4 × -1 = 8.
```$$
WHERE slug = $$product-of-all-other-elements$$;

UPDATE problem_translations SET
    description = $$정수 배열 `nums`가 주어집니다. 같은 길이의 배열 `answer`를 반환하세요. 각 `answer[i]`는 `nums[i]`를 제외한 `nums`의 모든 원소를 곱한 값입니다.

나눗셈을 쓰지 말고 O(n) 시간에 풀어야 합니다.

**예시 1:**
```
입력: nums = [2,3,5,4]
출력: [60,40,24,30]
설명: answer[0] = 3 × 5 × 4 = 60, answer[1] = 2 × 5 × 4 = 40, answer[2] = 2 × 3 × 4 = 24, answer[3] = 2 × 3 × 5 = 30입니다.
```

**예시 2:**
```
입력: nums = [-2,1,0,4,-1]
출력: [0,0,8,0,0]
설명: 2번 위치를 뺀 나머지 위치의 곱에는 모두 0이 들어가므로 0입니다. answer[2] = -2 × 1 × 4 × -1 = 8입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$product-of-all-other-elements$$);
