#include <iostream>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string s1, s2, s3;
    getline(cin, s1);
    getline(cin, s2);
    getline(cin, s3);
    bool result = Solution().checkMergedQueue(s1, s2, s3);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
