-- V587: dog-street-walk, text only. Two Test Cases list the same segment twice and expect it
-- walked twice, which the statement never said (statement cold-read, #350). One constraint
-- line in each language states it.

UPDATE problems SET
    constraints = $$- `1 <= routes.length <= 320`
- `routes[i].length == 2`
- Each `from` and `to` is a zone code of 1 to 3 uppercase English letters.
- `from != to` within any single segment.
- The same segment may appear more than once in `routes`; the walk uses each copy once.
- At least one walk starts at `"HUB"` and uses every segment exactly once.$$
WHERE slug = $$dog-street-walk$$;

UPDATE problem_translations SET
    constraints = $$- `1 <= routes.length <= 320`
- `routes[i].length == 2`
- 각 `from`과 `to`는 영어 대문자 1~3글자로 된 구역 코드입니다.
- 같은 구간 안에서 `from != to`입니다.
- 같은 구간이 `routes`에 여러 번 나올 수 있으며, 경로는 각각을 한 번씩 사용합니다.
- `"HUB"`에서 출발해 모든 구간을 정확히 한 번씩 사용하는 경로가 하나 이상 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$dog-street-walk$$);
