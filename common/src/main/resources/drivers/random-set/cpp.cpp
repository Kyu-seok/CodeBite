#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string opsLine, argsLine;
    getline(cin, opsLine);
    getline(cin, argsLine);

    // Parse operations: ["RandomSet","insert",...]
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

    // Parse args: [[],[1],[2],[],[2],[3],[]]
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
    RandomSet* rs = nullptr;
    for (size_t idx = 0; idx < ops.size(); idx++) {
        if (idx > 0) cout << ",";
        string op = ops[idx];
        if (op == "RandomSet") {
            rs = new RandomSet();
            cout << "null";
        } else if (op == "insert") {
            cout << (rs->insert(argsList[idx][0]) ? "true" : "false");
        } else if (op == "remove") {
            cout << (rs->remove(argsList[idx][0]) ? "true" : "false");
        } else if (op == "getRandom") {
            cout << rs->getRandom();
        }
    }
    cout << "]" << endl;
    delete rs;
    return 0;
}
