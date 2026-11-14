#include <iostream>
using namespace std;

{USER_CODE}

int main() {
    int leftFlags, rightFlags;
    cin >> leftFlags >> rightFlags;
    int result = Solution().countFlagMismatches(leftFlags, rightFlags);
    cout << result << endl;
    return 0;
}
