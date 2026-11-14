class Solution {
    public boolean canGroupCards(int[] cards, int groupSize) {
        if (cards.length % groupSize != 0) return false;
        TreeMap<Integer, Integer> left = new TreeMap<>();
        for (int card : cards) left.merge(card, 1, Integer::sum);
        for (int start : new ArrayList<>(left.keySet())) {
            int groups = left.get(start);
            if (groups == 0) continue;
            for (int card = start; card < start + groupSize; card++) {
                int have = left.getOrDefault(card, 0);
                if (have < groups) return false;
                left.put(card, have - groups);
            }
        }
        return true;
    }
}
