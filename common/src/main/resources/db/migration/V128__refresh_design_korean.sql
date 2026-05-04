-- V128: Phase 5 — refresh Korean translations for the 16 design problems.
--
-- The existing ko translations were written against the pre-V125 class/method
-- names and the pre-V127 textbook narrative. V125 renamed every class and its
-- methods; V126 tightened canonical fingerprints; V127 re-authored the
-- descriptions in domain framing. This migration drops the stale ko rows for
-- those 16 slugs and inserts fresh translations that mirror the new English.
--
-- Non-design translations are untouched.


-- Drop stale ko translations for the 16 refreshed slugs
DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
    'click-counter',
    'feed-designer',
    'hash-table',
    'kth-largest-stream',
    'minimum-stack',
    'prefix-tree',
    'random-set',
    'recent-cache',
    'ring-buffer',
    'running-median',
    'stack-queue',
    'state-snapshots',
    'string-codec',
    'time-map',
    'tree-codec',
    'word-dictionary'
    )
  );

-- click-counter
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'click-counter'),
    'ko',
    $$클릭 집계 윈도우$$,
    $$마케팅 랜딩 페이지의 실시간 트래픽 대시보드에서 지난 몇 분 동안 페이지가 흡수한 클릭 수를 표시하려고 합니다. 요청은 서버 기준의 '일(day) 단위 초'로 태깅되어 도착하며, 대시보드는 항상 양 끝을 포함하는 5분 롤링 윈도우를 반영해야 합니다.

`ClickTally` 클래스를 구현하여 클릭 이벤트를 수집하고 윈도우 쿼리에 응답할 수 있도록 합니다.

- `ClickTally()` — 기록된 클릭이 전혀 없는 새 집계기를 초기화합니다.
- `void record(int timestamp)` — `timestamp` 초에 발생한 단일 클릭을 기록합니다. 같은 초에 여러 클릭이 몰릴 수 있으며, 각각은 모두 개별적으로 계산됩니다.
- `int countSince(int timestamp)` — 닫힌 구간 `[timestamp - 299, timestamp]`에 속하는 클릭 수를 반환합니다.

`record`와 `countSince` 호출은 타임스탬프가 비감소 순서로 도착하며, 이는 append-only 특성을 가진 트래픽 로그의 성격을 그대로 반영합니다.

**예시 1:**
```
Input: ["ClickTally","record","record","record","countSince","record","countSince","countSince"] / [[],[1],[2],[3],[4],[300],[300],[301]]
Output: [null,null,null,null,3,null,4,3]
```
4초 시점에서 1, 2, 3초의 클릭은 모두 `[-295, 4]` 윈도우 안에 들어 있습니다. 300초 시점에서는 1초의 클릭도 여전히 `[1, 300]` 안에 있어 윈도우에 네 개의 클릭이 담깁니다. 한 초 뒤에는 가장 오래된 1초의 클릭이 `[2, 301]` 밖으로 밀려나면서 카운트가 3으로 줄어듭니다.

**예시 2:**
```
Input: ["ClickTally","record","record","record","countSince"] / [[],[100],[100],[100],[100]]
Output: [null,null,null,null,3]
```
같은 초를 공유하는 세 개의 클릭은 모두 해당 초에 고정된 윈도우에 포함됩니다.

**예시 3:**
```
Input: ["ClickTally","countSince","record","countSince"] / [[],[1],[2],[300]]
Output: [null,0,null,1]
```
클릭이 한 건도 도착하기 전에 실행된 쿼리는 0을 반환하며, 이후에 기록된 클릭은 300초 시점의 윈도우 안에 여전히 포함됩니다.$$,
    $$- `1 <= timestamp <= 2 * 10^9`
- 전체 호출을 통틀어 전달되는 각 `timestamp`는 이전 값보다 크거나 같습니다.
- `record`와 `countSince`를 합쳐 총 호출 수는 최대 250회입니다.$$
);

-- feed-designer
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'feed-designer'),
    'ko',
    $$숏포스트 피드$$,
    $$각 계정이 짧은 글을 게시하고, 자신의 글과 현재 팔로우 중인 사용자들의 글을 합쳐 타임라인을 훑어볼 수 있는 경량 숏포스트 소셜 네트워크의 백엔드를 연결하고 있습니다. 타임라인은 항상 게시 시각 기준으로 최신순 정렬되어야 하며, 가장 최근 10개 항목으로 제한됩니다.

하루 동안 사용자들이 구독과 구독 취소를 반복하더라도 팔로우 그래프와 게시 스트림이 일관성을 유지하도록 `MicroFeed` 클래스를 구현하세요.

