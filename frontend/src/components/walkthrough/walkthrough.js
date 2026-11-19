// Walkthrough player: draws a Walkthrough (see references/format.md) as a stepped, flat 2D card.
// Framework-free ES module. `mount(root, walkthrough, options)` returns `{ show(run, frame), destroy() }`.

const NS = 'http://www.w3.org/2000/svg';
export const MARKS = ['dim', 'path', 'bad', 'good', 'lit']; // painted in this order: later wins

// ---------- small helpers ----------
function svg(tag, attrs = {}, parent) {
  const n = document.createElementNS(NS, tag);
  for (const k in attrs) if (attrs[k] != null) n.setAttribute(k, attrs[k]);
  if (parent) parent.appendChild(n);
  return n;
}
function html(tag, cls, parent, text) {
  const n = document.createElement(tag);
  if (cls) n.className = cls;
  if (text != null) n.textContent = text;
  if (parent) parent.appendChild(n);
  return n;
}
export function textOf(t, lang) {
  if (t == null) return '';
  if (typeof t === 'object' && !Array.isArray(t)) return t[lang] ?? t.en ?? Object.values(t)[0] ?? '';
  return String(t);
}
const fmt = v => (v == null ? '' : typeof v === 'object' ? JSON.stringify(v) : String(v));
const keyOf = v => (Array.isArray(v) ? v.join(',') : String(v));

// marks: { lit: [k, ...], good: [...] } -> Map(key -> strongest mark)
function markMap(marks) {
  const m = new Map();
  if (!marks) return m;
  for (const name of MARKS) for (const k of marks[name] || []) m.set(keyOf(k), name);
  return m;
}
const markClass = (m, k) => (m.has(keyOf(k)) ? ' wt-' + m.get(keyOf(k)) : '');

// ---------- graph layout (pure, exported for tests) ----------
// Nodes evenly on a circle, the first at the top, going clockwise, as a problem's graph Diagram draws them. The circle
// grows past its smallest radius only when neighbouring nodes would sit closer than GRAPH_GAP centre to centre.
// Returns { pos: Map(id -> {x, y}) centred on 0,0 with y down, radius }.
const GRAPH_MIN_RADIUS = 90, GRAPH_GAP = 96;
export function layoutGraph(nodes) {
  const n = nodes.length;
  const radius = n < 2 ? 0 : Math.max(GRAPH_MIN_RADIUS, GRAPH_GAP / (2 * Math.sin(Math.PI / n)));
  const pos = new Map(nodes.map((node, i) => {
    const t = -Math.PI / 2 + (i * 2 * Math.PI) / n;
    return [keyOf(node.id), { x: radius * Math.cos(t), y: radius * Math.sin(t) }];
  }));
  return { pos, radius };
}

// Where an edge's w × h label chip goes: beside the middle of the line (x1,y1)-(x2,y2), just clear of it, on the side
// away from the circle's centre (0,0). `side` overrides that: +1 is along (-dy, dx), -1 along (dy, -dx), the side a
// line of a pair drawn both ways is nudged to.
export function edgeLabelAt(x1, y1, x2, y2, w, h, side) {
  const dx = x2 - x1, dy = y2 - y1, len = Math.hypot(dx, dy) || 1;
  let nx = -dy / len, ny = dx / len;
  const mx = (x1 + x2) / 2, my = (y1 + y2) / 2;
  const s = side || (mx * nx + my * ny < -1e-9 ? -1 : 1);
  nx *= s; ny *= s;
  const off = Math.abs(nx) * w / 2 + Math.abs(ny) * h / 2 + 4;
  return { x: mx + nx * off, y: my + ny * off };
}

// The index of the edge a graph address `[from, to]` names (the first, if several do), or -1; an undirected edge
// answers to either order.
export function edgeAt(edges, [a, b], directed) {
  const is = (x, y) => String(x) === String(y);
  return (edges || []).findIndex(e => (is(e.from, a) && is(e.to, b)) || (!directed && is(e.from, b) && is(e.to, a)));
}

// ---------- views ----------
// Each view type: mount(host, config, ctx) -> { update(state), locate?(at), prepare?(states) }. `state` is the run's
// setup merged with the frame's; `prepare` gets every frame's state once per run, before the first update. `locate(at)`
// returns the element a move's address names (an array index, a map key, a set member), or null: a view type that holds values
// defines it, and kit/addresses.json says which `at` it takes.
export const VIEWS = {};

VIEWS.grid = (host, config, ctx) => {
  const S = 56, G = 6, P = 22;
  let built = null;
  function build(rows, cols) {
    host.innerHTML = '';
    const W = P + cols * (S + G) - G + 4, H = P + rows * (S + G) - G + 4;
    const root = svg('svg', { viewBox: `0 0 ${W} ${H}`, width: W, class: 'wt-svg wt-grid' }, host);
    const cells = [];
    for (let r = 0; r < rows; r++) for (let c = 0; c < cols; c++) {
      const g = svg('g', { transform: `translate(${P + c * (S + G)},${P + r * (S + G)})` }, root);
      if (c === 0) svg('text', { x: -8, y: S / 2 + 4, 'text-anchor': 'end', class: 'wt-index' }, g).textContent = r;
      if (r === 0) svg('text', { x: S / 2, y: -7, 'text-anchor': 'middle', class: 'wt-index' }, g).textContent = c;
      const tile = svg('rect', { x: 1, y: 1, width: S - 2, height: S - 2, rx: 8, class: 'wt-tile' }, g);
      const val = svg('text', { x: S / 2, y: S / 2 + 6, 'text-anchor': 'middle', class: 'wt-val' }, g);
      const tag = svg('text', { x: S / 2, y: 13, 'text-anchor': 'middle', class: 'wt-tag' }, g);
      cells.push({ r, c, g, tile, val, tag });
    }
    // `boxes`: a heavier line in the gap after every `boxes` rows and columns, as a sudoku board's 3×3 boxes
    const k = config.boxes;
    if (Number.isInteger(k) && k > 0) {
      const lines = svg('g', { class: 'wt-boxlines' }, root);
      const at = i => P + i * (S + G) - G / 2, x0 = P - 2, y0 = P - 2;
      const x1 = P + cols * (S + G) - G + 2, y1 = P + rows * (S + G) - G + 2;
      for (let c = k; c < cols; c += k) svg('line', { x1: at(c), x2: at(c), y1: y0, y2: y1, class: 'wt-boxline' }, lines);
      for (let r = k; r < rows; r += k) svg('line', { x1: x0, x2: x1, y1: at(r), y2: at(r), class: 'wt-boxline' }, lines);
    }
    return { rows, cols, cells };
  }
  const values = config.values || {};
  return {
    // A cell's address is [row, col]; a move starts from or lands on its tile, carrying the value drawn there.
    // `shade` lists cells drawn on a soft band, a region in play (a sudoku cell's row, column and box), under any mark.
    locate: at => (built && Array.isArray(at) && at.length === 2 && Number.isInteger(at[0]) && Number.isInteger(at[1]) &&
      at[0] >= 0 && at[0] < built.rows && at[1] >= 0 && at[1] < built.cols ? built.cells[at[0] * built.cols + at[1]].tile : null),
    update(s) {
      const rows = s.cells.length, cols = rows ? s.cells[0].length : 0;
      if (!built || built.rows !== rows || built.cols !== cols) built = build(rows, cols);
      const m = markMap(s.marks), tags = new Map((s.tags || []).map(([r, c, t]) => [r + ',' + c, t]));
      const shade = new Set((s.shade || []).map(keyOf));
      for (const { r, c, g, tile, val, tag } of built.cells) {
        const v = s.cells[r][c], spec = values[keyOf(v)] || {};
        g.setAttribute('class', 'wt-cell wt-tone-' + (spec.tone || 'plain') + markClass(m, [r, c]) + (shade.has(r + ',' + c) ? ' wt-shaded' : ''));
        val.textContent = spec.glyph != null ? spec.glyph : config.showValues === false ? '' : fmt(v);
        tile.dataset.token = val.textContent || `${r},${c}`;
        tag.textContent = textOf(tags.get(r + ',' + c), ctx.lang);
      }
    },
  };
};

// What an array state draws besides its cells: a span above (a window), a span below (a record), labels under cells.
function arrayNeeds(s) {
  const spans = Object.values(s.spans || {}).filter(Boolean);
  return { above: spans.some(sp => !sp.below), below: spans.some(sp => sp.below), under: !!(s.under || []).length };
}
// A label's width in px at 11px, for keeping it inside the drawing: wide (CJK) characters count double.
const labelWidth = t => [...t].reduce((w, ch) => w + (ch.codePointAt(0) > 0x2e80 ? 11 : 6.7), 0);

