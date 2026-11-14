#include <string>
#include <unordered_set>
using namespace std;

class WildcardLexicon {
    unordered_set<string> words;

public:
    WildcardLexicon() {}

    void enroll(string word) {
        words.insert(word);
    }

    bool match(string word) {
        for (const string& saved : words) {
            if (saved.size() != word.size()) continue;
            bool fits = true;
            for (size_t i = 0; i < word.size() && fits; i++) {
                fits = word[i] == '.' || word[i] == saved[i];
            }
            if (fits) return true;
        }
        return false;
    }
};
