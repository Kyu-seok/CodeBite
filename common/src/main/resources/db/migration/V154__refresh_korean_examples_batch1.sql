-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 1 (problems #1-#10)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (snacks, lockers, s, t, strs,
-- checkIns, k, rates, seatIds, board, phrase) stay verbatim. First mention
-- of each variable in Korean prose is paired with a Korean noun phrase
-- describing its type or role. Constraint identifiers are also aligned
-- with the canonical English parameter names from V149/V152/V135.

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'snack-drawer-pair', 'spot-duplicate-locker', 'valid-anagram', 'group-anagrams',
      'top-espresso-machines', 'barista-throughput-share', 'longest-seat-run', 'chat-log-codec',
      'valid-sudoku', 'valid-slogan-palindrome'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. snack-drawer-pair
((SELECT id FROM problems WHERE slug = 'snack-drawer-pair'), 'ko',
 $$간식 서랍 짝 찾기$$,
 $$정수 배열 `snacks`는 함께 쓰는 서랍 안의 각 간식이 가진 칼로리 수를 담고 있습니다. 친구와 둘이서 정확히 정수 `target` 칼로리만큼을 함께 먹고 싶습니다.

칼로리의 합이 `target`이 되는 서로 다른 두 간식을 골라 그 인덱스를 반환하세요. 정답이 되는 짝은 정확히 하나이며, 두 인덱스의 순서는 상관없습니다.

**예시 1:**
```
입력: snacks = [4, 11, 19, 23], target = 30
출력: [1, 2]
설명: snacks[1] + snacks[2] = 11 + 19 = 30 이므로 인덱스 1과 2가 정답입니다.
```

**예시 2:**
```
입력: snacks = [8, 14, 6], target = 14
출력: [0, 2]
설명: snacks[0] + snacks[2] = 8 + 6 = 14 이므로 인덱스 0과 2가 정답입니다.
```$$,
 $$- `2 <= snacks.length <= 80000`
- `-10^8 <= snacks[i] <= 10^8`
- `-10^8 <= target <= 10^8`
- 정답 짝이 정확히 하나 존재합니다.$$),

-- 2. spot-duplicate-locker
((SELECT id FROM problems WHERE slug = 'spot-duplicate-locker'), 'ko',
 $$사물함 번호 중복 찾기$$,
 $$담임 반 학생들에게 사물함 번호를 나눠주려는데, 하루가 시작되기 전에 같은 번호가 두 번 배정되지는 않았는지 확인하고 싶습니다. 배정된 번호들이 들어 있는 정수 배열 `lockers`가 주어졌을 때, 같은 번호가 한 번이라도 반복되면 `true`, 그렇지 않으면 `false`를 반환하도록 `detectClash`를 구현하세요.

**예시 1:**
```
입력: lockers = [7,2,9,7]
출력: true
설명: 숫자 `7`이 인덱스 `0`과 인덱스 `3`에서 두 번 등장하므로 중복이 있습니다.
```

**예시 2:**
```
입력: lockers = [11,22,33,44]
출력: false
설명: 모든 사물함 번호가 서로 다릅니다.
```$$,
 $$- `1 <= lockers.length <= 2 * 10^5`
- `-10^8 <= lockers[i] <= 10^8`$$),

-- 3. valid-anagram
((SELECT id FROM problems WHERE slug = 'valid-anagram'), 'ko',
 $$애너그램 확인$$,
 $$두 문자열이 서로 *애너그램*(anagram)이라는 것은 한쪽의 글자들을 재배열해서 다른 쪽을 만들 수 있다는 뜻입니다. 즉, 정확히 같은 글자들이 정확히 같은 개수만큼 들어 있어야 합니다.

소문자로 된 두 문자열 `s`와 `t`가 주어졌을 때, `t`가 `s`의 애너그램이면 `true`를, 아니면 `false`를 반환하세요. 길이가 다른 두 문자열은 결코 애너그램이 될 수 없습니다.

**예시 1:**
```
입력: s = "anagram", t = "nagaram"
출력: true
설명: `s`와 `t`는 글자 `a` 3개, `n` 1개, `g` 1개, `r` 1개, `m` 1개로 같은 글자를 같은 개수만큼 사용하므로 애너그램입니다.
```

**예시 2:**
```
입력: s = "rat", t = "car"
출력: false
설명: 글자 `a`와 `t`는 `s`에는 있지만 `t`에는 없으므로 두 문자열의 글자 다중집합이 다릅니다.
```$$,
 $$- `1 <= s.length, t.length <= 5 * 10^4`
- `s`와 `t`는 영어 소문자로만 이루어져 있습니다.$$),

