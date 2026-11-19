class Solution {
    countOnlineFriends(friendMask) {
        let count = 0;
        let mask = friendMask >>> 0;
        while (mask !== 0) {
            count += mask & 1;
            mask >>>= 1;
        }
        return count;
    }
}
