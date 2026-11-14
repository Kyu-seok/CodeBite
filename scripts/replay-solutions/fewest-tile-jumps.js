class Solution {
    minJumps(maxJump) {
        let jumps = 0, currentEnd = 0, farthest = 0;
        for (let i = 0; i < maxJump.length - 1; i++) {
            farthest = Math.max(farthest, i + maxJump[i]);
            if (i === currentEnd) {
                jumps++;
                currentEnd = farthest;
            }
        }
        return jumps;
    }
}
