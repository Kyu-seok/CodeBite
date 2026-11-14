class Solution {
    public boolean isPalindrome(String phrase) {
        int left = 0, right = phrase.length() - 1;
        while (left < right) {
            char a = phrase.charAt(left), b = phrase.charAt(right);
            if (!Character.isLetterOrDigit(a)) left++;
            else if (!Character.isLetterOrDigit(b)) right--;
            else {
                if (Character.toLowerCase(a) != Character.toLowerCase(b)) return false;
                left++;
                right--;
            }
        }
        return true;
    }
}
