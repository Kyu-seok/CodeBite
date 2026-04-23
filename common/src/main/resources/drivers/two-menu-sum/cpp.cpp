#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string numsLine;
    getline(cin, numsLine);
    string inner = numsLine.substr(1, numsLine.size() - 2);
    vector<int> numbers;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        numbers.push_back(stoi(token));
    }
    int target;
    cin >> target;
    vector<int> result = Solution().pairTiersBudget(numbers, target);
    cout << JsonOutput::intVector(result) << endl;
    return 0;
}
