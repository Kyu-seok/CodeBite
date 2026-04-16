#include <iostream>
#include <vector>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string s, t;
    getline(cin, s);
    getline(cin, t);
    long long result = Solution().numDistinct(s, t);
    cout << result << endl;
    return 0;
}
