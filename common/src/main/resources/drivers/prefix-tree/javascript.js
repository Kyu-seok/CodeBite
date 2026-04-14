{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const cmds = JSON.parse(lines[0]);
const args = JSON.parse(lines[1]);

let trie = null;
const result = [];
for (let i = 0; i < cmds.length; i++) {
    if (cmds[i] === "Trie") {
        trie = new Trie();
        result.push(null);
    } else if (cmds[i] === "insert") {
        trie.insert(args[i][0]);
        result.push(null);
    } else if (cmds[i] === "search") {
        result.push(trie.search(args[i][0]));
    } else if (cmds[i] === "startsWith") {
        result.push(trie.startsWith(args[i][0]));
    }
}
console.log(JSON.stringify(result));
