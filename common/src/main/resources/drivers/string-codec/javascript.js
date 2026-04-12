{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const strs = JSON.parse(input);
const codec = new Codec();
const encoded = codec.encode(strs);
const result = codec.decode(encoded);
console.log(JSON.stringify(result));