VIEWS.array = (host, config, ctx) => {
  const S = 46, G = 4, P = 10, ABOVE = 26, UNDER = 16;
  let built = null, room = { above: false, below: false, under: false };
  const bars = config.display === 'bars';
  function build(n, max) {
    host.innerHTML = '';
    const unit = bars ? Math.max(12, Math.min(28, 160 / Math.max(max, 1))) : 0;
    const barH = bars ? unit * Math.max(max, 1) : 0;
    const above = room.above ? ABOVE : 0, top = above + 18, W = P * 2 + n * (S + G) - G;
    const yIdx = top + (bars ? barH + 32 : S + 14), yUnder = yIdx + UNDER, yPtr = (room.under ? yUnder : yIdx) + 18;
    const yBelow = yPtr + 18, H = yPtr + (room.below ? 34 : 26);
    const root = svg('svg', { viewBox: `0 0 ${W} ${H}`, width: W, class: 'wt-svg wt-array' }, host);
    const items = [];
    for (let i = 0; i < n; i++) {
      const x = P + i * (S + G);
      const g = svg('g', { transform: `translate(${x},0)` }, root);
      const tag = svg('text', { x: S / 2, y: above + 11, 'text-anchor': 'middle', class: 'wt-tag' }, g);
      let box, fill, val;
      if (bars) {
        svg('line', { x1: -G / 2, x2: S + G / 2, y1: top + barH, y2: top + barH, class: 'wt-base' }, g);
        fill = svg('rect', { x: 2, width: S - 4, class: 'wt-fill' }, g);
        box = svg('rect', { x: 2, width: S - 4, rx: 3, class: 'wt-bar' }, g);
        val = svg('text', { x: S / 2, y: top + barH + 17, 'text-anchor': 'middle', class: 'wt-val wt-val-sm' }, g);
      } else {
        box = svg('rect', { x: 1, y: top, width: S - 2, height: S - 2, rx: 7, class: 'wt-tile' }, g);
        val = svg('text', { x: S / 2, y: top + S / 2 + 5, 'text-anchor': 'middle', class: 'wt-val' }, g);
      }
      svg('text', { x: S / 2, y: yIdx, 'text-anchor': 'middle', class: 'wt-index' }, g).textContent = i;
      const under = room.under ? svg('text', { x: S / 2, y: yUnder, 'text-anchor': 'middle', class: 'wt-under' }, g) : null;
      const ptr = svg('text', { x: S / 2, y: yPtr, 'text-anchor': 'middle', class: 'wt-ptr' }, g);
      items.push({ g, box, fill, val, tag, ptr, under });
    }
    const spans = svg('g', { class: 'wt-spans' }, root);
    return { n, max, items, unit, top, barH, W, yAbove: 8, aboveBase: above - 2, yBelow, spans, spanEls: new Map(), room: { ...room } };
  }
  // One bracket per span name, kept across frames so it slides: above, open at the bottom; below, dashed, open at the top.
  function drawSpans(spans) {
    const live = new Set();
    for (const [name, sp] of Object.entries(spans || {})) {
      if (!sp) continue;
      live.add(name);
      let el = built.spanEls.get(name);
      if (!el) {
        const g = svg('g', {}, built.spans);
        const line = svg('path', { class: 'wt-spanline' }, g), label = svg('g', { class: 'wt-spantag' }, g);
        el = { g, line, label, bg: svg('rect', { y: -11, height: 15, rx: 3, class: 'wt-spanbg' }, label), text: svg('text', { 'text-anchor': 'middle', class: 'wt-spanlabel' }, label) };
        built.spanEls.set(name, el);
      }
      const x1 = P + sp.from * (S + G) + 1, x2 = P + sp.to * (S + G) + S - 1;
      const y = sp.below ? built.yBelow : built.yAbove, y0 = sp.below ? y - 8 : built.aboveBase;
      const d = sp.below ? `M${x1},${y0} L${x1},${y + 4} L${x2},${y + 4} L${x2},${y0}` : `M${x1},${y0} L${x1},${y} L${x2},${y} L${x2},${y0}`;
      el.line.setAttribute('d', d); el.line.style.d = `path("${d}")`;
      el.g.setAttribute('class', 'wt-span' + (sp.below ? ' wt-below' : '') + (sp.mark ? ' wt-' + sp.mark : ''));
      const label = sp.label != null ? textOf(sp.label, ctx.lang) : name;
      const half = labelWidth(label) / 2 + 3;
      const cx = Math.max(half, Math.min(built.W - half, (x1 + x2) / 2));
      el.text.textContent = label;
      el.bg.setAttribute('x', -half); el.bg.setAttribute('width', 2 * half); // the line stops at the label's edges
      el.label.style.transform = `translate(${cx}px, ${y + (sp.below ? 8 : 4)}px)`;
    }
    for (const [name, el] of built.spanEls) if (!live.has(name)) { el.g.remove(); built.spanEls.delete(name); }
  }
  return {
    locate: at => (built && Number.isInteger(at) && built.items[at] ? built.items[at].g : null),
    // the run's every state, before its first frame: room for spans and labels is kept for the whole run, so the cells never jump
    prepare(states) {
      for (const st of states) { const n = arrayNeeds(st); for (const k in n) room[k] = room[k] || n[k]; }
      built = null;
    },
    update(s) {
      const vals = s.values || [], fills = s.fill || [];
      const max = bars ? Math.max(1, ...vals.map((v, i) => (+v || 0) + (+fills[i] || 0)), config.max || 0) : 0;
      if (!vals.length) { host.innerHTML = ''; built = null; html('span', 'wt-empty', host, config.empty != null ? textOf(config.empty, ctx.lang) : ctx.ui.empty); return; }
      const need = arrayNeeds(s);
      const grow = Object.keys(need).some(k => need[k] && !room[k]);
      for (const k in need) room[k] = room[k] || need[k];
      if (!built || grow || built.n !== vals.length || (bars && max > built.max)) built = build(vals.length, max);
      const m = markMap(s.marks), tags = new Map((s.tags || []).map(([i, t]) => [String(i), t]));
      const unders = new Map((s.under || []).map(([i, t]) => [String(i), t]));
      const unread = new Set(s.unread || []);
      const fades = Object.values(s.spans || {}).filter(sp => sp && sp.fade);
      const ptrs = new Map();
      for (const [name, i] of Object.entries(s.pointers || {})) if (i != null) ptrs.set(i, [...(ptrs.get(i) || []), name]);
      built.items.forEach(({ g, box, fill, val, tag, ptr, under }, i) => {
        const faded = !m.has(keyOf(i)) && fades.some(sp => i < sp.from || i > sp.to);
        g.setAttribute('class', 'wt-item' + markClass(m, i) + (ptrs.has(i) ? ' wt-pointed' : '') +
          (faded ? ' wt-faded' : '') + (unread.has(i) ? ' wt-unread' : ''));
        val.textContent = fmt(vals[i]);
        tag.textContent = textOf(tags.get(String(i)), ctx.lang);
        if (under) under.textContent = textOf(unders.get(String(i)), ctx.lang);
        ptr.textContent = (ptrs.get(i) || []).join(' ');
        if (bars) {
          const { unit, top, barH } = built, h = (+vals[i] || 0) * unit, f = (+fills[i] || 0) * unit;
          box.style.height = h + 'px'; box.style.y = top + barH - h + 'px';
          fill.style.height = f + 'px'; fill.style.y = top + barH - h - f + 'px';
        }
      });
      drawSpans(s.spans);
    },
  };
};

// A hash map: one card per key in insertion order. A count is drawn as dots and the number, a list as chips. An entry's
// `label` is written on its card in place of the key; its `marks` mark chips of a list value by index.
// `slots` (at most k keys) draws the free slots dashed and a key beyond them red; a `struck` key is leaving.
// A `probe` is a lookup: a chip above the cards, ✓ with its key's card ringed on a hit, red and ✗ on a miss. Its
// `hit` (default: the key is held) says what the lookup found when the step stores the key after looking it up.
const MAX_DOTS = 10;
VIEWS.map = (host, config, ctx) => {
  host.innerHTML = '';
  const box = html('div', 'wt-map', host);
  const cards = new Map(); // String(key) -> card element, kept so marks transition
  let empty = null, free = [], probe = null, most = 0;
  return {
    locate: at => cards.get(String(at)) || null,
    // the run's every state, before its first frame: the box keeps room for its fullest frame's cards (as invisible
    // spacers, so it still wraps on a narrow screen) and a run that looks keys up keeps the lookup row in every frame,
    // so the views around the map never jump
    prepare(states) {
      most = Math.max(0, ...states.map(st => Math.max((st.entries || []).length, Number.isInteger(st.slots) ? st.slots : 0)));
      if (probe) probe.remove();
      probe = states.some(st => st.probe) ? html('div', 'wt-mapprobe', null) : null;
    },
    update(s) {
      const m = markMap(s.marks), entries = s.entries || [];
      const rank = new Map((s.ranks || []).map((k, i) => [String(k), i + 1]));
      const struck = new Set((s.struck || []).map(String));
      const slots = Number.isInteger(s.slots) ? s.slots : null;
      const live = new Set(entries.map(e => String(e.key)));
      for (const [k, el] of cards) if (!live.has(k)) { el.remove(); cards.delete(k); }
      for (const el of free) el.remove();
      free = [];
      if (empty) { empty.remove(); empty = null; }
      if (probe) {
        box.prepend(probe);
        const hit = !!s.probe && (s.probe.hit ?? live.has(String(s.probe.key)));
        probe.className = 'wt-mapprobe' + (!s.probe ? ' wt-idle' : hit ? ' wt-hit' : ' wt-miss');
        probe.replaceChildren(html('span', 'wt-mapprobechip', null,
          s.probe ? `${s.probe.label != null ? textOf(s.probe.label, ctx.lang) : fmt(s.probe.key)} ${hit ? '✓' : '✗'}` : '\u00a0'));
      }
      if (!entries.length && !slots) empty = html('span', 'wt-empty', box, config.empty != null ? textOf(config.empty, ctx.lang) : 'empty');
      let held = 0; // keys holding a slot: a struck key is leaving and holds none
      for (const e of entries) {
        const k = String(e.key), gone = struck.has(k), over = !gone && slots != null && held++ >= slots;
        let card = cards.get(k);
        if (!card) { card = html('div', null, null); cards.set(k, card); }
        box.appendChild(card); // insertion order
        card.className = 'wt-mapcard' + markClass(m, e.key) + (rank.size && !rank.has(k) ? ' wt-unranked' : '') +
          (over ? ' wt-over' : '') + (gone ? ' wt-struck' : '') +
          (s.probe && s.probe.hit !== false && String(s.probe.key) === k ? ' wt-probed' : '');
        card.dataset.token = fmt(e.key);
        card.innerHTML = '';
        if (rank.has(k)) html('span', 'wt-rank', card, '#' + rank.get(k));
        html('div', 'wt-mapkey', card, e.label != null ? textOf(e.label, ctx.lang) : fmt(e.key));
        const v = e.value;
        if (Array.isArray(v)) {
          const chips = html('div', 'wt-chips', card), cm = markMap(e.marks);
          v.forEach((x, i) => html('span', 'wt-chip' + markClass(cm, i), chips, fmt(x)));
        } else if (Number.isInteger(v) && v >= 0 && v <= MAX_DOTS) {
          const dots = html('div', 'wt-dots', card);
          for (let i = 0; i < v; i++) html('span', 'wt-dot', dots);
          html('div', 'wt-mapval', card, fmt(v));
        } else html('div', 'wt-mapval', card, fmt(v));
      }
      for (let i = held; i < (slots || 0); i++) free.push(html('div', 'wt-mapslot', box)); // the slots still free
      for (let i = entries.length + free.length; i < most; i++) free.push(html('div', 'wt-mapspace', box));
    },
  };
};

