-- Add Kth Largest Stream (LC#703) as the 50th Phase 1 problem
-- Pulled forward from Phase 2 to replace the duplicate #50 slot

INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Kth Largest Stream',
    'kth-largest-stream',
    'Design a class to find the `k`th largest element in a stream. Note that it is the `k`th largest element in the sorted order, not the `k`th distinct element.

Implement `KthLargest` class:
- `KthLargest(int k, int[] nums)` Initializes the object with the integer `k` and the stream of integers `nums`.
- `int add(int val)` Appends the integer `val` to the stream and returns the element representing the `k`th largest element in the stream.

**Example 1:**
```
Input:
["KthLargest", "add", "add", "add", "add", "add"]
[[3, [4, 5, 8, 2]], [3], [5], [10], [9], [4]]
Output: [null, 4, 5, 5, 8, 8]

Explanation:
KthLargest kthLargest = new KthLargest(3, [4, 5, 8, 2]);
kthLargest.add(3);   // return 4
kthLargest.add(5);   // return 5
kthLargest.add(10);  // return 5
kthLargest.add(9);   // return 8
kthLargest.add(4);   // return 8
```',
    'EASY',
    '1 <= k <= 10^4
0 <= nums.length <= 10^4
-10^4 <= nums[i] <= 10^4
-10^4 <= val <= 10^4
At most 10^4 calls will be made to add.
It is guaranteed that there will be at least k elements in the array when you search for the kth element.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'kth-largest-stream'), '["KthLargest","add","add","add","add","add"]
[[3,[4,5,8,2]],[3],[5],[10],[9],[4]]', '[null,4,5,5,8,8]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'kth-largest-stream'), '["KthLargest","add","add","add"]
[[1,[]],[-3],[-2],[-4]]', '[null,-3,-2,-2]', FALSE, 2),
    ((SELECT id FROM problems WHERE slug = 'kth-largest-stream'), '["KthLargest","add","add","add","add"]
[[2,[0]],[-1],[1],[-2],[3]]', '[null,-1,0,0,1]', FALSE, 3);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems WHERE slug = 'kth-largest-stream';

-- Korean translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'kth-largest-stream'), 'ko',
    'K번째 최대 스트림',
    '스트림에서 `k`번째로 큰 원소를 찾는 클래스를 설계하세요. 정렬된 순서에서 `k`번째로 큰 원소이며, `k`번째 고유한 원소가 아닙니다.

`KthLargest` 클래스를 구현하세요:
- `KthLargest(int k, int[] nums)` — 정수 `k`와 정수 스트림 `nums`로 객체를 초기화합니다.
- `int add(int val)` — 정수 `val`을 스트림에 추가하고, 스트림에서 `k`번째로 큰 원소를 반환합니다.

**예시 1:**
```
Input:
["KthLargest", "add", "add", "add", "add", "add"]
[[3, [4, 5, 8, 2]], [3], [5], [10], [9], [4]]
Output: [null, 4, 5, 5, 8, 8]

Explanation:
KthLargest kthLargest = new KthLargest(3, [4, 5, 8, 2]);
kthLargest.add(3);   // 4를 반환
kthLargest.add(5);   // 5를 반환
kthLargest.add(10);  // 5를 반환
kthLargest.add(9);   // 8을 반환
kthLargest.add(4);   // 8을 반환
```',
    '1 <= k <= 10^4
0 <= nums.length <= 10^4
-10^4 <= nums[i] <= 10^4
-10^4 <= val <= 10^4
최대 10^4번의 add 호출이 이루어집니다.
k번째 원소를 찾을 때 배열에 최소 k개의 원소가 있음이 보장됩니다.'
);
