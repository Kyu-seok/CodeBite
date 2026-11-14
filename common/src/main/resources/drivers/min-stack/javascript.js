{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const ops = JSON.parse(lines[0]);
const args = JSON.parse(lines[1]);
const result = [];
let stack = null;
for (let i = 0; i < ops.length; i++) {
    const op = ops[i];
    const arg = args[i];
    if (op === "LowTrackStack") {
        stack = new LowTrackStack();
        result.push(null);
    } else if (op === "push") {
        stack.push(arg[0]);
        result.push(null);
    } else if (op === "pop") {
        stack.pop();
        result.push(null);
    } else if (op === "top") {
        result.push(stack.top());
    } else if (op === "getMin") {
        result.push(stack.getMin());
    }
}
console.log(JSON.stringify(result));