// A set: a bag of member chips in insertion order. Each probe is a lookup drawn above the bag: a hit lights the member
// it finds, a miss is drawn dashed. `hit` defaults to whether the value is a member; a value looked up and then added in the
// same step is a miss (`hit: false`) with its member marked `good`. Address: a member.
const SET_TEXT = { en: { hit: 'in the set', miss: 'not in the set' }, ko: { hit: '집합에 있음', miss: '집합에 없음' } };
VIEWS.set = (host, config, ctx) => {
  host.innerHTML = '';
  const words = { ...SET_TEXT.en, ...(SET_TEXT[ctx.lang] || {}) };
  const word = k => (config[k] != null ? textOf(config[k], ctx.lang) : words[k]);
  const probes = html('div', 'wt-probes', host);
  const bag = html('div', 'wt-set', host);
  const chips = new Map(); // String(member) -> chip, kept so marks transition
  let empty = null, probing = false; // probing: some frame of the run looks a value up, so the probe row keeps its room
  return {
    locate: at => chips.get(String(at)) || null,
    // the run's every state, before its first frame: the bag is sized for the most members it will hold, so it never
    // grows during the run and the views beside it don't jump onto another line
    prepare(states) {
      let most = 0, widest = 0;
      probing = states.some(st => (st.probes || []).length);
      for (const st of states) {
        most = Math.max(most, (st.members || []).length);
        for (const v of st.members || []) widest = Math.max(widest, labelWidth(fmt(v)) * 14 / 11);
      }
      const chip = widest + 30, perLine = Math.max(1, Math.floor((420 - 24 + 6) / (chip + 6)));
      bag.style.width = most ? Math.min(420, 24 + Math.min(most, perLine) * (chip + 6)) + 'px' : '';
      bag.style.minHeight = most ? 24 + Math.ceil(most / perLine) * 36 - 6 + 'px' : '';
    },
    update(s) {
      const m = markMap(s.marks), members = s.members || [];
      const has = new Set(members.map(String));
      const list = (s.probes || []).map(pr => ({ ...pr, hit: pr.hit ?? has.has(String(pr.value)) }));
      const found = new Set(list.filter(pr => pr.hit).map(pr => String(pr.value)));
      probes.innerHTML = '';
      probes.hidden = !list.length && !probing;
      probes.style.visibility = list.length ? '' : 'hidden';
      for (const pr of list) {
        const el = html('div', 'wt-probe ' + (pr.hit ? 'wt-hit' : 'wt-miss'), probes);
        if (pr.label != null) html('span', 'wt-probelabel', el, textOf(pr.label, ctx.lang));
        html('span', 'wt-probevalue', el, fmt(pr.value));
        html('span', 'wt-probeword', el, (pr.hit ? '✓ ' : '✗ ') + word(pr.hit ? 'hit' : 'miss'));
      }
      for (const [k, el] of chips) if (!has.has(k)) { el.remove(); chips.delete(k); }
      if (empty) { empty.remove(); empty = null; }
      if (!members.length) empty = html('span', 'wt-empty', bag, config.empty != null ? textOf(config.empty, ctx.lang) : 'empty');
      for (const v of members) {
        const k = String(v);
        let chip = chips.get(k);
        if (!chip) { chip = html('span', null, null); chips.set(k, chip); }
        bag.appendChild(chip); // insertion order
        chip.className = 'wt-member' + markClass(m, v) + (found.has(k) && !m.has(k) ? ' wt-lit' : '') + (found.has(k) ? ' wt-found' : '');
        chip.textContent = fmt(v);
        chip.dataset.token = fmt(v);
      }
    },
  };
};

// The answer as it forms: a box its values move into, one chip per value. The box keeps room for the run's fullest
// frame (its chips still to come are drawn invisible), so the views around it never jump as the answer grows.
VIEWS.output = (host, config, ctx) => {
  host.innerHTML = '';
  const box = html('div', 'wt-output', host);
  let chips = [], fullest = [];
  return {
    locate: at => (Number.isInteger(at) && chips[at]) || null,
    prepare(states) {
      fullest = states.reduce((most, st) => ((st.values || []).length > most.length ? st.values : most), []);
    },
    update(s) {
      const m = markMap(s.marks), values = s.values || [];
      box.innerHTML = '';
      if (!values.length) html('span', 'wt-empty', box, config.empty != null ? textOf(config.empty, ctx.lang) : 'empty');
      chips = values.map((v, i) => html('span', 'wt-outchip' + markClass(m, i), box, fmt(v)));
      for (const v of fullest.slice(values.length)) html('span', 'wt-outchip wt-outspace', box, fmt(v));
    },
  };
};

// A queue as a horizontal pipe, front on the left: values join at the back (right) and leave from the front (left).
// `deque: true` opens both ends. A value's address is its position from the front; `tags` label positions above.
VIEWS.queue = (host, config, ctx) => {
  host.innerHTML = '';
  const deque = config.deque === true;
  const box = html('div', 'wt-queue' + (deque ? ' wt-deque' : ''), host);
  const end = (cls, arrow, word) => {
    const e = html('div', 'wt-qend ' + cls, box);
    html('span', 'wt-qarrow', e, arrow);
    html('span', 'wt-qword', e, word);
    return e;
  };
  end('wt-qfront', deque ? '⇆' : '←', ctx.ui.front);
  const pipe = html('div', 'wt-qpipe', box);
  end('wt-qback', deque ? '⇆' : '←', ctx.ui.back);
  let items = [];
  return {
    locate: at => (Number.isInteger(at) && items[at]) || null,
    update(s) {
      const m = markMap(s.marks), values = s.values || [];
      const tags = new Map((s.tags || []).map(([i, t]) => [i, t]));
      pipe.innerHTML = '';
      if (!values.length) html('span', 'wt-empty', pipe, config.empty != null ? textOf(config.empty, ctx.lang) : ctx.ui.empty);
      items = values.map((v, i) => {
        const it = html('div', 'wt-qitem' + markClass(m, i), pipe);
        it.dataset.token = fmt(v);
        html('span', 'wt-qtag', it, textOf(tags.get(i), ctx.lang));
        html('span', 'wt-qval', it, fmt(v));
        return it;
      });
    },
  };
};

// Intervals on one number line, in the style of a problem's intervals Diagram: one row per interval, its
// `[start, end]` label left of a bar, groups (the input, the merged output) stacked over one shared axis.
// `points` draw a value across every row, such as the boundary a step compares. Address: [group, index].
export function axisTicks(min, max) {
  const ticksAt = step => {
    const first = Math.ceil(min / step) * step, count = Math.floor((max - first) / step) + 1;
    return Array.from({ length: Math.max(0, count) }, (_, i) => first + i * step);
  };
  const miss = n => (n < 5 ? 5 / n : n > 10 ? n / 10 : 1); // 5 to 10 ticks, every multiple of 1, 2 or 5 × 10^k
  let best = ticksAt(1);
  for (let power = 1; power < 1e12; power *= 10) for (const m of [1, 2, 5]) {
    const t = ticksAt(m * power);
    if (miss(t.length) === 1) return t;
    if (miss(t.length) < miss(best.length)) best = t;
    if (t.length < 5) return best;
  }
  return best;
}
VIEWS.intervals = (host, config, ctx) => {
  const CHAR = 7.3, PLOT = 280, PAD = 12, ROW = 24, BAR = 12, HEAD = 18, TOP = 20, AXIS = 26, MIN_BAR = 4;
  let bars = new Map(); // "group,index" -> bar rect
  return {
    locate: at => (Array.isArray(at) ? bars.get(at.join(',')) || null : null),
    update(s) {
      host.innerHTML = '';
      bars = new Map();
      const groups = s.groups || [], points = s.points || [];
      const values = [...groups.flatMap(g => (g.intervals || []).flat()), ...points.map(p => p.at)];
      const [lo, hi] = s.domain || (values.length ? [Math.min(...values), Math.max(...values)] : [0, 1]);
      const span = hi - lo || 1;
      const label = ([a, b]) => `[${a}, ${b}]`;
      // the label column fits the widest label any interval on this axis could have, so it doesn't shift as values change
      const chars = Math.max(label([lo, hi]).length, ...groups.flatMap(g => (g.intervals || []).map(iv => label(iv).length)));
      const labelW = PAD + chars * CHAR, plotX = labelW + PAD;
      const xOf = v => plotX + (hi === lo ? PLOT / 2 : ((v - lo) / span) * PLOT);
      const rows = groups.reduce((n, g) => n + (g.label != null ? HEAD : 0) + Math.max(1, (g.intervals || []).length) * ROW, 0);
      const plotBottom = TOP + rows, W = plotX + PLOT + PAD, H = plotBottom + AXIS;
      const root = svg('svg', { viewBox: `0 0 ${W} ${H}`, width: W, class: 'wt-svg wt-intervals' }, host);
      const lines = svg('g', {}, root);
      let y = TOP;
      groups.forEach((g, gi) => {
        if (g.label != null) { svg('text', { x: PAD, y: y + 12, class: 'wt-ivgroup' }, root).textContent = textOf(g.label, ctx.lang); y += HEAD; }
        const m = markMap(g.marks), list = g.intervals || [];
        if (!list.length) svg('text', { x: plotX, y: y + ROW / 2 + 4, class: 'wt-ivempty' }, root).textContent = config.empty != null ? textOf(config.empty, ctx.lang) : 'empty';
        list.forEach(([a, b], i) => {
          const cy = y + i * ROW + ROW / 2;
          const row = svg('g', { class: 'wt-ivrow' + markClass(m, i) }, root);
          svg('text', { x: labelW, y: cy + 4, 'text-anchor': 'end', class: 'wt-ivlabel' }, row).textContent = label([a, b]);
          const len = xOf(b) - xOf(a), w = Math.max(len, MIN_BAR), x = len < MIN_BAR ? xOf(a) - MIN_BAR / 2 : xOf(a);
          const bar = svg('rect', { x, y: cy - BAR / 2, width: w, height: BAR, rx: 3, class: 'wt-ivbar', 'data-token': `[${a},${b}]` }, row);
          bars.set(gi + ',' + i, bar);
        });
        y += Math.max(1, list.length) * ROW;
      });
      // points: a dashed line across every row; a label near an end of the axis, or near another label, goes beside its line
      const placed = points.map((p, i) => ({ p, i, x: xOf(p.at) })).sort((a, b) => a.x - b.x);
      placed.forEach((q, j) => {
        const prev = placed[j - 1], next = placed[j + 1];
        const near = 40, edge = 36;
        const anchor = (prev && q.x - prev.x < near) || q.x < plotX + edge ? 'start'
          : (next && next.x - q.x < near) || q.x > plotX + PLOT - edge ? 'end' : 'middle';
        const pg = svg('g', { class: 'wt-ivpoint' + (q.p.mark ? ' wt-' + q.p.mark : '') }, lines);
        svg('line', { x1: q.x, x2: q.x, y1: TOP - 4, y2: plotBottom, class: 'wt-ivpline' }, pg);
        const text = (q.p.label != null ? textOf(q.p.label, ctx.lang) + ' ' : '') + fmt(q.p.at);
        svg('text', { x: q.x + (anchor === 'start' ? 3 : anchor === 'end' ? -3 : 0), y: TOP - 8, 'text-anchor': anchor, class: 'wt-ivptext' }, pg).textContent = text;
      });
      svg('line', { x1: plotX, x2: plotX + PLOT, y1: plotBottom + 4, y2: plotBottom + 4, class: 'wt-ivaxis' }, root);
      for (const v of axisTicks(lo, hi)) {
        svg('line', { x1: xOf(v), x2: xOf(v), y1: plotBottom + 4, y2: plotBottom + 8, class: 'wt-ivaxis' }, root);
        svg('text', { x: xOf(v), y: plotBottom + 19, 'text-anchor': 'middle', class: 'wt-index' }, root).textContent = v;
      }
    },
  };
};

