#include <queue>
#include <vector>
#include <functional>
using namespace std;

class StreamMedian {
    priority_queue<int> low;
    priority_queue<int, vector<int>, greater<int>> high;
public:
    StreamMedian() {}

    void record(int num) {
        low.push(num);
        high.push(low.top());
        low.pop();
        if (high.size() > low.size()) { low.push(high.top()); high.pop(); }
    }

    double median() {
        if (low.size() > high.size()) return low.top();
        return (low.top() + (double) high.top()) / 2.0;
    }
};
