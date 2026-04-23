-- V134: Clean up slugs and titles so they match each problem's rethemed
-- casual scenario. Both English titles (on `problems.title`) and Korean titles
-- (on `problem_translations.title` for locale='ko') are refreshed. Slugs are
-- renamed in the same pass — descriptions and constraints were already
-- rewritten in V133, so only the surface labels change here.

-- Starter directories under backend/src/main/resources/starters/<slug>/ and
-- driver directories under common/src/main/resources/drivers/<slug>/ are
-- renamed in the same commit to match the new slugs.

-- active-sensor-mask -> online-friend-mask
UPDATE problems SET
    slug = $$online-friend-mask$$,
    title = $$Online Friend Count$$
WHERE slug = $$active-sensor-mask$$;

UPDATE problem_translations SET
    title = $KO$온라인 친구 수 세기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$online-friend-mask$$);

-- alternate-ward-sweep -> zigzag-yearbook-order
UPDATE problems SET
    slug = $$zigzag-yearbook-order$$,
    title = $$Zigzag Yearbook Order$$
WHERE slug = $$alternate-ward-sweep$$;

UPDATE problem_translations SET
    title = $KO$지그재그로 줄 서기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$zigzag-yearbook-order$$);

-- assemble-script-breakdown -> rebuild-boss-tree
UPDATE problems SET
    slug = $$rebuild-boss-tree$$,
    title = $$Rebuild Boss Tree$$
WHERE slug = $$assemble-script-breakdown$$;

UPDATE problem_translations SET
    title = $KO$보스전 트리 복원$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$rebuild-boss-tree$$);

-- balance-print-jobs -> balance-print-queue
UPDATE problems SET
    slug = $$balance-print-queue$$,
    title = $$Balance the Print Queue$$
WHERE slug = $$balance-print-jobs$$;

UPDATE problem_translations SET
    title = $KO$인쇄 작업 균형 맞추기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$balance-print-queue$$);

-- batch-quota-combos -> menu-combos-tab
UPDATE problems SET
    slug = $$menu-combos-tab$$,
    title = $$Menu Combos For The Tab$$
WHERE slug = $$batch-quota-combos$$;

UPDATE problem_translations SET
    title = $KO$계산서에 딱 맞는 메뉴 조합$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$menu-combos-tab$$);

-- best-bake-order -> best-balloon-pop-order
UPDATE problems SET
    slug = $$best-balloon-pop-order$$,
    title = $$Best Balloon Pop Order$$
WHERE slug = $$best-bake-order$$;

UPDATE problem_translations SET
    title = $KO$최고의 풍선 터뜨리기 순서$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$best-balloon-pop-order$$);

-- best-flow-streak -> best-boba-streak
UPDATE problems SET
    slug = $$best-boba-streak$$,
    title = $$Best Boba Streak$$
WHERE slug = $$best-flow-streak$$;

UPDATE problem_translations SET
    title = $KO$최고의 손님 흐름 구간$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$best-boba-streak$$);

-- best-scene-branch -> best-skill-tree-path
UPDATE problems SET
    slug = $$best-skill-tree-path$$,
    title = $$Best Skill Tree Path$$
WHERE slug = $$best-scene-branch$$;

UPDATE problem_translations SET
    title = $KO$최고의 스킬 트리 가지$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$best-skill-tree-path$$);

-- best-tier-resale -> best-skin-flip-day
UPDATE problems SET
    slug = $$best-skin-flip-day$$,
    title = $$Best Skin Flip Day$$
WHERE slug = $$best-tier-resale$$;

UPDATE problem_translations SET
    title = $KO$최고의 스킨 되팔이 날$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$best-skin-flip-day$$);

-- biggest-clear-bay -> biggest-clear-floor
UPDATE problems SET
    slug = $$biggest-clear-floor$$,
    title = $$Biggest Clear Floor$$
WHERE slug = $$biggest-clear-bay$$;

UPDATE problem_translations SET
    title = $KO$가장 큰 빈 교실 바닥$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$biggest-clear-floor$$);

-- bridge-label-chain -> spawn-code-ladder
UPDATE problems SET
    slug = $$spawn-code-ladder$$,
    title = $$Spawn Code Ladder$$
WHERE slug = $$bridge-label-chain$$;

UPDATE problem_translations SET
    title = $KO$스폰 코드 한 글자씩$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$spawn-code-ladder$$);

-- brightest-observed-targets -> top-raid-score
UPDATE problems SET
    slug = $$top-raid-score$$,
    title = $$Top Raid Score$$
WHERE slug = $$brightest-observed-targets$$;

UPDATE problem_translations SET
    title = $KO$상위 점수 조회$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$top-raid-score$$);

-- build-mirror-length -> longest-doodle-palindrome
UPDATE problems SET
    slug = $$longest-doodle-palindrome$$,
    title = $$Longest Doodle Palindrome$$
WHERE slug = $$build-mirror-length$$;

UPDATE problem_translations SET
    title = $KO$거울처럼 읽히는 구간 길이$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-doodle-palindrome$$);

-- bump-parcel-code -> bump-takeout-number
UPDATE problems SET
    slug = $$bump-takeout-number$$,
    title = $$Bump Takeout Number$$
WHERE slug = $$bump-parcel-code$$;

UPDATE problem_translations SET
    title = $KO$포장 번호 하나 올리기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$bump-takeout-number$$);

-- busiest-machines-list -> top-espresso-machines
UPDATE problems SET
    slug = $$top-espresso-machines$$,
    title = $$Top Espresso Machines$$
WHERE slug = $$busiest-machines-list$$;

UPDATE problem_translations SET
    title = $KO$가장 바빴던 머신 목록$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$top-espresso-machines$$);

-- calm-sensor-reading -> calm-phone-number
UPDATE problems SET
    slug = $$calm-phone-number$$,
    title = $$Calm Phone Number$$
WHERE slug = $$calm-sensor-reading$$;

UPDATE problem_translations SET
    title = $KO$평온한 전화번호$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$calm-phone-number$$);

-- carrier-street-sweep -> dog-street-walk
UPDATE problems SET
    slug = $$dog-street-walk$$,
    title = $$Dog Street Walk$$
WHERE slug = $$carrier-street-sweep$$;

UPDATE problem_translations SET
    title = $KO$동네 길 한 번씩 돌기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$dog-street-walk$$);

-- chart-block-route -> shortest-dungeon-path
UPDATE problems SET
    slug = $$shortest-dungeon-path$$,
    title = $$Shortest Dungeon Path$$
WHERE slug = $$chart-block-route$$;

UPDATE problem_translations SET
    title = $KO$최단 던전 경로$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$shortest-dungeon-path$$);

-- check-key-reachability -> open-all-rooms
UPDATE problems SET
    slug = $$open-all-rooms$$,
    title = $$Open All Rooms$$
WHERE slug = $$check-key-reachability$$;

UPDATE problem_translations SET
    title = $KO$모든 방 열 수 있는지$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$open-all-rooms$$);

-- check-merged-queue -> check-interleaved-inputs
UPDATE problems SET
    slug = $$check-interleaved-inputs$$,
    title = $$Check Interleaved Inputs$$
WHERE slug = $$check-merged-queue$$;

UPDATE problem_translations SET
    title = $KO$입력 합쳐쓰기 검사$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$check-interleaved-inputs$$);

-- choose-start-station -> pick-charging-start
UPDATE problems SET
    slug = $$pick-charging-start$$,
    title = $$Pick Charging Start$$
WHERE slug = $$choose-start-station$$;

UPDATE problem_translations SET
    title = $KO$출발 충전소 고르기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$pick-charging-start$$);

-- clear-defect-rows -> zero-out-rows-cols
UPDATE problems SET
    slug = $$zero-out-rows-cols$$,
    title = $$Zero Out Rows and Cols$$
WHERE slug = $$clear-defect-rows$$;

UPDATE problem_translations SET
    title = $KO$불량 줄 싹 지우기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$zero-out-rows-cols$$);

-- click-counter -> click-tally-window
UPDATE problems SET
    slug = $$click-tally-window$$,
    title = $$Click Tally Window$$
WHERE slug = $$click-counter$$;

UPDATE problem_translations SET
    title = $KO$클릭 집계 창$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$click-tally-window$$);

-- cluster-barrel-signatures -> group-drink-labels
UPDATE problems SET
    slug = $$group-drink-labels$$,
    title = $$Group Drink Labels$$
