-- V564: restore-wifi-ip restated, Slug and English title unchanged. The first sentence now
-- states the task, and the statement says the addresses may come in any order (every Driver
-- sorts them) where it asked for lexicographic order. The Korean title matches the English
-- one. Starter method splitZoneCodes -> restoreIpAddresses in all 4 Starter Codes and Drivers,
-- and the Drivers' local s is now digits. Examples match the sample test cases, which are
-- unchanged.

UPDATE problems SET
    description = $$Your roommate wrote the Wi-Fi router's IP address as one string of digits, `digits`, leaving out the dots. Return every valid IP address that inserting exactly three dots into `digits` can form, in any order, or an empty list when none is valid.

A valid address has exactly four segments separated by dots. Each segment is a number from `0` to `255` with no leading zero: `"0"` is a valid segment, `"01"` is not.

**Example 1:**
```
Input: digits = "19216811"
Output: ["1.92.168.11","19.2.168.11","19.21.68.11","19.216.8.11","19.216.81.1","192.1.68.11","192.16.8.11","192.16.81.1","192.168.1.1"]
```

**Example 2:**
```
Input: digits = "0202"
Output: ["0.2.0.2"]
Explanation: A segment of `"0"` alone is fine, but `"02"` and `"020"` start with `0`, so the only split is 0.2.0.2.
```$$
WHERE slug = $$restore-wifi-ip$$;

UPDATE problem_translations SET
    title = $$Wi-Fi IP 복원하기$$,
    description = $$룸메이트가 Wi-Fi 공유기의 IP 주소를 점을 빼고 숫자 문자열 `digits` 하나로 적어 두었습니다. `digits`에 점 세 개를 끼워 넣어 만들 수 있는 유효한 IP 주소를 모두 반환하세요. 순서는 자유이며, 유효한 주소가 없으면 빈 리스트를 반환합니다.

유효한 주소는 점으로 구분된 정확히 네 조각으로 이루어집니다. 각 조각은 `0` 이상 `255` 이하의 수이며 앞에 0이 붙을 수 없습니다. `"0"`은 유효한 조각이지만 `"01"`은 아닙니다.

**예시 1:**
```
입력: digits = "19216811"
출력: ["1.92.168.11","19.2.168.11","19.21.68.11","19.216.8.11","19.216.81.1","192.1.68.11","192.16.8.11","192.16.81.1","192.168.1.1"]
```

**예시 2:**
```
입력: digits = "0202"
출력: ["0.2.0.2"]
설명: `"0"` 한 글자짜리 조각은 괜찮지만 `"02"`와 `"020"`은 `0`으로 시작하므로, 가능한 분할은 0.2.0.2 하나뿐입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$restore-wifi-ip$$);
