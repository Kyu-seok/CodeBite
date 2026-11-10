-- V290: restate random-pick-bag (#222, part of #193). The unnumbered Example was a
-- Calls/Args/Result trace with no Input and Output; the description now shows sample
-- test cases 1 and 2 as Example 1 and Example 2 in the operations form, each with a
-- traced Explanation, in both languages. Only the descriptions change; Slug, title,
-- constraints, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problems SET
    description = $$Your gaming group keeps a bag of distinct card numbers and wants to draw one at random on demand. Build `RandomBag` so every card currently in the bag has equal chance of being drawn, and so insert, remove, and draw all run in average constant time.

- `RandomBag()` starts with an empty bag.
- `boolean insert(int val)` adds card `val`. Returns `true` if it wasn't already present, `false` otherwise.
- `boolean remove(int val)` removes card `val`. Returns `true` if it was present, `false` otherwise.
- `int drawRandom()` returns one card uniformly at random from the current bag. Only called when the bag is non-empty.

The judge prints whatever `drawRandom` returns, so the examples draw only when the bag holds a single card: that draw has one right answer.

**Example 1:**
```
Input
["RandomBag","insert","insert","remove","drawRandom"]
[[],[1],[2],[1],[]]
Output
[null,true,true,true,2]

Explanation
RandomBag bag = new RandomBag();
bag.insert(1);    // returns true, bag = {1}
bag.insert(2);    // returns true, bag = {1, 2}
bag.remove(1);    // returns true, bag = {2}
bag.drawRandom(); // returns 2, the only card left
```

**Example 2:**
```
Input
["RandomBag","insert","insert","remove","insert","remove","drawRandom"]
[[],[5],[5],[5],[5],[10],[]]
Output
[null,true,false,true,true,false,5]

Explanation
RandomBag bag = new RandomBag();
bag.insert(5);    // returns true, bag = {5}
bag.insert(5);    // returns false, 5 is already in the bag
bag.remove(5);    // returns true, bag = {}
bag.insert(5);    // returns true, bag = {5}
bag.remove(10);   // returns false, 10 is not in the bag
bag.drawRandom(); // returns 5, the only card left
```$$
WHERE slug = $$random-pick-bag$$;

UPDATE problem_translations SET
    description = $$게임 모임에서 서로 다른 카드 번호들이 들어 있는 가방을 두고, 필요할 때마다 카드 한 장을 무작위로 뽑고 싶어 합니다. 가방 안에 현재 들어 있는 모든 카드가 같은 확률로 뽑히도록 `RandomBag`을 만들고, 삽입·제거·뽑기 모두 평균적으로 상수 시간에 동작하게 하세요.

- `RandomBag()` — 비어 있는 가방으로 시작합니다.
- `boolean insert(int val)` — 카드 `val`(카드 번호)을 추가합니다. 새로 추가됐으면 `true`, 이미 있었으면 `false`를 반환합니다.
- `boolean remove(int val)` — 카드 `val`을 제거합니다. 있었으면 `true`, 없었으면 `false`를 반환합니다.
- `int drawRandom()` — 현재 가방에서 카드 하나를 균등 확률로 뽑아 반환합니다. 가방이 비어 있지 않을 때만 호출됩니다.

채점기는 `drawRandom`이 반환한 값을 그대로 출력하므로, 예시는 가방에 카드가 한 장만 있을 때만 뽑습니다. 그때의 정답은 하나뿐입니다.

**예시 1:**
```
입력
["RandomBag","insert","insert","remove","drawRandom"]
[[],[1],[2],[1],[]]
출력
[null,true,true,true,2]

설명
RandomBag bag = new RandomBag();
bag.insert(1);    // true 반환, 가방 = {1}
bag.insert(2);    // true 반환, 가방 = {1, 2}
bag.remove(1);    // true 반환, 가방 = {2}
bag.drawRandom(); // 2 반환, 남은 카드는 2뿐
```

**예시 2:**
```
입력
["RandomBag","insert","insert","remove","insert","remove","drawRandom"]
[[],[5],[5],[5],[5],[10],[]]
출력
[null,true,false,true,true,false,5]

설명
RandomBag bag = new RandomBag();
bag.insert(5);    // true 반환, 가방 = {5}
bag.insert(5);    // false 반환, 5는 이미 가방에 있음
bag.remove(5);    // true 반환, 가방 = {}
bag.insert(5);    // true 반환, 가방 = {5}
bag.remove(10);   // false 반환, 10은 가방에 없음
bag.drawRandom(); // 5 반환, 남은 카드는 5뿐
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$random-pick-bag$$);
