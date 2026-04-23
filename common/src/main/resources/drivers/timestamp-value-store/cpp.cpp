#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

struct ParsedArg {
    vector<string> strings;
    vector<int> ints;
};

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

vector<string> splitArgs(const string& raw) {
    vector<string> parts;
    bool inQuote = false;
    int start = 0;
    for (int i = 0; i < (int)raw.size(); i++) {
        if (raw[i] == '"') inQuote = !inQuote;
        else if (raw[i] == ',' && !inQuote) {
            parts.push_back(raw.substr(start, i - start));
            start = i + 1;
        }
    }
    parts.push_back(raw.substr(start));
    return parts;
}

string stripQuotes(const string& s) {
    string r;
    for (char c : s) {
        if (c != '"' && c != ' ') r += c;
    }
    return r;
}

int main() {
    string opsLine, argsLine;
    getline(cin, opsLine);
    getline(cin, argsLine);

    vector<string> ops = parseOps(opsLine);
    vector<string> rawArgs = parseRawArgs(argsLine);

    TimestampedStore* obj = nullptr;
    cout << "[";
    for (int i = 0; i < (int)ops.size(); i++) {
        if (i > 0) cout << ",";
        if (ops[i] == "TimestampedStore") {
            obj = new TimestampedStore();
            cout << "null";
        } else if (ops[i] == "write") {
            vector<string> parts = splitArgs(rawArgs[i]);
            string key = stripQuotes(parts[0]);
            string value = stripQuotes(parts[1]);
            int timestamp = stoi(stripQuotes(parts[2]));
            obj->write(key, value, timestamp);
            cout << "null";
        } else if (ops[i] == "readAt") {
            vector<string> parts = splitArgs(rawArgs[i]);
            string key = stripQuotes(parts[0]);
            int timestamp = stoi(stripQuotes(parts[1]));
            string result = obj->readAt(key, timestamp);
            cout << "\"" << result << "\"";
        }
    }
    cout << "]" << endl;
    delete obj;
    return 0;
}
