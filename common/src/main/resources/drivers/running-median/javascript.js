{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const ops = JSON.parse(lines[0]);
const args = JSON.parse(lines[1]);

let obj = null;
const parts = [];
for (let i = 0; i < ops.length; i++) {
    const op = ops[i];
    const arg = args[i];
    if (op === "StreamMedian") {
        obj = new StreamMedian();
        parts.push("null");
    } else if (op === "record") {
        obj.record(arg[0]);
        parts.push("null");
    } else if (op === "median") {
        const median = obj.median();
        if (Number.isInteger(median)) {
            parts.push(median.toFixed(1));
        } else {
            parts.push(String(median));
        }
    }
}
console.log("[" + parts.join(",") + "]");
