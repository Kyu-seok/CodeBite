-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 5 (problems #41-#50)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (snacks, bagSizes, quota,
-- scores, headline, topics, slack, seatings, cafeMap, frames, TopKStream,
-- record, val, k) stay verbatim. First mention of each variable in
-- Korean prose is paired with a Korean noun phrase describing its role.
-- Constraint identifiers are aligned with the canonical English parameter
-- names from V135 / V137 source descriptions.

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'pick-snack-haul', 'fewest-candy-bags', 'longest-quiz-streak', 'word-break-chat',
      'peak-score-streak', 'finish-the-level', 'merge-reservation-slots', 'rotate-pet-cafe-map',
      'lonely-candy', 'kth-top-score-stream'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. pick-snack-haul
((SELECT id FROM problems WHERE slug = 'pick-snack-haul'), 'ko',
 $$간식 털이 최대화$$,
 $$복도에 자판기들이 한 줄로 늘어서 있습니다. 정수 배열 `snacks`의 `snacks[i]`는 자판기 `i`에서 얻을 수 있는 간식의 양입니다. 전선이 오래돼서, 한 번의 순회에서 이웃한 두 자판기를 연달아 털면 퓨즈가 나가버립니다.

이웃한 자판기는 같이 고르지 않는다는 조건 아래, 얻을 수 있는 간식의 최대 합을 반환하세요.

**예시 1:**
```
입력: snacks = [4,1,1,9,1,3]
출력: 16
설명: 자판기 0, 3, 5번을 털면 4 + 9 + 3 = 16 입니다. 인접하지 않게 고르는 다른 어떤 조합도 이 합을 넘지 못합니다.
```

**예시 2:**
```
입력: snacks = [5,5,10,100,10,5]
출력: 110
설명: 자판기 1, 3, 5번을 털면 5 + 100 + 5 = 110 입니다. 자판기 3번만 털면 100점이고, 자판기 3번을 건너뛰는 어떤 조합도 이 합을 따라잡을 수 없습니다.
```$$,
 $$- `1 <= snacks.length <= 100`
- `0 <= snacks[i] <= 400`$$),

-- 2. fewest-candy-bags
((SELECT id FROM problems WHERE slug = 'fewest-candy-bags'), 'ko',
 $$최소 사탕 봉지 수$$,
 $$영화의 밤을 준비하며 사탕을 나눠 담으려 합니다. 찬장에는 크기가 정해진 봉지가 몇 종류 있고, 같은 크기의 봉지는 원하는 만큼 꺼내 쓸 수 있어요. 정확히 정수 `quota`개의 사탕을 담되, 봉지를 가장 적게 쓰는 방법을 찾아야 합니다.

봉지 크기 목록 `bagSizes`에서 봉지들을 골라 합이 `quota`가 되도록 하는 최소 봉지 수를 반환하는 `fewestBagSizes(bagSizes, quota)`를 구현하세요. 어떤 조합으로도 만들 수 없다면 `-1`을 반환합니다.

**예시 1:**
```
입력: bagSizes = [2,4,7], quota = 15
출력: 3
설명: 크기 4, 4, 7인 봉지 세 개를 쓰면 합이 15가 됩니다. 봉지 두 개로 합이 15가 되는 조합은 없으므로 최소 개수는 3입니다.
```

**예시 2:**
```
입력: bagSizes = [3,5], quota = 4
출력: -1
설명: 크기가 3과 5인 봉지만으로는 합이 정확히 4가 되도록 만들 수 없습니다.
```$$,
 $$- `1 <= bagSizes.length <= 12`
- `1 <= bagSizes[i] <= 2^31 - 1`
- `0 <= quota <= 10^4`$$),

-- 3. longest-quiz-streak
((SELECT id FROM problems WHERE slug = 'longest-quiz-streak'), 'ko',
 $$가장 긴 상승 퀴즈 수열$$,
 $$매주 본 퀴즈 점수가 본 순서대로 정수 배열 `scores`에 들어 있습니다. 가장 긴 **순증가 부분수열**의 길이를 반환하세요. 퀴즈를 건너뛰어도 되지만 시간 순서는 유지해야 하며, 연속해서 고른 두 점수는 반드시 `scores[i] < scores[j]`를 만족해야 합니다.

**예시 1:**
```
입력: scores = [4,10,2,6,3,5,8,11]
출력: 5
설명: 인덱스 2, 4, 5, 6, 7에서 뽑은 부분수열 `[2,3,5,8,11]`은 순증가하며 길이가 5입니다.
```

**예시 2:**
```
입력: scores = [9,2,7,4,6,8]
출력: 4
설명: 부분수열 `[2,4,6,8]`의 길이가 4이며, 길이 5짜리 순증가 부분수열은 만들 수 없습니다.
```$$,
 $$- `1 <= scores.length <= 2500`
- `-10^4 <= scores[i] <= 10^4`$$),

