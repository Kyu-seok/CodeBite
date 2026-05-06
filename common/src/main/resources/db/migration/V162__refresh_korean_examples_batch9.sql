-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 9 (problems #81-#90)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (numSteps, prereqs, n, relays,
-- ward, yields, scan, traffic, accounts, code, rows, cols, left, right)
-- stay verbatim. First mention of each variable in Korean prose is paired
-- with a Korean noun phrase describing its role. Constraint identifiers
-- are aligned with the canonical English parameter names from V135 / V137
-- source descriptions.

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'order-group-tasks', 'count-voice-parties', 'rotting-donuts', 'pick-circular-donuts',
      'count-cipher-decodings', 'best-boba-streak', 'merge-duplicate-contacts',
      'count-doodle-palindromes', 'count-dungeon-paths', 'desk-notes-overlap'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. order-group-tasks
((SELECT id FROM problems WHERE slug = 'order-group-tasks'), 'ko',
 $$과제 수행 순서$$,
 $$`0`번부터 `numSteps - 1`번까지 라벨이 붙은 `numSteps`개의 과제가 있습니다. 각 항목 `prereqs[i] = [a, b]`는 과제 `b`가 먼저 끝나야 과제 `a`를 시작할 수 있다는 뜻입니다.

선행 관계를 모두 만족하면서 모든 과제를 끝낼 수 있는 유효한 순서 중 아무거나 하나를 반환하세요. 사이클 때문에 모든 과제를 끝내는 것이 불가능하다면 빈 배열을 반환합니다.

**예시 1:**
```
입력: numSteps = 3, prereqs = [[2,0],[1,0]]
출력: [0,1,2]
설명: 과제 0은 선행 과제가 없어서 가장 먼저 실행됩니다. 그 뒤 과제 1과 2는 어떤 순서로도 실행할 수 있고, [0,1,2]는 그중 한 가지 유효한 순서입니다.
```

**예시 2:**
```
입력: numSteps = 5, prereqs = [[1,0],[2,1],[3,1],[4,2],[4,3]]
출력: [0,1,2,3,4]
설명: 0은 1보다 앞서야 하고, 1은 2와 3보다 앞서야 하며, 2와 3은 모두 4보다 앞서야 합니다. [0,1,2,3,4]는 이 모든 간선을 만족합니다.
```$$,
 $$- `1 <= numSteps <= 2000`
- `0 <= prereqs.length <= numSteps * (numSteps - 1)`
- `prereqs[i].length == 2`
- `0 <= a, b < numSteps`
- `a != b`
- `prereqs`의 모든 쌍 `[a, b]`는 서로 다릅니다.$$),

-- 2. count-voice-parties
((SELECT id FROM problems WHERE slug = 'count-voice-parties'), 'ko',
 $$음성 릴레이 파티 세기$$,
 $$협동 게임에 `0`번부터 `n - 1`번까지 라벨이 붙은 `n`명의 플레이어가 있습니다. 각 항목 `relays[i] = [a, b]`는 플레이어 `a`와 `b`가 서로 직접 음성 통신을 할 수 있다는 뜻입니다. 두 플레이어는 릴레이의 사슬로 이어져 있으면 같은 파티에 속한 것으로 봅니다.

서로 분리된 파티의 개수를 반환하도록 `tallyDeviceMeshes(n, relays)`를 구현하세요. 릴레이가 하나도 없는 플레이어는 자기 혼자 한 파티로 셉니다.

**예시 1:**
```
입력: n = 6, relays = [[0,1],[2,3],[3,4]]
출력: 3
설명: 플레이어 `{0,1}`은 릴레이 하나로 이어져 있고, `{2,3,4}`는 사슬로 묶여 있으며, 플레이어 `5`는 혼자입니다. 모두 합쳐 파티가 3개입니다.
```

**예시 2:**
```
입력: n = 7, relays = [[0,1],[1,2],[2,3],[3,4],[4,5],[5,6]]
출력: 1
설명: 모든 플레이어가 릴레이 사슬을 통해 서로에게 닿을 수 있으므로 파티는 하나로 합쳐집니다.
```$$,
 $$- `1 <= n <= 2000`
- `0 <= relays.length <= 5000`
- `relays[i].length == 2`
- `0 <= a, b < n`
- `a != b`
- `relays`에서 같은 쌍이 두 번 이상 나타나지 않습니다.$$),

