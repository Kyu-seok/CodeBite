#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <iomanip>
using namespace std;

{USER_CODE}

vector<int> parseIntArray(const string& s) {
    vector<int> result;
    string inner = s.substr(1, s.size() - 2);
    if (inner.empty()) return result;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        result.push_back(stoi(token));
    }
    return result;
}

int main() {
    string line1, line2;
    getline(cin, line1);
    getline(cin, line2);
    vector<int> nums1 = parseIntArray(line1);
    vector<int> nums2 = parseIntArray(line2);
    double result = Solution().findMedian(nums1, nums2);
    cout << fixed << setprecision(1) << result << endl;
    return 0;
}
