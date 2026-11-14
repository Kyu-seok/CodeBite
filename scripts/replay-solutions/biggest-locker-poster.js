class Solution {
    largestPosterArea(lockers) {
        let left = 0, right = lockers.length - 1, best = 0;
        while (left < right) {
            best = Math.max(best, Math.min(lockers[left], lockers[right]) * (right - left));
            if (lockers[left] < lockers[right]) left++;
            else right--;
        }
        return best;
    }
}
