#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <unordered_map>
using namespace std;

{USER_CODE}

int main() {
    string queue;
    getline(cin, queue);
    int k;
    cin >> k;
    int result = Solution().longestKGenreWindow(queue, k);
    cout << result << endl;
    return 0;
}