-- 4. group-anagrams
((SELECT id FROM problems WHERE slug = 'group-anagrams'), 'ko',
 $$그룹 애너그램$$,
 $$소문자로 된 문자열 배열 `strs`가 주어집니다. 서로 *애너그램*(같은 글자가 같은 개수만큼 들어 있어 한쪽을 재배열하면 다른 쪽이 되는 관계)인 문자열들을 같은 그룹으로 묶으세요.

결과는 그룹들의 리스트로 반환합니다. 그룹들 간의 순서나 그룹 안 문자열들의 순서는 상관없습니다.

**예시 1:**
```
입력: strs = ["eat","tea","tan","ate","nat","bat"]
출력: [["bat"],["nat","tan"],["ate","eat","tea"]]
설명: `eat`, `tea`, `ate`는 글자 구성이 같아 한 그룹이고, `tan`과 `nat`도 한 그룹, `bat`은 자기 자신만으로 한 그룹입니다.
```

**예시 2:**
```
입력: strs = [""]
출력: [[""]]
설명: 빈 문자열 하나만 있으므로 빈 문자열로 이루어진 그룹 하나가 결과입니다.
```

**예시 3:**
```
입력: strs = ["a"]
출력: [["a"]]
설명: 원소가 하나뿐이므로 그 자체가 유일한 그룹이 됩니다.
```$$,
 $$- `1 <= strs.length <= 10^4`
- `0 <= strs[i].length <= 100`
- `strs[i]`는 영어 소문자로만 이루어져 있습니다.$$),

-- 5. top-espresso-machines
((SELECT id FROM problems WHERE slug = 'top-espresso-machines'), 'ko',
 $$가장 바빴던 머신 목록$$,
 $$카페에서 아침 러시 동안 사용된 에스프레소 머신을 모두 정수 배열 `checkIns`에 기록합니다. 각 숫자는 머신의 id이며, 매니저는 가장 많이 쓰인 머신 정수 `k`개를 휴게실 화이트보드에 적어두려고 합니다.

`checkIns`에서 가장 자주 등장하는 머신 id `k`개를 반환하는 `busiestMachines`를 구현하세요. 반환 순서는 상관없으며, 상위 `k`개는 유일하게 결정된다고 보장됩니다.

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
 $$- `1 <= checkIns.length <= 2 * 10^5`
- `|checkIns[i]| <= 10^8`
- `k`는 `checkIns`에 등장하는 서로 다른 머신 id 개수 범위 `[1, 개수]` 안의 값입니다.
- 정답은 유일하게 결정된다고 보장됩니다.$$),

