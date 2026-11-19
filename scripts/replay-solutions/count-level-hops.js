class Solution {
    countHopSequences(n) {
        let previous = 1, current = 1;
        for (let i = 1; i < n; i++) {
            [previous, current] = [current, previous + current];
        }
        return current;
    }
}
