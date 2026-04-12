#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string s, t;
    getline(cin, s);
    getline(cin, t);
    string result = Solution().minWindow(s, t);
    cout << result << endl;
    return 0;
}
