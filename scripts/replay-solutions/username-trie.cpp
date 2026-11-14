#include <string>

class PrefixIndex {
    PrefixIndex* next[26] = {};
    bool word = false;

    PrefixIndex* find(const string& s) {
        PrefixIndex* node = this;
        for (char c : s) {
            node = node->next[c - 'a'];
            if (!node) return nullptr;
        }
        return node;
    }

public:
    PrefixIndex() {
    }

    void insert(string word) {
        PrefixIndex* node = this;
        for (char c : word) {
            if (!node->next[c - 'a']) node->next[c - 'a'] = new PrefixIndex();
            node = node->next[c - 'a'];
        }
        node->word = true;
    }

    bool search(string word) {
        PrefixIndex* node = find(word);
        return node && node->word;
    }

    bool startsWith(string prefix) {
        return find(prefix) != nullptr;
    }
};
