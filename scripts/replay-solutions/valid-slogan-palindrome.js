class Solution {
    isPalindrome(phrase) {
        const cleaned = phrase.toLowerCase().replace(/[^a-z0-9]/g, '');
        return cleaned === cleaned.split('').reverse().join('');
    }
}
