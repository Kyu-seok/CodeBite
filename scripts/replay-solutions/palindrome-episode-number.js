class Solution {
    isPalindrome(episode) {
        const text = String(episode);
        return text.split('').reverse().join('') === text;
    }
}
