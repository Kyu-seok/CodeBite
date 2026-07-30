import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Tabs, TabsList, TabsTrigger, TabsContent } from '@/components/ui/Tabs';
import { Button } from '@/components/ui/Button';
import { Tooltip, TooltipTrigger, TooltipContent } from '@/components/ui/Tooltip';
import { DescriptionPanel } from './DescriptionPanel';
import { SubmissionsPanel } from './SubmissionsPanel';
import { SolutionsListPanel } from './solutions/SolutionsListPanel';
import type { Difficulty } from '@/types/problem';
import type { SubmissionListItem } from '@/types/submission';
import { PanelLeftClose, Maximize2, Minimize2 } from 'lucide-react';

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
  slug: string;
  title: string;
  difficulty: Difficulty;
  description: string;
  constraints: string | null;
  isAuthenticated: boolean;
  submissions: SubmissionListItem[];
  onUpdateNote?: (id: number, notes: string) => void;
  onLoadIntoEditor?: (code: string, language: string) => void;
  onFold?: () => void;
  onMaximize?: () => void;
  isMaximized?: boolean;
}

export function LeftPanel({
  slug,
  title,
  difficulty,
  description,
  constraints,
  isAuthenticated,
  submissions,
  onUpdateNote,
  onLoadIntoEditor,
  onFold,
  onMaximize,
  isMaximized,
}: LeftPanelProps) {
  const { t } = useTranslation('problem');
  const [activeTab, setActiveTab] = useState<string>('description');
  const [selectedSubmissionId, setSelectedSubmissionId] = useState<number | null>(null);

  const handleOpenSubmission = (id: number) => {
    setSelectedSubmissionId(id);
    setActiveTab('submissions');
  };

  return (
    <div className="flex h-full flex-col">
      <Tabs
        value={activeTab}
        onValueChange={(v) => {
          setActiveTab(v);
          // Switching tabs away from Submissions should clear any open detail.
          if (v !== 'submissions') setSelectedSubmissionId(null);
        }}
        className="flex h-full flex-col"
      >
        <div className="group flex items-center justify-between border-b border-border bg-muted">
          <TabsList>
            <TabsTrigger value="description" className="gap-1.5">
              <DescriptionIcon />
              {t('tabs.description')}
            </TabsTrigger>
            <TabsTrigger value="submissions" className="gap-1.5">
              <HistoryIcon />
              {t('tabs.submissions')}
            </TabsTrigger>
            <TabsTrigger value="solutions" className="gap-1.5">
              <LightbulbIcon />
              {t('tabs.solutions')}
            </TabsTrigger>
          </TabsList>
          <div className="flex items-center pr-1 opacity-0 transition-opacity group-hover:opacity-100">
            <Tooltip>
              <TooltipTrigger>
                <Button variant="ghost" size="icon" className="h-7 w-7" onClick={onFold}>
                  <PanelLeftClose className="h-3.5 w-3.5" />
                </Button>
              </TooltipTrigger>
              <TooltipContent>Fold panel</TooltipContent>
            </Tooltip>
            <Tooltip>
              <TooltipTrigger>
                <Button variant="ghost" size="icon" className="h-7 w-7" onClick={onMaximize}>
                  {isMaximized ? <Minimize2 className="h-3.5 w-3.5" /> : <Maximize2 className="h-3.5 w-3.5" />}
                </Button>
              </TooltipTrigger>
              <TooltipContent>{isMaximized ? 'Restore' : 'Maximize'}</TooltipContent>
            </Tooltip>
          </div>
        </div>

        <div className="flex-1 overflow-auto">
          <TabsContent value="description" className="mt-0">
            <DescriptionPanel
              slug={slug}
              title={title}
              difficulty={difficulty}
              description={description}
              constraints={constraints}
              isAuthenticated={isAuthenticated}
              onOpenSubmission={handleOpenSubmission}
            />
          </TabsContent>

          <TabsContent value="submissions" className="mt-0">
            <SubmissionsPanel
              isAuthenticated={isAuthenticated}
              submissions={submissions}
              selectedSubmissionId={selectedSubmissionId}
              onSelectSubmission={setSelectedSubmissionId}
              onUpdateNote={onUpdateNote}
              onLoadIntoEditor={onLoadIntoEditor}
            />
          </TabsContent>

          <TabsContent value="solutions" className="mt-0 h-full">
            <SolutionsListPanel slug={slug} isAuthenticated={isAuthenticated} />
          </TabsContent>
        </div>
      </Tabs>
    </div>
  );
}

export function CollapsedLeftStrip({ onExpand }: { onExpand?: () => void }) {
  const { t } = useTranslation('problem');
  return (
    <div className="flex h-full flex-col items-center py-2 gap-1">
      <Tooltip>
        <TooltipTrigger>
          <button
            type="button"
            onClick={onExpand}
            className="flex items-center justify-center rounded p-1.5 text-muted-foreground transition-colors hover:bg-muted hover:text-foreground">
            <DescriptionIcon />
          </button>
        </TooltipTrigger>
        <TooltipContent side="right">{t('tabs.description')}</TooltipContent>
      </Tooltip>
      <Tooltip>
        <TooltipTrigger>
          <button
            type="button"
            onClick={onExpand}
            className="flex items-center justify-center rounded p-1.5 text-muted-foreground transition-colors hover:bg-muted hover:text-foreground">
            <HistoryIcon />
          </button>
        </TooltipTrigger>
        <TooltipContent side="right">{t('tabs.submissions')}</TooltipContent>
      </Tooltip>
      <Tooltip>
        <TooltipTrigger>
          <button
            type="button"
            onClick={onExpand}
            className="flex items-center justify-center rounded p-1.5 text-muted-foreground transition-colors hover:bg-muted hover:text-foreground">
            <LightbulbIcon />
          </button>
        </TooltipTrigger>
        <TooltipContent side="right">{t('tabs.solutions')}</TooltipContent>
      </Tooltip>
    </div>
  );
}
