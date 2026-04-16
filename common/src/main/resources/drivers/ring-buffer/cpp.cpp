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

    // Parse operations: ["RingBuffer","enQueue",...]
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

    // Parse args: [[3],[1],[2],...]
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
    RingBuffer* buf = nullptr;
    for (size_t idx = 0; idx < ops.size(); idx++) {
        if (idx > 0) cout << ",";
        string op = ops[idx];
        if (op == "RingBuffer") {
            buf = new RingBuffer(argsList[idx][0]);
            cout << "null";
        } else if (op == "enQueue") {
            cout << (buf->enQueue(argsList[idx][0]) ? "true" : "false");
        } else if (op == "deQueue") {
            cout << (buf->deQueue() ? "true" : "false");
        } else if (op == "front") {
            cout << buf->front();
        } else if (op == "rear") {
            cout << buf->rear();
        } else if (op == "isEmpty") {
            cout << (buf->isEmpty() ? "true" : "false");
        } else if (op == "isFull") {
            cout << (buf->isFull() ? "true" : "false");
        }
    }
    cout << "]" << endl;
    delete buf;
    return 0;
}
