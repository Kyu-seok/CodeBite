class Solution {
    public int fewestBags(int candies) {
        int[] fewest = new int[candies + 1];
        for (int a = 1; a <= candies; a++) {
            fewest[a] = a;
            for (int s = 1; s * s <= a; s++) fewest[a] = Math.min(fewest[a], fewest[a - s * s] + 1);
        }
        return fewest[candies];
    }
}
