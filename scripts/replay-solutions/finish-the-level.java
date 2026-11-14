class Solution {
    public boolean canFinishLevel(int[] jumps) {
        int farthest = 0;
        for (int tile = 0; tile < jumps.length; tile++) {
            if (tile > farthest) return false;
            farthest = Math.max(farthest, tile + jumps[tile]);
        }
        return true;
    }
}
