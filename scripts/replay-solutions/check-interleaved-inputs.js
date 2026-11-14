class Solution {
    /**
     * @param {string} controllerA
     * @param {string} controllerB
     * @param {string} merged
     * @return {boolean}
     */
    isInterleaving(controllerA, controllerB, merged) {
        const a = controllerA.length, b = controllerB.length;
        if (a + b !== merged.length) return false;
        const ok = new Array(b + 1).fill(true);
        for (let j = 1; j <= b; j++) ok[j] = ok[j - 1] && controllerB[j - 1] === merged[j - 1];
        for (let i = 1; i <= a; i++) {
            ok[0] = ok[0] && controllerA[i - 1] === merged[i - 1];
            for (let j = 1; j <= b; j++) {
                const letter = merged[i + j - 1];
                ok[j] = (ok[j] && controllerA[i - 1] === letter) || (ok[j - 1] && controllerB[j - 1] === letter);
            }
        }
        return ok[b];
    }
}