VIEWS.graph = (host, config, ctx) => {
  const R = 20, MX = 56, MY = 42; // node radius; the room beside and above or below the circle for a node's tag and value
  let built = null;
  function build(nodes, edges) {
    host.innerHTML = '';
    const directed = config.directed !== false;
    const { pos, radius } = layoutGraph(nodes);
    // the drawing is sized once for the run (no crop to what is drawn: the values under the nodes come later)
    const CX = radius + R + MX, CY = radius + R + MY, W = 2 * CX, H = 2 * CY;
    const P = id => { const p = pos.get(keyOf(id)); return [CX + p.x, CY + p.y]; };
    const root = svg('svg', { viewBox: `0 0 ${W} ${H}`, width: W, class: 'wt-svg wt-graph' }, host);
    const defs = svg('defs', {}, root);
    for (const m of ['plain', ...MARKS]) {
      const mk = svg('marker', { id: `${ctx.uid}-ah-${m}`, viewBox: '0 0 10 10', refX: 9, refY: 5, markerWidth: 11, markerHeight: 11, markerUnits: 'userSpaceOnUse', orient: 'auto-start-reverse' }, defs);
      svg('path', { d: 'M0,0 L10,5 L0,10 z', class: 'wt-ah wt-ah-' + m }, mk);
    }
    // straight lines trimmed to the node circles; a directed pair both ways is two lines, each nudged to its left
    const pairs = new Set(edges.map(e => keyOf(e.from) + '>' + keyOf(e.to)));
    const eg = svg('g', {}, root), lg = svg('g', {}, root);
    const edgeEls = edges.map(e => {
      const [ax, ay] = P(e.from), [bx, by] = P(e.to);
      const len = Math.hypot(bx - ax, by - ay) || 1, ux = (bx - ax) / len, uy = (by - ay) / len;
      const both = directed && pairs.has(keyOf(e.to) + '>' + keyOf(e.from));
      const nudge = both ? 5 : 0, sx = uy * nudge, sy = -ux * nudge; // along (dy, -dx): side -1 of edgeLabelAt
      const end = directed ? R + 3 : R;
      const x1 = ax + ux * R + sx, y1 = ay + uy * R + sy, x2 = bx - ux * end + sx, y2 = by - uy * end + sy;
      const g = svg('g', {}, eg);
      const path = svg('path', { d: `M${x1},${y1} L${x2},${y2}`, class: 'wt-edge' }, g);
      // a move to or from the edge lands on its label chip, or on a dot at its middle when it has no label; the
      // labels are drawn above every line, so no other edge crosses a weight
      let spot, label = null;
      if (e.label != null) {
        const t = textOf(e.label, ctx.lang), w = 10 + 7.5 * t.length;
        const c = edgeLabelAt(ax - CX, ay - CY, bx - CX, by - CY, w, 18, both ? -1 : 0);
        label = svg('g', {}, lg);
        spot = svg('rect', { x: CX + c.x - w / 2, y: CY + c.y - 9, width: w, height: 18, rx: 9, class: 'wt-chipbg' }, label);
        svg('text', { x: CX + c.x, y: CY + c.y + 4, 'text-anchor': 'middle', class: 'wt-elabel' }, label).textContent = t;
        spot.dataset.token = t;
      } else spot = svg('circle', { cx: (x1 + x2) / 2, cy: (y1 + y2) / 2, r: 1, class: 'wt-espot' }, g);
      return { g, path, directed, spot, label };
    });
    // a node's tag and value sit outside the circle, beside the node on the side facing away from the centre, the
    // value nearer the node, so no edge runs through them
    const nodeEls = new Map();
    for (const n of nodes) {
      const [x, y] = P(n.id), p = pos.get(keyOf(n.id)), r = Math.hypot(p.x, p.y);
      const ux = r ? p.x / r : 0, uy = r ? p.y / r : -1;
      const g = svg('g', { transform: `translate(${x},${y})` }, root);
      const circle = svg('circle', { r: R, class: 'wt-node' }, g);
      const name = n.label != null ? textOf(n.label, ctx.lang) : fmt(n.id);
      svg('text', { y: 5, 'text-anchor': 'middle', class: 'wt-nid' }, g).textContent = name;
      const lines = n.tag != null ? (uy < 0 ? ['tag', 'val'] : ['val', 'tag']) : ['val'];
      const LINE = 16, h = lines.length * LINE, ax = ux * (R + 6), ay = uy * (R + 6);
      const top = ay - h * (1 - (uy + 1) / 2), anchor = ux > 0.4 ? 'start' : ux < -0.4 ? 'end' : 'middle';
      const line = i => ({ x: ax, y: top + i * LINE + 12, 'text-anchor': anchor });
      if (n.tag != null) svg('text', { ...line(lines.indexOf('tag')), class: 'wt-tag wt-ntag' }, g).textContent = textOf(n.tag, ctx.lang);
      const val = svg('text', { ...line(lines.indexOf('val')), class: 'wt-val wt-val-sm wt-nval' }, g);
      nodeEls.set(keyOf(n.id), { g, val, circle, name });
    }
    return { nodes, edges, edgeEls, nodeEls, directed };
  }
  return {
    // A node's address is its id, an edge's [from, to]; a move from a node carries the value under it (else its name),
    // one from an edge its label.
    locate: at => {
      if (!built) return null;
      if (!Array.isArray(at)) return built.nodeEls.get(keyOf(at))?.circle || null;
      const i = at.length === 2 ? edgeAt(built.edges, at, built.directed) : -1;
      return i >= 0 ? built.edgeEls[i].spot : null;
    },
    update(s) {
      if (!built || built.nodes !== s.nodes || built.edges !== s.edges) built = build(s.nodes || [], s.edges || []);
      const nm = markMap(s.nodeMarks), em = markMap(s.edgeMarks), values = s.values || {};
      built.edgeEls.forEach(({ g, path, directed, label }, i) => {
        const m = em.get(String(i)) || 'plain';
        g.setAttribute('class', 'wt-e wt-' + m);
        if (label) label.setAttribute('class', 'wt-e wt-elab wt-' + m);
        if (directed) path.setAttribute('marker-end', `url(#${ctx.uid}-ah-${m})`);
      });
      for (const [id, { g, val, circle, name }] of built.nodeEls) {
        g.setAttribute('class', 'wt-n' + markClass(nm, id));
        val.textContent = fmt(values[id]);
        circle.dataset.token = val.textContent || name;
      }
    },
  };
};

// ---------- tree layout (pure, exported for tests) ----------
// A tidy tree: each node gets a span across (its own room, or its children's spans side by side) and sits centred
// over its children; each depth is one level, the root's at the top, or at the left when `sideways`. With an
// `arity`, a node's children take fixed slots and a missing child leaves a gap of its own, so a binary tree's lone
// right child sits right of its parent. `size(id)` is a node's { w, h } (h holds its tag under it), `label(id)` the
// width of the label on the edge into it: upright, a child's span keeps that label clear of its siblings'.
// Returns { pos: Map(id -> pill centre), width, height }.
const TREE = { LINK_GAP: 30, SIDE_LINK_GAP: 24, PH: 28, GAP: 12, GHOST: 30, LEVEL: 40, SIDE_GAP: 8, SIDE_GHOST: 16, SIDE_LEVEL: 30, AT: 0.7, PAD: 6 };
export function layoutTree(nodes, edges, opts = {}) {
  const { arity = 0, sideways = false } = opts;
  const size = opts.size || (() => ({ w: 32, h: TREE.PH })), label = opts.label || (() => 0);
  const ids = nodes.map(n => keyOf(n.id));
  const kids = new Map(ids.map(id => [id, []])), hasParent = new Set(), nth = new Map();
  for (const e of edges) {
    const a = keyOf(e.from), b = keyOf(e.to);
    if (!kids.has(a) || !kids.has(b) || hasParent.has(b)) continue;
    hasParent.add(b);
    const i = nth.get(a) || 0, list = kids.get(a);
    nth.set(a, i + 1);
    if (!arity) { list.push(b); continue; }
    while (list.length < arity) list.push(null);
    const slot = e.slot ?? i;
    if (slot >= 0 && slot < arity && list[slot] == null) list[slot] = b;
  }
  const gap = opts.gap ?? (sideways ? TREE.SIDE_GAP : TREE.GAP), ghost = sideways ? TREE.SIDE_GHOST : TREE.GHOST;
  const across = id => (sideways ? size(id).h : size(id).w);
  const need = id => Math.max(across(id), sideways ? 0 : label(id) / TREE.AT) + gap;
  const span = new Map();
  const spanOf = id => {
    if (span.has(id)) return span.get(id);
    span.set(id, need(id)); // a cycle (refused by validate) stops here
    const sum = kids.get(id).reduce((t, c) => t + (c == null ? ghost : spanOf(c)), 0);
    span.set(id, Math.max(need(id), sum));
    return span.get(id);
  };
  const mid = new Map(), depth = new Map();
  const place = (id, start, d) => {
    depth.set(id, d);
    const list = kids.get(id), s = span.get(id);
    let x = start + (s - list.reduce((t, c) => t + (c == null ? ghost : span.get(c)), 0)) / 2;
    const centres = [];
    for (const c of list) {
      const w = c == null ? ghost : span.get(c);
      if (c != null && !depth.has(c)) place(c, x, d + 1);
      centres.push(x + w / 2);
      x += w;
    }
    mid.set(id, list.length ? (centres[0] + centres[centres.length - 1]) / 2 : start + s / 2);
  };
  let start = TREE.PAD;
  // the roots side by side, then anything a cycle kept from them (refused by validate)
  for (const id of [...ids.filter(i => !hasParent.has(i)), ...ids]) if (!depth.has(id)) { spanOf(id); place(id, start, 0); start += span.get(id); }
  // each level is as deep as its biggest node: upright its tallest (pill and tag), sideways its widest
  const levels = [];
  for (const id of ids) { const d = depth.get(id); levels[d] = Math.max(levels[d] || 0, sideways ? size(id).w : size(id).h); }
  const widest = Math.max(0, ...ids.map(label));
  const step = sideways ? Math.max(TREE.SIDE_LEVEL, widest + 16) : TREE.LEVEL;
  const at = [];
  let edge = TREE.PAD;
  levels.forEach((l, d) => { at[d] = edge; edge += (l || 0) + step; });
  const deep = edge - step + TREE.PAD, wide = start + TREE.PAD;
  const pos = new Map(ids.map(id => {
    const d = depth.get(id), m = mid.get(id), h = size(id).h;
    return [id, sideways ? { x: at[d] + levels[d] / 2, y: m - (h - TREE.PH) / 2 } : { x: m, y: at[d] + TREE.PH / 2 }];
  }));
  return { pos, width: sideways ? deep : wide, height: sideways ? wide : deep };
}

