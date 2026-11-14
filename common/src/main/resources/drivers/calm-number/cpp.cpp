#include <iostream>
#include <string>
#include <unordered_set>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    int reading = stoi(line);
    bool result = Solution().isCalm(reading);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
