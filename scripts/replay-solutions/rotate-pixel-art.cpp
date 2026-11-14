#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    void rotateImage(vector<vector<int>>& image) {
        int n = image.size();
        for (int i = 0; i < n; i++)
            for (int j = i + 1; j < n; j++)
                swap(image[i][j], image[j][i]);
        for (auto& row : image) reverse(row.begin(), row.end());
    }
};
