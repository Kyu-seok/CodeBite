import { Tabs, TabsList, TabsTrigger, TabsContent } from '@/components/ui/Tabs';
import { DescriptionPanel } from './DescriptionPanel';
import { SubmissionsPanel } from './SubmissionsPanel';
import type { Difficulty, TestCase } from '@/types/problem';
import type { SubmissionListItem } from '@/types/submission';

function DescriptionIcon() {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="14"
      height="14"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round">
      <path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z" />
      <path d="M14 2v4a2 2 0 0 0 2 2h4" />
    </svg>
  );
}

function HistoryIcon() {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="14"
      height="14"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round">
      <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8" />
      <path d="M3 3v5h5" />
      <path d="M12 7v5l4 2" />
    </svg>
  );
}

function LightbulbIcon() {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="14"
      height="14"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round">
      <path d="M15 14c.2-1 .7-1.7 1.5-2.5 1-.9 1.5-2.2 1.5-3.5A6 6 0 0 0 6 8c0 1 .2 2.2 1.5 3.5.7.7 1.3 1.5 1.5 2.5" />
      <path d="M9 18h6" />
      <path d="M10 22h4" />
    </svg>
  );
}

interface LeftPanelProps {
  title: string;
  difficulty: Difficulty;
  description: string;
  constraints: string | null;
  sampleTestCases: TestCase[];
  isAuthenticated: boolean;
  submissions: SubmissionListItem[];
  onUpdateNote?: (id: number, notes: string) => void;
}

export function LeftPanel({
  title,
  difficulty,
  description,
  constraints,
  sampleTestCases,
  isAuthenticated,
  submissions,
  onUpdateNote,
}: LeftPanelProps) {
  return (
    <div className="flex h-full flex-col">
      <Tabs defaultValue="description" className="flex h-full flex-col">
        <div className="border-b border-border bg-muted">
          <TabsList>
            <TabsTrigger value="description" className="gap-1.5">
              <DescriptionIcon />
              Description
            </TabsTrigger>
            <TabsTrigger value="submissions" className="gap-1.5">
              <HistoryIcon />
              Submissions
            </TabsTrigger>
            <TabsTrigger value="solutions" className="gap-1.5">
              <LightbulbIcon />
              Solutions
            </TabsTrigger>
          </TabsList>
        </div>

        <div className="flex-1 overflow-auto">
          <TabsContent value="description" className="mt-0">
            <DescriptionPanel
              title={title}
              difficulty={difficulty}
              description={description}
              constraints={constraints}
              sampleTestCases={sampleTestCases}
            />
          </TabsContent>

          <TabsContent value="submissions" className="mt-0">
            <SubmissionsPanel
              isAuthenticated={isAuthenticated}
              submissions={submissions}
              onUpdateNote={onUpdateNote}
            />
          </TabsContent>

          <TabsContent value="solutions" className="mt-0">
            <div className="flex flex-col items-center justify-center py-16 text-muted-foreground">
              <LightbulbIcon />
              <p className="mt-2 text-sm">Solutions coming soon</p>
            </div>
          </TabsContent>
        </div>
      </Tabs>
    </div>
  );
}
