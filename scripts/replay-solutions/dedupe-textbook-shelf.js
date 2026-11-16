class Solution {
    compactShelf(books) {
        let k = 1;
        for (let i = 1; i < books.length; i++) {
            if (books[i] !== books[k - 1]) books[k++] = books[i];
        }
        return k;
    }
}