WHERE slug = $$cluster-barrel-signatures$$;

UPDATE problem_translations SET
    title = $KO$음료 라벨 묶기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$group-drink-labels$$);

-- combine-counter-readings -> add-without-plus
UPDATE problems SET
    slug = $$add-without-plus$$,
    title = $$Add Without the Plus Sign$$
WHERE slug = $$combine-counter-readings$$;

UPDATE problem_translations SET
    title = $KO$더하기 없이 덧셈$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$add-without-plus$$);

-- combine-oven-rotations -> merge-leaderboard-runs
UPDATE problems SET
    slug = $$merge-leaderboard-runs$$,
    title = $$Merge Leaderboard Runs$$
WHERE slug = $$combine-oven-rotations$$;

UPDATE problem_translations SET
    title = $KO$리더보드 기록 합치기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$merge-leaderboard-runs$$);

-- compact-shelved-copies -> dedupe-textbook-shelf
UPDATE problems SET
    slug = $$dedupe-textbook-shelf$$,
    title = $$Dedupe Textbook Shelf$$
WHERE slug = $$compact-shelved-copies$$;

UPDATE problem_translations SET
    title = $KO$책꽂이 중복 정리$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$dedupe-textbook-shelf$$);

-- compare-pallet-flags -> compare-loadout-bits
UPDATE problems SET
    slug = $$compare-loadout-bits$$,
    title = $$Compare Loadout Bits$$
WHERE slug = $$compare-pallet-flags$$;

UPDATE problem_translations SET
    title = $KO$장비 플래그 비교하기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$compare-loadout-bits$$);

-- contains-topic-branch -> find-submap
UPDATE problems SET
    slug = $$find-submap$$,
    title = $$Find the Sub-map$$
WHERE slug = $$contains-topic-branch$$;

UPDATE problem_translations SET
    title = $KO$주제 가지 포함 확인$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$find-submap$$);

-- count-assembly-orders -> count-task-orderings
UPDATE problems SET
    slug = $$count-task-orderings$$,
    title = $$Count Task Orderings$$
WHERE slug = $$count-assembly-orders$$;

UPDATE problem_translations SET
    title = $KO$조별 과제 순서 세기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-task-orderings$$);

-- count-coupon-combos -> count-coupon-ways
UPDATE problems SET
    slug = $$count-coupon-ways$$,
    title = $$Count Coupon Ways$$
WHERE slug = $$count-coupon-combos$$;

UPDATE problem_translations SET
    title = $KO$쿠폰 조합 세기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-coupon-ways$$);

-- count-exact-page-quotas -> count-square-candy-bags
UPDATE problems SET
    slug = $$count-square-candy-bags$$,
    title = $$Count Square Candy Bags$$
WHERE slug = $$count-exact-page-quotas$$;

UPDATE problem_translations SET
    title = $KO$딱 맞는 봉지 개수 세기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-square-candy-bags$$);

-- count-filter-matches -> count-hint-matches
UPDATE problems SET
    slug = $$count-hint-matches$$,
    title = $$Count Hint Matches$$
WHERE slug = $$count-filter-matches$$;

UPDATE problem_translations SET
    title = $KO$노트 매칭 개수 세기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-hint-matches$$);

-- count-gate-routes -> count-dungeon-paths
UPDATE problems SET
    slug = $$count-dungeon-paths$$,
    title = $$Count Dungeon Paths$$
WHERE slug = $$count-gate-routes$$;

UPDATE problem_translations SET
    title = $KO$던전 경로 수 세기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-dungeon-paths$$);

-- count-longest-bake-trail -> count-longest-cookie-runs
UPDATE problems SET
    slug = $$count-longest-cookie-runs$$,
    title = $$Count Longest Cookie Runs$$
WHERE slug = $$count-longest-bake-trail$$;

UPDATE problem_translations SET
    title = $KO$가장 긴 굽기 순서 개수$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-longest-cookie-runs$$);

-- count-mirror-spans -> count-doodle-palindromes
UPDATE problems SET
    slug = $$count-doodle-palindromes$$,
    title = $$Count Doodle Palindromes$$
WHERE slug = $$count-mirror-spans$$;

UPDATE problem_translations SET
    title = $KO$거울 구간 세기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-doodle-palindromes$$);

-- count-reservoir-paths -> count-level-hops
UPDATE problems SET
    slug = $$count-level-hops$$,
    title = $$Count Level Hops$$
WHERE slug = $$count-reservoir-paths$$;

UPDATE problem_translations SET
    title = $KO$레벨 뛰는 경우의 수$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-level-hops$$);

-- count-scan-decodings -> count-cipher-decodings
UPDATE problems SET
    slug = $$count-cipher-decodings$$,
    title = $$Count Cipher Decodings$$
WHERE slug = $$count-scan-decodings$$;

UPDATE problem_translations SET
    title = $KO$디코딩 방법 개수$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-cipher-decodings$$);

-- cover-watering-windows -> cover-aquarium-zones
UPDATE problems SET
    slug = $$cover-aquarium-zones$$,
    title = $$Cover Aquarium Zones$$
WHERE slug = $$cover-watering-windows$$;

UPDATE problem_translations SET
    title = $KO$수조 구역 덮기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$cover-aquarium-zones$$);

-- crush-heaviest-bales -> crush-heaviest-blocks
UPDATE problems SET
    slug = $$crush-heaviest-blocks$$,
    title = $$Crush Heaviest Blocks$$
WHERE slug = $$crush-heaviest-bales$$;

UPDATE problem_translations SET
    title = $KO$가장 무거운 블록 부수기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$crush-heaviest-blocks$$);

-- days-to-upgrade -> days-until-warmer
UPDATE problems SET
    slug = $$days-until-warmer$$,
    title = $$Days Until Warmer$$
WHERE slug = $$days-to-upgrade$$;

UPDATE problem_translations SET
    title = $KO$기온이 오를 때까지 며칠?$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$days-until-warmer$$);

-- decode-zone-numeral -> decode-roman-floor
UPDATE problems SET
    slug = $$decode-roman-floor$$,
    title = $$Decode Roman Floor$$
WHERE slug = $$decode-zone-numeral$$;

UPDATE problem_translations SET
    title = $KO$던전 층수 해독하기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$decode-roman-floor$$);

-- deepest-zone-chain -> deepest-skill-chain
UPDATE problems SET
    slug = $$deepest-skill-chain$$,
    title = $$Deepest Skill Chain$$
WHERE slug = $$deepest-zone-chain$$;

UPDATE problem_translations SET
    title = $KO$가장 깊은 스킬 체인$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$deepest-skill-chain$$);

-- detect-callnumber-clash -> spot-duplicate-locker
UPDATE problems SET
    slug = $$spot-duplicate-locker$$,
    title = $$Spot the Duplicate Locker$$
WHERE slug = $$detect-callnumber-clash$$;

UPDATE problem_translations SET
    title = $KO$사물함 번호 중복 찾기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$spot-duplicate-locker$$);

-- detect-flow-value -> find-menu-price
UPDATE problems SET
    slug = $$find-menu-price$$,
    title = $$Find the Menu Price$$
WHERE slug = $$detect-flow-value$$;

UPDATE problem_translations SET
    title = $KO$메뉴판에서 가격 찾기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$find-menu-price$$);

-- detect-transfer-loop -> detect-portal-loop
UPDATE problems SET
    slug = $$detect-portal-loop$$,
    title = $$Detect Portal Loop$$
WHERE slug = $$detect-transfer-loop$$;

UPDATE problem_translations SET
    title = $KO$맵 루프 감지하기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$detect-portal-loop$$);

-- dock-edge-silhouette -> right-side-skill-view
UPDATE problems SET
    slug = $$right-side-skill-view$$,
    title = $$Right-Side Skill View$$
WHERE slug = $$dock-edge-silhouette$$;

UPDATE problem_translations SET
    title = $KO$오른쪽에서 본 스킬 트리$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$right-side-skill-view$$);

-- drop-class-conflicts -> drop-conflicting-classes
UPDATE problems SET
    slug = $$drop-conflicting-classes$$,
    title = $$Drop Conflicting Classes$$
WHERE slug = $$drop-class-conflicts$$;

UPDATE problem_translations SET
    title = $KO$겹치는 수업 정리하기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$drop-conflicting-classes$$);

