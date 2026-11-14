class Solution {
    public String recoverTierOrder(String[] tags) {
        TreeSet<Character> letters = new TreeSet<>();
        for (String tag : tags) for (char ch : tag.toCharArray()) letters.add(ch);
        Map<Character, Set<Character>> after = new HashMap<>();
        Map<Character, Integer> indegree = new HashMap<>();
        for (char ch : letters) { after.put(ch, new HashSet<>()); indegree.put(ch, 0); }
        for (int i = 0; i + 1 < tags.length; i++) {
            String first = tags[i], second = tags[i + 1];
            int len = Math.min(first.length(), second.length());
            int j = 0;
            while (j < len && first.charAt(j) == second.charAt(j)) j++;
            if (j == len) {
                if (first.length() > second.length()) return "";
            } else if (after.get(first.charAt(j)).add(second.charAt(j))) {
                indegree.merge(second.charAt(j), 1, Integer::sum);
            }
        }
        PriorityQueue<Character> ready = new PriorityQueue<>();
        for (char ch : letters) if (indegree.get(ch) == 0) ready.add(ch);
        StringBuilder order = new StringBuilder();
        while (!ready.isEmpty()) {
            char ch = ready.poll();
            order.append(ch);
            for (char next : after.get(ch)) {
                if (indegree.merge(next, -1, Integer::sum) == 0) ready.add(next);
            }
        }
        return order.length() == letters.size() ? order.toString() : "";
    }
}
