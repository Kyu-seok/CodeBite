import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import { ThemeProvider } from "./context/ThemeContext";
import { EditorSettingsProvider } from "./context/EditorSettingsContext";
import Layout from "./components/layout/Layout";
import WorkspaceLayout from "./components/layout/WorkspaceLayout";
import LandingPage from "./pages/landing";
import LoginPage from "./pages/LoginPage";
import OAuthCallbackPage from "./pages/OAuthCallbackPage";
import ProblemListPage from "./pages/ProblemListPage";
import ProblemDetailPage from "./pages/problem";
import RoadmapPage from "./pages/roadmap";
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
              <Route element={<WorkspaceLayout />}>
                <Route path="problems/:slug" element={<ProblemDetailPage />} />
              </Route>
              <Route index element={<LandingPage />} />
              <Route element={<Layout />}>
                <Route path="problems" element={<ProblemListPage />} />
                <Route path="roadmap" element={<RoadmapPage />} />
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
