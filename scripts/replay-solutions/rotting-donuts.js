class Solution {
    minutesUntilStale(tray) {
        const rows = tray.length, cols = tray[0].length;
        let fresh = 0;
        let stale = [];
        for (let r = 0; r < rows; r++)
            for (let c = 0; c < cols; c++) {
                if (tray[r][c] === 1) fresh++;
                else if (tray[r][c] === 2) stale.push([r, c]);
            }
        let minutes = 0;
        while (stale.length > 0 && fresh > 0) {
            const next = [];
            for (const [r, c] of stale) {
                for (const [nr, nc] of [[r + 1, c], [r - 1, c], [r, c + 1], [r, c - 1]]) {
                    if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && tray[nr][nc] === 1) {
                        tray[nr][nc] = 2;
                        fresh--;
                        next.push([nr, nc]);
                    }
                }
            }
            stale = next;
            minutes++;
        }
        return fresh > 0 ? -1 : minutes;
    }
}
