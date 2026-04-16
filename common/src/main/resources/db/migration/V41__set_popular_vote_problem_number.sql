-- Set problem_number for Popular Vote (was missing from V40 INSERT)
UPDATE problems SET problem_number = 101 WHERE slug = 'popular-vote';
