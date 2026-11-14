#include <iostream>
using namespace std;

{USER_CODE}

int main() {
    unsigned int friendMask;
    cin >> friendMask;
    int result = Solution().countOnlineFriends((int)friendMask);
    cout << result << endl;
    return 0;
}
