class Solution {
    /**
     * @param {number[][]} bookings
     * @return {boolean}
     */
    verifyTableBookings(bookings) {
        const sorted = bookings.slice().sort((a, b) => a[0] - b[0]);
        for (let i = 1; i < sorted.length; i++) {
            if (sorted[i - 1][1] > sorted[i][0]) return false;
        }
        return true;
    }
}