- `MicroFeed()` — 사용자, 팔로우 관계, 게시글이 전혀 없는 빈 서비스를 시작합니다.
- `publishPost(int userId, int messageId)` — 계정 `userId`가 `messageId` 스니펫을 방금 게시했다는 사실을 기록합니다. 모든 `messageId`는 전역적으로 유일하며 게시 순서대로 도착합니다.
- `List<Integer> latestFeed(int userId)` — `userId`에게 보이는 가장 최근 메시지 ID를 최대 10개까지 반환합니다. 즉, `userId`가 직접 게시한 글과 현재 팔로우 중인 사용자가 게시한 글을 모두 포함해 최신순으로 정렬한 결과입니다.
- `subscribe(int followerId, int followeeId)` — `followerId`가 `followeeId`를 팔로우하도록 만듭니다. 두 ID가 동일하면 아무 동작도 하지 않습니다.
- `unsubscribe(int followerId, int followeeId)` — `followerId`가 `followeeId`를 더 이상 팔로우하지 않도록 만듭니다. 두 ID가 동일하거나 현재 팔로우 관계가 활성 상태가 아니면 아무 동작도 하지 않습니다.

**예시 1:**
```
Input: ["MicroFeed","publishPost","publishPost","latestFeed"]
       [[],[1,10],[1,20],[1]]
Output: [null,null,null,[20,10]]
```
계정 1이 스니펫 두 개를 게시하면 최신순으로 노출됩니다.

**예시 2:**
```
Input: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed"]
       [[],[1,10],[2,20],[1,2],[1]]
Output: [null,null,null,null,[20,10]]
```
계정 1이 계정 2를 팔로우하면, 계정 2의 스니펫이 계정 1의 타임라인에 등장합니다.

**예시 3:**
```
Input: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed","unsubscribe","latestFeed"]
       [[],[1,10],[2,20],[1,2],[1],[1,2],[1]]
Output: [null,null,null,null,[20,10],null,[10]]
```
팔로우 관계를 끊는 즉시 계정 2의 기여분이 계정 1의 타임라인에서 빠집니다.$$,
    $$- `1 <= userId, followerId, followeeId <= 500`
- `0 <= messageId <= 8000`
- `publishPost`, `latestFeed`, `subscribe`, `unsubscribe`를 통틀어 최대 `20000`회의 호출이 발생합니다.$$
);

-- hash-table
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'hash-table'),
    'ko',
    $$체이닝 키-값 맵$$,
    $$정수 SKU 코드를 재고 수량에 매핑하는 소규모 부품 인벤토리 서비스를 구축하고 있습니다. 플랫폼 정책상 내장 딕셔너리 라이브러리를 가져올 수 없기 때문에, 룩업 테이블은 체이닝(또는 동등한 충돌 처리 기법)을 사용해 직접 조립해야 하지만 외부적으로는 편리한 set/lookup/erase 인터페이스를 제공해야 합니다.

창고 담당자가 하루 종일 입고와 출고에 맞춰 수량을 최신 상태로 유지할 수 있도록 `ChainedMap` 클래스를 구현하세요.

- `ChainedMap()` — SKU 항목이 하나도 없는 빈 카탈로그를 만듭니다.
- `void set(int key, int value)` — SKU `key`의 현재 수량이 `value`임을 기록합니다. 해당 SKU가 이미 추적되고 있다면 기존 수량을 새 값으로 덮어씁니다.
- `int lookup(int key)` — SKU `key`에 현재 바인딩된 수량을 반환하며, 해당 SKU가 카탈로그에 없으면 `-1`을 반환합니다.
- `void erase(int key)` — SKU `key`를 카탈로그에서 완전히 제거합니다. 해당 SKU가 없으면 아무 동작도 하지 않고 조용히 통과합니다.

**예시 1:**
```
Input: ["ChainedMap","set","set","lookup","lookup","set","lookup","erase","lookup"] / [[],[1,10],[2,20],[1],[3],[2,30],[2],[2],[2]]
Output: [null,null,null,10,-1,null,30,null,-1]
```
`(1,10)`과 `(2,20)`을 기록한 뒤, SKU 1을 조회하면 해당 수량이 나오고 SKU 3을 조회하면 값이 없음을 의미하는 센티넬 `-1`이 반환됩니다. SKU 2의 수량을 30으로 덮어쓰면 다음 조회에 반영되며, SKU 2를 제거한 뒤 다시 조회하면 `-1`이 돌아옵니다.

**예시 2:**
```
Input: ["ChainedMap","set","set","set","lookup","lookup","lookup"] / [[],[5,50],[10,100],[15,150],[5],[10],[15]]
Output: [null,null,null,null,50,100,150]
```
서로 독립된 세 SKU가 기록되고 각각의 수량이 정확히 조회됩니다.

**예시 3:**
```
Input: ["ChainedMap","lookup","erase","lookup"] / [[],[7],[7],[7]]
Output: [null,-1,null,-1]
```
한 번도 등록된 적 없는 SKU에 대한 조회와 삭제는 부작용 없이 처리됩니다.$$,
    $$- `0 <= key, value <= 800000`
- `set`, `lookup`, `erase`를 통틀어 최대 `8000`회의 호출이 발생합니다.$$
);

