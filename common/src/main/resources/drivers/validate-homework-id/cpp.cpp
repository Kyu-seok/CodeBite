#include <iostream>
#include <vector>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string s, p;
    getline(cin, s);
    getline(cin, p);
    bool result = Solution().validatePartStream(s, p);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
