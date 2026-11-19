-- V332: grocery-bag-triple -> combine-bags-to-match-target, retitled "Combine Bags to
-- Match Target". The title didn't hint at the task (combine bags, position by position
-- maximum, to equal target). Example 1 mixed 1-indexed bags with 0-indexed channels; it
-- now counts both from 0. "1 <= bags[i][j]" was false (hidden case 12 has zeros), so the
-- lower bound is 0, a fair input. Starter method canBuildBales -> canMatchTarget; Drivers'
-- triplets -> bags. Drivers and Starter Code directories are renamed in the same commit.
-- Examples match the sample test cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$grocery-bag-triple$$, id FROM problems WHERE slug = $$grocery-bag-triple$$;

UPDATE problems SET
    slug = $$combine-bags-to-match-target$$,
    title = $$Combine Bags to Match Target$$,
    description = $$Given grocery bags `bags`, each labeled with three readings, and three readings `target`, return `true` if some group of one or more bags combines to exactly `target`, and `false` otherwise.

Combining bags takes, in each of the three positions, the largest reading among the chosen bags. For example, combining `[1,2,3]` and `[4,2,1]` gives `[4,2,3]`.

A bag with a reading above `target`'s in any position can never be part of the group, since the combined reading in that position would be too large.

**Example 1:**
```
Input: bags = [[1,2,3],[4,2,1],[1,5,3],[2,1,4]], target = [4,5,4]
Output: true
Explanation: No bag has a reading above target's. Combining bags 1, 2 and 3 gives [max(4,1,2), max(2,5,1), max(1,3,4)] = [4,5,4].
```

**Example 2:**
```
Input: bags = [[1,2,3],[4,5,6]], target = [3,4,5]
Output: false
Explanation: Bag 1 is above target in every position, so it can't be used. Bag 0 alone gives [1,2,3], which is not [3,4,5].
```$$,
    constraints = $$- `1 <= bags.length <= 2 * 10^5`
- `bags[i].length == 3`
- `target.length == 3`
- `0 <= bags[i][j] <= 1000`
- `1 <= target[j] <= 1000`$$
WHERE slug = $$grocery-bag-triple$$;

UPDATE problem_translations SET
    title = $$봉투를 합쳐 목표 맞추기$$,
    description = $$각각 측정값 세 개가 적힌 장바구니 봉투 배열 `bags`와 측정값 세 개로 된 `target`이 주어질 때, 봉투를 하나 이상 골라 합쳐서 정확히 `target`을 만들 수 있으면 `true`, 아니면 `false`를 반환하세요.

봉투를 합치면 세 자리 각각에서 고른 봉투들의 측정값 중 가장 큰 값을 가집니다. 예를 들어 `[1,2,3]`과 `[4,2,1]`을 합치면 `[4,2,3]`이 됩니다.

어느 한 자리라도 측정값이 `target`보다 큰 봉투는 고를 수 없습니다. 그 자리의 합친 값이 너무 커지기 때문입니다.

**예시 1:**
```
입력: bags = [[1,2,3],[4,2,1],[1,5,3],[2,1,4]], target = [4,5,4]
출력: true
설명: target보다 큰 측정값을 가진 봉투가 없습니다. 봉투 1, 2, 3을 합치면 [max(4,1,2), max(2,5,1), max(1,3,4)] = [4,5,4]가 됩니다.
```

**예시 2:**
```
입력: bags = [[1,2,3],[4,5,6]], target = [3,4,5]
출력: false
설명: 봉투 1은 모든 자리에서 target보다 크므로 쓸 수 없습니다. 봉투 0만 쓰면 [1,2,3]이 되어 [3,4,5]가 아닙니다.
```$$,
    constraints = $$- `1 <= bags.length <= 2 * 10^5`
- `bags[i].length == 3`
- `target.length == 3`
- `0 <= bags[i][j] <= 1000`
- `1 <= target[j] <= 1000`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$combine-bags-to-match-target$$);