-- 6. barista-throughput-share
((SELECT id FROM problems WHERE slug = 'barista-throughput-share'), 'ko',
 $$바리스타 처리량 지분$$,
 $$카페 바리스타들이 한 줄로 서서 일하고 있고, 정수 배열 `rates`의 `rates[i]`는 바리스타 `i`가 한 사이클 동안 만드는 음료 수입니다. 각 바리스타의 **지분**은 자기 자신을 제외한 나머지 모든 바리스타 속도의 곱으로 정의합니다.

`rates`가 주어졌을 때 같은 길이의 배열 `shares`를 반환하세요. `shares[i]`는 모든 `j != i`에 대한 `rates[j]`의 곱과 같아야 합니다. `rates`의 어떤 접두 곱이나 접미 곱도 부호 있는 32비트 정수 범위 안에 들어옵니다. 나눗셈을 사용하지 말고 선형 시간에 풀어야 합니다.

**예시 1:**
```
입력: rates = [2,3,5,4]
출력: [60,40,24,30]
설명: 바리스타 0의 지분은 3*5*4 = 60, 바리스타 1의 지분은 2*5*4 = 40, 바리스타 2의 지분은 2*3*4 = 24, 바리스타 3의 지분은 2*3*5 = 30 입니다.
```

**예시 2:**
```
입력: rates = [-2,1,0,4,-1]
출력: [0,0,8,0,0]
설명: 바리스타 2의 속도가 0이므로 그 위치를 제외한 모든 지분은 0과 곱해져 0이 됩니다. 바리스타 2의 지분만 (-2)*1*4*(-1) = 8 이 됩니다.
```$$,
 $$- `2 <= rates.length <= 2 * 10^5`
- `-30 <= rates[i] <= 30`
- `rates`의 어떤 접두 곱이나 접미 곱도 부호 있는 32비트 정수 범위 안에 들어옵니다.$$),

-- 7. longest-seat-run
((SELECT id FROM problems WHERE slug = 'longest-seat-run'), 'ko',
 $$가장 긴 좌석 구간$$,
 $$정수 배열 `seatIds`는 비어 있는 로비 좌석 번호들이 어떤 순서로든 섞여 있는 목록입니다. `seatIds`의 원소들로 만들 수 있는 **연속된 정수 구간** 중에서 가장 긴 길이를 반환하세요.

중복은 무시하며, 풀이는 O(n) 시간에 동작해야 합니다.

**예시 1:**
```
입력: seatIds = [42,7,41,40,9,8,43]
출력: 4
설명: 연속된 정수 묶음 `40, 41, 42, 43`의 길이가 4로 가장 깁니다.
```

**예시 2:**
```
입력: seatIds = [11,13,12,15,16,14,20,19,18]
출력: 6
설명: 연속된 정수 묶음 `11, 12, 13, 14, 15, 16`의 길이가 6으로 가장 깁니다.
```$$,
 $$- `0 <= seatIds.length <= 2 * 10^5`
- `|seatIds[i]| <= 10^8`$$),

-- 8. chat-log-codec
((SELECT id FROM problems WHERE slug = 'chat-log-codec'), 'ko',
 $$채팅 로그 코덱$$,
 $$협동 게임의 채팅 로그를 위한 코덱을 설계합니다. 보내는 쪽에는 메시지 리스트가 있고, 받는 쪽에는 단 하나의 문자열만 건네줄 수 있으며, 그 문자열로부터 원래 메시지 리스트를 다시 그대로 복원해야 합니다.

다음 두 메서드를 가진 `ListCoder` 클래스를 구현하세요.

- `String pack(List<String> messages)` — 문자열 리스트 `messages`를 하나의 문자열로 인코딩합니다. 각 메시지에는 여러분이 구분자로 고른 문자를 포함해 어떤 문자든 들어갈 수 있으므로, 특정 문자로 단순히 이어 붙이는 방식은 통하지 않습니다.
- `List<String> unpack(String blob)` — `pack`이 만든 문자열 `blob`을 받아 원래 리스트와 순서·길이·내용이 모두 같은 문자열 리스트로 디코딩합니다. 빈 메시지도 그대로 살려야 합니다.

코덱은 상태를 가지지 않아야 합니다. 즉, `unpack`은 오직 `pack`이 내놓은 문자열만 사용해야 하며, 리스트가 비어 있거나 빈 메시지를 포함하거나 구분자처럼 보이는 문자들로만 이루어진 메시지가 있더라도 왕복 변환이 입력을 정확히 재현해야 합니다.$$,
 $$- `0 <= messages.length <= 200`
- `0 <= messages[i].length <= 200`
- 각 `messages[i]`에는 코덱이 구분자나 이스케이프로 사용하는 문자를 포함해 임의의 유니코드 코드 포인트가 들어 있을 수 있습니다.$$),

