-- V391: min-daily-brew -> min-daily-brew-capacity, retitled "Min Daily Brew Capacity". The
-- statement asks for a capacity, not a rate, and it is one capacity used every day (the old
-- text read as a new one each day); "ships" is now "brews". Starter method smallestFlowRate
-- -> minDailyCapacity. Drivers and Starter Code directories are renamed in the same commit.
-- Examples match the sample test cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$min-daily-brew$$, id FROM problems WHERE slug = $$min-daily-brew$$;

UPDATE problems SET
    slug = $$min-daily-brew-capacity$$,
    title = $$Min Daily Brew Capacity$$,
    description = $$A cafe has a queue of drinks to brew, where `volumes[i]` is the volume of drink `i`, and must brew them all, in queue order, within `days` days. The barista sets one daily capacity, the same every day: each day, drinks are brewed from the front of the queue as long as the day's total volume stays within the capacity, and the next drink waits for the following day.

Return the smallest daily capacity that brews every drink within `days` days.

**Example 1:**
```
Input: volumes = [2,4,5,7,9,11,13,16,18,20], days = 5
Output: 27
Explanation: With capacity 27 the days are [2,4,5,7,9], [11,13], [16], [18], [20]: 5 days. With 26, [2,4,5,7] fills the first day and 6 days are needed.
```

**Example 2:**
```
Input: volumes = [4,3,3,5,2,5], days = 3
Output: 8
Explanation: With capacity 8 the days are [4,3], [3,5], [2,5].
```

**Example 3:**
```
Input: volumes = [2,3,4,2,2], days = 4
Output: 4
Explanation: With capacity 4 the days are [2], [3], [4], [2,2]. The capacity can't be below 4, the largest drink.
```$$,
    constraints = $$- `1 <= days <= volumes.length <= 8 * 10^4`
- `1 <= volumes[i] <= 600`$$
WHERE slug = $$min-daily-brew$$;

UPDATE problem_translations SET
    description = $$카페에는 추출할 음료 대기열이 있고, `volumes[i]`는 `i`번 음료의 양입니다. 모든 음료를 대기열 순서대로 `days`일 안에 추출해야 합니다. 바리스타는 매일 똑같이 쓰는 일일 용량 하나를 정합니다. 하루에는 그날 추출한 양의 합이 용량을 넘지 않는 동안 대기열 앞에서부터 음료를 추출하고, 넘게 만드는 다음 음료는 다음 날로 넘어갑니다.

`days`일 안에 모든 음료를 추출할 수 있는 가장 작은 일일 용량을 반환하세요.

**예시 1:**
```
입력: volumes = [2,4,5,7,9,11,13,16,18,20], days = 5
출력: 27
설명: 용량이 27이면 [2,4,5,7,9], [11,13], [16], [18], [20]으로 5일이 걸립니다. 26이면 첫날이 [2,4,5,7]로 끝나 6일이 필요합니다.
```

**예시 2:**
```
입력: volumes = [4,3,3,5,2,5], days = 3
출력: 8
설명: 용량이 8이면 [4,3], [3,5], [2,5]로 3일이 걸립니다.
```

**예시 3:**
```
입력: volumes = [2,3,4,2,2], days = 4
출력: 4
설명: 용량이 4면 [2], [3], [4], [2,2]로 4일이 걸립니다. 가장 큰 음료가 4이므로 용량은 4보다 작을 수 없습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$min-daily-brew-capacity$$);
