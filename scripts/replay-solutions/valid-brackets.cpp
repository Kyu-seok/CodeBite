#include <string>
#include <vector>
using namespace std;

class Solution {
public:
    bool isValidBrackets(string brackets) {
        vector<char> stack;
        for (char ch : brackets) {
            if (ch == '(' || ch == '[' || ch == '{') {
                stack.push_back(ch);
            } else {
                char opener = ch == ')' ? '(' : ch == ']' ? '[' : '{';
                if (stack.empty() || stack.back() != opener) return false;
                stack.pop_back();
            }
        }
        return stack.empty();
    }
};