-- drop-tail-booking -> drop-nth-reservation
UPDATE problems SET
    slug = $$drop-nth-reservation$$,
    title = $$Drop the Nth Reservation$$
WHERE slug = $$drop-tail-booking$$;

UPDATE problem_translations SET
    title = $KO$뒤에서 N번째 예약 취소$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$drop-nth-reservation$$);

-- duplicate-catalog-link -> redundant-friendship
UPDATE problems SET
    slug = $$redundant-friendship$$,
    title = $$Redundant Friendship$$
WHERE slug = $$duplicate-catalog-link$$;

UPDATE problem_translations SET
    title = $KO$중복된 친구 관계$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$redundant-friendship$$);

-- duplicate-topic-web -> clone-quest-log
UPDATE problems SET
    slug = $$clone-quest-log$$,
    title = $$Clone the Quest Log$$
WHERE slug = $$duplicate-topic-web$$;

UPDATE problem_translations SET
    title = $KO$퀘스트 로그 복제$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$clone-quest-log$$);

-- enumerate-barrel-blends -> list-trail-mix-combos
UPDATE problems SET
    slug = $$list-trail-mix-combos$$,
    title = $$List Trail Mix Combos$$
WHERE slug = $$enumerate-barrel-blends$$;

UPDATE problem_translations SET
    title = $KO$트레일 믹스 조합 나열$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$list-trail-mix-combos$$);

-- event-window-tally -> battery-window-tally
UPDATE problems SET
    slug = $$battery-window-tally$$,
    title = $$Battery Window Tally$$
WHERE slug = $$event-window-tally$$;

UPDATE problem_translations SET
    title = $KO$배터리 변동 구간 세기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$battery-window-tally$$);

-- fanout-responder-reach -> nearest-cat-feeder
UPDATE problems SET
    slug = $$nearest-cat-feeder$$,
    title = $$Nearest Cat Feeder$$
WHERE slug = $$fanout-responder-reach$$;

UPDATE problem_translations SET
    title = $KO$급식대까지 최소 거리$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$nearest-cat-feeder$$);

-- feed-designer -> micro-feed
UPDATE problems SET
    slug = $$micro-feed$$,
    title = $$Micro Feed$$
WHERE slug = $$feed-designer$$;

UPDATE problem_translations SET
    title = $KO$짧은 글 피드$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$micro-feed$$);

-- fewest-bag-sizes -> fewest-candy-bags
UPDATE problems SET
    slug = $$fewest-candy-bags$$,
    title = $$Fewest Candy Bags$$
WHERE slug = $$fewest-bag-sizes$$;

UPDATE problem_translations SET
    title = $KO$최소 사탕 봉지 수$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$fewest-candy-bags$$);

-- fewest-van-hops -> fewest-tile-jumps
UPDATE problems SET
    slug = $$fewest-tile-jumps$$,
    title = $$Fewest Tile Jumps$$
WHERE slug = $$fewest-van-hops$$;

UPDATE problem_translations SET
    title = $KO$최소 점프 횟수$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$fewest-tile-jumps$$);

-- finish-assembly-line -> finish-the-level
UPDATE problems SET
    slug = $$finish-the-level$$,
    title = $$Finish the Level$$
WHERE slug = $$finish-assembly-line$$;

UPDATE problem_translations SET
    title = $KO$레벨 클리어 가능?$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$finish-the-level$$);

-- flag-material-codes -> find-hidden-words
UPDATE problems SET
    slug = $$find-hidden-words$$,
    title = $$Find Hidden Words$$
WHERE slug = $$flag-material-codes$$;

UPDATE problem_translations SET
    title = $KO$단어 찾기 목록$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$find-hidden-words$$);

-- flights-by-tier -> group-tree-by-level
UPDATE problems SET
    slug = $$group-tree-by-level$$,
    title = $$Group Tree By Level$$
WHERE slug = $$flights-by-tier$$;

UPDATE problem_translations SET
    title = $KO$계급별 모으기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$group-tree-by-level$$);

-- flip-sorter-segments -> flip-chunks-of-k
UPDATE problems SET
    slug = $$flip-chunks-of-k$$,
    title = $$Flip Chunks of K$$
WHERE slug = $$flip-sorter-segments$$;

UPDATE problem_translations SET
    title = $KO$구간별로 뒤집기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$flip-chunks-of-k$$);

-- flooded-corridor-crossing -> rising-water-path
UPDATE problems SET
    slug = $$rising-water-path$$,
    title = $$Rising Water Path$$
WHERE slug = $$flooded-corridor-crossing$$;

UPDATE problem_translations SET
    title = $KO$물에 잠기는 통로 건너기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$rising-water-path$$);

-- fold-bale-ops -> eval-postfix-tape
UPDATE problems SET
    slug = $$eval-postfix-tape$$,
    title = $$Eval Postfix Tape$$
WHERE slug = $$fold-bale-ops$$;

UPDATE problem_translations SET
    title = $KO$후위 표기식 계산$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$eval-postfix-tape$$);

-- forecast-step-factor -> battery-drain-power
UPDATE problems SET
    slug = $$battery-drain-power$$,
    title = $$Battery Drain Power$$
WHERE slug = $$forecast-step-factor$$;

UPDATE problem_translations SET
    title = $KO$배터리 소모율 예측$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$battery-drain-power$$);

-- form-bale-triple -> grocery-bag-triple
UPDATE problems SET
    slug = $$grocery-bag-triple$$,
    title = $$Grocery Bag Triple$$
WHERE slug = $$form-bale-triple$$;

UPDATE problem_translations SET
    title = $KO$장바구니 세 묶음$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$grocery-bag-triple$$);

-- frame-largest-bale -> biggest-locker-poster
UPDATE problems SET
    slug = $$biggest-locker-poster$$,
    title = $$Biggest Locker Poster$$
WHERE slug = $$frame-largest-bale$$;

UPDATE problem_translations SET
    title = $KO$가장 큰 사물함 포스터$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$biggest-locker-poster$$);

-- group-oven-bakes -> group-study-cards
UPDATE problems SET
    slug = $$group-study-cards$$,
    title = $$Group Study Cards$$
WHERE slug = $$group-oven-bakes$$;

UPDATE problem_translations SET
    title = $KO$스터디 카드 묶기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$group-study-cards$$);

-- group-train-packs -> group-car-packs
UPDATE problems SET
    slug = $$group-car-packs$$,
    title = $$Group Car Packs$$
WHERE slug = $$group-train-packs$$;

UPDATE problem_translations SET
    title = $KO$차량 무리 묶기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$group-car-packs$$);

-- hash-table -> snack-stock-map
UPDATE problems SET
    slug = $$snack-stock-map$$,
    title = $$Snack Stock Map$$
WHERE slug = $$hash-table$$;

UPDATE problem_translations SET
    title = $KO$간식 재고 맵$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$snack-stock-map$$);

-- headline-majority-pick -> majority-boss-vote
UPDATE problems SET
    slug = $$majority-boss-vote$$,
    title = $$Majority Boss Vote$$
WHERE slug = $$headline-majority-pick$$;

UPDATE problem_translations SET
    title = $KO$대세 픽 고르기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$majority-boss-vote$$);

-- hub-evenness-check -> balanced-hamster-tree
UPDATE problems SET
    slug = $$balanced-hamster-tree$$,
    title = $$Balanced Hamster Tree$$
WHERE slug = $$hub-evenness-check$$;

UPDATE problem_translations SET
    title = $KO$햄스터 가계도 균형 검사$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$balanced-hamster-tree$$);

-- interleave-trailer-cuts -> interleave-clip-chain
UPDATE problems SET
    slug = $$interleave-clip-chain$$,
    title = $$Interleave Clip Chain$$
WHERE slug = $$interleave-trailer-cuts$$;

UPDATE problem_translations SET
    title = $KO$트레일러 컷 교차하기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$interleave-clip-chain$$);

-- irrigation-pipe-plan -> connect-water-bowls
UPDATE problems SET
    slug = $$connect-water-bowls$$,
    title = $$Connect Water Bowls$$
WHERE slug = $$irrigation-pipe-plan$$;

UPDATE problem_translations SET
    title = $KO$반려동물 급수대 연결$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$connect-water-bowls$$);

-- is-acyclic-network -> valid-pet-tree
UPDATE problems SET
    slug = $$valid-pet-tree$$,
    title = $$Valid Pet Cafe Tree$$
WHERE slug = $$is-acyclic-network$$;