// How a tree's second link (`links`: next to the node on its right) is drawn: a straight arrow from one pill's edge to
// the other's, so a link along a level runs level through the gap between the pills; a pair each way between two
// nodes takes a lane each, 5px to either side. `null` hooks out to ∅ just past the pill: on its right upright, under
// it on its side, where a level runs down the column. `box(id)` is a pill's { x, y, w, h } (centre and size), or
// nothing for a node not drawn. Returns [{ from, to, x1, y1, x2, y2, nil? }], ids as text, nil the ∅'s centre.
const TREE_NIL = 16;
export function treeLinks(to, box, opts = {}) {
  const arrows = [];
  for (const [k, t] of Object.entries(to)) {
    const a = box(k);
    if (!a) continue;
    if (t == null) {
      const [x, y] = opts.sideways ? [a.x, a.y + a.h / 2 + TREE_NIL] : [a.x + a.w / 2 + TREE_NIL, a.y];
      arrows.push({ from: k, to: null, x1: opts.sideways ? a.x : a.x + a.w / 2, y1: opts.sideways ? a.y + a.h / 2 : a.y, x2: x, y2: y, nil: [x, y] });
      continue;
    }
    const b = box(keyOf(t));
    if (!b || keyOf(t) === k) continue;
    const dx = b.x - a.x, dy = b.y - a.y;
    const clip = p => Math.min(dx ? p.w / 2 / Math.abs(dx) : Infinity, dy ? p.h / 2 / Math.abs(dy) : Infinity);
    const ta = clip(a), tb = clip(b);
    // a pair each way: the link to the right (or down) takes the lane before it, the one back the lane after
    const back = to[keyOf(t)] != null && keyOf(to[keyOf(t)]) === k, len = Math.hypot(dx, dy);
    const lane = back ? (dx > 0 || (!dx && dy > 0) ? -5 : 5) * Math.sign(dx || dy) : 0;
    const ox = (-dy / len) * lane, oy = (dx / len) * lane;
    arrows.push({ from: k, to: keyOf(t), x1: a.x + dx * ta + ox, y1: a.y + dy * ta + oy, x2: b.x - dx * tb + ox, y2: b.y - dy * tb + oy });
  }
  return arrows;
}

// Whether a tree goes on its side: only when it is wider upright than the room it has (`room`, 0 when unknown) and
// narrower on its side, where it grows down instead of across.
export const treeSideways = (upright, side, room) => room > 0 && upright.width > room && side.width < upright.width;

// A tree: nodes as pills joined by edges to their children, upright with the root at the top, or on its side with the
// root at the left when it would not fit upright (treeSideways). The layout is the run's whole tree (every node any
// frame draws), so a growing tree keeps every node in place and a node appears where it will stay. `tags` write a
// short label under a node (bounds, a count, a heap index), `shade` the nodes on the current path (the open calls).
// Address: a node id, or an edge as [from, to].
VIEWS.tree = (host, config, ctx) => {
  const PH = TREE.PH, arity = Number.isInteger(config.arity) ? config.arity : 0;
  const width = (t, px) => [...t].reduce((w, ch) => w + (ch.codePointAt(0) > 0x2e80 ? px : px * 0.6), 0);
  let whole = null, built = null, tagged = false, linked = false, nils = new Set();
  // every frame's nodes and edges as one tree, or null when a node changes parent (then each frame is laid out alone)
  function unite(states) {
    const nodes = new Map(), edges = new Map(), parent = new Map();
    for (const st of states) {
      for (const n of st.nodes || []) {
        const k = keyOf(n.id), was = nodes.get(k);
        nodes.set(k, { id: n.id, texts: [...(was ? was.texts : []), fmt(n.value)] });
      }
      for (const e of st.edges || []) {
        const b = keyOf(e.to);
        if (parent.has(b) && parent.get(b) !== keyOf(e.from)) return null;
        parent.set(b, keyOf(e.from));
        const was = edges.get(keyOf(e.from) + '>' + b);
        edges.set(keyOf(e.from) + '>' + b, { ...e, labels: [...(was ? was.labels : []), textOf(e.label, ctx.lang)] });
      }
    }
    const tags = new Map();
    for (const st of states) for (const [id, t] of st.tags || []) tags.set(keyOf(id), Math.max(tags.get(keyOf(id)) || 0, width(textOf(t, ctx.lang), 10.5)));
    return { nodes: [...nodes.values()], edges: [...edges.values()], tags };
  }
  const room = () => {
    const stage = host.closest('.wt-stage');
    if (!stage || typeof getComputedStyle !== 'function') return 0;
    const cs = getComputedStyle(stage);
    return stage.clientWidth - parseFloat(cs.paddingLeft) - parseFloat(cs.paddingRight);
  };
  function build(tree, space) {
    host.innerHTML = '';
    const pill = new Map(tree.nodes.map(n => [keyOf(n.id), Math.max(PH, ...n.texts.map(t => width(t, 13) + 18))]));
    const into = new Map(tree.edges.map(e => [keyOf(e.to), Math.max(0, ...e.labels.map(t => (t ? width(t, 11) + 10 : 0)))]));
    const size = id => ({ w: Math.max(pill.get(id), (tree.tags.get(id) || 0) + 8), h: PH + (tagged ? 18 : 0) });
    // a second link runs through the gap between pills on a level, so the gaps widen to hold an arrow
    const opts = { arity, size, label: id => into.get(id) || 0 };
    const upright = layoutTree(tree.nodes, tree.edges, { ...opts, gap: linked ? TREE.LINK_GAP : undefined });
    const side = layoutTree(tree.nodes, tree.edges, { ...opts, sideways: true, gap: linked ? TREE.SIDE_LINK_GAP : undefined });
    const sideways = treeSideways(upright, side, space), L = sideways ? side : upright;
    let W = L.width, Hh = L.height; // room for each ∅ a null link hangs past its pill
    for (const id of nils) {
      const p = L.pos.get(id);
      if (!p) continue;
      if (sideways) Hh = Math.max(Hh, p.y + PH / 2 + TREE_NIL + 10); else W = Math.max(W, p.x + pill.get(id) / 2 + TREE_NIL + 10);
    }
    const root = svg('svg', { viewBox: `0 0 ${W} ${Hh}`, width: W, class: 'wt-svg wt-tree' + (sideways ? ' wt-tside' : '') }, host);
    if (linked) {
      const defs = svg('defs', {}, root);
      for (const m of ['side', ...MARKS]) {
        const mk = svg('marker', { id: `${ctx.uid}-tl-${m}`, viewBox: '0 0 10 10', refX: 9, refY: 5, markerWidth: 8, markerHeight: 8, markerUnits: 'userSpaceOnUse', orient: 'auto-start-reverse' }, defs);
        svg('path', { d: 'M0,0 L10,5 L0,10 z', class: 'wt-ah wt-ah-' + m }, mk);
      }
    }
    const eg = svg('g', {}, root), lg = svg('g', {}, root), kg = svg('g', {}, root), ng = svg('g', {}, root), tg = svg('g', {}, root);
    const edgeEls = new Map();
    for (const e of tree.edges) {
      const a = L.pos.get(keyOf(e.from)), b = L.pos.get(keyOf(e.to));
      if (!a || !b) continue;
      const [x1, y1, x2, y2] = sideways
        ? [a.x + pill.get(keyOf(e.from)) / 2, a.y, b.x - pill.get(keyOf(e.to)) / 2, b.y]
        : [a.x, a.y + PH / 2 + (tagged ? 18 : 0), b.x, b.y - PH / 2]; // upright, an edge leaves below the tag
      const g = svg('g', {}, eg);
      svg('path', { d: `M${x1},${y1} L${x2},${y2}`, class: 'wt-tedge' }, g);
      const lx = x1 + (x2 - x1) * TREE.AT, ly = y1 + (y2 - y1) * TREE.AT;
      const lab = svg('g', {}, lg);
      const bg = svg('rect', { y: ly - 8, height: 16, rx: 8, class: 'wt-tlabelbg' }, lab);
      const text = svg('text', { x: lx, y: ly + 4, 'text-anchor': 'middle', class: 'wt-tlabel' }, lab);
      const spot = svg('circle', { cx: (x1 + x2) / 2, cy: (y1 + y2) / 2, r: 1, class: 'wt-tspot' }, g);
      edgeEls.set(keyOf(e.from) + '>' + keyOf(e.to), { g, lab, bg, text, spot, lx, from: keyOf(e.from), to: keyOf(e.to) });
    }
    const nodeEls = new Map();
    for (const n of tree.nodes) {
      const k = keyOf(n.id), p = L.pos.get(k), w = pill.get(k);
      const g = svg('g', { transform: `translate(${p.x},${p.y})` }, ng);
      const box = svg('rect', { x: -w / 2, y: -PH / 2, width: w, height: PH, rx: PH / 2, class: 'wt-tnode' }, g);
      const val = svg('text', { y: 5, 'text-anchor': 'middle', class: 'wt-tval' }, g);
      const tag = svg('g', { transform: `translate(${p.x},${p.y + PH / 2 + 12})` }, tg);
      const tagbg = svg('rect', { y: -10, height: 14, rx: 3, class: 'wt-ttagbg' }, tag);
      const tagText = svg('text', { 'text-anchor': 'middle', class: 'wt-ttag' }, tag);
      nodeEls.set(k, { g, box, val, tag, tagbg, tagText });
    }
    const empty = svg('text', { x: TREE.PAD, y: PH / 2 + 5, class: 'wt-tempty' }, root);
    return { tree, nodeEls, edgeEls, sideways, space, empty, kg, pos: L.pos, pill };
  }
  const shown = (el, on) => { el.style.display = on ? '' : 'none'; };
  return {
    locate: at => {
      if (!built) return null;
      if (Array.isArray(at)) {
        const e = at.length === 2 ? built.edgeEls.get(keyOf(at[0]) + '>' + keyOf(at[1])) : null;
        return e && e.g.style.display !== 'none' ? (e.lab.style.display !== 'none' ? e.bg : e.spot) : null;
      }
      const n = built.nodeEls.get(keyOf(at));
      return n && n.g.style.display !== 'none' ? n.box : null;
    },
    prepare(states) {
      tagged = states.some(st => (st.tags || []).length);
      linked = states.some(st => Object.keys(st.links || {}).length);
      nils = new Set(states.flatMap(st => Object.values(st.links || {}).flatMap(to => Object.keys(to).filter(k => to[k] == null))));
      whole = unite(states);
      built = null;
    },
    update(s) {
      const space = room();
      const tree = whole || unite([s]);
      if (!built || !whole || (space !== built.space && space > 0)) built = build(tree, space);
      const nm = markMap(s.nodeMarks), em = markMap(s.edgeMarks), shade = new Set((s.shade || []).map(keyOf));
      const nodes = new Map((s.nodes || []).map(n => [keyOf(n.id), n])), tags = new Map((s.tags || []).map(([id, t]) => [keyOf(id), t]));
      for (const [k, el] of built.nodeEls) {
        const n = nodes.get(k);
        shown(el.g, !!n); shown(el.tag, !!n && tags.has(k));
        if (!n) continue;
        el.g.setAttribute('class', 'wt-tn' + markClass(nm, n.id) + (shade.has(k) ? ' wt-tshade' : ''));
        el.val.textContent = fmt(n.value);
        el.box.dataset.token = fmt(n.value) || fmt(n.id);
        const t = textOf(tags.get(k), ctx.lang), w = width(t, 10.5) + 8;
        el.tagText.textContent = t;
        el.tagbg.setAttribute('x', -w / 2); el.tagbg.setAttribute('width', w);
        el.tag.setAttribute('class', 'wt-ttagg' + markClass(nm, n.id));
      }
      const edges = new Map((s.edges || []).map(e => [keyOf(e.from) + '>' + keyOf(e.to), e]));
      for (const [k, el] of built.edgeEls) {
        const e = edges.get(k);
        const label = e ? textOf(e.label, ctx.lang) : '';
        shown(el.g, !!e); shown(el.lab, !!e && !!label);
        if (!e) continue;
        const m = em.get(keyOf([e.from, e.to]));
        el.g.setAttribute('class', 'wt-te' + (m ? ' wt-' + m : '') + (shade.has(el.from) && shade.has(el.to) ? ' wt-tshade' : ''));
        el.lab.setAttribute('class', 'wt-te' + (m ? ' wt-' + m : ''));
        el.text.textContent = label;
        const w = width(label, 11) + 10;
        el.bg.setAttribute('x', el.lx - w / 2); el.bg.setAttribute('width', w);
        el.bg.dataset.token = label;
      }
      // the second link, one kind: an arrow from pill to pill, or a hook to ∅
      built.kg.replaceChildren();
      const name = Object.keys(s.links || {})[0], lm = markMap(s.linkMarks);
      const box = k => (nodes.has(k) && built.pos.get(k) ? { ...built.pos.get(k), w: built.pill.get(k), h: PH } : null);
      for (const a of name ? treeLinks(s.links[name], box, { sideways: built.sideways }) : []) {
        const mark = lm.get(keyOf([name, a.from])), g = svg('g', { class: 'wt-tlink' + (mark ? ' wt-' + mark : '') }, built.kg);
        if (a.nil) {
          const [x, y] = a.nil, d = built.sideways ? `M${a.x1},${a.y1} L${x},${y - 8}` : `M${a.x1},${a.y1} L${x - 8},${y}`;
          svg('path', { d, class: 'wt-tlinkpath' }, g);
          svg('text', { x, y: y + 5, 'text-anchor': 'middle', class: 'wt-tnil' }, g).textContent = '∅';
        } else svg('path', { d: `M${a.x1},${a.y1} L${a.x2},${a.y2}`, class: 'wt-tlinkpath', 'marker-end': `url(#${ctx.uid}-tl-${mark || 'side'})` }, g);
      }
      built.empty.textContent = nodes.size ? '' : config.empty != null ? textOf(config.empty, ctx.lang) : ctx.ui.empty;
    },
  };
};

