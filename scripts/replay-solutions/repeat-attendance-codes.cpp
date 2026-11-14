class Solution {
public:
    vector<int> listRepeatedCodes(vector<int>& codes) {
        vector<int> repeated;
        for (int code : codes) {
            int index = abs(code) - 1;
            if (codes[index] < 0) repeated.push_back(abs(code));
            else codes[index] = -codes[index];
        }
        return repeated;
    }
};
