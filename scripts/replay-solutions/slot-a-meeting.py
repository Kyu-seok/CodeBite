class Solution:
    def insertMeeting(self, meetings: list[list[int]], newMeeting: list[int]) -> list[list[int]]:
        start, end = newMeeting
        result: list[list[int]] = []
        i = 0
        while i < len(meetings) and meetings[i][1] < start:
            result.append(meetings[i])
            i += 1
        while i < len(meetings) and meetings[i][0] <= end:
            start = min(start, meetings[i][0])
            end = max(end, meetings[i][1])
            i += 1
        result.append([start, end])
        result.extend(meetings[i:])
        return result
