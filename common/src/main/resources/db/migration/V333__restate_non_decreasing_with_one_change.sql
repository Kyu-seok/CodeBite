-- V333: verify-pizza-rotation -> non-decreasing-with-one-change, retitled "Non-Decreasing
-- With One Change". Nothing rotates: the task is whether changing at most one value makes
-- the array non-decreasing. The oven theme is dropped, and the Korean, which said exactly
-- one slot, now says at most one (an already sorted array returns true). Starter method
-- verifyBakeOrder -> canBeNonDecreasing, parameter trays -> nums. Drivers and Starter
-- Code directories are renamed in the same commit. Examples match the sample test cases,
-- which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$verify-pizza-rotation$$, id FROM problems WHERE slug = $$verify-pizza-rotation$$;

UPDATE problems SET
    slug = $$non-decreasing-with-one-change$$,
    title = $$Non-Decreasing With One Change$$,
    description = $$Given an integer array `nums`, return `true` if you can make it non-decreasing (`nums[i] <= nums[i + 1]` for every `i`) by changing **at most one** element to any integer, and `false` otherwise.

An array that is already non-decreasing needs no change, so it returns `true`.

**Example 1:**
```
Input: nums = [3,1,4,5]
Output: true
Explanation: Changing the first element to 1 gives [1,1,4,5], which is non-decreasing.
```

**Example 2:**
```
Input: nums = [6,4,2,3]
Output: false
Explanation: There are two drops, 6 > 4 and 4 > 2. Changing 4 would need a value that is at least 6 and at most 2, and changing any other element leaves a drop.
```$$,
    constraints = $$- `1 <= nums.length <= 2 * 10^5`
- `-10^8 <= nums[i] <= 10^8`$$
WHERE slug = $$verify-pizza-rotation$$;

UPDATE problem_translations SET
    title = $$한 번 바꿔 비감소 만들기$$,
    description = $$정수 배열 `nums`가 주어질 때, 원소를 **최대 하나** 임의의 정수로 바꾸어 비감소(모든 `i`에 대해 `nums[i] <= nums[i + 1]`)로 만들 수 있으면 `true`, 아니면 `false`를 반환하세요.

이미 비감소인 배열은 바꿀 필요가 없으므로 `true`를 반환합니다.

**예시 1:**
```
입력: nums = [3,1,4,5]
출력: true
설명: 첫 원소를 1로 바꾸면 [1,1,4,5]가 되어 비감소입니다.
```

**예시 2:**
```
입력: nums = [6,4,2,3]
출력: false
설명: 6 > 4와 4 > 2, 두 군데에서 값이 줄어듭니다. 4를 바꾸려면 6 이상이면서 2 이하인 값이 필요하고, 다른 원소를 바꾸면 줄어드는 곳이 하나 남습니다.
```$$,
    constraints = $$- `1 <= nums.length <= 2 * 10^5`
- `-10^8 <= nums[i] <= 10^8`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$non-decreasing-with-one-change$$);
