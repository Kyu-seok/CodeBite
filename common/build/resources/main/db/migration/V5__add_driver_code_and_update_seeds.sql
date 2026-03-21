-- Add driver_code column to problems
ALTER TABLE problems ADD COLUMN driver_code TEXT;

-- Update test case inputs from JSON to line-based format
-- Two Sum test cases (problem_id = 1)
UPDATE test_cases SET input = '[2,7,11,15]
9' WHERE problem_id = 1 AND order_index = 1;
UPDATE test_cases SET input = '[3,2,4]
6' WHERE problem_id = 1 AND order_index = 2;
UPDATE test_cases SET input = '[3,3]
6' WHERE problem_id = 1 AND order_index = 3;
UPDATE test_cases SET input = '[1,5,3,7,2]
9' WHERE problem_id = 1 AND order_index = 4;

-- FizzBuzz test cases (problem_id = 2)
UPDATE test_cases SET input = '5' WHERE problem_id = 2 AND order_index = 1;
UPDATE test_cases SET input = '15' WHERE problem_id = 2 AND order_index = 2;
UPDATE test_cases SET input = '1' WHERE problem_id = 2 AND order_index = 3;

-- Reverse String test cases (problem_id = 3)
UPDATE test_cases SET input = '["h","e","l","l","o"]' WHERE problem_id = 3 AND order_index = 1;
UPDATE test_cases SET input = '["H","a","n","n","a","h"]' WHERE problem_id = 3 AND order_index = 2;
UPDATE test_cases SET input = '["a"]' WHERE problem_id = 3 AND order_index = 3;

-- Valid Parentheses test cases (problem_id = 4)
UPDATE test_cases SET input = '()' WHERE problem_id = 4 AND order_index = 1;
UPDATE test_cases SET input = '()[]{}' WHERE problem_id = 4 AND order_index = 2;
UPDATE test_cases SET input = '(]' WHERE problem_id = 4 AND order_index = 3;
UPDATE test_cases SET input = '([{}])' WHERE problem_id = 4 AND order_index = 4;
UPDATE test_cases SET input = '((' WHERE problem_id = 4 AND order_index = 5;

-- Palindrome Number test cases (problem_id = 5)
UPDATE test_cases SET input = '121' WHERE problem_id = 5 AND order_index = 1;
UPDATE test_cases SET input = '-121' WHERE problem_id = 5 AND order_index = 2;
UPDATE test_cases SET input = '10' WHERE problem_id = 5 AND order_index = 3;
UPDATE test_cases SET input = '0' WHERE problem_id = 5 AND order_index = 4;
UPDATE test_cases SET input = '12321' WHERE problem_id = 5 AND order_index = 5;

-- Populate driver_code for all 5 seed problems
-- Problem 1: Two Sum
UPDATE problems SET driver_code = '{"java": "import java.util.*;\n\n{USER_CODE}\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        String numsLine = sc.nextLine().trim();\n        int target = Integer.parseInt(sc.nextLine().trim());\n        String inner = numsLine.substring(1, numsLine.length() - 1);\n        String[] parts = inner.split(\",\");\n        int[] nums = new int[parts.length];\n        for (int i = 0; i < parts.length; i++) nums[i] = Integer.parseInt(parts[i].trim());\n        int[] result = new Solution().twoSum(nums, target);\n        System.out.println(Arrays.toString(result).replace(\" \", \"\"));\n    }\n}", "python": "{USER_CODE}\n\nimport sys\nnums = eval(input())\ntarget = int(input())\nresult = Solution().twoSum(nums, target)\nprint(result)"}'
WHERE slug = 'two-sum';

-- Problem 2: FizzBuzz
UPDATE problems SET driver_code = '{"java": "import java.util.*;\n\n{USER_CODE}\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int n = Integer.parseInt(sc.nextLine().trim());\n        List<String> result = new Solution().fizzBuzz(n);\n        System.out.println(result);\n    }\n}", "python": "{USER_CODE}\n\nn = int(input())\nresult = Solution().fizzBuzz(n)\nprint(result)"}'
WHERE slug = 'fizzbuzz';

-- Problem 3: Reverse String
UPDATE problems SET driver_code = '{"java": "import java.util.*;\n\n{USER_CODE}\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        String line = sc.nextLine().trim();\n        String inner = line.substring(1, line.length() - 1);\n        String[] parts = inner.split(\",\");\n        char[] s = new char[parts.length];\n        for (int i = 0; i < parts.length; i++) s[i] = parts[i].trim().charAt(1);\n        new Solution().reverseString(s);\n        StringBuilder sb = new StringBuilder(\"[\");\n        for (int i = 0; i < s.length; i++) {\n            if (i > 0) sb.append(\",\");\n            sb.append(\"\\''\\''\").append(s[i]).append(\"\\''\\''\");\n        }\n        sb.append(\"]\");\n        System.out.println(sb);\n    }\n}", "python": "{USER_CODE}\n\nimport ast\ns = [c for c in ast.literal_eval(input())]\nSolution().reverseString(s)\nprint(s)"}'
WHERE slug = 'reverse-string';

-- Problem 4: Valid Parentheses
UPDATE problems SET driver_code = '{"java": "import java.util.*;\n\n{USER_CODE}\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        String s = sc.nextLine().trim();\n        boolean result = new Solution().isValid(s);\n        System.out.println(result);\n    }\n}", "python": "{USER_CODE}\n\ns = input().strip()\nresult = Solution().isValid(s)\nprint(str(result).lower())"}'
WHERE slug = 'valid-parentheses';

-- Problem 5: Palindrome Number
UPDATE problems SET driver_code = '{"java": "import java.util.*;\n\n{USER_CODE}\n\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int x = Integer.parseInt(sc.nextLine().trim());\n        boolean result = new Solution().isPalindrome(x);\n        System.out.println(result);\n    }\n}", "python": "{USER_CODE}\n\nx = int(input())\nresult = Solution().isPalindrome(x)\nprint(str(result).lower())"}'
WHERE slug = 'palindrome-number';
