#include <iostream>
#include <vector>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string s1, s2;
    getline(cin, s1);
    getline(cin, s2);
    bool result = Solution().checkInclusion(s1, s2);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
