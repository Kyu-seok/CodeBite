class Solution {
    public List<String> rankTrendingTopics(String[] topics, int k) {
        Map<String, Integer> counts = new HashMap<>();
        for (String topic : topics) counts.merge(topic, 1, Integer::sum);
        List<String> ranked = new ArrayList<>(counts.keySet());
        ranked.sort((a, b) -> !counts.get(a).equals(counts.get(b))
                ? Integer.compare(counts.get(b), counts.get(a))
                : a.compareTo(b));
        return new ArrayList<>(ranked.subList(0, Math.min(k, ranked.size())));
    }
}
