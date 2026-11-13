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
// Longest-path layers when the graph is directed and acyclic, so a chain reads as "steps from the start";
// BFS layers from the first node otherwise. Returns { pos: Map(id -> {col, row}), cols, rows }.
export function layoutGraph(nodes, edges, directed) {
  const ids = nodes.map(n => keyOf(n.id));
  const out = new Map(ids.map(i => [i, []]));
  const indeg = new Map(ids.map(i => [i, 0]));
  for (const e of edges) {
    out.get(keyOf(e.from)).push(keyOf(e.to));
    indeg.set(keyOf(e.to), indeg.get(keyOf(e.to)) + 1);
    if (!directed) out.get(keyOf(e.to)).push(keyOf(e.from));
  }
  const layer = new Map(ids.map(i => [i, 0]));
  let acyclic = false;
  if (directed) {
    const deg = new Map(indeg), q = ids.filter(i => !deg.get(i)), seen = [];
    while (q.length) {
      const v = q.shift(); seen.push(v);
      for (const w of out.get(v)) { layer.set(w, Math.max(layer.get(w), layer.get(v) + 1)); deg.set(w, deg.get(w) - 1); if (!deg.get(w)) q.push(w); }
    }
    acyclic = seen.length === ids.length;
  }
  if (!acyclic) {
    for (const i of ids) layer.set(i, -1);
    let next = 0;
    for (const start of ids) {
      if (layer.get(start) >= 0) continue;
      layer.set(start, next); const q = [start];
      while (q.length) { const v = q.shift(); for (const w of out.get(v)) if (layer.get(w) < 0) { layer.set(w, layer.get(v) + 1); q.push(w); } }
      next = Math.max(...[...layer.values()]) + 1;
    }
  }
  const byLayer = new Map();
  for (const i of ids) { const l = layer.get(i); if (!byLayer.has(l)) byLayer.set(l, []); byLayer.get(l).push(i); }
  const pos = new Map();
  for (const [l, vs] of byLayer) vs.forEach((v, j) => pos.set(v, { col: l, row: j - (vs.length - 1) / 2 }));
  return { pos, cols: Math.max(...layer.values()) + 1, rows: Math.max(...[...byLayer.values()].map(v => v.length)) };
}

// ---------- views ----------
// Each view type: mount(host, config, ctx) -> { update(state) }. `state` is the run's setup merged with the frame's.
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
    return { rows, cols, cells };
  }
  const values = config.values || {};
  return {
    update(s) {
      const rows = s.cells.length, cols = rows ? s.cells[0].length : 0;
      if (!built || built.rows !== rows || built.cols !== cols) built = build(rows, cols);
      const m = markMap(s.marks), tags = new Map((s.tags || []).map(([r, c, t]) => [r + ',' + c, t]));
      for (const { r, c, g, val, tag } of built.cells) {
        const v = s.cells[r][c], spec = values[keyOf(v)] || {};
        g.setAttribute('class', 'wt-cell wt-tone-' + (spec.tone || 'plain') + markClass(m, [r, c]));
        val.textContent = spec.glyph != null ? spec.glyph : config.showValues === false ? '' : fmt(v);
        tag.textContent = textOf(tags.get(r + ',' + c), ctx.lang);
      }
    },
  };
};

VIEWS.array = (host, config, ctx) => {
  const S = 46, G = 4, P = 10;
  let built = null;
  const bars = config.display === 'bars';
  function build(n, max) {
    host.innerHTML = '';
    const unit = bars ? Math.max(12, Math.min(28, 160 / Math.max(max, 1))) : 0;
    const barH = bars ? unit * Math.max(max, 1) : 0;
    const top = 18, W = P * 2 + n * (S + G) - G, H = top + (bars ? barH : S) + 58;
    const root = svg('svg', { viewBox: `0 0 ${W} ${H}`, width: W, class: 'wt-svg wt-array' }, host);
    const items = [];
    for (let i = 0; i < n; i++) {
      const x = P + i * (S + G);
      const g = svg('g', { transform: `translate(${x},0)` }, root);
      const tag = svg('text', { x: S / 2, y: 11, 'text-anchor': 'middle', class: 'wt-tag' }, g);
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
      const yIdx = top + (bars ? barH + 32 : S + 14);
      svg('text', { x: S / 2, y: yIdx, 'text-anchor': 'middle', class: 'wt-index' }, g).textContent = i;
      const ptr = svg('text', { x: S / 2, y: yIdx + 18, 'text-anchor': 'middle', class: 'wt-ptr' }, g);
      items.push({ g, box, fill, val, tag, ptr });
    }
    return { n, max, items, unit, top, barH };
  }
  return {
    update(s) {
      const vals = s.values || [], fills = s.fill || [];
      const max = bars ? Math.max(1, ...vals.map((v, i) => (+v || 0) + (+fills[i] || 0)), config.max || 0) : 0;
      if (!built || built.n !== vals.length || (bars && max > built.max)) built = build(vals.length, max);
      const m = markMap(s.marks), tags = new Map((s.tags || []).map(([i, t]) => [String(i), t]));
      const ptrs = new Map();
      for (const [name, i] of Object.entries(s.pointers || {})) if (i != null) ptrs.set(i, [...(ptrs.get(i) || []), name]);
      built.items.forEach(({ g, box, fill, val, tag, ptr }, i) => {
        g.setAttribute('class', 'wt-item' + markClass(m, i) + (ptrs.has(i) ? ' wt-pointed' : ''));
        val.textContent = fmt(vals[i]);
        tag.textContent = textOf(tags.get(String(i)), ctx.lang);
        ptr.textContent = (ptrs.get(i) || []).join(' ');
        if (bars) {
          const { unit, top, barH } = built, h = (+vals[i] || 0) * unit, f = (+fills[i] || 0) * unit;
          box.style.height = h + 'px'; box.style.y = top + barH - h + 'px';
          fill.style.height = f + 'px'; fill.style.y = top + barH - h - f + 'px';
        }
      });
    },
  };
};

