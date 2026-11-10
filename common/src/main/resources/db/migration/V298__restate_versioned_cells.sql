-- V298: restate versioned-cells (#230, part of #193). The unnumbered Example was a call
-- trace with no Input and Output; the descriptions now show sample test cases 1 and 2 as
-- Example 1 and Example 2 in the operations form, the old trace moving under Example 1's
-- Explanation. Only the descriptions change; Slug, title, constraints, Test Cases, Starter
-- Code and Drivers are unchanged.

UPDATE problems SET
    description = $$You're building save-file support for a sandbox game. The world is a row of numeric cells. You can edit the live row, and you can freeze it as a snapshot to revisit later. All cells start at `0`, and snapshot ids count up from `0`.

Implement the `VersionedCells` class:

- `VersionedCells(int length)` creates a row of `length` cells, all initialized to `0`, with no snapshots taken.
- `void set(int index, int val)` sets the live value at position `index` to `val`. Previously committed snapshots are unchanged.
- `int commit()` freezes the current live row as a new snapshot and returns its id. The first call returns `0`, the second `1`, and so on.
- `int readAt(int index, int snapId)` returns the value of cell `index` in snapshot `snapId`.

**Example 1:**
```
Input
["VersionedCells","set","commit","set","readAt"]
[[3],[0,5],[],[0,6],[0,0]]
Output
[null,null,0,null,5]

Explanation
VersionedCells cells = new VersionedCells(3);
cells.set(0, 5);
cells.commit();       // returns 0, snapshot 0 is [5, 0, 0]
cells.set(0, 6);      // live row is now [6, 0, 0]
cells.readAt(0, 0);   // returns 5, the value of cell 0 in snapshot 0
```

**Example 2:**
```
Input
["VersionedCells","set","set","commit","set","commit","readAt","readAt"]
[[2],[0,10],[1,20],[],[0,30],[],[0,0],[0,1]]
Output
[null,null,null,0,null,1,10,30]

Explanation
VersionedCells cells = new VersionedCells(2);
cells.set(0, 10);
cells.set(1, 20);
cells.commit();       // returns 0, snapshot 0 is [10, 20]
cells.set(0, 30);
cells.commit();       // returns 1, snapshot 1 is [30, 20]
cells.readAt(0, 0);   // returns 10, cell 0 in snapshot 0
cells.readAt(0, 1);   // returns 30, cell 0 in snapshot 1
```$$
WHERE slug = $$versioned-cells$$;

UPDATE problem_translations SET
    description = $$샌드박스 게임의 저장 기능을 만들고 있습니다. 월드는 숫자 셀들이 한 줄로 늘어선 구조이고, 살아 있는 행을 자유롭게 수정하다가 원할 때 그 상태를 스냅샷으로 동결해 나중에 다시 볼 수 있어야 합니다. 모든 셀은 `0`으로 시작하고, 스냅샷 id는 `0`부터 차례로 매겨집니다.

다음과 같은 `VersionedCells` 클래스를 구현하세요.

- `VersionedCells(int length)` — 길이 `length`(셀 개수)인 행을 모두 `0`으로 초기화하고, 스냅샷이 하나도 없는 상태로 시작합니다.
- `void set(int index, int val)` — 살아 있는 행의 위치 `index`(셀 위치)에 값 `val`(새 값)을 설정합니다. 이미 커밋된 스냅샷은 영향을 받지 않습니다.
- `int commit()` — 현재 살아 있는 행을 새 스냅샷으로 동결하고 그 id를 반환합니다. 첫 호출은 `0`, 두 번째는 `1`, ... 식으로 이어집니다.
- `int readAt(int index, int snapId)` — 스냅샷 `snapId`(스냅샷 식별자)에서 셀 `index`의 값을 반환합니다.

**예시 1:**
```
입력
["VersionedCells","set","commit","set","readAt"]
[[3],[0,5],[],[0,6],[0,0]]
출력
[null,null,0,null,5]

설명
VersionedCells cells = new VersionedCells(3);
cells.set(0, 5);
cells.commit();       // 0 반환, 스냅샷 0은 [5, 0, 0]
cells.set(0, 6);      // 살아 있는 행은 이제 [6, 0, 0]
cells.readAt(0, 0);   // 5 반환, 스냅샷 0의 셀 0 값
```

**예시 2:**
```
입력
["VersionedCells","set","set","commit","set","commit","readAt","readAt"]
[[2],[0,10],[1,20],[],[0,30],[],[0,0],[0,1]]
출력
[null,null,null,0,null,1,10,30]

설명
VersionedCells cells = new VersionedCells(2);
cells.set(0, 10);
cells.set(1, 20);
cells.commit();       // 0 반환, 스냅샷 0은 [10, 20]
cells.set(0, 30);
cells.commit();       // 1 반환, 스냅샷 1은 [30, 20]
cells.readAt(0, 0);   // 10 반환, 스냅샷 0의 셀 0 값
cells.readAt(0, 1);   // 30 반환, 스냅샷 1의 셀 0 값
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$versioned-cells$$);
