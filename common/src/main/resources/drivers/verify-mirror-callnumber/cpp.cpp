#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <cctype>
using namespace std;

{USER_CODE}

int main() {
    string s;
    getline(cin, s);
    bool result = Solution().verifyMirrorCode(s);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
