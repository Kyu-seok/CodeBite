#!/usr/bin/env python3.12
"""chat-log-codec's Walkthrough: the reference solution (scripts/replay-solutions/chat-log-codec.py),
length-prefixed packing (`<length>#<message>`) and the unpack that reads it back, one frame per message
packed and per message unpacked on each sample Test Case, plus an extra run whose messages hold `#` and
digits.

    CODEBITE_DB=<database> scripts/walkthroughs/chat-log-codec.py

writes common/src/main/resources/walkthroughs/chat-log-codec.json.
"""
import json
import os
import sys

sys.dont_write_bytecode = True  # no __pycache__ beside the tracers
sys.path.insert(0, os.path.dirname(__file__))
from codebite import driver_list, josa, plural, sample_cases, sample_run, walkthrough_path  # noqa: E402
from walkthrough_trace import Walkthrough  # noqa: E402

SLUG = "chat-log-codec"
COLUMNS = [{"en": "text", "ko": "내용"}, {"en": "length", "ko": "길이"}]

wt = Walkthrough(
    {"en": "Chat Log Codec", "ko": "채팅 로그 코덱"},
    {"en": "Write each message as its length, a #, then the message: unpack reads the length first and takes "
           "exactly that many characters, so a # or a digit inside a message is never mistaken for a marker.",
     "ko": "메시지마다 길이, #, 메시지 순으로 적습니다. unpack은 길이를 먼저 읽고 정확히 그만큼의 문자를 가져오므로 "
           "메시지 안의 # 기호나 숫자를 구분자로 착각하지 않습니다."},
    views=[
        {"id": "messages", "type": "table", "title": {"en": "messages (sender)", "ko": "messages (보내는 쪽)"}},
        {"id": "blob", "type": "array", "title": {"en": "blob", "ko": "blob"}},
        {"id": "unpacked", "type": "table", "title": {"en": "unpack(blob) (receiver)", "ko": "unpack(blob) (받는 쪽)"}},
        {"id": "state", "type": "vars"},
    ],
)


def rows(messages):
    return [{"label": {"en": f"message {n}", "ko": f"메시지 {n}"}, "cells": [json.dumps(m, ensure_ascii=False), len(m)]}
            for n, m in enumerate(messages, start=1)]


def quoted(m):
    return json.dumps(m, ensure_ascii=False)


