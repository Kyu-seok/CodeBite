-- Export for scripts/replay-judge0-python.py: every problem with all its test cases and its latest
-- Accepted Python submission, a user's if there is one, otherwise an admin's (null when neither).
-- An admin's is an admin bulk-validation submission or one made by an ADMIN account.
select json_agg(json_build_object(
    'slug', p.slug,
    'test_cases', (select coalesce(json_agg(json_build_object('input', t.input, 'expected_output', t.expected_output)
                                            order by t.order_index, t.id), '[]')
                   from test_cases t where t.problem_id = p.id),
    'solution', (select json_build_object(
                        'source', s.source_code,
                        'origin', case when s.admin_submission or u.role = 'ADMIN' then 'admin' else 'user' end
                                  || ' submission ' || s.id)
                 from submissions s join users u on u.id = s.user_id
                 where s.problem_id = p.id and s.language = 'python' and s.status = 'ACCEPTED'
                 order by (s.admin_submission or u.role = 'ADMIN'), s.created_at desc, s.id desc
                 limit 1)
) order by p.problem_number nulls last, p.slug)
from problems p;