UPDATE problem_translations SET
    title = $KO$무순환 네트워크 판별$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$valid-pet-tree$$);

-- keypad-device-codes -> flip-phone-codes
UPDATE problems SET
    slug = $$flip-phone-codes$$,
    title = $$Flip Phone Codes$$
WHERE slug = $$keypad-device-codes$$;

UPDATE problem_translations SET
    title = $KO$키패드 문자 조합$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$flip-phone-codes$$);

-- kth-largest-stream -> kth-top-score-stream
UPDATE problems SET
    slug = $$kth-top-score-stream$$,
    title = $$K-th Top Score Stream$$
WHERE slug = $$kth-largest-stream$$;

UPDATE problem_translations SET
    title = $KO$실시간 K번째 최고 점수$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$kth-top-score-stream$$);

-- label-lane-scans -> round-nicknames
UPDATE problems SET
    slug = $$round-nicknames$$,
    title = $$Round Nicknames$$
WHERE slug = $$label-lane-scans$$;

UPDATE problem_translations SET
    title = $KO$라운드 이름 붙이기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$round-nicknames$$);

-- list-runtime-branches -> list-skill-build-paths
UPDATE problems SET
    slug = $$list-skill-build-paths$$,
    title = $$List Skill Build Paths$$
WHERE slug = $$list-runtime-branches$$;

UPDATE problem_translations SET
    title = $KO$스킬 빌드 경로 나열$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$list-skill-build-paths$$);

-- list-slate-sequences -> list-bracket-pairings
UPDATE problems SET
    slug = $$list-bracket-pairings$$,
    title = $$List Bracket Pairings$$
WHERE slug = $$list-slate-sequences$$;

UPDATE problem_translations SET
    title = $KO$괄호 짝 만들기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$list-bracket-pairings$$);

-- locate-call-number -> find-locker-number
UPDATE problems SET
    slug = $$find-locker-number$$,
    title = $$Find Locker Number$$
WHERE slug = $$locate-call-number$$;

UPDATE problem_translations SET
    title = $KO$사물함 위치 찾기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$find-locker-number$$);

-- locate-terminus-station -> find-rotated-low-score
UPDATE problems SET
    slug = $$find-rotated-low-score$$,
    title = $$Find the Rotated Low Score$$
WHERE slug = $$locate-terminus-station$$;

UPDATE problem_translations SET
    title = $KO$회전된 리더보드 최저 점수$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$find-rotated-low-score$$);

-- locate-vacant-callslot -> find-empty-locker
UPDATE problems SET
    slug = $$find-empty-locker$$,
    title = $$Find the Empty Locker$$
WHERE slug = $$locate-vacant-callslot$$;

UPDATE problem_translations SET
    title = $KO$비어 있는 사물함 찾기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$find-empty-locker$$);

-- longest-bright-run -> longest-quiz-streak
UPDATE problems SET
    slug = $$longest-quiz-streak$$,
    title = $$Longest Quiz Streak$$
WHERE slug = $$longest-bright-run$$;

UPDATE problem_translations SET
    title = $KO$가장 긴 상승 퀴즈 수열$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-quiz-streak$$);

-- longest-clean-run -> longest-unique-treats
UPDATE problems SET
    slug = $$longest-unique-treats$$,
    title = $$Longest Unique Treats$$
WHERE slug = $$longest-clean-run$$;

UPDATE problem_translations SET
    title = $KO$가장 긴 안 겹치는 간식 구간$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-unique-treats$$);

-- longest-fresh-feed -> longest-genre-window
UPDATE problems SET
    slug = $$longest-genre-window$$,
    title = $$Longest Genre Window$$
WHERE slug = $$longest-fresh-feed$$;

UPDATE problem_translations SET
    title = $KO$가장 긴 장르 몰아보기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-genre-window$$);

-- longest-seat-block -> longest-seat-run
UPDATE problems SET
    slug = $$longest-seat-run$$,
    title = $$Longest Seat Run$$
WHERE slug = $$longest-seat-block$$;

UPDATE problem_translations SET
    title = $KO$가장 긴 좌석 구간$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-seat-run$$);

-- longest-vine-ascent -> longest-level-up-path
UPDATE problems SET
    slug = $$longest-level-up-path$$,
    title = $$Longest Level-Up Path$$
WHERE slug = $$longest-vine-ascent$$;

UPDATE problem_translations SET
    title = $KO$가장 긴 레벨업 경로$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-level-up-path$$);

-- lowest-missing-target -> missing-sock-number
UPDATE problems SET
    slug = $$missing-sock-number$$,
    title = $$Missing Sock Number$$
WHERE slug = $$lowest-missing-target$$;

UPDATE problem_translations SET
    title = $KO$사라진 빨래 번호$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$missing-sock-number$$);

-- match-recipe-ingredients -> same-snack-mix
UPDATE problems SET
    slug = $$same-snack-mix$$,
    title = $$Same Snack Mix$$
WHERE slug = $$match-recipe-ingredients$$;

UPDATE problem_translations SET
    title = $KO$같은 간식 믹스$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$same-snack-mix$$);

-- matching-catalog-layouts -> same-skill-trees
UPDATE problems SET
    slug = $$same-skill-trees$$,
    title = $$Same Skill Trees$$
WHERE slug = $$matching-catalog-layouts$$;

UPDATE problem_translations SET
    title = $KO$같은 스킬 트리 확인$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$same-skill-trees$$);

-- merge-flight-rosters -> merge-cafe-queues
UPDATE problems SET
    slug = $$merge-cafe-queues$$,
    title = $$Merge Cafe Queues$$
WHERE slug = $$merge-flight-rosters$$;

UPDATE problem_translations SET
    title = $KO$카페 주문 큐 합치기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$merge-cafe-queues$$);

-- merge-reservation-windows -> merge-reservation-slots
UPDATE problems SET
    slug = $$merge-reservation-slots$$,
    title = $$Merge Reservation Slots$$
WHERE slug = $$merge-reservation-windows$$;

UPDATE problem_translations SET
    title = $KO$예약 창 합치기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$merge-reservation-slots$$);

-- merged-zone-median -> merged-price-median
UPDATE problems SET
    slug = $$merged-price-median$$,
    title = $$Merged Price Median$$
WHERE slug = $$merged-zone-median$$;

UPDATE problem_translations SET
    title = $KO$합쳐진 매출 중간값$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$merged-price-median$$);

-- min-wait-route -> min-wait-drive
UPDATE problems SET
    slug = $$min-wait-drive$$,
    title = $$Min Wait Drive$$
WHERE slug = $$min-wait-route$$;

UPDATE problem_translations SET
    title = $KO$최소 대기 경로$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$min-wait-drive$$);

-- min-zone-code-edits -> min-cheat-code-edits
UPDATE problems SET
    slug = $$min-cheat-code-edits$$,
    title = $$Min Cheat Code Edits$$
WHERE slug = $$min-zone-code-edits$$;

UPDATE problem_translations SET
    title = $KO$최소 편집 횟수$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$min-cheat-code-edits$$);

-- minimum-stack -> low-score-stack
UPDATE problems SET
    slug = $$low-score-stack$$,
    title = $$Low Score Stack$$
WHERE slug = $$minimum-stack$$;

UPDATE problem_translations SET
    title = $KO$최저값 추적 스택$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$low-score-stack$$);

-- mirror-headline-splits -> palindrome-menu-splits
UPDATE problems SET
    slug = $$palindrome-menu-splits$$,
    title = $$Palindrome Menu Splits$$
WHERE slug = $$mirror-headline-splits$$;

UPDATE problem_translations SET
    title = $KO$팰린드롬 조각으로 쪼개기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$palindrome-menu-splits$$);

-- montage-scene-picks -> snack-combo-picks
UPDATE problems SET
    slug = $$snack-combo-picks$$,
    title = $$Snack Combo Picks$$
WHERE slug = $$montage-scene-picks$$;

UPDATE problem_translations SET
    title = $KO$간식 조합 뽑기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$snack-combo-picks$$);

-- nearest-depot-stops -> nearest-cafe-stops
UPDATE problems SET
    slug = $$nearest-cafe-stops$$,
    title = $$Nearest Cafe Stops$$
WHERE slug = $$nearest-depot-stops$$;

UPDATE problem_translations SET
    title = $KO$가까운 카페 배달지$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$nearest-cafe-stops$$);