-- kth-largest-stream
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'kth-largest-stream'),
    'ko',
    $$K번째 최대 실시간 값$$,
    $$옥상 기상 연구소에서는 센서 뱅크로부터 정수 측정값들이 모니터링 서비스로 끊임없이 전달됩니다. 분석가들은 스트림이 늘어나는 동안 `k`번째로 큰 측정값을 지켜보고 싶어 합니다. 여기서 말하는 것은 `k`번째 *서로 다른* 값이 아니라 전체 정렬된 순서에서 `k`번째에 해당하는 값이므로, 중복된 값도 각자의 순위를 유지합니다.

새로운 샘플이 들어올 때마다 이 실시간 질문에 효율적으로 답할 수 있도록 `TopKStream` 클래스를 구현하세요.

- `TopKStream(int k, int[] nums)` — 순위 매개변수 `k`와 센서에서 이미 수집된 초기 측정값 배치 `nums`로 추적기를 초기화합니다.
- `int record(int val)` — `val`을 스트림에 추가하고, 지금까지 수집된 전체 측정값을 기준으로 현재 `k`번째 최대 측정값을 반환합니다.

**예시 1:**
```
Input:
["TopKStream", "record", "record", "record", "record", "record"]
[[3, [4, 5, 8, 2]], [3], [5], [10], [9], [4]]
Output: [null, 4, 5, 5, 8, 8]

Explanation:
TopKStream tracker = new TopKStream(3, [4, 5, 8, 2]);
tracker.record(3);   // stream becomes [4,5,8,2,3]; 3rd largest is 4
tracker.record(5);   // stream becomes [4,5,8,2,3,5]; 3rd largest is 5
tracker.record(10);  // stream becomes [4,5,8,2,3,5,10]; 3rd largest is 5
tracker.record(9);   // stream becomes [4,5,8,2,3,5,10,9]; 3rd largest is 8
tracker.record(4);   // stream becomes [4,5,8,2,3,5,10,9,4]; 3rd largest is 8
```

추적기는 근무 시간 내내 반응성을 유지해야 합니다. 샘플마다 전체를 다시 정렬하는 단순한 방식으로는 금세 피드를 따라잡지 못합니다.$$,
    $$- `1 <= k <= 8000`
- `0 <= nums.length <= 8000`
- `-10^8 <= nums[i] <= 10^8`
- `-10^8 <= val <= 10^8`
- `record`는 최대 `8000`회까지 호출됩니다.
- `record`가 호출되는 시점에 합쳐진 스트림에는 최소 `k`개 이상의 측정값이 포함되어 있음이 보장됩니다.$$
);

-- minimum-stack
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'minimum-stack'),
    'ko',
    $$최솟값 추적 스택$$,
    $$운영팀은 프로덕션 트레이서에서 보내오는 서비스 지연 샘플을 실시간 로그에 쌓아두고 있습니다. 조사자들은 이 로그를 스택처럼 다룹니다. 측정값이 도착하면 뒤에 덧붙이고, 롤백 시에는 끝에서부터 팝(pop)해 나갑니다. 그리고 사이드카 대시보드는 현재 로그에 남아 있는 **최저** 지연 값을 매 순간 보여줘야 합니다. 트레이서가 지연되지 않도록 최저값 쿼리를 포함한 로그의 모든 연산은 상수 시간에 끝나야 합니다.

정확히 다음 인터페이스를 갖는 `LowTrackStack` 클래스를 구현하세요.

- `LowTrackStack()` — 샘플이 하나도 없는 빈 로그를 생성합니다.
- `void push(int val)` — 지연 측정값 `val`을 로그의 맨 위에 추가합니다.
- `void pop()` — 현재 로그의 맨 위에 있는 측정값을 제거합니다.
- `int top()` — 맨 위 측정값을 제거하지 않고 반환합니다.
- `int getMin()` — 현재 로그 전체에서 가장 작은 측정값을 반환합니다.

`push`, `pop`, `top`, `getMin` 모두 `O(1)` 시간에 수행되어야 대시보드가 실시간 트레이서를 따라갈 수 있습니다.

**예시 1:**
```
Input:
["LowTrackStack","push","push","push","getMin","pop","top","getMin"]
[[],[12],[6],[-2],[],[],[],[]]
Output: [null,null,null,null,-2,null,6,6]
```
세 개의 지연 샘플(12, 6, -2)이 순서대로 추가됩니다. `getMin`은 현재 로그에서 가장 작은 `-2`를 반환합니다. 맨 위 샘플을 팝하면 로그에는 `[12, 6]`이 남고, `top`은 `6`을, `getMin`도 `6`을 반환합니다. 이전 최솟값이 이미 제거되었기 때문입니다.

사이드카는 최소 한 번의 push가 이루어진 뒤에만 `pop`, `top`, `getMin`을 호출한다는 전제에 의존하므로, 이 세 연산에서는 로그가 비어있지 않다고 가정해도 됩니다.$$,
    $$- `-10^8 <= val <= 10^8`
- `pop`, `top`, `getMin`은 최소 한 개의 원소가 push된 뒤에만 호출됩니다.
- `push`, `pop`, `top`, `getMin`을 통틀어 최대 `20000`회의 호출이 발생합니다.$$
);

