#include <iostream>
#include <string>
#include <iomanip>
using namespace std;

{USER_CODE}

int main() {
    double x;
    int n;
    cin >> x >> n;
    double result = Solution().raiseForecastFactor(x, n);
    cout << fixed << setprecision(5) << result << endl;
    return 0;
}