-- next-shot-order -> next-speaker-order
UPDATE problems SET
    slug = $$next-speaker-order$$,
    title = $$Next Speaker Order$$
WHERE slug = $$next-shot-order$$;

UPDATE problem_translations SET
    title = $KO$다음 발표 순서$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$next-speaker-order$$);

-- nth-dimmest-target -> nth-lowest-score
UPDATE problems SET
    slug = $$nth-lowest-score$$,
    title = $$Nth Lowest Score$$
WHERE slug = $$nth-dimmest-target$$;

UPDATE problem_translations SET
    title = $KO$N번째 낮은 점수$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$nth-lowest-score$$);

-- nth-smooth-batch -> nth-unlockable-level
UPDATE problems SET
    slug = $$nth-unlockable-level$$,
    title = $$Nth Unlockable Level$$
WHERE slug = $$nth-smooth-batch$$;

UPDATE problem_translations SET
    title = $KO$N번째 해금 레벨$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$nth-unlockable-level$$);

-- order-tank-deviations -> sort-latte-squared
UPDATE problems SET
    slug = $$sort-latte-squared$$,
    title = $$Sort Latte Squared$$
WHERE slug = $$order-tank-deviations$$;

UPDATE problem_translations SET
    title = $KO$라떼 온도 편차 정렬$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$sort-latte-squared$$);

-- order-ticket-holders -> rebuild-tournament-line
UPDATE problems SET
    slug = $$rebuild-tournament-line$$,
    title = $$Rebuild the Tournament Line$$
WHERE slug = $$order-ticket-holders$$;

UPDATE problem_translations SET
    title = $KO$참가자 줄 세우기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$rebuild-tournament-line$$);

-- outward-shelf-walk -> spiral-shelf-walk
UPDATE problems SET
    slug = $$spiral-shelf-walk$$,
    title = $$Spiral Shelf Walk$$
WHERE slug = $$outward-shelf-walk$$;

UPDATE problem_translations SET
    title = $KO$바깥쪽 선반 돌기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$spiral-shelf-walk$$);

-- pair-crates-for-order -> pair-lunchbox-snacks
UPDATE problems SET
    slug = $$pair-lunchbox-snacks$$,
    title = $$Pair Lunchbox Snacks$$
WHERE slug = $$pair-crates-for-order$$;

UPDATE problem_translations SET
    title = $KO$도시락 상자 짝짓기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$pair-lunchbox-snacks$$);

-- pair-tiers-budget -> two-menu-sum
UPDATE problems SET
    slug = $$two-menu-sum$$,
    title = $$Two Menu Sum$$
WHERE slug = $$pair-tiers-budget$$;

UPDATE problem_translations SET
    title = $KO$예산 맞춰 두 메뉴 고르기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$two-menu-sum$$);

-- partition-tank-doses -> ticket-plus-or-minus
UPDATE problems SET
    slug = $$ticket-plus-or-minus$$,
    title = $$Ticket Plus or Minus$$
WHERE slug = $$partition-tank-doses$$;

UPDATE problem_translations SET
    title = $KO$티켓에 플러스·마이너스 붙이기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$ticket-plus-or-minus$$);

-- peak-flow-stretch -> peak-combo-window
UPDATE problems SET
    slug = $$peak-combo-window$$,
    title = $$Peak Combo Window$$
WHERE slug = $$peak-flow-stretch$$;

UPDATE problem_translations SET
    title = $KO$구간 최고 콤보$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$peak-combo-window$$);

-- peak-gate-demand -> peak-table-demand
UPDATE problems SET
    slug = $$peak-table-demand$$,
    title = $$Peak Table Demand$$
WHERE slug = $$peak-gate-demand$$;

UPDATE problem_translations SET
    title = $KO$피크 타임 테이블 수요$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$peak-table-demand$$);

-- peak-reading-window -> peak-score-streak
UPDATE problems SET
    slug = $$peak-score-streak$$,
    title = $$Peak Score Streak$$
WHERE slug = $$peak-reading-window$$;

UPDATE problem_translations SET
    title = $KO$최고 점수 구간$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$peak-score-streak$$);

-- peak-temp-swing -> peak-temp-jump
UPDATE problems SET
    slug = $$peak-temp-jump$$,
    title = $$Peak Temperature Jump$$
WHERE slug = $$peak-temp-swing$$;

UPDATE problem_translations SET
    title = $KO$최대 온도 변동$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$peak-temp-jump$$);

-- pick-circuit-targets -> pick-circular-donuts
UPDATE problems SET
    slug = $$pick-circular-donuts$$,
    title = $$Pick Circular Donuts$$
WHERE slug = $$pick-circuit-targets$$;

UPDATE problem_translations SET
    title = $KO$원형 도넛 고르기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$pick-circular-donuts$$);

-- pick-least-effort-circuit -> min-stamina-checkpoints
UPDATE problems SET
    slug = $$min-stamina-checkpoints$$,
    title = $$Min Stamina Checkpoints$$
WHERE slug = $$pick-least-effort-circuit$$;

UPDATE problem_translations SET
    title = $KO$체력 최소 소모 코스$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$min-stamina-checkpoints$$);

-- pick-plot-haul -> pick-snack-haul
UPDATE problems SET
    slug = $$pick-snack-haul$$,
    title = $$Pick Snack Haul$$
WHERE slug = $$pick-plot-haul$$;

UPDATE problem_translations SET
    title = $KO$간식 털이 최대화$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$pick-snack-haul$$);

-- pinpoint-peak-reading -> find-battery-peak
UPDATE problems SET
    slug = $$find-battery-peak$$,
    title = $$Find Battery Peak$$
WHERE slug = $$pinpoint-peak-reading$$;

UPDATE problem_translations SET
    title = $KO$정점 값 찾기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$find-battery-peak$$);

-- pool-between-walls -> puddle-between-fences
UPDATE problems SET
    slug = $$puddle-between-fences$$,
    title = $$Puddle Between Fences$$
WHERE slug = $$pool-between-walls$$;

UPDATE problem_translations SET
    title = $KO$울타리 사이 물웅덩이$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$puddle-between-fences$$);

-- prefix-tree -> username-trie
UPDATE problems SET
    slug = $$username-trie$$,
    title = $$Username Trie$$
WHERE slug = $$prefix-tree$$;

UPDATE problem_translations SET
    title = $KO$유저네임 트라이$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$username-trie$$);

-- probe-sugar-reading -> find-menu-calorie
UPDATE problems SET
    slug = $$find-menu-calorie$$,
    title = $$Find the Menu Calorie$$
WHERE slug = $$probe-sugar-reading$$;

UPDATE problem_translations SET
    title = $KO$메뉴 보드 탐색$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$find-menu-calorie$$);

-- product-as-text -> multiply-as-text
UPDATE problems SET
    slug = $$multiply-as-text$$,
    title = $$Multiply As Text$$
WHERE slug = $$product-as-text$$;

UPDATE problem_translations SET
    title = $KO$문자열로 곱셈$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$multiply-as-text$$);

-- quad-tray-demand -> four-tray-sum
UPDATE problems SET
    slug = $$four-tray-sum$$,
    title = $$Four Tray Sum$$
WHERE slug = $$quad-tray-demand$$;

UPDATE problem_translations SET
    title = $KO$네 트레이 합 맞추기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$four-tray-sum$$);

-- random-set -> random-pick-bag
UPDATE problems SET
    slug = $$random-pick-bag$$,
    title = $$Random Pick Bag$$
WHERE slug = $$random-set$$;

UPDATE problem_translations SET
    title = $KO$무작위 뽑기 가방$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$random-pick-bag$$);

-- recent-cache -> recent-save-slots
UPDATE problems SET
    slug = $$recent-save-slots$$,
    title = $$Recent Save Slots$$
WHERE slug = $$recent-cache$$;

UPDATE problem_translations SET
    title = $KO$최근 세이브 슬롯$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$recent-save-slots$$);

-- reflect-blend-profile -> mirror-menu-tree
UPDATE problems SET
    slug = $$mirror-menu-tree$$,
    title = $$Mirror the Menu Tree$$
WHERE slug = $$reflect-blend-profile$$;

UPDATE problem_translations SET
    title = $KO$메뉴 트리 뒤집기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$mirror-menu-tree$$);

-- repeat-tracking-codes -> repeat-attendance-codes
UPDATE problems SET
    slug = $$repeat-attendance-codes$$,
    title = $$Repeat Attendance Codes$$
