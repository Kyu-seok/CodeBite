#include <iostream>
#include <vector>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string notes, target;
    getline(cin, notes);
    getline(cin, target);
    long long result = Solution().countHintMatches(notes, target);
    cout << result << endl;
    return 0;
}
