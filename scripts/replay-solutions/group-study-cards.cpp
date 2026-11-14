#include <vector>
#include <map>
using namespace std;

class Solution {
public:
    bool canGroupCards(vector<int>& cards, int groupSize) {
        if (cards.size() % groupSize != 0) return false;
        map<int, int> left;
        for (int card : cards) left[card]++;
        for (map<int, int>::iterator it = left.begin(); it != left.end(); ++it) {
            int start = it->first, groups = it->second;
            if (groups == 0) continue;
            for (int card = start; card < start + groupSize; card++) {
                map<int, int>::iterator found = left.find(card);
                if (found == left.end() || found->second < groups) return false;
                found->second -= groups;
            }
        }
        return true;
    }
};
