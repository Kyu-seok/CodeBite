#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string s;
    getline(cin, s);
    bool result = Solution().isPalindrome(s);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
