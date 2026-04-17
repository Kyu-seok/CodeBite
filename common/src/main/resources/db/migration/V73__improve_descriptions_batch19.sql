-- Improve descriptions: batch 19
-- Problems: zero-matrix, power-function, string-multiply, joyful-number, increment-digits,
--           fizz-buzz-game, mirror-number, numeral-converter, bit-tracker, flip-bits,
--           absent-number, bitwise-sum, power-check, bit-distance, stack-queue,
--           ring-buffer, hash-table, random-set, state-snapshots, click-counter

------------------------------------------------------------
-- zero-matrix
------------------------------------------------------------
UPDATE problems
SET description = 'Given an `m x n` integer matrix, modify it **in-place** so that if any element is `0`, its entire row and entire column are set to `0`.

You must propagate every original zero to fill its full row and column. Elements that were non-zero but share a row or column with a zero must also become `0`.

**Example 1:**
```
Input: matrix = [[1,1,1],[1,0,1],[1,1,1]]
Output: [[1,0,1],[0,0,0],[1,0,1]]
Explanation: The element at row 1, column 1 is 0, so all of row 1 and all of column 1 become 0.
```

**Example 2:**
```
Input: matrix = [[0,1,2,0],[3,4,5,2],[1,3,1,5]]
Output: [[0,0,0,0],[0,4,5,0],[0,3,1,0]]
Explanation: Row 0 has zeroes at columns 0 and 3, so column 0 and column 3 are fully zeroed, and row 0 is fully zeroed.
```

**Example 3:**
```
Input: matrix = [[1,2],[3,4]]
Output: [[1,2],[3,4]]
Explanation: No zeroes exist, so the matrix remains unchanged.
```'
WHERE slug = 'zero-matrix';

UPDATE problem_translations
SET description = 'Given an `m x n` integer matrix, modify it **in-place** so that if any element is `0`, its entire row and entire column are set to `0`.

You must propagate every original zero to fill its full row and column. Elements that were non-zero but share a row or column with a zero must also become `0`.

**Example 1:**
```
Input: matrix = [[1,1,1],[1,0,1],[1,1,1]]
Output: [[1,0,1],[0,0,0],[1,0,1]]
Explanation: The element at row 1, column 1 is 0, so all of row 1 and all of column 1 become 0.
```

**Example 2:**
```
Input: matrix = [[0,1,2,0],[3,4,5,2],[1,3,1,5]]
Output: [[0,0,0,0],[0,4,5,0],[0,3,1,0]]
Explanation: Row 0 has zeroes at columns 0 and 3, so column 0 and column 3 are fully zeroed, and row 0 is fully zeroed.
```

**Example 3:**
```
Input: matrix = [[1,2],[3,4]]
Output: [[1,2],[3,4]]
Explanation: No zeroes exist, so the matrix remains unchanged.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'zero-matrix')
  AND locale = 'en';

------------------------------------------------------------
-- power-function
------------------------------------------------------------
UPDATE problems
SET description = 'Given a floating-point number `x` and an integer `n`, compute `x` raised to the power `n` (i.e., `x^n`).

Your implementation must handle negative exponents. When `n` is negative, `x^n` equals `1 / x^|n|`. For example, `2^-2 = 1 / (2^2) = 0.25`.

A naive approach that multiplies `x` by itself `n` times will be too slow for large values of `n`. Consider how you can reduce the number of multiplications.

Return the result rounded to 5 decimal places.

**Example 1:**
```
Input: x = 2.00000, n = 10
Output: 1024.00000
```

**Example 2:**
```
Input: x = 2.10000, n = 3
Output: 9.26100
```

**Example 3:**
```
Input: x = 2.00000, n = -2
Output: 0.25000
Explanation: 2^-2 = 1 / (2^2) = 1/4 = 0.25
```'
WHERE slug = 'power-function';

UPDATE problem_translations
SET description = 'Given a floating-point number `x` and an integer `n`, compute `x` raised to the power `n` (i.e., `x^n`).

Your implementation must handle negative exponents. When `n` is negative, `x^n` equals `1 / x^|n|`. For example, `2^-2 = 1 / (2^2) = 0.25`.

A naive approach that multiplies `x` by itself `n` times will be too slow for large values of `n`. Consider how you can reduce the number of multiplications.

Return the result rounded to 5 decimal places.

**Example 1:**
```
Input: x = 2.00000, n = 10
Output: 1024.00000
```

**Example 2:**
```
Input: x = 2.10000, n = 3
Output: 9.26100
```

**Example 3:**
```
Input: x = 2.00000, n = -2
Output: 0.25000
Explanation: 2^-2 = 1 / (2^2) = 1/4 = 0.25
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'power-function')
  AND locale = 'en';

------------------------------------------------------------
-- string-multiply
------------------------------------------------------------
UPDATE problems
SET description = 'Given two non-negative integers represented as strings `num1` and `num2`, return their product as a string.

You must not use any built-in big integer library or convert the inputs directly to integers. Instead, perform the multiplication digit by digit, simulating the long multiplication process you would do by hand.

**Example 1:**
```
Input: num1 = "2", num2 = "3"
Output: "6"
```

**Example 2:**
```
Input: num1 = "123", num2 = "456"
Output: "56088"
```

**Example 3:**
```
Input: num1 = "99", num2 = "0"
Output: "0"
Explanation: Any number multiplied by zero is zero.
```'
WHERE slug = 'string-multiply';

UPDATE problem_translations
SET description = 'Given two non-negative integers represented as strings `num1` and `num2`, return their product as a string.

