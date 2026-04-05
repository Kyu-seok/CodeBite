-- Korean translations for all problems

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. Two Sum
((SELECT id FROM problems WHERE slug = 'two-sum'), 'ko',
 '두 수의 합',
 '정수 배열 `nums`와 정수 `target`이 주어졌을 때, 두 수의 합이 `target`이 되는 두 수의 인덱스를 반환하세요.

각 입력에는 정확히 하나의 해답이 존재하며, 같은 요소를 두 번 사용할 수 없습니다.

답은 어떤 순서로든 반환할 수 있습니다.

**예시 1:**
```
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: nums[0] + nums[1] == 9 이므로 [0, 1]을 반환합니다.
```

**예시 2:**
```
Input: nums = [3,2,4], target = 6
Output: [1,2]
```',
 '2 <= nums.length <= 10^4
-10^9 <= nums[i] <= 10^9
-10^9 <= target <= 10^9
정답은 정확히 하나만 존재합니다.'),

-- 2. FizzBuzz
((SELECT id FROM problems WHERE slug = 'fizzbuzz'), 'ko',
 '피즈버즈',
 '정수 `n`이 주어졌을 때, 1부터 `n`까지의 문자열 배열 `answer`를 반환하세요:

- `answer[i] == "FizzBuzz"` — `i`가 3과 5로 나누어지는 경우
- `answer[i] == "Fizz"` — `i`가 3으로 나누어지는 경우
- `answer[i] == "Buzz"` — `i`가 5로 나누어지는 경우
- `answer[i] == i` (문자열) — 위 조건에 해당하지 않는 경우

**예시:**
```
Input: n = 5
Output: ["1","2","Fizz","4","Buzz"]
```',
 '1 <= n <= 10^4'),

-- 3. Reverse String
((SELECT id FROM problems WHERE slug = 'reverse-string'), 'ko',
 '문자열 뒤집기',
 '문자열을 뒤집는 함수를 작성하세요. 입력 문자열은 문자 배열 `s`로 주어집니다.

추가 메모리 O(1)만 사용하여 배열을 직접 수정해야 합니다.

**예시 1:**
```
Input: s = ["h","e","l","l","o"]
Output: ["o","l","l","e","h"]
```

**예시 2:**
```
Input: s = ["H","a","n","n","a","h"]
Output: ["h","a","n","n","a","H"]
```',
 '1 <= s.length <= 10^5
s[i]는 출력 가능한 ASCII 문자입니다.'),

-- 4. Valid Parentheses
((SELECT id FROM problems WHERE slug = 'valid-parentheses'), 'ko',
 '유효한 괄호',
 '`(`, `)`, `{`, `}`, `[`, `]` 문자만 포함하는 문자열 `s`가 주어졌을 때, 입력 문자열이 유효한지 판별하세요.

입력 문자열은 다음 조건을 만족해야 유효합니다:
1. 여는 괄호는 같은 종류의 닫는 괄호로 닫혀야 합니다.
2. 여는 괄호는 올바른 순서로 닫혀야 합니다.
3. 모든 닫는 괄호에는 대응하는 같은 종류의 여는 괄호가 있어야 합니다.

**예시 1:**
```
Input: s = "()"
Output: true
```

**예시 2:**
```
Input: s = "()[]{}"
Output: true
```

**예시 3:**
```
Input: s = "(]"
Output: false
```',
 '1 <= s.length <= 10^4
s는 괄호 문자 ''()[]{}''로만 구성됩니다.'),

-- 5. Palindrome Number
((SELECT id FROM problems WHERE slug = 'palindrome-number'), 'ko',
 '회문 수',
 '정수 `x`가 주어졌을 때, `x`가 회문(palindrome)이면 `true`를, 아니면 `false`를 반환하세요.

회문은 앞에서 읽으나 뒤에서 읽으나 같은 수를 말합니다.

**예시 1:**
```
Input: x = 121
Output: true
Explanation: 121은 왼쪽에서 오른쪽으로, 오른쪽에서 왼쪽으로 모두 121입니다.
```

**예시 2:**
```
Input: x = -121
Output: false
Explanation: 왼쪽에서 오른쪽으로 -121이지만, 오른쪽에서 왼쪽으로는 121-입니다. 따라서 회문이 아닙니다.
```',
 '-2^31 <= x <= 2^31 - 1'),

-- 6. Sqrt(x)
((SELECT id FROM problems WHERE slug = 'sqrtx'), 'ko',
 '제곱근',
 '음이 아닌 정수 `x`가 주어졌을 때, `x`의 제곱근을 내림하여 가장 가까운 정수로 반환하세요.

내장 지수 함수나 연산자를 사용해서는 안 됩니다.

**예시 1:**
```
Input: x = 4
Output: 2
Explanation: 4의 제곱근은 2이므로 2를 반환합니다.
```

**예시 2:**
```
Input: x = 8
Output: 2
Explanation: 8의 제곱근은 2.82842...이고, 내림하면 2입니다.
```',
 '0 <= x <= 2^31 - 1'),

-- 7. Reverse Words in a String
((SELECT id FROM problems WHERE slug = 'reverse-words-in-a-string'), 'ko',
 '문자열의 단어 뒤집기',
 '입력 문자열 `s`가 주어졌을 때, 단어의 순서를 뒤집으세요.

단어는 공백이 아닌 문자의 연속입니다. `s`의 단어는 하나 이상의 공백으로 구분됩니다.

단어의 순서를 뒤집어 하나의 공백으로 구분된 문자열을 반환하세요.

`s`에는 앞뒤 공백이나 단어 사이에 여러 개의 공백이 있을 수 있습니다. 반환되는 문자열에는 단어 사이에 하나의 공백만 있어야 합니다.

**예시 1:**
```
Input: s = "the sky is blue"
Output: "blue is sky the"
```

**예시 2:**
```
Input: s = "  hello world  "
Output: "world hello"
Explanation: 뒤집은 문자열에는 앞뒤 공백이 없어야 합니다.
```

**예시 3:**
```
Input: s = "a good   example"
Output: "example good a"
Explanation: 단어 사이의 여러 공백을 하나로 줄여야 합니다.
```',
 '1 <= s.length <= 10^4
s는 영문자(대소문자), 숫자, 공백 '' ''을 포함합니다.
s에는 최소 하나의 단어가 있습니다.'),

-- 8. Plus One
((SELECT id FROM problems WHERE slug = 'plus-one'), 'ko',
 '1 더하기',
 '큰 정수가 정수 배열 `digits`로 표현됩니다. `digits[i]`는 정수의 i번째 자릿수이며, 가장 높은 자릿수부터 가장 낮은 자릿수 순서로 왼쪽에서 오른쪽으로 정렬됩니다. 큰 정수에는 선행 0이 없습니다.

큰 정수에 1을 더한 결과를 배열로 반환하세요.

**예시 1:**
```
Input: digits = [1,2,3]
Output: [1,2,4]
Explanation: 배열은 정수 123을 나타냅니다. 1을 더하면 123 + 1 = 124이므로 [1,2,4]를 반환합니다.
```

**예시 2:**
```
Input: digits = [4,3,2,1]
Output: [4,3,2,2]
Explanation: 배열은 정수 4321을 나타냅니다. 1을 더하면 4321 + 1 = 4322이므로 [4,3,2,2]를 반환합니다.
```

**예시 3:**
```
Input: digits = [9]
Output: [1,0]
Explanation: 배열은 정수 9를 나타냅니다. 1을 더하면 9 + 1 = 10이므로 [1,0]을 반환합니다.
```',
 '1 <= digits.length <= 100
0 <= digits[i] <= 9
digits에는 선행 0이 없습니다.'),

-- 9. Pascal's Triangle
((SELECT id FROM problems WHERE slug = 'pascals-triangle'), 'ko',
 '파스칼의 삼각형',
 '정수 `numRows`가 주어졌을 때, 파스칼의 삼각형의 첫 `numRows` 행을 반환하세요.

파스칼의 삼각형에서 각 수는 바로 위의 두 수의 합입니다.

**예시 1:**
```
Input: numRows = 5
Output: [[1],[1,1],[1,2,1],[1,3,3,1],[1,4,6,4,1]]
```

**예시 2:**
```
Input: numRows = 1
Output: [[1]]
```',
 '1 <= numRows <= 30'),

-- 10. Reverse Linked List
((SELECT id FROM problems WHERE slug = 'reverse-linked-list'), 'ko',
 '연결 리스트 뒤집기',
 '단일 연결 리스트의 `head`가 주어졌을 때, 리스트를 뒤집어 반환하세요.

**예시 1:**
```
Input: head = [1,2,3,4,5]
Output: [5,4,3,2,1]
```

**예시 2:**
```
Input: head = [1,2]
Output: [2,1]
```

**예시 3:**
```
Input: head = []
Output: []
```',
 '노드의 수는 [0, 5000] 범위입니다.
-5000 <= Node.val <= 5000'),

-- 11. Invert Binary Tree
((SELECT id FROM problems WHERE slug = 'invert-binary-tree'), 'ko',
 '이진 트리 반전',
 '이진 트리의 `root`가 주어졌을 때, 트리를 반전시키고 루트를 반환하세요.

**예시 1:**
```
Input: root = [4,2,7,1,3,6,9]
Output: [4,7,2,9,6,3,1]
```

**예시 2:**
```
Input: root = [2,1,3]
Output: [2,3,1]
```

**예시 3:**
```
Input: root = []
Output: []
```',
 '트리의 노드 수는 [0, 100] 범위입니다.
-100 <= Node.val <= 100'),

-- 12. Binary Tree Level Order Traversal
((SELECT id FROM problems WHERE slug = 'binary-tree-level-order-traversal'), 'ko',
 '이진 트리 레벨 순회',
 '이진 트리의 `root`가 주어졌을 때, 노드 값의 레벨 순회 결과를 반환하세요. (왼쪽에서 오른쪽으로, 레벨별로)

**예시 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: [[3],[9,20],[15,7]]
```

**예시 2:**
```
Input: root = [1]
Output: [[1]]
```

**예시 3:**
```
Input: root = []
Output: []
```',
 '트리의 노드 수는 [0, 2000] 범위입니다.
-1000 <= Node.val <= 1000'),

-- 13. Group Anagrams
((SELECT id FROM problems WHERE slug = 'group-anagrams'), 'ko',
 '애너그램 그룹',
 '문자열 배열 `strs`가 주어졌을 때, 애너그램끼리 그룹화하세요. 답은 어떤 순서로든 반환할 수 있습니다.

애너그램은 다른 단어의 글자를 재배열하여 만든 단어로, 원래의 모든 글자를 정확히 한 번씩 사용합니다.

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
 '1 <= strs.length <= 10^4
0 <= strs[i].length <= 100
strs[i]는 영문 소문자로만 구성됩니다.'),

-- 14. Merge Intervals
((SELECT id FROM problems WHERE slug = 'merge-intervals'), 'ko',
 '구간 합치기',
 '`intervals[i] = [start_i, end_i]`인 구간 배열 `intervals`가 주어졌을 때, 겹치는 구간을 모두 합치고, 입력의 모든 구간을 포함하는 겹치지 않는 구간 배열을 반환하세요.

**예시 1:**
```
Input: intervals = [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]
Explanation: 구간 [1,3]과 [2,6]이 겹치므로 [1,6]으로 합칩니다.
```

**예시 2:**
```
Input: intervals = [[1,4],[4,5]]
Output: [[1,5]]
Explanation: 구간 [1,4]와 [4,5]는 겹치는 것으로 간주합니다.
```',
 '1 <= intervals.length <= 10^4
intervals[i].length == 2
0 <= start_i <= end_i <= 10^4'),

-- 15. 3Sum
((SELECT id FROM problems WHERE slug = '3sum'), 'ko',
 '세 수의 합',
 '정수 배열 `nums`가 주어졌을 때, `nums[i] + nums[j] + nums[k] == 0`을 만족하는 모든 세 쌍 `[nums[i], nums[j], nums[k]]`를 반환하세요. 단, `i != j`, `i != k`, `j != k`여야 합니다.

결과에 중복되는 세 쌍이 포함되어서는 안 됩니다.

**예시 1:**
```
Input: nums = [-1,0,1,2,-1,-4]
Output: [[-1,-1,2],[-1,0,1]]
Explanation:
nums[0] + nums[1] + nums[2] = (-1) + 0 + 1 = 0.
nums[0] + nums[3] + nums[4] = (-1) + 2 + (-1) = 0.
서로 다른 세 쌍은 [-1,0,1]과 [-1,-1,2]입니다.
```

**예시 2:**
```
Input: nums = [0,1,1]
Output: []
Explanation: 가능한 세 쌍의 합이 0이 되지 않습니다.
```

**예시 3:**
```
Input: nums = [0,0,0]
Output: [[0,0,0]]
```',
 '3 <= nums.length <= 3000
-10^5 <= nums[i] <= 10^5'),

-- 16. Permutations
((SELECT id FROM problems WHERE slug = 'permutations'), 'ko',
 '순열',
 '서로 다른 정수 배열 `nums`가 주어졌을 때, 가능한 모든 순열을 반환하세요. 답은 어떤 순서로든 반환할 수 있습니다.

**예시 1:**
```
Input: nums = [1,2,3]
Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
```

**예시 2:**
```
Input: nums = [0,1]
Output: [[0,1],[1,0]]
```

**예시 3:**
```
Input: nums = [1]
Output: [[1]]
```',
 '1 <= nums.length <= 6
-10 <= nums[i] <= 10
nums의 모든 정수는 서로 다릅니다.'),

-- 17. Subsets
((SELECT id FROM problems WHERE slug = 'subsets'), 'ko',
 '부분집합',
 '서로 다른 정수 배열 `nums`가 주어졌을 때, 가능한 모든 부분집합(멱집합)을 반환하세요.

결과에 중복되는 부분집합이 포함되어서는 안 됩니다. 답은 어떤 순서로든 반환할 수 있습니다.

**예시 1:**
```
Input: nums = [1,2,3]
Output: [[],[1],[1,2],[1,2,3],[1,3],[2],[2,3],[3]]
```

**예시 2:**
```
Input: nums = [0]
Output: [[],[0]]
```',
 '1 <= nums.length <= 10
-10 <= nums[i] <= 10
nums의 모든 수는 서로 다릅니다.'),

-- 18. Combination Sum
((SELECT id FROM problems WHERE slug = 'combination-sum'), 'ko',
 '조합의 합',
 '서로 다른 정수 배열 `candidates`와 목표 정수 `target`이 주어졌을 때, 합이 `target`이 되는 `candidates`의 모든 고유한 조합 목록을 반환하세요. 답은 어떤 순서로든 반환할 수 있습니다.

`candidates`의 같은 수를 횟수 제한 없이 선택할 수 있습니다. 선택한 수의 빈도가 하나라도 다르면 두 조합은 고유합니다.

**예시 1:**
```
Input: candidates = [2,3,6,7], target = 7
Output: [[2,2,3],[7]]
```

**예시 2:**
```
Input: candidates = [2,3,5], target = 8
Output: [[2,2,2,2],[2,3,3],[3,5]]
```

**예시 3:**
```
Input: candidates = [2], target = 1
Output: []
```',
 '1 <= candidates.length <= 30
2 <= candidates[i] <= 40
candidates의 모든 원소는 서로 다릅니다.
1 <= target <= 40'),

-- 19. Clone Graph
((SELECT id FROM problems WHERE slug = 'clone-graph'), 'ko',
 '그래프 복제',
 '연결된 무방향 그래프의 노드 참조가 주어졌을 때, 그래프의 깊은 복사(clone)를 반환하세요.

그래프의 각 노드는 값(`int`)과 이웃 목록(`List[Node]`)을 포함합니다.

테스트 케이스에서 그래프는 인접 리스트로 표현됩니다. 인접 리스트는 유한 그래프를 표현하는 데 사용되는 순서 없는 리스트의 모음입니다.

주어지는 노드는 항상 `val = 1`인 첫 번째 노드입니다.

**예시 1:**
```
Input: adjList = [[2,4],[1,3],[2,4],[1,3]]
Output: [[2,4],[1,3],[2,4],[1,3]]
```

**예시 2:**
```
Input: adjList = [[]]
Output: [[]]
Explanation: 그래프는 이웃이 없는 단일 노드로 구성됩니다.
```

**예시 3:**
```
Input: adjList = []
Output: []
Explanation: 빈 그래프입니다.
```',
 '그래프의 노드 수는 [0, 100] 범위입니다.
1 <= Node.val <= 100
Node.val은 각 노드마다 고유합니다.
반복되는 간선이나 자기 루프가 없습니다.'),

-- 20. N-Queens
((SELECT id FROM problems WHERE slug = 'n-queens'), 'ko',
 'N-퀸',
 'N-퀸 퍼즐은 `n x n` 체스판에 서로 공격할 수 없도록 `n`개의 퀸을 배치하는 문제입니다.

정수 `n`이 주어졌을 때, N-퀸 퍼즐의 모든 서로 다른 해를 반환하세요. 답은 어떤 순서로든 반환할 수 있습니다.

각 해는 `''Q''`가 퀸, `''.''`가 빈 칸을 나타내는 보드 배치를 포함합니다.

**예시 1:**
```
Input: n = 4
Output: [["..Q.","Q...","...Q",".Q.."],[".Q..","...Q","Q...","..Q."]]
```

**예시 2:**
```
Input: n = 1
Output: [["Q"]]
```',
 '1 <= n <= 9'),

-- 21. Accounts Merge
((SELECT id FROM problems WHERE slug = 'accounts-merge'), 'ko',
 '계정 병합',
 '`accounts` 리스트가 주어집니다. 각 `accounts[i]`는 문자열 리스트로, 첫 번째 요소 `accounts[i][0]`은 이름이고, 나머지 요소는 해당 계정의 이메일입니다.

이 계정들을 병합하려고 합니다. 두 계정에 공통 이메일이 있으면 반드시 같은 사람의 계정입니다. 같은 이름을 가진 계정이라도 다른 사람일 수 있습니다. 한 사람은 처음에 여러 계정을 가질 수 있지만, 모든 계정의 이름은 동일합니다.

병합 후, 각 계정의 첫 번째 요소는 이름이고 나머지 요소는 정렬된 이메일이어야 합니다. 계정 자체는 어떤 순서로든 반환할 수 있습니다.

**예시 1:**
```
Input: accounts = [["John","johnsmith@mail.com","john_newyork@mail.com"],["John","johnsmith@mail.com","john00@mail.com"],["Mary","mary@mail.com"],["John","johnnybravo@mail.com"]]
Output: [["John","john00@mail.com","john_newyork@mail.com","johnsmith@mail.com"],["John","johnnybravo@mail.com"],["Mary","mary@mail.com"]]
```

**예시 2:**
```
Input: accounts = [["Gabe","Gabe0@m.co","Gabe3@m.co","Gabe1@m.co"],["Kevin","Kevin3@m.co","Kevin5@m.co","Kevin0@m.co"],["Ethan","Ethan5@m.co","Ethan4@m.co","Ethan0@m.co"],["Hanzo","Hanzo3@m.co","Hanzo1@m.co","Hanzo0@m.co"],["Fern","Fern5@m.co","Fern1@m.co","Fern0@m.co"]]
Output: [["Ethan","Ethan0@m.co","Ethan4@m.co","Ethan5@m.co"],["Fern","Fern0@m.co","Fern1@m.co","Fern5@m.co"],["Gabe","Gabe0@m.co","Gabe1@m.co","Gabe3@m.co"],["Hanzo","Hanzo0@m.co","Hanzo1@m.co","Hanzo3@m.co"],["Kevin","Kevin0@m.co","Kevin3@m.co","Kevin5@m.co"]]
```',
 '1 <= accounts.length <= 1000
2 <= accounts[i].length <= 10
1 <= accounts[i][j].length <= 30
accounts[i][0]은 영문자로 구성됩니다.
accounts[i][j] (j > 0)은 유효한 이메일입니다.');
