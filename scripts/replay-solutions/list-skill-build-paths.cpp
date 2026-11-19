#include <vector>
using namespace std;

class Solution {
public:
    vector<vector<int>> listBuildPaths(TreeNode* root, int target) {
        vector<vector<int>> paths;
        vector<int> path;
        walk(root, target, path, paths);
        return paths;
    }

private:
    void walk(TreeNode* node, int remaining, vector<int>& path, vector<vector<int>>& paths) {
        if (node == nullptr) return;
        path.push_back(node->val);
        remaining -= node->val;
        if (node->left == nullptr && node->right == nullptr) {
            if (remaining == 0) paths.push_back(path);
        } else {
            walk(node->left, remaining, path, paths);
            walk(node->right, remaining, path, paths);
        }
        path.pop_back();
    }
};
