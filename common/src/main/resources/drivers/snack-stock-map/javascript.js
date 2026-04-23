{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const ops = JSON.parse(lines[0]);
const args = JSON.parse(lines[1]);
const result = [];
let m = null;
for (let i = 0; i < ops.length; i++) {
    const op = ops[i];
    const arg = args[i];
    if (op === "ChainedMap") {
        m = new ChainedMap();
        result.push(null);
    } else if (op === "set") {
        m.set(arg[0], arg[1]);
        result.push(null);
    } else if (op === "lookup") {
        result.push(m.lookup(arg[0]));
    } else if (op === "erase") {
        m.erase(arg[0]);
        result.push(null);
    }
}
console.log(JSON.stringify(result));
