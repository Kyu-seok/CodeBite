class Solution {
    /**
     * @param {string} feed
     * @return {number}
     */
    longestGenreWindow(feed) {
        const lastSeen = new Map();
        let start = 0;
        let best = 0;
        for (let i = 0; i < feed.length; i++) {
            const tag = feed[i];
            if (lastSeen.has(tag) && lastSeen.get(tag) >= start) {
                start = lastSeen.get(tag) + 1;
            }
            lastSeen.set(tag, i);
            best = Math.max(best, i - start + 1);
        }
        return best;
    }
}
