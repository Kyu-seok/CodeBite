#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <queue>
using namespace std;

{USER_CODE}

int main() {
    string opsLine, argsLine;
    getline(cin, opsLine);
    getline(cin, argsLine);

    // Parse operations
    vector<string> ops;
    string opsInner = opsLine.substr(1, opsLine.size() - 2);
    stringstream oss(opsInner);
    string tok;
    while (getline(oss, tok, ',')) {
        string s;
        for (char c : tok) {
            if (c != '"' && c != ' ') s += c;
        }
        ops.push_back(s);
    }

    // Parse args: [[3,[4,5,8,2]],[3],[5],...]
    vector<string> rawArgs;
    string argsInner = argsLine.substr(1, argsLine.size() - 1);
    int depth = 0;
    int start = -1;
    for (int i = 0; i < (int)argsInner.size(); i++) {
        if (argsInner[i] == '[') {
            if (depth == 0) start = i;
            depth++;
        } else if (argsInner[i] == ']') {
            depth--;
            if (depth == 0) {
                rawArgs.push_back(argsInner.substr(start + 1, i - start - 1));
            }
        }
    }

    cout << "[";
    KthLargest* obj = nullptr;
    for (size_t idx = 0; idx < ops.size(); idx++) {
        if (idx > 0) cout << ",";
        if (ops[idx] == "KthLargest") {
            // Parse "3,[4,5,8,2]"
            string raw = rawArgs[idx];
            int commaIdx = raw.find(',');
            int k = stoi(raw.substr(0, commaIdx));
            string numsStr = raw.substr(commaIdx + 1);
            // Remove [ and ]
            string numsInner = numsStr.substr(1, numsStr.size() - 2);
            vector<int> nums;
            if (!numsInner.empty()) {
                stringstream ss2(numsInner);
                string num;
                while (getline(ss2, num, ',')) {
                    nums.push_back(stoi(num));
                }
            }
            obj = new KthLargest(k, nums);
            cout << "null";
        } else if (ops[idx] == "add") {
            int val = stoi(rawArgs[idx]);
            cout << obj->add(val);
        }
    }
    cout << "]" << endl;
    delete obj;
    return 0;
}
