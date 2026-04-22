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
    vector<int> nums;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        nums.push_back(stoi(token));
    }
    int k = Solution().compactShelf(nums);
    cout << k << endl;
    vector<int> unique(nums.begin(), nums.begin() + k);
    cout << JsonOutput::intVector(unique) << endl;
    return 0;
}
