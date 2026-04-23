#include <iostream>
#include <vector>
#include <string>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string s;
    getline(cin, s);
    vector<int> result = Solution().splitZoneRuns(s);
    cout << JsonOutput::intVector(result) << endl;
    return 0;
}