-- 3. rotting-donuts
((SELECT id FROM problems WHERE slug = 'rotting-donuts'), 'ko',
 $$도넛 상함 전파$$,
 $$`m x n` 크기의 도넛 진열 트레이 `ward`가 주어집니다. 각 칸은 다음 세 가지 상태 중 하나입니다.

- `0` — **빈 자리** (도넛 없음)
- `1` — **신선한 도넛**
- `2` — **상한 도넛**

매 분마다, 상한 도넛과 4방향으로 변을 공유하는 신선한 도넛은 함께 상하게 됩니다. 신선한 도넛이 모두 사라질 때까지 걸리는 최소 분 수를 반환하세요. 어떤 신선한 도넛에도 닿을 수 없으면 `-1`을 반환합니다.

**예시 1:**
```
입력: ward = [[2,1,1],[1,0,1],[1,1,1]]
출력: 4
설명: (0,0)에 있는 단 하나의 상한 도넛에서 시작해, 마지막 신선한 도넛 (2,2)이 4분 뒤 상하게 됩니다.
```

**예시 2:**
```
입력: ward = [[2,0,1],[0,0,1],[1,1,1]]
출력: -1
설명: (0,0)의 상한 도넛이 빈 자리들로 둘러싸여 있어 신선한 도넛에 절대 닿을 수 없습니다.
```

**예시 3:**
```
입력: ward = [[2,0],[0,1]]
출력: -1
설명: 상한 도넛이 빈 자리들로 막혀 있어 신선한 도넛은 끝까지 상하지 않습니다.
```$$,
 $$- `m == ward.length`
- `n == ward[i].length`
- `1 <= m, n <= 10`
- `ward[i][j]`는 `0`, `1`, 또는 `2`입니다.$$),

-- 4. pick-circular-donuts
((SELECT id FROM problems WHERE slug = 'pick-circular-donuts'), 'ko',
 $$원형 도넛 고르기$$,
 $$원형 트레이 위에 도넛 `n`개가 놓여 있습니다. `yields[i]`는 도넛 `i`의 맛 점수입니다. 바로 옆에 붙어 있는 두 도넛을 동시에 집을 수는 없으며, 트레이가 원형이라 첫 번째와 마지막 도넛도 이웃으로 칩니다.

옆자리 금지 규칙을 지키면서 모을 수 있는 맛 점수의 최댓값을 반환하세요.

**예시 1:**
```
입력: yields = [4,1,5,6,2]
출력: 10
설명: yields[0]=4와 yields[3]=6을 고르면 합이 10입니다. yields[4]=2는 yields[0]의 이웃이라 함께 집을 수 없습니다.
```

**예시 2:**
```
입력: yields = [3,8,2,7,1,9]
출력: 24
설명: yields[1]=8, yields[3]=7, yields[5]=9를 골라 합 24를 만듭니다. yields[5]의 이웃인 yields[0]을 건너뛰었기 때문에 가능한 조합입니다.
```$$,
 $$- `1 <= yields.length <= 2 * 10^3`
- `0 <= yields[i] <= 5000`$$),

-- 5. count-cipher-decodings
((SELECT id FROM problems WHERE slug = 'count-cipher-decodings'), 'ko',
 $$디코딩 방법 개수$$,
 $$레트로 암호 게임에서 글자 `A..Z`는 id `1..26`에 대응합니다. 디코딩해야 할 숫자 문자열 `scan`이 주어집니다. `0`으로 시작하는 묶음은 유효하지 않습니다. `05` 같은 id를 가진 카드는 없기 때문입니다.

`scan`을 왼쪽에서 오른쪽으로 `1..26` 범위의 유효한 id들로 나누는 서로 다른 방법의 개수를 반환하세요. 답은 32비트 부호 있는 정수 범위 안에 들어옵니다.

**예시 1:**
```
입력: scan = "1234"
출력: 3
설명: 유효한 분할은 (1,2,3,4), (12,3,4), (1,23,4) 세 가지입니다. `"1234"` 전체를 하나의 id로 보는 것은 너무 크고, `"12,34"`는 34가 26을 넘기 때문에 안 됩니다.
```

**예시 2:**
```
입력: scan = "100"
출력: 0
설명: 두 번째 자리가 0이라 새로운 id를 시작할 수 없고, 마지막의 0도 유효한 id에 해당하지 않습니다.
```$$,
 $$- `1 <= scan.length <= 120`
- `scan`은 십진 숫자로만 구성되며 선행 혹은 중간 `0`을 포함할 수 있습니다.$$),