You must not use any built-in big integer library or convert the inputs directly to integers. Instead, perform the multiplication digit by digit, simulating the long multiplication process you would do by hand.

**Example 1:**
```
Input: num1 = "2", num2 = "3"
Output: "6"
```

**Example 2:**
```
Input: num1 = "123", num2 = "456"
Output: "56088"
```

**Example 3:**
```
Input: num1 = "99", num2 = "0"
Output: "0"
Explanation: Any number multiplied by zero is zero.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'string-multiply')
  AND locale = 'en';

------------------------------------------------------------
-- joyful-number
------------------------------------------------------------
UPDATE problems
SET description = 'Given a positive integer `n`, determine whether it is a **joyful number**.

A number is joyful if the following process eventually reaches `1`: take the sum of the squares of its digits, then repeat the process with the result. If the process enters an endless cycle without ever reaching `1`, the number is not joyful.

Return `true` if `n` is a joyful number, and `false` otherwise.

**Example 1:**
```
Input: n = 19
Output: true
Explanation: 1^2 + 9^2 = 82, 8^2 + 2^2 = 68, 6^2 + 8^2 = 100, 1^2 + 0^2 + 0^2 = 1
```

**Example 2:**
```
Input: n = 2
Output: false
Explanation: The digit-square sums cycle without ever reaching 1.
```

**Example 3:**
```
Input: n = 1
Output: true
```'
WHERE slug = 'joyful-number';

UPDATE problem_translations
SET description = 'Given a positive integer `n`, determine whether it is a **joyful number**.

A number is joyful if the following process eventually reaches `1`: take the sum of the squares of its digits, then repeat the process with the result. If the process enters an endless cycle without ever reaching `1`, the number is not joyful.

Return `true` if `n` is a joyful number, and `false` otherwise.

**Example 1:**
```
Input: n = 19
Output: true
Explanation: 1^2 + 9^2 = 82, 8^2 + 2^2 = 68, 6^2 + 8^2 = 100, 1^2 + 0^2 + 0^2 = 1
```

**Example 2:**
```
Input: n = 2
Output: false
Explanation: The digit-square sums cycle without ever reaching 1.
```

**Example 3:**
```
Input: n = 1
Output: true
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'joyful-number')
  AND locale = 'en';

------------------------------------------------------------
-- increment-digits
------------------------------------------------------------
UPDATE problems
SET description = 'You are given a non-negative integer represented as an array of its digits, where `digits[0]` is the most significant digit. Add one to the number and return the result as an array of digits.

The input does not contain leading zeros, except for the number zero itself, which is represented as `[0]`. Handle the carry correctly when digits overflow (e.g., `9 + 1 = 10`).

**Example 1:**
```
Input: digits = [1,2,3]
Output: [1,2,4]
Explanation: The number 123 becomes 124.
```

**Example 2:**
```
Input: digits = [9,9]
Output: [1,0,0]
Explanation: 99 + 1 = 100, which requires an extra digit.
```

**Example 3:**
```
Input: digits = [0]
Output: [1]
```'
WHERE slug = 'increment-digits';

UPDATE problem_translations
SET description = 'You are given a non-negative integer represented as an array of its digits, where `digits[0]` is the most significant digit. Add one to the number and return the result as an array of digits.

The input does not contain leading zeros, except for the number zero itself, which is represented as `[0]`. Handle the carry correctly when digits overflow (e.g., `9 + 1 = 10`).

**Example 1:**
```
Input: digits = [1,2,3]
Output: [1,2,4]
Explanation: The number 123 becomes 124.
```

**Example 2:**
```
Input: digits = [9,9]
Output: [1,0,0]
Explanation: 99 + 1 = 100, which requires an extra digit.
```

