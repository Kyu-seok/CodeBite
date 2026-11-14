class Solution {
    countFlagMismatches(leftFlags, rightFlags) {
        let diff = (leftFlags ^ rightFlags) >>> 0;
        let count = 0;
        while (diff !== 0) {
            count += diff & 1;
            diff >>>= 1;
        }
        return count;
    }
}
