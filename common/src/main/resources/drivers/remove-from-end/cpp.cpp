#include <iostream>
#include <string>
#include <sstream>
using namespace std;

// {{LIB:ListNode}}

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    string nStr;
    getline(cin, nStr);
    int n = stoi(nStr);
    ListNode* head = listFromArray(line);
    head = Solution().removeNthFromEnd(head, n);
    cout << listToJsonArray(head) << endl;
    return 0;
}
