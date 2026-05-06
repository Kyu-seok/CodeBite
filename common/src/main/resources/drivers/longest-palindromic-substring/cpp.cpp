#include <iostream>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string s;
    getline(cin, s);
    int result = Solution().longestPalindrome(s);
    cout << result << endl;
    return 0;
}
