-- V353: next-speaker-order restated, title unchanged. The Starter names shotOrder and
-- advanceShotOrder were left over from another theme; they are now lineup and nextLineup.
-- "Lexicographically greater permutation" is now defined, Example 1 lists the arrangements
-- in order so the next one can be seen, and the statement says ids may repeat ([1,1] and
-- [1,5,1] are cases). Starter method advanceShotOrder -> nextLineup, parameter shotOrder ->
-- lineup, in all 4 Starter Codes and Drivers; the Walkthrough is regenerated with the new
-- name. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$The standup lineup is an array `lineup` of speaker ids. Each morning it moves on to the next arrangement of the same ids in lexicographic order: the smallest arrangement that is greater than today's. One arrangement is smaller than another when, at the first position where they differ, its id is smaller.

If today's lineup is already the greatest arrangement, it starts over at the smallest one, the ids in ascending order. An id can appear more than once.

Rearrange `lineup` **in place** into the next lineup, using only constant extra memory. Return nothing.

**Example 1:**
```
Input: lineup = [2,3,4]
Output: [2,4,3]
Explanation: In lexicographic order the arrangements of 2, 3 and 4 are [2,3,4], [2,4,3], [3,2,4], [3,4,2], [4,2,3], [4,3,2]. The one after [2,3,4] is [2,4,3].
```

**Example 2:**
```
Input: lineup = [5,4,3,2]
Output: [2,3,4,5]
Explanation: [5,4,3,2] is the greatest arrangement, so the lineup starts over at the smallest, [2,3,4,5].
```$$,
    constraints = $$- `1 <= lineup.length <= 100`
- `0 <= lineup[i] <= 100`$$
WHERE slug = $$next-speaker-order$$;

UPDATE problem_translations SET
    description = $$아침 발표 순서가 발표자 ID 배열 `lineup`에 들어 있습니다. 매일 아침 순서는 같은 ID들로 만들 수 있는 배치 가운데 사전순으로 바로 다음 배치, 즉 오늘보다 큰 배치 중 가장 작은 배치로 바뀝니다. 두 배치를 비교할 때는 처음으로 다른 자리의 ID가 더 작은 쪽이 작은 배치입니다.

오늘 순서가 이미 가장 큰 배치라면 가장 작은 배치, 즉 ID의 오름차순으로 돌아갑니다. 같은 ID가 여러 번 나올 수 있습니다.

`lineup`을 **제자리에서** 다음 순서로 바꾸세요. 추가 메모리는 상수 크기만 사용하고, 아무것도 반환하지 않습니다.

**예시 1:**
```
입력: lineup = [2,3,4]
출력: [2,4,3]
설명: 2, 3, 4의 배치를 사전순으로 나열하면 [2,3,4], [2,4,3], [3,2,4], [3,4,2], [4,2,3], [4,3,2]입니다. [2,3,4] 다음은 [2,4,3]입니다.
```

**예시 2:**
```
입력: lineup = [5,4,3,2]
출력: [2,3,4,5]
설명: [5,4,3,2]는 가장 큰 배치이므로 가장 작은 배치인 [2,3,4,5]로 돌아갑니다.
```$$,
    constraints = $$- `1 <= lineup.length <= 100`
- `0 <= lineup[i] <= 100`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$next-speaker-order$$);
