#include <iostream>
#include <vector>
#include <string>
using namespace std;

// {{LIB:JsonOutput}}

{USER_CODE}

int main() {
    string stickers;
    getline(cin, stickers);
    vector<int> result = Solution().splitStickerRuns(stickers);
    cout << JsonOutput::intVector(result) << endl;
    return 0;
}
