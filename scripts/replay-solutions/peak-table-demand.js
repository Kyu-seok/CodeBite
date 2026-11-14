class Solution {
    minTables(visits) {
        const arrive = visits.map(v => v[0]).sort((a, b) => a - b);
        const leave = visits.map(v => v[1]).sort((a, b) => a - b);
        let seated = 0, most = 0, j = 0;
        for (let i = 0; i < arrive.length; i++) {
            while (leave[j] <= arrive[i]) { j++; seated--; }
            seated++;
            most = Math.max(most, seated);
        }
        return most;
    }
}
