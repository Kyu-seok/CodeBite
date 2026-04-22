#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <unordered_map>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string numsLine;
    getline(cin, numsLine);
    // Parse "[a,b,c,...]" -> vector<int>
    string inner = numsLine.substr(1, numsLine.size() - 2);
    vector<int> nums;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        nums.push_back(stoi(token));
    }
    int target;
    cin >> target;
    vector<int> result = Solution().findPairIndices(nums, target);
    cout << JsonOutput::intVector(result) << endl;
    return 0;
}
