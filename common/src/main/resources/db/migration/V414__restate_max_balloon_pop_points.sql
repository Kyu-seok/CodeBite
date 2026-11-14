-- V414: best-balloon-pop-order -> max-balloon-pop-points, retitled "Max Balloon Pop Points".
-- The old title asked for an order though the output is the maximum points, and the
-- formula balloons[i - 1] * balloons[i] * balloons[i + 1] used original indices that the
-- next clause contradicted, since neighbours change after pops. Starter method
-- bestBakeOrder (bake) -> maxPopPoints in all 4 Starter Codes and Drivers. Drivers and
-- Starter Code directories are renamed in the same commit. Examples match the sample test
-- cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$best-balloon-pop-order$$, id FROM problems WHERE slug = $$best-balloon-pop-order$$;

UPDATE problems SET
    slug = $$max-balloon-pop-points$$,
    title = $$Max Balloon Pop Points$$,
    description = $$A row of balloons carries the numbers in `balloons`. Pop them one at a time, in any order, and return the most points you can earn by popping them all.

Popping a balloon earns its number times the numbers of its current left and right neighbours. A missing neighbour, past either end of the row, counts as `1`. Once a balloon is popped, the balloons on either side of it become neighbours.

**Example 1:**
```
Input: balloons = [2,4,1,6]
Output: 90
Explanation: Pop 1 (4*1*6 = 24, leaving [2,4,6]), then 4 (2*4*6 = 48, leaving [2,6]), then 2 (1*2*6 = 12, leaving [6]), then 6 (1*6*1 = 6). Total 24 + 48 + 12 + 6 = 90.
```

**Example 2:**
```
Input: balloons = [3,5]
Output: 20
Explanation: Pop 3 (1*3*5 = 15), then 5 (1*5*1 = 5). Total 20.
```$$,
    constraints = $$- `1 <= balloons.length <= 300`
- `0 <= balloons[i] <= 100`$$
WHERE slug = $$best-balloon-pop-order$$;

UPDATE problem_translations SET
    title = $$풍선 터뜨리기 최대 점수$$,
    description = $$숫자가 적힌 풍선들이 한 줄로 놓여 있고, 그 숫자들이 `balloons`에 주어집니다. 원하는 순서대로 풍선을 하나씩 모두 터뜨릴 때 얻을 수 있는 최대 점수를 반환하세요.

풍선을 터뜨리면 그 풍선의 숫자에 지금 왼쪽과 오른쪽에 붙어 있는 풍선의 숫자를 곱한 만큼 점수를 얻습니다. 줄의 양 끝 바깥처럼 이웃이 없으면 `1`로 셉니다. 풍선이 터지면 그 양옆의 풍선끼리 이웃이 됩니다.

**예시 1:**
```
입력: balloons = [2,4,1,6]
출력: 90
설명: 1을 터뜨리고(4*1*6 = 24, [2,4,6]이 남음), 4(2*4*6 = 48, [2,6]이 남음), 2(1*2*6 = 12, [6]이 남음), 6(1*6*1 = 6) 순으로 터뜨립니다. 합계 24 + 48 + 12 + 6 = 90.
```

**예시 2:**
```
입력: balloons = [3,5]
출력: 20
설명: 3을 터뜨리고(1*3*5 = 15), 5를 터뜨립니다(1*5*1 = 5). 합계 20.
```$$,
    constraints = $$- `1 <= balloons.length <= 300`
- `0 <= balloons[i] <= 100`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$max-balloon-pop-points$$);
