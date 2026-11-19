#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <deque>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string comboLine;
    getline(cin, comboLine);
    string inner = comboLine.substr(1, comboLine.size() - 2);
    vector<int> combo;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        combo.push_back(stoi(token));
    }
    int k;
    cin >> k;
    vector<int> result = Solution().peakComboPerWindow(combo, k);
    cout << JsonOutput::intVector(result) << endl;
    return 0;
}
