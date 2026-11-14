class Solution {
public:
    int countHopSequences(int n) {
        int previous = 1, current = 1;
        for (int i = 1; i < n; i++) {
            int next = previous + current;
            previous = current;
            current = next;
        }
        return current;
    }
};
