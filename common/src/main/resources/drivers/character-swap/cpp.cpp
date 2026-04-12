#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string s;
    getline(cin, s);
    int k;
    cin >> k;
    int result = Solution().characterReplacement(s, k);
    cout << result << endl;
    return 0;
}
