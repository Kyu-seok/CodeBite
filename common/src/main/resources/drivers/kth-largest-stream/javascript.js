{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const ops = JSON.parse(lines[0]);
const args = JSON.parse(lines[1]);
const result = [];
let obj = null;
for (let i = 0; i < ops.length; i++) {
    const op = ops[i];
    const arg = args[i];
    if (op === "KthLargest") {
        obj = new KthLargest(arg[0], arg[1]);
        result.push(null);
    } else if (op === "add") {
        result.push(obj.add(arg[0]));
    }
}
console.log(JSON.stringify(result));
