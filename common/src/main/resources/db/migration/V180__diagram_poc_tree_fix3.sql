-- V177–V179 all silently no-oped. V179 had the right substring contents but
-- used `E'...\n...'` C-style escape strings; the description was written by
-- V137 with literal newlines via `$$...$$` dollar quoting, so the escape
-- form's `\n` did not match the literal LF in storage.
--
-- This migration uses the same `$$...$$` quoting style as V137 with real
-- line breaks inside the literal — so the REPLACE substring matches byte
-- for byte.

-- English description
UPDATE problems
SET description = REPLACE(
    description,
    $$Output: [5,8,3,9,7,4,2]
Explanation: Every left/right pair is swapped at every level.
```$$,
    $$Output: [5,8,3,9,7,4,2]
Explanation: Every left/right pair is swapped at every level.
```

```diagram-tree
nodes: [5, 3, 8, 2, 4, 7, 9]
```$$
)
WHERE slug = 'mirror-menu-tree';

-- Korean translation
UPDATE problem_translations
SET description = REPLACE(
    description,
    $$출력: [5,8,3,9,7,4,2]
설명: 모든 계층에서 왼쪽과 오른쪽 자식 쌍이 통째로 맞바뀌어 거울 이미지 트리가 만들어집니다.
```$$,
    $$출력: [5,8,3,9,7,4,2]
설명: 모든 계층에서 왼쪽과 오른쪽 자식 쌍이 통째로 맞바뀌어 거울 이미지 트리가 만들어집니다.
```

```diagram-tree
nodes: [5, 3, 8, 2, 4, 7, 9]
```$$
)
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'mirror-menu-tree')
  AND locale = 'ko';
