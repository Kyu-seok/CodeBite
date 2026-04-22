{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const ops = JSON.parse(lines[0]);
const args = JSON.parse(lines[1]);
const result = [];
let rs = null;
for (let i = 0; i < ops.length; i++) {
    const op = ops[i];
    const arg = args[i];
    if (op === "RandomBag") {
        rs = new RandomBag();
        result.push(null);
    } else if (op === "insert") {
        result.push(rs.insert(arg[0]));
    } else if (op === "remove") {
        result.push(rs.remove(arg[0]));
    } else if (op === "drawRandom") {
        result.push(rs.drawRandom());
    }
}
console.log(JSON.stringify(result));
