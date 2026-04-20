-- Korean translations: batch 1 (problems #1-10)
-- Wipe any pre-existing Korean translations so V77-V96 can repopulate
-- without unique-constraint conflicts.
DELETE FROM problem_translations WHERE locale = 'ko';

------------------------------------------------------------
-- #1 pair-sum
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'pair-sum'),
    'ko',
    '두 수의 합',
    '정수 배열 `nums`와 정수 `target`이 주어졌을 때, 합이 `target`이 되는 두 수의 인덱스를 반환하세요.

각 입력에는 정확히 하나의 정답만 존재하며, 같은 원소를 두 번 사용할 수 없습니다. 답은 어떤 순서로든 반환할 수 있습니다.

**예시 1:**
```
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: nums[0] + nums[1] == 9이므로 [0, 1]을 반환합니다.
```

**예시 2:**
```
Input: nums = [3,2,4], target = 6
Output: [1,2]
```',
    '- `2 <= nums.length <= 10^4`
- `-10^9 <= nums[i] <= 10^9`
- `-10^9 <= target <= 10^9`
- 정답은 정확히 하나만 존재합니다.'
);

------------------------------------------------------------
-- #2 find-duplicates
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'find-duplicates'),
    'ko',
    '중복 찾기',
    '정수 배열 `nums`가 주어졌을 때, 배열에 같은 값이 두 번 이상 나타나면 `true`를, 모든 원소가 고유하면 `false`를 반환하세요.

**예시 1:**
```
Input: nums = [1,2,3,1]
Output: true
Explanation: 원소 1이 인덱스 0과 3에 나타납니다.
```

**예시 2:**
```
Input: nums = [1,2,3,4]
Output: false
Explanation: 모든 원소가 고유합니다.
```

**예시 3:**
```
Input: nums = [1,1,1,3,3,4,3,2,4,2]
Output: true
```',
    '- `1 <= nums.length <= 10^5`
- `-10^9 <= nums[i] <= 10^9`'
);

------------------------------------------------------------
-- #3 anagram-check
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'anagram-check'),
    'ko',
    '애너그램 검사',
    '두 문자열 `s`와 `t`가 주어졌을 때, `t`가 `s`의 애너그램이면 `true`를, 아니면 `false`를 반환하세요.

**애너그램**이란 다른 단어의 글자를 재배열하여 만든 단어로, 모든 원래 글자를 정확히 한 번씩 사용합니다.

**예시 1:**
```
Input: s = "anagram", t = "nagaram"
Output: true
```

**예시 2:**
```
Input: s = "rat", t = "car"
Output: false
```',
    '- `1 <= s.length, t.length <= 5 * 10^4`
- `s`와 `t`는 소문자 영어 알파벳으로만 구성됩니다.'
);

------------------------------------------------------------
-- #4 anagram-groups
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'anagram-groups'),
    'ko',
    '애너그램 그룹',
    '문자열 배열 `strs`가 주어졌을 때, 서로 애너그램인 문자열끼리 그룹으로 묶어 반환하세요. 그룹의 순서는 상관없습니다.

**애너그램**이란 다른 단어의 글자를 재배열하여 만든 단어로, 모든 원래 글자를 정확히 한 번씩 사용합니다.

**예시 1:**
```
Input: strs = ["eat","tea","tan","ate","nat","bat"]
Output: [["ate","eat","tea"],["bat"],["nat","tan"]]
```

**예시 2:**
```
Input: strs = [""]
Output: [[""]]
```

**예시 3:**
```
Input: strs = ["a"]
Output: [["a"]]
```',
    '- `1 <= strs.length <= 10^4`
- `0 <= strs[i].length <= 100`
- `strs[i]`는 소문자 영어 알파벳으로만 구성됩니다.'
);

------------------------------------------------------------
-- #5 k-most-frequent
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'k-most-frequent'),
    'ko',
    'K개의 최빈 원소',
    '정수 배열 `nums`와 정수 `k`가 주어졌을 때, 가장 자주 나타나는 `k`개의 원소를 반환하세요. 답은 어떤 순서로든 반환할 수 있습니다.

답이 유일함이 보장됩니다.

**예시 1:**
```
Input: nums = [1,1,1,2,2,3], k = 2
Output: [1,2]
Explanation: 가장 빈번한 두 원소는 1(3회)과 2(2회)입니다.
```

**예시 2:**
```
Input: nums = [1], k = 1
Output: [1]
```',
    '- `1 <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`
- `k`는 `[1, 배열의 고유 원소 수]` 범위입니다.
- 답이 유일함이 보장됩니다.'
);

------------------------------------------------------------
-- #6 array-product
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'array-product'),
    'ko',
    '배열 곱',
    '정수 배열 `nums`가 주어졌을 때, `answer[i]`가 `nums[i]`를 제외한 나머지 모든 원소의 곱과 같은 배열 `answer`를 반환하세요.

`nums`의 어떤 접두사 또는 접미사의 곱도 32비트 정수 범위 내에 들어감이 보장됩니다.

나눗셈 연산을 사용하지 않고 O(n) 시간에 풀어야 합니다.

