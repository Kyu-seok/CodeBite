-- V544: slot-a-meeting restated, title unchanged. The method scheduleObservingWindow was
-- left over from another theme; it becomes insertMeeting, and the parameters slots and
-- newSlot become meetings and newMeeting. The statement now says what "touches" means:
-- meetings sharing an endpoint merge, as the reference solution does (no case has one).
-- Starter method scheduleObservingWindow -> insertMeeting, parameters slots -> meetings and
-- newSlot -> newMeeting in all 4 Starter Codes and Drivers. Examples and the Diagram match
-- the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$The team calendar `meetings` lists meetings as `[start, end]`, sorted by `start`, with no two overlapping. Insert the meeting `newMeeting` and return the updated calendar, still sorted and without overlaps.

`newMeeting` merges with every meeting it overlaps or touches into one meeting that covers them all. Two meetings touch when one ends where the other starts, like `[1,4]` and `[4,5]`, which merge into `[1,5]`.

**Example 1:**
```
Input: meetings = [[1,4],[7,10]], newMeeting = [3,6]
Output: [[1,6],[7,10]]
Explanation: [3,6] overlaps [1,4], and together they cover [1,6]. [7,10] starts after 6, so it stays as it is.
```

```diagram-intervals
intervals: [[1,4],[7,10]]
added: [3,6]
after: [[1,6],[7,10]]
```

**Example 2:**
```
Input: meetings = [[2,4],[6,8],[10,12],[14,18]], newMeeting = [5,11]
Output: [[2,4],[5,12],[14,18]]
Explanation: [5,11] overlaps [6,8] and [10,12], and the three merge into [5,12]. [2,4] ends before 5 and [14,18] starts after 12, so they stay.
```$$,
    constraints = $$- `0 <= meetings.length <= 8000`
- `meetings[i].length == 2`
- `newMeeting.length == 2`
- `0 <= start <= end <= 8 * 10^4` for every meeting, `newMeeting` included
- `meetings` is sorted by `start`, and no two of its meetings overlap or touch.$$
WHERE slug = $$slot-a-meeting$$;

UPDATE problem_translations SET
    description = $$팀 캘린더 `meetings`는 회의를 `[start, end]`로 나열하며, `start` 순으로 정렬되어 있고 서로 겹치는 회의가 없습니다. 회의 `newMeeting`을 끼워 넣은 뒤, 여전히 정렬되어 있고 겹치는 회의가 없는 캘린더를 반환하세요.

`newMeeting`은 자신과 겹치거나 맞닿는 모든 회의와 합쳐져, 그 회의들을 모두 덮는 회의 하나가 됩니다. 한 회의가 끝나는 시각에 다른 회의가 시작하면 두 회의는 맞닿은 것입니다. 예를 들어 `[1,4]`와 `[4,5]`는 `[1,5]`로 합쳐집니다.

**예시 1:**
```
입력: meetings = [[1,4],[7,10]], newMeeting = [3,6]
출력: [[1,6],[7,10]]
설명: [3,6]은 [1,4]와 겹치며, 둘을 합치면 [1,6]이 됩니다. [7,10]은 6 이후에 시작하므로 그대로 남습니다.
```

```diagram-intervals
intervals: [[1,4],[7,10]]
added: [3,6]
after: [[1,6],[7,10]]
```

**예시 2:**
```
입력: meetings = [[2,4],[6,8],[10,12],[14,18]], newMeeting = [5,11]
출력: [[2,4],[5,12],[14,18]]
설명: [5,11]은 [6,8], [10,12]와 겹치므로 셋이 합쳐져 [5,12]가 됩니다. [2,4]는 5 전에 끝나고 [14,18]은 12 이후에 시작하므로 그대로 남습니다.
```$$,
    constraints = $$- `0 <= meetings.length <= 8000`
- `meetings[i].length == 2`
- `newMeeting.length == 2`
- `0 <= start <= end <= 8 * 10^4` (`newMeeting`을 포함한 모든 회의)
- `meetings`는 `start` 순으로 정렬되어 있으며, 서로 겹치거나 맞닿는 회의가 없습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$slot-a-meeting$$);