-- prefix-tree
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'prefix-tree'),
    'ko',
    $$접두사 인덱스$$,
    $$방대한 디렉터리 카탈로그를 색인하는 파일시스템 인덱서는 두 가지 질문에 빠르게 답할 수 있는 작은 자료구조가 필요합니다. "이 파일 이름을 정확히 본 적이 있는가?"와 "이 접두사로 시작하는 항목이 카탈로그에 존재하는가?"입니다. 이런 용도에는 글자 단위로 공유되는 트리가 잘 맞습니다. 각 글자마다 노드 하나씩만 따라가면 되므로 두 쿼리의 비용이 카탈로그 크기가 아니라 쿼리 길이에만 비례합니다.

인덱서가 파일 이름을 스트리밍 입력으로 받아들이고, 하류 도구들이 전체 이름이나 접두사로 탐색할 수 있도록 `PrefixIndex` 클래스를 구현하세요.

- `PrefixIndex()` — 아직 아무 이름도 등록되지 않은 빈 인덱스를 만듭니다.
- `void insert(String word)` — 문자열 `word`를 완전한 색인 파일 이름으로 기록합니다. 이미 존재하는 이름을 다시 삽입해도 부작용은 없습니다.
- `boolean search(String word)` — `word`가 이전에 완전한 이름으로 삽입된 적이 있으면 `true`, 그렇지 않으면 `false`를 반환합니다. 삽입된 어떤 이름의 앞 부분 글자들과 우연히 일치할 뿐, 자체적으로 전체 이름으로 삽입된 적이 없는 접두사는 반드시 `false`를 반환해야 합니다.
- `boolean startsWith(String prefix)` — 이전에 삽입된 이름 중 `prefix`로 시작하는 것이 하나라도 있으면 `true`, 그렇지 않으면 `false`를 반환합니다.

**예시 1:**
```
Input:
["PrefixIndex", "insert", "search", "search", "startsWith", "insert", "search"]
[[], ["apple"], ["apple"], ["app"], ["app"], ["app"], ["app"]]
Output: [null, null, true, false, true, null, true]
```

`"apple"`을 삽입한 뒤 `search("apple")`은 해당 이름이 등록되어 있으므로 `true`입니다. `search("app")`은 `"app"`이 *접두사로만* 등장했을 뿐 독립된 이름으로 삽입된 적이 없으므로 `false`입니다. `startsWith("app")`은 `"apple"`이 그 세 글자로 시작하므로 `true`입니다. 이후 `"app"`이 정식으로 삽입되면 뒤따르는 `search("app")`은 `true`로 바뀝니다.$$,
    $$- `1 <= word.length, prefix.length <= 2000`
- `word`와 `prefix`는 영어 소문자로만 이루어져 있습니다.
- `insert`, `search`, `startsWith`를 통틀어 최대 `20000`회의 호출이 발생합니다.$$
);

-- random-set
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'random-set'),
    'ko',
    $$무작위 추첨 가방$$,
    $$래플 데스크는 추첨 자격이 있는 티켓 번호의 실시간 풀을 관리하며, 어느 시점에서든 그 중 하나를 균등하게 뽑아낼 수 있어야 합니다. 각 티켓 번호는 서로 다른 정수이며, 신청이 들어오거나 자격이 박탈되면서 풀의 크기는 커지거나 줄어듭니다. 매번 뽑을 때마다 현재 자격이 있는 모든 티켓은 동일한 확률로 뽑혀야 하고, 티켓이 아무리 많아져도 추가/제거/추첨의 기록 관리는 평균적으로 상수 시간에 유지되어야 합니다.

`RandomBag` 클래스를 구현하세요.

- `RandomBag()`은 자격 있는 티켓이 하나도 없는 빈 풀을 구성합니다.
- `boolean insert(int val)`은 티켓 번호 `val`을 자격이 있는 것으로 등록합니다. 새로 추가되었으면 `true`, 이미 풀에 있었다면 `false`를 반환합니다.
- `boolean remove(int val)`은 티켓 번호 `val`의 자격을 박탈합니다. 풀에 존재해서 제거된 경우 `true`, 존재하지 않은 경우 `false`를 반환합니다.
- `int drawRandom()`은 현재 풀에서 균등 확률로 티켓 번호 하나를 선택해 반환합니다. 자격 있는 모든 티켓은 뽑힐 확률이 동일해야 합니다. 이 메서드는 풀에 티켓이 최소 한 장 이상 있을 때만 호출됩니다.

**예시:**
```
Calls:  ["RandomBag","insert","insert","remove","drawRandom"]
Args:   [[],[1],[2],[1],[]]
Result: [null,true,true,true,2]
```
티켓 `1`과 티켓 `2`가 풀에 들어오고, 그 뒤 티켓 `1`이 자격을 잃습니다. 남아있는 자격 티켓은 `2`뿐이므로 추첨 결과는 반드시 `2`가 됩니다.$$,
    $$- `-10^8 <= val <= 10^8`
- `insert`, `remove`, `drawRandom`을 통틀어 최대 `2 * 10^5`회의 호출이 발생합니다.
- `drawRandom`이 호출되는 시점에 풀은 비어있지 않음이 보장됩니다.$$
);

