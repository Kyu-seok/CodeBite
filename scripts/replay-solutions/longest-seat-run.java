class Solution {
    public int longestSeatRun(int[] seatIds) {
        Set<Integer> seats = new HashSet<>();
        for (int seat : seatIds) seats.add(seat);
        int longest = 0;
        for (int seat : seats) {
            if (seats.contains(seat - 1)) continue;
            int end = seat;
            while (seats.contains(end + 1)) end++;
            longest = Math.max(longest, end - seat + 1);
        }
        return longest;
    }
}
