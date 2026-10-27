import { useState, useEffect, useCallback, useId } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { ArrowLeft } from 'lucide-react';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { Badge } from '@/components/ui/Badge';
import Spinner from '@/components/ui/Spinner';
import LoadError from '@/components/ui/LoadError';
import { ConfirmDialog } from '@/pages/problem/ConfirmDialog';
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
import { cn } from '@/lib/utils';

const DIFFICULTIES: Difficulty[] = ['EASY', 'MEDIUM', 'HARD'];

// Selected difficulty uses the Wash-and-Text pair DifficultyBadge uses (700 on paper, 400 on night).
const DIFFICULTY_SELECTED: Record<Difficulty, string> = {
  EASY: 'bg-success-500/15 text-success-700 ring-1 ring-success-700/40 dark:text-success-400 dark:ring-success-400/40',
  MEDIUM: 'bg-warning-500/15 text-warning-700 ring-1 ring-warning-700/40 dark:text-warning-400 dark:ring-warning-400/40',
  HARD: 'bg-error-500/15 text-error-700 ring-1 ring-error-700/40 dark:text-error-400 dark:ring-error-400/40',
};

const DIFFICULTY_KEY: Record<Difficulty, string> = {
  EASY: 'difficulty.easy',
  MEDIUM: 'difficulty.medium',
  HARD: 'difficulty.hard',
};

const fieldClass =
  'w-full resize-y rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground font-mono placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring';