-- recent-cache
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'recent-cache'),
    'ko',
    $$최근 사용 레지스트리$$,
    $$엣지 노드는 최근 참조된 레코드를 담는 용량 제한 레지스트리를 운영합니다. 각 레코드는 숫자 키로 식별되며 숫자 값을 함께 가집니다(재계산 비용이 비싼 응답이라고 생각하면 됩니다). 레지스트리가 가득 찬 상태에서 새로운 키가 들어오면, 가장 오래 건드려지지 않은 레코드를 밀어내 자리를 마련해야 합니다. 키에 대한 모든 접근은 — 새 쓰기든 성공적인 읽기든 — 해당 키를 "건드린 것"으로 간주되어 가장 최근에 사용된 항목으로 승격됩니다.

`RecentRegistry` 클래스를 구현하세요.

- `RecentRegistry(int capacity)`는 한 번에 최대 `capacity`개의 항목을 보관할 수 있는 빈 레지스트리를 만듭니다.
- `int lookup(int key)`는 현재 `key`에 바인딩된 값을 반환하며, 바인딩이 없으면 `-1`을 반환합니다. 성공적인 조회는 `key`를 가장 최근에 사용된 항목으로 승격시킵니다.
- `void store(int key, int value)`는 `key`를 `value`에 바인딩합니다. `key`가 이미 존재하면 값을 덮어쓰고 가장 최근에 사용된 항목으로 승격시킵니다. `key`가 새로 들어오는데 레지스트리가 이미 가득 차 있다면, 가장 오래 사용되지 않은 바인딩을 축출한 뒤 새 항목을 기록합니다.

`lookup`과 `store` 모두 평균 `O(1)` 시간에 수행되어야 합니다.

**예시:**
```
registry = new RecentRegistry(2)
registry.store(1, 10)   // {1=10}
registry.store(2, 20)   // {1=10, 2=20}
registry.lookup(1)      // returns 10; 1 is now most recent
registry.store(3, 30)   // evicts key 2 -> {1=10, 3=30}
registry.lookup(2)      // returns -1
```$$,
    $$- `1 <= capacity <= 3000`
- `0 <= key <= 8000`
- `0 <= value <= 80000`
- `lookup`과 `store`를 통틀어 최대 `2 * 10^5`회의 호출이 발생합니다.$$
);

-- ring-buffer
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'ring-buffer'),
    'ko',
    $$고정 길이 링 버퍼$$,
    $$스트리밍 파이프라인이 원형으로 배치된 고정 크기 슬롯 블록을 재사용합니다. 데이터는 한쪽 끝으로 들어와 반대쪽 끝으로 빠져나가며, 쓰기 헤드가 블록의 끝에 도달하면 다시 시작 위치로 돌아오므로 저장 공간은 시작 시 정해진 용량을 절대 초과하지 않습니다. 파이프라인은 모든 슬롯이 차 있을 때의 쓰기를 거부하고, 버퍼가 비어 있을 때의 비우기를 무시하며, 앞뒤 값과 빈/가득 참 여부를 언제든 저렴한 비용으로 보고할 수 있어야 합니다.

`FixedRing` 클래스를 구현하세요:

- `FixedRing(int k)` 최대 `k`개의 값을 담을 수 있는 빈 링을 준비합니다.
- `boolean push(int value)` 쓰기 헤드(뒤쪽)에 `value`를 추가합니다. 성공하면 `true`, 링이 이미 가득 차 있으면 `false`를 반환합니다.
- `boolean pull()` 읽기 헤드(앞쪽)에 있는 값을 제거합니다. 성공하면 `true`, 링이 비어 있으면 `false`를 반환합니다.
- `int front()` 앞쪽 값을 제거하지 않고 반환합니다. 링이 비어 있으면 `-1`을 반환합니다.
- `int rear()` 뒤쪽 값을 제거하지 않고 반환합니다. 링이 비어 있으면 `-1`을 반환합니다.
- `boolean isEmpty()` 버퍼에 아무 값도 없을 때만 정확히 `true`를 반환합니다.
- `boolean isFull()` `k`개의 슬롯이 모두 채워져 있을 때만 정확히 `true`를 반환합니다.

**예시:**
```
ring = new FixedRing(3)
ring.push(1); ring.push(2); ring.push(3)   // all succeed
ring.push(4)                               // false, ring full
ring.rear()                                // 3
ring.pull()                                // true, drops 1
ring.push(4)                               // true, wraps around
ring.rear()                                // 4
```$$,
    $$- `1 <= k <= 1000`
- `0 <= value <= 1000`
- `push`, `pull`, `front`, `rear`, `isEmpty`, `isFull` 호출은 합쳐서 최대 `3000`회$$
);

