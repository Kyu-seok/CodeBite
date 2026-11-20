class Solution {
    public String shortestShelfSpan(String shelf, String needed) {
        if (needed.isEmpty()) return "";
        Map<Character, Integer> missing = new HashMap<>();
        for (char tag : needed.toCharArray()) missing.merge(tag, 1, Integer::sum);
        int toCover = needed.length();
        int start = 0;
        int bestStart = 0, bestLen = shelf.length() + 1;
        for (int end = 0; end < shelf.length(); end++) {
            char tag = shelf.charAt(end);
            if (missing.getOrDefault(tag, 0) > 0) toCover--;
            missing.merge(tag, -1, Integer::sum);
            while (toCover == 0) {
                if (end - start + 1 < bestLen) {
                    bestStart = start;
                    bestLen = end - start + 1;
                }
                if (missing.merge(shelf.charAt(start), 1, Integer::sum) > 0) toCover++;
                start++;
            }
        }
        return bestLen <= shelf.length() ? shelf.substring(bestStart, bestStart + bestLen) : "";
    }
}
