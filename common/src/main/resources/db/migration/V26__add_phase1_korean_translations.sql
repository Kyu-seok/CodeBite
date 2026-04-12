-- Korean translations for Phase 1 new problems

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- Find Duplicates
((SELECT id FROM problems WHERE slug = 'find-duplicates'), 'ko',
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
 '1 <= nums.length <= 10^5
-10^9 <= nums[i] <= 10^9'),

-- Anagram Check
((SELECT id FROM problems WHERE slug = 'anagram-check'), 'ko',
 '애너그램 검사',
 '두 문자열 `s`와 `t`가 주어졌을 때, `t`가 `s`의 애너그램이면 `true`를, 아니면 `false`를 반환하세요.

애너그램이란 다른 단어의 글자를 재배열하여 만든 단어로, 모든 원래 글자를 정확히 한 번씩 사용합니다.

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
 '1 <= s.length, t.length <= 5 * 10^4
s와 t는 소문자 영어 글자로 구성됩니다.'),

-- K Most Frequent
((SELECT id FROM problems WHERE slug = 'k-most-frequent'), 'ko',
 'K개의 최빈 원소',
 '정수 배열 `nums`와 정수 `k`가 주어졌을 때, 가장 빈번하게 나타나는 `k`개의 원소를 반환하세요. 답은 어떤 순서로든 반환할 수 있습니다.

**예시 1:**
```
Input: nums = [1,1,1,2,2,3], k = 2
Output: [1,2]
```

**예시 2:**
```
Input: nums = [1], k = 1
Output: [1]
```',
 '1 <= nums.length <= 10^5
-10^4 <= nums[i] <= 10^4
k는 [1, 배열의 고유 원소 수] 범위입니다.
답이 유일함이 보장됩니다.'),

-- Array Product
((SELECT id FROM problems WHERE slug = 'array-product'), 'ko',
 '배열 곱',
 '정수 배열 `nums`가 주어졌을 때, `answer[i]`가 `nums[i]`를 제외한 나머지 모든 원소의 곱과 같은 배열 `answer`를 반환하세요.

어떤 접두사 또는 접미사의 곱도 32비트 정수에 들어감이 보장됩니다.

나눗셈 연산을 사용하지 않고 O(n) 시간에 동작하는 알고리즘을 작성하세요.

**예시 1:**
```
Input: nums = [1,2,3,4]
Output: [24,12,8,6]
```

**예시 2:**
```
Input: nums = [-1,1,0,-3,3]
Output: [0,0,9,0,0]
```',
 '2 <= nums.length <= 10^5
-30 <= nums[i] <= 30
어떤 접두사 또는 접미사의 곱도 32비트 정수에 들어감이 보장됩니다.'),

-- Longest Streak
((SELECT id FROM problems WHERE slug = 'longest-streak'), 'ko',
 '최장 연속 수열',
 '정렬되지 않은 정수 배열 `nums`가 주어졌을 때, 가장 긴 연속 원소 수열의 길이를 반환하세요.

O(n) 시간에 동작하는 알고리즘을 작성하세요.

**예시 1:**
```
Input: nums = [100,4,200,1,3,2]
Output: 4
Explanation: 가장 긴 연속 수열은 [1, 2, 3, 4]이므로 길이는 4입니다.
```

**예시 2:**
```
Input: nums = [0,3,7,2,5,8,4,6,0,1]
Output: 9
```',
 '0 <= nums.length <= 10^5
-10^9 <= nums[i] <= 10^9'),

-- String Codec
((SELECT id FROM problems WHERE slug = 'string-codec'), 'ko',
 '문자열 코덱',
 '문자열 리스트를 단일 문자열로 인코딩하는 알고리즘을 설계하세요. 인코딩된 문자열은 다시 원래의 문자열 리스트로 디코딩됩니다.

`encode`와 `decode` 메서드를 구현하세요:
- `encode(strs)` — 문자열 리스트를 단일 문자열로 인코딩합니다.
- `decode(s)` — 단일 문자열을 원래의 문자열 리스트로 디코딩합니다.

알고리즘은 무상태여야 합니다: 인코딩된 문자열에 디코딩에 필요한 모든 정보가 포함되어야 합니다.

**예시 1:**
```
Input: strs = ["hello","world"]
Output: ["hello","world"]
Explanation: encode(["hello","world"])로 인코딩된 문자열을 decode하면 원래 리스트를 반환합니다.
```

**예시 2:**
```
Input: strs = [""]
Output: [""]
```',
 '0 <= strs.length <= 200
0 <= strs[i].length <= 200
strs[i]는 구분자 문자를 포함한 모든 가능한 문자를 포함할 수 있습니다.'),

-- Sudoku Validator
((SELECT id FROM problems WHERE slug = 'sudoku-validator'), 'ko',
 '스도쿠 검증기',
 '9 x 9 스도쿠 보드가 유효한지 판별하세요. 채워진 칸만 다음 규칙에 따라 검증하면 됩니다:

1. 각 행에는 1-9 숫자가 중복 없이 포함되어야 합니다.
2. 각 열에는 1-9 숫자가 중복 없이 포함되어야 합니다.
3. 9개의 3 x 3 서브 박스 각각에 1-9 숫자가 중복 없이 포함되어야 합니다.

참고:
- 부분적으로 채워진 스도쿠 보드가 유효할 수 있지만 반드시 풀 수 있는 것은 아닙니다.
- 채워진 칸만 위의 규칙에 따라 검증하면 됩니다.

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
Input: board = (위와 같지만 좌상단 5를 8로 변경)
Output: false
Explanation: 좌상단 3x3 서브 박스에 8이 두 개 있으므로 유효하지 않습니다.
```',
 'board.length == 9
board[i].length == 9
board[i][j]는 숫자 1-9 또는 ''.''입니다.'),

-- Palindrome Checker
((SELECT id FROM problems WHERE slug = 'palindrome-checker'), 'ko',
 '회문 검사기',
 '구문이 회문인지 판별하세요. 모든 대문자를 소문자로 변환하고 영숫자가 아닌 문자를 모두 제거한 후, 앞에서 읽으나 뒤에서 읽으나 같으면 회문입니다.

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
```

**예시 3:**
```
Input: s = " "
Output: true
Explanation: 영숫자가 아닌 문자를 제거하면 빈 문자열이 됩니다. 빈 문자열은 회문입니다.
```',
 '1 <= s.length <= 2 * 10^5
s는 출력 가능한 ASCII 문자로만 구성됩니다.'),

-- Sorted Pair Sum
((SELECT id FROM problems WHERE slug = 'sorted-pair-sum'), 'ko',
 '정렬된 쌍의 합',
 '비내림차순으로 이미 정렬된 1-인덱스 정수 배열 `numbers`가 주어졌을 때, 합이 특정 `target`이 되는 두 수를 찾으세요.

두 수의 인덱스(1-인덱스)를 정수 배열 `[index1, index2]`로 반환하세요. `1 <= index1 < index2 <= numbers.length`입니다.

같은 원소를 두 번 사용할 수 없습니다. 상수 추가 공간만 사용하는 풀이를 작성하세요.

**예시 1:**
```
Input: numbers = [2,7,11,15], target = 9
Output: [1,2]
Explanation: 2와 7의 합이 9입니다. index1 = 1, index2 = 2를 반환합니다.
```

**예시 2:**
```
Input: numbers = [2,3,4], target = 6
Output: [1,3]
```',
 '2 <= numbers.length <= 3 * 10^4
-1000 <= numbers[i] <= 1000
numbers는 비내림차순으로 정렬되어 있습니다.
-1000 <= target <= 1000
정확히 하나의 해가 존재함이 보장됩니다.'),

-- Water Container
((SELECT id FROM problems WHERE slug = 'water-container'), 'ko',
 '물 담기',
 '길이 `n`의 정수 배열 `height`가 주어집니다. `i`번째 선의 두 끝점은 `(i, 0)`과 `(i, height[i])`입니다.

x축과 함께 가장 많은 물을 담을 수 있는 두 선을 찾으세요.

컨테이너가 담을 수 있는 최대 물의 양을 반환하세요.

**예시 1:**
```
Input: height = [1,8,6,2,5,4,8,3,7]
Output: 49
```

**예시 2:**
```
Input: height = [1,1]
Output: 1
```',
 'n == height.length
2 <= n <= 10^5
0 <= height[i] <= 10^4'),

-- Stock Profit
((SELECT id FROM problems WHERE slug = 'stock-profit'), 'ko',
 '주식 수익',
 '배열 `prices`가 주어지며, `prices[i]`는 `i`번째 날의 주식 가격입니다.

하루를 골라 주식을 사고 미래의 다른 날에 팔아서 수익을 최대화하려 합니다.

이 거래에서 얻을 수 있는 최대 수익을 반환하세요. 수익을 얻을 수 없으면 `0`을 반환하세요.

**예시 1:**
```
Input: prices = [7,1,5,3,6,4]
Output: 5
Explanation: 2일차에 사고(가격 = 1) 5일차에 팔면(가격 = 6) 수익 = 6-1 = 5입니다.
```

**예시 2:**
```
Input: prices = [7,6,4,3,1]
Output: 0
```',
 '1 <= prices.length <= 10^5
0 <= prices[i] <= 10^4'),

-- Unique Substring
((SELECT id FROM problems WHERE slug = 'unique-substring'), 'ko',
 '고유 부분 문자열',
 '문자열 `s`가 주어졌을 때, 반복 문자가 없는 가장 긴 부분 문자열의 길이를 구하세요.

**예시 1:**
```
Input: s = "abcabcbb"
Output: 3
Explanation: 답은 "abc"이며 길이는 3입니다.
```

**예시 2:**
```
Input: s = "bbbbb"
Output: 1
```

**예시 3:**
```
Input: s = "pwwkew"
Output: 3
```',
 '0 <= s.length <= 5 * 10^4
s는 영어 글자, 숫자, 기호, 공백으로 구성됩니다.'),

-- Character Swap
((SELECT id FROM problems WHERE slug = 'character-swap'), 'ko',
 '문자 교체',
 '문자열 `s`와 정수 `k`가 주어집니다. 문자열의 아무 문자를 골라 다른 대문자 영어 글자로 바꿀 수 있습니다. 이 작업을 최대 `k`번 수행할 수 있습니다.

위 작업을 수행한 후 같은 글자로 이루어진 가장 긴 부분 문자열의 길이를 반환하세요.

**예시 1:**
```
Input: s = "ABAB", k = 2
Output: 4
Explanation: 두 ''A''를 ''B''로 바꾸거나 그 반대로 합니다.
```

**예시 2:**
```
Input: s = "AABABBA", k = 1
Output: 4
```',
 '1 <= s.length <= 10^5
s는 대문자 영어 글자로만 구성됩니다.
0 <= k <= s.length'),

-- Smallest Window
((SELECT id FROM problems WHERE slug = 'smallest-window'), 'ko',
 '최소 창',
 '길이 `m`과 `n`의 두 문자열 `s`와 `t`가 주어졌을 때, `t`의 모든 문자(중복 포함)가 포함된 `s`의 최소 창 부분 문자열을 반환하세요. 그런 부분 문자열이 없으면 빈 문자열 `""`을 반환하세요.

**예시 1:**
```
Input: s = "ADOBECODEBANC", t = "ABC"
Output: "BANC"
```

**예시 2:**
```
Input: s = "a", t = "a"
Output: "a"
```

**예시 3:**
```
Input: s = "a", t = "aa"
Output: ""
```',
 'm == s.length
n == t.length
1 <= m, n <= 10^5
s와 t는 대소문자 영어 글자로 구성됩니다.'),

-- Minimum Stack
((SELECT id FROM problems WHERE slug = 'minimum-stack'), 'ko',
 '최소 스택',
 'push, pop, top, 최솟값 조회를 상수 시간에 지원하는 스택을 설계하세요.

`MinStack` 클래스를 구현하세요:
- `MinStack()` — 스택 객체를 초기화합니다.
- `void push(int val)` — 원소 `val`을 스택에 넣습니다.
- `void pop()` — 스택 꼭대기의 원소를 제거합니다.
- `int top()` — 스택 꼭대기 원소를 가져옵니다.
- `int getMin()` — 스택의 최솟값을 조회합니다.

각 함수에 대해 O(1) 시간 복잡도의 풀이를 구현하세요.

**예시 1:**
```
Input:
["MinStack","push","push","push","getMin","pop","top","getMin"]
[[],[-2],[0],[-3],[],[],[],[]]
Output: [null,null,null,null,-3,null,0,-2]
```',
 '-2^31 <= val <= 2^31 - 1
pop, top, getMin 연산은 항상 비어있지 않은 스택에서 호출됩니다.
최대 3 * 10^4번의 push, pop, top, getMin 호출이 이루어집니다.'),

-- Basic Binary Search
((SELECT id FROM problems WHERE slug = 'basic-binary-search'), 'ko',
 '기본 이진 탐색',
 '오름차순으로 정렬된 정수 배열 `nums`와 정수 `target`이 주어졌을 때, `nums`에서 `target`을 찾는 함수를 작성하세요. `target`이 존재하면 인덱스를, 아니면 `-1`을 반환하세요.

O(log n) 실행 시간의 알고리즘을 작성하세요.

**예시 1:**
```
Input: nums = [-1,0,3,5,9,12], target = 9
Output: 4
```

**예시 2:**
```
Input: nums = [-1,0,3,5,9,12], target = 2
Output: -1
```',
 '1 <= nums.length <= 10^4
-10^4 < nums[i], target < 10^4
nums의 모든 정수는 고유합니다.
nums는 오름차순으로 정렬되어 있습니다.'),

-- Matrix Search
((SELECT id FROM problems WHERE slug = 'matrix-search'), 'ko',
 '행렬 탐색',
 '다음 두 가지 특성을 가진 `m x n` 정수 행렬이 주어집니다:
- 각 행은 비내림차순으로 정렬되어 있습니다.
- 각 행의 첫 번째 정수는 이전 행의 마지막 정수보다 큽니다.

정수 `target`이 주어졌을 때, 행렬에 있으면 `true`를, 없으면 `false`를 반환하세요.

O(log(m * n)) 시간 복잡도의 풀이를 작성하세요.

**예시 1:**
```
Input: matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 3
Output: true
```

**예시 2:**
```
Input: matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 13
Output: false
```',
 'm == matrix.length
n == matrix[i].length
1 <= m, n <= 100
-10^4 <= matrix[i][j], target <= 10^4'),

-- Rotated Array Min
((SELECT id FROM problems WHERE slug = 'rotated-array-min'), 'ko',
 '회전 배열의 최솟값',
 '길이 `n`의 오름차순 정렬 배열이 1~n번 회전되었다고 가정합니다. 예를 들어, `nums = [0,1,2,4,5,6,7]`은 4번 회전하면 `[4,5,6,7,0,1,2]`가 됩니다.

고유 원소로 이루어진 정렬 후 회전된 배열 `nums`가 주어졌을 때, 이 배열의 최솟값을 반환하세요.

O(log n) 시간에 동작하는 알고리즘을 작성하세요.

**예시 1:**
```
Input: nums = [3,4,5,1,2]
Output: 1
```

**예시 2:**
```
Input: nums = [4,5,6,7,0,1,2]
Output: 0
```

**예시 3:**
```
Input: nums = [11,13,15,17]
Output: 11
```',
 'n == nums.length
1 <= n <= 5000
-5000 <= nums[i] <= 5000
nums의 모든 정수는 고유합니다.'),

-- Merge Sorted Lists
((SELECT id FROM problems WHERE slug = 'merge-sorted-lists'), 'ko',
 '정렬 리스트 병합',
 '두 정렬된 연결 리스트 `list1`과 `list2`의 머리가 주어집니다.

두 리스트를 하나의 정렬된 리스트로 병합하세요. 리스트는 두 리스트의 노드를 이어 붙여 만들어야 합니다.

병합된 연결 리스트의 머리를 반환하세요.

**예시 1:**
```
Input: list1 = [1,2,4], list2 = [1,3,4]
Output: [1,1,2,3,4,4]
```

**예시 2:**
```
Input: list1 = [], list2 = []
Output: []
```

**예시 3:**
```
Input: list1 = [], list2 = [0]
Output: [0]
```',
 '두 리스트의 노드 수는 [0, 50] 범위입니다.
-100 <= Node.val <= 100
list1과 list2는 비내림차순으로 정렬되어 있습니다.'),

-- Cycle Detection
((SELECT id FROM problems WHERE slug = 'cycle-detection'), 'ko',
 '순환 감지',
 '연결 리스트의 `head`가 주어졌을 때, 연결 리스트에 순환이 있는지 판별하세요.

리스트의 어떤 노드에 `next` 포인터를 계속 따라가면 다시 도달할 수 있으면 순환이 있는 것입니다.

연결 리스트에 순환이 있으면 `true`를, 없으면 `false`를 반환하세요.

**예시 1:**
```
Input: head = [3,2,0,-4], pos = 1
Output: true
Explanation: 꼬리가 1번 노드(0-인덱스)에 연결되는 순환이 있습니다.
```

**예시 2:**
```
Input: head = [1,2], pos = 0
Output: true
```

**예시 3:**
```
Input: head = [1], pos = -1
Output: false
```',
 '리스트의 노드 수는 [0, 10^4] 범위입니다.
-10^5 <= Node.val <= 10^5
pos는 -1이거나 연결 리스트의 유효한 인덱스입니다.'),

-- Remove From End
((SELECT id FROM problems WHERE slug = 'remove-from-end'), 'ko',
 '끝에서 제거',
 '연결 리스트의 `head`가 주어졌을 때, 끝에서 `n`번째 노드를 제거하고 머리를 반환하세요.

**예시 1:**
```
Input: head = [1,2,3,4,5], n = 2
Output: [1,2,3,5]
```

**예시 2:**
```
Input: head = [1], n = 1
Output: []
```

**예시 3:**
```
Input: head = [1,2], n = 1
Output: [1]
```',
 '리스트의 노드 수는 sz입니다.
1 <= sz <= 30
0 <= Node.val <= 100
1 <= n <= sz'),

-- Tree Depth
((SELECT id FROM problems WHERE slug = 'tree-depth'), 'ko',
 '트리 깊이',
 '이진 트리의 `root`가 주어졌을 때, 최대 깊이를 반환하세요.

이진 트리의 최대 깊이는 루트 노드에서 가장 먼 리프 노드까지의 경로에 있는 노드의 수입니다.

**예시 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: 3
```

**예시 2:**
```
Input: root = [1,null,2]
Output: 2
```',
 '트리의 노드 수는 [0, 10^4] 범위입니다.
-100 <= Node.val <= 100'),

-- Identical Trees
((SELECT id FROM problems WHERE slug = 'identical-trees'), 'ko',
 '동일한 트리',
 '두 이진 트리의 루트 `p`와 `q`가 주어졌을 때, 두 트리가 같은지 확인하는 함수를 작성하세요.

두 이진 트리는 구조적으로 동일하고 노드의 값이 같으면 같은 것으로 간주합니다.

**예시 1:**
```
Input: p = [1,2,3], q = [1,2,3]
Output: true
```

**예시 2:**
```
Input: p = [1,2], q = [1,null,2]
Output: false
```

**예시 3:**
```
Input: p = [1,2,1], q = [1,1,2]
Output: false
```',
 '두 트리의 노드 수는 [0, 100] 범위입니다.
-10^4 <= Node.val <= 10^4'),

-- Tree Within Tree
((SELECT id FROM problems WHERE slug = 'tree-within-tree'), 'ko',
 '트리 속 트리',
 '두 이진 트리의 루트 `root`와 `subRoot`가 주어졌을 때, `root`에 `subRoot`와 같은 구조와 노드 값을 가진 서브트리가 있으면 `true`를, 없으면 `false`를 반환하세요.

이진 트리의 서브트리는 트리의 한 노드와 그 노드의 모든 자손으로 구성됩니다. 트리 자체도 자신의 서브트리로 간주됩니다.

**예시 1:**
```
Input: root = [3,4,5,1,2], subRoot = [4,1,2]
Output: true
```

**예시 2:**
```
Input: root = [3,4,5,1,2,null,null,null,null,0], subRoot = [4,1,2]
Output: false
```',
 'root 트리의 노드 수는 [1, 2000] 범위입니다.
subRoot 트리의 노드 수는 [1, 1000] 범위입니다.
-10^4 <= root.val <= 10^4
-10^4 <= subRoot.val <= 10^4'),

-- BST Validator
((SELECT id FROM problems WHERE slug = 'bst-validator'), 'ko',
 'BST 검증기',
 '이진 트리의 `root`가 주어졌을 때, 유효한 이진 탐색 트리(BST)인지 판별하세요.

유효한 BST의 정의:
- 왼쪽 서브트리는 노드의 키보다 작은 키만 포함합니다.
- 오른쪽 서브트리는 노드의 키보다 큰 키만 포함합니다.
- 왼쪽과 오른쪽 서브트리 모두 이진 탐색 트리여야 합니다.

**예시 1:**
```
Input: root = [2,1,3]
Output: true
```

**예시 2:**
```
Input: root = [5,1,4,null,null,3,6]
Output: false
```',
 '트리의 노드 수는 [1, 10^4] 범위입니다.
-2^31 <= Node.val <= 2^31 - 1'),

-- BST Ancestor
((SELECT id FROM problems WHERE slug = 'bst-ancestor'), 'ko',
 'BST 공통 조상',
 '이진 탐색 트리(BST)가 주어졌을 때, 두 노드 `p`와 `q`의 최소 공통 조상(LCA) 노드를 찾으세요.

최소 공통 조상은 두 노드 `p`와 `q` 사이에서, `p`와 `q` 모두를 자손으로 가지는 가장 낮은 노드로 정의됩니다(노드가 자기 자신의 자손이 될 수 있습니다).

**예시 1:**
```
Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 8
Output: 6
```

**예시 2:**
```
Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 4
Output: 2
```

**예시 3:**
```
Input: root = [2,1], p = 2, q = 1
Output: 2
```',
 '트리의 노드 수는 [2, 10^5] 범위입니다.
-10^9 <= Node.val <= 10^9
모든 Node.val은 고유합니다.
p != q
p와 q는 BST에 존재합니다.'),

-- Island Counter
((SELECT id FROM problems WHERE slug = 'island-counter'), 'ko',
 '섬 개수',
 '`m x n` 2D 이진 격자 `grid`가 주어지며, ''1''(육지)과 ''0''(물)의 지도를 나타냅니다. 섬의 개수를 반환하세요.

섬은 물로 둘러싸여 있으며 인접한 육지를 수평 또는 수직으로 연결하여 형성됩니다. 격자의 네 모서리 바깥은 모두 물로 둘러싸여 있다고 가정합니다.

**예시 1:**
```
Input: grid = [
  ["1","1","1","1","0"],
  ["1","1","0","1","0"],
  ["1","1","0","0","0"],
  ["0","0","0","0","0"]
]
Output: 1
```

**예시 2:**
```
Input: grid = [
  ["1","1","0","0","0"],
  ["1","1","0","0","0"],
  ["0","0","1","0","0"],
  ["0","0","0","1","1"]
]
Output: 3
```',
 'm == grid.length
n == grid[i].length
1 <= m, n <= 300
grid[i][j]는 ''0'' 또는 ''1''입니다.'),

-- Course Planner
((SELECT id FROM problems WHERE slug = 'course-planner'), 'ko',
 '수강 계획',
 '`0`부터 `numCourses - 1`까지 라벨이 붙은 총 `numCourses`개의 과목을 수강해야 합니다. 배열 `prerequisites`에서 `prerequisites[i] = [a_i, b_i]`는 `a_i` 과목을 수강하려면 먼저 `b_i` 과목을 이수해야 함을 나타냅니다.

모든 과목을 이수할 수 있으면 `true`를, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: numCourses = 2, prerequisites = [[1,0]]
Output: true
Explanation: 과목 1을 수강하려면 과목 0을 먼저 이수해야 합니다. 가능합니다.
```

**예시 2:**
```
Input: numCourses = 2, prerequisites = [[1,0],[0,1]]
Output: false
Explanation: 순환 의존 관계가 있으므로 불가능합니다.
```',
 '1 <= numCourses <= 2000
0 <= prerequisites.length <= 5000
prerequisites[i].length == 2
0 <= a_i, b_i < numCourses
모든 prerequisites[i] 쌍은 고유합니다.'),

-- Staircase
((SELECT id FROM problems WHERE slug = 'staircase'), 'ko',
 '계단 오르기',
 '계단을 오르고 있습니다. 꼭대기에 도달하려면 `n`개의 계단을 올라야 합니다.

매번 1계단 또는 2계단을 오를 수 있습니다. 꼭대기에 도달하는 서로 다른 방법의 수를 구하세요.

**예시 1:**
```
Input: n = 2
Output: 2
Explanation: 1단 + 1단, 또는 2단.
```

**예시 2:**
```
Input: n = 3
Output: 3
Explanation: 1단+1단+1단, 1단+2단, 2단+1단.
```',
 '1 <= n <= 45'),

-- House Thief
((SELECT id FROM problems WHERE slug = 'house-thief'), 'ko',
 '집 털기',
 '길을 따라 있는 집들을 털 계획입니다. 각 집에는 일정 금액이 숨겨져 있는데, 인접한 두 집을 같은 밤에 털면 경보가 울립니다.

각 집의 금액을 나타내는 정수 배열 `nums`가 주어졌을 때, 경보를 울리지 않고 털 수 있는 최대 금액을 반환하세요.

**예시 1:**
```
Input: nums = [1,2,3,1]
Output: 4
Explanation: 1번 집(1)과 3번 집(3)을 털면 합계 = 4.
```

**예시 2:**
```
Input: nums = [2,7,9,3,1]
Output: 12
```',
 '1 <= nums.length <= 100
0 <= nums[i] <= 400'),

-- Coin Picker
((SELECT id FROM problems WHERE slug = 'coin-picker'), 'ko',
 '동전 교환',
 '서로 다른 단위의 동전을 나타내는 정수 배열 `coins`와 총 금액 `amount`가 주어집니다.

해당 금액을 만들기 위해 필요한 최소 동전 수를 반환하세요. 어떤 동전 조합으로도 만들 수 없으면 `-1`을 반환하세요.

각 종류의 동전을 무한히 사용할 수 있습니다.

**예시 1:**
```
Input: coins = [1,5,10], amount = 12
Output: 3
Explanation: 12 = 10 + 1 + 1
```

**예시 2:**
```
Input: coins = [2], amount = 3
Output: -1
```

**예시 3:**
```
Input: coins = [1], amount = 0
Output: 0
```',
 '1 <= coins.length <= 12
1 <= coins[i] <= 2^31 - 1
0 <= amount <= 10^4'),

-- Longest Ascending
((SELECT id FROM problems WHERE slug = 'longest-ascending'), 'ko',
 '최장 증가 부분수열',
 '정수 배열 `nums`가 주어졌을 때, 가장 긴 순증가 부분수열의 길이를 반환하세요.

**예시 1:**
```
Input: nums = [10,9,2,5,3,7,101,18]
Output: 4
Explanation: 최장 증가 부분수열은 [2,3,7,101]이므로 길이는 4입니다.
```

**예시 2:**
```
Input: nums = [0,1,0,3,2,3]
Output: 4
```

**예시 3:**
```
Input: nums = [7,7,7,7,7,7,7]
Output: 1
```',
 '1 <= nums.length <= 2500
-10^4 <= nums[i] <= 10^4'),

-- Word Segmentation
((SELECT id FROM problems WHERE slug = 'word-segmentation'), 'ko',
 '단어 분할',
 '문자열 `s`와 문자열 사전 `wordDict`가 주어졌을 때, `s`를 사전의 단어 하나 이상으로 공백으로 구분하여 분할할 수 있으면 `true`를 반환하세요.

사전의 같은 단어를 분할에서 여러 번 재사용할 수 있습니다.

**예시 1:**
```
Input: s = "codebite", wordDict = ["code","bite"]
Output: true
Explanation: "codebite"를 "code bite"로 분할할 수 있습니다.
```

**예시 2:**
```
Input: s = "applepenapple", wordDict = ["apple","pen"]
Output: true
```

**예시 3:**
```
Input: s = "catsandog", wordDict = ["cats","dog","sand","and","cat"]
Output: false
```',
 '1 <= s.length <= 300
1 <= wordDict.length <= 1000
1 <= wordDict[i].length <= 20
s와 wordDict[i]는 소문자 영어 글자로만 구성됩니다.
wordDict의 모든 문자열은 고유합니다.'),

-- Largest Subarray
((SELECT id FROM problems WHERE slug = 'largest-subarray'), 'ko',
 '최대 부분 배열',
 '정수 배열 `nums`가 주어졌을 때, 합이 가장 큰 부분 배열을 찾아 그 합을 반환하세요.

**예시 1:**
```
Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
Output: 6
Explanation: 부분 배열 [4,-1,2,1]의 합이 6으로 가장 큽니다.
```

**예시 2:**
```
Input: nums = [1]
Output: 1
```

**예시 3:**
```
Input: nums = [5,4,-1,7,8]
Output: 23
```',
 '1 <= nums.length <= 10^5
-10^4 <= nums[i] <= 10^4'),

-- Reach the End
((SELECT id FROM problems WHERE slug = 'reach-the-end'), 'ko',
 '끝에 도달',
 '정수 배열 `nums`가 주어집니다. 배열의 첫 번째 인덱스에서 시작하며, 각 원소는 해당 위치에서의 최대 점프 길이를 나타냅니다.

마지막 인덱스에 도달할 수 있으면 `true`를, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: nums = [2,3,1,1,4]
Output: true
Explanation: 인덱스 0에서 1로 1칸, 인덱스 1에서 마지막으로 3칸 점프.
```

**예시 2:**
```
Input: nums = [3,2,1,0,4]
Output: false
Explanation: 항상 인덱스 3에 도달하게 되며, 최대 점프 길이가 0이라 마지막에 도달할 수 없습니다.
```',
 '1 <= nums.length <= 10^4
0 <= nums[i] <= 10^5'),

-- Rotate Grid
((SELECT id FROM problems WHERE slug = 'rotate-grid'), 'ko',
 '격자 회전',
 '이미지를 나타내는 `n x n` 2D `matrix`가 주어졌을 때, 이미지를 시계 방향으로 90도 회전하세요.

이미지를 제자리에서 회전해야 합니다. 즉, 입력 2D 행렬을 직접 수정해야 합니다. 다른 2D 행렬을 할당하지 마세요.

**예시 1:**
```
Input: matrix = [[1,2,3],[4,5,6],[7,8,9]]
Output: [[7,4,1],[8,5,2],[9,6,3]]
```

**예시 2:**
```
Input: matrix = [[5,1,9,11],[2,4,8,10],[13,3,6,7],[15,14,12,16]]
Output: [[15,13,2,5],[14,3,4,1],[12,6,8,9],[16,7,10,11]]
```',
 'n == matrix.length == matrix[i].length
1 <= n <= 20
-1000 <= matrix[i][j] <= 1000'),

-- Lone Element
((SELECT id FROM problems WHERE slug = 'lone-element'), 'ko',
 '홀로 남은 원소',
 '비어있지 않은 정수 배열 `nums`에서 하나를 제외한 모든 원소가 두 번씩 나타납니다. 한 번만 나타나는 원소를 찾으세요.

선형 시간 복잡도와 상수 추가 공간만 사용하는 풀이를 구현하세요.

**예시 1:**
```
Input: nums = [2,2,1]
Output: 1
```

**예시 2:**
```
Input: nums = [4,1,2,1,2]
Output: 4
```

**예시 3:**
```
Input: nums = [1]
Output: 1
```',
 '1 <= nums.length <= 3 * 10^4
-3 * 10^4 <= nums[i] <= 3 * 10^4
하나를 제외한 모든 원소가 정확히 두 번 나타납니다.');
