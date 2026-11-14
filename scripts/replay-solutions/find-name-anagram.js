class Solution {
    containsNameAnagram(pattern, log) {
        const size = pattern.length;
        if (size > log.length) return false;
        const diff = new Array(26).fill(0);
        const at = (s, i) => s.charCodeAt(i) - 97;
        for (let i = 0; i < size; i++) {
            diff[at(pattern, i)]++;
            diff[at(log, i)]--;
        }
        if (diff.every((c) => c === 0)) return true;
        for (let i = size; i < log.length; i++) {
            diff[at(log, i)]--;
            diff[at(log, i - size)]++;
            if (diff.every((c) => c === 0)) return true;
        }
        return false;
    }
}
