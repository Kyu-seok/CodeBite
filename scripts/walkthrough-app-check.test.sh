#!/usr/bin/env bash
# Checks scripts/walkthrough-app-check.mjs without a real Chrome or servers: it parses, it refuses
# missing arguments with its usage and exit 2 before starting anything, and against a fake Chrome that
# accepts the DevTools socket but never answers, it fails naming the command and leaves no Chrome behind;
# and diagramBeside, which decides whether a problem gets the description's Diagrams beside the first frame.
set -uo pipefail
script="$(cd "$(dirname "$0")" && pwd)/walkthrough-app-check.mjs"
fail=0
node --check "$script" || { echo "FAIL: does not parse"; fail=1; }
out=$(node "$script" http://127.0.0.1:1 http://127.0.0.1:1/api /tmp/x 2>&1); code=$?
[[ $code == 2 && "$out" == *usage:* ]] || { echo "FAIL: a missing slug must print usage and exit 2 (got $code: $out)"; fail=1; }

# diagramBeside: a shot named after the slug for a description with Diagrams, none without, and only for
# fenced diagram-* blocks (not the word in prose or an inline span).
BESIDE="$(dirname "$script")/walkthrough-diagram-beside.mjs" node --input-type=module <<'JS' \
  || { echo "FAIL: diagramBeside decides the side-by-side shot"; fail=1; }
import assert from 'node:assert/strict';
const { diagramBeside } = await import(process.env.BESIDE);
const fence = '```';
const graph = `Intro.\n\n${fence}diagram-graph\nedges: [[0,1]]\n${fence}\n\nMore \`diagram-grid\` text.\n\n~~~diagram-intervals\nintervals: []\n~~~\n`;
assert.deepEqual(diagramBeside('cheapest-courier-route', graph),
  { name: 'cheapest-courier-route-diagram-beside-frame-1440', kinds: ['diagram-graph', 'diagram-intervals'] });
assert.equal(diagramBeside('two-sum', `No pictures.\n\n${fence}python\nprint(1)\n${fence}\n`), null);
assert.equal(diagramBeside('two-sum', 'Mentions diagram-graph in prose only.'), null);
assert.equal(diagramBeside('two-sum', null), null);
JS

dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT
cat > "$dir/silent-chrome.mjs" <<'JS'
#!/usr/bin/env node
// A stand-in for Chrome that starts and accepts the DevTools socket but never answers a command,
// as a real Chrome under load sometimes does. Writes its pid to $SILENT_CHROME_PID.
import { createServer } from 'node:http';
import { createHash } from 'node:crypto';
import { writeFileSync } from 'node:fs';

if (process.env.SILENT_CHROME_PID) writeFileSync(process.env.SILENT_CHROME_PID, String(process.pid));
const server = createServer((_req, res) => {
  const { port } = server.address();
  res.setHeader('content-type', 'application/json');
  res.end(JSON.stringify([{ type: 'page', webSocketDebuggerUrl: `ws://127.0.0.1:${port}/devtools/page/1` }]));
});
server.on('upgrade', (req, socket) => {
  const accept = createHash('sha1').update(req.headers['sec-websocket-key'] + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11').digest('base64');
  socket.write(`HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: ${accept}\r\n\r\n`);
  socket.on('data', () => {}); // read every command, answer none
});
server.listen(0, '127.0.0.1', () => process.stderr.write(`DevTools listening on ws://127.0.0.1:${server.address().port}/devtools/browser/x\n`));
JS
chmod +x "$dir/silent-chrome.mjs"
out=$(CHROME_PATH="$dir/silent-chrome.mjs" SILENT_CHROME_PID="$dir/chrome.pid" WALKTHROUGH_CDP_TIMEOUT_MS=500 \
  timeout 30 node "$script" http://127.0.0.1:1 http://127.0.0.1:1/api "$dir/shots" some-slug 2>&1); code=$?
[[ $code == 1 && "$out" == *"Chrome did not answer Page.enable within 500 ms"* ]] \
  || { echo "FAIL: a Chrome that stops answering must fail naming the command, exit 1 (got $code: $out)"; fail=1; }
pid=$(cat "$dir/chrome.pid" 2>/dev/null)
if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
  echo "FAIL: the fake Chrome ($pid) is still running after the check exited"; kill "$pid"; fail=1
fi
(( fail )) && exit 1
echo "PASS: walkthrough-app-check.mjs parses, refuses missing arguments, times out a silent Chrome, and picks its Diagram shot"
