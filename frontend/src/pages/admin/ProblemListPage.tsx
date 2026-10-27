import { useState, useEffect, useCallback } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { Badge } from '@/components/ui/Badge';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import DifficultyBadge from '@/components/ui/DifficultyBadge';
import Spinner from '@/components/ui/Spinner';
import LoadError from '@/components/ui/LoadError';
import { ConfirmDialog } from '@/pages/problem/ConfirmDialog';
import { listProblems, deleteProblem } from '@/api/admin';
import type { AdminProblemListItem } from '@/types/admin';
import type { Difficulty } from '@/types/problem';

export default function AdminProblemListPage() {
  const { t } = useTranslation('admin');
  const navigate = useNavigate();
  const [problems, setProblems] = useState<AdminProblemListItem[]>([]);
  const [totalElements, setTotalElements] = useState(0);
  const [page, setPage] = useState(0);
  const [search, setSearch] = useState('');
  const [status, setStatus] = useState<'loading' | 'ready' | 'failed'>('loading');
  const [pendingDelete, setPendingDelete] = useState<AdminProblemListItem | null>(null);
  const [deleteError, setDeleteError] = useState<string | null>(null);

  const fetchProblems = useCallback(() => {
    listProblems({ page, size: 50, search: search || undefined })
      .then((res) => {
        setProblems(res.data.content);
        setTotalElements(res.data.totalElements);
        setStatus('ready');
      })
      .catch(() => setStatus('failed'));
  }, [page, search]);

  useEffect(fetchProblems, [fetchProblems]);

  const retry = () => {
    setStatus('loading');
    fetchProblems();
  };

  const confirmDelete = async () => {
    const target = pendingDelete;
    setPendingDelete(null);
    if (!target) return;
    setDeleteError(null);
    try {
      await deleteProblem(target.id);
      fetchProblems();
    } catch {
      setDeleteError(t('problems.deleteFailed'));
    }
  };

  return (
    <div className="p-6">
      <div className="mb-6 flex items-center justify-between">
        <div>
          <h1 className="text-xl font-bold text-foreground">{t('problems.heading')}</h1>
          <p className="text-sm text-muted-foreground">{t('problems.total', { count: totalElements })}</p>
        </div>
        <Button onClick={() => navigate('/admin/problems/new')}>
          + {t('problems.newProblem')}
        </Button>
      </div>

      <div className="mb-4">
        <Input
          aria-label={t('problems.search')}
          placeholder={t('problems.search')}
          value={search}
          onChange={(e) => {
            setSearch(e.target.value);
            setPage(0);
          }}
          className="max-w-sm"
        />
      </div>

      {deleteError && (
        <p role="alert" className="mb-3 text-sm text-error-700 dark:text-error-400">
          {deleteError}
        </p>
      )}

      {status === 'loading' ? (
        <Spinner size="sm" />
      ) : status === 'failed' ? (
        <LoadError onRetry={retry} />
      ) : problems.length === 0 ? (
        <div className="py-12 text-center text-sm text-muted-foreground">
          {t('problems.noProblems')}
        </div>
      ) : (
        <div className="overflow-auto rounded-lg border border-border">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border bg-muted/50 text-left text-xs text-muted-foreground">
                <th scope="col" className="px-4 py-2.5 font-medium w-12">{t('problems.id')}</th>
                <th scope="col" className="px-4 py-2.5 font-medium">{t('problems.title')}</th>
                <th scope="col" className="px-4 py-2.5 font-medium w-24">{t('problems.difficulty')}</th>
                <th scope="col" className="px-4 py-2.5 font-medium w-20">{t('problems.status')}</th>
                <th scope="col" className="px-4 py-2.5 font-medium w-24">{t('problems.accepted')}</th>
                <th scope="col" className="px-4 py-2.5 font-medium w-28">{t('problems.tags')}</th>
                <th scope="col" className="px-4 py-2.5 font-medium w-24 text-right">{t('problems.actions')}</th>
              </tr>
            </thead>
            <tbody>
              {problems.map((p) => (
                <tr
                  key={p.id}
                  className="border-b border-border/50 last:border-0 hover:bg-muted/30 transition-colors cursor-pointer"
                  // The title link is the keyboard path; the row click is a pointer shortcut to it.
                  onClick={() => navigate(`/admin/problems/${p.id}`)}
                >
                  <td className="px-4 py-2.5 tabular-nums text-muted-foreground">{p.problemNumber ?? p.id}</td>
                  <td className="px-4 py-2.5">
                    <Link
                      to={`/admin/problems/${p.id}`}
                      onClick={(e) => e.stopPropagation()}
                      className="rounded-sm font-medium text-foreground hover:underline focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                    >
                      {p.title}
                    </Link>
                    <span className="ml-2 text-xs text-muted-foreground">/{p.slug}</span>
                  </td>
                  <td className="px-4 py-2.5">
                    <DifficultyBadge difficulty={p.difficulty as Difficulty} />
                  </td>
                  <td className="px-4 py-2.5">
                    <Badge variant={p.status === 'ACCEPTED' ? 'success' : 'secondary'}>
                      {p.status === 'ACCEPTED' ? t('problems.accepted') : t('problems.draft')}
                    </Badge>
                  </td>
                  <td className="px-4 py-2.5 tabular-nums text-muted-foreground">
                    {p.acceptanceRate != null ? `${p.acceptanceRate}%` : '—'}
                  </td>
                  <td className="px-4 py-2.5">
                    <div className="flex flex-wrap gap-1">
                      {p.tags.slice(0, 2).map((tag) => (
                        <span key={tag} className="rounded bg-muted px-1.5 py-0.5 text-xs text-secondary-foreground">
                          {tag}
                        </span>
                      ))}
                      {p.tags.length > 2 && (
                        <span className="text-xs text-muted-foreground">+{p.tags.length - 2}</span>
                      )}
                    </div>
                  </td>
                  <td className="px-4 py-2.5 text-right">
                    <div className="flex justify-end gap-1" onClick={(e) => e.stopPropagation()}>
                      <Link
                        to={`/problems/${p.slug}`}
                        className="rounded px-2 py-1 text-xs text-muted-foreground hover:text-foreground hover:bg-muted transition-colors"
                      >
                        {t('problems.view')}
                      </Link>
                      <button
                        type="button"
                        onClick={() => setPendingDelete(p)}
                        className="rounded px-2 py-1 text-xs text-error-700 hover:bg-destructive/10 transition-colors dark:text-error-400"
                      >
                        {t('problems.delete')}
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      <ConfirmDialog
        open={pendingDelete !== null}
        title={t('problems.confirmDeleteTitle', { title: pendingDelete?.title ?? '' })}
        description={t('problems.confirmDeleteBody')}
        confirmLabel={t('problems.delete')}
        onConfirm={confirmDelete}
        onCancel={() => setPendingDelete(null)}
      />
    </div>
  );
}
