#include <iostream>
#include <string>
#include <vector>
using namespace std;

{USER_CODE}

int main() {
    string text1, text2;
    getline(cin, text1);
    getline(cin, text2);
    int result = Solution().longestCommonSubsequence(text1, text2);
    cout << result << endl;
    return 0;
}
