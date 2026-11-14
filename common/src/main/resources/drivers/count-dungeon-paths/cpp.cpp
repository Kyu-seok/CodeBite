#include <iostream>
#include <vector>
using namespace std;

{USER_CODE}

int main() {
    int rows, cols;
    cin >> rows >> cols;
    int result = Solution().countPaths(rows, cols);
    cout << result << endl;
    return 0;
}