// ---------- linked list arrows (pure, exported for tests) ----------
// How each node's next is drawn, the nodes standing in a row in `ids` order: `right` or `left` into the gap beside it
// when it reaches a neighbour, `over` the row when it skips forward, `under` it when it loops back (or to itself), and
// `null-right` or `null-left` to ∅, on the side away from the node that reaches it, and off the row's start for the
// first node of several (a head turned back by a reversal).
// Two arrows in one gap, one each way, take a lane each (-1 above the middle, 1 below). A node missing from `next`
// has no arrow. Returns [{ from, to, kind, lane }], ids as text.
export function linkArrows(ids, next) {
  const at = new Map(ids.map((id, i) => [keyOf(id), i])), keys = ids.map(keyOf);
  const reachedFromRight = new Set();
  for (const k of keys) {
    const to = next[k];
    if (to != null && at.has(keyOf(to)) && at.get(keyOf(to)) < at.get(k)) reachedFromRight.add(keyOf(to));
  }
  const arrows = [];
  keys.forEach((k, i) => {
    if (!(k in next)) return;
    const to = next[k];
    if (to == null) {
      const left = reachedFromRight.has(k) || (i === 0 && keys.length > 1); // a head turned back points off the row's start
      arrows.push({ from: k, to: null, kind: left ? 'null-left' : 'null-right', lane: 0 });
      return;
    }
    const j = at.get(keyOf(to));
    if (j === undefined) return;
    const kind = j === i + 1 ? 'right' : j === i - 1 ? 'left' : j > i ? 'over' : 'under';
    arrows.push({ from: k, to: keyOf(to), kind, lane: 0 });
  });
  // the gap right of node i: an arrow rightwards out of i, or leftwards out of i + 1
  const gap = a => (a.kind === 'right' || a.kind === 'null-right' ? at.get(a.from) : a.kind === 'left' || a.kind === 'null-left' ? at.get(a.from) - 1 : null);
  for (const a of arrows) {
    const g = gap(a);
    if (g === null) continue;
    const other = arrows.find(b => b !== a && gap(b) === g);
    if (other) a.lane = a.kind === 'right' || a.kind === 'null-right' ? -1 : 1;
  }
  return arrows;
}

// How each node's second link (`links`: a copy's random, a doubly linked list's prev) is drawn: always under the row,
// so it never shares the gap with next. `arc` reaches a node, `level` deep: its distance in nodes, half a step more
// going back (or to itself), so two arcs over one stretch, one each way, nest instead of crossing; capped at 4.5.
// `null` hooks out to ∅ just under the gap on the node's right. A node missing from `to` has no arrow. Returns [{ from, to, kind, level }].
export function sideArrows(ids, to) {
  const at = new Map(ids.map((id, i) => [keyOf(id), i])), arrows = [];
  ids.map(keyOf).forEach((k, i) => {
    if (!(k in to)) return;
    if (to[k] == null) { arrows.push({ from: k, to: null, kind: 'null', level: 0 }); return; }
    const j = at.get(keyOf(to[k]));
    if (j === undefined) return;
    arrows.push({ from: k, to: keyOf(to[k]), kind: 'arc', level: Math.min(4, Math.abs(j - i)) + (j <= i ? 0.5 : 0) });
  });
  return arrows;
}

// A linked list: nodes as boxes in a row, in `nodes` order for the whole run, each next an arrow (linkArrows), so a
// reversal redraws the arrows and never moves a node. `pointers` stand above their node; `cut` draws an arrow this
// step removed, faded and dashed. A second link per node (`links`, one kind) runs under the row (sideArrows), dashed in
// a colour of its own, with `linkCuts` its removed arrows. Room for every arc, ∅ and pointer the run draws is kept from
// its first frame. Address: a node id.
VIEWS.linkedlist = (host, config, ctx) => {
  const H = 36, GAP = 36, END = 30, ARC = 24, LINE = 14, P = 6, NIL = 9;
  let built = null, room = null;
  const ids = st => (st.nodes || []).map(n => keyOf(n.id));
  const kind = st => Object.keys(st.links || {})[0];
  const sideDepth = level => 12 + 12 * level; // a side arc's control points; the curve reaches 3/4 of it
  function need(states) {
    const r = { box: 40, left: false, right: false, over: false, under: false, ptrs: 0, side: 0 };
    for (const st of states) {
      for (const n of st.nodes || []) r.box = Math.max(r.box, labelWidth(fmt(n.value)) * 15 / 11 + 18);
      for (const a of [...linkArrows(ids(st), st.next || {}), ...linkArrows(ids(st), st.cut || {})]) {
        if (a.kind === 'null-left') r.left = true;
        if (a.kind === 'null-right' && keyOf(a.from) === ids(st).at(-1)) r.right = true;
        if (a.kind === 'over') r.over = true;
        if (a.kind === 'under') r.under = true;
      }
      const name = kind(st);
      for (const a of name ? [...sideArrows(ids(st), st.links[name]), ...sideArrows(ids(st), (st.linkCuts || {})[name] || {})] : []) {
        r.side = Math.max(r.side, a.kind === 'null' ? NIL + 10 : sideDepth(a.level) * 0.75 + 6);
        if (a.kind === 'null' && a.from === ids(st).at(-1)) r.right = true;
      }
      const per = new Map();
      for (const at of Object.values(st.pointers || {})) if (at != null) per.set(keyOf(at), (per.get(keyOf(at)) || 0) + 1);
      r.ptrs = Math.max(r.ptrs, ...per.values());
    }
    return r;
  }
  function build(keys) {
    host.innerHTML = '';
    const B = room.box, x0 = P + (room.left ? END : 0);
    const ptrTop = P + (room.over ? ARC : 0), top = ptrTop + room.ptrs * LINE + (room.ptrs ? 8 : 0);
    const W = x0 + keys.length * (B + GAP) - GAP + (room.right ? END : 0) + P, Hh = top + H + Math.max(room.under ? ARC + 6 : 0, room.side) + P;
    const root = svg('svg', { viewBox: `0 0 ${W} ${Hh}`, width: W, class: 'wt-svg wt-linkedlist' }, host);
    const defs = svg('defs', {}, root);
    for (const m of ['plain', 'side', ...MARKS]) {
      const mk = svg('marker', { id: `${ctx.uid}-ll-${m}`, viewBox: '0 0 10 10', refX: 9, refY: 5, markerWidth: 9, markerHeight: 9, markerUnits: 'userSpaceOnUse', orient: 'auto-start-reverse' }, defs);
      svg('path', { d: 'M0,0 L10,5 L0,10 z', class: 'wt-ah wt-ah-' + m }, mk);
    }
    const cx = new Map(keys.map((k, i) => [k, x0 + i * (B + GAP) + B / 2]));
    const arrows = svg('g', {}, root), boxes = svg('g', {}, root);
    const nodeEls = new Map();
    for (const k of keys) {
      const g = svg('g', { transform: `translate(${cx.get(k)},${top + H / 2})` }, boxes);
      const box = svg('rect', { x: -B / 2, y: -H / 2, width: B, height: H, rx: 7, class: 'wt-llbox' }, g);
      const val = svg('text', { y: 5, 'text-anchor': 'middle', class: 'wt-llval' }, g);
      const ptr = svg('text', { y: -H / 2 - 6, 'text-anchor': 'middle', class: 'wt-llptr' }, g);
      nodeEls.set(k, { g, box, val, ptr });
    }
    return { keys, cx, top, B, W, arrows, nodeEls, ptrTop };
  }
  // one arrow's path and where its ∅ goes, from the node's box to its target's
  function route(a) {
    const { cx, top, B } = built, mid = top + H / 2, x = cx.get(a.from), dy = a.lane * 7, bot = top + H;
    switch (a.kind) {
      case 'arc': { // a second link: out of the box's right half, into the target's left half
        const x2 = cx.get(a.to) - 8, y = bot + sideDepth(a.level);
        return { d: `M${x + 8},${bot} C${x + 8},${y} ${x2},${y} ${x2},${bot + 1}` };
      }
      case 'null': // a hook out to ∅ in the gap on its right, under next's arrows and over the arcs passing below
        return { d: `M${x + 8},${bot} Q${x + 8},${bot + NIL} ${x + B / 2 + 3},${bot + NIL}`, nil: [x + B / 2 + 11, bot + NIL] };
      case 'right': return { d: `M${x + B / 2},${mid + dy} L${cx.get(a.to) - B / 2 - 1},${mid + dy}` };
      case 'left': return { d: `M${x - B / 2},${mid + dy} L${cx.get(a.to) + B / 2 + 1},${mid + dy}` };
      case 'null-right': return { d: `M${x + B / 2},${mid + dy} L${x + B / 2 + GAP - 16},${mid + dy}`, nil: [x + B / 2 + GAP - 8, mid + dy] };
      case 'null-left': return { d: `M${x - B / 2},${mid + dy} L${x - B / 2 - GAP + 16},${mid + dy}`, nil: [x - B / 2 - GAP + 8, mid + dy] };
      case 'over': {
        const x2 = cx.get(a.to), y = built.ptrTop - 2;
        return { d: `M${x + 6},${top} C${x + 6},${y} ${x2 - 6},${y} ${x2 - 6},${top - 1}` };
      }
      default: { // under: a loop back, or a node reaching itself
        const x2 = a.to === a.from ? x + 10 : cx.get(a.to), x1 = a.to === a.from ? x - 10 : x, y = top + H + ARC;
        return { d: `M${x1 - 6},${top + H} C${x1 - 6},${y} ${x2 + 6},${y} ${x2 + 6},${top + H + 1}` };
      }
    }
  }
  return {
    locate: at => (built && built.nodeEls.get(keyOf(at))?.box) || null,
    prepare(states) { room = need(states); built = null; },
    update(s) {
      const keys = ids(s);
      if (!room) room = need([s]);
      if (!keys.length) { host.innerHTML = ''; built = null; html('span', 'wt-empty', host, config.empty != null ? textOf(config.empty, ctx.lang) : ctx.ui.empty); return; }
      if (!built || built.keys.join('\u0000') !== keys.join('\u0000')) built = build(keys);
      const m = markMap(s.marks), lm = markMap(s.linkMarks), values = new Map((s.nodes || []).map(n => [keyOf(n.id), n.value]));
      const ptrs = new Map();
      for (const [name, at] of Object.entries(s.pointers || {})) if (at != null) ptrs.set(keyOf(at), [...(ptrs.get(keyOf(at)) || []), name]);
      for (const [k, el] of built.nodeEls) {
        el.g.setAttribute('class', 'wt-llnode' + markClass(m, k) + (ptrs.has(k) ? ' wt-llpointed' : ''));
        el.val.textContent = fmt(values.get(k));
        el.box.dataset.token = fmt(values.get(k));
        el.ptr.replaceChildren();
        const names = ptrs.get(k) || [];
        names.forEach((name, i) => { svg('tspan', { x: 0, dy: i ? LINE : -(names.length - 1) * LINE }, el.ptr).textContent = name + (i === names.length - 1 ? ' ↓' : ''); });
      }
      built.arrows.replaceChildren();
      const draw = (a, cls, mark, plain = 'plain') => {
        const r = route(a), g = svg('g', { class: cls + (mark ? ' wt-' + mark : '') }, built.arrows);
        svg('path', { d: r.d, class: 'wt-lllink', 'marker-end': r.nil ? null : `url(#${ctx.uid}-ll-${mark || plain})` }, g);
        if (r.nil) svg('text', { x: r.nil[0], y: r.nil[1] + 5, 'text-anchor': 'middle', class: 'wt-llnil' }, g).textContent = '∅';
      };
      for (const a of linkArrows(keys, s.cut || {})) draw({ ...a, lane: a.lane || 1 }, 'wt-llarrow wt-llcut', 'bad'); // below the live arrow in its gap
      for (const a of linkArrows(keys, s.next || {})) draw(a, 'wt-llarrow', lm.get(a.from));
      const name = kind(s);
      if (name) {
        for (const a of sideArrows(keys, (s.linkCuts || {})[name] || {})) draw(a, 'wt-llarrow wt-llside wt-llcut', 'bad');
        for (const a of sideArrows(keys, s.links[name])) draw(a, 'wt-llarrow wt-llside', lm.get(keyOf([name, a.from])), 'side');
      }
    },
  };
};