-- running-median
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'running-median'),
    'ko',
    $$실시간 미디안 트래커$$,
    $$메트릭 수집기가 실시간 서비스에서 정수 샘플 스트림을 받아들이며, 어느 시점에서든 지금까지 관측한 모든 샘플의 미디안을 즉시 보고할 수 있어야 합니다. 샘플은 한 번에 하나씩 도착하며 제거되지 않습니다. 짝수 개의 샘플이 관측되었을 때 미디안은 가운데 두 값의 산술 평균으로 정의되어 부동소수점 값으로 반환되며, 홀수 개일 때는 가운데 값 자체가 (역시 부동소수점으로) 반환됩니다. 읽기와 쓰기가 자유롭게 섞여서 호출되므로, 아주 긴 세션에서도 두 연산 모두 저렴하게 동작해야 합니다.

`StreamMedian` 클래스를 구현하세요:

- `StreamMedian()` 아직 어떤 샘플도 보지 못한 빈 수집기를 초기화합니다.
- `void record(int num)` 샘플 `num`을 현재 수집 집합에 반영합니다.
- `double median()` 지금까지 반영된 모든 샘플의 미디안을 반환합니다. 이 메서드는 최소 한 번 이상 `record`가 호출된 뒤에만 호출됩니다.

**예시:**
```
collector = new StreamMedian()
collector.record(1)
collector.median()    // 1.0
collector.record(2)
collector.median()    // (1 + 2) / 2 = 1.5
collector.record(3)
collector.median()    // middle of [1, 2, 3] = 2.0
```$$,
    $$- `-80000 <= num <= 80000`
- `record`와 `median` 호출은 합쳐서 최대 `40000`회
- `median`은 첫 번째 `record` 이전에는 호출되지 않습니다$$
);

-- stack-queue
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'stack-queue'),
    'ko',
    $$스택으로 만든 큐$$,
    $$처리 파이프라인이 도착 순서(선입선출)대로 엄격히 처리해야 하는 작업들을 받지만, 이 환경에서 사용할 수 있는 기본 저장 자료구조는 후입선출 스택뿐입니다. 여러분의 과제는 내부적으로 정확히 두 개의 스택만 백업 저장소로 쓰면서 FIFO 인터페이스를 노출하는 것입니다. 배열, 리스트, 덱, 그 밖의 어떤 컨테이너도 허용되지 않습니다. 두 내부 스택에 대해서는 표준 스택 연산(상단에 push, 상단에서 pop, 상단 peek, 비어 있는지 검사)만 사용할 수 있습니다.

`QueueFromStacks` 클래스를 구현하세요:

- `QueueFromStacks()` 빈 파이프라인을 초기화합니다.
- `void push(int x)` 파이프라인의 뒤쪽에 작업 `x`를 추가합니다.
- `int pop()` 파이프라인 앞쪽의 작업을 제거하고 반환합니다.
- `int peek()` 파이프라인 앞쪽의 작업을 제거하지 않고 반환합니다.
- `boolean empty()` 대기 중인 작업이 없으면 `true`, 그렇지 않으면 `false`를 반환합니다.

호출 측은 비어 있는 파이프라인에 대해서는 `pop`과 `peek`을 절대 호출하지 않음을 보장합니다.

**예시:**
```
q = new QueueFromStacks()
q.push(1)
q.push(2)
q.peek()   // 1  -- front of the pipeline
q.pop()    // 1  -- front is dequeued
q.empty()  // false -- 2 still queued
```$$,
    $$- `1 <= x <= 9`
- `push`, `pop`, `peek`, `empty` 호출은 합쳐서 최대 `100`회
- `pop`과 `peek`은 파이프라인이 비어 있지 않을 때만 호출됩니다$$
);

-- state-snapshots
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'state-snapshots'),
    'ko',
    $$버전 관리되는 셀 배열$$,
    $$구성 관리 서비스가 운영자가 값을 덮어쓰는 고정 길이의 숫자 셀 행을 관리하며, 주기적으로 현재 행을 감사용 불변 스냅샷으로 고정합니다. 모든 스냅샷은 `0`부터 시작해 차례대로 다음 번호를 부여받으며, 이후 읽기 요청은 그 스냅샷이 찍히던 순간 특정 셀이 어떤 값을 가지고 있었는지를 정확히 복원할 수 있어야 합니다 — 그 뒤로 아무리 많은 편집이 있었더라도 말이죠. 서비스 생성 시 모든 셀은 `0`으로 시작합니다.

`VersionedCells` 클래스를 구현하세요:

- `VersionedCells(int length)` 모두 `0`으로 초기화된 `length`개의 셀로 이루어진 행을 만듭니다. 아직 스냅샷은 없습니다.
- `void set(int index, int val)` 현재 행의 `index` 위치 값을 `val`로 덮어씁니다. 이 변경은 현재(라이브) 행에만 영향을 주며, 이미 커밋된 스냅샷은 그대로입니다.
- `int commit()` 현재 라이브 행을 새 스냅샷으로 고정하고 그 id를 반환합니다. 첫 호출은 `0`, 다음은 `1`, 이런 식으로 이어집니다.
- `int readAt(int index, int snapId)` `snapId`로 식별되는 스냅샷에서 `index` 셀이 가지고 있던 값을 반환합니다.

