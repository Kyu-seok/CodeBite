#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string feed;
    getline(cin, feed);
    int result = Solution().longestGenreWindow(feed);
    cout << result << endl;
    return 0;
}
