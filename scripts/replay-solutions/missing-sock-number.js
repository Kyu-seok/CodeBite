class Solution {
    smallestMissingNumber(socks) {
        const n = socks.length;
        for (let i = 0; i < n; i++) {
            while (socks[i] >= 1 && socks[i] <= n && socks[socks[i] - 1] !== socks[i]) {
                const home = socks[i] - 1;
                [socks[i], socks[home]] = [socks[home], socks[i]];
            }
        }
        for (let i = 0; i < n; i++) {
            if (socks[i] !== i + 1) return i + 1;
        }
        return n + 1;
    }
}
