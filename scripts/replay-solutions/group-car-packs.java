class Solution {
    public int countCarPacks(int target, int[] position, int[] speed) {
        int n = position.length;
        Integer[] order = new Integer[n];
        for (int i = 0; i < n; i++) order[i] = i;
        Arrays.sort(order, (a, b) -> position[b] - position[a]);
        int packs = 0;
        long leadDistance = 0, leadSpeed = 1;
        for (int i : order) {
            long distance = target - position[i];
            if (distance * leadSpeed > leadDistance * speed[i]) {
                packs++;
                leadDistance = distance;
                leadSpeed = speed[i];
            }
        }
        return packs;
    }
}
