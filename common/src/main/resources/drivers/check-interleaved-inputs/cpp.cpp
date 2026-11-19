#include <iostream>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string controllerA, controllerB, merged;
    getline(cin, controllerA);
    getline(cin, controllerB);
    getline(cin, merged);
    bool result = Solution().isInterleaving(controllerA, controllerB, merged);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
