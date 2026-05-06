-- V151: Drop 13 over-themed rebrands where the casual story added a
-- translation layer over the underlying problem (anagram check, tree
-- problems dressed as guilds, subset generation as trail-mix combos,
-- LCA dressed as catalog/guild, etc.) — these revert to canonical CS
-- naming. Slugs, English titles, and Korean titles are refreshed here.
-- Driver folders, starter folders, and method/class/parameter names are
-- renamed in the same commit. Descriptions (English/Korean) are rewritten
-- in V152/V153.

-- same-snack-mix -> valid-anagram
-- The snack-mix-as-ingredient-multiset rebrand forced readers to translate
-- "trail-mix bag" into "string" and "ingredient" into "letter" before they
-- could engage with the actual problem. "Anagram" is a widely-known term, so
-- the canonical framing is clearer.
UPDATE problems SET
    slug = $$valid-anagram$$,
    title = $$Valid Anagram$$
WHERE slug = $$same-snack-mix$$;

UPDATE problem_translations SET
    title = $$애너그램 확인$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$valid-anagram$$);

-- group-drink-labels -> group-anagrams
UPDATE problems SET
    slug = $$group-anagrams$$,
    title = $$Group Anagrams$$
WHERE slug = $$group-drink-labels$$;

UPDATE problem_translations SET
    title = $$그룹 애너그램$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$group-anagrams$$);

-- topic-catalog-lca -> lca-bst
UPDATE problems SET
    slug = $$lca-bst$$,
    title = $$Lowest Common Ancestor of a BST$$
WHERE slug = $$topic-catalog-lca$$;

UPDATE problem_translations SET
    title = $$이진 검색 트리의 최소 공통 조상$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$lca-bst$$);

-- link-guild-siblings -> populating-next-pointers
UPDATE problems SET
    slug = $$populating-next-pointers$$,
    title = $$Populating Next Right Pointers$$
WHERE slug = $$link-guild-siblings$$;

UPDATE problem_translations SET
    title = $$다음 오른쪽 포인터 연결$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$populating-next-pointers$$);

-- sum-skill-tree-codes -> sum-root-to-leaf
UPDATE problems SET
    slug = $$sum-root-to-leaf$$,
    title = $$Sum Root to Leaf Numbers$$
WHERE slug = $$sum-skill-tree-codes$$;

UPDATE problem_translations SET
    title = $$루트에서 리프까지의 수 합$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$sum-root-to-leaf$$);

-- shared-guild-ancestor -> lca-binary-tree
UPDATE problems SET
    slug = $$lca-binary-tree$$,
    title = $$Lowest Common Ancestor of a Binary Tree$$
WHERE slug = $$shared-guild-ancestor$$;

UPDATE problem_translations SET
    title = $$이진 트리의 최소 공통 조상$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$lca-binary-tree$$);

-- list-trail-mix-combos -> subsets-ii
UPDATE problems SET
    slug = $$subsets-ii$$,
    title = $$Subsets II$$
WHERE slug = $$list-trail-mix-combos$$;

UPDATE problem_translations SET
    title = $$부분집합 II$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$subsets-ii$$);

-- valid-pet-tree -> graph-valid-tree
UPDATE problems SET
    slug = $$graph-valid-tree$$,
    title = $$Graph Valid Tree$$
WHERE slug = $$valid-pet-tree$$;

UPDATE problem_translations SET
    title = $$유효한 그래프 트리$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$graph-valid-tree$$);

-- reverse-playlist -> reverse-linked-list
UPDATE problems SET
    slug = $$reverse-linked-list$$,
    title = $$Reverse Linked List$$
WHERE slug = $$reverse-playlist$$;

UPDATE problem_translations SET
    title = $$연결 리스트 뒤집기$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$reverse-linked-list$$);

-- group-tree-by-level -> binary-tree-level-order
UPDATE problems SET
    slug = $$binary-tree-level-order$$,
    title = $$Binary Tree Level Order Traversal$$
WHERE slug = $$group-tree-by-level$$;

UPDATE problem_translations SET
    title = $$이진 트리 레벨 순서 순회$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$binary-tree-level-order$$);

-- skill-tree-codec -> binary-tree-codec
-- The codec driver only takes a tree-array as input (then calls pack/unpack
-- internally), so test_cases.input has no class/method literal strings to
-- REPLACE — unlike LRU.
UPDATE problems SET
    slug = $$binary-tree-codec$$,
    title = $$Serialize and Deserialize Binary Tree$$
WHERE slug = $$skill-tree-codec$$;

UPDATE problem_translations SET
    title = $$이진 트리 직렬화와 역직렬화$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$binary-tree-codec$$);

-- nearest-cat-feeder -> walls-and-gates
UPDATE problems SET
    slug = $$walls-and-gates$$,
    title = $$Walls and Gates$$
WHERE slug = $$nearest-cat-feeder$$;

UPDATE problem_translations SET
    title = $$벽과 문$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$walls-and-gates$$);

-- longest-doodle-palindrome -> longest-palindromic-substring
-- This problem is a length-only variant of LC #5: it returns the length of
-- the longest palindromic substring rather than the substring itself. The
-- canonical title is preserved; the description spells out that we return
-- the length, matching the existing test cases.
UPDATE problems SET
    slug = $$longest-palindromic-substring$$,
    title = $$Longest Palindromic Substring$$
WHERE slug = $$longest-doodle-palindrome$$;

UPDATE problem_translations SET
    title = $$가장 긴 회문 부분 문자열$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-palindromic-substring$$);
