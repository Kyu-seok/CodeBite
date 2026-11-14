#include <string>
#include <cctype>
using namespace std;

class Solution {
public:
    bool isPalindrome(string phrase) {
        int left = 0, right = (int) phrase.size() - 1;
        while (left < right) {
            if (!isalnum((unsigned char) phrase[left])) left++;
            else if (!isalnum((unsigned char) phrase[right])) right--;
            else {
                if (tolower((unsigned char) phrase[left]) != tolower((unsigned char) phrase[right])) return false;
                left++;
                right--;
            }
        }
        return true;
    }
};
