#include <iostream>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string digits;
    getline(cin, digits);
    int result = Solution().countDecodings(digits);
    cout << result << endl;
    return 0;
}
