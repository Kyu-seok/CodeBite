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
    if (op === "FeedDesigner") {
        obj = new FeedDesigner();
        result.push(null);
    } else if (op === "postMessage") {
        obj.postMessage(arg[0], arg[1]);
        result.push(null);
    } else if (op === "getNewsFeed") {
        result.push(obj.getNewsFeed(arg[0]));
    } else if (op === "follow") {
        obj.follow(arg[0], arg[1]);
        result.push(null);
    } else if (op === "unfollow") {
        obj.unfollow(arg[0], arg[1]);
        result.push(null);
    }
}
console.log(JSON.stringify(result));
