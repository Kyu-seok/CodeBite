-- Remove 7 problems not in the curated 200-problem plan
-- These were early seed problems that don't appear in any major interview curation.
-- CASCADE handles: test_cases, problem_translations, problem_tags, roadmap_category_problems
-- Submissions must be deleted explicitly (no CASCADE on problem_id FK)

-- Delete submission results for submissions against these problems
DELETE FROM submission_results
WHERE submission_id IN (
    SELECT s.id FROM submissions s
    JOIN problems p ON s.problem_id = p.id
    WHERE p.slug IN ('fizzbuzz', 'palindrome-number', 'plus-one', 'reverse-string',
                     'reverse-words-in-a-string', 'sqrtx', 'pascals-triangle')
);

-- Delete submissions against these problems
DELETE FROM submissions
WHERE problem_id IN (
    SELECT id FROM problems
    WHERE slug IN ('fizzbuzz', 'palindrome-number', 'plus-one', 'reverse-string',
                   'reverse-words-in-a-string', 'sqrtx', 'pascals-triangle')
);

-- Delete the problems (test_cases, translations, tags, roadmap entries cascade)
DELETE FROM problems
WHERE slug IN ('fizzbuzz', 'palindrome-number', 'plus-one', 'reverse-string',
               'reverse-words-in-a-string', 'sqrtx', 'pascals-triangle');
