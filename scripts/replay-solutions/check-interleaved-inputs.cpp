#include <string>
#include <vector>
using namespace std;

class Solution {
public:
    bool isInterleaving(string controllerA, string controllerB, string merged) {
        int a = controllerA.size(), b = controllerB.size();
        if (a + b != (int)merged.size()) return false;
        vector<bool> ok(b + 1, true);
        for (int j = 1; j <= b; j++) ok[j] = ok[j - 1] && controllerB[j - 1] == merged[j - 1];
        for (int i = 1; i <= a; i++) {
            ok[0] = ok[0] && controllerA[i - 1] == merged[i - 1];
            for (int j = 1; j <= b; j++) {
                char letter = merged[i + j - 1];
                ok[j] = (ok[j] && controllerA[i - 1] == letter) || (ok[j - 1] && controllerB[j - 1] == letter);
            }
        }
        return ok[b];
    }
};
