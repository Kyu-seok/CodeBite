#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <cctype>
using namespace std;

{USER_CODE}

int main() {
    string phrase;
    getline(cin, phrase);
    bool result = Solution().isPalindrome(phrase);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
