-- V150: Korean descriptions for the 10 canonical-restored classics. Mirrors
-- V136's style — identifiers, fenced example blocks (Input/Output/Explanation),
-- numeric values, and string literals are kept verbatim from the English
-- source in V149. Example headers are rendered as **예시 N:**.

-- valid-sudoku
UPDATE problem_translations SET
    description = $$9×9 스도쿠 보드가 부분적으로 채워져 있습니다. 지금까지 놓인 숫자들이 규칙에 맞는지 확인하세요. 빈 칸(`.`)은 어떤 제약도 주지 않지만, 숫자가 채워진 칸은 같은 행, 같은 열, 같은 3×3 서브박스 안의 다른 숫자들과 모두 달라야 합니다.

`board[i][j]`의 각 원소는 `'1'`–`'9'` 사이의 숫자이거나 `'.'`입니다. 어떤 행, 열, 또는 3×3 서브박스에도 같은 숫자가 두 번 나오지 않으면 `true`를, 그렇지 않으면 `false`를 반환하세요. 보드가 끝까지 풀릴 수 있는지는 검사할 필요가 없습니다 — 이미 채워진 칸들의 유효성만 보면 됩니다.

**예시 1:**
```
Input: board = [["5","3",".",".","7",".",".",".","."],["6",".",".","1","9","5",".",".","."],[".","9","8",".",".",".",".","6","."],["8",".",".",".","6",".",".",".","3"],["4",".",".","8",".","3",".",".","1"],["7",".",".",".","2",".",".",".","6"],[".","6",".",".",".",".","2","8","."],[".",".",".","4","1","9",".",".","5"],[".",".",".",".","8",".",".","7","9"]]
Output: true
```

**예시 2:**
```
Input: board = [["8","3",".",".","7",".",".",".","."],["6",".",".","1","9","5",".",".","."],[".","9","8",".",".",".",".","6","."],["8",".",".",".","6",".",".",".","3"],["4",".",".","8",".","3",".",".","1"],["7",".",".",".","2",".",".",".","6"],[".","6",".",".",".",".","2","8","."],[".",".",".","4","1","9",".",".","5"],[".",".",".",".","8",".",".","7","9"]]
Output: false
Explanation: Two 8s appear in the leftmost column, so the column constraint is violated.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$valid-sudoku$$);

-- sort-colors
UPDATE problem_translations SET
    description = $$배열 `nums`의 원소는 `0`, `1`, `2` 세 가지뿐이며, 자연스러운 정렬 순서가 있습니다(관례상 빨강, 하양, 파랑에 해당합니다). 모든 `0`이 앞쪽에, 그다음 `1`들이, 마지막에 `2`들이 오도록 **제자리에서** 재배열하세요. 내장 정렬 함수는 사용할 수 없습니다.

상수 추가 공간만 쓰면서 한 번의 선형 탐색으로 처리하는 것이 목표입니다 — 고전적인 네덜란드 국기 분할 문제입니다.

**예시 1:**
```
Input: nums = [2,0,2,1,1,0]
Output: [0,0,1,1,2,2]
```

**예시 2:**
```
Input: nums = [2,0,1]
Output: [0,1,2]
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$sort-colors$$);

-- trapping-rain-water
UPDATE problem_translations SET
    description = $$높이 지도가 `height` 배열로 주어집니다. `height[i]`는 `i`번째 막대의 높이이고, 모든 막대의 너비는 1입니다. 비가 내린 뒤 더 높은 막대들 사이의 움푹한 곳에 물이 고이는데, 갇힌 물의 총량을 구하세요.

`i`번째 위치는 `min(maxLeft, maxRight) - height[i]`만큼의 물을 가둡니다. 여기서 `maxLeft`, `maxRight`는 각각 `i`의 왼쪽과 오른쪽에서 가장 높은 막대의 높이입니다. 한쪽에 더 높은 막대가 없으면 그쪽으로 물이 새어나가서 가둘 수 없습니다.

