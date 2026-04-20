#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <map>
using namespace std;

{USER_CODE}

int main() {
    string opsLine, argsLine;
    getline(cin, opsLine);
    getline(cin, argsLine);

    // Parse operations: ["SnapshotArray","set",...]
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

    // Parse args: [[3],[0,5],[],[0,6],[0,0]]
    vector<vector<int>> argsList;
    string argsInner = argsLine.substr(1, argsLine.size() - 1);
    size_t i = 0;
    while (i < argsInner.size()) {
        if (argsInner[i] == '[') {
            size_t j = argsInner.find(']', i);
            string sub = argsInner.substr(i + 1, j - i - 1);
            vector<int> arr;
            if (!sub.empty()) {
                stringstream ss2(sub);
                string num;
                while (getline(ss2, num, ',')) {
                    arr.push_back(stoi(num));
                }
            }
            argsList.push_back(arr);
            i = j + 1;
        } else {
            i++;
        }
    }

    cout << "[";
    SnapshotArray* snapArr = nullptr;
    for (size_t idx = 0; idx < ops.size(); idx++) {
        if (idx > 0) cout << ",";
        string op = ops[idx];
        if (op == "SnapshotArray") {
            snapArr = new SnapshotArray(argsList[idx][0]);
            cout << "null";
        } else if (op == "set") {
            snapArr->set(argsList[idx][0], argsList[idx][1]);
            cout << "null";
        } else if (op == "snap") {
            cout << snapArr->snap();
        } else if (op == "get") {
            cout << snapArr->get(argsList[idx][0], argsList[idx][1]);
        }
    }
    cout << "]" << endl;
    delete snapArr;
    return 0;
}
