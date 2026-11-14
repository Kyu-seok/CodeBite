class Solution {
    public String spaceBakes(String cookies) {
        int n = cookies.length();
        int[] counts = new int[26];
        for (char c : cookies.toCharArray()) counts[c - 'a']++;
        Integer[] kinds = new Integer[26];
        for (int i = 0; i < 26; i++) kinds[i] = i;
        java.util.Arrays.sort(kinds, (a, b) -> counts[b] != counts[a] ? counts[b] - counts[a] : a - b);
        if (counts[kinds[0]] > (n + 1) / 2) return "";
        char[] result = new char[n];
        int slot = 0;
        for (int kind : kinds) {
            for (int k = 0; k < counts[kind]; k++) {
                if (slot >= n) slot = 1;
                result[slot] = (char) ('a' + kind);
                slot += 2;
            }
        }
        return new String(result);
    }
}
