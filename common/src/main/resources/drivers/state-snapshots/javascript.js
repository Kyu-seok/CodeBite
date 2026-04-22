{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const ops = JSON.parse(lines[0]);
const args = JSON.parse(lines[1]);
const result = [];
let snapArr = null;
for (let i = 0; i < ops.length; i++) {
    const op = ops[i];
    const arg = args[i];
    if (op === "VersionedCells") {
        snapArr = new VersionedCells(arg[0]);
        result.push(null);
    } else if (op === "set") {
        snapArr.set(arg[0], arg[1]);
        result.push(null);
    } else if (op === "commit") {
        result.push(snapArr.commit());
    } else if (op === "readAt") {
        result.push(snapArr.readAt(arg[0], arg[1]));
    }
}
console.log(JSON.stringify(result));
