class Solution {
    public boolean canSplitEqually(int[] tickets) {
        int total = 0;
        for (int t : tickets) total += t;
        if (total % 2 != 0) return false;
        boolean[] reachable = new boolean[total / 2 + 1];
        reachable[0] = true;
        for (int t : tickets)
            for (int s = total / 2; s >= t; s--)
                if (reachable[s - t]) reachable[s] = true;
        return reachable[total / 2];
    }
}
