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
    vector<vector<string>> result = Solution().partition(s);
    sort(result.begin(), result.end());
    cout << JsonOutput::stringVector2D(result) << endl;
    return 0;
}
