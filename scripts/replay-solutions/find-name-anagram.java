class Solution {
    public boolean containsNameAnagram(String pattern, String log) {
        int size = pattern.length();
        if (size > log.length()) return false;
        int[] diff = new int[26];
        for (int i = 0; i < size; i++) {
            diff[pattern.charAt(i) - 'a']++;
            diff[log.charAt(i) - 'a']--;
        }
        if (allZero(diff)) return true;
        for (int i = size; i < log.length(); i++) {
            diff[log.charAt(i) - 'a']--;
            diff[log.charAt(i - size) - 'a']++;
            if (allZero(diff)) return true;
        }
        return false;
    }

    private boolean allZero(int[] counts) {
        for (int c : counts) if (c != 0) return false;
        return true;
    }
}
