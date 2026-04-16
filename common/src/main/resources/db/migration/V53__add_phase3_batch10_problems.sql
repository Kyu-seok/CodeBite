-- Phase 3 Batch 10: Bit Manipulation (#189-194) + Design (#195-200)
-- 12 problems: bit-tracker, flip-bits, absent-number, bitwise-sum, power-check, bit-distance, stack-queue, ring-buffer, hash-table, random-set, state-snapshots, click-counter

------------------------------------------------------------
-- Add Bit Tracker problem
-- CodeBite original name: Bit Tracker (inspired by Counting Bits, LC #338)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Bit Tracker',
    'bit-tracker',
    'Given a non-negative integer `n`, return an array `answer` of length `n + 1` where `answer[i]` is the number of `1`s in the binary representation of `i`.

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
```',
    'EASY',
    '0 <= n <= 10^5',
    189,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'bit-tracker'), '2', '[0,1,1]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'bit-tracker'), '5', '[0,1,1,2,1,2]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'bit-tracker'), '0', '[0]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'bit-tracker'), '1', '[0,1]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'bit-tracker'), '8', '[0,1,1,2,1,2,2,3,1]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'bit-tracker'), '15', '[0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'bit-tracker'),
    'en',
    'Bit Tracker',
    'Given a non-negative integer `n`, return an array `answer` of length `n + 1` where `answer[i]` is the number of `1`s in the binary representation of `i`.

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
```',
    '0 <= n <= 10^5'
);

------------------------------------------------------------
-- Add Flip Bits problem
-- CodeBite original name: Flip Bits (inspired by LeetCode #190 Reverse Bits)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Flip Bits',
    'flip-bits',
    'Given a 32-bit unsigned integer `n`, reverse the order of its bits and return the result as an unsigned integer.

In other words, bit 0 of the input should become bit 31 of the output, bit 1 should become bit 30, and so on.

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
```',
    'EASY',
    'The input is a 32-bit unsigned integer (0 <= n <= 2^32 - 1).',
    190,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'flip-bits'), '43261596', '964176192', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'flip-bits'), '4294967293', '3221225471', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'flip-bits'), '1', '2147483648', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'flip-bits'), '0', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'flip-bits'), '4294967295', '4294967295', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'flip-bits'), '2147483648', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'flip-bits'), '6', '1610612736', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'flip-bits'),
    'en',
    'Flip Bits',
    'Given a 32-bit unsigned integer `n`, reverse the order of its bits and return the result as an unsigned integer.

In other words, bit 0 of the input should become bit 31 of the output, bit 1 should become bit 30, and so on.

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
```',
    'The input is a 32-bit unsigned integer (0 <= n <= 2^32 - 1).'
);

------------------------------------------------------------
-- Add Absent Number problem
-- CodeBite original name: Absent Number (inspired by Missing Number, LC #268)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Absent Number',
    'absent-number',
    'Given an array `nums` containing `n` distinct integers taken from the range `0` to `n` (inclusive), identify the single value from that range which does not appear in the array.

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
```',
    'EASY',
    '1 <= nums.length <= 10000
0 <= nums[i] <= n
All values in nums are unique',
    191,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'absent-number'), '[3,0,1]', '2', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'absent-number'), '[0,1]', '2', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'absent-number'), '[9,6,4,2,3,5,7,0,1]', '8', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'absent-number'), '[0]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'absent-number'), '[1]', '0', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'absent-number'), '[0,1,2,3,4,5,6,7,8,9]', '10', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'absent-number'),
    'en',
    'Absent Number',
    'Given an array `nums` containing `n` distinct integers taken from the range `0` to `n` (inclusive), identify the single value from that range which does not appear in the array.

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
```',
    '1 <= nums.length <= 10000
0 <= nums[i] <= n
All values in nums are unique'
);

------------------------------------------------------------
-- Add Bitwise Sum problem
-- CodeBite original name: Bitwise Sum (inspired by Sum of Two Integers, LC #371)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Bitwise Sum',
    'bitwise-sum',
    'Given two integers `a` and `b`, calculate their sum without using the `+` or `-` operators.

You must rely on bitwise operations only.

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
```',
    'MEDIUM',
    '-1000 <= a, b <= 1000',
    192,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'bitwise-sum'), E'3\n5', '8', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'bitwise-sum'), E'-7\n3', '-4', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'bitwise-sum'), E'0\n0', '0', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'bitwise-sum'), E'-1\n1', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'bitwise-sum'), E'1000\n-1000', '0', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'bitwise-sum'), E'-500\n-300', '-800', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'bitwise-sum'), E'1\n999', '1000', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'bitwise-sum'),
    'en',
    'Bitwise Sum',
    'Given two integers `a` and `b`, calculate their sum without using the `+` or `-` operators.

You must rely on bitwise operations only.

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
```',
    '-1000 <= a, b <= 1000'
);

------------------------------------------------------------
-- Add Power Check problem
-- CodeBite original name: Power Check (inspired by Power of Two, LC #231)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Power Check',
    'power-check',
    'Given an integer `n`, determine whether it is a power of two. A number is a power of two if there exists some non-negative integer `k` such that `n` equals `2^k`.

Return `true` if `n` is a power of two, and `false` otherwise.

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
```',
    'EASY',
    '-2^31 <= n <= 2^31 - 1',
    193,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'power-check'), '1', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '16', 'true', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '6', 'false', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '0', 'false', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '-16', 'false', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '1024', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '2147483647', 'false', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'power-check'),
    'en',
    'Power Check',
    'Given an integer `n`, determine whether it is a power of two. A number is a power of two if there exists some non-negative integer `k` such that `n` equals `2^k`.

Return `true` if `n` is a power of two, and `false` otherwise.

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
```',
    '-2^31 <= n <= 2^31 - 1'
);

------------------------------------------------------------
-- Add Bit Distance problem
-- CodeBite original name: Bit Distance (inspired by Hamming Distance, LC #461)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Bit Distance',
    'bit-distance',
    'Given two integers `x` and `y`, return the number of bit positions where their binary representations differ.

In other words, compare each bit of `x` with the corresponding bit of `y` and count how many positions have different values.

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
```',
    'EASY',
    '0 <= x, y <= 2^31 - 1',
    194,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'bit-distance'), E'1\n4', '2', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'bit-distance'), E'3\n1', '1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'bit-distance'), E'0\n0', '0', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'bit-distance'), E'15\n0', '4', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'bit-distance'), E'2147483647\n0', '31', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'bit-distance'), E'93\n73', '2', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'bit-distance'),
    'en',
    'Bit Distance',
    'Given two integers `x` and `y`, return the number of bit positions where their binary representations differ.

In other words, compare each bit of `x` with the corresponding bit of `y` and count how many positions have different values.

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
```',
    '0 <= x, y <= 2^31 - 1'
);

------------------------------------------------------------
-- Add Stack Queue problem
-- CodeBite original name: Stack Queue (inspired by LeetCode #232 Implement Queue using Stacks)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Stack Queue',
    'stack-queue',
    'Design a first-in, first-out (FIFO) queue using only two stacks. The queue should support the standard enqueue and dequeue operations along with peeking at the front element and checking whether the queue is empty.

Implement the `StackQueue` class:
- `StackQueue()` initializes an empty queue.
- `void push(int x)` adds element `x` to the back of the queue.
- `int pop()` removes and returns the element at the front of the queue.
- `int peek()` returns the element at the front of the queue without removing it.
- `boolean empty()` returns `true` if the queue has no elements, `false` otherwise.

You may only use standard stack operations: push to top, pop from top, peek at top, and check if empty. You must not use any other data structure internally besides two stacks.

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
```',
    'EASY',
    '1 <= x <= 9
At most 100 calls will be made to push, pop, peek, and empty.
All calls to pop and peek are valid (the queue will not be empty when these are called).',
    195,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'stack-queue'), '["StackQueue","push","push","peek","pop","empty"]
[[],[1],[2],[],[],[]]', '[null,null,null,1,1,false]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'stack-queue'), '["StackQueue","push","push","push","pop","pop","peek","empty"]
[[],[10],[20],[30],[],[],[],[]]', '[null,null,null,null,10,20,30,false]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'stack-queue'), '["StackQueue","push","pop","empty"]
[[],[42],[],[]]', '[null,null,42,true]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'stack-queue'), '["StackQueue","push","push","pop","push","peek","pop","pop","empty"]
[[],[1],[2],[],[3],[],[],[],[]]', '[null,null,null,1,null,2,2,3,true]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'stack-queue'), '["StackQueue","push","peek","push","peek","pop","pop","empty"]
[[],[5],[],[7],[],[],[],[]]', '[null,null,5,null,5,5,7,true]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'stack-queue'), '["StackQueue","empty","push","empty","peek","pop","empty"]
[[],[],[9],[],[],[],[]]', '[null,true,null,false,9,9,true]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'stack-queue'),
    'en',
    'Stack Queue',
    'Design a first-in, first-out (FIFO) queue using only two stacks. The queue should support the standard enqueue and dequeue operations along with peeking at the front element and checking whether the queue is empty.

Implement the `StackQueue` class:
- `StackQueue()` initializes an empty queue.
- `void push(int x)` adds element `x` to the back of the queue.
- `int pop()` removes and returns the element at the front of the queue.
- `int peek()` returns the element at the front of the queue without removing it.
- `boolean empty()` returns `true` if the queue has no elements, `false` otherwise.

You may only use standard stack operations: push to top, pop from top, peek at top, and check if empty. You must not use any other data structure internally besides two stacks.

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
```',
    '1 <= x <= 9
At most 100 calls will be made to push, pop, peek, and empty.
All calls to pop and peek are valid (the queue will not be empty when these are called).'
);

------------------------------------------------------------
-- Add Ring Buffer problem
-- CodeBite original name: Ring Buffer (inspired by Design Circular Queue, LC #622)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Ring Buffer',
    'ring-buffer',
    'Design a circular queue (ring buffer) with a fixed capacity. The buffer should reuse space efficiently by wrapping around when it reaches the end of its internal storage.

Implement the `RingBuffer` class:
- `RingBuffer(int k)` initializes the buffer with a maximum capacity of `k`.
- `boolean enQueue(int value)` inserts an element at the rear of the buffer. Returns `true` if successful, or `false` if the buffer is full.
- `boolean deQueue()` removes an element from the front of the buffer. Returns `true` if successful, or `false` if the buffer is empty.
- `int front()` returns the element at the front of the buffer, or `-1` if the buffer is empty.
- `int rear()` returns the element at the rear of the buffer, or `-1` if the buffer is empty.
- `boolean isEmpty()` returns `true` if the buffer contains no elements.
- `boolean isFull()` returns `true` if the buffer has reached its maximum capacity.

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
```',
    'MEDIUM',
    '1 <= k <= 1000
0 <= value <= 1000
At most 3000 calls will be made to enQueue, deQueue, front, rear, isEmpty, and isFull.',
    196,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'ring-buffer'), E'["RingBuffer","enQueue","enQueue","enQueue","enQueue","rear","isFull","deQueue","enQueue","rear"]\n[[3],[1],[2],[3],[4],[],[],[],[4],[]]', '[null,true,true,true,false,3,true,true,true,4]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'ring-buffer'), E'["RingBuffer","enQueue","deQueue","front","deQueue"]\n[[2],[5],[],[],[]]', '[null,true,true,-1,false]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'ring-buffer'), E'["RingBuffer","isEmpty","enQueue","isEmpty","isFull","enQueue","isFull"]\n[[2],[],[1],[],[],[2],[]]', '[null,true,true,false,false,true,true]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'ring-buffer'), E'["RingBuffer","enQueue","enQueue","deQueue","deQueue","deQueue","enQueue","enQueue","enQueue","front","rear"]\n[[2],[1],[2],[],[],[],[3],[4],[5],[],[]]', '[null,true,true,true,true,false,true,true,false,3,4]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'ring-buffer'), E'["RingBuffer","front","rear","deQueue","isEmpty"]\n[[1],[],[],[],[]]', '[null,-1,-1,false,true]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'ring-buffer'), E'["RingBuffer","enQueue","front","rear","enQueue","front","rear","deQueue","front","rear"]\n[[1],[7],[],[],[8],[],[],[],[],[]]', '[null,true,7,7,false,7,7,true,-1,-1]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'ring-buffer'),
    'en',
    'Ring Buffer',
    'Design a circular queue (ring buffer) with a fixed capacity. The buffer should reuse space efficiently by wrapping around when it reaches the end of its internal storage.

Implement the `RingBuffer` class:
- `RingBuffer(int k)` initializes the buffer with a maximum capacity of `k`.
- `boolean enQueue(int value)` inserts an element at the rear of the buffer. Returns `true` if successful, or `false` if the buffer is full.
- `boolean deQueue()` removes an element from the front of the buffer. Returns `true` if successful, or `false` if the buffer is empty.
- `int front()` returns the element at the front of the buffer, or `-1` if the buffer is empty.
- `int rear()` returns the element at the rear of the buffer, or `-1` if the buffer is empty.
- `boolean isEmpty()` returns `true` if the buffer contains no elements.
- `boolean isFull()` returns `true` if the buffer has reached its maximum capacity.

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
```',
    '1 <= k <= 1000
0 <= value <= 1000
At most 3000 calls will be made to enQueue, deQueue, front, rear, isEmpty, and isFull.'
);

------------------------------------------------------------
-- Add Hash Table problem
-- CodeBite original name: Hash Table (inspired by Design HashMap, LC #706)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Hash Table',
    'hash-table',
    'Design a simple hash map that supports storing, retrieving, and removing key-value pairs, all without using any built-in hash map or dictionary libraries.

Implement the `SimpleHashMap` class:

- `SimpleHashMap()` — creates an empty map.
- `put(key, value)` — inserts the pair `(key, value)`. If `key` already exists, update its value.
- `get(key)` — returns the value associated with `key`, or `-1` if the key is not present.
- `remove(key)` — deletes the pair with the given `key`. Does nothing if the key is not found.

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
```',
    'EASY',
    '0 <= key, value <= 10^6\nAt most 10^4 calls will be made to put, get, and remove.',
    197,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'hash-table'), E'["SimpleHashMap","put","put","get","get","put","get","remove","get"]\n[[],[1,10],[2,20],[1],[3],[2,30],[2],[2],[2]]', '[null,null,null,10,-1,null,30,null,-1]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'hash-table'), E'["SimpleHashMap","put","put","put","get","get","get"]\n[[],[5,50],[10,100],[15,150],[5],[10],[15]]', '[null,null,null,null,50,100,150]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'hash-table'), E'["SimpleHashMap","get","remove","get"]\n[[],[7],[7],[7]]', '[null,-1,null,-1]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'hash-table'), E'["SimpleHashMap","put","get","put","get","remove","get"]\n[[],[0,0],[0],[0,999999],[0],[0],[0]]', '[null,null,0,null,999999,null,-1]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'hash-table'), E'["SimpleHashMap","put","put","put","remove","get","get","put","get"]\n[[],[1,1],[2,2],[3,3],[2],[1],[2],[1,100],[1]]', '[null,null,null,null,null,1,-1,null,100]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'hash-table'), E'["SimpleHashMap","put","put","put","put","get","get","get","get","remove","remove","get","get"]\n[[],[100,1],[200,2],[300,3],[400,4],[100],[200],[300],[400],[200],[400],[200],[400]]', '[null,null,null,null,null,1,2,3,4,null,null,-1,-1]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'hash-table'),
    'en',
    'Hash Table',
    'Design a simple hash map that supports storing, retrieving, and removing key-value pairs, all without using any built-in hash map or dictionary libraries.

Implement the `SimpleHashMap` class:

- `SimpleHashMap()` — creates an empty map.
- `put(key, value)` — inserts the pair `(key, value)`. If `key` already exists, update its value.
- `get(key)` — returns the value associated with `key`, or `-1` if the key is not present.
- `remove(key)` — deletes the pair with the given `key`. Does nothing if the key is not found.

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
```',
    '0 <= key, value <= 10^6\nAt most 10^4 calls will be made to put, get, and remove.'
);

------------------------------------------------------------
-- Add Random Set problem
-- CodeBite original name: Random Set (inspired by Insert Delete GetRandom O(1), LC #380)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Random Set',
    'random-set',
    'Design a data structure that allows inserting, removing, and fetching a random element, where each operation runs in average `O(1)` time.

Implement the `RandomSet` class:

- `RandomSet()` — creates an empty set.
- `insert(val)` — adds `val` to the set. Returns `true` if the element was not already present, or `false` if it was.
- `remove(val)` — removes `val` from the set. Returns `true` if the element was found and removed, or `false` if it was not present.
- `getRandom()` — returns a random element from the set. Every element in the set must have an equal probability of being chosen. It is guaranteed that at least one element exists when this method is called.

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
```',
    'MEDIUM',
    '-2^31 <= val <= 2^31 - 1\nAt most 2 * 10^5 calls will be made to insert, remove, and getRandom.\nThere will be at least one element in the set when getRandom is called.',
    198,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'random-set'), E'["RandomSet","insert","insert","remove","getRandom"]\n[[],[1],[2],[1],[]]', '[null,true,true,true,2]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'random-set'), E'["RandomSet","insert","insert","remove","insert","remove","getRandom"]\n[[],[5],[5],[5],[5],[10],[]]', '[null,true,false,true,true,false,5]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'random-set'), E'["RandomSet","insert","remove","remove","insert","getRandom"]\n[[],[7],[7],[7],[7],[]]', '[null,true,true,false,true,7]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'random-set'), E'["RandomSet","insert","insert","insert","remove","remove","getRandom"]\n[[],[100],[200],[300],[100],[300],[]]', '[null,true,true,true,true,true,200]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'random-set'), E'["RandomSet","insert","remove","insert","remove","insert","getRandom"]\n[[],[1],[1],[2],[2],[42],[]]', '[null,true,true,true,true,true,42]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'random-set'), E'["RandomSet","insert","insert","remove","insert","remove","remove","insert","getRandom"]\n[[],[0],[-1],[0],[0],[-1],[0],[99],[]]', '[null,true,true,true,true,true,true,true,99]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'random-set'),
    'en',
    'Random Set',
    'Design a data structure that allows inserting, removing, and fetching a random element, where each operation runs in average `O(1)` time.

Implement the `RandomSet` class:

- `RandomSet()` — creates an empty set.
- `insert(val)` — adds `val` to the set. Returns `true` if the element was not already present, or `false` if it was.
- `remove(val)` — removes `val` from the set. Returns `true` if the element was found and removed, or `false` if it was not present.
- `getRandom()` — returns a random element from the set. Every element in the set must have an equal probability of being chosen. It is guaranteed that at least one element exists when this method is called.

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
```',
    '-2^31 <= val <= 2^31 - 1\nAt most 2 * 10^5 calls will be made to insert, remove, and getRandom.\nThere will be at least one element in the set when getRandom is called.'
);

------------------------------------------------------------
-- Add State Snapshots problem
-- CodeBite original name: State Snapshots (inspired by LeetCode #1146 Snapshot Array)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'State Snapshots',
    'state-snapshots',
    'Design a data structure that supports setting values at specific indices, saving the current state as a snapshot, and retrieving the value at any index as it was at the time of a previous snapshot.

Implement the `SnapshotArray` class:
- `SnapshotArray(int length)` initializes the array with the given `length`. All elements are initially `0`.
- `void set(int index, int val)` updates the element at `index` to `val`.
- `int snap()` saves a snapshot of the current state of the array and returns the snapshot id, which is the number of times `snap()` has been called minus one (starting from `0`).
- `int get(int index, int snapId)` returns the value at `index` at the time the snapshot with `snapId` was taken.

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
```',
    'MEDIUM',
    '1 <= length <= 50000
0 <= index < length
0 <= val <= 10^9
0 <= snapId < (number of times snap() is called)
At most 50000 total calls will be made to set, snap, and get.',
    199,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'state-snapshots'), '["SnapshotArray","set","snap","set","get"]
[[3],[0,5],[],[0,6],[0,0]]', '[null,null,0,null,5]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'state-snapshots'), '["SnapshotArray","set","set","snap","set","snap","get","get"]
[[2],[0,10],[1,20],[],[0,30],[],[0,0],[0,1]]', '[null,null,null,0,null,1,10,30]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'state-snapshots'), '["SnapshotArray","snap","get","set","snap","get"]
[[1],[],[0,0],[0,7],[],[0,1]]', '[null,0,0,null,1,7]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'state-snapshots'), '["SnapshotArray","set","set","set","snap","get","get","get"]
[[3],[0,1],[1,2],[2,3],[],[0,0],[1,0],[2,0]]', '[null,null,null,null,0,1,2,3]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'state-snapshots'), '["SnapshotArray","snap","snap","snap","set","get","get"]
[[2],[],[],[],[0,99],[0,0],[0,1]]', '[null,0,1,2,null,0,0]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'state-snapshots'), '["SnapshotArray","set","snap","set","snap","set","snap","get","get","get"]
[[1],[0,1],[],[0,2],[],[0,3],[],[0,0],[0,1],[0,2]]', '[null,null,0,null,1,null,2,1,2,3]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'state-snapshots'),
    'en',
    'State Snapshots',
    'Design a data structure that supports setting values at specific indices, saving the current state as a snapshot, and retrieving the value at any index as it was at the time of a previous snapshot.

Implement the `SnapshotArray` class:
- `SnapshotArray(int length)` initializes the array with the given `length`. All elements are initially `0`.
- `void set(int index, int val)` updates the element at `index` to `val`.
- `int snap()` saves a snapshot of the current state of the array and returns the snapshot id, which is the number of times `snap()` has been called minus one (starting from `0`).
- `int get(int index, int snapId)` returns the value at `index` at the time the snapshot with `snapId` was taken.

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
```',
    '1 <= length <= 50000
0 <= index < length
0 <= val <= 10^9
0 <= snapId < (number of times snap() is called)
At most 50000 total calls will be made to set, snap, and get.'
);

------------------------------------------------------------
-- Add Click Counter problem
-- CodeBite original name: Click Counter (inspired by Design Hit Counter, LC #362)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Click Counter',
    'click-counter',
    'Design a click counter that tracks the number of clicks received in the last 5 minutes (i.e., the past 300 seconds).

Implement the `HitCounter` class:

- `HitCounter()` — initializes the counter with zero clicks.
- `hit(timestamp)` — records a click at the given `timestamp` (in seconds). Multiple clicks may share the same timestamp.
- `getHits(timestamp)` — returns the total number of clicks in the time range `[timestamp - 299, timestamp]`, inclusive on both ends.

Timestamps are given in strictly non-decreasing order across all calls.

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
Explanation: Three clicks at the same timestamp are all counted.
```

**Example 3:**
```
Input: ["HitCounter","getHits","hit","getHits"] / [[],[1],[2],[300]]
Output: [null,0,null,1]
Explanation: Querying before any clicks returns 0. The click at timestamp 2 is still within the window at timestamp 300.
```',
    'MEDIUM',
    '1 <= timestamp <= 2 * 10^9\nEach timestamp is greater than or equal to the previous one.\nAt most 300 calls will be made to hit and getHits.',
    200,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'click-counter'), E'["HitCounter","hit","hit","hit","getHits","hit","getHits","getHits"]\n[[],[1],[2],[3],[4],[300],[300],[301]]', '[null,null,null,null,3,null,4,3]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'click-counter'), E'["HitCounter","hit","hit","hit","getHits"]\n[[],[100],[100],[100],[100]]', '[null,null,null,null,3]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'click-counter'), E'["HitCounter","getHits","hit","getHits"]\n[[],[1],[2],[300]]', '[null,0,null,1]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'click-counter'), E'["HitCounter","hit","getHits","getHits"]\n[[],[1],[300],[301]]', '[null,null,1,0]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'click-counter'), E'["HitCounter","hit","hit","hit","hit","hit","getHits","getHits"]\n[[],[1],[1],[2],[2],[3],[3],[302]]', '[null,null,null,null,null,null,5,1]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'click-counter'), E'["HitCounter","hit","hit","hit","getHits","getHits","hit","getHits"]\n[[],[1],[200],[400],[400],[500],[500],[700]]', '[null,null,null,null,2,1,null,2]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'click-counter'),
    'en',
    'Click Counter',
    'Design a click counter that tracks the number of clicks received in the last 5 minutes (i.e., the past 300 seconds).

Implement the `HitCounter` class:

- `HitCounter()` — initializes the counter with zero clicks.
- `hit(timestamp)` — records a click at the given `timestamp` (in seconds). Multiple clicks may share the same timestamp.
- `getHits(timestamp)` — returns the total number of clicks in the time range `[timestamp - 299, timestamp]`, inclusive on both ends.

Timestamps are given in strictly non-decreasing order across all calls.

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
Explanation: Three clicks at the same timestamp are all counted.
```

**Example 3:**
```
Input: ["HitCounter","getHits","hit","getHits"] / [[],[1],[2],[300]]
Output: [null,0,null,1]
Explanation: Querying before any clicks returns 0. The click at timestamp 2 is still within the window at timestamp 300.
```',
    '1 <= timestamp <= 2 * 10^9\nEach timestamp is greater than or equal to the previous one.\nAt most 300 calls will be made to hit and getHits.'
);

