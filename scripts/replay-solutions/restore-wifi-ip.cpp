#include <vector>
#include <string>
using namespace std;

class Solution {
public:
    vector<string> restoreIpAddresses(string digits) {
        vector<string> addresses;
        int len = digits.size();
        for (int a = 1; a <= 3; a++)
            for (int b = a + 1; b <= a + 3; b++)
                for (int c = b + 1; c <= b + 3; c++) {
                    if (c >= len) continue;
                    string p1 = digits.substr(0, a), p2 = digits.substr(a, b - a),
                           p3 = digits.substr(b, c - b), p4 = digits.substr(c);
                    if (valid(p1) && valid(p2) && valid(p3) && valid(p4))
                        addresses.push_back(p1 + "." + p2 + "." + p3 + "." + p4);
                }
        return addresses;
    }

private:
    bool valid(const string& segment) {
        if (segment.empty() || segment.size() > 3) return false;
        if (segment.size() > 1 && segment[0] == '0') return false;
        return stoi(segment) <= 255;
    }
};
