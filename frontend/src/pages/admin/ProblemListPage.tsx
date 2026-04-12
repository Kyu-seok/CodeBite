import { useState, useEffect, useCallback } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { Badge } from '@/components/ui/Badge';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import DifficultyBadge from '@/components/ui/DifficultyBadge';
import { listProblems, deleteProblem } from '@/api/admin';
import type { AdminProblemListItem } from '@/types/admin';
import type { Difficulty } from '@/types/problem';

export default function AdminProblemListPage() {
  const { t } = useTranslation('admin');
  const { t: tc } = useTranslation('common');
  const navigate = useNavigate();
  const [problems, setProblems] = useState<AdminProblemListItem[]>([]);
  const [totalElements, setTotalElements] = useState(0);
  const [page, setPage] = useState(0);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);

  const fetchProblems = useCallback(() => {
    setLoading(true);
    listProblems({ page, size: 50, search: search || undefined })
      .then((res) => {
        setProblems(res.data.content);
        setTotalElements(res.data.totalElements);
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, [page, search]);

  useEffect(() => {
    fetchProblems();
  }, [fetchProblems]);

  const handleDelete = async (id: number, title: string) => {
    if (!confirm(`Delete "${title}"? This cannot be undone.`)) return;
    try {
      await deleteProblem(id);
      fetchProblems();
    } catch {
      // ignore
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
          placeholder={t('problems.search')}
          value={search}
          onChange={(e) => {
            setSearch(e.target.value);
            setPage(0);
          }}
          className="max-w-sm"
        />
      </div>

      {loading ? (
        <div className="flex justify-center py-12">
          <div className="h-5 w-5 animate-spin rounded-full border-2 border-muted border-t-accent" />
        </div>
      ) : (
        <div className="rounded-lg border border-border overflow-hidden">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border bg-muted/50 text-left text-xs text-muted-foreground">
                <th className="px-4 py-2.5 font-medium w-12">{t('problems.id')}</th>
                <th className="px-4 py-2.5 font-medium">{t('problems.title')}</th>
                <th className="px-4 py-2.5 font-medium w-24">{tc('difficulty.easy').replace(/./, '') && 'Difficulty'}</th>
                <th className="px-4 py-2.5 font-medium w-20">{t('problems.status')}</th>
                <th className="px-4 py-2.5 font-medium w-24">{t('problems.accepted')}</th>
                <th className="px-4 py-2.5 font-medium w-28">{t('problems.tags')}</th>
                <th className="px-4 py-2.5 font-medium w-24 text-right">{t('problems.actions')}</th>
              </tr>
            </thead>
            <tbody>
              {problems.map((p) => (
                <tr
                  key={p.id}
                  className="border-b border-border/50 last:border-0 hover:bg-muted/30 transition-colors cursor-pointer"
                  onClick={() => navigate(`/admin/problems/${p.id}`)}
                >
                  <td className="px-4 py-2.5 text-muted-foreground">{p.problemNumber ?? p.id}</td>
                  <td className="px-4 py-2.5">
                    <span className="font-medium text-foreground">{p.title}</span>
                    <span className="ml-2 text-xs text-muted-foreground">/{p.slug}</span>
                  </td>
                  <td className="px-4 py-2.5">
                    <DifficultyBadge difficulty={p.difficulty as Difficulty} />
                  </td>
                  <td className="px-4 py-2.5">
                    <Badge variant={p.status === 'ACCEPTED' ? 'success' : 'secondary'} className="text-[10px]">
                      {p.status === 'ACCEPTED' ? t('problems.accepted') : t('problems.draft')}
                    </Badge>
                  </td>
                  <td className="px-4 py-2.5 text-muted-foreground">
                    {p.acceptanceRate != null ? `${p.acceptanceRate}%` : '—'}
                  </td>
                  <td className="px-4 py-2.5">
                    <div className="flex flex-wrap gap-1">
                      {p.tags.slice(0, 2).map((tag) => (
                        <span key={tag} className="rounded bg-muted px-1.5 py-0.5 text-[10px] text-muted-foreground">
                          {tag}
                        </span>
                      ))}
                      {p.tags.length > 2 && (
                        <span className="text-[10px] text-muted-foreground">+{p.tags.length - 2}</span>
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
                        onClick={() => handleDelete(p.id, p.title)}
                        className="rounded px-2 py-1 text-xs text-destructive hover:bg-destructive/10 transition-colors"
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

      {!loading && problems.length === 0 && (
        <div className="py-12 text-center text-sm text-muted-foreground">
          {t('problems.noProblems')}
        </div>
      )}
    </div>
  );
}
