#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    int pairCount;
    cin >> pairCount;
    vector<string> result = Solution().listBracketPairings(pairCount);
    sort(result.begin(), result.end());
    cout << JsonOutput::stringVector(result) << endl;
    return 0;
}
