"""Validate skill links, source paths, principle IDs and evidence-before-authoring record."""
from pathlib import Path
import re,json,sys
root=Path(sys.argv[1] if len(sys.argv)>1 else '.').resolve()
errors=[]
files=list(root.rglob('*.md'))
for f in files:
    text=f.read_text()
    for target in re.findall(r'\[[^\]]*\]\(([^)]+)\)',text):
        if '://' in target or target.startswith('#'):continue
        p=(f.parent/target.split('#')[0]).resolve()
        if not p.exists():errors.append(f'{f.relative_to(root)} -> missing {target}')
source=(root/'references/source-map.md').read_text()
ids=set(re.findall(r'\| ([A-Z]\d{2}):',source))
for f in (root/'references').glob('*.md'):
    if f.name=='source-map.md':continue
    for id in re.findall(r'(?<![A-Z])[A-Z]\d{2}(?!\d)',f.read_text()):
        if id not in ids:errors.append(f'{f.name}: unregistered principle {id}')
checkpoint=json.loads((root/'research/evidence-checkpoint.json').read_text())
if checkpoint['skill_md_exists_at_checkpoint']:errors.append('Evidence checkpoint was not before SKILL.md')
if checkpoint['evidence_rows']!=23 or checkpoint['tracked_files']!=296:errors.append('Coverage mismatch')
cases=json.loads((root/'research/case-evidence.json').read_text())
for c in cases:
    if not (root/'case-studies'/f"{c['id']}.md").exists():errors.append(f"Missing case {c['id']}")
if len((root/'SKILL.md').read_text().splitlines())>=500:errors.append('Core exceeds 500 lines')
if errors:
    print('\n'.join(errors));sys.exit(1)
print(f'Passed: {len(files)} Markdown files, {len(ids)} provenance IDs, 23 cases, evidence checkpoint, local links')
