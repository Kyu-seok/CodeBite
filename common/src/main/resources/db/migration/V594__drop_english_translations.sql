-- English lives only on problems (#242). The en rows of problem_translations were never read:
-- ProblemCatalogue and RoadmapService serve en from problems without querying translations, and
-- 200 of the 201 rows had drifted from it. Delete them, and refuse new ones so no author adds
-- one again. Not reversible except by re-running the old migrations' INSERTs (V22 onward).
DELETE FROM problem_translations WHERE locale = 'en';

ALTER TABLE problem_translations
    ADD CONSTRAINT problem_translations_locale_not_en CHECK (locale <> 'en');
