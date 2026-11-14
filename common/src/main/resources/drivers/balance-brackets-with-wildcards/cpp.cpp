#include <iostream>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string brackets;
    getline(cin, brackets);
    bool result = Solution().canBalance(brackets);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
