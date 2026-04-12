#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    // Parse ["hello","world"]
    vector<string> strs;
    size_t pos = 0;
    while (pos < line.size()) {
        if (line[pos] == '"') {
            size_t end = line.find('"', pos + 1);
            strs.push_back(line.substr(pos + 1, end - pos - 1));
            pos = end + 1;
        } else {
            pos++;
        }
    }
    Codec codec;
    string encoded = codec.encode(strs);
    vector<string> result = codec.decode(encoded);
    cout << JsonOutput::stringVector(result) << endl;
    return 0;
}