**Example 3:**
```
Input: digits = [0]
Output: [1]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'increment-digits')
  AND locale = 'en';

------------------------------------------------------------
-- fizz-buzz-game
------------------------------------------------------------
UPDATE problems
SET description = 'Given a positive integer `n`, build an array of strings for each number from `1` to `n` using the following rules:

- If the number is divisible by both 3 and 5, use `"FizzBuzz"`.
- If the number is divisible by 3 only, use `"Fizz"`.
- If the number is divisible by 5 only, use `"Buzz"`.
- Otherwise, use the number itself converted to a string.

Return the resulting array.

**Example 1:**
```
Input: n = 3
Output: ["1","2","Fizz"]
```

**Example 2:**
```
Input: n = 5
Output: ["1","2","Fizz","4","Buzz"]
```

**Example 3:**
```
Input: n = 15
Output: ["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]
```'
WHERE slug = 'fizz-buzz-game';

UPDATE problem_translations
SET description = 'Given a positive integer `n`, build an array of strings for each number from `1` to `n` using the following rules:

- If the number is divisible by both 3 and 5, use `"FizzBuzz"`.
- If the number is divisible by 3 only, use `"Fizz"`.
- If the number is divisible by 5 only, use `"Buzz"`.
- Otherwise, use the number itself converted to a string.

Return the resulting array.

**Example 1:**
```
Input: n = 3
Output: ["1","2","Fizz"]
```

**Example 2:**
```
Input: n = 5
Output: ["1","2","Fizz","4","Buzz"]
```

**Example 3:**
```
Input: n = 15
Output: ["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fizz-buzz-game')
  AND locale = 'en';

------------------------------------------------------------
-- mirror-number
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer `x`, return `true` if `x` reads the same forwards and backwards, and `false` otherwise.

Negative numbers are never mirror numbers because of the leading minus sign. For example, `-121` reversed would read `121-`, which is not the same.

**Example 1:**
```
Input: x = 121
Output: true
Explanation: 121 reversed is still 121.
```

**Example 2:**
```
Input: x = -45
Output: false
Explanation: Negative numbers cannot be mirror numbers due to the leading minus sign.
```

**Example 3:**
```
Input: x = 10
Output: false
Explanation: 10 reversed is 01, which is not equal to 10.
```'
WHERE slug = 'mirror-number';

UPDATE problem_translations
SET description = 'Given an integer `x`, return `true` if `x` reads the same forwards and backwards, and `false` otherwise.

Negative numbers are never mirror numbers because of the leading minus sign. For example, `-121` reversed would read `121-`, which is not the same.

**Example 1:**
```
Input: x = 121
Output: true
Explanation: 121 reversed is still 121.
```

**Example 2:**
```
Input: x = -45
Output: false
Explanation: Negative numbers cannot be mirror numbers due to the leading minus sign.
```

**Example 3:**
```
Input: x = 10
Output: false
Explanation: 10 reversed is 01, which is not equal to 10.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'mirror-number')
  AND locale = 'en';

------------------------------------------------------------
-- numeral-converter
------------------------------------------------------------
UPDATE problems
SET description = 'Given a string `s` representing a Roman numeral, convert it to its integer value.

Roman numerals use seven symbols:
- `I` = 1, `V` = 5, `X` = 10, `L` = 50, `C` = 100, `D` = 500, `M` = 1000

Symbols are normally written largest to smallest from left to right. However, when a smaller symbol appears directly before a larger one, it represents subtraction. For example, `IV` equals 4 (5 - 1) and `IX` equals 9 (10 - 1).

The six valid subtractive combinations are:
- `IV` = 4, `IX` = 9
- `XL` = 40, `XC` = 90
- `CD` = 400, `CM` = 900

Return the integer value of the given Roman numeral.

**Example 1:**
```
Input: s = "III"
Output: 3
Explanation: I + I + I = 3.
```

**Example 2:**
```
Input: s = "LVIII"
Output: 58
Explanation: L + V + I + I + I = 50 + 5 + 1 + 1 + 1 = 58.
```

**Example 3:**
```
Input: s = "MCMXCIV"
Output: 1994
Explanation: M + CM + XC + IV = 1000 + 900 + 90 + 4 = 1994.
```'
WHERE slug = 'numeral-converter';

UPDATE problem_translations
SET description = 'Given a string `s` representing a Roman numeral, convert it to its integer value.

Roman numerals use seven symbols:
- `I` = 1, `V` = 5, `X` = 10, `L` = 50, `C` = 100, `D` = 500, `M` = 1000

Symbols are normally written largest to smallest from left to right. However, when a smaller symbol appears directly before a larger one, it represents subtraction. For example, `IV` equals 4 (5 - 1) and `IX` equals 9 (10 - 1).

The six valid subtractive combinations are:
- `IV` = 4, `IX` = 9
- `XL` = 40, `XC` = 90
- `CD` = 400, `CM` = 900

Return the integer value of the given Roman numeral.

**Example 1:**
```
Input: s = "III"
Output: 3
Explanation: I + I + I = 3.
```

**Example 2:**
```
Input: s = "LVIII"
Output: 58
Explanation: L + V + I + I + I = 50 + 5 + 1 + 1 + 1 = 58.
```

**Example 3:**
```
Input: s = "MCMXCIV"
Output: 1994
Explanation: M + CM + XC + IV = 1000 + 900 + 90 + 4 = 1994.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'numeral-converter')
  AND locale = 'en';

------------------------------------------------------------
-- bit-tracker
------------------------------------------------------------
UPDATE problems
SET description = 'Given a non-negative integer `n`, return an array `answer` of length `n + 1` where `answer[i]` is the number of `1` bits in the binary representation of `i`.

In other words, for every integer from `0` to `n`, count how many bits are set to `1` and store that count at the corresponding index.

**Example 1:**
```
Input: n = 2
Output: [0,1,1]
Explanation: 0 = 0b0 (zero 1s), 1 = 0b1 (one 1), 2 = 0b10 (one 1)
```

**Example 2:**
```
Input: n = 5
Output: [0,1,1,2,1,2]
Explanation: 0 through 5 in binary are 0, 1, 10, 11, 100, 101
```

**Example 3:**
```
Input: n = 0
Output: [0]
```'
WHERE slug = 'bit-tracker';

UPDATE problem_translations
SET description = 'Given a non-negative integer `n`, return an array `answer` of length `n + 1` where `answer[i]` is the number of `1` bits in the binary representation of `i`.

In other words, for every integer from `0` to `n`, count how many bits are set to `1` and store that count at the corresponding index.

**Example 1:**
```
Input: n = 2
Output: [0,1,1]
Explanation: 0 = 0b0 (zero 1s), 1 = 0b1 (one 1), 2 = 0b10 (one 1)
```

**Example 2:**
```
Input: n = 5
Output: [0,1,1,2,1,2]
Explanation: 0 through 5 in binary are 0, 1, 10, 11, 100, 101
```

**Example 3:**
```
Input: n = 0
Output: [0]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bit-tracker')
  AND locale = 'en';

------------------------------------------------------------
-- flip-bits
------------------------------------------------------------
UPDATE problems
SET description = 'Given a 32-bit unsigned integer `n`, reverse the order of all 32 bits and return the result as an unsigned integer.

Bit 0 (the least significant bit) of the input becomes bit 31 (the most significant bit) of the output, bit 1 becomes bit 30, and so on for all 32 positions.

**Example 1:**
```
Input: n = 43261596
Output: 964176192
Explanation: 43261596 in binary is 00000010100101000001111010011100. Reversing the bits gives 00111001011110000010100101000000, which is 964176192.
```

**Example 2:**
```
Input: n = 4294967293
Output: 3221225471
Explanation: 4294967293 in binary is 11111111111111111111111111111101. Reversing gives 10111111111111111111111111111111, which is 3221225471.
```

**Example 3:**
```
Input: n = 1
Output: 2147483648
Explanation: Only bit 0 is set. After reversal it moves to bit 31, producing 2147483648.
```'
WHERE slug = 'flip-bits';

UPDATE problem_translations
SET description = 'Given a 32-bit unsigned integer `n`, reverse the order of all 32 bits and return the result as an unsigned integer.

Bit 0 (the least significant bit) of the input becomes bit 31 (the most significant bit) of the output, bit 1 becomes bit 30, and so on for all 32 positions.

**Example 1:**
```
Input: n = 43261596
Output: 964176192
Explanation: 43261596 in binary is 00000010100101000001111010011100. Reversing the bits gives 00111001011110000010100101000000, which is 964176192.
```

**Example 2:**
```
Input: n = 4294967293
Output: 3221225471
Explanation: 4294967293 in binary is 11111111111111111111111111111101. Reversing gives 10111111111111111111111111111111, which is 3221225471.
```

**Example 3:**
```
Input: n = 1
Output: 2147483648
Explanation: Only bit 0 is set. After reversal it moves to bit 31, producing 2147483648.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flip-bits')
  AND locale = 'en';

------------------------------------------------------------
-- absent-number
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array `nums` containing `n` distinct integers from the range `[0, n]`, return the one number in that range that is missing from the array.

Since there are `n + 1` possible values (`0` through `n`) but only `n` elements in the array, exactly one value is absent.

**Example 1:**
```
Input: nums = [3,0,1]
Output: 2
Explanation: The array has length 3, so the full range is [0, 1, 2, 3]. The value 2 is absent.
```

**Example 2:**
```
Input: nums = [0,1]
Output: 2
Explanation: The array has length 2, so the full range is [0, 1, 2]. The value 2 is absent.
```

**Example 3:**
```
Input: nums = [9,6,4,2,3,5,7,0,1]
Output: 8
```'
WHERE slug = 'absent-number';

UPDATE problem_translations
SET description = 'Given an array `nums` containing `n` distinct integers from the range `[0, n]`, return the one number in that range that is missing from the array.

Since there are `n + 1` possible values (`0` through `n`) but only `n` elements in the array, exactly one value is absent.

**Example 1:**
```
Input: nums = [3,0,1]
Output: 2
Explanation: The array has length 3, so the full range is [0, 1, 2, 3]. The value 2 is absent.
```

**Example 2:**
```
Input: nums = [0,1]
Output: 2
Explanation: The array has length 2, so the full range is [0, 1, 2]. The value 2 is absent.
```

**Example 3:**
```
Input: nums = [9,6,4,2,3,5,7,0,1]
Output: 8
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'absent-number')
  AND locale = 'en';

------------------------------------------------------------
-- bitwise-sum
------------------------------------------------------------
UPDATE problems
SET description = 'Given two integers `a` and `b`, return their sum without using the `+` or `-` operators.

You must compute the result using only bitwise operations (AND, OR, XOR, NOT, shifts). Think about how binary addition works at the bit level: XOR gives the sum without carries, and AND followed by a left shift gives the carry bits.

**Example 1:**
```
Input: a = 3, b = 5
Output: 8
```

**Example 2:**
```
Input: a = -7, b = 3
Output: -4
```

**Example 3:**
```
Input: a = 0, b = 0
Output: 0
```'
WHERE slug = 'bitwise-sum';

UPDATE problem_translations
SET description = 'Given two integers `a` and `b`, return their sum without using the `+` or `-` operators.

You must compute the result using only bitwise operations (AND, OR, XOR, NOT, shifts). Think about how binary addition works at the bit level: XOR gives the sum without carries, and AND followed by a left shift gives the carry bits.

**Example 1:**
```
Input: a = 3, b = 5
Output: 8
```

**Example 2:**
```
Input: a = -7, b = 3
Output: -4
```

**Example 3:**
```
Input: a = 0, b = 0
Output: 0
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bitwise-sum')
  AND locale = 'en';

------------------------------------------------------------
-- power-check
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer `n`, return `true` if it is a power of two, and `false` otherwise.

A number is a power of two if there exists a non-negative integer `k` such that `n == 2^k`. Note that `2^0 = 1`, so `1` is a power of two. Non-positive numbers (zero and negatives) are never powers of two.

**Example 1:**
```
Input: n = 1
Output: true
Explanation: 2^0 = 1.
```

**Example 2:**
```
Input: n = 16
Output: true
Explanation: 2^4 = 16.
```

**Example 3:**
```
Input: n = 6
Output: false
```'
WHERE slug = 'power-check';

UPDATE problem_translations
SET description = 'Given an integer `n`, return `true` if it is a power of two, and `false` otherwise.

A number is a power of two if there exists a non-negative integer `k` such that `n == 2^k`. Note that `2^0 = 1`, so `1` is a power of two. Non-positive numbers (zero and negatives) are never powers of two.

**Example 1:**
```
Input: n = 1
Output: true
Explanation: 2^0 = 1.
```

**Example 2:**
```
Input: n = 16
Output: true
Explanation: 2^4 = 16.
```

**Example 3:**
```
Input: n = 6
Output: false
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'power-check')
  AND locale = 'en';

------------------------------------------------------------
-- bit-distance
------------------------------------------------------------
UPDATE problems
SET description = 'Given two integers `x` and `y`, return the number of bit positions where their binary representations differ. This count is known as the **Hamming distance**.

Compare each corresponding bit of `x` and `y`. Every position where one has a `1` and the other has a `0` contributes one to the distance.

**Example 1:**
```
Input: x = 1, y = 4
Output: 2
Explanation: 1 in binary is 001 and 4 is 100. They differ at positions 0 and 2.
```

**Example 2:**
```
Input: x = 3, y = 1
Output: 1
Explanation: 3 is 11 and 1 is 01. Only position 1 differs.
```

**Example 3:**
```
Input: x = 0, y = 0
Output: 0
Explanation: Both values are identical, so no bits differ.
```'
WHERE slug = 'bit-distance';

UPDATE problem_translations
SET description = 'Given two integers `x` and `y`, return the number of bit positions where their binary representations differ. This count is known as the **Hamming distance**.

Compare each corresponding bit of `x` and `y`. Every position where one has a `1` and the other has a `0` contributes one to the distance.

**Example 1:**
```
Input: x = 1, y = 4
Output: 2
Explanation: 1 in binary is 001 and 4 is 100. They differ at positions 0 and 2.
```

**Example 2:**
```
Input: x = 3, y = 1
Output: 1
Explanation: 3 is 11 and 1 is 01. Only position 1 differs.
```

**Example 3:**
```
Input: x = 0, y = 0
Output: 0
Explanation: Both values are identical, so no bits differ.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bit-distance')
  AND locale = 'en';

------------------------------------------------------------
-- stack-queue
------------------------------------------------------------
UPDATE problems
SET description = 'Design a **first-in, first-out (FIFO) queue** using only two stacks. Your queue must support the standard operations: adding to the back, removing from the front, peeking at the front, and checking if empty.

Implement the `StackQueue` class:
- `StackQueue()` -- initializes an empty queue.
- `void push(int x)` -- adds element `x` to the back of the queue.
- `int pop()` -- removes and returns the element at the front of the queue.
- `int peek()` -- returns the front element without removing it.
- `boolean empty()` -- returns `true` if the queue has no elements, `false` otherwise.

You may only use standard stack operations: push to top, pop from top, peek at top, and check if empty. No other data structure is allowed besides two stacks.

**Example 1:**
```
Input:
["StackQueue","push","push","peek","pop","empty"]
[[],[1],[2],[],[],[]]
Output: [null,null,null,1,1,false]
Explanation: After pushing 1 and 2, peek returns 1 (front of queue). Pop removes and returns 1. The queue still has 2, so empty returns false.
```

**Example 2:**
```
Input:
["StackQueue","push","push","push","pop","pop","peek","empty"]
[[],[10],[20],[30],[],[],[],[]]
Output: [null,null,null,null,10,20,30,false]
Explanation: Elements are dequeued in the same order they were enqueued: 10, 20, then peek shows 30.
```

**Example 3:**
```
Input:
["StackQueue","push","pop","empty"]
[[],[42],[],[]]
Output: [null,null,42,true]
Explanation: After pushing 42 and then popping it, the queue is empty.
```'
WHERE slug = 'stack-queue';

UPDATE problem_translations
SET description = 'Design a **first-in, first-out (FIFO) queue** using only two stacks. Your queue must support the standard operations: adding to the back, removing from the front, peeking at the front, and checking if empty.

Implement the `StackQueue` class:
- `StackQueue()` -- initializes an empty queue.
- `void push(int x)` -- adds element `x` to the back of the queue.
- `int pop()` -- removes and returns the element at the front of the queue.
- `int peek()` -- returns the front element without removing it.
- `boolean empty()` -- returns `true` if the queue has no elements, `false` otherwise.

You may only use standard stack operations: push to top, pop from top, peek at top, and check if empty. No other data structure is allowed besides two stacks.

**Example 1:**
```
Input:
["StackQueue","push","push","peek","pop","empty"]
[[],[1],[2],[],[],[]]
Output: [null,null,null,1,1,false]
Explanation: After pushing 1 and 2, peek returns 1 (front of queue). Pop removes and returns 1. The queue still has 2, so empty returns false.
```

**Example 2:**
```
Input:
["StackQueue","push","push","push","pop","pop","peek","empty"]
[[],[10],[20],[30],[],[],[],[]]
Output: [null,null,null,null,10,20,30,false]
Explanation: Elements are dequeued in the same order they were enqueued: 10, 20, then peek shows 30.
```

**Example 3:**
```
Input:
["StackQueue","push","pop","empty"]
[[],[42],[],[]]
Output: [null,null,42,true]
Explanation: After pushing 42 and then popping it, the queue is empty.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'stack-queue')
  AND locale = 'en';

------------------------------------------------------------
-- ring-buffer
------------------------------------------------------------
UPDATE problems
SET description = 'Design a **circular queue** (ring buffer) with a fixed maximum capacity. The buffer reuses space by wrapping around when it reaches the end of its internal storage.

Implement the `RingBuffer` class:
- `RingBuffer(int k)` -- initializes the buffer with a maximum capacity of `k`.
- `boolean enQueue(int value)` -- inserts an element at the rear. Returns `true` if successful, or `false` if the buffer is full.
- `boolean deQueue()` -- removes the element at the front. Returns `true` if successful, or `false` if the buffer is empty.
- `int front()` -- returns the front element, or `-1` if the buffer is empty.
- `int rear()` -- returns the rear element, or `-1` if the buffer is empty.
- `boolean isEmpty()` -- returns `true` if the buffer contains no elements.
- `boolean isFull()` -- returns `true` if the buffer has reached its maximum capacity.

**Example 1:**
```
Input:
["RingBuffer","enQueue","enQueue","enQueue","enQueue","rear","isFull","deQueue","enQueue","rear"]
[[3],[1],[2],[3],[4],[],[],[],[4],[]]
Output: [null,true,true,true,false,3,true,true,true,4]
Explanation: The buffer has capacity 3. After inserting 1, 2, 3 it is full, so inserting 4 fails. After removing the front element (1), inserting 4 succeeds.
```

**Example 2:**
```
Input:
["RingBuffer","enQueue","deQueue","front","deQueue"]
[[2],[5],[],[],[]]
Output: [null,true,true,-1,false]
Explanation: After enqueuing 5 and dequeuing it, front() returns -1 because the buffer is empty. The second deQueue also fails.
```

**Example 3:**
```
Input:
["RingBuffer","isEmpty","enQueue","isEmpty","isFull","enQueue","isFull"]
[[2],[],[1],[],[],[2],[]]
Output: [null,true,true,false,false,true,true]
Explanation: A fresh buffer is empty. After adding one element it is no longer empty. After adding a second it becomes full.
```'
WHERE slug = 'ring-buffer';

UPDATE problem_translations
SET description = 'Design a **circular queue** (ring buffer) with a fixed maximum capacity. The buffer reuses space by wrapping around when it reaches the end of its internal storage.

Implement the `RingBuffer` class:
- `RingBuffer(int k)` -- initializes the buffer with a maximum capacity of `k`.
- `boolean enQueue(int value)` -- inserts an element at the rear. Returns `true` if successful, or `false` if the buffer is full.
- `boolean deQueue()` -- removes the element at the front. Returns `true` if successful, or `false` if the buffer is empty.
- `int front()` -- returns the front element, or `-1` if the buffer is empty.
- `int rear()` -- returns the rear element, or `-1` if the buffer is empty.
- `boolean isEmpty()` -- returns `true` if the buffer contains no elements.
- `boolean isFull()` -- returns `true` if the buffer has reached its maximum capacity.

**Example 1:**
```
Input:
["RingBuffer","enQueue","enQueue","enQueue","enQueue","rear","isFull","deQueue","enQueue","rear"]
[[3],[1],[2],[3],[4],[],[],[],[4],[]]
Output: [null,true,true,true,false,3,true,true,true,4]
Explanation: The buffer has capacity 3. After inserting 1, 2, 3 it is full, so inserting 4 fails. After removing the front element (1), inserting 4 succeeds.
```

**Example 2:**
```
Input:
["RingBuffer","enQueue","deQueue","front","deQueue"]
[[2],[5],[],[],[]]
Output: [null,true,true,-1,false]
Explanation: After enqueuing 5 and dequeuing it, front() returns -1 because the buffer is empty. The second deQueue also fails.
```

**Example 3:**
```
Input:
["RingBuffer","isEmpty","enQueue","isEmpty","isFull","enQueue","isFull"]
[[2],[],[1],[],[],[2],[]]
Output: [null,true,true,false,false,true,true]
Explanation: A fresh buffer is empty. After adding one element it is no longer empty. After adding a second it becomes full.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ring-buffer')
  AND locale = 'en';

------------------------------------------------------------
-- hash-table
------------------------------------------------------------
UPDATE problems
SET description = 'Design a hash map from scratch without using any built-in hash map or dictionary library. Your implementation must support inserting, retrieving, and removing key-value pairs.

Implement the `SimpleHashMap` class:
- `SimpleHashMap()` -- creates an empty map.
- `void put(int key, int value)` -- inserts the pair `(key, value)`. If the key already exists, update its value.
- `int get(int key)` -- returns the value mapped to `key`, or `-1` if the key is not present.
- `void remove(int key)` -- removes the key and its value. Does nothing if the key does not exist.

**Example 1:**
```
Input: ["SimpleHashMap","put","put","get","get","put","get","remove","get"] / [[],[1,10],[2,20],[1],[3],[2,30],[2],[2],[2]]
Output: [null,null,null,10,-1,null,30,null,-1]
Explanation: After putting (1,10) and (2,20), get(1) returns 10, get(3) returns -1. Updating key 2 to 30, get(2) returns 30. After removing key 2, get(2) returns -1.
```

**Example 2:**
```
Input: ["SimpleHashMap","put","put","put","get","get","get"] / [[],[5,50],[10,100],[15,150],[5],[10],[15]]
Output: [null,null,null,null,50,100,150]
```

**Example 3:**
```
Input: ["SimpleHashMap","get","remove","get"] / [[],[7],[7],[7]]
Output: [null,-1,null,-1]
Explanation: Getting and removing keys from an empty map returns -1 and does nothing, respectively.
```'
WHERE slug = 'hash-table';

UPDATE problem_translations
SET description = 'Design a hash map from scratch without using any built-in hash map or dictionary library. Your implementation must support inserting, retrieving, and removing key-value pairs.

Implement the `SimpleHashMap` class:
- `SimpleHashMap()` -- creates an empty map.
- `void put(int key, int value)` -- inserts the pair `(key, value)`. If the key already exists, update its value.
- `int get(int key)` -- returns the value mapped to `key`, or `-1` if the key is not present.
- `void remove(int key)` -- removes the key and its value. Does nothing if the key does not exist.

**Example 1:**
```
Input: ["SimpleHashMap","put","put","get","get","put","get","remove","get"] / [[],[1,10],[2,20],[1],[3],[2,30],[2],[2],[2]]
Output: [null,null,null,10,-1,null,30,null,-1]
Explanation: After putting (1,10) and (2,20), get(1) returns 10, get(3) returns -1. Updating key 2 to 30, get(2) returns 30. After removing key 2, get(2) returns -1.
```

**Example 2:**
```
Input: ["SimpleHashMap","put","put","put","get","get","get"] / [[],[5,50],[10,100],[15,150],[5],[10],[15]]
Output: [null,null,null,null,50,100,150]
```

**Example 3:**
```
Input: ["SimpleHashMap","get","remove","get"] / [[],[7],[7],[7]]
Output: [null,-1,null,-1]
Explanation: Getting and removing keys from an empty map returns -1 and does nothing, respectively.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'hash-table')
  AND locale = 'en';

------------------------------------------------------------
-- random-set
------------------------------------------------------------
UPDATE problems
SET description = 'Design a data structure that supports inserting, removing, and retrieving a random element, each in average `O(1)` time.

Implement the `RandomSet` class:
- `RandomSet()` -- creates an empty set.
- `boolean insert(int val)` -- adds `val` to the set. Returns `true` if the element was not already present, or `false` if it already existed.
- `boolean remove(int val)` -- removes `val` from the set. Returns `true` if the element was found and removed, or `false` if it was not present.
- `int getRandom()` -- returns a uniformly random element from the current set. Every element must have an equal probability of being chosen. This method is only called when the set is non-empty.

**Example 1:**
```
Input: ["RandomSet","insert","insert","remove","getRandom"] / [[],[1],[2],[1],[]]
Output: [null,true,true,true,2]
Explanation: After inserting 1 and 2, then removing 1, only 2 remains. getRandom returns 2.
```

**Example 2:**
```
Input: ["RandomSet","insert","insert","remove","insert","remove","getRandom"] / [[],[5],[5],[5],[5],[10],[]]
Output: [null,true,false,true,true,false,5]
Explanation: Second insert(5) returns false since 5 is already present. remove(10) returns false since 10 is not in the set. Only 5 remains, so getRandom returns 5.
```

**Example 3:**
```
Input: ["RandomSet","insert","remove","remove","insert","getRandom"] / [[],[7],[7],[7],[7],[]]
Output: [null,true,true,false,true,7]
Explanation: insert(7) then remove(7) empties the set. Second remove(7) returns false. Re-inserting 7 makes it the only element, so getRandom returns 7.
```'
WHERE slug = 'random-set';

UPDATE problem_translations
SET description = 'Design a data structure that supports inserting, removing, and retrieving a random element, each in average `O(1)` time.

Implement the `RandomSet` class:
- `RandomSet()` -- creates an empty set.
- `boolean insert(int val)` -- adds `val` to the set. Returns `true` if the element was not already present, or `false` if it already existed.
- `boolean remove(int val)` -- removes `val` from the set. Returns `true` if the element was found and removed, or `false` if it was not present.
- `int getRandom()` -- returns a uniformly random element from the current set. Every element must have an equal probability of being chosen. This method is only called when the set is non-empty.

**Example 1:**
```
Input: ["RandomSet","insert","insert","remove","getRandom"] / [[],[1],[2],[1],[]]
Output: [null,true,true,true,2]
Explanation: After inserting 1 and 2, then removing 1, only 2 remains. getRandom returns 2.
```

**Example 2:**
```
Input: ["RandomSet","insert","insert","remove","insert","remove","getRandom"] / [[],[5],[5],[5],[5],[10],[]]
Output: [null,true,false,true,true,false,5]
Explanation: Second insert(5) returns false since 5 is already present. remove(10) returns false since 10 is not in the set. Only 5 remains, so getRandom returns 5.
```

**Example 3:**
```
Input: ["RandomSet","insert","remove","remove","insert","getRandom"] / [[],[7],[7],[7],[7],[]]
Output: [null,true,true,false,true,7]
Explanation: insert(7) then remove(7) empties the set. Second remove(7) returns false. Re-inserting 7 makes it the only element, so getRandom returns 7.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'random-set')
  AND locale = 'en';

