-- V192: barista-throughput-share -> product-of-all-other-elements, retitled
-- "Product of All Other Elements", with its barista story replaced by a direct
-- statement in English and Korean. The parameter is renamed from `rates` to
-- `nums` and the method from computeStationShare to productOfAllOtherElements.
-- Driver directory common/src/main/resources/drivers/<slug>/ and starter
-- directory backend/src/main/resources/starters/<slug>/ are renamed in the
-- same commit. Examples match the sample test cases (order_index 1 and 2),
-- which are unchanged.

UPDATE problems SET
    slug = $$product-of-all-other-elements$$,
    title = $$Product of All Other Elements$$,
    description = $$Given an integer array `nums`, return an array `answer` of the same length, where `answer[i]` is the product of all elements in `nums` except `nums[i]`.

**Example 1:**
```
Input: nums = [2, 3, 5, 4]
Output: answer = [60, 40, 24, 30]
```

**Example 2:**
```
Input: nums = [-2, 1, 0, 4, -1]
Output: answer = [0, 0, 8, 0, 0]
```

For each position, calculate the product of all elements except the element at that position. You must solve the problem without using division and in O(n) time complexity.$$,
    constraints = $$- `2 <= nums.length <= 2 * 10^5`
- `-30 <= nums[i] <= 30`
- The product of any prefix or suffix of `nums` fits in a signed 32-bit integer.$$
WHERE slug = $$barista-throughput-share$$;

UPDATE problem_translations SET
    title = $$자기 자신을 제외한 모든 원소의 곱$$,
    description = $$정수 배열 `nums`가 주어집니다. 같은 길이의 배열 `answer`를 반환하세요. 각 `answer[i]`는 `nums[i]`를 제외한 배열의 모든 원소를 곱한 값입니다.

**예시 1:**
```
입력: nums = [2, 3, 5, 4]
출력: answer = [60, 40, 24, 30]
```

**예시 2:**
```
입력: nums = [-2, 1, 0, 4, -1]
출력: answer = [0, 0, 8, 0, 0]
```

각 위치에서 자기 자신만 제외하고 나머지를 전부 곱하면 됩니다. 나눗셈은 사용할 수 없으며, 시간 복잡도는 O(n)이어야 합니다.$$,
    constraints = $$- `2 <= nums.length <= 2 * 10^5`
- `-30 <= nums[i] <= 30`
- `nums`의 어떤 접두 곱이나 접미 곱도 부호 있는 32비트 정수 범위 안에 들어옵니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$product-of-all-other-elements$$);
