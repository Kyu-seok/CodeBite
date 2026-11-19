-- V525: move-voided-scans restated, Slug and title unchanged. The method was named
-- voidEmptyScans, which reads as "void the empty scans": renamed moveVoidsToEnd in the
-- Starter Code and Drivers (Driver local nums renamed scans). The sentence about the
-- driver printing the array is dropped, and Example 2 is explained. Examples match the
-- sample test cases, which are unchanged.

UPDATE problems SET
    description = $$The cafe's point-of-sale stores each order's price in `scans` in the order it was rung up, with voided orders as `0`. Move every `0` to the end while the real prices keep their original order.

Implement `moveVoidsToEnd(scans)`, changing `scans` **in place** without allocating a new array. It returns nothing.

**Example 1:**
```
Input: scans = [4,0,0,2,9,0,7]
Output: [4,2,9,7,0,0,0]
Explanation: The four real prices keep their order, and the three voids move to the end.
```

**Example 2:**
```
Input: scans = [0,0,5]
Output: [5,0,0]
Explanation: The one real price, 5, moves to the front, and both voids follow it.
```$$
WHERE slug = $$move-voided-scans$$;

UPDATE problem_translations SET
    description = $$카페 포스기는 주문이 들어온 순서대로 각 주문의 가격을 정수 배열 `scans`에 기록하며, 취소된 주문은 `0`으로 남깁니다. 모든 `0`을 배열의 끝으로 옮기고, 실제 가격들은 원래 들어왔던 순서를 그대로 유지하세요.

`moveVoidsToEnd(scans)`를 구현하세요. 새 배열을 할당하지 말고 `scans`를 **제자리에서** 바꾸며, 아무것도 반환하지 않습니다.

**예시 1:**
```
입력: scans = [4,0,0,2,9,0,7]
출력: [4,2,9,7,0,0,0]
설명: 실제 가격 네 개는 들어온 순서를 유지하고, 취소 주문 세 개는 끝으로 옮겨집니다.
```

**예시 2:**
```
입력: scans = [0,0,5]
출력: [5,0,0]
설명: 하나뿐인 실제 가격 5가 맨 앞으로 오고, 취소 주문 두 개가 그 뒤에 놓입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$move-voided-scans$$);
