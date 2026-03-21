#include <iostream>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    int x;
    cin >> x;
    bool result = Solution().isPalindrome(x);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
