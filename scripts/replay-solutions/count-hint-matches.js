class Solution {
    countHintMatches(notes, target) {
        const m = target.length;
        const ways = new Array(m + 1).fill(0n);
        ways[0] = 1n;
        for (const letter of notes) {
            for (let j = m; j >= 1; j--) if (target[j - 1] === letter) ways[j] += ways[j - 1];
        }
        return ways[m].toString();
    }
}
