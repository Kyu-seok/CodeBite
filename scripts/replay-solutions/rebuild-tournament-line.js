class Solution {
    rebuildLine(players) {
        const sorted = [...players].sort((a, b) => (a[0] !== b[0] ? b[0] - a[0] : a[1] - b[1]));
        const line = [];
        for (const player of sorted) line.splice(player[1], 0, player);
        return line;
    }
}
