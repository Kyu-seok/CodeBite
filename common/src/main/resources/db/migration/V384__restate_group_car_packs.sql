-- V384: group-car-packs restated, title unchanged. Hidden cases 10 and 11 have every car
-- reach the booth at the same moment and count one pack, a rule the statement never gave,
-- and "any group of cars traveling together" didn't say a lone car is a pack. Both are now
-- stated, with merging packs. Starter method groupTrainPacks (trains) -> countCarPacks in
-- all 4 Starter Codes and Drivers. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Cars drive along a one-lane road toward a toll booth at kilometer `target`. Car `i` starts at kilometer `position[i]` and drives at `speed[i]` kilometers per hour. A car can't pass the one ahead: when a car or pack catches up with the one ahead, it slows to that speed and they drive on as one **pack**. Catching up exactly at the booth also counts. A car that never catches up with anyone, and is never caught, is a pack of its own.

Return the number of packs that reach the toll booth.

**Example 1:**
```
Input: target = 20, position = [0,3,7,14], speed = [5,3,2,1]
Output: 2
Explanation: The car at km 14 reaches the booth after 6 hours. The car at km 7 would need 6.5 hours, so it never catches up with it. The cars at km 3 and km 0 would need about 5.7 and 4 hours, so both catch up with the car at km 7 before the booth: a second pack.
```

**Example 2:**
```
Input: target = 15, position = [5], speed = [2]
Output: 1
Explanation: A single car is a pack of its own.
```$$,
    constraints = $$- `n == position.length == speed.length`
- `1 <= n <= 2 * 10^5`
- `0 <= position[i] < target <= 10^8`
- `1 <= speed[i] <= 2 * 10^5`
- All values in `position` are distinct.$$
WHERE slug = $$group-car-packs$$;

UPDATE problem_translations SET
    description = $$자동차들이 1차선 도로를 따라 `target` 킬로미터에 있는 톨게이트로 향합니다. `i`번째 자동차는 `position[i]` 킬로미터 지점에서 출발해 시속 `speed[i]` 킬로미터로 달립니다. 차는 앞 차를 추월할 수 없어, 차나 팩이 앞의 차나 팩을 따라잡으면 그 속도로 줄여 하나의 **팩(pack)** 이 되어 함께 달립니다. 톨게이트에서 딱 맞춰 따라잡는 것도 포함됩니다. 아무도 따라잡지 못하고 따라잡히지도 않는 차는 혼자서 하나의 팩입니다.

톨게이트에 도착하는 팩의 개수를 반환하세요.

**예시 1:**
```
입력: target = 20, position = [0,3,7,14], speed = [5,3,2,1]
출력: 2
설명: 14km 지점의 차는 6시간 뒤 톨게이트에 도착합니다. 7km 지점의 차는 6.5시간이 걸리므로 그 차를 따라잡지 못합니다. 3km와 0km 지점의 차는 각각 약 5.7시간과 4시간이 걸리므로 톨게이트 전에 7km 지점의 차를 따라잡아 두 번째 팩이 됩니다.
```

**예시 2:**
```
입력: target = 15, position = [5], speed = [2]
출력: 1
설명: 차가 하나뿐이면 그 차 혼자 하나의 팩입니다.
```$$,
    constraints = $$- `n == position.length == speed.length`
- `1 <= n <= 2 * 10^5`
- `0 <= position[i] < target <= 10^8`
- `1 <= speed[i] <= 2 * 10^5`
- `position`의 모든 값은 서로 다릅니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$group-car-packs$$);
