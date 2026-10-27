import { useCallback, useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { getUserSubmissions, getUsers, deleteSubmission } from '@/api/admin';
import type { AdminSubmissionListItem, AdminUser } from '@/types/admin';
import type { SubmissionStatus } from '@/types/submission';
import StatusBadge from '@/components/ui/StatusBadge';
import Spinner from '@/components/ui/Spinner';
import LoadError from '@/components/ui/LoadError';
import { ConfirmDialog } from '@/pages/problem/ConfirmDialog';
import { formatDate } from './adminFormat';

export default function UserSubmissionsPage() {
  const { userId } = useParams<{ userId: string }>();
  const { t, i18n } = useTranslation('admin');
  const { t: tc } = useTranslation('common');

  const [user, setUser] = useState<AdminUser | null>(null);
  const [submissions, setSubmissions] = useState<AdminSubmissionListItem[]>([]);
  const [page, setPage] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const [totalElements, setTotalElements] = useState(0);
  const [status, setStatus] = useState<'loading' | 'ready' | 'failed'>('loading');
  const [deletingId, setDeletingId] = useState<number | null>(null);
  const [pendingDelete, setPendingDelete] = useState<number | null>(null);
  // Separate from the target, so the dialog keeps its title while it animates closed.
  const [deleteOpen, setDeleteOpen] = useState(false);
  const [deleteError, setDeleteError] = useState<string | null>(null);

  const uid = Number(userId);

  useEffect(() => {
    getUsers(0, 50)
      .then((res) => {
        const found = res.data.content.find((u) => u.id === uid);
        if (found) setUser(found);
      })
      // eslint-disable-next-line no-restricted-syntax -- The name is only for the heading; "#id" stands in if this fails, and the submissions below show their own error.
      .catch(() => {});
  }, [uid]);

  // The page the rows on screen belong to; while it differs the old rows stay, dimmed and busy.
  const [shownPage, setShownPage] = useState<number | null>(null);

  const fetchSubmissions = useCallback(() => {
    getUserSubmissions(uid, page, 20)
      .then((res) => {
        setShownPage(page);
        setSubmissions(res.data.content);
        setTotalPages(res.data.totalPages);
        setTotalElements(res.data.totalElements);
        setStatus('ready');
      })
      .catch(() => setStatus('failed'));
  }, [uid, page]);

  useEffect(fetchSubmissions, [fetchSubmissions]);

  const retry = () => {
    setStatus('loading');
    fetchSubmissions();
  };

  const confirmDelete = async () => {
    const id = pendingDelete;
    setDeleteOpen(false);
    if (id == null) return;
    setDeletingId(id);
    setDeleteError(null);
    try {
      await deleteSubmission(id);
      setSubmissions((prev) => prev.filter((s) => s.id !== id));
      setTotalElements((n) => n - 1);
    } catch {
      setDeleteError(t('submissions.deleteFailed'));
    } finally {
      setDeletingId(null);
    }
  };

  if (status === 'loading' && submissions.length === 0) {
    return (
      <div className="flex h-full items-center justify-center">
        <Spinner />
      </div>
    );
  }

  return (
    <div className="space-y-4 p-6">
      {/* Breadcrumb */}
      <div className="flex items-center gap-2 text-sm text-muted-foreground">
        <Link to="/admin/users" className="hover:text-foreground transition-colors">
          {t('users.heading')}
        </Link>
        <span aria-hidden>/</span>
        <span className="text-foreground font-medium">
          {user ? user.username : `#${uid}`}
        </span>
      </div>

      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-foreground">
            {t('submissions.heading', { username: user?.username ?? `#${uid}` })}
          </h1>
          <p className="mt-0.5 text-sm text-muted-foreground">
            {t('submissions.total', { count: totalElements })}
          </p>
        </div>
      </div>

      {deleteError && (
        <p role="alert" className="text-sm text-error-700 dark:text-error-400">
          {deleteError}
        </p>
      )}

      {status === 'failed' ? (
        <LoadError onRetry={retry} />
      ) : (
      <div className="overflow-auto rounded-xl border border-border bg-card">
        <table aria-busy={shownPage !== page} className="w-full text-sm transition-opacity aria-busy:opacity-60">
          <thead>
            <tr className="border-b border-border text-left text-xs text-muted-foreground">
              <th scope="col" className="px-4 py-3">{t('submissions.id')}</th>
              <th scope="col" className="px-4 py-3">{t('submissions.status')}</th>
              <th scope="col" className="px-4 py-3">{t('submissions.language')}</th>
              <th scope="col" className="px-4 py-3">{t('submissions.runtime')}</th>
              <th scope="col" className="px-4 py-3">{t('submissions.submittedAt')}</th>
              <th scope="col" className="px-4 py-3"><span className="sr-only">{t('problems.actions')}</span></th>
            </tr>
          </thead>
          <tbody>
            {submissions.length === 0 ? (
              <tr>
                <td colSpan={6} className="px-4 py-8 text-center text-muted-foreground">
                  {t('submissions.empty')}
                </td>
              </tr>
            ) : (
              submissions.map((s) => (
                <tr key={s.id} className="border-b border-border/50 last:border-0">
                  <td className="px-4 py-3 tabular-nums text-muted-foreground">#{s.id}</td>
                  <td className="px-4 py-3">
                    <StatusBadge status={s.status as SubmissionStatus} />
                  </td>
                  <td className="px-4 py-3 font-mono text-foreground">{s.language}</td>
                  <td className="px-4 py-3 text-muted-foreground">
                    {s.runtimeMs != null ? `${s.runtimeMs} ms` : '—'}
                  </td>
                  <td className="px-4 py-3 text-muted-foreground">{formatDate(s.createdAt, i18n.language, true)}</td>
                  <td className="px-4 py-3 text-right">
                    <button
                      type="button"
                      onClick={() => {
                        setPendingDelete(s.id);
                        setDeleteOpen(true);
                      }}
                      disabled={deletingId === s.id}
                      className="rounded-md px-2.5 py-1 text-xs text-error-700 border border-destructive/30 transition-colors hover:bg-destructive/10 disabled:opacity-40 dark:text-error-400"
                    >
                      {deletingId === s.id ? t('submissions.deleting') : t('submissions.delete')}
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
      )}

      <ConfirmDialog
        open={deleteOpen}
        title={t('submissions.confirmDeleteTitle', { id: pendingDelete ?? '' })}
        description={t('submissions.confirmDeleteBody')}
        confirmLabel={t('submissions.delete')}
        onConfirm={confirmDelete}
        onCancel={() => setDeleteOpen(false)}
      />

      {status !== 'failed' && totalPages > 1 && (
        <div className="flex items-center justify-center gap-2">
          <button
            onClick={() => setPage((p) => Math.max(0, p - 1))}
            disabled={page === 0}
            className="rounded-md border border-border px-3 py-1.5 text-sm text-foreground transition-colors hover:bg-muted disabled:opacity-40"
          >
            {tc('button.previous')}
          </button>
          <span className="text-sm text-muted-foreground">
            {tc('pagination.pageOf', { current: page + 1, total: totalPages })}
          </span>
          <button
            onClick={() => setPage((p) => Math.min(totalPages - 1, p + 1))}
            disabled={page >= totalPages - 1}
            className="rounded-md border border-border px-3 py-1.5 text-sm text-foreground transition-colors hover:bg-muted disabled:opacity-40"
          >
            {tc('button.next')}
          </button>
        </div>
      )}
    </div>
  );
}
