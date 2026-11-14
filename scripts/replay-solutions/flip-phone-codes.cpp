#include <string>
#include <vector>
using namespace std;

class Solution {
public:
    vector<string> letterCombinations(string digits) {
        if (digits.empty()) return {};
        static const string keypad[] = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};
        vector<string> combos = {""};
        for (char d : digits) {
            vector<string> next;
            for (const string& prefix : combos) {
                for (char letter : keypad[d - '0']) next.push_back(prefix + letter);
            }
            combos = next;
        }
        return combos;
    }
};
