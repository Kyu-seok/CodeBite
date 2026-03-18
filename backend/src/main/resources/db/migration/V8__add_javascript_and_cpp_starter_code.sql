-- Add JavaScript and C++ starter code for all 5 problems
-- Full replacement of starter_code JSON (includes existing java/python keys)

-- Problem 1: Two Sum
UPDATE problems SET starter_code = '{"java": "class Solution {\n    public int[] twoSum(int[] nums, int target) {\n        // Write your solution here\n    }\n}", "python": "class Solution:\n    def twoSum(self, nums: list[int], target: int) -> list[int]:\n        # Write your solution here\n        pass", "javascript": "class Solution {\n    /**\n     * @param {number[]} nums\n     * @param {number} target\n     * @return {number[]}\n     */\n    twoSum(nums, target) {\n        // Write your solution here\n    }\n}", "cpp": "class Solution {\npublic:\n    vector<int> twoSum(vector<int>& nums, int target) {\n        // Write your solution here\n    }\n};"}'
WHERE slug = 'two-sum';

-- Problem 2: FizzBuzz
UPDATE problems SET starter_code = '{"java": "class Solution {\n    public List<String> fizzBuzz(int n) {\n        // Write your solution here\n    }\n}", "python": "class Solution:\n    def fizzBuzz(self, n: int) -> list[str]:\n        # Write your solution here\n        pass", "javascript": "class Solution {\n    /**\n     * @param {number} n\n     * @return {string[]}\n     */\n    fizzBuzz(n) {\n        // Write your solution here\n    }\n}", "cpp": "class Solution {\npublic:\n    vector<string> fizzBuzz(int n) {\n        // Write your solution here\n    }\n};"}'
WHERE slug = 'fizzbuzz';

-- Problem 3: Reverse String
UPDATE problems SET starter_code = '{"java": "class Solution {\n    public void reverseString(char[] s) {\n        // Write your solution here\n    }\n}", "python": "class Solution:\n    def reverseString(self, s: list[str]) -> None:\n        # Write your solution here\n        pass", "javascript": "class Solution {\n    /**\n     * @param {string[]} s\n     * @return {void}\n     */\n    reverseString(s) {\n        // Write your solution here\n    }\n}", "cpp": "class Solution {\npublic:\n    void reverseString(vector<char>& s) {\n        // Write your solution here\n    }\n};"}'
WHERE slug = 'reverse-string';

-- Problem 4: Valid Parentheses
UPDATE problems SET starter_code = '{"java": "class Solution {\n    public boolean isValid(String s) {\n        // Write your solution here\n    }\n}", "python": "class Solution:\n    def isValid(self, s: str) -> bool:\n        # Write your solution here\n        pass", "javascript": "class Solution {\n    /**\n     * @param {string} s\n     * @return {boolean}\n     */\n    isValid(s) {\n        // Write your solution here\n    }\n}", "cpp": "class Solution {\npublic:\n    bool isValid(string s) {\n        // Write your solution here\n    }\n};"}'
WHERE slug = 'valid-parentheses';

-- Problem 5: Palindrome Number
UPDATE problems SET starter_code = '{"java": "class Solution {\n    public boolean isPalindrome(int x) {\n        // Write your solution here\n    }\n}", "python": "class Solution:\n    def isPalindrome(self, x: int) -> bool:\n        # Write your solution here\n        pass", "javascript": "class Solution {\n    /**\n     * @param {number} x\n     * @return {boolean}\n     */\n    isPalindrome(x) {\n        // Write your solution here\n    }\n}", "cpp": "class Solution {\npublic:\n    bool isPalindrome(int x) {\n        // Write your solution here\n    }\n};"}'
WHERE slug = 'palindrome-number';
