// PROTOTYPE (throwaway): isometric Walkthrough style built on the anatomy kit (inlined before this file by build.mjs).
// Registers WT_STYLES.iso. Every drawn value comes from the frame; geometry is built once per mount, show() only
// toggles attributes and eases the moving parts (timer needle, courier token).
(() => {
const still = () => matchMedia('(prefers-reduced-motion: reduce)').matches;
const dark = () => matchMedia('(prefers-color-scheme: dark)').matches && document.documentElement.dataset.theme !== 'light';
if (!document.getElementById('iso-kit-css')) {
  const s = document.createElement('style'); s.id = 'iso-kit-css'; s.textContent = ISO_CSS; document.head.appendChild(s);
}
const FT = (m, text, style) => faceTextSvg(m, String(text), style);
const S = (paths, style) => solidSvg(paths, style);
const L = (d, style) => lineSvg(d, style);
const D = (points, style) => dotsSvg(points, style);
const T = (at, z, P, text, style) => FT(topMatrix(at, z, P, 'x'), text, style);
const esc = s => String(s).replace(/[&<>]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;' })[c]);

function wrap(stage) {
  const box = document.createElement('div');
  box.className = 'iso wt-iso';
  box.dataset.theme = dark() ? 'dark' : 'light';
  stage.appendChild(box);
  return box;
}
// Crop the figure's viewBox to what is drawn, so the scene fills the card at every width.
function crop(svg, pad = 10) {
  const b = svg.getBBox();
  svg.setAttribute('viewBox', `${b.x - pad} ${b.y - pad} ${b.width + 2 * pad} ${b.height + 2 * pad}`);
}

// Eased scalar follower driven by rAF; settles and stops.
function follower(apply, seconds = 0.45) {
  let value = null, target = 0, raf = 0, last = 0;
  const tick = now => {
    const dt = last ? Math.min((now - last) / 1000, 1 / 30) : 1 / 60; last = now;
    value += (target - value) * (1 - Math.exp(-dt / (seconds / 4)));
    if (Math.abs(target - value) < 1e-3) value = target;
    apply(value);
    raf = value === target ? 0 : requestAnimationFrame(tick);
  };
  return to => {
    target = to;
    if (value === null || still()) { value = to; apply(value); return; }
    if (!raf) { last = 0; raf = requestAnimationFrame(tick); }
  };
}

// ---------------------------------------------------------------- grid: a bakery tray
function mountGrid(stage, data, run) {
  const rows = run.frames[0].grid.cells.length, cols = run.frames[0].grid.cells[0].length;
  const PITCH = 34, R = 11, WELL = 13.2, M = 12, TRAY_H = 7, FOOT = 4;
  const tray = { x: -M, y: -M, w: cols * PITCH + 2 * M, d: rows * PITCH + 2 * M, r: 6 };
  const maxMin = Math.max(1, ...run.frames.map(f => f.vars.minute));
  const TIMER = [tray.x + tray.w + 26, tray.y + tray.d / 2], TR = 15, TZ = -TRAY_H - FOOT, TH = 14;
  const W = 620, H = 330;
  const P = fitProjection([...boxCorners(tray, -TRAY_H - FOOT, 12), [TIMER[0] + TR, TIMER[1] + TR, TZ + TH], [TIMER[0] - TR, TIMER[1] - TR, TZ]], W, H, { pad: 14, azimuth: 60, elevation: 34 });
  const at = p => iso(p, P);
  const centre = (r, c) => [c * PITCH + PITCH / 2, r * PITCH + PITCH / 2];
  const when = window.WT.staleMinutes(run);

  const out = [];
  // tray: feet, body, rim groove, corner screws, engraved row/column indices
  out.push(`<path class="iso-halo" d="${haloOf(tray, -TRAY_H - FOOT, TRAY_H, P)}"/>`);
  for (const [x, y] of corners(tray, 12).sort((a, b) => depthOf([...a, 0], P) - depthOf([...b, 0], P))) {
    out.push(S(cylinder(x, y, 5, -TRAY_H - FOOT, FOOT, P, 24), { tone: 'lo' }));
  }
  out.push(S(slabOf(tray, -TRAY_H, TRAY_H, P, 8, 1.2), { tone: 'mid' }));
  out.push(L(planOutline(insetPlan(tray, 4), 0, P), { tone: 'lo' }));
  const screws = corners(tray, 6.5);
  out.push(L(screws.map(([x, y]) => ring(x, y, 1.8, 0, P, 14)).join(''), { tone: 'lo' }));
  out.push(D(screws.map(([x, y]) => at([x, y, 0])), { size: 0.45 }));
  for (let c = 0; c < cols; c++) out.push(T([centre(0, c)[0], -5], 0, P, c, { size: 4.2, tone: 'mid', anchor: 'middle' }));
  for (let r = 0; r < rows; r++) out.push(T([-7, centre(r, 0)[1] + 1.5], 0, P, r, { size: 4.2, tone: 'mid', anchor: 'middle' }));
  out.push(FT(topMatrix([tray.x + tray.w - 6, tray.y + tray.d - 7], 0, P, 'x'), 'ward', { size: 3.4, tone: 'faint', anchor: 'end' }));

  // kitchen timer beside the tray: reads the minute
  out.push(`<path class="iso-halo" d="${haloOf({ x: TIMER[0] - TR, y: TIMER[1] - TR, w: 2 * TR, d: 2 * TR, r: TR }, TZ, TH, P)}"/>`);
  out.push(S(cylinder(TIMER[0], TIMER[1], TR + 1.5, TZ, 2.5, P, 48), { tone: 'lo' }));
  out.push(S(cylinder(TIMER[0], TIMER[1], TR, TZ + 2.5, TH - 2.5, P, 64, 0.8), { tone: 'hi', crease: 'lo' }));
  out.push(L(knurl(TIMER[0], TIMER[1], TR, TZ + TH - 4, TZ + TH, 64, P, 0.3), { tone: 'lo' }));
  out.push(L(ring(TIMER[0], TIMER[1], TR - 2, TZ + TH, P, 48), { tone: 'lo' }));
  const SPAN = Math.PI * 1.5, FROM = -Math.PI * 0.75;
  const ticks = radialTicks(TIMER[0], TIMER[1], TR - 2.6, maxMin * 4, 4, TZ + TH, [1.1, 2.4], P, FROM, SPAN);
  out.push(L(ticks.minor, { tone: 'lo' }), L(ticks.major, { tone: 'mid' }));
  for (let m = 0; m <= maxMin; m++) {
    const a = FROM + (m / maxMin) * SPAN;
    out.push(T([TIMER[0] + Math.sin(a) * (TR - 6.6), TIMER[1] - Math.cos(a) * (TR - 6.6) + 1.2], TZ + TH, P, m, { size: 2.8, tone: 'mid', anchor: 'middle' }));
  }
  out.push(T([TIMER[0], TIMER[1] + 6.5], TZ + TH, P, 'MIN', { size: 2.4, tone: 'lo', anchor: 'middle' }));
  out.push(`<path data-part="needle" class="iso-line" data-tone="lit" data-free="start" style="stroke-width:1.3px" d=""/>`);
  out.push(L(ring(TIMER[0], TIMER[1], 1.4, TZ + TH, P, 12), { tone: 'mid' }));

  // cells, back to front: well, wave ring, stuck ring, fresh donut, stale donut, minute stamp
  const order = [];
  for (let r = 0; r < rows; r++) for (let c = 0; c < cols; c++) order.push([r, c]);
  order.sort((a, b) => depthOf([...centre(...a), 0], P) - depthOf([...centre(...b), 0], P));
  const donut = (cx, cy, h, cls) => {
    const top = h;
    const parts = [S(cylinder(cx, cy, R, 0, h, P, 48, 0.6), { tone: 'hi', crease: 'lo', className: cls })];
    parts.push(`<path class="wt-glaze" d="${onTop(circleRing(cx, cy, R - 2.6, 40), top, P, true)}"/>`);
    parts.push(`<path class="wt-hole" d="${onTop(circleRing(cx, cy, 3.4, 24), top, P, true)}"/>`);
    parts.push(L(ring(cx, cy, 3.4, top, P, 24), { tone: 'mid' }));
    return parts.join('');
  };
  for (const [r, c] of order) {
    const [cx, cy] = centre(r, c);
    const g = [];
    g.push(`<g class="wt-well">${L(ring(cx, cy, WELL, 0, P, 48), { tone: 'lo' })}${L(ring(cx, cy, WELL - 1, 0, P, 48), { tone: 'faint' })}</g>`);
    g.push(`<path class="iso-line wt-wave" data-tone="lit" d="${ring(cx, cy, WELL + 1.6, 0, P, 56)}"/>`);
    g.push(`<path class="iso-line wt-stuck" data-tone="red" d="${ring(cx, cy, WELL + 1.6, 0, P, 56)}"/>`);
    // sprinkles on the fresh glaze: fixed, decorative parts of the donut itself
    const spr = [0.4, 1.5, 2.6, 3.7, 4.8, 5.7].map(a => at([cx + Math.cos(a) * (R - 4.6), cy + Math.sin(a) * (R - 4.6), 7]));
    g.push(`<g class="wt-donut wt-fresh">${donut(cx, cy, 7, 'wt-dough-fresh')}${D(spr, { size: 0.55, tone: 'hi' })}</g>`);
    const spots = [0.9, 2.2, 3.4, 4.6, 5.8].map(a => at([cx + Math.cos(a) * (R - 4.2), cy + Math.sin(a) * (R - 4.2), 4]));
    g.push(`<g class="wt-donut wt-stale">${donut(cx, cy, 4, 'wt-dough-stale')}<g class="wt-spots">${D(spots, { size: 0.7, tone: 'mid' })}</g></g>`);
    g.push(`<g class="wt-stamp">${T([cx, cy + 9], 4, P, when[r + ',' + c] ? (when[r + ',' + c].minute === 0 ? 'start' : 'min ' + when[r + ',' + c].minute) : '', { size: 3.2, tone: 'hi', anchor: 'middle' })}</g>`);
    out.push(`<g class="wt-cell" data-rc="${r},${c}">${g.join('')}</g>`);
  }

  const box = wrap(stage);
  box.innerHTML = figureSvg({ width: W, height: H, label: `A baking tray of ${rows} by ${cols} wells. Fresh donuts are tall and glazed; stale ones sink and darken. A lit ring marks the current wave, and a kitchen timer counts the minutes.`, body: out })
    + `<div class="wt-strip"><span><b>MINUTE</b> <i data-k="minute"></i></span><span><b>FRESH LEFT</b> <i data-k="fresh"></i></span><span class="wt-q"><b>WAVE</b> <i data-k="wave"></i></span></div>`;
  const svg = box.querySelector('svg');
  crop(svg);
  const cellEls = new Map([...svg.querySelectorAll('.wt-cell')].map(e => [e.dataset.rc, e]));
  const needle = svg.querySelector('[data-part="needle"]');
  const setNeedle = follower(m => {
    const a = FROM + (m / maxMin) * SPAN;
    needle.setAttribute('d', lineOnTop([TIMER[0] - Math.sin(a) * 2.6, TIMER[1] + Math.cos(a) * 2.6], [TIMER[0] + Math.sin(a) * (TR - 4), TIMER[1] - Math.cos(a) * (TR - 4)], TZ + TH + 0.2, P));
  }, 0.6);
  const k = n => box.querySelector(`[data-k="${n}"]`);
  return {
    show(i) {
      const f = run.frames[i];
      const lit = new Set(f.grid.lit.map(p => p.join(','))), ring_ = new Set(f.grid.ring.map(p => p.join(','))), stuck = new Set(f.grid.stuck.map(p => p.join(',')));
      cellEls.forEach((e, rc) => {
        const [r, c] = rc.split(',').map(Number), v = f.grid.cells[r][c];
        e.dataset.v = v;
        e.toggleAttribute('data-wave', ring_.has(rc));
        e.toggleAttribute('data-new', lit.has(rc));
        e.toggleAttribute('data-stuck', stuck.has(rc));
        e.toggleAttribute('data-stamped', v === 2 && !!when[rc] && when[rc].frame <= i);
      });
      setNeedle(f.vars.minute);
      k('minute').textContent = f.vars.minute;
      k('fresh').textContent = f.vars.fresh;
      k('fresh').className = f.answer === -1 && f.vars.fresh ? 'bad' : '';
      k('wave').innerHTML = f.vars.wave.length ? f.vars.wave.map(([r, c]) => `<em>${r},${c}</em>`).join('') : '<u>empty</u>';
    },
  };
}

// ---------------------------------------------------------------- graph: a courier dispatch board
function mountGraph(stage, data, run) {
  const { pos, cols, rows } = window.WT.layoutGraph(run);
  const DX = 72, DY = 62, PR = 10, PH = 7, BOARD_H = 6, FOOT = 4, M = 24;
  // a narrow card stands the chain on end, so the board runs down the screen instead of across it
  const tall = stage.clientWidth < 520;
  const node = v => tall ? [pos[v].row * DY, pos[v].col * DX] : [pos[v].col * DX, pos[v].row * DY];

  // edge routes on the board top (z = 0): straight for neighbours, quadratic arcs (alternating) for skips
  let flip = 1;
  const routes = run.links.map(([a, b]) => {
    const A = node(a), B = node(b);
    const dx = B[0] - A[0], dy = B[1] - A[1], len = Math.hypot(dx, dy) || 1, ux = dx / len, uy = dy / len;
    const span = Math.abs(pos[b].col - pos[a].col);
    const straight = span === 1 || (span === 0 && Math.abs(pos[b].row - pos[a].row) === 1);
    let pts;
    if (straight) pts = [A, B];
    else {
      const bend = flip * (30 + 14 * span); flip = -flip;
      const C = [(A[0] + B[0]) / 2 - uy * bend, (A[1] + B[1]) / 2 + ux * bend];
      pts = Array.from({ length: 25 }, (_, t) => { t /= 24; return [(1 - t) ** 2 * A[0] + 2 * (1 - t) * t * C[0] + t * t * B[0], (1 - t) ** 2 * A[1] + 2 * (1 - t) * t * C[1] + t * t * B[1]]; });
    }
    // trim to the puck rims
    const trim = (p, from, d) => {
      let acc = 0, q = from === 0 ? p : [...p].reverse();
      for (let i = 1; i < q.length; i++) {
        const seg = Math.hypot(q[i][0] - q[i - 1][0], q[i][1] - q[i - 1][1]);
        if (acc + seg >= d) { const t = (d - acc) / seg; const s = [q[i - 1][0] + (q[i][0] - q[i - 1][0]) * t, q[i - 1][1] + (q[i][1] - q[i - 1][1]) * t]; q = [s, ...q.slice(i)]; break; }
        acc += seg;
      }
      return from === 0 ? q : q.reverse();
    };
    pts = trim(trim(pts, 0, PR + 3), 1, PR + 4);
    return pts;
  });
  // the board covers every cafe and every route with a margin
  const fx = [...Array(run.n).keys()].map(node).concat(...routes);
  const bx0 = Math.min(...fx.map(p => p[0])) - M, bx1 = Math.max(...fx.map(p => p[0])) + M;
  const by0 = Math.min(...fx.map(p => p[1])) - M, by1 = Math.max(...fx.map(p => p[1])) + M;
  const board = { x: bx0, y: by0, w: bx1 - bx0, d: by1 - by0, r: 8 };
  const W = 640, H = 380;
  const P = fitProjection([...boxCorners(board, -BOARD_H - FOOT, PH + 12)], W, H, { pad: 10, azimuth: 66, elevation: tall ? 48 : 36 });
  const at = p => iso(p, P);
  const lengthOf = pts => pts.slice(1).reduce((s, p, i) => s + Math.hypot(p[0] - pts[i][0], p[1] - pts[i][1]), 0);
  const pointAt = (pts, d) => {
    for (let i = 1; i < pts.length; i++) {
      const seg = Math.hypot(pts[i][0] - pts[i - 1][0], pts[i][1] - pts[i - 1][1]);
      if (d <= seg) { const t = d / seg; return [pts[i - 1][0] + (pts[i][0] - pts[i - 1][0]) * t, pts[i - 1][1] + (pts[i][1] - pts[i - 1][1]) * t]; }
      d -= seg;
    }
    return pts[pts.length - 1];
  };

  const out = [];
  out.push(`<path class="iso-halo" d="${haloOf(board, -BOARD_H - FOOT, BOARD_H, P)}"/>`);
  for (const [x, y] of corners(board, 14).sort((a, b) => depthOf([...a, 0], P) - depthOf([...b, 0], P))) out.push(S(cylinder(x, y, 5, -BOARD_H - FOOT, FOOT, P, 24), { tone: 'lo' }));
  out.push(S(slabOf(board, -BOARD_H, BOARD_H, P, 8, 1.2), { tone: 'mid' }));
  out.push(L(planOutline(insetPlan(board, 4), 0, P), { tone: 'lo' }));
  const screws = corners(board, 7);
  out.push(L(screws.map(([x, y]) => ring(x, y, 1.8, 0, P, 14)).join(''), { tone: 'lo' }));
  out.push(D(screws.map(([x, y]) => at([x, y, 0])), { size: 0.45 }));
  out.push(FT(topMatrix([board.x + board.w - 8, board.y + board.d - 8], 0, P, 'x'), 'courier links', { size: 3.4, tone: 'faint', anchor: 'end' }));

  // routes: an engraved groove (two lines) plus a chevron at the head, and the minutes engraved beside the middle
  routes.forEach((pts, i) => {
    const [, , w] = run.links[i];
    const tip = pts[pts.length - 1], prev = pointAt(pts, lengthOf(pts) - 5);
    const ux = tip[0] - prev[0], uy = tip[1] - prev[1], l = Math.hypot(ux, uy), nx = -uy / l * 3, ny = ux / l * 3;
    const back = [tip[0] - ux / l * 6, tip[1] - uy / l * 6];
    const chev = onTop([[back[0] + nx, back[1] + ny], tip, [back[0] - nx, back[1] - ny]], 0, P);
    const mid = pointAt(pts, lengthOf(pts) / 2);
    const nmx = -(pointAt(pts, lengthOf(pts) / 2 + 1)[1] - pointAt(pts, lengthOf(pts) / 2 - 1)[1]) / 2, nmy = (pointAt(pts, lengthOf(pts) / 2 + 1)[0] - pointAt(pts, lengthOf(pts) / 2 - 1)[0]) / 2;
    const lab = [mid[0] + nmx * 9, mid[1] + nmy * 9 + 1.9];
    out.push(`<g class="wt-route" data-i="${i}">`
      + `<path class="wt-bed" d="${onTop(pts, 0, P)}"/>`
      + `<path class="iso-line wt-groove" d="${onTop(pts, 0, P)}"/>`
      + `<path class="iso-line wt-chev" d="${chev}"/>`
      + `<path class="wt-wplate" d="${onTop(circleRing(lab[0], lab[1] - 1.9, 6.6, 24), 0, P, true)}"/>`
      + FT(topMatrix(lab, 0, P, 'x'), w, { size: 5, tone: 'mid', anchor: 'middle' })
      + `</g>`);
  });

  // cafes back to front: puck, engraved id, display block with the cost on its top
  const order = [...Array(run.n).keys()].sort((a, b) => depthOf([...node(a), 0], P) - depthOf([...node(b), 0], P));
  const DISP = { w: 28, d: 17 };
  for (const v of order) {
    const [x, y] = node(v);
    const g = [];
    g.push(`<path class="iso-halo" d="${haloOf({ x: x - PR, y: y - PR, w: 2 * PR, d: 2 * PR, r: PR }, 0, PH, P)}" style="filter:blur(4px)"/>`);
    g.push(S(cylinder(x, y, PR + 1.2, 0, 1.4, P, 40), { tone: 'lo' }));
    g.push(`<g class="wt-puck">${S(cylinder(x, y, PR, 1.4, PH - 1.4, P, 48, 0.6), { tone: 'hi', crease: 'lo' })}</g>`);
    g.push(L(sideArc(x, y, PR, 4, P, 24), { tone: 'faint' }));
    const plan = { x: x - DISP.w / 2, y: y - DISP.d / 2, w: DISP.w, d: DISP.d, r: 2 };
    g.push(`<g class="wt-disp">${S(slabOf(plan, PH, 5, P, 3, 0.5), { tone: 'hi', crease: 'lo' })}</g>`);
    g.push(L(planOutline(insetPlan(plan, 1.6), PH + 5, P, 3), { tone: 'faint' }));
    g.push(FT(topMatrix([x, y - 2.6], PH + 5, P, 'x'), '#' + v + (v === run.src ? ' SRC' : v === run.dst ? ' DST' : ''), { size: 4.2, tone: v === run.src || v === run.dst ? 'hi' : 'mid', anchor: 'middle' }));
    g.push(`<g class="wt-cost">${FT(topMatrix([x, y + 6.3], PH + 5, P, 'x'), '∞', { size: 8, tone: 'hi', anchor: 'middle' })}</g>`);
    out.push(`<g class="wt-cafe" data-v="${v}">${g.join('')}</g>`);
  }
  // the courier token: a small lit puck that rides the leg being relaxed (drawn last, it is the one moving part)
  out.push(`<g data-part="token" class="wt-token">${S(cylinder(0, 0, 3.4, 0, 3, P, 24), { tone: 'hi', lit: true })}</g>`);

  const box = wrap(stage);
  box.innerHTML = figureSvg({ width: W, height: H, label: `A dispatch board with ${run.n} cafe pucks joined by engraved one-way courier links, each marked with its minutes. Each cafe carries a display with its cheapest known cost; a lit token rides the link being relaxed.`, body: out })
    + `<div class="wt-strip wt-table"><span class="wt-round"></span><table><thead><tr><th></th>${[...Array(run.n).keys()].map(v => `<th>${v}</th>`).join('')}</tr></thead><tbody><tr data-row="0"><th>last round</th>${'<td></td>'.repeat(run.n)}</tr><tr data-row="1"><th>this round</th>${'<td></td>'.repeat(run.n)}</tr></tbody></table></div>`;
  const svg = box.querySelector('svg');
  crop(svg);
  const routeEls = [...svg.querySelectorAll('.wt-route')];
  const cafeEls = new Map([...svg.querySelectorAll('.wt-cafe')].map(e => [+e.dataset.v, e]));
  const token = svg.querySelector('[data-part="token"]');
  let tokenRaf = 0;
  const rideToken = (i, animate) => {
    cancelAnimationFrame(tokenRaf);
    if (i == null) { token.style.opacity = 0; return; }
    const pts = routes[i], len = lengthOf(pts);
    token.style.opacity = 1;
    const place = t => { const [x, y] = pointAt(pts, len * t); token.setAttribute('transform', translateAlong(P, [x, y, 0])); };
    if (!animate || still()) { place(1); return; }
    let t0 = 0;
    const tick = now => { if (!t0) t0 = now; const u = Math.min(1, (now - t0) / 650); place(1 - (1 - u) ** 3); if (u < 1) tokenRaf = requestAnimationFrame(tick); };
    place(0); tokenRaf = requestAnimationFrame(tick);
  };
  const fmt = c => (c == null ? '∞' : c);
  return {
    show(i, from) {
      const f = run.frames[i];
      const pathEdges = new Set();
      for (let j = 1; j < f.graph.path.length; j++) pathEdges.add(run.links.findIndex(([a, b]) => a === f.graph.path[j - 1] && b === f.graph.path[j]));
      const changedNode = f.graph.improved ? run.links[f.graph.edge][1] : null;
      const reading = f.graph.edge != null ? run.links[f.graph.edge][0] : null;
      routeEls.forEach((e, k) => {
        e.dataset.s = pathEdges.has(k) ? 'path' : k === f.graph.edge ? (f.graph.improved ? 'good' : f.vars.cost[run.links[k][0]] == null ? 'skip' : 'lit') : '';
      });
      cafeEls.forEach((e, v) => {
        e.querySelector('.wt-cost text').textContent = fmt(f.graph.pathCosts && f.graph.pathCosts[v] != null ? f.graph.pathCosts[v] : f.vars.updated[v]);
        e.toggleAttribute('data-unreached', f.vars.updated[v] == null);
        e.toggleAttribute('data-changed', v === changedNode);
        e.toggleAttribute('data-reading', v === reading);
        e.toggleAttribute('data-path', f.graph.path.includes(v));
      });
      rideToken(f.graph.edge, from != null && Math.abs(i - from) === 1);
      box.querySelector('.wt-round').innerHTML = f.vars.round ? `<b>ROUND</b> ${f.vars.round} / ${f.vars.rounds} <small>round r allows r legs</small>` : `<b>BEFORE ROUND 1</b> <small>${f.vars.rounds} round${f.vars.rounds > 1 ? 's' : ''} to go</small>`;
      [f.vars.cost, f.vars.updated].forEach((row, ri) => {
        const tds = box.querySelectorAll(`tr[data-row="${ri}"] td`);
        row.forEach((c, v) => {
          tds[v].textContent = fmt(c);
          tds[v].className = (c == null ? 'inf ' : '') + (ri === 1 && v === changedNode ? 'changed' : '') + (ri === 0 && v === reading ? 'read' : '');
        });
      });
    },
  };
}

window.WT_STYLES.iso = {
  label: 'Isometric',
  mount(stage, data, run) { return data.kind === 'grid' ? mountGrid(stage, data, run) : mountGraph(stage, data, run); },
};
})();