WHERE slug = $$repeat-tracking-codes$$;

UPDATE problem_translations SET
    title = $KO$두 번 찍힌 출석 코드$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$repeat-attendance-codes$$);

-- resolve-lane-crashes -> brawler-lane-collision
UPDATE problems SET
    slug = $$brawler-lane-collision$$,
    title = $$Brawler Lane Collision$$
WHERE slug = $$resolve-lane-crashes$$;

UPDATE problem_translations SET
    title = $KO$레인 충돌 정리하기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$brawler-lane-collision$$);

-- resolve-price-ratios -> cafe-price-ratios
UPDATE problems SET
    slug = $$cafe-price-ratios$$,
    title = $$Cafe Price Ratios$$
WHERE slug = $$resolve-price-ratios$$;

UPDATE problem_translations SET
    title = $KO$가격 비율 계산하기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$cafe-price-ratios$$);

-- responder-relay-cost -> cheapest-courier-route
UPDATE problems SET
    slug = $$cheapest-courier-route$$,
    title = $$Cheapest Courier Route$$
WHERE slug = $$responder-relay-cost$$;

UPDATE problem_translations SET
    title = $KO$가장 싼 배송 경로$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$cheapest-courier-route$$);

-- reverse-printer-flags -> reverse-savefile-flags
UPDATE problems SET
    slug = $$reverse-savefile-flags$$,
    title = $$Reverse Save File Flags$$
WHERE slug = $$reverse-printer-flags$$;

UPDATE problem_translations SET
    title = $KO$세이브 파일 플래그 뒤집기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$reverse-savefile-flags$$);

-- reversible-call-number -> palindrome-episode-number
UPDATE problems SET
    slug = $$palindrome-episode-number$$,
    title = $$Palindrome Episode Number$$
WHERE slug = $$reversible-call-number$$;

UPDATE problem_translations SET
    title = $KO$뒤집어도 같은 에피소드 번호$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$palindrome-episode-number$$);

-- rewind-conveyor-chain -> reverse-playlist
UPDATE problems SET
    slug = $$reverse-playlist$$,
    title = $$Reverse the Playlist$$
WHERE slug = $$rewind-conveyor-chain$$;

UPDATE problem_translations SET
    title = $KO$플레이리스트 뒤집기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$reverse-playlist$$);

-- ring-buffer -> chat-ring-buffer
UPDATE problems SET
    slug = $$chat-ring-buffer$$,
    title = $$Chat Ring Buffer$$
WHERE slug = $$ring-buffer$$;

UPDATE problem_translations SET
    title = $KO$고정 크기 채팅 링 버퍼$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$chat-ring-buffer$$);

-- rotate-park-map -> rotate-pet-cafe-map
UPDATE problems SET
    slug = $$rotate-pet-cafe-map$$,
    title = $$Rotate Pet Cafe Map$$
WHERE slug = $$rotate-park-map$$;

UPDATE problem_translations SET
    title = $KO$펫 카페 지도 회전$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$rotate-pet-cafe-map$$);

-- running-median -> running-median-timer
UPDATE problems SET
    slug = $$running-median-timer$$,
    title = $$Running Median Timer$$
WHERE slug = $$running-median$$;

UPDATE problem_translations SET
    title = $KO$실시간 중앙값 추적$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$running-median-timer$$);

-- scene-shoot-order -> recover-tier-order
UPDATE problems SET
    slug = $$recover-tier-order$$,
    title = $$Recover Tier List Order$$
WHERE slug = $$scene-shoot-order$$;

UPDATE problem_translations SET
    title = $KO$티어 순서 복원$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$recover-tier-order$$);

-- schedule-observing-window -> slot-a-meeting
UPDATE problems SET
    slug = $$slot-a-meeting$$,
    title = $$Slot a Meeting In$$
WHERE slug = $$schedule-observing-window$$;

UPDATE problem_translations SET
    title = $KO$일정 끼워 넣기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$slot-a-meeting$$);

-- seize-enclosed-zones -> capture-enclosed-tiles
UPDATE problems SET
    slug = $$capture-enclosed-tiles$$,
    title = $$Capture Enclosed Tiles$$
WHERE slug = $$seize-enclosed-zones$$;

UPDATE problem_translations SET
    title = $KO$갇힌 영역 점령$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$capture-enclosed-tiles$$);

-- sequence-assembly-steps -> order-group-tasks
UPDATE problems SET
    slug = $$order-group-tasks$$,
    title = $$Order the Group Tasks$$
WHERE slug = $$sequence-assembly-steps$$;

UPDATE problem_translations SET
    title = $KO$과제 수행 순서$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$order-group-tasks$$);

-- shared-assembly-lookup -> topic-catalog-lca
UPDATE problems SET
    slug = $$topic-catalog-lca$$,
    title = $$Topic Catalog LCA$$
WHERE slug = $$shared-assembly-lookup$$;

UPDATE problem_translations SET
    title = $KO$공통 조상 주제 찾기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$topic-catalog-lca$$);

-- shared-dispatch-hub -> shared-guild-ancestor
UPDATE problems SET
    slug = $$shared-guild-ancestor$$,
    title = $$Shared Guild Ancestor$$
WHERE slug = $$shared-dispatch-hub$$;

UPDATE problem_translations SET
    title = $KO$공통 팀장 찾기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$shared-guild-ancestor$$);

-- shelf-overlap-length -> desk-notes-overlap
UPDATE problems SET
    slug = $$desk-notes-overlap$$,
    title = $$Desk Notes Overlap$$
WHERE slug = $$shelf-overlap-length$$;

UPDATE problem_translations SET
    title = $KO$겹치는 필기 길이$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$desk-notes-overlap$$);

-- shelf-stock-pair -> snack-drawer-pair
UPDATE problems SET
    slug = $$snack-drawer-pair$$,
    title = $$Snack Drawer Pair$$
WHERE slug = $$shelf-stock-pair$$;

UPDATE problem_translations SET
    title = $KO$간식 서랍 짝 찾기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$snack-drawer-pair$$);

-- shift-unscannable-letters -> longest-combo-run
UPDATE problems SET
    slug = $$longest-combo-run$$,
    title = $$Longest Combo Run$$
WHERE slug = $$shift-unscannable-letters$$;

UPDATE problem_translations SET
    title = $KO$최장 콤보 구간$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-combo-run$$);

-- shortest-bake-span -> shortest-cookie-span
UPDATE problems SET
    slug = $$shortest-cookie-span$$,
    title = $$Shortest Cookie Span$$
WHERE slug = $$shortest-bake-span$$;

UPDATE problem_translations SET
    title = $KO$가장 짧은 쿠키 구간$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$shortest-cookie-span$$);

-- shortest-shelf-span -> shortest-book-span
UPDATE problems SET
    slug = $$shortest-book-span$$,
    title = $$Shortest Book Span$$
WHERE slug = $$shortest-shelf-span$$;

UPDATE problem_translations SET
    title = $KO$가장 짧은 책장 구간$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$shortest-book-span$$);

-- single-species-tank -> power-of-two-tank
UPDATE problems SET
    slug = $$power-of-two-tank$$,
    title = $$Power of Two Tank$$
WHERE slug = $$single-species-tank$$;

UPDATE problem_translations SET
    title = $KO$2의 거듭제곱 수조$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$power-of-two-tank$$);

-- slowest-conveyor-speed -> slowest-snack-rate
UPDATE problems SET
    slug = $$slowest-snack-rate$$,
    title = $$Slowest Snack Rate$$
WHERE slug = $$slowest-conveyor-speed$$;

UPDATE problem_translations SET
    title = $KO$가장 느린 간식 속도$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$slowest-snack-rate$$);

-- smallest-flow-rate -> min-daily-brew
UPDATE problems SET
    slug = $$min-daily-brew$$,
    title = $$Min Daily Brew Rate$$
WHERE slug = $$smallest-flow-rate$$;

UPDATE problem_translations SET
    title = $KO$최소 하루 제조 용량$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$min-daily-brew$$);

-- snapshot-mesh-layout -> snapshot-town-map
UPDATE problems SET
    slug = $$snapshot-town-map$$,
    title = $$Snapshot the Town Map$$
WHERE slug = $$snapshot-mesh-layout$$;

UPDATE problem_translations SET
    title = $KO$맵 스냅샷 뜨기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$snapshot-town-map$$);

