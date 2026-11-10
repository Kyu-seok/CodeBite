-- V277: restate fizz-buzz (#209, part of #193). Examples 1 and 2 showed LeetCode's
-- data (n = 3 and n = 5), which is no sample Test Case; they now show samples 1 and 2
-- (n = 4 and n = 6) in both languages. Example 3 (n = 15) already was sample 3 and
-- stays. Slug, title, constraints, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problems SET
    description = $$Given a positive integer `n`, return an array `answer` of length `n` where, for each `i` from `1` through `n`:
- `answer[i-1]` is `"FizzBuzz"` when `i` is divisible by both 3 and 5,
- `"Fizz"` when `i` is divisible only by 3,
- `"Buzz"` when `i` is divisible only by 5,
- the decimal string of `i` otherwise.

**Example 1:**
```
Input: n = 4
Output: ["1","2","Fizz","4"]
```

**Example 2:**
```
Input: n = 6
Output: ["1","2","Fizz","4","Buzz","Fizz"]
```

**Example 3:**
```
Input: n = 15
Output: ["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]
```$$
WHERE slug = $$fizz-buzz$$;

UPDATE problem_translations SET
    description = $$양의 정수 `n`이 주어지면 길이가 `n`인 배열 `answer`를 반환하세요. `1`부터 `n`까지의 각 정수 `i`에 대해:
- `i`가 3과 5 모두로 나누어떨어지면 `answer[i-1]`은 `"FizzBuzz"`,
- 3으로만 나누어떨어지면 `"Fizz"`,
- 5로만 나누어떨어지면 `"Buzz"`,
- 그 외에는 `i`의 십진 문자열 표현입니다.

**예시 1:**
```
입력: n = 4
출력: ["1","2","Fizz","4"]
```

**예시 2:**
```
입력: n = 6
출력: ["1","2","Fizz","4","Buzz","Fizz"]
```

**예시 3:**
```
입력: n = 15
출력: ["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$fizz-buzz$$);
