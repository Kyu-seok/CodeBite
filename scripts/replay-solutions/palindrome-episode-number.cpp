#include <string>
#include <algorithm>
using namespace std;

class Solution {
public:
    bool isPalindrome(int episode) {
        string text = to_string(episode);
        string reversed(text.rbegin(), text.rend());
        return reversed == text;
    }
};
