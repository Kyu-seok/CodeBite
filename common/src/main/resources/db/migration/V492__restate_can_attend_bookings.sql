-- V492: can-attend-bookings, text restated. The statement now says the bookings come in no
-- particular order (Example 3 and hidden case 9 are unsorted), and Example 3 gains an
-- explanation. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$A cafe has one window table. `bookings` lists its reservations as `[start, end]`, in minutes after opening, in no particular order.

Return `true` if no two bookings overlap, so the table can host them all, and `false` otherwise. A booking that ends exactly when another one starts does not overlap it.

**Example 1:**
```
Input: bookings = [[18,20],[19,21],[22,23]]
Output: false
Explanation: [18,20] and [19,21] both cover minute 19, so two parties collide.
```

```diagram-intervals
intervals: [[18,20],[19,21],[22,23]]
highlight: [0,1]
```

**Example 2:**
```
Input: bookings = [[18,20],[20,22],[22,23]]
Output: true
Explanation: Each booking ends right when the next starts, so the table turns cleanly.
```

```diagram-intervals
intervals: [[18,20],[20,22],[22,23]]
```

**Example 3:**
```
Input: bookings = [[45,90],[30,60]]
Output: false
Explanation: The list is not sorted: [30,60] starts first, and [45,90] starts at minute 45, before [30,60] ends.
```$$
WHERE slug = $$can-attend-bookings$$;

UPDATE problem_translations SET
    description = $$카페에 창가 테이블이 하나 있습니다. `bookings`는 이 테이블의 예약 목록이며, 각 예약은 개점 후 몇 분인지로 나타낸 구간 `[start, end]`입니다. 예약은 정해진 순서 없이 주어집니다.

어떤 두 예약도 겹치지 않아 테이블이 모든 예약을 받을 수 있으면 `true`, 그렇지 않으면 `false`를 반환하세요. 한 예약이 끝나는 바로 그 시각에 다른 예약이 시작되는 경우는 겹침으로 보지 않습니다.

**예시 1:**
```
입력: bookings = [[18,20],[19,21],[22,23]]
출력: false
설명: [18,20]과 [19,21]이 모두 19분을 포함하므로 두 팀이 충돌합니다.
```

```diagram-intervals
intervals: [[18,20],[19,21],[22,23]]
highlight: [0,1]
```

**예시 2:**
```
입력: bookings = [[18,20],[20,22],[22,23]]
출력: true
설명: 각 예약이 끝나는 시각에 다음 예약이 시작되어 테이블이 깔끔하게 회전합니다.
```

```diagram-intervals
intervals: [[18,20],[20,22],[22,23]]
```

**예시 3:**
```
입력: bookings = [[45,90],[30,60]]
출력: false
설명: 목록이 정렬되어 있지 않습니다. [30,60]이 먼저 시작하고, [45,90]은 [30,60]이 끝나기 전인 45분에 시작합니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$can-attend-bookings$$);
