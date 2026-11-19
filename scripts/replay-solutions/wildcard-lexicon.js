class WildcardLexicon {
    constructor() {
        this.words = new Set();
    }

    enroll(word) {
        this.words.add(word);
    }

    match(word) {
        for (const saved of this.words) {
            if (saved.length !== word.length) continue;
            let fits = true;
            for (let i = 0; i < word.length && fits; i++) {
                fits = word[i] === '.' || word[i] === saved[i];
            }
            if (fits) return true;
        }
        return false;
    }
}
