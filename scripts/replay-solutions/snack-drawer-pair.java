class Solution {
    public int[] findPairIndices(int[] snacks, int target) {
        Map<Integer, Integer> seen = new HashMap<>();
        for (int i = 0; i < snacks.length; i++) {
            Integer partner = seen.get(target - snacks[i]);
            if (partner != null) return new int[] {partner, i};
            seen.put(snacks[i], i);
        }
        return new int[0];
    }
}
