-- V453: top-espresso-machines, text restated. The task now leads the statement instead of
-- the morning-rush and whiteboard story, and the unique-answer guarantee is stated once,
-- in the constraints. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Implement `busiestMachines` to return the `k` machine ids that appear most often in `checkIns`, in any order. Each number in `checkIns` is the id of the espresso machine used for one coffee.

**Example 1:**
```
Input: checkIns = [4,4,4,7,7,5], k = 2
Output: [4,7]
Explanation: Machine 4 was used 3 times, machine 7 twice, machine 5 once. The top 2 are 4 and 7.
```

**Example 2:**
```
Input: checkIns = [9], k = 1
Output: [9]
Explanation: Machine 9 is the only machine, so it is the most used.
```$$,
    constraints = $$- `1 <= checkIns.length <= 2 * 10^5`
- `|checkIns[i]| <= 10^8`
- `k` is at least `1` and at most the number of distinct machine ids in `checkIns`.
- The answer is unique: no machine outside the top `k` is used as often as one inside it.$$
WHERE slug = $$top-espresso-machines$$;

UPDATE problem_translations SET
    description = $$`checkIns`에서 가장 자주 등장하는 머신 id `k`개를 반환하는 `busiestMachines`를 구현하세요. 반환 순서는 상관없습니다. `checkIns`의 각 숫자는 커피 한 잔을 내릴 때 사용된 에스프레소 머신의 id입니다.

**예시 1:**
```
입력: checkIns = [4,4,4,7,7,5], k = 2
출력: [4,7]
설명: 머신 `4`는 3번, 머신 `7`은 2번, 머신 `5`는 1번 사용됐으므로 상위 2개는 `4`와 `7`입니다.
```

**예시 2:**
```
입력: checkIns = [9], k = 1
출력: [9]
설명: 머신 `9` 하나만 등장하므로 가장 자주 쓰인 1개는 `9`입니다.
```$$,
    constraints = $$- `1 <= checkIns.length <= 2 * 10^5`
- `|checkIns[i]| <= 10^8`
- `k`는 `1` 이상, `checkIns`에 등장하는 서로 다른 머신 id 개수 이하입니다.
- 정답은 유일합니다. 상위 `k`개 밖의 머신은 모두 그 안의 어떤 머신보다도 적게 사용됐습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$top-espresso-machines$$);
