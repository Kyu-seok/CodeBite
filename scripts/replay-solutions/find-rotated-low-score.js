class Solution {
    findLowestScore(scores) {
        let low = 0, high = scores.length - 1;
        while (low < high) {
            const mid = Math.floor((low + high) / 2);
            if (scores[mid] > scores[high]) low = mid + 1;
            else high = mid;
        }
        return scores[low];
    }
}