-- 9. valid-sudoku
((SELECT id FROM problems WHERE slug = 'valid-sudoku'), 'ko',
 $$유효한 스도쿠$$,
 $$9×9 스도쿠 보드 `board`가 부분적으로 채워져 있습니다. 지금까지 놓인 숫자들이 규칙에 맞는지 확인하세요. 빈 칸(`.`)은 어떤 제약도 주지 않지만, 숫자가 채워진 칸은 같은 행, 같은 열, 같은 3×3 서브박스 안의 다른 숫자들과 모두 달라야 합니다.

`board[i][j]`의 각 원소는 `'1'`–`'9'` 사이의 숫자이거나 `'.'`입니다. 어떤 행, 열, 또는 3×3 서브박스에도 같은 숫자가 두 번 나오지 않으면 `true`를, 그렇지 않으면 `false`를 반환하세요. 보드가 끝까지 풀릴 수 있는지는 검사할 필요가 없으며, 이미 채워진 칸들의 유효성만 확인하면 됩니다.

**예시 1:**
```
입력: board = [["5","3",".",".","7",".",".",".","."],["6",".",".","1","9","5",".",".","."],[".","9","8",".",".",".",".","6","."],["8",".",".",".","6",".",".",".","3"],["4",".",".","8",".","3",".",".","1"],["7",".",".",".","2",".",".",".","6"],[".","6",".",".",".",".","2","8","."],[".",".",".","4","1","9",".",".","5"],[".",".",".",".","8",".",".","7","9"]]
출력: true
설명: 채워진 모든 칸이 행·열·3×3 서브박스의 규칙을 어기지 않으므로 보드는 유효합니다.
```

**예시 2:**
```
입력: board = [["8","3",".",".","7",".",".",".","."],["6",".",".","1","9","5",".",".","."],[".","9","8",".",".",".",".","6","."],["8",".",".",".","6",".",".",".","3"],["4",".",".","8",".","3",".",".","1"],["7",".",".",".","2",".",".",".","6"],[".","6",".",".",".",".","2","8","."],[".",".",".","4","1","9",".",".","5"],[".",".",".",".","8",".",".","7","9"]]
출력: false
설명: 가장 왼쪽 열에 숫자 `8`이 두 번 등장하므로 같은 열 안에 같은 숫자가 두 번 나올 수 없다는 규칙이 깨집니다.
```$$,
 $$- `board.length == 9`
- `board[i].length == 9`
- 각 `board[i][j]`는 숫자 `'1'`–`'9'` 또는 문자 `'.'` 입니다.$$),

-- 10. valid-slogan-palindrome
((SELECT id FROM problems WHERE slug = 'valid-slogan-palindrome'), 'ko',
 $$슬로건 회문 검사$$,
 $$범퍼 스티커 슬로건을 담은 문자열 `phrase`가 주어집니다. 알파벳을 모두 소문자로 바꾸고 알파벳·숫자가 아닌 문자를 전부 제거했을 때, 남은 문자열이 앞에서 읽어도 뒤에서 읽어도 똑같으면 `true`, 아니면 `false`를 반환하세요. 빈 문자열도 회문으로 간주합니다.

**예시 1:**
```
입력: phrase = "Step on no pets"
출력: true
설명: 필터링 후 `phrase`는 `"steponnopets"`가 되며, 앞뒤 어느 쪽으로 읽어도 동일하므로 회문입니다.
```

**예시 2:**
```
입력: phrase = "Shelf 7A not mirrored"
출력: false
설명: 필터링 후 `phrase`는 `"shelf7anotmirrored"`가 되며, 앞뒤로 읽었을 때 같지 않으므로 회문이 아닙니다.
```

**예시 3:**
```
입력: phrase = ",,,"
출력: true
설명: 알파벳·숫자가 아닌 문자를 모두 제거하면 빈 문자열이 남고, 빈 문자열은 회문으로 간주합니다.
```$$,
 $$- `1 <= phrase.length <= 2 * 10^5`
- `phrase`는 32 ~ 126 사이의 인쇄 가능한 문자로만 이루어져 있습니다.$$);
