// PROTOTYPE (throwaway): flat 2D Walkthrough style. Registers WT_STYLES.flat and the shared helpers on window.WT.
(() => {
const NS = 'http://www.w3.org/2000/svg';
const el = (tag, attrs = {}, parent) => {
  const n = document.createElementNS(NS, tag);
  for (const k in attrs) n.setAttribute(k, attrs[k]);
  if (parent) parent.appendChild(n);
  return n;
};
const key = (r, c) => r + ',' + c;

// Shared, derived only from the trace: the minute each cell went stale (frame index of the minute it first shows as 2).
function staleMinutes(run) {
  const when = {};
  run.frames.forEach((f, i) => f.grid.cells.forEach((row, r) => row.forEach((v, c) => {
    if (v === 2 && !(key(r, c) in when)) when[key(r, c)] = { minute: f.vars.minute, frame: i };
  })));
  return when;
}

// Shared graph layout: longest-path layers when acyclic (a chain reads as "hops from src"), BFS layers otherwise.
function layoutGraph(run) {
  const n = run.n, out = Array.from({ length: n }, () => []);
  const indeg = new Array(n).fill(0);
  run.links.forEach(([a, b]) => { out[a].push(b); indeg[b]++; });
  const layer = new Array(n).fill(0), order = [], q = [];
  const deg = indeg.slice();
  for (let i = 0; i < n; i++) if (!deg[i]) q.push(i);
  while (q.length) { const v = q.shift(); order.push(v); out[v].forEach(w => { layer[w] = Math.max(layer[w], layer[v] + 1); if (!--deg[w]) q.push(w); }); }
  if (order.length < n) { // cyclic: BFS from src
    layer.fill(-1); layer[run.src] = 0; const bq = [run.src];
    while (bq.length) { const v = bq.shift(); out[v].forEach(w => { if (layer[w] < 0) { layer[w] = layer[v] + 1; bq.push(w); } }); }
    const maxL = Math.max(...layer); layer.forEach((l, i) => { if (l < 0) layer[i] = maxL + 1; });
  }
  const byLayer = {};
  layer.forEach((l, i) => (byLayer[l] = byLayer[l] || []).push(i));
  const pos = [];
  Object.entries(byLayer).forEach(([l, vs]) => vs.forEach((v, j) => { pos[v] = { col: +l, row: j - (vs.length - 1) / 2 }; }));
  return { pos, cols: Math.max(...layer) + 1, rows: Math.max(...Object.values(byLayer).map(v => v.length)) };
}
window.WT = { el, key, staleMinutes, layoutGraph };

// ---------- grid ----------
function mountGrid(stage, data, run) {
  const rows = run.frames[0].grid.cells.length, cols = run.frames[0].grid.cells[0].length;
  const S = 68, G = 8, pad = 26, gw = cols * S + (cols - 1) * G, gh = rows * S + (rows - 1) * G;
  const panelW = 190, W = pad * 2 + gw + 28 + panelW, H = Math.max(gh + pad * 2 + 18, 230);
  const svg = el('svg', { viewBox: `0 0 ${W} ${H}`, width: W, class: 'fl' }, stage);
  const when = staleMinutes(run);
  const cells = [];
  for (let r = 0; r < rows; r++) for (let c = 0; c < cols; c++) {
    const x = pad + c * (S + G), y = pad + 18 + r * (S + G);
    const g = el('g', { transform: `translate(${x},${y})` }, svg);
    el('rect', { width: S, height: S, rx: 10, class: 'fl-cell' }, g);
    const donut = el('g', { class: 'fl-donut', transform: `translate(${S / 2},${S / 2 + 6})` }, g);
    el('circle', { r: 17, class: 'fl-dough' }, donut);
    el('circle', { r: 5.5, class: 'fl-hole' }, donut);
    [[-8, -8], [9, -4], [-3, 10], [10, 8]].forEach(([dx, dy]) => el('circle', { cx: dx, cy: dy, r: 2.6, class: 'fl-spot' }, donut));
    const t = el('text', { x: S / 2, y: 13, 'text-anchor': 'middle', class: 'fl-when' }, g);
    el('rect', { width: S, height: S, rx: 10, class: 'fl-ring' }, g);
    if (c === 0) el('text', { x: -8, y: S / 2 + 4, 'text-anchor': 'end', class: 'fl-rc' }, g).textContent = r;
    if (r === 0) el('text', { x: S / 2, y: -6, 'text-anchor': 'middle', class: 'fl-rc' }, g).textContent = c;
    cells.push({ r, c, g, t });
  }
    // working-state panel
  const px = pad + gw + 28;
  const panel = el('g', { transform: `translate(${px},${pad + 18})` }, svg);
  const stat = (y, label) => {
    el('text', { x: 0, y, class: 'fl-label' }, panel).textContent = label;
    return el('text', { x: 0, y: y + 30, class: 'fl-big' }, panel);
  };
  const minuteT = stat(0, 'MINUTE'), freshT = stat(62, 'FRESH LEFT');
  el('text', { x: 0, y: 124, class: 'fl-label' }, panel).textContent = 'WAVE (QUEUE)';
  const waveG = el('g', { transform: 'translate(0,136)' }, panel);

  return {
    show(i) {
      const f = run.frames[i], lit = new Set(f.grid.lit.map(p => key(...p))), ring = new Set(f.grid.ring.map(p => key(...p)));
      const stuck = new Set(f.grid.stuck.map(p => key(...p)));
      cells.forEach(({ r, c, g, t }) => {
        const v = f.grid.cells[r][c], k = key(r, c);
        g.setAttribute('class', 'fl-c v' + v + (lit.has(k) ? ' lit' : '') + (ring.has(k) ? ' wave' : '') + (stuck.has(k) ? ' stuck' : ''));
        t.textContent = v === 2 && when[k] && when[k].frame <= i ? (when[k].minute === 0 ? 'start' : 'min ' + when[k].minute) : '';
      });
      minuteT.textContent = f.vars.minute;
      freshT.textContent = f.vars.fresh;
      freshT.setAttribute('class', 'fl-big' + (f.answer === -1 && f.vars.fresh ? ' bad' : ''));
      waveG.innerHTML = '';
      if (!f.vars.wave.length) el('text', { x: 0, y: 16, class: 'fl-empty' }, waveG).textContent = 'empty';
      f.vars.wave.forEach(([r, c], j) => {
        const cg = el('g', { transform: `translate(${(j % 3) * 58},${Math.floor(j / 3) * 30})` }, waveG);
        el('rect', { width: 52, height: 24, rx: 12, class: 'fl-chip' }, cg);
        el('text', { x: 26, y: 16, 'text-anchor': 'middle', class: 'fl-chipt' }, cg).textContent = `${r},${c}`;
      });
    },
  };
}

// ---------- graph ----------
function mountGraph(stage, data, run) {
  const { pos, cols, rows } = layoutGraph(run);
  const DX = 132, DY = 96, R = 22, padX = 44;
  const ARC = 96;
  const top = 46 + (rows > 1 ? (rows - 1) / 2 * DY : 0) + ARC;
  const gw = (cols - 1) * DX + padX * 2;
  const tableY = top + (rows - 1) / 2 * DY + ARC + 64;
  const W = Math.max(gw, 140 + run.n * 64), H = tableY + 96;
  const offX = (W - gw) / 2;
  const P = v => [offX + padX + pos[v].col * DX, top + pos[v].row * DY];
  const svg = el('svg', { viewBox: `0 0 ${W} ${H}`, width: W, class: 'fl' }, stage);
  const defs = el('defs', {}, svg);
  ['base', 'lit', 'good', 'path'].forEach(t => {
    const m = el('marker', { id: 'ah-' + t, viewBox: '0 0 10 10', refX: 9, refY: 5, markerWidth: 7, markerHeight: 7, orient: 'auto-start-reverse' }, defs);
    el('path', { d: 'M0,0 L10,5 L0,10 z', class: 'fl-ah ' + t }, m);
  });
  // edges: straight between adjacent columns, arcs (alternating) for skips and same-column
  let arcFlip = 1;
  const edges = run.links.map(([a, b, w], i) => {
    const [x1, y1] = P(a), [x2, y2] = P(b);
    const span = Math.abs(pos[b].col - pos[a].col);
    const g = el('g', { class: 'fl-e' }, svg);
    let d, mx, my;
    const dx = x2 - x1, dy = y2 - y1, len = Math.hypot(dx, dy), ux = dx / len, uy = dy / len;
    if (span === 1 || (span === 0 && Math.abs(pos[b].row - pos[a].row) === 1) || len < 1) {
      d = `M${x1 + ux * R},${y1 + uy * R} L${x2 - ux * (R + 3)},${y2 - uy * (R + 3)}`; mx = (x1 + x2) / 2 - uy * 12; my = (y1 + y2) / 2 + ux * 12 - 4;
    } else {
      const bend = arcFlip * (130 + 24 * span); arcFlip = -arcFlip;
      const cx = (x1 + x2) / 2 - uy * bend, cy = (y1 + y2) / 2 + ux * bend;
      const sx = x1 + (cx - x1) / Math.hypot(cx - x1, cy - y1) * R, sy = y1 + (cy - y1) / Math.hypot(cx - x1, cy - y1) * R;
      const ex = x2 + (cx - x2) / Math.hypot(cx - x2, cy - y2) * (R + 3), ey = y2 + (cy - y2) / Math.hypot(cx - x2, cy - y2) * (R + 3);
      d = `M${sx},${sy} Q${cx},${cy} ${ex},${ey}`; mx = (x1 + 2 * cx + x2) / 4; my = (y1 + 2 * cy + y2) / 4 + 4;
    }
    const path = el('path', { d, class: 'fl-edge', 'marker-end': 'url(#ah-base)' }, g);
    const lbg = el('rect', { x: mx - 17, y: my - 12, width: 34, height: 18, rx: 9, class: 'fl-wbg' }, g);
    el('text', { x: mx, y: my + 1, 'text-anchor': 'middle', class: 'fl-w' }, g).textContent = w;
    return { g, path, a, b };
  });
  const nodes = [];
  for (let v = 0; v < run.n; v++) {
    const [x, y] = P(v);
    const g = el('g', { transform: `translate(${x},${y})` }, svg);
    el('circle', { r: R, class: 'fl-node' }, g);
    el('text', { y: 5, 'text-anchor': 'middle', class: 'fl-nid' }, g).textContent = v;
    const tag = v === run.src ? 'src' : v === run.dst ? 'dst' : '';
    if (tag) el('text', { y: -R - 8, 'text-anchor': 'middle', class: 'fl-tag' }, g).textContent = tag;
    const cost = el('text', { y: R + 20, 'text-anchor': 'middle', class: 'fl-cost' }, g);
    nodes.push({ g, cost });
  }
  // two-row cost table: last round vs this round
  const tx = (W - (96 + run.n * 52)) / 2;
  const table = el('g', { transform: `translate(${tx},${tableY})` }, svg);
  const roundT = el('text', { x: 0, y: -30, class: 'fl-label' }, table);
  const cellsT = [[], []];
  ['last round', 'this round'].forEach((label, row) => {
    el('text', { x: 0, y: row * 32 + 20, class: 'fl-rowl' }, table).textContent = label;
    for (let v = 0; v < run.n; v++) {
      const g = el('g', { transform: `translate(${96 + v * 52},${row * 32})` }, table);
      if (row === 0) el('text', { x: 23, y: -4, 'text-anchor': 'middle', class: 'fl-colh' }, g).textContent = 'cafe ' + v;
      const rect = el('rect', { width: 46, height: 28, rx: 6, class: 'fl-tc' }, g);
      const t = el('text', { x: 23, y: 19, 'text-anchor': 'middle', class: 'fl-tv' }, g);
      cellsT[row].push({ rect, t, g });
    }
  });
  const fmt = c => (c == null ? '∞' : c);

  return {
    show(i) {
      const f = run.frames[i], prev = run.frames[i - 1];
      const pathEdges = new Set();
      for (let j = 1; j < f.graph.path.length; j++) {
        const k = run.links.findIndex(([a, b]) => a === f.graph.path[j - 1] && b === f.graph.path[j]); pathEdges.add(k);
      }
      const reading = f.graph.edge != null ? run.links[f.graph.edge][0] : null;
      edges.forEach(({ g, path }, k) => {
        let s = 'base';
        if (pathEdges.has(k)) s = 'path';
        else if (k === f.graph.edge) s = f.graph.improved ? 'good' : 'lit';
        g.setAttribute('class', 'fl-e ' + s);
        path.setAttribute('marker-end', `url(#ah-${s})`);
      });
      nodes.forEach(({ g, cost }, v) => {
        const c = f.graph.pathCosts && f.graph.pathCosts[v] != null ? f.graph.pathCosts[v] : f.vars.updated[v];
        cost.textContent = fmt(c);
        const changed = f.graph.improved && run.links[f.graph.edge][1] === v;
        g.setAttribute('class', 'fl-n' + (c == null ? ' unreached' : '') + (changed ? ' changed' : '') + (v === reading ? ' reading' : '') + (f.graph.path.includes(v) ? ' onpath' : ''));
      });
      roundT.textContent = f.vars.round ? `ROUND ${f.vars.round} OF ${f.vars.rounds}  ·  round r allows r legs` : `BEFORE ROUND 1  ·  ${f.vars.rounds} round${f.vars.rounds > 1 ? 's' : ''} to go`;
      [f.vars.cost, f.vars.updated].forEach((row, ri) => row.forEach((c, v) => {
        const cell = cellsT[ri][v];
        cell.t.textContent = fmt(c);
        const changed = ri === 1 && f.graph.improved && run.links[f.graph.edge][1] === v;
        const read = ri === 0 && v === reading;
        cell.g.setAttribute('class', 'fl-tcell' + (changed ? ' changed' : '') + (read ? ' read' : '') + (c == null ? ' inf' : ''));
      }));
    },
  };
}

window.WT_STYLES.flat = {
  label: 'Flat',
  mount(stage, data, run) { return data.kind === 'grid' ? mountGrid(stage, data, run) : mountGraph(stage, data, run); },
};
})();
