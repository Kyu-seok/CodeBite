class Solution {
    canSplitMessage(message, words) {
        const splittable = new Array(message.length + 1).fill(false);
        splittable[0] = true;
        for (let end = 1; end <= message.length; end++) {
            splittable[end] = words.some(word => {
                const start = end - word.length;
                return start >= 0 && splittable[start] && message.startsWith(word, start);
            });
        }
        return splittable[message.length];
    }
}
