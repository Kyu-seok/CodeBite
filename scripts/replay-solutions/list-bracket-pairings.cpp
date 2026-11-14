#include <vector>
#include <string>
using namespace std;

class Solution {
public:
    vector<string> listBracketPairings(int pairCount) {
        vector<string> sequences;
        string prefix;
        build(prefix, 0, 0, pairCount, sequences);
        return sequences;
    }

private:
    void build(string& prefix, int opened, int closed, int pairCount, vector<string>& out) {
        if ((int)prefix.size() == 2 * pairCount) {
            out.push_back(prefix);
            return;
        }
        if (opened < pairCount) {
            prefix.push_back('(');
            build(prefix, opened + 1, closed, pairCount, out);
            prefix.pop_back();
        }
        if (closed < opened) {
            prefix.push_back(')');
            build(prefix, opened, closed + 1, pairCount, out);
            prefix.pop_back();
        }
    }
};
