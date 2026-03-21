#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    int numRows;
    cin >> numRows;
    vector<vector<int>> result = Solution().generate(numRows);
    cout << JsonOutput::intVector2D(result) << endl;
    return 0;
}
