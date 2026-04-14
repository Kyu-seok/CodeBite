#include <iostream>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string word1, word2;
    getline(cin, word1);
    getline(cin, word2);
    int result = Solution().minDistance(word1, word2);
    cout << result << endl;
    return 0;
}
