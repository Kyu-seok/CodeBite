class Solution {
public:
    int minutesUntilStale(vector<vector<int>>& tray) {
        int rows = tray.size(), cols = tray[0].size(), fresh = 0;
        vector<pair<int, int>> stale;
        for (int r = 0; r < rows; r++)
            for (int c = 0; c < cols; c++) {
                if (tray[r][c] == 1) fresh++;
                else if (tray[r][c] == 2) stale.push_back({r, c});
            }
        int minutes = 0;
        int dr[] = {1, -1, 0, 0}, dc[] = {0, 0, 1, -1};
        while (!stale.empty() && fresh > 0) {
            vector<pair<int, int>> next;
            for (auto& p : stale) {
                for (int d = 0; d < 4; d++) {
                    int nr = p.first + dr[d], nc = p.second + dc[d];
                    if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && tray[nr][nc] == 1) {
                        tray[nr][nc] = 2;
                        fresh--;
                        next.push_back({nr, nc});
                    }
                }
            }
            stale = next;
            minutes++;
        }
        return fresh > 0 ? -1 : minutes;
    }
};
