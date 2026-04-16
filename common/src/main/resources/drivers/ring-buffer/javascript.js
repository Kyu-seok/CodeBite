{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const ops = JSON.parse(lines[0]);
const args = JSON.parse(lines[1]);
const result = [];
let buf = null;
for (let i = 0; i < ops.length; i++) {
    const op = ops[i];
    const arg = args[i];
    if (op === "RingBuffer") {
        buf = new RingBuffer(arg[0]);
        result.push(null);
    } else if (op === "enQueue") {
        result.push(buf.enQueue(arg[0]));
    } else if (op === "deQueue") {
        result.push(buf.deQueue());
    } else if (op === "front") {
        result.push(buf.front());
    } else if (op === "rear") {
        result.push(buf.rear());
    } else if (op === "isEmpty") {
        result.push(buf.isEmpty());
    } else if (op === "isFull") {
        result.push(buf.isFull());
    }
}
console.log(JSON.stringify(result));