-- 4. word-break-chat
((SELECT id FROM problems WHERE slug = 'word-break-chat'), 'ko',
 $$헤드라인 토큰 나누기$$,
 $$채팅 메시지를 담은 문자열 `headline`은 공백이 모두 제거된 상태입니다. 알려진 슬랭 단어 목록은 문자열 배열 `topics`에 들어 있습니다.

`headline`을 `topics` 안의 단어들(같은 단어를 여러 번 사용해도 됩니다)을 이어 붙인 형태로 분리할 수 있으면 `true`, 그렇지 않으면 `false`를 반환하세요.

**예시 1:**
```
입력: headline = "morningwire", topics = ["morning","wire"]
출력: true
설명: `headline`을 `"morning wire"`로 나눌 수 있습니다.
```

**예시 2:**
```
입력: headline = "topstoryalert", topics = ["top","story","alert"]
출력: true
설명: `headline`을 `"top story alert"`로 나눌 수 있습니다.
```

**예시 3:**
```
입력: headline = "breakingnews", topics = ["break","breaking","new","ing"]
출력: false
설명: 어떤 접두 단어를 골라도 남은 부분을 끝까지 덮을 수 없습니다. `"news"`로 시작하는 단어가 없고, 끝에 남는 `"s"`로 끝나는 단어도 없기 때문입니다.
```$$,
 $$- `1 <= headline.length <= 300`
- `1 <= topics.length <= 1000`
- `1 <= topics[i].length <= 20`
- `headline`과 `topics[i]`는 영어 소문자로만 이루어져 있습니다.
- `topics`의 모든 문자열은 서로 다릅니다.$$),

-- 5. peak-score-streak
((SELECT id FROM problems WHERE slug = 'peak-score-streak'), 'ko',
 $$최고 점수 구간$$,
 $$리듬 게임에서 노트 하나를 쳤을 때 얻거나 잃는 점수가 정수 배열 `scores`의 각 원소에 들어 있습니다. 합이 가장 큰 **연속된 비어 있지 않은 노트 구간**을 찾아 그 합을 반환하세요.

**예시 1:**
```
입력: scores = [3,-2,5,-1,2,-8,4,3]
출력: 7
설명: 구간 `[3,-2,5,-1,2]`의 합 7이 가장 큽니다.
```

**예시 2:**
```
입력: scores = [2,1,-3,6,4]
출력: 10
설명: 구간 `[6,4]`의 합이 10입니다. 배열 전체의 합도 10이라 둘 다 최댓값이 됩니다.
```$$,
 $$- `1 <= scores.length <= 10^5`
- `-10^4 <= scores[i] <= 10^4`$$),

-- 6. finish-the-level
((SELECT id FROM problems WHERE slug = 'finish-the-level'), 'ko',
 $$레벨 클리어 가능?$$,
 $$`n`개의 타일로 이루어진 플랫포머 레벨에서 타일 `0`부터 시작합니다. 정수 배열 `slack`의 `slack[i]`는 타일 `i`에서 한 번에 점프할 수 있는 최대 거리이며, `0`이면 그 타일이 함정임을 뜻합니다.

타일 `n - 1`에 도달할 수 있으면 `true`, 그렇지 않으면 `false`를 반환하는 `canFinishLine(slack)`을 구현하세요.

**예시 1:**
```
입력: slack = [2,1,3,1,1,2]
출력: true
설명: 0 -> 2 (2칸 점프), 2 -> 5 (3칸 점프) 경로로 마지막 타일 5에 도달할 수 있습니다.
```

**예시 2:**
```
입력: slack = [2,0,0,1,3]
출력: false
설명: 타일 0에서 갈 수 있는 곳은 타일 1과 타일 2뿐인데 둘 다 함정이라 타일 3까지 갈 수 없습니다.
```$$,
 $$- `1 <= slack.length <= 10^4`
- `0 <= slack[i] <= 10^5`$$),

-- 7. merge-reservation-slots
((SELECT id FROM problems WHERE slug = 'merge-reservation-slots'), 'ko',
 $$예약 창 합치기$$,
 $$브런치 예약 시간이 `seatings[i] = [start_i, end_i]` 형태로 정수 배열 `seatings`에 들어 있습니다. 두 예약이 한 점에서라도 만나면(끝점이 같은 경우도 겹치는 것으로 간주합니다) 하나로 합쳐, 원래의 모든 예약을 덮으면서 서로 겹치지 않는 가장 짧은 구간 목록을 시작 시각 기준으로 정렬해 반환하세요.

**예시 1:**
```
입력: seatings = [[2,5],[4,7],[9,11],[14,16]]
출력: [[2,7],[9,11],[14,16]]
설명: `[2,5]`와 `[4,7]`은 4분과 5분이 겹치므로 `[2,7]`로 합쳐집니다. 나머지 두 구간은 따로 남습니다.
```

**예시 2:**
```
입력: seatings = [[1,3],[3,8],[10,12]]
출력: [[1,8],[10,12]]
설명: `[1,3]`과 `[3,8]`은 3분에서 끝점이 맞닿아 있으므로 겹치는 것으로 보고 `[1,8]`로 합쳐집니다.
```$$,
 $$- `1 <= seatings.length <= 10^4`
- `seatings[i].length == 2`
- `0 <= start_i <= end_i <= 10^4`$$),

