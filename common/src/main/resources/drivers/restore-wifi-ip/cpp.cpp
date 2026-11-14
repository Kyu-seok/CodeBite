#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string digits;
    getline(cin, digits);
    vector<string> result = Solution().restoreIpAddresses(digits);
    sort(result.begin(), result.end());
    cout << JsonOutput::stringVector(result) << endl;
    return 0;
}
