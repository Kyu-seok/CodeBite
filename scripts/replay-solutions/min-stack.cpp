class LowTrackStack {
    vector<pair<int, int>> entries;

public:
    LowTrackStack() {
    }

    void push(int val) {
        int low = entries.empty() ? val : min(val, entries.back().second);
        entries.push_back({val, low});
    }

    void pop() {
        entries.pop_back();
    }

    int top() {
        return entries.back().first;
    }

    int getMin() {
        return entries.back().second;
    }
};
