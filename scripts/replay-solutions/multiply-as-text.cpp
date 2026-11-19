#include <string>
#include <vector>
using namespace std;

class Solution {
public:
    string productAsText(string left, string right) {
        vector<int> digits(left.size() + right.size(), 0);
        for (int i = (int)left.size() - 1; i >= 0; i--) {
            for (int j = (int)right.size() - 1; j >= 0; j--) {
                int sum = digits[i + j + 1] + (left[i] - '0') * (right[j] - '0');
                digits[i + j + 1] = sum % 10;
                digits[i + j] += sum / 10;
            }
        }
        string out;
        for (int d : digits) if (!out.empty() || d != 0) out += char('0' + d);
        return out.empty() ? "0" : out;
    }
};