**예시:**
```
cells = new VersionedCells(3)
cells.set(0, 5)
cells.commit()        // returns 0; snapshot 0 is [5, 0, 0]
cells.set(0, 6)       // live row is now [6, 0, 0]
cells.readAt(0, 0)    // 5 -- value of cell 0 in snapshot 0
```$$,
    $$- `1 <= length <= 50000`
- `0 <= index < length`
- `0 <= val <= 10^8`
- `0 <= snapId`이며 `snapId`는 지금까지 호출된 `commit` 횟수보다 반드시 작습니다
- `set`, `commit`, `readAt` 호출은 합쳐서 최대 `50000`회$$
);

-- string-codec
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'string-codec'),
    'ko',
    $$문자열 리스트 코덱$$,
    $$두 서비스 사이에 메시지 프레이밍 계층이 자리하고 있는데, 이 두 서비스는 소켓을 통해 오직 하나의 원시 문자열만 주고받을 수 있습니다. 송신 측은 임의의 문자열 조각들로 이루어진 리스트를 수신 측에 전달해야 하고, 수신 측은 그 리스트를 바이트 단위로 동일하게 복원해야 합니다. 여러분이 할 일은 양쪽 끝에 공통으로 들어가는 프레이밍 코덱을 만드는 것입니다.

두 개의 메서드를 가진 `ListCoder` 클래스를 구현하세요:

- `String pack(List<String> strs)` — 조각들의 리스트를 받아, 나중에 리스트를 복원할 수 있을 만큼의 구조 정보를 담은 하나의 프레이밍된 문자열을 반환합니다. 조각은 여러분이 선택한 구분자나 이스케이프 문자를 포함해 *어떤* 바이트 패턴이든 담을 수 있으므로, 예약된 문자로 단순히 이어 붙이는 방식은 통하지 않습니다.
- `List<String> unpack(String s)` — 이전에 `pack`이 만들어 낸 프레이밍된 문자열을 받아, 원래 리스트를 순서, 길이, 내용 모두 그대로 복원해 반환합니다. 빈 조각도 빠짐없이 보존해야 합니다.

이 코덱은 반드시 **무상태(stateless)** 여야 합니다. `unpack`이 필요로 하는 모든 정보는 `pack`이 만들어 낸 문자열 안에만 존재해야 하며, 공유 카운터나 외부 메타데이터, 호출 간에 유지되는 인스턴스 필드 같은 것에 의존해서는 안 됩니다. 리스트가 비어 있거나, `hello`나 `world` 같은 빈 조각들만 담고 있거나, 프레이밍 마커처럼 보이는 문자들로만 이루어진 조각을 포함하더라도, `pack` → `unpack`을 거친 왕복은 입력 리스트를 정확히 재현해야 합니다.$$,
    $$- `0 <= strs.length <= 200`
- `0 <= strs[i].length <= 200`
- 각 `strs[i]`는 코덱이 구분자나 이스케이프로 사용하는 문자를 포함해 어떤 유니코드 코드 포인트든 담을 수 있습니다.$$
);

-- time-map
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'time-map'),
    'ko',
    $$타임스탬프 값 저장소$$,
    $$메트릭 플랫폼이 장비 계측으로부터 이름이 붙은 신호를 받아들입니다. 각 신호는 문자열 `key`(예: 장치 식별자나 메트릭 이름)로 구분되며, 장치가 보고할 때마다 해당 키에 대해 새로운 `value`가 기록됩니다. 같은 키에 대한 보고는 타임스탬프가 엄격하게 증가하는 순서로 도착합니다. 나중에 분석가들은 특정 키와 타임스탬프 `t`에 대해 "이 신호는 `t` 시점 기준으로 어떤 값이었나?"라고 묻는데, 이는 `t`보다 미래가 아닌 타임스탬프 중 가장 최근에 기록된 값을 의미합니다.

이 작업을 뒷받침하는 `TimestampedStore` 클래스를 만드세요:

- `TimestampedStore()` — 어떤 신호도 담고 있지 않은 빈 저장소를 생성합니다.
- `void write(String key, String value, int timestamp)` — 주어진 `timestamp`에 신호 `key`의 측정값 `value`를 추가합니다. 같은 키에 대해 연속된 `write` 호출은 해당 키의 이전 타임스탬프들보다 엄격하게 큰 타임스탬프를 사용합니다.
- `String readAt(String key, int timestamp)` — `key`에 대해 `timestamp` 이하의 타임스탬프로 가장 최근에 쓰인 `value`를 반환합니다. `timestamp` 이하에 해당 키에 대한 기록이 없다면(해당 키가 한 번도 쓰이지 않은 경우 포함) 빈 문자열 `""`를 반환합니다.

쿼리는 기록된 두 타임스탬프 사이의 시점을 물어볼 수도 있습니다. 그 경우에는 그보다 앞선 가장 최근 쓰기 시점의 값이 유효했던 값이므로 `readAt`은 그 값을 반환합니다. 쿼리는 가장 최근 쓰기보다 더 뒤의 타임스탬프에 대해서도 도착할 수 있으며, 이때는 그 가장 최근 값을 드러내야 합니다.$$,
    $$- `1 <= key.length, value.length <= 100`
