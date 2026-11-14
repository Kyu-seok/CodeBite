class Solution {
    longestTwoFlavorStretch(treats) {
        const count = new Map(); // treats of each flavor in treats[left..right]
        let best = 0, left = 0;
        for (let right = 0; right < treats.length; right++) {
            count.set(treats[right], (count.get(treats[right]) || 0) + 1);
            while (count.size > 2) {
                const out = treats[left++];
                count.set(out, count.get(out) - 1);
                if (count.get(out) === 0) count.delete(out);
            }
            best = Math.max(best, right - left + 1);
        }
        return best;
    }
}
