import "@/lib/i18n";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import { ThemeProvider } from "./context/ThemeContext";
import { EditorSettingsProvider } from "./context/EditorSettingsContext";
import Layout from "./components/layout/Layout";
import LandingPage from "./pages/landing";
import LoginPage from "./pages/LoginPage";
import OAuthCallbackPage from "./pages/OAuthCallbackPage";
import ProblemListPage from "./pages/ProblemListPage";
import ProblemDetailPage from "./pages/problem";
import RoadmapPage from "./pages/roadmap";
import ProfilePage from "./pages/profile/ProfilePage";
import ProtectedRoute from "./components/layout/ProtectedRoute";
import AdminLayout from "./pages/admin/AdminLayout";
import AdminDashboardPage from "./pages/admin/DashboardPage";
import AdminProblemListPage from "./pages/admin/ProblemListPage";
import AdminProblemEditPage from "./pages/admin/ProblemEditPage";
import AdminUserListPage from "./pages/admin/UserListPage";
import NotFoundPage from "./pages/NotFoundPage";

function App() {
  return (
    <ThemeProvider>
      <EditorSettingsProvider>
        <AuthProvider>
          <BrowserRouter>
            <Routes>
              <Route path="/login" element={<LoginPage />} />
              <Route path="/auth/callback/:provider" element={<OAuthCallbackPage />} />
              <Route element={<AdminLayout />}>
                <Route path="admin/dashboard" element={<AdminDashboardPage />} />
                <Route path="admin/problems" element={<AdminProblemListPage />} />
                <Route path="admin/problems/:id" element={<AdminProblemEditPage />} />
                <Route path="admin/users" element={<AdminUserListPage />} />
              </Route>
              <Route element={<Layout />}>
                <Route index element={<LandingPage />} />
                <Route path="problems" element={<ProblemListPage />} />
                <Route path="problems/:slug" element={<ProblemDetailPage />} />
                <Route path="roadmap" element={<RoadmapPage />} />
                <Route path="profile" element={<ProtectedRoute><ProfilePage /></ProtectedRoute>} />
                <Route path="*" element={<NotFoundPage />} />
              </Route>
            </Routes>
          </BrowserRouter>
        </AuthProvider>
      </EditorSettingsProvider>
    </ThemeProvider>
  );
}

export default App;
