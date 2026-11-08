-- V215: restate word-ladder (#176, part of #168). The English constraints named
-- `startCode` -> `beginWord`, `targetCode` -> `endWord`, `codeBank` -> `wordList`, which the Starter Code never mentions. Only the
-- English constraints change; Slug, title, description, Korean text, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problems SET
    constraints = $$- `1 <= beginWord.length <= 10`
- `endWord.length == beginWord.length`
- `1 <= wordList.length <= 4500`
- `wordList[i].length == beginWord.length`
- `beginWord`, `endWord`, and each `wordList[i]` consist of lowercase English letters
- `beginWord != endWord`$$
WHERE slug = $$word-ladder$$;
