#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    int n;
    cin >> n;
    cin.ignore();
    string line;
    getline(cin, line);
    // Parse 2D int array [[0,1,100],[1,2,100]]
    vector<vector<int>> flights;
    string inner = line.substr(1, line.size() - 2);
    if (!inner.empty() && inner.find('[') != string::npos) {
        int i = 0;
        while (i < (int)inner.size()) {
            if (inner[i] == '[') {
                int j = inner.find(']', i);
                string tripStr = inner.substr(i + 1, j - i - 1);
                vector<int> trip;
                stringstream ss(tripStr);
                string token;
                while (getline(ss, token, ',')) {
                    trip.push_back(stoi(token));
                }
                flights.push_back(trip);
                i = j + 1;
            } else {
                i++;
            }
        }
    }
    int src, dst, k;
    cin >> src >> dst >> k;
    int result = Solution().findCheapestPrice(n, flights, src, dst, k);
    cout << result << endl;
    return 0;
}
