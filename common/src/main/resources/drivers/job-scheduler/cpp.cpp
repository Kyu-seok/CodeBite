#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string jobsLine;
    getline(cin, jobsLine);
    int n;
    cin >> n;
    // Parse ["A","A","B"] -> vector<char>
    vector<char> jobs;
    for (int i = 0; i < (int)jobsLine.size(); i++) {
        if (jobsLine[i] >= 'A' && jobsLine[i] <= 'Z') {
            jobs.push_back(jobsLine[i]);
        }
    }
    int result = Solution().scheduleJobs(jobs, n);
    cout << result << endl;
    return 0;
}
