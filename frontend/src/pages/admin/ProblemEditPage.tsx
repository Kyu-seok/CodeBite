import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { Badge } from '@/components/ui/Badge';
import {
  getProblem,
  createProblem,
  updateProblem,
  getTestCases,
  addTestCase,
  updateTestCase,
  deleteTestCase,
  listTags,
  getProblemTags,
  updateProblemTags,
} from '@/api/admin';
import type { TestCaseDto, TagDto, CreateTestCaseRequest } from '@/types/admin';
import type { Difficulty } from '@/types/problem';

const DIFFICULTIES: Difficulty[] = ['EASY', 'MEDIUM', 'HARD'];

export default function ProblemEditPage() {
  const { t } = useTranslation('admin');
  const { t: tc } = useTranslation('common');
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const isNew = id === 'new';

  // Problem form
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [difficulty, setDifficulty] = useState<Difficulty>('EASY');
  const [constraints, setConstraints] = useState('');
  const [published, setPublished] = useState(false);
  const [saving, setSaving] = useState(false);
  const [loading, setLoading] = useState(!isNew);

  // Test cases
  const [testCases, setTestCases] = useState<TestCaseDto[]>([]);
  const [editingTc, setEditingTc] = useState<Partial<CreateTestCaseRequest & { id?: number }> | null>(null);

  // Tags
  const [allTags, setAllTags] = useState<TagDto[]>([]);
  const [selectedTagIds, setSelectedTagIds] = useState<Set<number>>(new Set());

  useEffect(() => {
    if (!isNew) {
      const problemId = Number(id);
      Promise.all([
        getProblem(problemId),
        getTestCases(problemId),
        listTags(),
        getProblemTags(problemId),
      ]).then(([probRes, tcRes, tagsRes, problemTagsRes]) => {
        const p = probRes.data;
        setTitle(p.title);
        setDescription(p.description);
        setDifficulty(p.difficulty);
        setConstraints(p.constraints || '');
        setPublished(p.published);
        setTestCases(tcRes.data);
        setAllTags(tagsRes.data);

        // Match tag names to IDs
        const tagNames = new Set(problemTagsRes.data);
        setSelectedTagIds(new Set(
          tagsRes.data.filter((t) => tagNames.has(t.name)).map((t) => t.id)
        ));
      }).catch(() => {})
        .finally(() => setLoading(false));
    } else {
      listTags().then((res) => setAllTags(res.data)).catch(() => {});
    }
  }, [id, isNew]);

  const handleSave = async () => {
    setSaving(true);
    try {
      if (isNew) {
        const res = await createProblem({ title, description, difficulty, constraints: constraints || undefined, published });
        // Update tags
        if (selectedTagIds.size > 0) {
          await updateProblemTags(res.data.id, Array.from(selectedTagIds));
        }
        navigate(`/admin/problems/${res.data.id}`, { replace: true });
      } else {
        await updateProblem(Number(id), { title, description, difficulty, constraints: constraints || undefined, published });
        await updateProblemTags(Number(id), Array.from(selectedTagIds));
      }
    } catch {
      // ignore
    } finally {
      setSaving(false);
    }
  };

  const handleAddTestCase = async () => {
    if (!editingTc || !editingTc.input || !editingTc.expectedOutput) return;
    const problemId = Number(id);
    try {
      if (editingTc.id) {
        const res = await updateTestCase(problemId, editingTc.id, {
          input: editingTc.input,
          expectedOutput: editingTc.expectedOutput,
          sample: editingTc.sample,
          orderIndex: editingTc.orderIndex,
        });
        setTestCases((prev) => prev.map((tc) => (tc.id === editingTc.id ? res.data : tc)));
      } else {
        const res = await addTestCase(problemId, {
          input: editingTc.input,
          expectedOutput: editingTc.expectedOutput,
          sample: editingTc.sample,
          orderIndex: editingTc.orderIndex,
        });
        setTestCases((prev) => [...prev, res.data]);
      }
      setEditingTc(null);
    } catch {
      // ignore
    }
  };

  const handleDeleteTestCase = async (tcId: number) => {
    if (!confirm('Delete this test case?')) return;
    try {
      await deleteTestCase(Number(id), tcId);
      setTestCases((prev) => prev.filter((tc) => tc.id !== tcId));
    } catch {
      // ignore
    }
  };

  const toggleTag = (tagId: number) => {
    setSelectedTagIds((prev) => {
      const next = new Set(prev);
      if (next.has(tagId)) next.delete(tagId);
      else next.add(tagId);
      return next;
    });
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-20">
        <div className="h-5 w-5 animate-spin rounded-full border-2 border-muted border-t-accent" />
      </div>
    );
  }

  return (
    <div className="p-6">
      {/* Header */}
      <div className="mb-6 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <button
            onClick={() => navigate('/admin/problems')}
            className="text-muted-foreground hover:text-foreground transition-colors"
          >
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M19 12H5" />
              <path d="m12 19-7-7 7-7" />
            </svg>
          </button>
          <h1 className="text-xl font-bold text-foreground">
            {isNew ? t('edit.newProblem') : t('edit.editProblem')}
          </h1>
          {!isNew && (
            <Badge variant={published ? 'success' : 'secondary'} className="text-[10px]">
              {published ? t('edit.published') : t('edit.draft')}
            </Badge>
          )}
        </div>
        <Button onClick={handleSave} disabled={saving || !title || !description}>
          {saving ? t('edit.saving') : t('edit.save')}
        </Button>
      </div>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
        {/* Main form */}
        <div className="lg:col-span-2 space-y-4">
          <div>
            <label className="mb-1 block text-xs font-medium text-muted-foreground">{t('edit.title')}</label>
            <Input value={title} onChange={(e) => setTitle(e.target.value)} placeholder={t('edit.titlePlaceholder')} />
          </div>

          <div>
            <label className="mb-1 block text-xs font-medium text-muted-foreground">{t('edit.description')}</label>
            <textarea
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              rows={12}
              placeholder={t('edit.descriptionPlaceholder')}
              className="w-full resize-y rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground font-mono placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
            />
          </div>

          <div>
            <label className="mb-1 block text-xs font-medium text-muted-foreground">{t('edit.constraints')}</label>
            <textarea
              value={constraints}
              onChange={(e) => setConstraints(e.target.value)}
              rows={3}
              placeholder={t('edit.constraintsPlaceholder')}
              className="w-full resize-y rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground font-mono placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
            />
          </div>

          {/* Test cases (only for existing problems) */}
          {!isNew && (
            <div>
              <div className="mb-2 flex items-center justify-between">
                <label className="text-xs font-medium text-muted-foreground">
                  {t('edit.testCases', { count: testCases.length })}
                </label>
                <button
                  onClick={() => setEditingTc({ input: '', expectedOutput: '', sample: false, orderIndex: testCases.length })}
                  className="text-xs text-accent hover:text-accent/80 transition-colors"
                >
                  + {t('edit.addTestCase')}
                </button>
              </div>

              <div className="space-y-2">
                {testCases.map((testCase) => (
                  <div key={testCase.id} className="rounded-lg border border-border p-3">
                    <div className="flex items-center justify-between mb-2">
                      <div className="flex items-center gap-2">
                        <span className="text-xs font-medium text-foreground">#{testCase.orderIndex}</span>
                        {testCase.sample && (
                          <Badge variant="outline" className="text-[10px]">{t('edit.sample')}</Badge>
                        )}
                      </div>
                      <div className="flex gap-1">
                        <button
                          onClick={() => setEditingTc({
                            id: testCase.id,
                            input: testCase.input,
                            expectedOutput: testCase.expectedOutput,
                            sample: testCase.sample,
                            orderIndex: testCase.orderIndex,
                          })}
                          className="rounded px-2 py-0.5 text-xs text-muted-foreground hover:text-foreground hover:bg-muted transition-colors"
                        >
                          {tc('button.edit')}
                        </button>
                        <button
                          onClick={() => handleDeleteTestCase(testCase.id)}
                          className="rounded px-2 py-0.5 text-xs text-destructive hover:bg-destructive/10 transition-colors"
                        >
                          {tc('button.delete')}
                        </button>
                      </div>
                    </div>
                    <div className="grid grid-cols-2 gap-2 text-xs">
                      <div>
                        <span className="text-muted-foreground">{t('edit.input')}:</span>
                        <pre className="mt-0.5 rounded bg-muted px-2 py-1 text-foreground whitespace-pre-wrap break-all">
                          {testCase.input}
                        </pre>
                      </div>
                      <div>
                        <span className="text-muted-foreground">{t('edit.expected')}:</span>
                        <pre className="mt-0.5 rounded bg-muted px-2 py-1 text-foreground whitespace-pre-wrap break-all">
                          {testCase.expectedOutput}
                        </pre>
                      </div>
                    </div>
                  </div>
                ))}
              </div>

              {/* Add/Edit test case form */}
              {editingTc && (
                <div className="mt-3 rounded-lg border border-accent/30 bg-accent/5 p-3 space-y-2">
                  <div className="grid grid-cols-2 gap-2">
                    <div>
                      <label className="mb-0.5 block text-xs text-muted-foreground">{t('edit.inputLabel')}</label>
                      <textarea
                        value={editingTc.input || ''}
                        onChange={(e) => setEditingTc({ ...editingTc, input: e.target.value })}
                        rows={3}
                        className="w-full resize-y rounded-md border border-border bg-background px-2 py-1.5 text-xs font-mono text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
                      />
                    </div>
                    <div>
                      <label className="mb-0.5 block text-xs text-muted-foreground">{t('edit.expectedOutputLabel')}</label>
                      <textarea
                        value={editingTc.expectedOutput || ''}
                        onChange={(e) => setEditingTc({ ...editingTc, expectedOutput: e.target.value })}
                        rows={3}
                        className="w-full resize-y rounded-md border border-border bg-background px-2 py-1.5 text-xs font-mono text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
                      />
                    </div>
                  </div>
                  <div className="flex items-center gap-4">
                    <label className="flex items-center gap-1.5 text-xs text-muted-foreground">
                      <input
                        type="checkbox"
                        checked={editingTc.sample || false}
                        onChange={(e) => setEditingTc({ ...editingTc, sample: e.target.checked })}
                        className="rounded"
                      />
                      {t('edit.sampleVisible')}
                    </label>
                    <div className="flex items-center gap-1.5">
                      <label className="text-xs text-muted-foreground">{t('edit.order')}:</label>
                      <input
                        type="number"
                        value={editingTc.orderIndex ?? 0}
                        onChange={(e) => setEditingTc({ ...editingTc, orderIndex: Number(e.target.value) })}
                        className="w-16 rounded-md border border-border bg-background px-2 py-1 text-xs text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
                      />
                    </div>
                  </div>
                  <div className="flex justify-end gap-2">
                    <button
                      onClick={() => setEditingTc(null)}
                      className="rounded px-3 py-1 text-xs text-muted-foreground hover:text-foreground transition-colors"
                    >
                      {tc('button.cancel')}
                    </button>
                    <button
                      onClick={handleAddTestCase}
                      disabled={!editingTc.input || !editingTc.expectedOutput}
                      className="rounded bg-accent px-3 py-1 text-xs font-medium text-white hover:bg-accent/90 transition-colors disabled:opacity-50"
                    >
                      {editingTc.id ? tc('button.update') : tc('button.add')}
                    </button>
                  </div>
                </div>
              )}
            </div>
          )}
        </div>

        {/* Sidebar */}
        <div className="space-y-4">
          <div className="rounded-lg border border-border p-4">
            <label className="mb-2 block text-xs font-medium text-muted-foreground">{t('edit.difficulty')}</label>
            <div className="flex gap-2">
              {DIFFICULTIES.map((d) => (
                <button
                  key={d}
                  onClick={() => setDifficulty(d)}
                  className={`flex-1 rounded-md px-2 py-1.5 text-xs font-medium transition-colors ${
                    difficulty === d
                      ? d === 'EASY'
                        ? 'bg-success/10 text-success-500 ring-1 ring-success'
                        : d === 'MEDIUM'
                          ? 'bg-warning/10 text-warning-500 ring-1 ring-warning'
                          : 'bg-destructive/10 text-destructive ring-1 ring-destructive'
                      : 'bg-muted text-muted-foreground hover:text-foreground'
                  }`}
                >
                  {d}
                </button>
              ))}
            </div>
          </div>

          <div className="rounded-lg border border-border p-4">
            <label className="mb-2 block text-xs font-medium text-muted-foreground">{t('edit.visibility')}</label>
            <label className="flex items-center gap-2 text-sm text-foreground cursor-pointer">
              <input
                type="checkbox"
                checked={published}
                onChange={(e) => setPublished(e.target.checked)}
                className="rounded"
              />
              {t('edit.published')}
            </label>
            <p className="mt-1 text-[11px] text-muted-foreground">
              {published ? t('edit.visibleToAll') : t('edit.adminOnly')}
            </p>
          </div>

          <div className="rounded-lg border border-border p-4">
            <label className="mb-2 block text-xs font-medium text-muted-foreground">
              {t('edit.tagsSelected', { count: selectedTagIds.size })}
            </label>
            <div className="flex flex-wrap gap-1.5">
              {allTags.map((tag) => (
                <button
                  key={tag.id}
                  onClick={() => toggleTag(tag.id)}
                  className={`rounded-md px-2 py-1 text-xs transition-colors ${
                    selectedTagIds.has(tag.id)
                      ? 'bg-accent/10 text-accent ring-1 ring-accent/30'
                      : 'bg-muted text-muted-foreground hover:text-foreground'
                  }`}
                >
                  {tag.name}
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
