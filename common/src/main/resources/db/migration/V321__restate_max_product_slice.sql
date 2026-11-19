-- V321: best-boba-streak -> max-product-slice, retitled "Max Product Slice". "Streak" hid
-- that the task is the largest product, and multiplying foot-traffic counts made no sense, so
-- the boba-shop story is dropped. The Korean Example 2 said "0을 건너뛰지 않는" (not skipping
-- the 0), the opposite of what it meant; both languages now list the slices on either side.
-- (max-product-subarray is already this problem's Former Slug, so it can't be the Slug.)
-- Starter method bestFlowStreak / max_product (Python) (traffic) -> maxProduct(nums). Drivers
-- and Starter Code directories are renamed in the same commit. Examples match the sample test
-- cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$best-boba-streak$$, id FROM problems WHERE slug = $$best-boba-streak$$;

UPDATE problems SET
    slug = $$max-product-slice$$,
    title = $$Max Product Slice$$,
    description = $$Given an integer array `nums`, return the largest product of any non-empty slice of `nums`. A slice is a run of consecutive elements.

Multiplying by a negative number flips the sign, so a slice with an even number of negatives has a positive product, and any slice that contains a `0` has product `0`.

**Example 1:**
```
Input: nums = [3,-1,4,-2,5]
Output: 120
Explanation: The whole array holds two negatives, so its product 3 × (-1) × 4 × (-2) × 5 = 120 is positive, and no slice beats it.
```

**Example 2:**
```
Input: nums = [-3,0,2,-4]
Output: 2
Explanation: Every slice that contains the 0 has product 0. The slices without it are [-3], [2], [-4] and [2,-4], with products -3, 2, -4 and -8, so the largest product is 2.
```$$,
    constraints = $$- `1 <= nums.length <= 2000`
- `-10 <= nums[i] <= 10`
- The product of any slice of `nums` fits in a 32-bit signed integer.$$
WHERE slug = $$best-boba-streak$$;

UPDATE problem_translations SET
    title = $$곱이 가장 큰 구간$$,
    description = $$정수 배열 `nums`가 주어질 때, `nums`의 비어 있지 않은 구간 중 원소의 곱이 가장 큰 값을 반환하세요. 구간은 연속한 원소들의 묶음입니다.

음수를 곱하면 부호가 바뀌므로 음수가 짝수 개인 구간의 곱은 양수이고, `0`이 들어 있는 구간의 곱은 `0`입니다.

**예시 1:**
```
입력: nums = [3,-1,4,-2,5]
출력: 120
설명: 배열 전체에 음수가 두 개 있어 곱 3 × (-1) × 4 × (-2) × 5 = 120은 양수이며, 이보다 곱이 큰 구간은 없습니다.
```

**예시 2:**
```
입력: nums = [-3,0,2,-4]
출력: 2
설명: 0이 들어 있는 구간의 곱은 모두 0입니다. 0이 없는 구간은 [-3], [2], [-4], [2,-4]이고 곱은 각각 -3, 2, -4, -8이므로 가장 큰 곱은 2입니다.
```$$,
    constraints = $$- `1 <= nums.length <= 2000`
- `-10 <= nums[i] <= 10`
- `nums`의 어떤 구간이든 그 곱은 32비트 부호 있는 정수 범위에 들어옵니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$max-product-slice$$);
