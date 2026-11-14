class Solution {
public:
    int minLunchboxes(vector<int>& weights, int capacity) {
        vector<int> sorted(weights);
        sort(sorted.begin(), sorted.end());
        int light = 0, heavy = (int)sorted.size() - 1, boxes = 0;
        while (light <= heavy) {
            if (sorted[light] + sorted[heavy] <= capacity) light++;
            heavy--;
            boxes++;
        }
        return boxes;
    }
};
