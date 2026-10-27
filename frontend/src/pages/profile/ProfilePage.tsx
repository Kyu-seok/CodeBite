import { useTranslation } from 'react-i18next';
import { useAuth } from '@/context/AuthContext';
import { useProfile } from '@/hooks/useProfile';
import Spinner from '@/components/ui/Spinner';
import { ProfileHeader } from './ProfileHeader';
import { ActivityHeatmap } from './ActivityHeatmap';
import { SolveProgressCard } from './SolveProgressCard';
import { TagRadarCard } from './TagRadarCard';
import { RecentSubmissionsCard } from './RecentSubmissionsCard';
import { DueReviewsCard } from './DueReviewsCard';
import { StreakCalendarCard } from './StreakCalendarCard';
import { GitHubLinkCard } from './GitHubLinkCard';
import { CardError } from './CardError';

export default function ProfilePage() {
  const { t } = useTranslation('profile');
  const { user } = useAuth();
  const { stats, activity, tagProficiency, failed, loading, reload } = useProfile();

  if (!user || (loading && !stats)) {
    return (
      <div className="mx-auto flex max-w-4xl items-center justify-center px-4 py-20 sm:px-6">
        <Spinner />
      </div>
    );
  }

  if (!stats) {
    return (
      <div className="mx-auto max-w-md px-4 py-20 sm:px-6">
        <h1 className="sr-only">{user.username}</h1>
        <CardError onRetry={reload} />
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6">
      <div className="flex flex-col gap-5">
        <ProfileHeader user={user} stats={stats} />
        <StreakCalendarCard />
        <GitHubLinkCard />
        {failed.has('activity') ? (
          <section className="rounded-xl border border-border bg-card p-5">
            <h2 className="text-sm font-medium text-foreground">{t('heatmap.title')}</h2>
            <CardError onRetry={reload} />
          </section>
        ) : (
          <ActivityHeatmap activity={activity} />
        )}

        <div className="grid grid-cols-1 gap-5 md:grid-cols-2">
          <SolveProgressCard stats={stats} />
          <TagRadarCard tagProficiency={tagProficiency} failed={failed.has('tags')} onRetry={reload} />
        </div>

        <DueReviewsCard />

        <RecentSubmissionsCard />
      </div>
    </div>
  );
}