------------------------------------------------------------
-- state-snapshots
------------------------------------------------------------
UPDATE problems
SET description = 'Design a data structure that supports setting values at specific indices, taking snapshots of the current state, and querying historical values from any previous snapshot.

Implement the `SnapshotArray` class:
- `SnapshotArray(int length)` -- initializes an array of the given `length` with all elements set to `0`.
- `void set(int index, int val)` -- sets the element at `index` to `val`.
- `int snap()` -- takes a snapshot of the current array state and returns the snapshot id. The first call returns `0`, the second returns `1`, and so on.
- `int get(int index, int snapId)` -- returns the value at `index` as it was when the snapshot with `snapId` was taken.

**Example 1:**
```
Input:
["SnapshotArray","set","snap","set","get"]
[[3],[0,5],[],[0,6],[0,0]]
Output: [null,null,0,null,5]
Explanation: After set(0, 5), snap saves as id 0. Then set(0, 6) changes the value. get(0, 0) retrieves the value from snapshot 0, which is 5.
```

**Example 2:**
```
Input:
["SnapshotArray","set","set","snap","set","snap","get","get"]
[[2],[0,10],[1,20],[],[0,30],[],[0,0],[0,1]]
Output: [null,null,null,0,null,1,10,30]
Explanation: Snapshot 0 captures [10, 20]. After set(0, 30), snapshot 1 captures [30, 20]. get(0, 0) returns 10 and get(0, 1) returns 30.
```

