class Solution {
public:
    int countCarPacks(int target, vector<int>& position, vector<int>& speed) {
        int n = position.size();
        vector<int> order(n);
        for (int i = 0; i < n; i++) order[i] = i;
        sort(order.begin(), order.end(), [&](int a, int b) { return position[a] > position[b]; });
        int packs = 0;
        long long leadDistance = 0, leadSpeed = 1;
        for (int i : order) {
            long long distance = target - position[i];
            if (distance * leadSpeed > leadDistance * speed[i]) {
                packs++;
                leadDistance = distance;
                leadSpeed = speed[i];
            }
        }
        return packs;
    }
};
