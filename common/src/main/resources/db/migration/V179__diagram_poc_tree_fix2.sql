-- V177 / V178 both no-ops: V177 used the wrong slug; V178 used the right slug
-- but missed that Example 1 has an `Explanation:` (en) / `설명:` (ko) line
-- between the Output line and the closing fence, so the REPLACE substring
-- never matched.
--
-- This migration uses the full Example 1 block as the unique target, so the
-- directive is appended right after the Example 1 fence closes.

-- English description
UPDATE problems
SET description = REPLACE(
    description,
    E'Output: [5,8,3,9,7,4,2]\nExplanation: Every left/right pair is swapped at every level.\n```',
    E'Output: [5,8,3,9,7,4,2]\nExplanation: Every left/right pair is swapped at every level.\n```\n\n```diagram-tree\nnodes: [5, 3, 8, 2, 4, 7, 9]\n```'
)
WHERE slug = 'mirror-menu-tree';

-- Korean translation
UPDATE problem_translations
SET description = REPLACE(
    description,
    E'출력: [5,8,3,9,7,4,2]\n설명: 모든 계층에서 왼쪽과 오른쪽 자식 쌍이 통째로 맞바뀌어 거울 이미지 트리가 만들어집니다.\n```',
    E'출력: [5,8,3,9,7,4,2]\n설명: 모든 계층에서 왼쪽과 오른쪽 자식 쌍이 통째로 맞바뀌어 거울 이미지 트리가 만들어집니다.\n```\n\n```diagram-tree\nnodes: [5, 3, 8, 2, 4, 7, 9]\n```'
)
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'mirror-menu-tree')
  AND locale = 'ko';
