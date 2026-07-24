import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { getUserSubmissions, getUsers, deleteSubmission } from '@/api/admin';
import type { AdminSubmissionListItem, AdminUser } from '@/types/admin';
import type { SubmissionStatus } from '@/types/submission';
import StatusBadge from '@/components/ui/StatusBadge';
import Spinner from '@/components/ui/Spinner';

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleString(undefined, {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
}

export default function UserSubmissionsPage() {
  const { userId } = useParams<{ userId: string }>();
  const { t } = useTranslation('admin');
  const { t: tc } = useTranslation('common');

  const [user, setUser] = useState<AdminUser | null>(null);
  const [submissions, setSubmissions] = useState<AdminSubmissionListItem[]>([]);
  const [page, setPage] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const [totalElements, setTotalElements] = useState(0);
  const [loading, setLoading] = useState(true);
  const [deletingId, setDeletingId] = useState<number | null>(null);

  const uid = Number(userId);

  useEffect(() => {
    getUsers(0, 50).then((res) => {
      const found = res.data.content.find((u) => u.id === uid);
      if (found) setUser(found);
    });
  }, [uid]);

  useEffect(() => {
    setLoading(true);
    getUserSubmissions(uid, page, 20)
      .then((res) => {
        setSubmissions(res.data.content);
        setTotalPages(res.data.totalPages);
        setTotalElements(res.data.totalElements);
      })
      .finally(() => setLoading(false));
  }, [uid, page]);

  const handleDelete = async (id: number) => {
    if (!window.confirm(t('submissions.confirmDelete'))) return;
    setDeletingId(id);
    try {
      await deleteSubmission(id);
      setSubmissions((prev) => prev.filter((s) => s.id !== id));
      setTotalElements((n) => n - 1);
    } finally {
      setDeletingId(null);
    }
  };

  if (loading && submissions.length === 0) {
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
        <span>/</span>
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

      <div className="overflow-auto rounded-xl border border-border bg-card">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border text-left text-xs text-muted-foreground">
              <th className="px-4 py-3">ID</th>
              <th className="px-4 py-3">{t('submissions.status')}</th>
              <th className="px-4 py-3">{t('submissions.language')}</th>
              <th className="px-4 py-3">{t('submissions.runtime')}</th>
              <th className="px-4 py-3">{t('submissions.submittedAt')}</th>
              <th className="px-4 py-3"></th>
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
                  <td className="px-4 py-3 text-muted-foreground">#{s.id}</td>
                  <td className="px-4 py-3">
                    <StatusBadge status={s.status as SubmissionStatus} />
                  </td>
                  <td className="px-4 py-3 font-mono text-foreground">{s.language}</td>
                  <td className="px-4 py-3 text-muted-foreground">
                    {s.runtimeMs != null ? `${s.runtimeMs} ms` : '—'}
                  </td>
                  <td className="px-4 py-3 text-muted-foreground">{formatDate(s.createdAt)}</td>
                  <td className="px-4 py-3 text-right">
                    <button
                      onClick={() => handleDelete(s.id)}
                      disabled={deletingId === s.id}
                      className="rounded-md px-2.5 py-1 text-xs text-destructive border border-destructive/30 transition-colors hover:bg-destructive/10 disabled:opacity-40"
                    >
                      {deletingId === s.id ? tc('button.deleting') : t('submissions.delete')}
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {totalPages > 1 && (
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
