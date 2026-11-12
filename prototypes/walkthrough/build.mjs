// PROTOTYPE: node build.mjs -> rotting-donuts.html, cheapest-courier-route.html (one page per problem, ?style= switches)
import { readFileSync, writeFileSync, existsSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
import { homedir } from 'node:os';
const here = new URL('.', import.meta.url).pathname;
const read = f => readFileSync(here + f, 'utf8');
const styles = ['flat', 'iso'].filter(s => existsSync(here + s + '.js'));
// the iso style draws with the anatomy kit (~/.agents/skills/anatomy), inlined ahead of the style scripts
const kit = styles.includes('iso') ? (await import(homedir() + '/.agents/skills/anatomy/scripts/inline-kit.mjs')).kitScript().replace(/<\/(script)/gi, '<\\/$1') + '\n;\n' : '';
for (const slug of ['rotting-donuts', 'cheapest-courier-route']) {
  const json = execFileSync('python3', [here + 'trace_' + slug.replace(/-/g, '_') + '.py']).toString();
  writeFileSync(here + slug + '.json', json);
  const data = JSON.parse(json);
  const html = read('shell.html')
    .replaceAll('__TITLE__', data.title)
    .replace('__STYLE_CSS__', () => styles.map(s => existsSync(here + s + '.css') ? read(s + '.css') : '').join('\n'))
    .replace('__STYLE_JS__', () => kit + styles.map(s => read(s + '.js')).join('\n;\n'))
    .replace('__DATA__', () => json);
  writeFileSync(here + slug + '.html', html);
  console.log(slug + '.html', styles.join(','));
}
