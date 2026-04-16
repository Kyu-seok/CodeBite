#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string s;
    getline(cin, s);
    vector<string> result = Solution().restoreIpAddresses(s);
    sort(result.begin(), result.end());
    cout << JsonOutput::stringVector(result) << endl;
    return 0;
}
