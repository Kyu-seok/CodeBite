#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <iomanip>
using namespace std;

{USER_CODE}

vector<vector<string>> parse2DStringArray(const string& line) {
    vector<vector<string>> result;
    int i = 0;
    while (i < (int)line.size()) {
        if (line[i] == '[' && i == 0) { i++; continue; }
        if (line[i] == '[') {
            int j = line.find(']', i);
            string inner = line.substr(i + 1, j - i - 1);
            vector<string> pair;
            stringstream ss(inner);
            string token;
            while (getline(ss, token, ',')) {
                string s;
                for (char c : token) {
                    if (c != '"' && c != ' ') s += c;
                }
                pair.push_back(s);
            }
            result.push_back(pair);
            i = j + 1;
        } else {
            i++;
        }
    }
    return result;
}

vector<double> parseDoubleArray(const string& line) {
    vector<double> result;
    string inner = line.substr(1, line.size() - 2);
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        result.push_back(stod(token));
    }
    return result;
}

int main() {
    string eqLine, valLine, qLine;
    getline(cin, eqLine);
    getline(cin, valLine);
    getline(cin, qLine);

    vector<vector<string>> equations = parse2DStringArray(eqLine);
    vector<double> values = parseDoubleArray(valLine);
    vector<vector<string>> queries = parse2DStringArray(qLine);

    vector<double> result = Solution().calcEquation(equations, values, queries);

    cout << "[";
    for (int i = 0; i < (int)result.size(); i++) {
        if (i > 0) cout << ",";
        cout << fixed << setprecision(5) << result[i];
    }
    cout << "]" << endl;
    return 0;
}