VIEWS.graph = (host, config, ctx) => {
  const R = 20, DX = 120, DY = 88, ARC = 88;
  let built = null;
  function build(nodes, edges) {
    host.innerHTML = '';
    const directed = config.directed !== false;
    const { pos, cols, rows } = layoutGraph(nodes, edges, directed);
    const half = (rows - 1) / 2 * DY;
    const W = Math.max((cols - 1) * DX + 2 * (R + 30), 120), H = 2 * half + 2 * ARC + 2 * R + 40;
    const P = id => { const p = pos.get(keyOf(id)); return [R + 30 + p.col * DX, ARC + R + 14 + half + p.row * DY]; };
    const root = svg('svg', { viewBox: `0 0 ${W} ${H}`, width: W, class: 'wt-svg wt-graph' }, host);
    const defs = svg('defs', {}, root);
    for (const m of ['plain', ...MARKS]) {
      const mk = svg('marker', { id: `${ctx.uid}-ah-${m}`, viewBox: '0 0 10 10', refX: 9, refY: 5, markerWidth: 7, markerHeight: 7, orient: 'auto-start-reverse' }, defs);
      svg('path', { d: 'M0,0 L10,5 L0,10 z', class: 'wt-ah wt-ah-' + m }, mk);
    }
    // straight between neighbouring layers; arcs, alternating sides, for skips and same-layer pairs further apart
    let flip = 1;
    const eg = svg('g', {}, root);
    const edgeEls = edges.map(e => {
      const [x1, y1] = P(e.from), [x2, y2] = P(e.to);
      const a = pos.get(keyOf(e.from)), b = pos.get(keyOf(e.to));
      const near = Math.abs(a.col - b.col) + Math.abs(a.row - b.row) <= 1.01 || (Math.abs(a.col - b.col) === 1);
      const dx = x2 - x1, dy = y2 - y1, len = Math.hypot(dx, dy) || 1, ux = dx / len, uy = dy / len;
      const end = directed ? R + 3 : R;
      let d, mx, my;
      if (near) {
        d = `M${x1 + ux * R},${y1 + uy * R} L${x2 - ux * end},${y2 - uy * end}`;
        mx = (x1 + x2) / 2 - uy * 11; my = (y1 + y2) / 2 + ux * 11;
      } else {
        const bend = flip * Math.min(ARC * 1.9, 70 + 22 * Math.abs(a.col - b.col)); flip = -flip;
        const cx = (x1 + x2) / 2 - uy * bend, cy = (y1 + y2) / 2 + ux * bend;
        const toward = (x, y, r) => { const l = Math.hypot(cx - x, cy - y); return [x + (cx - x) / l * r, y + (cy - y) / l * r]; };
        const [sx, sy] = toward(x1, y1, R), [ex, ey] = toward(x2, y2, end);
        d = `M${sx},${sy} Q${cx},${cy} ${ex},${ey}`;
        mx = (x1 + 2 * cx + x2) / 4; my = (y1 + 2 * cy + y2) / 4;
      }
      const g = svg('g', {}, eg);
      const path = svg('path', { d, class: 'wt-edge' }, g);
      let label = null;
      if (e.label != null) {
        const t = textOf(e.label, ctx.lang), w = 10 + 7.5 * t.length;
        svg('rect', { x: mx - w / 2, y: my - 9, width: w, height: 18, rx: 9, class: 'wt-chipbg' }, g);
        label = svg('text', { x: mx, y: my + 4, 'text-anchor': 'middle', class: 'wt-elabel' }, g);
        label.textContent = t;
      }
      return { g, path, directed };
    });
    const nodeEls = new Map();
    for (const n of nodes) {
      const [x, y] = P(n.id);
      const g = svg('g', { transform: `translate(${x},${y})` }, root);
      svg('circle', { r: R, class: 'wt-node' }, g);
      svg('text', { y: 5, 'text-anchor': 'middle', class: 'wt-nid' }, g).textContent = n.label != null ? textOf(n.label, ctx.lang) : fmt(n.id);
      if (n.tag != null) svg('text', { y: -R - 8, 'text-anchor': 'middle', class: 'wt-tag wt-ntag' }, g).textContent = textOf(n.tag, ctx.lang);
      const val = svg('text', { y: R + 19, 'text-anchor': 'middle', class: 'wt-val wt-val-sm' }, g);
      nodeEls.set(keyOf(n.id), { g, val });
    }
    // crop to what was drawn: arcs only take the side they bend to
    try {
      const b = root.getBBox();
      if (b.width && b.height) { root.setAttribute('viewBox', `${b.x - 6} ${b.y - 6} ${b.width + 12} ${b.height + 12}`); root.setAttribute('width', b.width + 12); }
    } catch {}
    return { nodes, edges, edgeEls, nodeEls };
  }
  return {
    update(s) {
      if (!built || built.nodes !== s.nodes || built.edges !== s.edges) built = build(s.nodes || [], s.edges || []);
      const nm = markMap(s.nodeMarks), em = markMap(s.edgeMarks), values = s.values || {};
      built.edgeEls.forEach(({ g, path, directed }, i) => {
        const m = em.get(String(i)) || 'plain';
        g.setAttribute('class', 'wt-e wt-' + m);
        if (directed) path.setAttribute('marker-end', `url(#${ctx.uid}-ah-${m})`);
      });
      for (const [id, { g, val }] of built.nodeEls) {
        g.setAttribute('class', 'wt-n' + markClass(nm, id));
        val.textContent = fmt(values[id]);
      }
    },
  };
};