export default function ProblemEditPage() {
  const { t } = useTranslation('admin');
  const { t: tc } = useTranslation('common');
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const isNew = id === 'new';
  const ids = useId();

  // Problem form
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [difficulty, setDifficulty] = useState<Difficulty>('EASY');
  const [constraints, setConstraints] = useState('');
  const [published, setPublished] = useState(false);
  const [saving, setSaving] = useState(false);
  const [saveState, setSaveState] = useState<'idle' | 'saved' | 'failed'>('idle');
  const [status, setStatus] = useState<'loading' | 'ready' | 'failed'>(isNew ? 'ready' : 'loading');

  // Test cases
  const [testCases, setTestCases] = useState<TestCaseDto[]>([]);
  const [editingTc, setEditingTc] = useState<Partial<CreateTestCaseRequest & { id?: number }> | null>(null);
  const [pendingDeleteTc, setPendingDeleteTc] = useState<TestCaseDto | null>(null);
  const [testCaseError, setTestCaseError] = useState<string | null>(null);

  // Tags
  const [allTags, setAllTags] = useState<TagDto[]>([]);
  const [selectedTagIds, setSelectedTagIds] = useState<Set<number>>(new Set());

  const fetchProblem = useCallback(() => {
    if (isNew) {
      listTags().then((res) => setAllTags(res.data)).catch(() => {});
      return;
    }
    const problemId = Number(id);
    Promise.all([
      getProblem(problemId),
      getTestCases(problemId),
      listTags(),
      getProblemTags(problemId),
    ])
      .then(([probRes, tcRes, tagsRes, problemTagsRes]) => {
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
          tagsRes.data.filter((tag) => tagNames.has(tag.name)).map((tag) => tag.id)
        ));
        setStatus('ready');
      })
      // A failed load must not leave an empty form whose Save would overwrite the real problem.
      .catch(() => setStatus('failed'));
  }, [id, isNew]);

  useEffect(fetchProblem, [fetchProblem]);

  const retry = () => {
    setStatus('loading');
    fetchProblem();
  };

  const handleSave = async () => {
    setSaving(true);
    setSaveState('idle');
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
        setSaveState('saved');
      }
    } catch {
      setSaveState('failed');
    } finally {
      setSaving(false);
    }
  };

  const handleAddTestCase = async () => {
    if (!editingTc || !editingTc.input || !editingTc.expectedOutput) return;
    const problemId = Number(id);
    setTestCaseError(null);
    try {
      if (editingTc.id) {
        const res = await updateTestCase(problemId, editingTc.id, {
          input: editingTc.input,
          expectedOutput: editingTc.expectedOutput,
          sample: editingTc.sample,
          orderIndex: editingTc.orderIndex,
        });
        setTestCases((prev) => prev.map((tcase) => (tcase.id === editingTc.id ? res.data : tcase)));
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
      setTestCaseError(t('edit.testCaseFailed'));
    }
  };

  const confirmDeleteTestCase = async () => {
    const target = pendingDeleteTc;
    setPendingDeleteTc(null);
    if (!target) return;
    setTestCaseError(null);
    try {
      await deleteTestCase(Number(id), target.id);
      setTestCases((prev) => prev.filter((tcase) => tcase.id !== target.id));
    } catch {
      setTestCaseError(t('edit.deleteTestCaseFailed'));
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

  if (status === 'loading') return <Spinner />;

  const header = (
    <div className="flex items-center gap-3">
      <button
        type="button"
        onClick={() => navigate('/admin/problems')}
        aria-label={t('edit.back')}
        className="rounded-md p-1 text-muted-foreground transition-colors hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
      >
        <ArrowLeft aria-hidden className="h-5 w-5" />
      </button>
      <h1 className="text-xl font-bold text-foreground">
        {isNew ? t('edit.newProblem') : t('edit.editProblem')}
      </h1>
      {!isNew && status === 'ready' && (
        <Badge variant={published ? 'success' : 'secondary'}>
          {published ? t('edit.published') : t('edit.draft')}
        </Badge>
      )}
    </div>
  );

  if (status === 'failed') {
    return (
      <div className="p-6">
        <div className="mb-6">{header}</div>
        <LoadError onRetry={retry} />
      </div>
    );
  }

  return (
    <div className="p-6">
      {/* Header */}
      <div className="mb-6 flex items-center justify-between gap-3">
        {header}
        <div className="flex items-center gap-3">
          <span role="status" className="text-xs text-muted-foreground">
            {saveState === 'saved' ? t('edit.saved') : ''}
          </span>
          <Button onClick={handleSave} disabled={saving || !title || !description}>
            {saving ? t('edit.saving') : t('edit.save')}
          </Button>
        </div>
      </div>

      {saveState === 'failed' && (
        <p role="alert" className="mb-4 text-sm text-error-700 dark:text-error-400">
          {t('edit.saveFailed')}
        </p>
      )}

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
        {/* Main form */}
        <div className="lg:col-span-2 space-y-4">
          <div>
            <label htmlFor={`${ids}-title`} className="mb-1 block text-xs font-medium text-muted-foreground">
              {t('edit.title')}
            </label>
            <Input
              id={`${ids}-title`}
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder={t('edit.titlePlaceholder')}
            />
          </div>

          <div>
            <label htmlFor={`${ids}-description`} className="mb-1 block text-xs font-medium text-muted-foreground">
              {t('edit.description')}
            </label>
            <textarea
              id={`${ids}-description`}
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              rows={12}
              placeholder={t('edit.descriptionPlaceholder')}
              className={fieldClass}
            />
          </div>

          <div>
            <label htmlFor={`${ids}-constraints`} className="mb-1 block text-xs font-medium text-muted-foreground">
              {t('edit.constraints')}
            </label>
            <textarea
              id={`${ids}-constraints`}
              value={constraints}
              onChange={(e) => setConstraints(e.target.value)}
              rows={3}
              placeholder={t('edit.constraintsPlaceholder')}
              className={fieldClass}
            />
          </div>

          {/* Test cases (only for existing problems) */}
          {!isNew && (
            <section aria-labelledby={`${ids}-testcases`}>
              <div className="mb-2 flex items-center justify-between">
                <h2 id={`${ids}-testcases`} className="text-xs font-medium text-muted-foreground">
                  {t('edit.testCases', { count: testCases.length })}
                </h2>
                <button
                  type="button"
                  onClick={() => setEditingTc({ input: '', expectedOutput: '', sample: false, orderIndex: testCases.length })}
                  className="rounded-sm text-xs text-accent-700 transition-colors hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring dark:text-accent-400"
                >
                  + {t('edit.addTestCase')}
                </button>
              </div>

              {testCaseError && (
                <p role="alert" className="mb-2 text-sm text-error-700 dark:text-error-400">
                  {testCaseError}
                </p>
              )}

              <ul className="space-y-2">
                {testCases.map((testCase) => (
                  <li key={testCase.id} className="rounded-lg border border-border p-3">
                    <div className="flex items-center justify-between mb-2">
                      <div className="flex items-center gap-2">
                        <span className="text-xs font-medium tabular-nums text-foreground">#{testCase.orderIndex}</span>
                        {testCase.sample && (
                          <Badge variant="outline">{t('edit.sample')}</Badge>
                        )}
                      </div>
                      <div className="flex gap-1">
                        <button
                          type="button"
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
                          type="button"
                          onClick={() => setPendingDeleteTc(testCase)}
                          className="rounded px-2 py-0.5 text-xs text-error-700 hover:bg-destructive/10 transition-colors dark:text-error-400"
                        >
                          {tc('button.delete')}
                        </button>
                      </div>
                    </div>
                    <div className="grid grid-cols-2 gap-2 text-xs">
                      <div>
                        <span className="text-muted-foreground">{t('edit.input')}</span>
                        <pre className="mt-0.5 rounded bg-muted px-2 py-1 text-foreground whitespace-pre-wrap break-all">
                          {testCase.input}
                        </pre>
                      </div>
                      <div>
                        <span className="text-muted-foreground">{t('edit.expected')}</span>
                        <pre className="mt-0.5 rounded bg-muted px-2 py-1 text-foreground whitespace-pre-wrap break-all">
                          {testCase.expectedOutput}
                        </pre>
                      </div>
                    </div>
                  </li>
                ))}
              </ul>

              {/* Add/Edit test case form */}
              {editingTc && (
                <div className="mt-3 rounded-lg border border-border bg-muted/30 p-3 space-y-2">
                  <div className="grid grid-cols-2 gap-2">
                    <div>
                      <label htmlFor={`${ids}-tc-input`} className="mb-0.5 block text-xs text-muted-foreground">
                        {t('edit.inputLabel')}
                      </label>
                      <textarea
                        id={`${ids}-tc-input`}
                        value={editingTc.input || ''}
                        onChange={(e) => setEditingTc({ ...editingTc, input: e.target.value })}
                        rows={3}
                        className="w-full resize-y rounded-md border border-border bg-background px-2 py-1.5 text-xs font-mono text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
                      />
                    </div>
                    <div>
                      <label htmlFor={`${ids}-tc-expected`} className="mb-0.5 block text-xs text-muted-foreground">
                        {t('edit.expectedOutputLabel')}
                      </label>
                      <textarea
                        id={`${ids}-tc-expected`}
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
                      <label htmlFor={`${ids}-tc-order`} className="text-xs text-muted-foreground">
                        {t('edit.order')}
                      </label>
                      <input
                        id={`${ids}-tc-order`}
                        type="number"
                        value={editingTc.orderIndex ?? 0}
                        onChange={(e) => setEditingTc({ ...editingTc, orderIndex: Number(e.target.value) })}
                        className="w-16 rounded-md border border-border bg-background px-2 py-1 text-xs text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
                      />
                    </div>
                  </div>
                  <div className="flex justify-end gap-2">
                    <Button variant="ghost" size="sm" onClick={() => setEditingTc(null)}>
                      {tc('button.cancel')}
                    </Button>
                    <Button
                      size="sm"
                      onClick={handleAddTestCase}
                      disabled={!editingTc.input || !editingTc.expectedOutput}
                    >
                      {editingTc.id ? tc('button.update') : tc('button.add')}
                    </Button>
                  </div>
                </div>
              )}
            </section>
          )}
        </div>

        {/* Sidebar */}
        <div className="space-y-4">
          <div className="rounded-lg border border-border p-4">
            <p id={`${ids}-difficulty`} className="mb-2 block text-xs font-medium text-muted-foreground">
              {t('edit.difficulty')}
            </p>
            <div role="group" aria-labelledby={`${ids}-difficulty`} className="flex gap-2">
              {DIFFICULTIES.map((d) => (
                <button
                  key={d}
                  type="button"
                  aria-pressed={difficulty === d}
                  onClick={() => setDifficulty(d)}
                  className={cn(
                    'flex-1 rounded-md px-2 py-1.5 text-xs font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring',
                    difficulty === d
                      ? DIFFICULTY_SELECTED[d]
                      : 'bg-secondary text-secondary-foreground hover:bg-muted',
                  )}
                >
                  {tc(DIFFICULTY_KEY[d])}
                </button>
              ))}
            </div>
          </div>

          <div className="rounded-lg border border-border p-4">
            <p className="mb-2 block text-xs font-medium text-muted-foreground">{t('edit.visibility')}</p>
            <label className="flex items-center gap-2 text-sm text-foreground cursor-pointer">
              <input
                type="checkbox"
                checked={published}
                onChange={(e) => setPublished(e.target.checked)}
                aria-describedby={`${ids}-visibility-hint`}
                className="rounded"
              />
              {t('edit.published')}
            </label>
            <p id={`${ids}-visibility-hint`} className="mt-1 text-xs text-muted-foreground">
              {published ? t('edit.visibleToAll') : t('edit.adminOnly')}
            </p>
          </div>

          <div className="rounded-lg border border-border p-4">
            <p id={`${ids}-tags`} className="mb-2 block text-xs font-medium text-muted-foreground">
              {t('edit.tagsSelected', { count: selectedTagIds.size })}
            </p>
            {/* Selected tags are the documented chip: a solid Ember Orange Text fill (DESIGN.md Chips). */}
            <div role="group" aria-labelledby={`${ids}-tags`} className="flex flex-wrap gap-1.5">
              {allTags.map((tag) => {
                const selected = selectedTagIds.has(tag.id);
                return (
                  <button
                    key={tag.id}
                    type="button"
                    aria-pressed={selected}
                    onClick={() => toggleTag(tag.id)}
                    className={cn(
                      'rounded-full border px-2.5 py-1 text-xs transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring',
                      selected
                        ? 'border-accent-700 bg-accent-700 text-white'
                        : 'border-border bg-secondary text-secondary-foreground hover:bg-muted',
                    )}
                  >
                    {tag.name}
                  </button>
                );
              })}
            </div>
          </div>
        </div>
      </div>

      <ConfirmDialog
        open={pendingDeleteTc !== null}
        title={t('edit.confirmDeleteTestCase', { order: pendingDeleteTc?.orderIndex ?? '' })}
        description={t('edit.confirmDeleteTestCaseBody')}
        confirmLabel={tc('button.delete')}
        onConfirm={confirmDeleteTestCase}
        onCancel={() => setPendingDeleteTc(null)}
      />
    </div>
  );
}
