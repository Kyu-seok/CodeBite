INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems;
