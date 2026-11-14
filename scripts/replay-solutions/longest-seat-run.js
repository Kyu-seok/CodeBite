class Solution {
    longestSeatRun(seatIds) {
        const seats = new Set(seatIds);
        let longest = 0;
        for (const seat of seats) {
            if (seats.has(seat - 1)) continue;
            let end = seat;
            while (seats.has(end + 1)) end++;
            longest = Math.max(longest, end - seat + 1);
        }
        return longest;
    }
}
