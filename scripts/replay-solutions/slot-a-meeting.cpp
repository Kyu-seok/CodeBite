#include <algorithm>
#include <vector>
using namespace std;

class Solution {
public:
    vector<vector<int>> insertMeeting(vector<vector<int>>& meetings, vector<int>& newMeeting) {
        vector<vector<int>> result;
        int start = newMeeting[0], end = newMeeting[1];
        size_t i = 0;
        while (i < meetings.size() && meetings[i][1] < start) result.push_back(meetings[i++]);
        while (i < meetings.size() && meetings[i][0] <= end) {
            start = min(start, meetings[i][0]);
            end = max(end, meetings[i][1]);
            i++;
        }
        result.push_back({start, end});
        while (i < meetings.size()) result.push_back(meetings[i++]);
        return result;
    }
};
