#include <vector>
#include <set>
#include <map>
#include <algorithm>
using namespace std;

class MicroFeed {
    int clock = 0;
    map<int, vector<pair<int, int>>> posts;
    map<int, set<int>> following;

public:
    MicroFeed() {}

    void publishPost(int userId, int messageId) {
        posts[userId].push_back(make_pair(clock++, messageId));
    }

    vector<int> latestFeed(int userId) {
        set<int> authors = following[userId];
        authors.insert(userId);
        vector<pair<int, int>> all;
        for (int author : authors) {
            const vector<pair<int, int>>& own = posts[author];
            all.insert(all.end(), own.begin(), own.end());
        }
        sort(all.rbegin(), all.rend());
        vector<int> feed;
        for (size_t i = 0; i < all.size() && i < 10; i++) feed.push_back(all[i].second);
        return feed;
    }

    void subscribe(int followerId, int followeeId) {
        if (followerId != followeeId) following[followerId].insert(followeeId);
    }

    void unsubscribe(int followerId, int followeeId) {
        following[followerId].erase(followeeId);
    }
};
