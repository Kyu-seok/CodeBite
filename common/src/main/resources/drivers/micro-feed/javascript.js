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
    if (op === "MicroFeed") {
        obj = new MicroFeed();
        result.push(null);
    } else if (op === "publishPost") {
        obj.publishPost(arg[0], arg[1]);
        result.push(null);
    } else if (op === "latestFeed") {
        result.push(obj.latestFeed(arg[0]));
    } else if (op === "subscribe") {
        obj.subscribe(arg[0], arg[1]);
        result.push(null);
    } else if (op === "unsubscribe") {
        obj.unsubscribe(arg[0], arg[1]);
        result.push(null);
    }
}
console.log(JSON.stringify(result));
