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
    if (op === "HitCounter") {
        obj = new HitCounter();
        result.push(null);
    } else if (op === "hit") {
        obj.hit(arg[0]);
        result.push(null);
    } else if (op === "getHits") {
        result.push(obj.getHits(arg[0]));
    }
}
console.log(JSON.stringify(result));
