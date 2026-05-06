-- V148: Restore canonical names for 10 classic CS puzzles whose iconic
-- framings predate LeetCode (Sudoku, N-Queens, FizzBuzz, Sort Colors,
-- Trapping Rain Water, Largest Rectangle in Histogram, Word Search/II,
-- Word Ladder, LRU Cache). English titles, Korean titles, and slugs are
-- refreshed here. Driver folders, starter folders, and method names are
-- renamed in the same commit. Descriptions (English/Korean) are rewritten
-- in V149/V150.

-- valid-number-puzzle -> valid-sudoku
UPDATE problems SET
    slug = $$valid-sudoku$$,
    title = $$Valid Sudoku$$
WHERE slug = $$valid-number-puzzle$$;

UPDATE problem_translations SET
    title = $$유효한 스도쿠$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$valid-sudoku$$);

-- sort-recycle-bins -> sort-colors
UPDATE problems SET
    slug = $$sort-colors$$,
    title = $$Sort Colors$$
WHERE slug = $$sort-recycle-bins$$;

UPDATE problem_translations SET
    title = $$색깔 정렬$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$sort-colors$$);

-- puddle-between-fences -> trapping-rain-water
UPDATE problems SET
    slug = $$trapping-rain-water$$,
    title = $$Trapping Rain Water$$
WHERE slug = $$puddle-between-fences$$;

UPDATE problem_translations SET
    title = $$빗물 가두기$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$trapping-rain-water$$);

-- find-hidden-words -> word-search-ii
UPDATE problems SET
    slug = $$word-search-ii$$,
    title = $$Word Search II$$
WHERE slug = $$find-hidden-words$$;

UPDATE problem_translations SET
    title = $$단어 찾기 II$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$word-search-ii$$);

-- place-n-scouts -> n-queens
UPDATE problems SET
    slug = $$n-queens$$,
    title = $$N-Queens$$
WHERE slug = $$place-n-scouts$$;

UPDATE problem_translations SET
    title = $$N-퀸$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$n-queens$$);

-- word-hunt-board -> word-search
UPDATE problems SET
    slug = $$word-search$$,
    title = $$Word Search$$
WHERE slug = $$word-hunt-board$$;

UPDATE problem_translations SET
    title = $$단어 찾기$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$word-search$$);

-- biggest-banner-span -> largest-rectangle-histogram
UPDATE problems SET
    slug = $$largest-rectangle-histogram$$,
    title = $$Largest Rectangle in Histogram$$
WHERE slug = $$biggest-banner-span$$;

UPDATE problem_translations SET
    title = $$히스토그램에서 가장 큰 직사각형$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$largest-rectangle-histogram$$);

-- recent-save-slots -> lru-cache
-- Test case input strings also need updating: V125 set op strings to
-- "RecentRegistry"/"lookup"/"store"; the canonical driver expects
-- "LRUCache"/"get"/"put".
UPDATE problems SET
    slug = $$lru-cache$$,
    title = $$LRU Cache$$
WHERE slug = $$recent-save-slots$$;

UPDATE problem_translations SET
    title = $$LRU 캐시$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$lru-cache$$);

UPDATE test_cases SET input = REPLACE(input, '"RecentRegistry"', '"LRUCache"')
WHERE problem_id = (SELECT id FROM problems WHERE slug = $$lru-cache$$);

UPDATE test_cases SET input = REPLACE(input, '"lookup"', '"get"')
WHERE problem_id = (SELECT id FROM problems WHERE slug = $$lru-cache$$);

UPDATE test_cases SET input = REPLACE(input, '"store"', '"put"')
WHERE problem_id = (SELECT id FROM problems WHERE slug = $$lru-cache$$);

-- spawn-code-ladder -> word-ladder
UPDATE problems SET
    slug = $$word-ladder$$,
    title = $$Word Ladder$$
WHERE slug = $$spawn-code-ladder$$;

UPDATE problem_translations SET
    title = $$단어 사다리$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$word-ladder$$);

-- round-nicknames -> fizz-buzz
UPDATE problems SET
    slug = $$fizz-buzz$$,
    title = $$Fizz Buzz$$
WHERE slug = $$round-nicknames$$;

UPDATE problem_translations SET
    title = $$피즈버즈$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$fizz-buzz$$);
