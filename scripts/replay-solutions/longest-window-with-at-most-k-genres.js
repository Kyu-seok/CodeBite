class Solution {
    longestKGenreWindow(queue, k) {
        if (k === 0) return 0;
        const count = new Map(); // tags of each genre in the window queue[left..right]
        let best = 0, left = 0;
        for (let right = 0; right < queue.length; right++) {
            const tag = queue[right];
            count.set(tag, (count.get(tag) || 0) + 1);
            while (count.size > k) {
                const out = queue[left++];
                count.set(out, count.get(out) - 1);
                if (count.get(out) === 0) count.delete(out);
            }
            best = Math.max(best, right - left + 1);
        }
        return best;
    }
}
