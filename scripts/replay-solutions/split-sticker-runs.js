class Solution {
    splitStickerRuns(stickers) {
        const last = {};
        for (let i = 0; i < stickers.length; i++) last[stickers[i]] = i;
        const sizes = [];
        let start = 0, end = 0;
        for (let i = 0; i < stickers.length; i++) {
            end = Math.max(end, last[stickers[i]]);
            if (i === end) { // every letter seen in this run has finished
                sizes.push(end - start + 1);
                start = i + 1;
            }
        }
        return sizes;
    }
}
