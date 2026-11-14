class Solution {
public:
    int countOnlineFriends(int friendMask) {
        unsigned int mask = (unsigned int)friendMask;
        int count = 0;
        while (mask) {
            count += mask & 1u;
            mask >>= 1;
        }
        return count;
    }
};
