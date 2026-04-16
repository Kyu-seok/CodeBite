{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const ops = JSON.parse(lines[0]);
const args = JSON.parse(lines[1]);
const result = [];
let queue = null;
for (let i = 0; i < ops.length; i++) {
    const op = ops[i];
    const arg = args[i];
    if (op === "StackQueue") {
        queue = new StackQueue();
        result.push(null);
    } else if (op === "push") {
        queue.push(arg[0]);
        result.push(null);
    } else if (op === "pop") {
        result.push(queue.pop());
    } else if (op === "peek") {
        result.push(queue.peek());
    } else if (op === "empty") {
        result.push(queue.empty());
    }
}
console.log(JSON.stringify(result));
