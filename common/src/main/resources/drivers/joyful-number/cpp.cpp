#include <iostream>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    int n = stoi(line);
    bool result = Solution().isJoyful(n);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
