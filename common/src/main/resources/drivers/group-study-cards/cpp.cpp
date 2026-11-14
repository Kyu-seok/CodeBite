#include <iostream>
#include <vector>
#include <string>
#include <sstream>
using namespace std;

{USER_CODE}

int main() {
    string cardsLine;
    getline(cin, cardsLine);
    string inner = cardsLine.substr(1, cardsLine.size() - 2);
    vector<int> cards;
    stringstream ss(inner);
    string token;
    while (getline(ss, token, ',')) {
        cards.push_back(stoi(token));
    }
    int groupSize;
    cin >> groupSize;
    bool result = Solution().canGroupCards(cards, groupSize);
    cout << (result ? "true" : "false") << endl;
    return 0;
}
