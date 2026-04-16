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

    // Parse operations: ["SimpleHashMap","put",...]
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

    // Parse args: [[],[1,10],[2,20],...]
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
    SimpleHashMap* m = nullptr;
    for (size_t idx = 0; idx < ops.size(); idx++) {
        if (idx > 0) cout << ",";
        string op = ops[idx];
        if (op == "SimpleHashMap") {
            m = new SimpleHashMap();
            cout << "null";
        } else if (op == "put") {
            m->put(argsList[idx][0], argsList[idx][1]);
            cout << "null";
        } else if (op == "get") {
            cout << m->get(argsList[idx][0]);
        } else if (op == "remove") {
            m->remove(argsList[idx][0]);
            cout << "null";
        }
    }
    cout << "]" << endl;
    delete m;
    return 0;
}
