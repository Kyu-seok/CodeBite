#include <iostream>
#include <vector>
#include <string>
#include <stack>
#include <unordered_map>
using namespace std;

{USER_CODE}

int main() {
    string brackets;
    getline(cin, brackets);
    bool result = Solution().isValidBrackets(brackets);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
