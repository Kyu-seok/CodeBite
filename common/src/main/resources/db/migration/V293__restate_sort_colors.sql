-- V293: restate sort-colors (#225, part of #193). The Examples showed LeetCode's data
-- (`[2,0,2,1,1,0]` and `[2,0,1]`) while the sample Test Cases are CodeBite's own
-- (`[1,2,0,2,1,0,1]` and `[2,1,0]`). Example N now shows sample N, in both languages.
-- Only the descriptions change; Slug, title, constraints, Test Cases, Starter Code and
-- Drivers are unchanged.

UPDATE problems SET
    description = $$An array `nums` contains only `0`, `1`, and `2` — three categories with a natural sort order (red, white, blue, by convention). Rearrange the entries **in place** so all `0`s come first, then all `1`s, then all `2`s. You may not call any built-in sort routine.

Aim for a single linear pass with constant extra space — the classic Dutch national flag partition.

**Example 1:**
```
Input: nums = [1,2,0,2,1,0,1]
Output: [0,0,1,1,1,2,2]
```

**Example 2:**
```
Input: nums = [2,1,0]
Output: [0,1,2]
```$$
WHERE slug = $$sort-colors$$;

UPDATE problem_translations SET
    description = $$배열 `nums`의 원소는 `0`, `1`, `2` 세 가지뿐이며, 자연스러운 정렬 순서가 있습니다(관례상 빨강, 하양, 파랑에 해당합니다). 모든 `0`이 앞쪽에, 그다음 `1`들이, 마지막에 `2`들이 오도록 **제자리에서** 재배열하세요. 내장 정렬 함수는 사용할 수 없습니다.

상수 추가 공간만 쓰면서 한 번의 선형 탐색으로 처리하는 것이 목표입니다 — 고전적인 네덜란드 국기 분할 문제입니다.

**예시 1:**
```
입력: nums = [1,2,0,2,1,0,1]
출력: [0,0,1,1,1,2,2]
```

**예시 2:**
```
입력: nums = [2,1,0]
출력: [0,1,2]
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$sort-colors$$);
