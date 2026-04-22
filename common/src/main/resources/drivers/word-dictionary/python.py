{USER_CODE}

import json

cmds = json.loads(input())
args = json.loads(input())

dict_obj = None
result = []
for cmd, arg in zip(cmds, args):
    if cmd == "WildcardLexicon":
        dict_obj = WildcardLexicon()
        result.append(None)
    elif cmd == "enroll":
        dict_obj.add_word(arg[0])
        result.append(None)
    elif cmd == "match":
        result.append(dict_obj.match(arg[0]))

print(json.dumps(result, separators=(',', ':')).replace('True', 'true').replace('False', 'false').replace('None', 'null'))
