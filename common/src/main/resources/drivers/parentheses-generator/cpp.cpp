#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    int n;
    cin >> n;
    vector<string> result = Solution().generateParenthesis(n);
    sort(result.begin(), result.end());
    cout << JsonOutput::stringVector(result) << endl;
    return 0;
}