// A call stack: one card per open call, its name and arguments, the top drawn first and the bottom held in place, so a
// call pushed appears on top and one popped leaves from it. The column keeps room for the run's deepest stack.
// Address: a call's position from the bottom (0 is the first call).
VIEWS.callstack = (host, config, ctx) => {
  host.innerHTML = '';
  const box = html('div', 'wt-callstack', host);
  let cards = [], deepest = 0;
  const line = c => `${textOf(c.name, ctx.lang)}(${Object.entries(c.args || {}).map(([k, v]) => `${k}=${fmt(v)}`).join(', ')})`;
  return {
    locate: at => (Number.isInteger(at) && cards[at]) || null,
    prepare(states) { deepest = Math.max(0, ...states.map(st => (st.calls || []).length)); },
    update(s) {
      const m = markMap(s.marks), calls = s.calls || [];
      box.innerHTML = '';
      cards = calls.map((c, i) => {
        const card = html('div', 'wt-cscall' + markClass(m, i) + (i === calls.length - 1 ? ' wt-cstop' : ''), box);
        card.dataset.token = line(c);
        html('div', 'wt-csline', card, line(c));
        if (c.note != null) html('div', 'wt-csnote', card, textOf(c.note, ctx.lang));
        return card;
      });
      if (!calls.length) html('span', 'wt-empty', box, config.empty != null ? textOf(config.empty, ctx.lang) : ctx.ui.empty);
      for (let i = Math.max(calls.length, 1); i < deepest; i++) html('div', 'wt-cscall wt-csspace', box, '\u00a0');
    },
  };
};

// A stack of values, drawn upright as a solver pictures one: cells piled on a fixed base, the top at the top with a
// "top" marker beside it, so a push appears on top and a pop leaves from it. The column keeps room for the run's
// tallest stack, so the base never moves. `tags` label cells (the day a reading belongs to, an index) inside the cell,
// above its value. Address: a position from the bottom (0 is the bottom).
VIEWS.stack = (host, config, ctx) => {
  host.innerHTML = '';
  const box = html('div', 'wt-stack', host);
  let cells = [], tallest = 0, tagged = false;
  const cell = (cls, tag, value) => {
    const c = html('div', 'wt-stackitem' + cls, box);
    if (tagged) html('span', 'wt-stacktag', c, tag || ' ');
    html('span', 'wt-stackval', c, value);
    return c;
  };
  return {
    locate: at => (Number.isInteger(at) && cells[at]) || null,
    prepare(states) {
      tallest = Math.max(1, ...states.map(st => (st.values || []).length));
      tagged = states.some(st => (st.tags || []).length);
    },
    update(s) {
      const m = markMap(s.marks), values = s.values || [];
      const tags = new Map((s.tags || []).map(([i, t]) => [i, t]));
      box.innerHTML = '';
      // drawn top first: the room kept for later pushes, then the cells from the top down to the base
      for (let i = tallest - 1; i >= Math.max(values.length, 1); i--) cell(' wt-stackspace', '', ' ');
      // an empty stack says so on its bottom cell's room, so the base holds still when the first value lands
      if (!values.length) cell(' wt-stackempty', '', config.empty != null ? textOf(config.empty, ctx.lang) : ctx.ui.empty);
      cells = [];
      for (let i = values.length - 1; i >= 0; i--) {
        const c = cell(markClass(m, i), textOf(tags.get(i), ctx.lang), fmt(values[i]));
        c.dataset.token = fmt(values[i]);
        if (i === values.length - 1) html('span', 'wt-stacktop', c, ctx.ui.top);
        cells[i] = c;
      }
    },
  };
};

VIEWS.table = (host, config, ctx) => {
  host.innerHTML = '';
  const table = html('table', 'wt-table', host);
  let cells = new Map(); // "row,col" -> td
  return {
    locate: at => (Array.isArray(at) && cells.get(keyOf(at))) || null,
    update(s) {
      const m = markMap(s.marks);
      table.innerHTML = '';
      cells = new Map();
      if (s.columns) {
        const tr = html('tr', null, html('thead', null, table));
        html('th', null, tr);
        for (const c of s.columns) html('th', null, tr, textOf(c, ctx.lang));
      }
      const body = html('tbody', null, table);
      (s.rows || []).forEach((row, r) => {
        const tr = html('tr', null, body);
        html('th', 'wt-rowlabel', tr, textOf(row.label, ctx.lang));
        row.cells.forEach((v, c) => cells.set(keyOf([r, c]), html('td', 'wt-td' + markClass(m, [r, c]), tr, fmt(v))));
      });
    },
  };
};

VIEWS.vars = (host, config, ctx) => {
  host.innerHTML = '';
  const box = html('div', 'wt-vars', host);
  return {
    update(s) {
      box.innerHTML = '';
      for (const item of s.items || []) {
        const d = html('div', 'wt-var' + (item.mark ? ' wt-' + item.mark : ''), box);
        html('div', 'wt-varlabel', d, textOf(item.label, ctx.lang));
        if (Array.isArray(item.value)) {
          const chips = html('div', 'wt-chips', d);
          if (!item.value.length) html('span', 'wt-empty', chips, item.empty != null ? textOf(item.empty, ctx.lang) : 'empty');
          item.value.forEach(v => html('span', 'wt-chip', chips, fmt(v)));
        } else html('div', 'wt-varvalue', d, fmt(item.value));
      }
    },
  };
};