**Example 3:**
```
Input:
["SnapshotArray","snap","get","set","snap","get"]
[[1],[],[0,0],[0,7],[],[0,1]]
Output: [null,0,0,null,1,7]
Explanation: Snapshot 0 is taken immediately (all zeros). After setting index 0 to 7, snapshot 1 captures that. get(0, 1) returns 7.
```'
WHERE slug = 'state-snapshots';

UPDATE problem_translations
SET description = 'Design a data structure that supports setting values at specific indices, taking snapshots of the current state, and querying historical values from any previous snapshot.

Implement the `SnapshotArray` class:
- `SnapshotArray(int length)` -- initializes an array of the given `length` with all elements set to `0`.
- `void set(int index, int val)` -- sets the element at `index` to `val`.
- `int snap()` -- takes a snapshot of the current array state and returns the snapshot id. The first call returns `0`, the second returns `1`, and so on.
- `int get(int index, int snapId)` -- returns the value at `index` as it was when the snapshot with `snapId` was taken.

**Example 1:**
```
Input:
["SnapshotArray","set","snap","set","get"]
[[3],[0,5],[],[0,6],[0,0]]
Output: [null,null,0,null,5]
Explanation: After set(0, 5), snap saves as id 0. Then set(0, 6) changes the value. get(0, 0) retrieves the value from snapshot 0, which is 5.
```