-- sort-material-bins -> sort-recycle-bins
UPDATE problems SET
    slug = $$sort-recycle-bins$$,
    title = $$Sort Recycle Bins$$
WHERE slug = $$sort-material-bins$$;

UPDATE problem_translations SET
    title = $KO$재활용 수거함 정리$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$sort-recycle-bins$$);

-- space-recipe-bakes -> space-cookie-bakes
UPDATE problems SET
    slug = $$space-cookie-bakes$$,
    title = $$Space the Cookie Bakes$$
WHERE slug = $$space-recipe-bakes$$;

UPDATE problem_translations SET
    title = $KO$쿠키 사이 간격 두기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$space-cookie-bakes$$);

-- species-grid-validator -> valid-number-puzzle
UPDATE problems SET
    slug = $$valid-number-puzzle$$,
    title = $$Valid Number Puzzle$$
WHERE slug = $$species-grid-validator$$;

UPDATE problem_translations SET
    title = $KO$숫자 퍼즐 격자 검사$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$valid-number-puzzle$$);

-- split-headline-tokens -> word-break-chat
UPDATE problems SET
    slug = $$word-break-chat$$,
    title = $$Word Break Chat$$
WHERE slug = $$split-headline-tokens$$;

UPDATE problem_translations SET
    title = $KO$헤드라인 토큰 나누기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$word-break-chat$$);

-- split-into-two-shifts -> two-shift-baristas
UPDATE problems SET
    slug = $$two-shift-baristas$$,
    title = $$Two Shift Baristas$$
WHERE slug = $$split-into-two-shifts$$;

UPDATE problem_translations SET
    title = $KO$바리스타 두 교대 나누기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$two-shift-baristas$$);

-- split-reading-for-product -> split-candy-bar
UPDATE problems SET
    slug = $$split-candy-bar$$,
    title = $$Split the Candy Bar$$
WHERE slug = $$split-reading-for-product$$;

UPDATE problem_translations SET
    title = $KO$막대 쪼개서 곱 최대화$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$split-candy-bar$$);

-- split-shift-loads -> split-ticket-pile
UPDATE problems SET
    slug = $$split-ticket-pile$$,
    title = $$Split the Ticket Pile$$
WHERE slug = $$split-shift-loads$$;

UPDATE problem_translations SET
    title = $KO$업무량 똑같이 나누기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$split-ticket-pile$$);

-- split-zone-codes -> restore-wifi-ip
UPDATE problems SET
    slug = $$restore-wifi-ip$$,
    title = $$Restore Wi-Fi IP$$
WHERE slug = $$split-zone-codes$$;

UPDATE problem_translations SET
    title = $KO$IP 주소로 쪼개기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$restore-wifi-ip$$);

-- split-zone-runs -> split-sticker-runs
UPDATE problems SET
    slug = $$split-sticker-runs$$,
    title = $$Split Sticker Runs$$
WHERE slug = $$split-zone-runs$$;

UPDATE problem_translations SET
    title = $KO$스티커 문자열 구간 분할$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$split-sticker-runs$$);

-- spot-catalog-target -> search-rotated-catalog
UPDATE problems SET
    slug = $$search-rotated-catalog$$,
    title = $$Search Rotated Catalog$$
WHERE slug = $$spot-catalog-target$$;

UPDATE problem_translations SET
    title = $KO$회전된 카탈로그 탐색$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$search-rotated-catalog$$);

-- spread-contamination-wave -> rotting-donuts
UPDATE problems SET
    slug = $$rotting-donuts$$,
    title = $$Rotting Donuts$$
WHERE slug = $$spread-contamination-wave$$;

UPDATE problem_translations SET
    title = $KO$도넛 상함 전파$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$rotting-donuts$$);

-- stack-queue -> queue-from-stacks
UPDATE problems SET
    slug = $$queue-from-stacks$$,
    title = $$Queue From Stacks$$
WHERE slug = $$stack-queue$$;

UPDATE problem_translations SET
    title = $KO$스택으로 큐 만들기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$queue-from-stacks$$);

-- state-snapshots -> versioned-cells
UPDATE problems SET
    slug = $$versioned-cells$$,
    title = $$Versioned Cell Array$$
WHERE slug = $$state-snapshots$$;

UPDATE problem_translations SET
    title = $KO$버전 관리되는 셀 배열$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$versioned-cells$$);

-- station-run-planner -> task-cooldown-planner
UPDATE problems SET
    slug = $$task-cooldown-planner$$,
    title = $$Task Cooldown Planner$$
WHERE slug = $$station-run-planner$$;

UPDATE problem_translations SET
    title = $KO$작업 쿨다운 스케줄러$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$task-cooldown-planner$$);

-- station-throughput-shares -> barista-throughput-share
UPDATE problems SET
    slug = $$barista-throughput-share$$,
    title = $$Barista Throughput Share$$
WHERE slug = $$station-throughput-shares$$;

UPDATE problem_translations SET
    title = $KO$바리스타 처리량 지분$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$barista-throughput-share$$);

-- station-visit-orders -> cafe-stop-orders
UPDATE problems SET
    slug = $$cafe-stop-orders$$,
    title = $$Cafe Stop Orders$$
WHERE slug = $$station-visit-orders$$;

UPDATE problem_translations SET
    title = $KO$카페 투어 순서 짜기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$cafe-stop-orders$$);

-- string-codec -> chat-log-codec
UPDATE problems SET
    slug = $$chat-log-codec$$,
    title = $$Chat Log Codec$$
WHERE slug = $$string-codec$$;

UPDATE problem_translations SET
    title = $KO$채팅 로그 코덱$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$chat-log-codec$$);

-- sum-zone-codes -> sum-skill-tree-codes
UPDATE problems SET
    slug = $$sum-skill-tree-codes$$,
    title = $$Sum Skill Tree Codes$$
WHERE slug = $$sum-zone-codes$$;

UPDATE problem_translations SET
    title = $KO$스킬 트리 코드 합 구하기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$sum-skill-tree-codes$$);

-- swap-queue-partners -> swap-print-pairs
UPDATE problems SET
    slug = $$swap-print-pairs$$,
    title = $$Swap Print Pairs$$
WHERE slug = $$swap-queue-partners$$;

UPDATE problem_translations SET
    title = $KO$인쇄 대기열 짝 바꾸기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$swap-print-pairs$$);

-- tally-device-meshes -> count-voice-parties
UPDATE problems SET
    slug = $$count-voice-parties$$,
    title = $$Count Voice Relay Parties$$
WHERE slug = $$tally-device-meshes$$;

UPDATE problem_translations SET
    title = $KO$음성 릴레이 파티 세기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-voice-parties$$);

-- tally-dominant-blocks -> count-top-heroes
UPDATE problems SET
    slug = $$count-top-heroes$$,
    title = $$Count Top Heroes$$
WHERE slug = $$tally-dominant-blocks$$;

UPDATE problem_translations SET
    title = $KO$최고점 영웅 세기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-top-heroes$$);

-- tally-pick-paths -> add-score-lists
UPDATE problems SET
    slug = $$add-score-lists$$,
    title = $$Add Score Lists$$
WHERE slug = $$tally-pick-paths$$;

UPDATE problem_translations SET
    title = $KO$점수 합산 연결 리스트$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$add-score-lists$$);

-- tally-planted-regions -> count-desk-clusters
UPDATE problems SET
    slug = $$count-desk-clusters$$,
    title = $$Count Desk Clusters$$
WHERE slug = $$tally-planted-regions$$;

UPDATE problem_translations SET
    title = $KO$책상 그룹 세기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-desk-clusters$$);

-- tally-priority-flags -> count-flag-bits
UPDATE problems SET
    slug = $$count-flag-bits$$,
    title = $$Count Flag Bits$$
WHERE slug = $$tally-priority-flags$$;

UPDATE problem_translations SET
    title = $KO$비트 플래그 개수 세기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-flag-bits$$);

-- taxiway-aircraft-layout -> place-n-scouts
UPDATE problems SET
    slug = $$place-n-scouts$$,
    title = $$Place N Scouts$$
WHERE slug = $$taxiway-aircraft-layout$$;

UPDATE problem_translations SET
    title = $KO$정찰병 배치 문제$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$place-n-scouts$$);

-- tightest-or-booking -> shortest-table-booking
UPDATE problems SET
    slug = $$shortest-table-booking$$,
    title = $$Shortest Table Booking$$