**예시 1:**
```
Input: height = [0,1,0,2,1,0,1,3,2,1,2,1]
Output: 6
Explanation: Six units of water sit in the dips between the bars of heights 2, 3, and 2.
```

**예시 2:**
```
Input: height = [4,2,0,3,2,5]
Output: 9
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$trapping-rain-water$$);

-- word-search-ii
UPDATE problem_translations SET
    description = $$`m x n` 글자 `board`와 단어 목록 `words`가 주어집니다. 보드 위에서 상하좌우로 인접한 칸을 따라 이동해 만들 수 있는 단어를 모두 찾으세요. 한 단어를 만드는 동안 같은 칸을 두 번 사용할 수 없습니다. 매칭된 단어들을 어떤 순서로든 반환하면 됩니다.

여러 단어의 경로가 보드에서 서로 겹쳐도 괜찮습니다 — 각 단어는 독립적으로 확인합니다.

**예시 1:**
```
Input: board = [["o","a","a","n"],["e","t","a","e"],["i","h","k","r"],["i","f","l","v"]], words = ["oath","pea","eat","rain"]
Output: ["eat","oath"]
```

**예시 2:**
```
Input: board = [["a","b"],["c","d"]], words = ["abcb"]
Output: []
Explanation: Tracing "abcb" would require revisiting the cell containing "b", which isn't allowed.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$word-search-ii$$);

-- n-queens
UPDATE problem_translations SET
    description = $$`n × n` 체스판에 `n`개의 퀸을 놓되, 어떤 두 퀸도 서로 공격하지 않도록 배치하세요. 즉, 두 퀸이 같은 행, 같은 열, 같은 대각선 위에 있어서는 안 됩니다. 가능한 모든 서로 다른 배치를 반환하세요.

각 배치는 길이가 `n`인 문자열 `n`개의 리스트로 나타냅니다. `'Q'`는 퀸이 놓인 칸, `'.'`은 빈 칸입니다. 결과 배치들이 출력되는 순서는 상관없습니다.

**예시 1:**
```
Input: n = 4
Output: [[".Q..","...Q","Q...","..Q."],["..Q.","Q...","...Q",".Q.."]]
Explanation: Two distinct safe placements exist for n = 4.
```

**예시 2:**
```
Input: n = 1
Output: [["Q"]]
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$n-queens$$);

-- word-search
UPDATE problem_translations SET
    description = $$`m x n` 글자 `board`와 목표 단어 `word`가 주어졌을 때, 상하좌우로 인접한 칸을 따라 이동해서 `word`를 만들 수 있으면 `true`를 반환하세요. 한 칸은 하나의 추적에서 한 번만 사용할 수 있습니다.

**예시 1:**
```
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCCED"
Output: true
```

**예시 2:**
```
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "SEE"
Output: true
```

**예시 3:**
```
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCB"
Output: false
Explanation: Reaching the second "B" would require revisiting the starting cell.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$word-search$$);

-- largest-rectangle-histogram
UPDATE problem_translations SET
    description = $$히스토그램이 배열 `heights`로 주어집니다. `heights[i]`는 `i`번째 막대의 높이이고, 모든 막대의 너비는 1입니다. 히스토그램 안에 완전히 들어가는 (여러 인접 막대에 걸쳐 있어도 됩니다) 가장 큰 직사각형의 넓이를 구하세요.

`i..j` 구간을 덮는 직사각형의 높이는 `min(heights[i..j])`, 너비는 `j - i + 1`입니다.

**예시 1:**
```
Input: heights = [2,1,5,6,2,3]
Output: 10
Explanation: The bars at indices 2 and 3 (heights 5 and 6) together support a 2×5 rectangle of area 10.
```

