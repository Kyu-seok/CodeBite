#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string ticketsLine;
    getline(cin, ticketsLine);
    string inner = ticketsLine.substr(1, ticketsLine.size() - 2);
    vector<int> tickets;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        tickets.push_back(stoi(token));
    }
    bool result = Solution().canSplitEqually(tickets);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
