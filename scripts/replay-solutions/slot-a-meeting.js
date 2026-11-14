class Solution {
    insertMeeting(meetings, newMeeting) {
        const result = [];
        let [start, end] = newMeeting;
        let i = 0;
        while (i < meetings.length && meetings[i][1] < start) result.push(meetings[i++]);
        while (i < meetings.length && meetings[i][0] <= end) {
            start = Math.min(start, meetings[i][0]);
            end = Math.max(end, meetings[i][1]);
            i++;
        }
        result.push([start, end]);
        while (i < meetings.length) result.push(meetings[i++]);
        return result;
    }
}
