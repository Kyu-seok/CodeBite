class Solution {
    daysUntilWarmer(readings) {
        const wait = new Array(readings.length).fill(0);
        const pending = [];
        for (let day = 0; day < readings.length; day++) {
            while (pending.length && readings[pending[pending.length - 1]] < readings[day]) {
                const earlier = pending.pop();
                wait[earlier] = day - earlier;
            }
            pending.push(day);
        }
        return wait;
    }
}
