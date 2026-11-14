#include <iostream>
#include <string>
#include <iomanip>
using namespace std;

{USER_CODE}

int main() {
    double base;
    int exponent;
    cin >> base >> exponent;
    double result = Solution().power(base, exponent);
    cout << fixed << setprecision(5) << result << endl;
    return 0;
}
