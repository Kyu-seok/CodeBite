#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <algorithm>
using namespace std;

{USER_CODE}

int main() {
    string s;
    getline(cin, s);
    string result = Solution().reverseWords(s);
    cout << result << endl;
    return 0;
}
