-- V205: subsets-ii -> power-set, retitled "Power Set". Every Test Case has distinct
-- elements, so the "may contain duplicates" statement and its [1,2,2] example promised
-- a problem the cases never tested. The English constraints also still named the old
-- `barrels` parameter, and both languages left out the cases' empty array and values
-- above 10. The method is renamed from subsetsWithDup to powerSet. Drivers and Starter
-- Code directories are renamed in the same commit. Examples match the sample test
-- cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$subsets-ii$$, id FROM problems WHERE slug = $$subsets-ii$$;

UPDATE problems SET
    slug = $$power-set$$,
    title = $$Power Set$$,
    description = $$Given an integer array `nums` of distinct elements, return all of its subsets (the power set).

The empty set counts as a subset. Return the subsets in any order, and the elements of each subset in any order.

**Example 1:**
```
Input: nums = [2,5,8]
Output: [[],[2],[2,5],[2,5,8],[2,8],[5],[5,8],[8]]
```

**Example 2:**
```
Input: nums = [7]
Output: [[],[7]]
```$$,
    constraints = $$- `0 <= nums.length <= 10`
- `-100 <= nums[i] <= 100`
- All elements of `nums` are distinct.$$
WHERE slug = $$subsets-ii$$;

UPDATE problem_translations SET
    title = $$멱집합$$,
    description = $$서로 다른 정수로 이루어진 배열 `nums`가 주어집니다. `nums`의 모든 부분집합(멱집합)을 반환하세요.

빈 집합도 부분집합에 포함됩니다. 부분집합들의 순서와 각 부분집합 안의 원소 순서는 상관없습니다.

**예시 1:**
```
입력: nums = [2,5,8]
출력: [[],[2],[2,5],[2,5,8],[2,8],[5],[5,8],[8]]
```

**예시 2:**
```
입력: nums = [7]
출력: [[],[7]]
```$$,
    constraints = $$- `0 <= nums.length <= 10`
- `-100 <= nums[i] <= 100`
- `nums`의 모든 원소는 서로 다릅니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$power-set$$);
