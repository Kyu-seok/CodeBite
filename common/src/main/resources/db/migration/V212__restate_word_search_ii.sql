-- V212: restate word-search-ii (#173, part of #168). The English constraints named
-- `targetWords` -> `words`, which the Starter Code never mentions. Only the
-- English constraints change; Slug, title, description, Korean text, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problems SET
    constraints = $$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 12`
- `board[i][j]` is a lowercase English letter.
- `1 <= words.length <= 8 * 10^4`
- `1 <= words[i].length <= 10`
- `words[i]` consists of lowercase English letters.
- All the strings in `words` are unique.$$
WHERE slug = $$word-search-ii$$;
