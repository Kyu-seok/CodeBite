class Solution {
    longestCommonSubsequence(left, right) {
        let previous = new Array(right.length + 1).fill(0);
        for (const a of left) {
            const current = [0];
            for (let j = 0; j < right.length; j++) {
                current.push(a === right[j] ? previous[j] + 1 : Math.max(previous[j + 1], current[j]));
            }
            previous = current;
        }
        return previous[right.length];
    }
}
