-- V400: cafe-price-ratios, text restated. The text said "drinks", the examples milk, bread
-- and eggs and the constraints "Item codes": now "items" throughout, in Korean "품목". The
-- answers' five decimal places were only shown: the statement now says each answer is
-- rounded to 5 decimal places. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$A cafe knows some price ratios between its items. Each pair `ratios[i] = [Ai, Bi]` with `values[i]` means one `Ai` costs `values[i]` times as much as one `Bi`. For each query `queries[j] = [Cj, Dj]`, return the price ratio `Cj / Dj` that the known ratios imply.

- A ratio works both ways: if `A / B = k`, then `B / A = 1 / k`. Ratios chain: `A / C = (A / B) * (B / C)`.
- `A / A = 1.0` for any item that appears in `ratios`.
- Return `-1.0` when the two items are not linked by any chain of ratios, or when either item never appears in `ratios`.

Return the answers in query order. Each answer is rounded to 5 decimal places, as the examples show.

**Example 1:**
```
Input: ratios = [["milk","bread"],["bread","eggs"]], values = [4.0,2.0], queries = [["milk","eggs"],["eggs","bread"],["bread","milk"],["milk","milk"],["soap","milk"]]
Output: [8.00000,0.50000,0.25000,1.00000,-1.00000]
Explanation: milk/eggs = (milk/bread) * (bread/eggs) = 4.0 * 2.0 = 8.0; eggs/bread = 1/2.0 = 0.5; bread/milk = 1/4.0 = 0.25; milk/milk = 1.0; soap never appears in ratios, so its query is -1.0.
```

```diagram-graph
edges: [["milk","bread"],["bread","eggs"]]
directed: true
highlight_path: ["milk","bread","eggs"]
```

**Example 2:**
```
Input: ratios = [["apple","pear"],["pear","plum"],["kiwi","lime"]], values = [3.0,4.0,2.0], queries = [["apple","plum"],["plum","apple"],["kiwi","lime"],["apple","kiwi"]]
Output: [12.00000,0.08333,2.00000,-1.00000]
Explanation: apple and plum are linked through pear: apple/plum = 3.0 * 4.0 = 12.0, and plum/apple = 1/12.0 = 0.08333 after rounding. kiwi and lime are linked to each other only, so kiwi/lime = 2.0 but apple/kiwi is -1.0.
```$$,
    constraints = $$- `1 <= ratios.length <= 25`
- `ratios[i].length == 2`
- `1 <= ratios[i][0].length, ratios[i][1].length <= 8`
- `values.length == ratios.length`
- `0.0 < values[i] <= 25.0`
- `1 <= queries.length <= 25`
- `queries[i].length == 2`
- `1 <= queries[i][0].length, queries[i][1].length <= 8`
- Item names consist of lowercase English letters and digits.
- The ratios never contradict each other.$$
WHERE slug = $$cafe-price-ratios$$;

UPDATE problem_translations SET
    description = $$카페가 몇몇 품목 사이의 가격 비율을 알고 있습니다. 쌍 `ratios[i] = [Ai, Bi]`와 `values[i]`는 `Ai` 하나의 가격이 `Bi` 하나의 가격의 `values[i]`배라는 뜻입니다. 각 질의 `queries[j] = [Cj, Dj]`에 대해, 알려진 비율들로부터 유도되는 가격 비율 `Cj / Dj`를 반환하세요.

- 비율은 양방향으로 쓸 수 있습니다. `A / B = k`이면 `B / A = 1 / k`입니다. 비율은 이어서 쓸 수 있습니다. `A / C = (A / B) * (B / C)`입니다.
- `ratios`에 등장하는 품목은 `A / A = 1.0`입니다.
- 두 품목이 어떤 비율의 사슬로도 이어지지 않거나, 둘 중 하나가 `ratios`에 한 번도 등장하지 않으면 `-1.0`을 반환합니다.

답은 질의 순서대로 반환합니다. 각 답은 예시처럼 소수점 아래 5자리로 반올림됩니다.

**예시 1:**
```
입력: ratios = [["milk","bread"],["bread","eggs"]], values = [4.0,2.0], queries = [["milk","eggs"],["eggs","bread"],["bread","milk"],["milk","milk"],["soap","milk"]]
출력: [8.00000,0.50000,0.25000,1.00000,-1.00000]
설명: milk/eggs = (milk/bread) * (bread/eggs) = 4.0 * 2.0 = 8.0; eggs/bread = 1/2.0 = 0.5; bread/milk = 1/4.0 = 0.25; milk/milk = 1.0; soap는 ratios에 한 번도 등장하지 않으므로 해당 질의는 -1.0입니다.
```

```diagram-graph
edges: [["milk","bread"],["bread","eggs"]]
directed: true
highlight_path: ["milk","bread","eggs"]
```

**예시 2:**
```
입력: ratios = [["apple","pear"],["pear","plum"],["kiwi","lime"]], values = [3.0,4.0,2.0], queries = [["apple","plum"],["plum","apple"],["kiwi","lime"],["apple","kiwi"]]
출력: [12.00000,0.08333,2.00000,-1.00000]
설명: apple과 plum은 pear를 거쳐 이어지므로 apple/plum = 3.0 * 4.0 = 12.0이고, plum/apple = 1/12.0을 반올림한 0.08333입니다. kiwi와 lime은 서로끼리만 이어져 있어 kiwi/lime = 2.0이지만 apple/kiwi는 -1.0입니다.
```$$,
    constraints = $$- `1 <= ratios.length <= 25`
- `ratios[i].length == 2`
- `1 <= ratios[i][0].length, ratios[i][1].length <= 8`
- `values.length == ratios.length`
- `0.0 < values[i] <= 25.0`
- `1 <= queries.length <= 25`
- `queries[i].length == 2`
- `1 <= queries[i][0].length, queries[i][1].length <= 8`
- 품목 이름은 영어 소문자와 숫자로만 이루어져 있습니다.
- 비율끼리 서로 모순되는 경우는 없습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$cafe-price-ratios$$);
