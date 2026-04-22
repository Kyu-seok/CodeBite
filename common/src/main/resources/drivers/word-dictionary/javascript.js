{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const cmds = JSON.parse(lines[0]);
const args = JSON.parse(lines[1]);

let dict = null;
const result = [];
for (let i = 0; i < cmds.length; i++) {
    if (cmds[i] === "WildcardLexicon") {
        dict = new WildcardLexicon();
        result.push(null);
    } else if (cmds[i] === "enroll") {
        dict.enroll(args[i][0]);
        result.push(null);
    } else if (cmds[i] === "match") {
        result.push(dict.match(args[i][0]));
    }
}
console.log(JSON.stringify(result));