**예시 1:**
```
Input: nums = [1,2,3,4]
Output: [24,12,8,6]
Explanation: 인덱스 0: 2 * 3 * 4 = 24, 인덱스 1: 1 * 3 * 4 = 12, 이런 식으로 계산됩니다.
```

**예시 2:**
```
Input: nums = [-1,1,0,-3,3]
Output: [0,0,9,0,0]
```',
    '- `2 <= nums.length <= 10^5`
- `-30 <= nums[i] <= 30`
- `nums`의 어떤 접두사 또는 접미사의 곱도 32비트 정수 범위 내에 들어감이 보장됩니다.'
);

------------------------------------------------------------
-- #7 longest-streak
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'longest-streak'),
    'ko',
    '최장 연속 수열',
    '정렬되지 않은 정수 배열 `nums`가 주어졌을 때, 연속하는 수로 이루어진 가장 긴 수열의 길이를 반환하세요.

O(n) 시간에 풀어야 합니다.

**예시 1:**
```
Input: nums = [100,4,200,1,3,2]
Output: 4
Explanation: 가장 긴 연속 수열은 [1, 2, 3, 4]이며, 길이는 4입니다.
```

**예시 2:**
```
Input: nums = [0,3,7,2,5,8,4,6,0,1]
Output: 9
```',
    '- `0 <= nums.length <= 10^5`
- `-10^9 <= nums[i] <= 10^9`'
);

------------------------------------------------------------
-- #8 string-codec
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'string-codec'),
    'ko',
    '문자열 인코딩/디코딩',
    '문자열 리스트를 하나의 문자열로 인코딩하고, 그 문자열을 다시 원래 리스트로 디코딩하는 알고리즘을 설계하세요.

두 가지 메서드를 구현합니다:
- `encode(strs)` — 문자열 리스트를 받아 하나의 인코딩된 문자열을 반환합니다.
- `decode(s)` — 인코딩된 문자열을 받아 원래 문자열 리스트를 반환합니다.

알고리즘은 **상태를 저장하지 않아야(stateless)** 합니다. 즉, 인코딩된 문자열만으로 디코딩에 필요한 모든 정보를 담고 있어야 합니다. 문자열에는 구분자를 포함한 어떤 문자든 들어올 수 있습니다.

**예시 1:**
```
Input: strs = ["hello","world"]
Output: ["hello","world"]
Explanation: encode(["hello","world"])가 인코딩된 문자열을 만들고, 그것을 decode하면 원래 리스트가 복원됩니다.
```

**예시 2:**
```
Input: strs = [""]
Output: [""]
```

**예시 3:**
```
Input: strs = ["","",""]
Output: ["","",""]
```',
    '- `0 <= strs.length <= 200`
- `0 <= strs[i].length <= 200`
- `strs[i]`에는 구분자를 포함한 모든 문자가 들어올 수 있습니다.'
);

------------------------------------------------------------
-- #9 sudoku-validator
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'sudoku-validator'),
    'ko',
    '스도쿠 검증',
    '9 x 9 스도쿠 보드가 유효한지 판별하세요. 숫자가 채워진 칸만 다음 규칙에 따라 검증하면 됩니다:

1. 각 행에는 `1`-`9` 숫자가 중복 없이 포함되어야 합니다.
2. 각 열에는 `1`-`9` 숫자가 중복 없이 포함되어야 합니다.
3. 9개의 3 x 3 서브 박스 각각에 `1`-`9` 숫자가 중복 없이 포함되어야 합니다.

부분적으로 채워진 보드도 풀 수 없더라도 유효할 수 있습니다. 빈 칸은 `"."`으로 표시됩니다.

**예시 1:**
```
Input: board =
[["5","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]
Output: true
```

**예시 2:**
```
Input: board =
[["8","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]
Output: false
Explanation: 예시 1과 동일하지만 좌측 상단의 5가 8로 바뀌었습니다. 좌측 상단 3x3 서브 박스에 8이 두 개 있으므로 유효하지 않습니다.
```',
    '- `board.length == 9`
- `board[i].length == 9`
- `board[i][j]`는 숫자 `1-9` 또는 `''.''`입니다.'
);

------------------------------------------------------------
-- #10 palindrome-checker
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'palindrome-checker'),
    'ko',
    '회문 검사',
    '**회문(palindrome)**이란 대문자를 소문자로 바꾸고 영숫자가 아닌 문자를 모두 제거한 후, 앞에서 읽으나 뒤에서 읽으나 같은 문구를 말합니다. 영숫자 문자에는 알파벳과 숫자가 포함됩니다.

문자열 `s`가 주어졌을 때, 회문이면 `true`를, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: s = "A man, a plan, a canal: Panama"
Output: true
Explanation: "amanaplanacanalpanama"는 회문입니다.
```

**예시 2:**
```
Input: s = "race a car"
Output: false
Explanation: "raceacar"는 회문이 아닙니다.
```

**예시 3:**
```
Input: s = " "
Output: true
Explanation: 영숫자가 아닌 문자를 제거하면 빈 문자열 ""이 됩니다. 빈 문자열은 앞뒤로 읽어도 같으므로 회문입니다.
```',
    '- `1 <= s.length <= 2 * 10^5`
- `s`는 출력 가능한 ASCII 문자로만 구성됩니다.'
);
