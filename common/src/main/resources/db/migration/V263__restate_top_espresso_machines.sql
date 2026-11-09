-- V263: restate top-espresso-machines (#192, part of #168). The English span `[1, the number
-- of distinct machine ids in checkIns]` embedded prose no translation can carry, so the bound
-- on `k` is reworded in both languages with the same spans; the Korean bullets keep their
-- prose and carry the English constraints' code spans exactly. Only the constraints change,
-- English and Korean; Slug, title, description, Test Cases, Starter Code and Drivers are
-- unchanged.

UPDATE problems SET
    constraints = $$- `1 <= checkIns.length <= 2 * 10^5`
- `|checkIns[i]| <= 10^8`
- `k` is at least `1` and at most the number of distinct machine ids in `checkIns`.
- The answer is guaranteed to be unique.$$
WHERE slug = $$top-espresso-machines$$;

UPDATE problem_translations SET
    constraints = $$- `1 <= checkIns.length <= 2 * 10^5`
- `|checkIns[i]| <= 10^8`
- `k`는 `1` 이상, `checkIns`에 등장하는 서로 다른 머신 id 개수 이하입니다.
- 정답은 유일하게 결정된다고 보장됩니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$top-espresso-machines$$);
