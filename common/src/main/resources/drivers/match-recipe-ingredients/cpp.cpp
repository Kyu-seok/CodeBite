#include <iostream>
#include <vector>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string s, t;
    getline(cin, s);
    getline(cin, t);
    bool result = Solution().matchRecipe(s, t);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
