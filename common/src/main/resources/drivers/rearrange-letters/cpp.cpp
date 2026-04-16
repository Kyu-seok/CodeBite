#include <iostream>
#include <string>
#include <algorithm>
using namespace std;

{USER_CODE}

int main() {
    string s;
    getline(cin, s);
    string result = Solution().rearrangeLetters(s);
    if (result.empty()) {
        cout << "" << endl;
    } else {
        string sortedOrig = s;
        string sortedRes = result;
        sort(sortedOrig.begin(), sortedOrig.end());
        sort(sortedRes.begin(), sortedRes.end());
        bool freqOk = (sortedOrig == sortedRes);
        bool noAdj = true;
        for (int i = 1; i < (int)result.size(); i++) {
            if (result[i] == result[i - 1]) { noAdj = false; break; }
        }
        if (freqOk && noAdj) {
            cout << "valid" << endl;
        } else {
            cout << "INVALID:" << result << endl;
        }
    }
    return 0;
}
