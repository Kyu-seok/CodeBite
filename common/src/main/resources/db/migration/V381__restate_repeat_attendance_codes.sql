-- V381: repeat-attendance-codes restated, title unchanged. "Some students scanned twice;
-- the rest scanned exactly once" can't hold for n scans of codes 1..n: a repeat leaves
-- some code missing ([3,3,1,2] has no 4). The statement now says each code appears once
-- or twice, so some never appear, calls the values codes throughout (not ids or scans),
-- and states that no repeat returns an empty list, shown by the new Example 3 (sample 3).
-- Names unchanged. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$An attendance scanner logs one code per scan in `codes`, an array of length `n`. Every code is between `1` and `n` and appears once or twice, so when a code repeats, some other code between `1` and `n` never appears.

Return every code that appears twice, in any order. If no code repeats, return an empty list. Aim for linear time and constant extra memory beyond the output list.

**Example 1:**
```
Input: codes = [5,2,6,3,2,1,4,6]
Output: [2,6]
Explanation: Code 2 appears at indices 1 and 4, and code 6 at indices 2 and 7. Codes 7 and 8 never appear.
```

**Example 2:**
```
Input: codes = [3,3,1,2]
Output: [3]
Explanation: Code 3 appears twice, and code 4 never appears.
```

**Example 3:**
```
Input: codes = [1,2,3,4,5]
Output: []
Explanation: Every code appears once, so the list is empty.
```$$,
    constraints = $$- `n == codes.length`
- `1 <= n <= 2 * 10^5`
- `1 <= codes[i] <= n`
- Each code in `codes` appears once or twice.$$
WHERE slug = $$repeat-attendance-codes$$;

UPDATE problem_translations SET
    description = $$출석 스캐너가 스캔할 때마다 코드 하나를 길이 `n`의 배열 `codes`에 기록합니다. 모든 코드는 `1`부터 `n` 사이이고 한 번 또는 두 번 등장하므로, 어떤 코드가 반복되면 `1`부터 `n` 사이의 다른 코드 중 한 번도 등장하지 않는 것이 생깁니다.

두 번 등장하는 코드를 모두 어떤 순서로든 반환하세요. 반복되는 코드가 없으면 빈 리스트를 반환합니다. 출력 리스트 외에는 상수 크기의 추가 메모리만 사용하면서 선형 시간에 처리하는 것을 목표로 합니다.

**예시 1:**
```
입력: codes = [5,2,6,3,2,1,4,6]
출력: [2,6]
설명: 코드 2는 인덱스 1과 4에, 코드 6은 인덱스 2와 7에 등장합니다. 코드 7과 8은 등장하지 않습니다.
```

**예시 2:**
```
입력: codes = [3,3,1,2]
출력: [3]
설명: 코드 3이 두 번 등장하고, 코드 4는 등장하지 않습니다.
```

**예시 3:**
```
입력: codes = [1,2,3,4,5]
출력: []
설명: 모든 코드가 한 번씩만 등장하므로 빈 리스트입니다.
```$$,
    constraints = $$- `n == codes.length`
- `1 <= n <= 2 * 10^5`
- `1 <= codes[i] <= n`
- `codes`의 각 코드는 한 번 또는 두 번 등장합니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$repeat-attendance-codes$$);