// ---------- moves ----------
// A frame's `moves` are drawn over the stage: a dashed arrow from each source to its target, and on a step forward
// (without reduced motion) a chip flying along it first. No `from`: the value is created at `to`; no `to`: dropped.
const FLIGHT_MS = 550;
function createMoves(layer, stage, ctx, viewById) {
  const overlay = svg('svg', { class: 'wt-movesvg', 'aria-hidden': 'true' }, layer);
  const defs = svg('defs', {}, overlay);
  for (const m of ['good', 'bad', 'path']) {
    const mk = svg('marker', { id: `${ctx.uid}-mv-${m}`, viewBox: '0 0 10 10', refX: 9, refY: 5, markerWidth: 6, markerHeight: 6, orient: 'auto-start-reverse' }, defs);
    svg('path', { d: 'M0,0 L10,5 L0,10 z', class: 'wt-ah wt-ah-' + m }, mk);
  }
  const arrows = svg('g', {}, overlay);
  let current = [], flights = [];
  // A move end in a shown view that its locate(at) can't find is one kit/addresses.json accepts and the player can't
  // draw (validate has already refused any other): a console error, once, so capture fails on it.
  const reported = new Set();
  const locate = (a, end) => {
    if (!a) return null;
    const v = viewById(a.view);
    if (!v || v.box.hidden) return null;
    const el = v.view.locate ? v.view.locate(a.at) : null;
    const message = `walkthrough: move ${end} ${JSON.stringify(a)} names nothing the player draws in ${v.type} "${v.id}"`;
    if (!el && !reported.has(message)) { reported.add(message); console.error(message); }
    return el;
  };
  const tone = mv => mv.mark || (!mv.to ? 'bad' : viewById(mv.to.view)?.type === 'output' ? 'path' : 'good');
  function rect(el) {
    const a = el.getBoundingClientRect(), b = stage.getBoundingClientRect();
    return { x: a.left - b.left, y: a.top - b.top, w: a.width, h: a.height };
  }
  const STUB = 30;
  function geometry(mv) {
    const s = locate(mv.from, 'from'), t = locate(mv.to, 'to');
    if ((mv.from && !s) || (mv.to && !t) || (!s && !t)) return null;
    const rs = s && rect(s), rt = t && rect(t);
    let d, x1, y1, x2, y2;
    if (rs && rt) {
      const down = rt.y >= rs.y + rs.h - 1, up = rt.y + rt.h <= rs.y + 1;
      if (down || up) {
        x1 = rs.x + rs.w / 2; y1 = down ? rs.y + rs.h : rs.y; x2 = rt.x + rt.w / 2; y2 = down ? rt.y - 2 : rt.y + rt.h + 2;
        const my = (y1 + y2) / 2;
        d = `M${x1},${y1} C${x1},${my} ${x2},${my} ${x2},${y2}`;
      } else { // side by side: dip under both, so the arrow never crosses the cells between them
        x1 = rs.x + rs.w / 2; y1 = rs.y + rs.h; x2 = rt.x + rt.w / 2; y2 = rt.y + rt.h + 2;
        const low = Math.max(y1, y2) + Math.min(56, 18 + Math.abs(x2 - x1) / 12);
        d = `M${x1},${y1} C${x1},${low} ${x2},${low} ${x2},${y2}`;
      }
    } else if (rt) { // created here
      x2 = x1 = rt.x + rt.w / 2; y2 = rt.y - 2; y1 = y2 - STUB; d = `M${x1},${y1} L${x2},${y2}`;
    } else { // dropped
      x2 = x1 = rs.x + rs.w / 2; y1 = rs.y; y2 = y1 - STUB; d = `M${x1},${y1} L${x2},${y2}`;
    }
    return { d, x1, y1, x2, y2, src: s, dst: t };
  }
  function draw() {
    arrows.replaceChildren();
    const r = stage.getBoundingClientRect();
    overlay.setAttribute('width', r.width); overlay.setAttribute('height', r.height);
    const drawn = [];
    for (const mv of current) {
      const g = geometry(mv);
      if (!g) continue;
      const m = tone(mv);
      svg('path', { d: g.d, class: 'wt-movearrow wt-' + m, 'marker-end': `url(#${ctx.uid}-mv-${m})` }, arrows);
      drawn.push({ mv, g, m });
    }
    return drawn;
  }
  function land() { for (const f of flights) f.cancel(); flights = []; layer.querySelectorAll('.wt-flychip').forEach(n => n.remove()); }
  const reduced = () => typeof matchMedia === 'function' && matchMedia('(prefers-reduced-motion: reduce)').matches;
  function show(list, forward) {
    land();
    current = list;
    const drawn = draw();
    if (!forward || reduced() || !drawn.length || typeof Element.prototype.animate !== 'function') return;
    flights.push(arrows.animate([{ opacity: 0 }, { opacity: 0, offset: 0.8 }, { opacity: 1 }], { duration: FLIGHT_MS + 150 }));
    for (const { mv, g, m } of drawn) {
      const chip = html('span', 'wt-flychip wt-' + m, layer, mv.value !== undefined ? fmt(mv.value) : (g.src?.dataset?.token ?? g.src?.textContent ?? g.dst?.dataset?.token ?? g.dst?.textContent ?? '').trim());
      chip.style.left = g.x1 + 'px'; chip.style.top = g.y1 + 'px';
      const dx = g.x2 - g.x1, dy = g.y2 - g.y1, lift = Math.min(40, 14 + Math.hypot(dx, dy) / 6);
      const a = chip.animate([
        { transform: 'translate(-50%,-50%) scale(1)', opacity: mv.from ? 1 : 0 },
        { transform: `translate(calc(${dx / 2}px - 50%), calc(${dy / 2 - lift}px - 50%)) scale(1.12)`, opacity: 1, offset: 0.5 },
        { transform: `translate(calc(${dx}px - 50%), calc(${dy}px - 50%)) scale(.9)`, opacity: mv.to ? 0.25 : 0 },
      ], { duration: FLIGHT_MS, easing: 'cubic-bezier(.4,0,.2,1)' });
      a.finished.then(() => chip.remove(), () => chip.remove());
      flights.push(a);
    }
  }
  const redraw = () => { if (current.length) draw(); };
  const ro = typeof ResizeObserver === 'function' ? new ResizeObserver(redraw) : null;
  if (ro) ro.observe(stage);
  stage.addEventListener('scroll', redraw, true);
  return { show, destroy() { land(); if (ro) ro.disconnect(); stage.removeEventListener('scroll', redraw, true); } };
}

// ---------- the player ----------
const UI = {
  en: { front: 'front', back: 'back', top: '← top', empty: 'empty', expected: 'expected', extra: 'extra input', step: 'Step', first: 'First step', prev: 'Previous step', next: 'Next step', play: 'Play', pause: 'Pause', hint: '← → step · space plays' },
  ko: { front: '앞', back: '뒤', top: '← 맨 위', empty: '비어 있음', expected: '기대값', extra: '추가 입력', step: '단계', first: '처음', prev: '이전 단계', next: '다음 단계', play: '재생', pause: '일시정지', hint: '← → 단계 이동 · 스페이스 재생' },
};
let uidSeq = 0;

export function mount(root, wt, options = {}) {
  const lang = options.lang || 'en', ui = { ...UI.en, ...(UI[lang] || {}), ...(options.ui || {}) };
  const ctx = { lang, ui, uid: 'wt' + ++uidSeq };
  const speed = options.interval || 1400;
  root.classList.add('wt');
  if (options.theme) root.dataset.theme = options.theme;
  root.innerHTML = '';
  root.tabIndex = 0;

  const runsBar = html('div', 'wt-runs', root);
  runsBar.setAttribute('role', 'tablist');
  const card = html('div', 'wt-card', root);
  const head = html('div', 'wt-head', card);
  const inputEl = html('code', 'wt-input', head), expectedEl = html('span', 'wt-expected', head);
  const stage = html('div', 'wt-stage', card);
  const movesLayer = html('div', 'wt-moves', null);
  const caption = html('div', 'wt-caption', card);
  caption.setAttribute('aria-live', 'polite');
  const controls = html('div', 'wt-controls', card);
  const btn = (label, text) => { const b = html('button', 'wt-btn', controls, text); b.type = 'button'; b.setAttribute('aria-label', label); return b; };
  const bFirst = btn(ui.first, '⏮'), bPrev = btn(ui.prev, '◀'), bPlay = btn(ui.play, '▶'), bNext = btn(ui.next, '▶|');
  const scrub = html('input', 'wt-scrub', controls); scrub.type = 'range'; scrub.min = 0; scrub.setAttribute('aria-label', ui.step);
  const count = html('span', 'wt-count', controls);
  if (options.hint !== false) html('div', 'wt-hint', root, ui.hint);

  const runButtons = wt.runs.map((r, i) => {
    const b = html('button', 'wt-runbtn', runsBar, textOf(r.label, lang));
    b.type = 'button'; b.setAttribute('role', 'tab');
    if (r.extra) html('span', 'wt-extra', b, ui.extra);
    b.onclick = () => show(i, 0);
    return b;
  });
  if (wt.runs.length < 2) runsBar.hidden = true;

  let runIdx = -1, frameIdx = 0, views = [], timer = null;
  const moves = createMoves(movesLayer, stage, ctx, id => views.find(v => v.id === id));
  function mountRun(i) {
    runIdx = i;
    const run = wt.runs[i];
    stage.innerHTML = '';
    stage.appendChild(movesLayer);
    views = wt.views.map(v => {
      const box = html('figure', 'wt-view wt-view-' + v.type, stage);
      if (v.title != null) html('figcaption', 'wt-viewtitle', box, textOf(v.title, lang));
      const host = html('div', 'wt-viewbody', box);
      const make = VIEWS[v.type];
      if (!make) throw new Error(`walkthrough: no view type "${v.type}"`);
      const setup = (run.setup || {})[v.id] || {}, view = make(host, v, ctx);
      if (view.prepare) view.prepare(run.frames.map(f => ({ ...setup, ...((f.views || {})[v.id] || {}) })));
      return { id: v.id, type: v.type, box, view, setup };
    });
    inputEl.textContent = run.input == null ? '' : fmt(run.input);
    expectedEl.textContent = run.expected === undefined ? '' : `${ui.expected} ${fmt(run.expected)}`;
    scrub.max = run.frames.length - 1;
    runButtons.forEach((b, j) => b.setAttribute('aria-selected', j === i));
  }
  function show(i, f) {
    const before = i === runIdx ? frameIdx : -2;
    if (i !== runIdx) { stop(); mountRun(i); }
    const run = wt.runs[runIdx];
    frameIdx = Math.max(0, Math.min(f, run.frames.length - 1));
    const frame = run.frames[frameIdx];
    for (const v of views) {
      const st = (frame.views || {})[v.id];
      v.box.hidden = st === undefined && !Object.keys(v.setup).length;
      if (!v.box.hidden) v.view.update({ ...v.setup, ...(st || {}) });
    }
    moves.show(frame.moves || [], frameIdx === before + 1); // only a step forward flies
    caption.textContent = textOf(frame.caption, lang);
    caption.classList.toggle('wt-done', 'answer' in frame);
    scrub.value = frameIdx;
    count.textContent = `${frameIdx + 1} / ${run.frames.length}`;
    bFirst.disabled = bPrev.disabled = frameIdx === 0;
    bNext.disabled = frameIdx === run.frames.length - 1;
    if (options.onChange) options.onChange(runIdx, frameIdx);
  }
  const last = () => wt.runs[runIdx].frames.length - 1;
  function stop() { clearInterval(timer); timer = null; bPlay.textContent = '▶'; bPlay.setAttribute('aria-label', ui.play); }
  function play() {
    if (timer) return stop();
    if (frameIdx === last()) show(runIdx, 0);
    bPlay.textContent = '⏸'; bPlay.setAttribute('aria-label', ui.pause);
    timer = setInterval(() => (frameIdx >= last() ? stop() : show(runIdx, frameIdx + 1)), speed);
  }
  bFirst.onclick = () => { stop(); show(runIdx, 0); };
  bPrev.onclick = () => { stop(); show(runIdx, frameIdx - 1); };
  bNext.onclick = () => { stop(); show(runIdx, frameIdx + 1); };
  bPlay.onclick = play;
  scrub.oninput = () => { stop(); show(runIdx, +scrub.value); };
  const onKey = e => {
    if (e.target.closest('input:not([type=range]),textarea,[contenteditable]')) return;
    const k = { ArrowRight: 1, ArrowLeft: -1 }[e.key];
    if (k) { stop(); show(runIdx, frameIdx + k); }
    else if (e.key === ' ') play();
    else if (e.key === 'Home') { stop(); show(runIdx, 0); }
    else if (e.key === 'End') { stop(); show(runIdx, last()); }
    else return;
    e.preventDefault();
  };
  root.addEventListener('keydown', onKey);

  const start = options.start || {};
  const r0 = Math.min(Math.max(+start.run || 0, 0), wt.runs.length - 1);
  show(r0, start.frame === 'last' ? 1e9 : +start.frame || 0);
  return {
    show: (r, f) => show(r, f === 'last' ? 1e9 : f),
    destroy() { stop(); moves.destroy(); root.removeEventListener('keydown', onKey); root.innerHTML = ''; root.classList.remove('wt'); },
  };
}
