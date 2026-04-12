#include <iostream>
#include <string>
#include <sstream>
using namespace std;

// {{LIB:ListNode}}

{USER_CODE}

int main() {
    string line1, line2;
    getline(cin, line1);
    getline(cin, line2);
    ListNode* list1 = listFromArray(line1);
    ListNode* list2 = listFromArray(line2);
    ListNode* result = Solution().mergeTwoLists(list1, list2);
    cout << listToJsonArray(result) << endl;
    return 0;
}
