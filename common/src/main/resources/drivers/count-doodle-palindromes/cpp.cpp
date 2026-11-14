#include <iostream>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string doodle;
    getline(cin, doodle);
    int result = Solution().countPalindromicSubstrings(doodle);
    cout << result << endl;
    return 0;
}
