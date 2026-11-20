class Solution {
    public int[] findTightestBooking(int[][] bookings, int[] probes) {
        int[][] byStart = bookings.clone();
        Arrays.sort(byStart, (a, b) -> Integer.compare(a[0], b[0]));
        Integer[] order = new Integer[probes.length];
        for (int i = 0; i < order.length; i++) order[i] = i;
        Arrays.sort(order, (a, b) -> Integer.compare(probes[a], probes[b]));
        int[] answers = new int[probes.length];
        // {length, end} of every booking starting by now
        PriorityQueue<int[]> started = new PriorityQueue<>((a, b) -> Integer.compare(a[0], b[0]));
        int next = 0;
        // Answer probes in time order, adding bookings as they start and dropping those already over.
        for (int index : order) {
            int minute = probes[index];
            while (next < byStart.length && byStart[next][0] <= minute) {
                started.add(new int[] {byStart[next][1] - byStart[next][0] + 1, byStart[next][1]});
                next++;
            }
            while (!started.isEmpty() && started.peek()[1] < minute) started.poll();
            answers[index] = started.isEmpty() ? -1 : started.peek()[0];
        }
        return answers;
    }
}
