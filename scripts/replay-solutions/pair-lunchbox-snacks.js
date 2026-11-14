class Solution {
    minLunchboxes(weights, capacity) {
        const sorted = [...weights].sort((a, b) => a - b);
        let light = 0, heavy = sorted.length - 1, boxes = 0;
        while (light <= heavy) {
            if (sorted[light] + sorted[heavy] <= capacity) light++;
            heavy--;
            boxes++;
        }
        return boxes;
    }
}
