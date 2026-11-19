#include <iostream>
#include <string>
#include <vector>
using namespace std;

{USER_CODE}

int main() {
    string left, right;
    getline(cin, left);
    getline(cin, right);
    int result = Solution().longestCommonSubsequence(left, right);
    cout << result << endl;
    return 0;
}
