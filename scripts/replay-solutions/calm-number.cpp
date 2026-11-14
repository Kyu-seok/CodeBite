class Solution {
public:
    bool isCalm(int reading) {
        unordered_set<int> seen;
        while (reading != 1 && seen.insert(reading).second) {
            int next = 0;
            for (int x = reading; x > 0; x /= 10) next += (x % 10) * (x % 10);
            reading = next;
        }
        return reading == 1;
    }
};