-- 6. best-boba-streak
((SELECT id FROM problems WHERE slug = 'best-boba-streak'), 'ko',
 $$최고의 손님 흐름 구간$$,
 $$정수 배열 `traffic`은 보바 가게의 시간대별 손님 흐름을 기록합니다. 양수는 손님이 들어온 수, 음수는 나간 수, `0`은 가게 문이 잠시 닫혀 있던 시간을 뜻합니다. 비어 있지 않은 임의의 연속 구간을 골라 그 값들을 모두 곱했을 때 나올 수 있는 **최댓값**을 반환하세요.

어떤 부분배열의 곱이든 부호 있는 32비트 정수 범위에 들어오는 것이 보장됩니다.

**예시 1:**
```
입력: traffic = [3,-1,4,-2,5]
출력: 120
설명: 전체 구간 [3,-1,4,-2,5]의 곱이 120으로, 가능한 연속 구간 곱 중 최댓값입니다.
```

**예시 2:**
```
입력: traffic = [-3,0,2,-4]
출력: 2
설명: 0을 가로지르는 어떤 구간이든 곱이 0이 되어 버리므로, 0을 건너뛰지 않는 가장 좋은 선택은 [2]입니다.
```$$,
 $$- `1 <= traffic.length <= 2 * 10^3`
- `-10 <= traffic[i] <= 10`
- `traffic`의 어떤 연속 부분배열이든 그 곱은 부호 있는 32비트 정수 범위에 들어옵니다.$$),

-- 7. merge-duplicate-contacts
((SELECT id FROM problems WHERE slug = 'merge-duplicate-contacts'), 'ko',
 $$중복 연락처 합치기$$,
 $$공용 사무실의 연락처 목록 `accounts`에 중복이 섞여 있습니다. 각 항목은 사람 이름으로 시작하고, 그 뒤에 그 사람의 이메일들이 이어집니다. 두 항목이 이메일을 하나라도 공유하면 (이행적으로 묶어서) 같은 사람의 항목으로 봅니다. 다만 이름이 같다고 해서 반드시 같은 사람은 아닙니다.

`unifyContactIdentities(accounts)`를 구현하세요. 이메일을 하나라도 공유하는 항목들을 모두 하나로 합치고, 각 합쳐진 항목은 이름 다음에 그 사람의 중복 없는 이메일들을 **사전순으로 정렬**해서 반환합니다. 반환되는 항목들 자체의 순서는 상관없습니다.

**예시 1:**
```
입력: accounts = [["Maya","maya.dp@set.film","mayalens@set.film"],["Maya","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]
출력: [["Maya","maya.dp@set.film","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]
설명: 처음 두 Maya 항목은 `mayalens@set.film`을 공유하므로 하나로 합쳐집니다. 세 번째 Maya는 공유하는 이메일이 없어서 따로 남습니다.
```

**예시 2:**
```
입력: accounts = [["Ash","ash1@set.film","ash2@set.film"],["Bea","bea1@set.film","bea2@set.film"],["Cal","cal1@set.film","cal2@set.film"]]
출력: [["Ash","ash1@set.film","ash2@set.film"],["Bea","bea1@set.film","bea2@set.film"],["Cal","cal1@set.film","cal2@set.film"]]
설명: 공유되는 이메일이 없어서 모든 항목이 그대로 유지되고, 각자의 이메일만 정렬됩니다.
```$$,
 $$- `1 <= accounts.length <= 1500`
- `2 <= accounts[i].length <= 10`
- `1 <= accounts[i][j].length <= 30`
- `accounts[i][0]`은 영문자로 구성됩니다.
- `j > 0`인 `accounts[i][j]`는 유효한 이메일 주소입니다.$$),

