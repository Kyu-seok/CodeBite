#include <vector>
#include <string>
#include <sstream>
using namespace std;

class JsonOutput {
public:
    static string intVector(const vector<int>& v) {
        ostringstream os;
        os << "[";
        for (size_t i = 0; i < v.size(); i++) {
            if (i > 0) os << ",";
            os << v[i];
        }
        os << "]";
        return os.str();
    }

    static string stringVector(const vector<string>& v) {
        ostringstream os;
        os << "[";
        for (size_t i = 0; i < v.size(); i++) {
            if (i > 0) os << ",";
            os << "\"" << v[i] << "\"";
        }
        os << "]";
        return os.str();
    }

    static string charVector(const vector<char>& v) {
        ostringstream os;
        os << "[";
        for (size_t i = 0; i < v.size(); i++) {
            if (i > 0) os << ",";
            os << "\"" << v[i] << "\"";
        }
        os << "]";
        return os.str();
    }
};