- `1 <= timestamp <= 10^7`
- `write`에 전달되는 타임스탬프는 각 `key`마다 엄격하게 증가합니다.
- `write`와 `readAt` 호출의 총합은 최대 `2 * 10^5`입니다.$$
);

-- tree-codec
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'tree-codec'),
    'ko',
    $$이진 트리 직렬화기$$,
    $$계층적 문서 워크플로는 이진 트리 형태의 아티팩트(각 노드가 선택적인 왼쪽/오른쪽 자식과 정수 라벨을 가지는 콘텐츠 개요라고 생각하면 됩니다)를 문자열만 주고받을 수 있는 서비스들 사이에서 전달해야 합니다. 여러분의 과제는 그 와이어 포맷의 양쪽을 작성하는 것입니다. 한쪽은 실제 트리를 하나의 문자열로 평탄화하고, 다른 쪽은 그 문자열로부터 동일한 트리를 재구성합니다.

두 개의 메서드를 가진 `TreeSerializer` 클래스를 구현하세요:

- `String pack(TreeNode root)` — `root`를 루트로 하는 트리를 순회하여, 모든 노드의 정수 값과 부모/자식 관계를 모두 담은 하나의 문자열을 생성합니다. `root`는 `null`일 수도 있으며, 그 경우에도 `pack`은 "빈 트리"를 나타내는 잘 정의된 문자열을 반환해야 합니다.
- `TreeNode unpack(String data)` — 이전에 `pack`이 만든 문자열을 받아 원본과 구조적으로 동일한 트리를 재구성합니다. 즉, 모든 노드가 같은 값과 같은 왼쪽 자식, 같은 오른쪽 자식을 가져야 합니다. `data`가 빈 트리를 나타낼 때 `unpack`은 `null`을 반환합니다.

구체적인 텍스트 포맷은 여러분이 자유롭게 고를 수 있습니다. 다만 왕복 보장은 고정되어 있습니다. 유효한 입력 트리 `t`에 대해 `unpack(pack(t))`은 `t`와 구별 불가능한 트리를 반환해야 합니다. 이 보장은 자식이 왼쪽에만 달린 한쪽으로 치우친 트리, 노드가 하나뿐인 트리, 그리고 빈 트리에 대해서도 성립해야 합니다.

문자열 밖의 어떤 상태에도 의존할 수 없습니다 — 직렬화기와 역직렬화기는 무상태여야 하며, 두 개의 서로 다른 프로세스가 오직 `pack`/`unpack`만으로 트리를 교환할 수 있어야 합니다.$$,
    $$- 트리의 노드 수는 `[0, 10000]` 범위입니다.
- `-1000 <= Node.val <= 1000`$$
);

-- word-dictionary
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'word-dictionary'),
    'ko',
    $$와일드카드 단어 사전$$,
    $$맞춤법 검사 서브시스템이 알려진 소문자 단어들의 사전을 점점 늘려가며 유지합니다. 작성자는 언제든 새 단어를 등록할 수 있고, 검토자는 간단한 패턴 언어로 사전에 질의합니다. 정확한 글자는 그 글자에 그대로 대응해야 하고, `.`은 임의의 단일 글자와 매칭됩니다. 저장된 단어들 중 최소 하나가 패턴과 같은 길이에서 위 규칙에 따라 글자별로 매칭되면 그 패턴은 만족된 것입니다.

`WildcardLexicon` 클래스를 구현하세요:

- `WildcardLexicon()` — 등록된 단어가 없는 상태로 사전을 초기화합니다.
- `void enroll(String word)` — `word`를 사전에 추가합니다. `word`는 소문자 영어 알파벳으로만 이루어져 있습니다. 같은 단어를 중복으로 등록해도 무해하며, 단어는 사전에 그대로 남아 있을 뿐입니다.
- `boolean match(String word)` — 등록된 단어 중 `word`와 길이가 같고 `word`의 모든 `.`을 단일 글자 와일드카드로 취급했을 때 자리별로 매칭되는 단어가 존재하면 `true`를 반환합니다. 그런 단어가 없다면 — 사전이 비어 있거나 모든 등록 단어가 `word`와 길이가 다른 경우를 포함해 — `false`를 반환합니다.

쿼리의 `word`는 소문자 알파벳과 와일드카드 문자 `.`만 포함합니다. 와일드카드가 아닌 문자는 대응되는 자리와 정확히 일치해야 하고, `.`은 임의의 소문자 하나를 대신할 수 있지만 여전히 저장된 단어의 한 글자를 정확히 소비합니다. 쿼리는 사전을 변경하지 않고 조회만 하며, 등록과 쿼리는 임의 순서로 섞여 호출될 수 있습니다.$$,
    $$- `1 <= word.length <= 25`
- `enroll`의 `word`는 소문자 영어 알파벳으로만 이루어집니다.
- `match`의 `word`는 소문자 영어 알파벳과/또는 와일드카드 문자 `.`로 이루어집니다.
- `enroll`과 `match` 호출은 합쳐서 최대 `8000`회입니다.$$
);
