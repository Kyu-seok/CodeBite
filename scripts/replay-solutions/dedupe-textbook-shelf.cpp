class Solution {
public:
    int compactShelf(vector<int>& books) {
        int k = 1;
        for (size_t i = 1; i < books.size(); i++) {
            if (books[i] != books[k - 1]) books[k++] = books[i];
        }
        return k;
    }
};
