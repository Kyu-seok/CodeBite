-- V324: longest-unique-treats -> longest-two-flavor-stretch, retitled "Longest Two-Flavor
-- Stretch". "Unique" suggested all-distinct treats (and the Korean title "안 겹치는" meant
-- non-overlapping); the task allows at most two distinct flavors. The examples no longer call a
-- stretch "clean" without defining it. The constraint `0 <= treats[i] < treats.length` was false
-- for samples and hidden cases alike ([9,9,9], [1], [10,10,20,10,20,30]); flavor codes are fair
-- inputs of any size, so it is loosened to `0 <= treats[i] <= 10^5`.
-- Starter method longestCleanRun / fruit_picker (Python) -> longestTwoFlavorStretch(treats).
-- Drivers and Starter Code directories are renamed in the same commit. Examples match the
-- sample test cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$longest-unique-treats$$, id FROM problems WHERE slug = $$longest-unique-treats$$;

UPDATE problems SET
    slug = $$longest-two-flavor-stretch$$,
    title = $$Longest Two-Flavor Stretch$$,
    description = $$The array `treats` lists the treats on a buffet line in order: `treats[i]` is the flavor code of the `i`-th treat. Return the length of the longest stretch of consecutive treats that contains **at most two distinct flavors**.

**Example 1:**
```
Input: treats = [4,4,7,4,7,2,7,2,2]
Output: 5
Explanation: The last five treats, [7,2,7,2,2], use only flavors 7 and 2, and the first five, [4,4,7,4,7], use only 4 and 7. Every stretch of six treats holds three flavors.
```

**Example 2:**
```
Input: treats = [9,9,9]
Output: 3
Explanation: Every treat is flavor 9. One flavor is within the limit, so the whole line counts.
```

**Example 3:**
```
Input: treats = [1,5,1,5,1,5]
Output: 6
Explanation: The line alternates between flavors 1 and 5 only, so the whole line counts.
```$$,
    constraints = $$- `1 <= treats.length <= 2 * 10^5`
- `0 <= treats[i] <= 10^5`$$
WHERE slug = $$longest-unique-treats$$;

UPDATE problem_translations SET
    title = $$맛이 두 가지 이하인 가장 긴 구간$$,
    description = $$배열 `treats`는 뷔페 라인에 놓인 간식을 순서대로 나열한 것으로, `treats[i]`는 `i`번째 간식의 맛 코드입니다. 연속한 간식들로 이루어진 구간 중 **서로 다른 맛이 최대 두 가지**인 가장 긴 구간의 길이를 반환하세요.

**예시 1:**
```
입력: treats = [4,4,7,4,7,2,7,2,2]
출력: 5
설명: 마지막 다섯 개 [7,2,7,2,2]는 맛 7과 2만, 처음 다섯 개 [4,4,7,4,7]은 맛 4와 7만 씁니다. 간식 여섯 개짜리 구간에는 모두 맛이 세 가지 들어 있습니다.
```

**예시 2:**
```
입력: treats = [9,9,9]
출력: 3
설명: 모든 간식이 맛 9입니다. 맛 한 가지는 제한 안이므로 라인 전체가 구간이 됩니다.
```

**예시 3:**
```
입력: treats = [1,5,1,5,1,5]
출력: 6
설명: 라인 전체가 맛 1과 5만 번갈아 나오므로, 라인 전체가 구간이 됩니다.
```$$,
    constraints = $$- `1 <= treats.length <= 2 * 10^5`
- `0 <= treats[i] <= 10^5`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-two-flavor-stretch$$);