VIEWS.table = (host, config, ctx) => {
  host.innerHTML = '';
  const table = html('table', 'wt-table', host);
  return {
    update(s) {
      const m = markMap(s.marks);
      table.innerHTML = '';
      if (s.columns) {
        const tr = html('tr', null, html('thead', null, table));
        html('th', null, tr);
        for (const c of s.columns) html('th', null, tr, textOf(c, ctx.lang));
      }
      const body = html('tbody', null, table);
      (s.rows || []).forEach((row, r) => {
        const tr = html('tr', null, body);
        html('th', 'wt-rowlabel', tr, textOf(row.label, ctx.lang));
        row.cells.forEach((v, c) => html('td', 'wt-td' + markClass(m, [r, c]), tr, fmt(v)));
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

// ---------- the player ----------
const UI = {
  en: { expected: 'expected', extra: 'extra input', step: 'Step', first: 'First step', prev: 'Previous step', next: 'Next step', play: 'Play', pause: 'Pause', hint: '← → step · space plays' },
  ko: { expected: '기대값', extra: '추가 입력', step: '단계', first: '처음', prev: '이전 단계', next: '다음 단계', play: '재생', pause: '일시정지', hint: '← → 단계 이동 · 스페이스 재생' },
};
let uidSeq = 0;

export function mount(root, wt, options = {}) {
  const lang = options.lang || 'en', ui = { ...UI.en, ...(UI[lang] || {}), ...(options.ui || {}) };
  const ctx = { lang, uid: 'wt' + ++uidSeq };
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
  function mountRun(i) {
    runIdx = i;
    const run = wt.runs[i];
    stage.innerHTML = '';
    views = wt.views.map(v => {
      const box = html('figure', 'wt-view wt-view-' + v.type, stage);
      if (v.title != null) html('figcaption', 'wt-viewtitle', box, textOf(v.title, lang));
      const host = html('div', 'wt-viewbody', box);
      const make = VIEWS[v.type];
      if (!make) throw new Error(`walkthrough: no view type "${v.type}"`);
      return { id: v.id, box, view: make(host, v, ctx), setup: (run.setup || {})[v.id] || {} };
    });
    inputEl.textContent = run.input == null ? '' : fmt(run.input);
    expectedEl.textContent = run.expected === undefined ? '' : `${ui.expected} ${fmt(run.expected)}`;
    scrub.max = run.frames.length - 1;
    runButtons.forEach((b, j) => b.setAttribute('aria-selected', j === i));
  }
  function show(i, f) {
    if (i !== runIdx) { stop(); mountRun(i); }
    const run = wt.runs[runIdx];
    frameIdx = Math.max(0, Math.min(f, run.frames.length - 1));
    const frame = run.frames[frameIdx];
    for (const v of views) {
      const st = (frame.views || {})[v.id];
      v.box.hidden = st === undefined && !Object.keys(v.setup).length;
      if (!v.box.hidden) v.view.update({ ...v.setup, ...(st || {}) });
    }
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
    destroy() { stop(); root.removeEventListener('keydown', onKey); root.innerHTML = ''; root.classList.remove('wt'); },
  };
}
