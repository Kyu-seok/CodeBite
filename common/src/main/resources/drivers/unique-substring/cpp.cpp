#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string s;
    getline(cin, s);
    int result = Solution().lengthOfLongestSubstring(s);
    cout << result << endl;
    return 0;
}
