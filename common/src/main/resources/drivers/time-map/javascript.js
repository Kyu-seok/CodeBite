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
    if (op === "TimestampedStore") {
        obj = new TimestampedStore();
        result.push(null);
    } else if (op === "write") {
        obj.write(arg[0], arg[1], arg[2]);
        result.push(null);
    } else if (op === "readAt") {
        result.push(obj.readAt(arg[0], arg[1]));
    }
}
console.log(JSON.stringify(result));