-- 8. rotate-pet-cafe-map
((SELECT id FROM problems WHERE slug = 'rotate-pet-cafe-map'), 'ko',
 $$펫 카페 지도 회전$$,
 $$펫 카페 좌석 격자가 옆으로 누운 채 저장됐고 태블릿에는 사본을 만들 공간이 없습니다. 격자를 시계 방향으로 90도 **그 자리에서** 회전시켜야 합니다.

`n x n` 정수 격자 `cafeMap`이 주어집니다. `rotateParkMap`을 구현해 `cafeMap`을 시계 방향으로 90도 회전하세요. `cafeMap`을 직접 수정해야 하며, 별도의 `n x n` 격자를 새로 할당해서는 안 됩니다.

**예시 1:**
```
입력: cafeMap = [[2,4,6],[8,1,3],[5,7,9]]
출력: [[5,8,2],[7,1,4],[9,3,6]]
```

**예시 2:**
```
입력: cafeMap = [[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]
출력: [[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]
```$$,
 $$- `n == cafeMap.length == cafeMap[i].length`
- `1 <= n <= 20`
- `-1000 <= cafeMap[i][j] <= 1000`$$),

-- 9. lonely-candy
((SELECT id FROM problems WHERE slug = 'lonely-candy'), 'ko',
 $$외톨이 사탕 찾기$$,
 $$사탕 한 봉지를 통째로 식탁에 쏟았습니다. 모든 맛은 두 번씩 등장하는데 딱 하나만 외톨이로 한 번만 등장합니다. 그 외톨이를 찾아주세요.

정수 배열 `frames`가 주어지며, 한 값을 제외한 모든 값이 정확히 두 번씩 등장하고 단 하나의 값만 한 번 등장합니다. 그 한 번만 등장하는 값을 반환하세요. 풀이는 O(n) 시간과 O(1) 추가 공간을 사용해야 합니다.

**예시 1:**
```
입력: frames = [5,5,3]
출력: 3
설명: `5`는 두 번 등장하고 `3`만 한 번 등장합니다.
```

**예시 2:**
```
입력: frames = [8,2,6,2,6]
출력: 8
설명: `2`와 `6`은 각각 두 번씩 등장하고 `8`만 외톨이입니다.
```$$,
 $$- `1 <= frames.length <= 3 * 10^4`
- `-3 * 10^4 <= frames[i] <= 3 * 10^4`
- 한 값을 제외한 모든 값이 정확히 두 번씩 등장합니다.$$),

-- 10. kth-top-score-stream
((SELECT id FROM problems WHERE slug = 'kth-top-score-stream'), 'ko',
 $$실시간 K번째 최고 점수$$,
 $$길드가 레이드 점수를 한 번에 하나씩 게시합니다. 새 점수가 들어올 때마다 현재까지의 점수 중 정수 `k`번째로 큰 값을 추적하세요. 같은 값이 여러 번 나와도 각각 자기 자리를 차지하므로, `k`번째로 큰 값은 정렬된 목록에서 위치 `k`에 있는 값을 의미합니다.

`TopKStream` 클래스를 구현하세요.

- `TopKStream(int k, int[] scores)` — 추적기에 순위 `k`와 처음 받은 레이드 점수 배열 `scores`를 넣어 초기화합니다.
- `int record(int val)` — 새 점수 `val`을 스트림에 추가하고, 지금까지의 스트림에서 `k`번째로 큰 점수를 반환합니다.

**예시 1:**
```
입력:
["TopKStream", "record", "record", "record", "record", "record"]
[[3, [4, 5, 8, 2]], [3], [5], [10], [9], [4]]
출력: [null, 4, 5, 5, 8, 8]

설명:
TopKStream tracker = new TopKStream(3, [4, 5, 8, 2]);
tracker.record(3);   // 스트림이 [4,5,8,2,3]; 3번째로 큰 값은 4
tracker.record(5);   // 스트림이 [4,5,8,2,3,5]; 3번째로 큰 값은 5
tracker.record(10);  // 스트림이 [4,5,8,2,3,5,10]; 3번째로 큰 값은 5
tracker.record(9);   // 스트림이 [4,5,8,2,3,5,10,9]; 3번째로 큰 값은 8
tracker.record(4);   // 스트림이 [4,5,8,2,3,5,10,9,4]; 3번째로 큰 값은 8
```

리더보드는 끊임없이 갱신되므로, 점수가 들어올 때마다 전체를 다시 정렬하는 방식으로는 속도를 따라잡을 수 없습니다.$$,
 $$- `1 <= k <= 10^4`
- `0 <= scores.length <= 10^4`
- `-10^4 <= scores[i] <= 10^4`
- `-10^4 <= val <= 10^4`
- `record`는 최대 `10^4`번 호출됩니다.
- `k`번째 값을 조회할 때 스트림에 적어도 `k`개의 값이 들어 있도록 보장됩니다.$$);
