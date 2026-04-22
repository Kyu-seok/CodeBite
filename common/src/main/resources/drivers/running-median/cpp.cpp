#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <iomanip>
#include <cmath>
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

vector<string> parseRawArgs(const string& line) {
    vector<string> result;
    int depth = 0;
    int start = -1;
    for (int i = 1; i < (int)line.size() - 1; i++) {
        if (line[i] == '[') {
            if (depth == 0) start = i;
            depth++;
        } else if (line[i] == ']') {
            depth--;
            if (depth == 0) {
                result.push_back(line.substr(start + 1, i - start - 1));
            }
        }
    }
    return result;
}

string stripSpaces(const string& s) {
    string r;
    for (char c : s) {
        if (c != ' ') r += c;
    }
    return r;
}

string formatDouble(double v) {
    if (v == floor(v)) {
        ostringstream oss;
        oss << fixed << setprecision(1) << v;
        return oss.str();
    } else {
        ostringstream oss;
        oss << v;
        return oss.str();
    }
}

int main() {
    string opsLine, argsLine;
    getline(cin, opsLine);
    getline(cin, argsLine);

    vector<string> ops = parseOps(opsLine);
    vector<string> rawArgs = parseRawArgs(argsLine);

    StreamMedian* obj = nullptr;
    cout << "[";
    for (int i = 0; i < (int)ops.size(); i++) {
        if (i > 0) cout << ",";
        string raw = stripSpaces(rawArgs[i]);

        if (ops[i] == "StreamMedian") {
            obj = new StreamMedian();
            cout << "null";
        } else if (ops[i] == "record") {
            int num = stoi(raw);
            obj->record(num);
            cout << "null";
        } else if (ops[i] == "median") {
            double median = obj->median();
            cout << formatDouble(median);
        }
    }
    cout << "]" << endl;
    delete obj;
    return 0;
}