def solve(messages, run):
    """ListCoder.pack then ListCoder.unpack, as the Driver runs them, with a frame per message each way.
    Returns the answer as the Driver prints it."""
    blob = ""
    # the blob's final length, only so its cells keep their place while pack writes it (unwritten ones are blank)
    width = sum(len(f"{len(m)}#") + len(m) for m in messages)
    out = []
    i = None
    length = None

    def frame(caption, sent=(), sender_done=False, lit=(), good=(), got=(), path=False, **answer):
        sender_marks = ([[r, c] for r in range(len(messages)) for c in (0, 1)] if sender_done
                        else [[r, c] for r in sent for c in (0, 1)])
        run.frame(caption,
                  messages={"columns": COLUMNS, "rows": rows(messages),
                            "marks": {"dim" if sender_done else "lit": sender_marks}},
                  blob={"values": list(blob) + [""] * (width - len(blob)), "pointers": {"i": i if i is not None and i < len(blob) else None},
                        "marks": {"lit": list(lit), "good": list(good)}},
                  unpacked={"columns": COLUMNS, "rows": rows(out),
                            "marks": {"path" if path else "good": [[r, c] for r in got for c in (0, 1)]}},
                  state={"items": [{"label": "i", "value": "–" if i is None else i},
                                   {"label": {"en": "length", "ko": "length (길이)"}, "value": "–" if length is None else length}]},
                  **answer)

    count = len(messages)
    frame({"en": f"pack gets {count} {plural(count, 'message', 'messages')}. It writes each one as its length, "
                 f"a #, then the message itself, so the receiver never has to guess where a message ends.",
           "ko": f"pack이 메시지 {count}개를 받습니다. 메시지마다 길이, #, 메시지 순으로 적으므로 받는 쪽은 "
                 f"메시지가 어디서 끝나는지 추측할 필요가 없습니다."})
    # pack: "".join(f"{len(message)}#{message}" for message in messages)
    for n, message in enumerate(messages, start=1):
        piece = f"{len(message)}#{message}"
        start = len(blob)
        blob += piece
        what = ("an empty message, so nothing follows the #" if not message
                else f"{len(message)} {plural(len(message), 'character', 'characters')}")
        what_ko = ("빈 메시지라 # 뒤에 아무것도 붙지 않습니다" if not message else f"문자 {len(message)}개입니다")
        frame({"en": f"Message {n}, {quoted(message)}, is {what}: append {piece}.",
               "ko": f"메시지 {n}({quoted(message)}): {what_ko}. blob 끝에 이어 붙입니다: {piece}"},
              sent=[n - 1], good=range(start, len(blob)))
    i = 0
    frame({"en": f"pack returns the blob {blob}, {len(blob)} characters. unpack gets only this string and reads "
                 f"it from i = 0.",
           "ko": f"pack이 돌려준 문자열은 {blob}, 문자 {len(blob)}개입니다. unpack은 이 문자열만 받아 "
                 f"i = 0부터 읽습니다."},
          sender_done=True)
    # unpack
    while i < len(blob):
        hash_at = blob.index("#", i)
        length = int(blob[i:hash_at])
        start = hash_at + 1
        message = blob[start:start + length]
        out.append(message)
        head = range(i, hash_at + 1)
        took = range(start, start + length)
        at = i
        i = start + length
        n = len(out)
        if length:
            take = (f"take the next {length} {plural(length, 'character', 'characters')}, {quoted(message)}, "
                    f"as message {n}, whatever they are")
            take_ko = f"그 뒤의 문자 {length}개({quoted(message)})를 내용과 상관없이 {n}번째 메시지로 가져와"
        else:
            take = f"take 0 characters, so message {n} is the empty message \"\""
            take_ko = f"문자를 0개 가져와 {n}번째 메시지를 빈 메시지로 두고"
        note = note_ko = ""
        if "#" in message:
            note = " The # inside it is only a character: unpack never searches the counted characters for a marker."
            note_ko = " 그 안의 # 기호는 그냥 문자일 뿐, unpack은 길이만큼 가져오는 문자 안에서 구분자를 찾지 않습니다."
        frame({"en": f"At i = {at}, the digits up to the next # read {length}: {take}, then jump to i = {i}.{note}",
               "ko": f"i = {at}에서 다음 #까지의 숫자 {josa(length, '을를')} 읽고, {take_ko} "
                     f"i = {josa(i, '(으)로')} 건너뜁니다.{note_ko}"},
              sender_done=True, lit=head, good=took, got=[n - 1])
    answer = driver_list(out)
    frame({"en": f"i = {i} is the end of the blob, so unpack stops with {len(out)} "
                 f"{plural(len(out), 'message', 'messages')}, the same as the sender's: answer {answer}.",
           "ko": f"i = {i}에서 문자열이 끝나므로 unpack이 메시지 {len(out)}개로 멈춥니다. 보낸 쪽과 같으므로 "
                 f"답은 {answer}입니다."},
          sender_done=True, got=range(len(out)), path=True, answer=answer)


for number, sample in enumerate(sample_cases(SLUG), start=1):
    messages = json.loads(sample["input"])
    run = sample_run(wt, number, sample, input=f"messages = {sample['input']}")
    solve(messages, run)
extra = ["7#x", "#"]
extra_input = driver_list(extra)
solve(extra, wt.run({"en": "Markers inside", "ko": "메시지 안의 구분자"}, input=f"messages = {extra_input}",
                    expected=extra_input, extra=True))
wt.write(walkthrough_path(SLUG))
print(walkthrough_path(SLUG))
