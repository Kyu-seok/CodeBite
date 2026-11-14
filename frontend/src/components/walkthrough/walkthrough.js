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
// defines it, and scripts/validate.mjs's ADDRESSES says which `at` it takes.
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
  const locate = a => {
    if (!a) return null;
    const v = viewById(a.view);
    return v && !v.box.hidden && v.view.locate ? v.view.locate(a.at) : null;
  };
  const tone = mv => mv.mark || (!mv.to ? 'bad' : viewById(mv.to.view)?.type === 'output' ? 'path' : 'good');
  function rect(el) {
    const a = el.getBoundingClientRect(), b = stage.getBoundingClientRect();
    return { x: a.left - b.left, y: a.top - b.top, w: a.width, h: a.height };
  }
  const STUB = 30;
  function geometry(mv) {
    const s = locate(mv.from), t = locate(mv.to);
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
  en: { front: 'front', back: 'back', empty: 'empty', expected: 'expected', extra: 'extra input', step: 'Step', first: 'First step', prev: 'Previous step', next: 'Next step', play: 'Play', pause: 'Pause', hint: '← → step · space plays' },
  ko: { front: '앞', back: '뒤', empty: '비어 있음', expected: '기대값', extra: '추가 입력', step: '단계', first: '처음', prev: '이전 단계', next: '다음 단계', play: '재생', pause: '일시정지', hint: '← → 단계 이동 · 스페이스 재생' },
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
