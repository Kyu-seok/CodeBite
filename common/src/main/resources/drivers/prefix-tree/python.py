{USER_CODE}

import json

cmds = json.loads(input())
args = json.loads(input())

trie = None
result = []
for cmd, arg in zip(cmds, args):
    if cmd == "PrefixIndex":
        trie = PrefixIndex()
        result.append(None)
    elif cmd == "insert":
        trie.insert(arg[0])
        result.append(None)
    elif cmd == "search":
        result.append(trie.search(arg[0]))
    elif cmd == "startsWith":
        result.append(trie.starts_with(arg[0]))

print(json.dumps(result, separators=(',', ':')).replace('True', 'true').replace('False', 'false').replace('None', 'null'))