**예시 2:**
```
Input: heights = [2,4]
Output: 4
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$largest-rectangle-histogram$$);

-- lru-cache
UPDATE problem_translations SET
    description = $$고정된 `capacity`를 가진 키/값 저장소 `LRUCache`를 설계하세요. 용량을 초과하는 순간 가장 오래 사용되지 않은(LRU) 엔트리를 자동으로 삭제합니다.

다음 메서드를 구현하세요:
- `LRUCache(int capacity)` — 양의 정수 용량 `capacity`로 캐시를 초기화합니다.
- `int get(int key)` — `key`에 해당하는 값을 반환하거나, 없으면 `-1`을 반환합니다. 성공한 `get`도 최근 사용으로 간주됩니다.
- `void put(int key, int value)` — 엔트리를 새로 넣거나 갱신합니다. 삽입 후 크기가 `capacity`를 넘으면 가장 오래 사용되지 않은 키를 제거합니다.

`get`과 `put` 모두 평균적으로 **O(1)** 시간에 동작해야 합니다.

**예시 1:**
```
Input
["LRUCache","put","put","get","put","get","put","get","get","get"]
[[2],[1,1],[2,2],[1],[3,3],[2],[4,4],[1],[3],[4]]
Output
[null,null,null,1,null,-1,null,-1,3,4]

Explanation
LRUCache cache = new LRUCache(2);
cache.put(1, 1); // cache = {1=1}
cache.put(2, 2); // cache = {1=1, 2=2}
cache.get(1);    // returns 1, cache = {2=2, 1=1}
cache.put(3, 3); // evicts key 2, cache = {1=1, 3=3}
cache.get(2);    // returns -1 (not found)
cache.put(4, 4); // evicts key 1, cache = {3=3, 4=4}
cache.get(1);    // returns -1
cache.get(3);    // returns 3
cache.get(4);    // returns 4
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$lru-cache$$);

-- word-ladder
UPDATE problem_translations SET
    description = $$같은 길이의 두 단어 `beginWord`와 `endWord`, 그리고 사전 `wordList`가 주어집니다. *변환*은 한 번에 정확히 한 글자만 바꾸는 동작이고, 변환 도중 거치는 모든 단어는 `wordList` 안에 있어야 합니다. `endWord` 자체도 사전에 들어 있어야 변환이 성립할 수 있습니다. 단, `beginWord`는 사전에 들어 있을 필요가 없습니다.

`beginWord`에서 `endWord`까지 가는 가장 짧은 변환 시퀀스의 길이를 양 끝 단어를 포함해서 반환하세요. 변환이 불가능하면 `0`을 반환합니다.

**예시 1:**
```
Input: beginWord = "hit", endWord = "cog", wordList = ["hot","dot","dog","lot","log","cog"]
Output: 5
Explanation: One shortest path is "hit" → "hot" → "dot" → "dog" → "cog", length 5.
```

**예시 2:**
```
Input: beginWord = "hit", endWord = "cog", wordList = ["hot","dot","dog","lot","log"]
Output: 0
Explanation: "cog" is missing from the dictionary, so no valid sequence exists.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$word-ladder$$);

-- fizz-buzz
UPDATE problem_translations SET
    description = $$양의 정수 `n`이 주어지면, 길이가 `n`인 배열 `answer`를 반환하세요. `1`부터 `n`까지의 각 `i`에 대해:
- `i`가 3과 5 모두로 나누어떨어지면 `answer[i-1]`은 `"FizzBuzz"`,
- 3으로만 나누어떨어지면 `"Fizz"`,
- 5로만 나누어떨어지면 `"Buzz"`,
- 그 외에는 `i`의 십진수 문자열 표현입니다.

**예시 1:**
```
Input: n = 3
Output: ["1","2","Fizz"]
```

**예시 2:**
```
Input: n = 5
Output: ["1","2","Fizz","4","Buzz"]
```

**예시 3:**
```
Input: n = 15
Output: ["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$fizz-buzz$$);
