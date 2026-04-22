#include <iostream>
#include <vector>
#include <string>
#include <stack>
#include <unordered_map>
using namespace std;

{USER_CODE}

int main() {
    string s;
    getline(cin, s);
    bool result = Solution().verifyJobNesting(s);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
