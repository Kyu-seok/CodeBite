class Solution {
    public boolean isAnagram(String s, String t) {
        Map<Integer, Integer> counts = new HashMap<>();
        s.codePoints().forEach(letter -> counts.merge(letter, 1, Integer::sum));
        t.codePoints().forEach(letter -> counts.merge(letter, -1, Integer::sum));
        for (int count : counts.values()) {
            if (count != 0) return false;
        }
        return true;
    }
}
