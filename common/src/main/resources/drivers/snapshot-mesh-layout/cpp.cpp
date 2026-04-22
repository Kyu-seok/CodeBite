#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <queue>
#include <map>
#include <unordered_map>
using namespace std;

// {{LIB:Node}}

{USER_CODE}

int main() {
    string line;
    getline(cin, line);
    Node* node = graphFromAdjList(line);
    Node* cloned = Solution().snapshotMeshLayout(node);
    cout << graphToAdjListJson(cloned) << endl;
    return 0;
}
