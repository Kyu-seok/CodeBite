#include <iostream>
#include <string>
#include <sstream>
using namespace std;

// {{LIB:ListNode}}

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    ListNode* head = listFromArray(line);
    head = Solution().swapQueuePartners(head);
    cout << listToJsonArray(head) << endl;
    return 0;
}
