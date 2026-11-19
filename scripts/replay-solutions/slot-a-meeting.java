class Solution {
    public int[][] insertMeeting(int[][] meetings, int[] newMeeting) {
        List<int[]> result = new ArrayList<>();
        int start = newMeeting[0], end = newMeeting[1];
        int i = 0;
        while (i < meetings.length && meetings[i][1] < start) result.add(meetings[i++]);
        while (i < meetings.length && meetings[i][0] <= end) {
            start = Math.min(start, meetings[i][0]);
            end = Math.max(end, meetings[i][1]);
            i++;
        }
        result.add(new int[]{start, end});
        while (i < meetings.length) result.add(meetings[i++]);
        return result.toArray(new int[0][]);
    }
}
