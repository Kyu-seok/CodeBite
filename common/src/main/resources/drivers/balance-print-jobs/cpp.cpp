#include <iostream>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string s;
    getline(cin, s);
    bool result = Solution().canBalanceJobs(s);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
