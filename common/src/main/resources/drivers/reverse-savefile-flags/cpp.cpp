#include <iostream>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    unsigned long statusWord;
    cin >> statusWord;
    unsigned long result = Solution().reverseFlags(statusWord);
    cout << result << endl;
    return 0;
}
