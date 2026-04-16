#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

vector<string> parseOps(const string& line) {
    vector<string> result;
    string inner = line.substr(1, line.size() - 2);
    string token;
    bool inQuote = false;
    for (char c : inner) {
        if (c == '"') { inQuote = !inQuote; continue; }
        if (c == ',' && !inQuote) { result.push_back(token); token = ""; continue; }
        if (inQuote) token += c;
    }
    if (!token.empty()) result.push_back(token);
    return result;
}

vector<vector<int>> parseArgs(const string& line) {
    vector<vector<int>> result;
    int depth = 0;
    int start = -1;
    for (int i = 1; i < (int)line.size() - 1; i++) {
        if (line[i] == '[') {
            if (depth == 0) start = i;
            depth++;
        } else if (line[i] == ']') {
            depth--;
            if (depth == 0) {
                string content = line.substr(start + 1, i - start - 1);
                vector<int> nums;
                if (!content.empty()) {
                    stringstream ss(content);
                    string token;
                    while (getline(ss, token, ',')) {
                        nums.push_back(stoi(token));
                    }
                }
                result.push_back(nums);
            }
        }
    }
    return result;
}

int main() {
    string opsLine, argsLine;
    getline(cin, opsLine);
    getline(cin, argsLine);

    vector<string> ops = parseOps(opsLine);
    vector<vector<int>> args = parseArgs(argsLine);

    RecentCache* obj = nullptr;
    cout << "[";
    for (int i = 0; i < (int)ops.size(); i++) {
        if (i > 0) cout << ",";
        if (ops[i] == "RecentCache") {
            obj = new RecentCache(args[i][0]);
            cout << "null";
        } else if (ops[i] == "put") {
            obj->put(args[i][0], args[i][1]);
            cout << "null";
        } else if (ops[i] == "get") {
            cout << obj->get(args[i][0]);
        }
    }
    cout << "]" << endl;
    delete obj;
    return 0;
}
