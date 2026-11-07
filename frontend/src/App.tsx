import "@/lib/i18n";
import { lazy, Suspense } from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import { ThemeProvider } from "./context/ThemeContext";
import { EditorSettingsProvider } from "./context/EditorSettingsContext";
import Layout from "./components/layout/Layout";
import LandingPage from "./pages/landing";
import LoginPage from "./pages/LoginPage";
import OAuthCallbackPage from "./pages/OAuthCallbackPage";
import ProblemListPage from "./pages/ProblemListPage";
// The problem workspace (with the Monaco editor), the solution editor and the admin pages load
// on demand: the landing and list pages are visited far more often and need none of that code.
const ProblemDetailPage = lazy(() => import("./pages/problem"));
const SolutionDetailPage = lazy(() => import("./pages/problem/solutions/SolutionDetailPage"));
const SolutionEditorPage = lazy(() => import("./pages/problem/solutions/SolutionEditorPage"));
import RoadmapPage from "./pages/roadmap";
import ProfilePage from "./pages/profile/ProfilePage";
import GitHubCallbackPage from "./pages/GitHubCallbackPage";
import ReviewsPage from "./pages/reviews/ReviewsPage";
import ProtectedRoute from "./components/layout/ProtectedRoute";
const AdminLayout = lazy(() => import("./pages/admin/AdminLayout"));
const AdminDashboardPage = lazy(() => import("./pages/admin/DashboardPage"));
const AdminProblemListPage = lazy(() => import("./pages/admin/ProblemListPage"));
const AdminProblemEditPage = lazy(() => import("./pages/admin/ProblemEditPage"));
const AdminUserListPage = lazy(() => import("./pages/admin/UserListPage"));
const AdminUserSubmissionsPage = lazy(() => import("./pages/admin/UserSubmissionsPage"));
import NotFoundPage from "./pages/NotFoundPage";
import Spinner from "./components/ui/Spinner";

function App() {
  return (
    <ThemeProvider>
      <EditorSettingsProvider>
        <AuthProvider>
          <BrowserRouter>
            <Suspense fallback={<Spinner />}>
            <Routes>
              <Route path="/login" element={<LoginPage />} />
              <Route path="/auth/callback/:provider" element={<OAuthCallbackPage />} />
              <Route element={<AdminLayout />}>
                <Route path="admin/dashboard" element={<AdminDashboardPage />} />
                <Route path="admin/problems" element={<AdminProblemListPage />} />
                <Route path="admin/problems/:id" element={<AdminProblemEditPage />} />
                <Route path="admin/users" element={<AdminUserListPage />} />
                <Route path="admin/users/:userId/submissions" element={<AdminUserSubmissionsPage />} />
              </Route>
              <Route element={<Layout />}>
                <Route index element={<LandingPage />} />
                <Route path="problems" element={<ProblemListPage />} />
                <Route path="problems/:slug" element={<ProblemDetailPage />} />
                <Route
                  path="problems/:slug/solutions/new"
                  element={
                    <ProtectedRoute>
                      <SolutionEditorPage mode="create" />
                    </ProtectedRoute>
                  }
                />
                <Route path="problems/:slug/solutions/:solutionId" element={<SolutionDetailPage />} />
                <Route
                  path="problems/:slug/solutions/:solutionId/edit"
                  element={
                    <ProtectedRoute>
                      <SolutionEditorPage mode="edit" />
                    </ProtectedRoute>
                  }
                />
                <Route path="roadmap" element={<RoadmapPage />} />
                <Route path="profile" element={<ProtectedRoute><ProfilePage /></ProtectedRoute>} />
                <Route path="github/callback" element={<ProtectedRoute><GitHubCallbackPage /></ProtectedRoute>} />
                <Route path="reviews" element={<ProtectedRoute><ReviewsPage /></ProtectedRoute>} />
                <Route path="*" element={<NotFoundPage />} />
              </Route>
            </Routes>
            </Suspense>
          </BrowserRouter>
        </AuthProvider>
      </EditorSettingsProvider>
    </ThemeProvider>
  );
}

export default App;