-- 8. count-doodle-palindromes
((SELECT id FROM problems WHERE slug = 'count-doodle-palindromes'), 'ko',
 $$거울 구간 세기$$,
 $$글자들을 끄적여 만든 문자열 `code`가 있습니다. **거울 구간(mirror span)** 이란 `code`의 연속 부분 문자열 중에서 앞에서 읽어도 뒤에서 읽어도 같은 것을 말합니다. 한 글자짜리도 모두 거울 구간으로 셉니다.

`code`에 들어 있는 거울 구간의 개수를 반환하도록 `countMirrorSpans(code)`를 구현하세요. 같은 텍스트라도 위치가 다르면 따로 셉니다.

**예시 1:**
```
입력: code = "klmn"
출력: 4
설명: 이웃한 두 글자 중 같은 짝이 없으므로 한 글자짜리 4개만 거울 구간이 됩니다.
```

**예시 2:**
```
입력: code = "rrrr"
출력: 10
설명: 같은 글자가 이어진 구간의 모든 연속 조각이 거울 구간입니다. 길이 4에서는 4 + 3 + 2 + 1 = 10개가 나옵니다.
```$$,
 $$- `1 <= code.length <= 1500`
- `code`는 영어 소문자로만 이루어져 있습니다.$$),

-- 9. count-dungeon-paths
((SELECT id FROM problems WHERE slug = 'count-dungeon-paths'), 'ko',
 $$던전 경로 수 세기$$,
 $$타일로 이루어진 던전이 `rows`행 `cols`열로 펼쳐져 있습니다. 캐릭터는 좌상단 타일에서 출발해 우하단 타일에 있는 보물에 도착해야 하며, 한 번에 한 칸 아래나 한 칸 오른쪽으로만 움직일 수 있습니다.

출발지에서 보물까지 가는 서로 다른 경로의 개수를 반환하도록 `countGateRoutes`를 구현하세요.

**예시 1:**
```
입력: rows = 4, cols = 5
출력: 35
설명: 모든 경로는 정확히 아래로 3번, 오른쪽으로 4번을 어떤 순서로든 섞어서 사용하므로, 그 7번의 이동을 배열하는 방법의 수가 정답입니다.
```

**예시 2:**
```
입력: rows = 2, cols = 6
출력: 6
설명: 아래로 한 번만 내려가면 되므로, 그 한 번을 6개 열 중 어디에서 내려가느냐로 경로가 모두 결정됩니다.
```$$,
 $$- `1 <= rows, cols <= 80`$$),

-- 10. desk-notes-overlap
((SELECT id FROM problems WHERE slug = 'desk-notes-overlap'), 'ko',
 $$겹치는 필기 길이$$,
 $$나와 짝꿍이 각자 필기한 수업 노트는 한 글자짜리 과목 코드의 문자열입니다. 두 문자열에서 같은 순서로 등장하는 글자들의 가장 긴 공통 흐름의 길이를 구하세요(중간에 다른 글자가 끼어 있어도 상관없습니다).

**부분수열(subsequence)** 이란 순서를 바꾸지 않고 글자를 임의로 지워서 얻을 수 있는 문자열입니다. 두 노트 문자열 `left`와 `right`가 주어질 때, 가장 긴 공통 부분수열의 길이를 반환하세요. 공통된 글자가 하나도 없으면 `0`을 반환합니다.

**예시 1:**
```
입력: left = "history", right = "mystery"
출력: 4
설명: 가장 긴 공통 부분수열 중 하나는 "stry"이며 길이는 4입니다.
```

**예시 2:**
```
입력: left = "ocean", right = "canoe"
출력: 3
설명: 가장 긴 공통 부분수열 중 하나는 "can"으로, left의 인덱스 1-3-4와 right의 인덱스 0-1-2에 같은 순서로 나타납니다.
```$$,
 $$- `1 <= left.length, right.length <= 1000`
- `left`와 `right`는 영어 소문자로만 이루어져 있습니다.$$);
