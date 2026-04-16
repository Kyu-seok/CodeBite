#include <iostream>
#include <string>
using namespace std;

{USER_CODE}

int main() {
    string num1, num2;
    getline(cin, num1);
    getline(cin, num2);
    string result = Solution().multiply(num1, num2);
    cout << result << endl;
    return 0;
}
