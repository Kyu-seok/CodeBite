class Solution {
public:
    int countFlagMismatches(int leftFlags, int rightFlags) {
        unsigned int diff = (unsigned int) (leftFlags ^ rightFlags);
        int count = 0;
        while (diff != 0) {
            count += diff & 1;
            diff >>= 1;
        }
        return count;
    }
};
