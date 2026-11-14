class Solution {
    splitIntoTwoShifts(conflicts) {
        const shift = new Array(conflicts.length).fill(-1);
        for (let start = 0; start < conflicts.length; start++) {
            if (shift[start] !== -1) continue;
            shift[start] = 0;
            const stack = [start];
            while (stack.length) {
                const node = stack.pop();
                for (const other of conflicts[node]) {
                    if (shift[other] === -1) {
                        shift[other] = 1 - shift[node];
                        stack.push(other);
                    } else if (shift[other] === shift[node]) {
                        return false;
                    }
                }
            }
        }
        return true;
    }
}
