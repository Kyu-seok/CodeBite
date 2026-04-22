{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const strs = JSON.parse(input);
const codec = new ListCoder();
const encoded = codec.pack(strs);
const result = codec.unpack(encoded);
console.log(JSON.stringify(result));
