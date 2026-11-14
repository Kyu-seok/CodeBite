-- V311: pick-charging-start restated. "Must never hit zero" and "the valid start is
-- unique" were both false: cases end a loop at exactly 0, Example 1 has three valid
-- starts (0, 1, 3) and the all-zero case four, every case expecting the smallest. Both
-- languages now say the battery may not go below zero, return the smallest valid stop,
-- spell out charge-then-drive, and trace Example 1. Starter method pickStartStation
-- (can_complete_circuit in Python) -> pickStartStop; Drivers' gas/cost -> energy/drain.
-- Korean title 출발 충전소 고르기 -> 출발 휴게소 고르기, the body's word for a stop.
-- Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Return the smallest index of a rest stop from which you can drive one full loop without your phone's battery going below zero, or `-1` if no stop works.

A loop road has `n` rest stops, numbered `0` to `n - 1`. At stop `i` your phone first charges by `energy[i]` units, then the drive from stop `i` to the next stop (stop `0` after stop `n - 1`) uses `drain[i]` units. You start at a stop of your choice with an empty battery and drive once around the loop, back to that stop.

The battery may reach exactly `0`, but it must never go below `0`.

**Example 1:**
```
Input: energy = [4,6,1,3,5], drain = [3,5,2,2,6]
Output: 0
```

Starting at stop `0`:

| Stop | Charge | Drive | Battery after the drive |
|---|---|---|---|
| `0` | `+4` | `-3` | `1` |
| `1` | `+6` | `-5` | `2` |
| `2` | `+1` | `-2` | `1` |
| `3` | `+3` | `-2` | `2` |
| `4` | `+5` | `-6` | `1` |

The battery never goes below `0`, so stop `0` works. Stops `1` and `3` work too, and `0` is the smallest.

**Example 2:**
```
Input: energy = [5,2,8], drain = [6,4,7]
Output: -1
```

The stops charge `15` units in all but the drives use `17`, so the battery goes below `0` whichever stop you start from.$$
WHERE slug = $$pick-charging-start$$;

UPDATE problem_translations SET
    title = $$출발 휴게소 고르기$$,
    description = $$한 바퀴를 도는 동안 휴대폰 배터리가 0 미만으로 떨어지지 않는 출발 휴게소 중 가장 작은 인덱스를 반환하세요. 그런 휴게소가 없으면 `-1`을 반환하세요.

순환 도로에 `0`번부터 `n - 1`번까지 `n`개의 휴게소가 있습니다. 휴게소 `i`에서는 먼저 휴대폰이 `energy[i]` 단위만큼 충전되고, 이어서 다음 휴게소(휴게소 `n - 1` 다음은 휴게소 `0`)까지 운전하면서 `drain[i]` 단위가 소모됩니다. 원하는 휴게소에서 빈 배터리로 출발해 도로를 한 바퀴 돌아 출발한 휴게소로 돌아옵니다.

배터리는 정확히 `0`이 될 수는 있지만, `0` 미만으로 떨어져서는 안 됩니다.

**예시 1:**
```
입력: energy = [4,6,1,3,5], drain = [3,5,2,2,6]
출력: 0
```

휴게소 `0`에서 출발하면:

| 휴게소 | 충전 | 운전 | 운전 후 배터리 |
|---|---|---|---|
| `0` | `+4` | `-3` | `1` |
| `1` | `+6` | `-5` | `2` |
| `2` | `+1` | `-2` | `1` |
| `3` | `+3` | `-2` | `2` |
| `4` | `+5` | `-6` | `1` |

배터리가 한 번도 `0` 미만으로 떨어지지 않으므로 휴게소 `0`에서 출발할 수 있습니다. 휴게소 `1`과 `3`에서도 출발할 수 있지만, 가장 작은 인덱스는 `0`입니다.

**예시 2:**
```
입력: energy = [5,2,8], drain = [6,4,7]
출력: -1
```

충전량은 모두 합쳐 `15`인데 운전에 `17`이 들기 때문에, 어느 휴게소에서 출발해도 배터리가 `0` 미만으로 떨어집니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$pick-charging-start$$);
