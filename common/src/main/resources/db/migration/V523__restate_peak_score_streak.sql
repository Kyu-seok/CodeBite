-- V523: peak-score-streak restated, Slug, title and text unchanged. The method was
-- named peakReadingSum, left over from another theme: renamed maxScoreStreak in the
-- Starter Code and Drivers. The bound |nums[i]| <= 10^8 let a window sum overflow the
-- int the method returns (2 * 10^5 * 10^8); it is now 10^4, which every case meets
-- (the largest is 100). Examples are unchanged.

UPDATE problems SET
    constraints = $$- `1 <= nums.length <= 2 * 10^5`
- `|nums[i]| <= 10^4`$$
WHERE slug = $$peak-score-streak$$;

UPDATE problem_translations SET
    constraints = $$- `1 <= nums.length <= 2 * 10^5`
- `|nums[i]| <= 10^4`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$peak-score-streak$$);
