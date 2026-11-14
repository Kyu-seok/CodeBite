-- V581: reverse-savefile-flags restated, title and Slug unchanged. The description named
-- the method reversePrinterFlags, a printer left over from an earlier theme, and asked
-- for "a `long`", which only Java has; it now states the task first, names no method and
-- says the result is an unsigned 32-bit value. Sample test case 3 becomes Example 3, the
-- result that needs more than a signed 32-bit integer.
-- Starter method reversePrinterFlags -> reverseFlags in all 4 Starter Codes and Drivers.
-- Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given a 32-bit unsigned integer `statusWord`, return the value you get by reversing the order of its 32 bits: bit 0 (the lowest) moves to position 31, bit 1 to position 30, and so on. The result is also an unsigned 32-bit value, between `0` and `2^32 - 1`.

Your handheld console reads save-file flags in the opposite bit order from your PC emulator, so a status word must be reversed before the two are compared.

**Example 1:**
```
Input: statusWord = 8
Output: 268435456
Explanation: 8 has bit 3 set. After reversing, that bit lands at position 28, giving 2^28 = 268435456.
```

**Example 2:**
```
Input: statusWord = 6
Output: 1610612736
Explanation: 6 has bits 1 and 2 set. Reversed, they become bits 30 and 29, giving 2^30 + 2^29 = 1610612736.
```

**Example 3:**
```
Input: statusWord = 1
Output: 2147483648
Explanation: Bit 0 moves to position 31, giving 2^31 = 2147483648, one more than a signed 32-bit integer can hold.
```$$,
    constraints = $$- `0 <= statusWord <= 4294967295`$$
WHERE slug = $$reverse-savefile-flags$$;

UPDATE problem_translations SET
    description = $$32비트 부호 없는 정수 `statusWord`가 주어질 때, 32개 비트의 순서를 뒤집은 값을 반환하세요. 0번 비트(가장 낮은 비트)는 31번 자리로, 1번 비트는 30번 자리로 옮겨지는 식입니다. 결과도 부호 없는 32비트 값으로, `0` 이상 `2^32 - 1` 이하입니다.

휴대용 콘솔은 세이브 파일 플래그를 PC 에뮬레이터와 정반대 비트 순서로 읽기 때문에, 둘을 비교하기 전에 상태 워드의 비트를 뒤집어야 합니다.

**예시 1:**
```
입력: statusWord = 8
출력: 268435456
설명: 8은 3번 비트가 켜져 있습니다. 뒤집으면 그 비트가 28번 자리로 가서 2^28 = 268435456 이 됩니다.
```

**예시 2:**
```
입력: statusWord = 6
출력: 1610612736
설명: 6은 1번과 2번 비트가 켜져 있습니다. 뒤집으면 각각 30번, 29번 자리로 가서 2^30 + 2^29 = 1610612736 이 됩니다.
```

**예시 3:**
```
입력: statusWord = 1
출력: 2147483648
설명: 0번 비트가 31번 자리로 가서 2^31 = 2147483648 이 됩니다. 부호 있는 32비트 정수의 최댓값보다 1 큽니다.
```$$,
    constraints = $$- `0 <= statusWord <= 4294967295`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$reverse-savefile-flags$$);
