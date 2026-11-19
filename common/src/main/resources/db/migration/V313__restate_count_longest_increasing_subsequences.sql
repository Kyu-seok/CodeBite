-- V313: count-longest-cookie-runs -> count-longest-increasing-subsequences, retitled
-- "Count Longest Increasing Subsequences". "Runs" suggested contiguous stretches, the
-- cookie theme hid the task, and "distinct subsequences" was wrong: [3,3,3] -> 3 and
-- [1,1,1,2,2,2,3,3,3] -> 27 count subsequences by the positions they pick. Both
-- languages now say so, drop the undefined "trail", and explain sample 3 as Example 3.
-- Starter method countLongestTrail(scores) -> countLongestIncreasing(nums). Drivers and
-- Starter Code directories are renamed in the same commit. Examples match the sample
-- test cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$count-longest-cookie-runs$$, id FROM problems WHERE slug = $$count-longest-cookie-runs$$;

UPDATE problems SET
    slug = $$count-longest-increasing-subsequences$$,
    title = $$Count Longest Increasing Subsequences$$,
    description = $$Given an integer array `nums`, return how many of its strictly increasing subsequences have the greatest possible length.

A subsequence keeps some elements of `nums` in their original order, skipping the rest. Subsequences are counted by the positions they pick, not by their values: two subsequences that pick different positions count separately, even when their values are equal.

**Example 1:**
```
Input: nums = [2,6,4,5,8]
Output: 1
Explanation: The longest strictly increasing subsequence has length 4, and [2,4,5,8] is the only one of that length.
```

**Example 2:**
```
Input: nums = [3,3,3]
Output: 3
Explanation: No two elements are strictly increasing, so the longest length is 1. Each of the three positions alone is a subsequence of length 1, so the answer is 3, even though all three are [3].
```

**Example 3:**
```
Input: nums = [1,2,4,3,5,4,7,2]
Output: 3
Explanation: The longest length is 5, reached by [1,2,4,5,7], [1,2,3,5,7] and [1,2,3,4,7].
```$$,
    constraints = $$- `1 <= nums.length <= 2000`
- `-8 * 10^5 <= nums[i] <= 8 * 10^5`
- The answer fits in a 32-bit signed integer.$$
WHERE slug = $$count-longest-cookie-runs$$;

UPDATE problem_translations SET
    title = $$가장 긴 증가 부분수열의 개수$$,
    description = $$정수 배열 `nums`가 주어질 때, 엄격하게 증가하는 부분수열 중 길이가 가장 긴 것이 몇 개인지 반환하세요.

부분수열은 `nums`의 원소 일부를 원래 순서대로 고른 것입니다(나머지는 건너뜁니다). 부분수열은 값이 아니라 고른 위치로 셉니다. 고른 위치가 다르면 값이 같더라도 서로 다른 부분수열로 셉니다.

**예시 1:**
```
입력: nums = [2,6,4,5,8]
출력: 1
설명: 가장 긴 엄격하게 증가하는 부분수열의 길이는 4이며, 그 길이의 부분수열은 [2,4,5,8] 하나뿐입니다.
```

**예시 2:**
```
입력: nums = [3,3,3]
출력: 3
설명: 엄격하게 증가하는 두 원소가 없으므로 가장 긴 길이는 1입니다. 세 위치 각각이 길이 1인 부분수열이므로, 셋 다 [3]이지만 답은 3입니다.
```

**예시 3:**
```
입력: nums = [1,2,4,3,5,4,7,2]
출력: 3
설명: 가장 긴 길이는 5이며, [1,2,4,5,7], [1,2,3,5,7], [1,2,3,4,7] 세 개가 그 길이입니다.
```$$,
    constraints = $$- `1 <= nums.length <= 2000`
- `-8 * 10^5 <= nums[i] <= 8 * 10^5`
- 답은 32비트 부호 있는 정수 범위 안에 들어옵니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-longest-increasing-subsequences$$);
