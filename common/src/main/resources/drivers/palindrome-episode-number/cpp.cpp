#include <iostream>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    int episode;
    cin >> episode;
    bool result = Solution().isPalindrome(episode);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
