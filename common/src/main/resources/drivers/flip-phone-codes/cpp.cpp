#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
using namespace std;

{USER_CODE}

int main() {
    string digits;
    getline(cin, digits);
    vector<string> result = Solution().mapKeypadCodes(digits);
    sort(result.begin(), result.end());
    cout << "[";
    for (int i = 0; i < (int)result.size(); i++) {
        if (i > 0) cout << ",";
        cout << "\"" << result[i] << "\"";
    }
    cout << "]" << endl;
    return 0;
}