WHERE slug = $$tightest-or-booking$$;

UPDATE problem_translations SET
    title = $KO$가장 짧은 예약 찾기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$shortest-table-booking$$);

-- time-map -> timestamp-value-store
UPDATE problems SET
    slug = $$timestamp-value-store$$,
    title = $$Timestamped Value Store$$
WHERE slug = $$time-map$$;

UPDATE problem_translations SET
    title = $KO$시각 기록 저장소$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$timestamp-value-store$$);

-- trace-dual-drainage -> dual-waterbowl-flow
UPDATE problems SET
    slug = $$dual-waterbowl-flow$$,
    title = $$Dual Waterbowl Flow$$
WHERE slug = $$trace-dual-drainage$$;

UPDATE problem_translations SET
    title = $KO$두 물그릇 모두 닿기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$dual-waterbowl-flow$$);

-- transit-alert-wave -> guild-chat-relay
UPDATE problems SET
    slug = $$guild-chat-relay$$,
    title = $$Guild Chat Relay$$
WHERE slug = $$transit-alert-wave$$;

UPDATE problem_translations SET
    title = $KO$길드 공지 전파 시간$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$guild-chat-relay$$);

-- tree-codec -> skill-tree-codec
UPDATE problems SET
    slug = $$skill-tree-codec$$,
    title = $$Skill Tree Codec$$
WHERE slug = $$tree-codec$$;

UPDATE problem_translations SET
    title = $KO$스킬 트리 직렬화$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$skill-tree-codec$$);

-- trending-feed-topics -> trending-chat-topics
UPDATE problems SET
    slug = $$trending-chat-topics$$,
    title = $$Trending Chat Topics$$
WHERE slug = $$trending-feed-topics$$;

UPDATE problem_translations SET
    title = $KO$단톡방 유행 주제$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$trending-chat-topics$$);

-- triage-zero-priority -> zero-sum-trio
UPDATE problems SET
    slug = $$zero-sum-trio$$,
    title = $$Zero Sum Trio$$
WHERE slug = $$triage-zero-priority$$;

UPDATE problem_translations SET
    title = $KO$합이 0인 삼인방$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$zero-sum-trio$$);

-- unify-crew-contacts -> merge-duplicate-contacts
UPDATE problems SET
    slug = $$merge-duplicate-contacts$$,
    title = $$Merge Duplicate Contacts$$
WHERE slug = $$unify-crew-contacts$$;

UPDATE problem_translations SET
    title = $KO$중복 연락처 합치기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$merge-duplicate-contacts$$);

-- unique-topic-window -> unique-genre-window
UPDATE problems SET
    slug = $$unique-genre-window$$,
    title = $$Unique Genre Window$$
WHERE slug = $$unique-topic-window$$;

UPDATE problem_translations SET
    title = $KO$장르 제한 몰아보기 구간$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$unique-genre-window$$);

-- unpaired-frame-reading -> lonely-candy
UPDATE problems SET
    slug = $$lonely-candy$$,
    title = $$Lonely Candy$$
WHERE slug = $$unpaired-frame-reading$$;

UPDATE problem_translations SET
    title = $KO$외톨이 사탕 찾기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$lonely-candy$$);

-- unroll-flight-schedule -> flatten-agenda-tree
UPDATE problems SET
    slug = $$flatten-agenda-tree$$,
    title = $$Flatten Agenda Tree$$
WHERE slug = $$unroll-flight-schedule$$;

UPDATE problem_translations SET
    title = $KO$일정 트리 펼치기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$flatten-agenda-tree$$);

-- validate-part-stream -> validate-homework-id
UPDATE problems SET
    slug = $$validate-homework-id$$,
    title = $$Validate Homework ID$$
WHERE slug = $$validate-part-stream$$;

UPDATE problem_translations SET
    title = $KO$과제 ID 검증$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$validate-homework-id$$);

-- verify-bake-rotation -> verify-pizza-rotation
UPDATE problems SET
    slug = $$verify-pizza-rotation$$,
    title = $$Verify Pizza Rotation$$
WHERE slug = $$verify-bake-rotation$$;

UPDATE problem_translations SET
    title = $KO$피자 트레이 정렬 확인하기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$verify-pizza-rotation$$);

-- verify-job-nesting -> valid-brackets
UPDATE problems SET
    slug = $$valid-brackets$$,
    title = $$Valid Brackets$$
WHERE slug = $$verify-job-nesting$$;

UPDATE problem_translations SET
    title = $KO$괄호 중첩 검사하기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$valid-brackets$$);

-- verify-mirror-callnumber -> valid-slogan-palindrome
UPDATE problems SET
    slug = $$valid-slogan-palindrome$$,
    title = $$Valid Slogan Palindrome$$
WHERE slug = $$verify-mirror-callnumber$$;

UPDATE problem_translations SET
    title = $KO$거울 문구 검사하기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$valid-slogan-palindrome$$);

-- verify-shoot-plan -> verify-task-order
UPDATE problems SET
    slug = $$verify-task-order$$,
    title = $$Verify Task Order$$
WHERE slug = $$verify-shoot-plan$$;

UPDATE problem_translations SET
    title = $KO$조별 과제 계획 검증$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$verify-task-order$$);

-- verify-table-bookings -> can-attend-bookings
UPDATE problems SET
    slug = $$can-attend-bookings$$,
    title = $$Can Attend All Bookings$$
WHERE slug = $$verify-table-bookings$$;

UPDATE problem_translations SET
    title = $KO$테이블 예약 충돌 검사$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$can-attend-bookings$$);

-- void-empty-scans -> move-voided-scans
UPDATE problems SET
    slug = $$move-voided-scans$$,
    title = $$Move Voided Scans$$
WHERE slug = $$void-empty-scans$$;

UPDATE problem_translations SET
    title = $KO$취소 주문 뒤로 밀기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$move-voided-scans$$);

-- voucher-price-combos -> voucher-price-combos
UPDATE problems SET
    slug = $$voucher-price-combos$$,
    title = $$Voucher Price Combos$$
WHERE slug = $$voucher-price-combos$$;

UPDATE problem_translations SET
    title = $KO$쿠폰 가격 조합$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$voucher-price-combos$$);

-- ward-priority-audit -> valid-score-bst
UPDATE problems SET
    slug = $$valid-score-bst$$,
    title = $$Valid Score BST$$
WHERE slug = $$ward-priority-audit$$;

UPDATE problem_translations SET
    title = $KO$점수 트리 검사$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$valid-score-bst$$);

-- widest-catalog-span -> longest-folder-path
UPDATE problems SET
    slug = $$longest-folder-path$$,
    title = $$Longest Folder Path$$
WHERE slug = $$widest-catalog-span$$;

UPDATE problem_translations SET
    title = $KO$가장 긴 폴더 경로$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-folder-path$$);

-- widest-vine-block -> biggest-banner-span
UPDATE problems SET
    slug = $$biggest-banner-span$$,
    title = $$Biggest Banner Span$$
WHERE slug = $$widest-vine-block$$;

UPDATE problem_translations SET
    title = $KO$가장 큰 배너 붙이기$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$biggest-banner-span$$);

-- wire-zone-peers -> link-guild-siblings
UPDATE problems SET
    slug = $$link-guild-siblings$$,
    title = $$Link Guild Siblings$$
WHERE slug = $$wire-zone-peers$$;

UPDATE problem_translations SET
    title = $KO$같은 층 친구 연결$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$link-guild-siblings$$);

-- word-dictionary -> wildcard-lexicon
UPDATE problems SET
    slug = $$wildcard-lexicon$$,
    title = $$Wildcard Lexicon$$
WHERE slug = $$word-dictionary$$;

UPDATE problem_translations SET
    title = $KO$와일드카드 단어 사전$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$wildcard-lexicon$$);

-- zone-code-anagram -> find-name-anagram
UPDATE problems SET
    slug = $$find-name-anagram$$,
    title = $$Find Name Anagram$$
WHERE slug = $$zone-code-anagram$$;

UPDATE problem_translations SET
    title = $KO$애너그램 부분 문자열$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$find-name-anagram$$);

-- zone-letter-trail -> word-hunt-board
UPDATE problems SET
    slug = $$word-hunt-board$$,
    title = $$Word Hunt Board$$
WHERE slug = $$zone-letter-trail$$;

UPDATE problem_translations SET
    title = $KO$보드 위 단어 탐색$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$word-hunt-board$$);

