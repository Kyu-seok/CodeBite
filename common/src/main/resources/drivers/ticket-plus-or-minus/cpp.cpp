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
    int target;
    cin >> target;
    int result = Solution().countSignAssignments(tickets, target);
    cout << result << endl;
    return 0;
}
