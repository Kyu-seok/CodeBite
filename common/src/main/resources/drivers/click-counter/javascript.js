{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const ops = JSON.parse(lines[0]);
const args = JSON.parse(lines[1]);

let obj = null;
const result = [];
for (let i = 0; i < ops.length; i++) {
    const op = ops[i];
    const arg = args[i];
    if (op === "ClickTally") {
        obj = new ClickTally();
        result.push(null);
    } else if (op === "record") {
        obj.record(arg[0]);
        result.push(null);
    } else if (op === "countSince") {
        result.push(obj.countSince(arg[0]));
    }
}
console.log(JSON.stringify(result));
