-- #90: test data that contradicted its drivers or descriptions, so no correct solution could be
-- Accepted in any language. Every update matches the old value exactly (or replaces an exact
-- old string), so a row that differs from the one V124 left is left alone.

-- cafe-stop-orders: every driver sorts the permutations before printing, but V124 gave sample
-- test case 1 ([4,7,2]) its permutations in input order. List them in the drivers' order, and
-- show the same output in the English and Korean Example 1.
UPDATE test_cases
SET expected_output = '[[2,4,7],[2,7,4],[4,2,7],[4,7,2],[7,2,4],[7,4,2]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cafe-stop-orders')
  AND is_sample = TRUE
  AND order_index = 1
  AND input = '[4,7,2]'
  AND expected_output = '[[4,7,2],[4,2,7],[7,4,2],[7,2,4],[2,4,7],[2,7,4]]';

UPDATE problems
SET description = REPLACE(description,
        'Output: [[4,7,2],[4,2,7],[7,4,2],[7,2,4],[2,4,7],[2,7,4]]',
        'Output: [[2,4,7],[2,7,4],[4,2,7],[4,7,2],[7,2,4],[7,4,2]]')
WHERE slug = 'cafe-stop-orders';

UPDATE problem_translations
SET description = REPLACE(description,
        '출력: [[4,7,2],[4,2,7],[7,4,2],[7,2,4],[2,4,7],[2,7,4]]',
        '출력: [[2,4,7],[2,7,4],[4,2,7],[4,7,2],[7,2,4],[7,4,2]]')
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cafe-stop-orders')
  AND locale = 'ko';

-- merge-duplicate-contacts: every driver sorts each account's emails and then the accounts by
-- their first email, but V124 gave sample test case 1 its accounts in first-appearance order
-- (Maya before Leo). List Leo first, and show the same output in the English and Korean Example 1.
UPDATE test_cases
SET expected_output = '[["Leo","leo.grip@set.film"],["Maya","maya.dp@set.film","mayalens@set.film","mk.camera@set.film"],["Maya","maya.solo@set.film"]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-duplicate-contacts')
  AND is_sample = TRUE
  AND order_index = 1
  AND input = '[["Maya","maya.dp@set.film","mayalens@set.film"],["Maya","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]'
  AND expected_output = '[["Maya","maya.dp@set.film","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]';

UPDATE problems
SET description = REPLACE(description,
        'Output: [["Maya","maya.dp@set.film","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]',
        'Output: [["Leo","leo.grip@set.film"],["Maya","maya.dp@set.film","mayalens@set.film","mk.camera@set.film"],["Maya","maya.solo@set.film"]]')
WHERE slug = 'merge-duplicate-contacts';

UPDATE problem_translations
SET description = REPLACE(description,
        '출력: [["Maya","maya.dp@set.film","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]',
        '출력: [["Leo","leo.grip@set.film"],["Maya","maya.dp@set.film","mayalens@set.film","mk.camera@set.film"],["Maya","maya.solo@set.film"]]')
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-duplicate-contacts')
  AND locale = 'ko';
