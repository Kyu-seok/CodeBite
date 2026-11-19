class Solution {
    canFinishLevel(jumps) {
        let farthest = 0;
        for (let tile = 0; tile < jumps.length; tile++) {
            if (tile > farthest) return false;
            farthest = Math.max(farthest, tile + jumps[tile]);
        }
        return true;
    }
}
