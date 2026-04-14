{USER_CODE}

import json

cmds = json.loads(input())
args = json.loads(input())

dict_obj = None
result = []
for cmd, arg in zip(cmds, args):
    if cmd == "WordDictionary":
        dict_obj = WordDictionary()
        result.append(None)
    elif cmd == "addWord":
        dict_obj.add_word(arg[0])
        result.append(None)
    elif cmd == "search":
        result.append(dict_obj.search(arg[0]))

print(json.dumps(result, separators=(',', ':')).replace('True', 'true').replace('False', 'false').replace('None', 'null'))
