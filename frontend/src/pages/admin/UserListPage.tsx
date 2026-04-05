import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { getUsers } from '@/api/admin';
import type { AdminUser } from '@/types/admin';
import Spinner from '@/components/ui/Spinner';
import { Badge } from '@/components/ui/Badge';

function formatDate(dateStr: string | null) {
  if (!dateStr) return '—';
  return new Date(dateStr).toLocaleDateString(undefined, {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  });
}

function timeAgo(dateStr: string | null) {
  if (!dateStr) return '—';
  const diff = Date.now() - new Date(dateStr).getTime();
  const mins = Math.floor(diff / 60000);
  if (mins < 1) return 'just now';
  if (mins < 60) return `${mins}m ago`;
  const hrs = Math.floor(mins / 60);
  if (hrs < 24) return `${hrs}h ago`;
  const days = Math.floor(hrs / 24);
  if (days < 30) return `${days}d ago`;
  return formatDate(dateStr);
}

export default function UserListPage() {
  const { t } = useTranslation('admin');
  const { t: tc } = useTranslation('common');
  const [users, setUsers] = useState<AdminUser[]>([]);
  const [page, setPage] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const [totalElements, setTotalElements] = useState(0);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    getUsers(page, 50)
      .then((res) => {
        setUsers(res.data.content);
        setTotalPages(res.data.totalPages);
        setTotalElements(res.data.totalElements);
      })
      .finally(() => setLoading(false));
  }, [page]);

  if (loading && users.length === 0) {
    return (
      <div className="flex h-full items-center justify-center">
        <Spinner />
      </div>
    );
  }

  return (
    <div className="space-y-4 p-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-foreground">{t('users.heading')}</h1>
        <span className="text-sm text-muted-foreground">{t('users.total', { count: totalElements })}</span>
      </div>

      <div className="overflow-auto rounded-xl border border-border bg-card">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border text-left text-xs text-muted-foreground">
              <th className="px-4 py-3">{t('users.user')}</th>
              <th className="px-4 py-3">{t('users.role')}</th>
              <th className="px-4 py-3">{t('users.solved')}</th>
              <th className="px-4 py-3">{t('users.lastActive')}</th>
              <th className="px-4 py-3">{t('users.joined')}</th>
            </tr>
          </thead>
          <tbody>
            {users.map((u) => (
              <tr key={u.id} className="border-b border-border/50 last:border-0">
                <td className="px-4 py-3">
                  <div className="flex items-center gap-3">
                    {u.avatarUrl ? (
                      <img
                        src={u.avatarUrl}
                        alt=""
                        className="h-8 w-8 rounded-full"
                      />
                    ) : (
                      <div className="flex h-8 w-8 items-center justify-center rounded-full bg-muted text-xs font-medium text-muted-foreground">
                        {u.username.charAt(0).toUpperCase()}
                      </div>
                    )}
                    <div>
                      <p className="font-medium text-foreground">{u.username}</p>
                      <p className="text-xs text-muted-foreground">{u.email}</p>
                    </div>
                  </div>
                </td>
                <td className="px-4 py-3">
                  <Badge variant={u.role === 'ADMIN' ? 'default' : 'secondary'}>
                    {u.role}
                  </Badge>
                </td>
                <td className="px-4 py-3 text-foreground">{u.solvedCount}</td>
                <td className="px-4 py-3 text-muted-foreground">{timeAgo(u.lastActiveAt)}</td>
                <td className="px-4 py-3 text-muted-foreground">{formatDate(u.createdAt)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Pagination */}
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
