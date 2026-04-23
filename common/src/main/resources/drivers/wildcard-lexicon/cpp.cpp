#include <iostream>
#include <string>
#include <sstream>
#include <vector>
using namespace std;

{USER_CODE}

vector<string> parseCmds(const string& line) {
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

vector<string> parseArgs(const string& line) {
    vector<string> result;
    int depth = 0;
    string curr;
    for (int i = 1; i < (int)line.size() - 1; i++) {
        char c = line[i];
        if (c == '[') { depth++; if (depth == 1) curr = ""; continue; }
        if (c == ']') { depth--; if (depth == 0) result.push_back(curr); continue; }
        if (c == ',' && depth == 0) continue;
        if (c == '"') continue;
        if (depth >= 1) curr += c;
    }
    return result;
}

int main() {
    string cmdsLine, argsLine;
    getline(cin, cmdsLine);
    getline(cin, argsLine);

    vector<string> cmds = parseCmds(cmdsLine);
    vector<string> args = parseArgs(argsLine);

    WildcardLexicon* dict = nullptr;
    cout << "[";
    for (int i = 0; i < (int)cmds.size(); i++) {
        if (i > 0) cout << ",";
        if (cmds[i] == "WildcardLexicon") {
            dict = new WildcardLexicon();
            cout << "null";
        } else if (cmds[i] == "enroll") {
            dict->enroll(args[i]);
            cout << "null";
        } else if (cmds[i] == "match") {
            cout << (dict->match(args[i]) ? "true" : "false");
        }
    }
    cout << "]" << endl;
    delete dict;
    return 0;
}
