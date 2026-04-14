{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const cmds = JSON.parse(lines[0]);
const args = JSON.parse(lines[1]);

let dict = null;
const result = [];
for (let i = 0; i < cmds.length; i++) {
    if (cmds[i] === "WordDictionary") {
        dict = new WordDictionary();
        result.push(null);
    } else if (cmds[i] === "addWord") {
        dict.addWord(args[i][0]);
        result.push(null);
    } else if (cmds[i] === "search") {
        result.push(dict.search(args[i][0]));
    }
}
console.log(JSON.stringify(result));
