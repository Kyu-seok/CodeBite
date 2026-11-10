-- V306: restate group-anagrams (#239). Example 3 (strs = [""]) showed hidden Test Case 3
-- exactly; it is dropped in both languages, leaving Examples 1 and 2, which show samples 1
-- and 2 unchanged. The empty string stays stated by the constraint 0 <= strs[i].length.
-- Only the descriptions change; Slug, titles, constraints, Test Cases, Starter Code and
-- Drivers are unchanged.

UPDATE problems SET
    description = $$Given an array of lowercase strings `strs`, group together every set of strings that are anagrams of one another. Two strings are anagrams when one can be rearranged into the other (same letters, same counts).

Return the groups as a list of lists. Order of groups, and order within each group, does not matter.

**Example 1:**
```
Input: strs = ["oakvanilla","vanillaoak","plum","lump","berrytannin","tanninberry","oak"]
Output: [["berrytannin","tanninberry"],["lump","plum"],["oak"],["oakvanilla","vanillaoak"]]
```

**Example 2:**
```
Input: strs = ["merlot"]
Output: [["merlot"]]
```$$
WHERE slug = $$group-anagrams$$;

UPDATE problem_translations SET
    description = $$소문자로 된 문자열 배열 `strs`가 주어집니다. 서로 *애너그램*(같은 글자가 같은 개수만큼 들어 있어 한쪽을 재배열하면 다른 쪽이 되는 관계)인 문자열들을 같은 그룹으로 묶으세요.

결과는 그룹들의 리스트로 반환합니다. 그룹들 간의 순서나 그룹 안 문자열들의 순서는 상관없습니다.

**예시 1:**
```
입력: strs = ["oakvanilla","vanillaoak","plum","lump","berrytannin","tanninberry","oak"]
출력: [["berrytannin","tanninberry"],["lump","plum"],["oak"],["oakvanilla","vanillaoak"]]
설명: `oakvanilla`와 `vanillaoak`, `plum`과 `lump`, `berrytannin`과 `tanninberry`는 각각 글자 구성이 같아 한 그룹이 되고, `oak`는 짝이 없어 자기 자신만으로 한 그룹입니다.
```

**예시 2:**
```
입력: strs = ["merlot"]
출력: [["merlot"]]
설명: 원소가 하나뿐이므로 그 자체가 유일한 그룹이 됩니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$group-anagrams$$);
