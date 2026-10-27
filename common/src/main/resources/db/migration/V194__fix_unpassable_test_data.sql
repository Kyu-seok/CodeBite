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

-- word-ladder: the length counts both endpoints, so pet -> pot (one letter, pot in the list) is 2,
-- as the description and sample test case 3 (x -> z) say, but V124 gave sample test case 1 the
-- answer 3. Expect 2 (the input is matched with LIKE because V124 wrote it as E'pet\npot\n...', which
-- H2 keeps verbatim), and make Example 1's diagram draw Example 1's path instead of pet -> pit -> pot.
UPDATE test_cases
SET expected_output = '2'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-ladder')
  AND is_sample = TRUE
  AND order_index = 1
  AND input LIKE 'pet%pot%["pit","pot","pat"]'
  AND expected_output = '3';

UPDATE problems
SET description = REPLACE(description,
        'edges: [["pet","pit"],["pit","pot"]]
directed: true
highlight_path: ["pet","pit","pot"]',
        'edges: [["hit","hot"],["hot","dot"],["hot","lot"],["dot","dog"],["lot","log"],["dog","cog"],["log","cog"]]
directed: false
highlight_path: ["hit","hot","dot","dog","cog"]')
WHERE slug = 'word-ladder';

UPDATE problem_translations
SET description = REPLACE(description,
        'edges: [["pet","pit"],["pit","pot"]]
directed: true
highlight_path: ["pet","pit","pot"]',
        'edges: [["hit","hot"],["hot","dot"],["hot","lot"],["dot","dog"],["lot","log"],["dog","cog"],["log","cog"]]
directed: false
highlight_path: ["hit","hot","dot","dog","cog"]')
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-ladder')
  AND locale = 'ko';

-- dog-street-walk: the description starts every walk at "HUB", but test cases 3-11 came from the
-- original itinerary problem and start at "JFK", so a solution following the description could not
-- pass them. Rename JFK to HUB in each; no other zone in them sorts between HUB and JFK, so every
-- expected walk stays the lexicographically smallest.
UPDATE test_cases
SET input = '[["HUB","KUL"],["HUB","NRT"],["NRT","HUB"]]',
    expected_output = '["HUB","NRT","HUB","KUL"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'dog-street-walk')
  AND order_index = 3
  AND input = '[["JFK","KUL"],["JFK","NRT"],["NRT","JFK"]]'
  AND expected_output = '["JFK","NRT","JFK","KUL"]';

UPDATE test_cases
SET input = '[["HUB","ATL"]]',
    expected_output = '["HUB","ATL"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'dog-street-walk')
  AND order_index = 4
  AND input = '[["JFK","ATL"]]'
  AND expected_output = '["JFK","ATL"]';

UPDATE test_cases
SET input = '[["HUB","AAA"],["AAA","HUB"],["HUB","BBB"]]',
    expected_output = '["HUB","AAA","HUB","BBB"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'dog-street-walk')
  AND order_index = 5
  AND input = '[["JFK","AAA"],["AAA","JFK"],["JFK","BBB"]]'
  AND expected_output = '["JFK","AAA","JFK","BBB"]';

UPDATE test_cases
SET input = '[["HUB","SFO"],["SFO","HUB"]]',
    expected_output = '["HUB","SFO","HUB"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'dog-street-walk')
  AND order_index = 6
  AND input = '[["JFK","SFO"],["SFO","JFK"]]'
  AND expected_output = '["JFK","SFO","JFK"]';

UPDATE test_cases
SET input = '[["HUB","ZZZ"],["HUB","AAA"],["AAA","HUB"]]',
    expected_output = '["HUB","AAA","HUB","ZZZ"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'dog-street-walk')
  AND order_index = 7
  AND input = '[["JFK","ZZZ"],["JFK","AAA"],["AAA","JFK"]]'
  AND expected_output = '["JFK","AAA","JFK","ZZZ"]';

UPDATE test_cases
SET input = '[["HUB","AAA"],["AAA","BBB"],["BBB","HUB"],["HUB","AAA"],["AAA","CCC"]]',
    expected_output = '["HUB","AAA","BBB","HUB","AAA","CCC"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'dog-street-walk')
  AND order_index = 8
  AND input = '[["JFK","AAA"],["AAA","BBB"],["BBB","JFK"],["JFK","AAA"],["AAA","CCC"]]'
  AND expected_output = '["JFK","AAA","BBB","JFK","AAA","CCC"]';

UPDATE test_cases
SET input = '[["HUB","LAX"],["LAX","SFO"],["SFO","HUB"],["HUB","DEN"]]',
    expected_output = '["HUB","LAX","SFO","HUB","DEN"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'dog-street-walk')
  AND order_index = 9
  AND input = '[["JFK","LAX"],["LAX","SFO"],["SFO","JFK"],["JFK","DEN"]]'
  AND expected_output = '["JFK","LAX","SFO","JFK","DEN"]';

UPDATE test_cases
SET input = '[["HUB","AAA"],["AAA","BBB"],["BBB","AAA"],["AAA","HUB"],["HUB","AAA"],["AAA","CCC"]]',
    expected_output = '["HUB","AAA","BBB","AAA","HUB","AAA","CCC"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'dog-street-walk')
  AND order_index = 10
  AND input = '[["JFK","AAA"],["AAA","BBB"],["BBB","AAA"],["AAA","JFK"],["JFK","AAA"],["AAA","CCC"]]'
  AND expected_output = '["JFK","AAA","BBB","AAA","JFK","AAA","CCC"]';

UPDATE test_cases
SET input = '[["HUB","A"],["A","B"],["B","C"],["C","D"],["D","E"]]',
    expected_output = '["HUB","A","B","C","D","E"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'dog-street-walk')
  AND order_index = 11
  AND input = '[["JFK","A"],["A","B"],["B","C"],["C","D"],["D","E"]]'
  AND expected_output = '["JFK","A","B","C","D","E"]';
