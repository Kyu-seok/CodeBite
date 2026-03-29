import { useAuth } from '@/context/AuthContext';
import { useProfile } from '@/hooks/useProfile';
import Spinner from '@/components/ui/Spinner';
import { ProfileHeader } from './ProfileHeader';
import { ActivityHeatmap } from './ActivityHeatmap';
import { SolveProgressCard } from './SolveProgressCard';
import { TagRadarCard } from './TagRadarCard';
import { RecentSubmissionsCard } from './RecentSubmissionsCard';

export default function ProfilePage() {
  const { user } = useAuth();
  const { stats, activity, tagProficiency, loading } = useProfile();

  if (loading || !stats || !user) {
    return (
      <div className="mx-auto flex max-w-4xl items-center justify-center px-4 py-20 sm:px-6">
        <Spinner />
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6">
      <div className="flex flex-col gap-5">
        <ProfileHeader user={user} stats={stats} />
        <ActivityHeatmap activity={activity} />

        <div className="grid grid-cols-1 gap-5 md:grid-cols-2">
          <SolveProgressCard stats={stats} />
          <TagRadarCard tagProficiency={tagProficiency} />
        </div>

        <RecentSubmissionsCard />
      </div>
    </div>
  );
}
