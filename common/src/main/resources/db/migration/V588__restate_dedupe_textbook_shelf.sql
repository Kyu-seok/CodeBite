-- V588: dedupe-textbook-shelf, text only. The Examples write `2, books = [2,5,_]` while the
-- judge prints k and then the first k values on the next line, which the statement never said
-- (statement cold-read, #350). One sentence in each language says what the judge prints.

UPDATE problems SET
    description = $$A sorted integer array `books` represents textbooks on a classroom shelf, with duplicates grouped together. Move the unique values to the front in their original order, and return `k`, the number of unique values. Positions from index `k` onward aren't checked. The judge prints `k` on one line and the first `k` values of `books` on the next, so Example 1 is judged as `2` then `[2,5]`.

**Example 1:**
```
Input: books = [2,2,5]
Output: 2, books = [2,5,_]
Explanation: Return k = 2. The front reads 2 then 5.
```

**Example 2:**
```
Input: books = [1,1,2,2,3,4,4,6,6,6]
Output: 5, books = [1,2,3,4,6,_,_,_,_,_]
Explanation: Five distinct values sit at the front in order.
```

**Example 3:**
```
Input: books = [8]
Output: 1, books = [8]
Explanation: A single-copy shelf is already compact.
```$$
WHERE slug = $$dedupe-textbook-shelf$$;

UPDATE problem_translations SET
    description = $$정렬된 정수 배열 `books`는 교실 책꽂이에 꽂힌 교과서를 나타내며, 같은 값(같은 책)은 서로 붙어 있습니다. 고유한 값들을 원래 순서대로 앞쪽으로 옮기고, 고유한 값의 개수 `k`를 반환하세요. 인덱스 `k` 이후의 위치는 검사하지 않습니다. 채점기는 첫 줄에 `k`를, 다음 줄에 `books`의 앞쪽 `k`개 값을 출력하므로, 예시 1은 `2`와 `[2,5]`로 채점됩니다.

**예시 1:**
```
입력: books = [2,2,5]
출력: 2, books = [2,5,_]
설명: k = 2를 반환합니다. 앞쪽은 2, 5 순서로 채워집니다.
```

**예시 2:**
```
입력: books = [1,1,2,2,3,4,4,6,6,6]
출력: 5, books = [1,2,3,4,6,_,_,_,_,_]
설명: 다섯 개의 서로 다른 값이 원래 순서대로 앞쪽에 자리잡습니다.
```

**예시 3:**
```
입력: books = [8]
출력: 1, books = [8]
설명: 한 권만 있는 책꽂이는 이미 정리된 상태입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$dedupe-textbook-shelf$$);
