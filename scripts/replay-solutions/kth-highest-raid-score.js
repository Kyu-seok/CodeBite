class Solution {
    kthHighestScore(scores, k) {
        const sorted = [...scores].sort((a, b) => b - a);
        return sorted[k - 1];
    }
}
