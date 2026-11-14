-- V573: rebuild-tournament-line restated, title unchanged. The first sentence now states the
-- task, each example is explained by checking every player's k in the output instead of
-- narrating the greedy algorithm, and Example 3 (sample 3) shows that an equal height counts
-- toward k. Starter method orderTicketHolders -> rebuildLine in all 4 Starter Codes and
-- Drivers. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given the scrambled `players` of a video-game tournament line, rebuild the line and return it from front to back. Each player is a pair `[h, k]`, where `h` is their height and `k` is the number of players standing **ahead** of them whose height is at least `h`.

**Example 1:**
```
Input: players = [[3,0],[6,0],[6,1],[4,1]]
Output: [[3,0],[6,0],[4,1],[6,1]]
Explanation: [3,0] is first. [6,0] has only the 3 ahead, shorter than 6. [4,1] has 3 and 6 ahead, and only the 6 is at least 4. [6,1] has 3, 6 and 4 ahead, and only the 6 is at least 6.
```

**Example 2:**
```
Input: players = [[2,0],[5,0],[2,1],[5,1]]
Output: [[2,0],[2,1],[5,0],[5,1]]
Explanation: [2,0] is first. [2,1] has the first 2 ahead, which is at least 2. [5,0] has two 2s ahead, both shorter than 5. [5,1] has 2, 2 and 5 ahead, and only the 5 is at least 5.
```

**Example 3:**
```
Input: players = [[3,0],[3,1]]
Output: [[3,0],[3,1]]
Explanation: An equal height counts toward k, so the second 3 has one player at least 3 ahead.
```$$
WHERE slug = $$rebuild-tournament-line$$;

UPDATE problem_translations SET
    description = $$뒤섞인 비디오 게임 토너먼트 참가자 목록 `players`가 주어질 때, 대기 줄을 다시 세워 앞에서부터 뒤로 반환하세요. 각 참가자는 `[h, k]` 쌍으로 주어지며, `h`는 키, `k`는 자기 **앞에** 서 있는 사람 중 키가 `h` 이상인 사람의 수입니다.

**예시 1:**
```
입력: players = [[3,0],[6,0],[6,1],[4,1]]
출력: [[3,0],[6,0],[4,1],[6,1]]
설명: [3,0]은 맨 앞입니다. [6,0]의 앞에는 6보다 작은 3만 있습니다. [4,1]의 앞에는 3과 6이 있고, 그중 키 4 이상은 6 한 명입니다. [6,1]의 앞에는 3, 6, 4가 있고, 그중 키 6 이상은 6 한 명입니다.
```

**예시 2:**
```
입력: players = [[2,0],[5,0],[2,1],[5,1]]
출력: [[2,0],[2,1],[5,0],[5,1]]
설명: [2,0]은 맨 앞입니다. [2,1]의 앞에는 키 2 이상인 첫 번째 2가 있습니다. [5,0]의 앞에는 5보다 작은 2 두 명만 있습니다. [5,1]의 앞에는 2, 2, 5가 있고, 그중 키 5 이상은 5 한 명입니다.
```

**예시 3:**
```
입력: players = [[3,0],[3,1]]
출력: [[3,0],[3,1]]
설명: 키가 같은 사람도 k에 세므로, 두 번째 3의 앞에는 키 3 이상인 사람이 한 명 있습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$rebuild-tournament-line$$);
