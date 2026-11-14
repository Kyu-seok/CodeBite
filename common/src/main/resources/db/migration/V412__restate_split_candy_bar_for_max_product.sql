-- V412: split-candy-bar -> split-candy-bar-for-max-product, retitled "Split Candy Bar for
-- Max Product". The old title hid that the product is maximized, the description named
-- splitProductMax while the Python Starter Code had break_integer, and "contiguous chunks"
-- suggested an order that doesn't matter. The bound `span <= 60` was false for the int
-- return type (n = 59 gives 3^19 * 2 > 2^31 - 1): it is now 58, which every case fits.
-- Starter method splitProductMax (break_integer in Python) -> maxSplitProduct and parameter
-- span -> length in all 4 Starter Codes and Drivers. Drivers and Starter Code directories
-- are renamed in the same commit. Examples match the sample test cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$split-candy-bar$$, id FROM problems WHERE slug = $$split-candy-bar$$;

UPDATE problems SET
    slug = $$split-candy-bar-for-max-product$$,
    title = $$Split Candy Bar for Max Product$$,
    description = $$A candy bar is `length` squares long. Break it into at least two pieces, each a whole number of squares long, and return the largest possible product of the piece lengths.

**Example 1:**
```
Input: length = 5
Output: 6
Explanation: 5 = 2 + 3 gives 2 * 3 = 6. Every other way (1 + 4, 1 + 1 + 3, 1 + 2 + 2, 1 + 1 + 1 + 2, 1 + 1 + 1 + 1 + 1) gives less.
```

**Example 2:**
```
Input: length = 11
Output: 54
Explanation: 11 = 3 + 3 + 3 + 2 gives 3 * 3 * 3 * 2 = 54. For comparison, 3 + 4 + 4 gives 48 and 3 + 3 + 5 gives 45.
```$$,
    constraints = $$- `2 <= length <= 58`$$
WHERE slug = $$split-candy-bar$$;

UPDATE problem_translations SET
    title = $$곱이 최대가 되게 사탕 막대 쪼개기$$,
    description = $$길이가 `length`칸인 사탕 막대가 있습니다. 막대를 길이가 양의 정수인 조각 두 개 이상으로 쪼갤 때, 조각 길이들의 곱 중 가장 큰 값을 반환하세요.

**예시 1:**
```
입력: length = 5
출력: 6
설명: 5 = 2 + 3으로 쪼개면 2 * 3 = 6입니다. 다른 방법(1 + 4, 1 + 1 + 3, 1 + 2 + 2, 1 + 1 + 1 + 2, 1 + 1 + 1 + 1 + 1)은 모두 곱이 더 작습니다.
```

**예시 2:**
```
입력: length = 11
출력: 54
설명: 11 = 3 + 3 + 3 + 2로 쪼개면 3 * 3 * 3 * 2 = 54입니다. 참고로 3 + 4 + 4는 48, 3 + 3 + 5는 45입니다.
```$$,
    constraints = $$- `2 <= length <= 58`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$split-candy-bar-for-max-product$$);
