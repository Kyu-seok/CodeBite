#include <iostream>
#include <vector>
#include <string>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    int n;
    cin >> n;
    vector<string> result = Solution().fizzBuzz(n);
    cout << JsonOutput::stringVector(result) << endl;
    return 0;
}