**Example 2:**
```
Input:
["SnapshotArray","set","set","snap","set","snap","get","get"]
[[2],[0,10],[1,20],[],[0,30],[],[0,0],[0,1]]
Output: [null,null,null,0,null,1,10,30]
Explanation: Snapshot 0 captures [10, 20]. After set(0, 30), snapshot 1 captures [30, 20]. get(0, 0) returns 10 and get(0, 1) returns 30.
```

**Example 3:**
```
Input:
["SnapshotArray","snap","get","set","snap","get"]
[[1],[],[0,0],[0,7],[],[0,1]]
Output: [null,0,0,null,1,7]
Explanation: Snapshot 0 is taken immediately (all zeros). After setting index 0 to 7, snapshot 1 captures that. get(0, 1) returns 7.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'state-snapshots')
  AND locale = 'en';

------------------------------------------------------------
-- click-counter
------------------------------------------------------------
UPDATE problems
SET description = 'Design a counter that tracks the number of hits received in the past 300 seconds (5 minutes).

Implement the `HitCounter` class:
- `HitCounter()` -- initializes the counter with zero hits.
- `void hit(int timestamp)` -- records a hit at the given `timestamp` (in seconds). Multiple hits may share the same timestamp.
- `int getHits(int timestamp)` -- returns the total number of hits in the time window `[timestamp - 299, timestamp]`, inclusive on both ends.

All timestamps are provided in strictly non-decreasing order across all calls to `hit` and `getHits`.

**Example 1:**
```
Input: ["HitCounter","hit","hit","hit","getHits","hit","getHits","getHits"] / [[],[1],[2],[3],[4],[300],[300],[301]]
Output: [null,null,null,null,3,null,4,3]
Explanation: At timestamp 4, all 3 earlier hits (at 1, 2, 3) fall within the window [4-299, 4]. At timestamp 300, the hit at 1 is still in range [1, 300], so getHits returns 4. At timestamp 301, the hit at 1 is now outside the window [2, 301], so getHits returns 3.
```

**Example 2:**
```
Input: ["HitCounter","hit","hit","hit","getHits"] / [[],[100],[100],[100],[100]]
Output: [null,null,null,null,3]
Explanation: Three hits at the same timestamp are all counted.
```

**Example 3:**
```
Input: ["HitCounter","getHits","hit","getHits"] / [[],[1],[2],[300]]
Output: [null,0,null,1]
Explanation: Querying before any hits returns 0. The hit at timestamp 2 is still within the window at timestamp 300.
```'
WHERE slug = 'click-counter';

UPDATE problem_translations
SET description = 'Design a counter that tracks the number of hits received in the past 300 seconds (5 minutes).

Implement the `HitCounter` class:
- `HitCounter()` -- initializes the counter with zero hits.
- `void hit(int timestamp)` -- records a hit at the given `timestamp` (in seconds). Multiple hits may share the same timestamp.
- `int getHits(int timestamp)` -- returns the total number of hits in the time window `[timestamp - 299, timestamp]`, inclusive on both ends.

All timestamps are provided in strictly non-decreasing order across all calls to `hit` and `getHits`.

**Example 1:**
```
Input: ["HitCounter","hit","hit","hit","getHits","hit","getHits","getHits"] / [[],[1],[2],[3],[4],[300],[300],[301]]
Output: [null,null,null,null,3,null,4,3]
Explanation: At timestamp 4, all 3 earlier hits (at 1, 2, 3) fall within the window [4-299, 4]. At timestamp 300, the hit at 1 is still in range [1, 300], so getHits returns 4. At timestamp 301, the hit at 1 is now outside the window [2, 301], so getHits returns 3.
```

**Example 2:**
```
Input: ["HitCounter","hit","hit","hit","getHits"] / [[],[100],[100],[100],[100]]
Output: [null,null,null,null,3]
Explanation: Three hits at the same timestamp are all counted.
```

**Example 3:**
```
Input: ["HitCounter","getHits","hit","getHits"] / [[],[1],[2],[300]]
Output: [null,0,null,1]
Explanation: Querying before any hits returns 0. The hit at timestamp 2 is still within the window at timestamp 300.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'click-counter')
  AND locale = 'en';
