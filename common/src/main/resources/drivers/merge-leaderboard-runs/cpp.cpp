#include <iostream>
#include <string>
#include <sstream>
using namespace std;

// {{LIB:ListNode}}

{USER_CODE}

int main() {
    string line1, line2;
    getline(cin, line1);
    getline(cin, line2);
    ListNode* runA = listFromArray(line1);
    ListNode* runB = listFromArray(line2);
    ListNode* result = Solution().mergeRuns(runA, runB);
    cout << listToJsonArray(result) << endl;
    return 0;
}
