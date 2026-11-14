class Solution {
    public boolean isPalindrome(int episode) {
        String text = Integer.toString(episode);
        return new StringBuilder(text).reverse().toString().equals(text);
    }
}
