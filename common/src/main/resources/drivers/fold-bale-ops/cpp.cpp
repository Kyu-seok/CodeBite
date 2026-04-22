#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <stack>
using namespace std;

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse ["2","1","+","3","*"]
    vector<string> tokens;
    size_t pos = 0;
    while (pos < line.size()) {
        if (line[pos] == '"') {
            size_t end = line.find('"', pos + 1);
            tokens.push_back(line.substr(pos + 1, end - pos - 1));
            pos = end + 1;
        } else {
            pos++;
        }
    }
    int result = Solution().foldBaleOps(tokens);
    cout << result << endl;
    return 0;
}
