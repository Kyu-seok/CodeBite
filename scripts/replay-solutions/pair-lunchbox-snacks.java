class Solution {
    public int minLunchboxes(int[] weights, int capacity) {
        int[] sorted = weights.clone();
        Arrays.sort(sorted);
        int light = 0, heavy = sorted.length - 1, boxes = 0;
        while (light <= heavy) {
            if (sorted[light] + sorted[heavy] <= capacity) light++;
            heavy--;
            boxes++;
        }
        return boxes;
    }
}
