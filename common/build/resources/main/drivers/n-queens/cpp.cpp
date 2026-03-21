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
    vector<vector<string>> result = Solution().solveNQueens(n);
    sort(result.begin(), result.end());
    cout << JsonOutput::stringVector2D(result) << endl;
    return 0;
}
