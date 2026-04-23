#include <iostream>
#include <vector>
#include <string>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    int n;
    cin >> n;
    vector<int> result = Solution().tallyPriorityFlags(n);
    cout << JsonOutput::intVector(result) << endl;
    return 0;
}
