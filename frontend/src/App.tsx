import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import { AuthProvider } from "./context/AuthContext";
import Layout from "./components/layout/Layout";
import WorkspaceLayout from "./components/layout/WorkspaceLayout";
import LoginPage from "./pages/LoginPage";
import OAuthCallbackPage from "./pages/OAuthCallbackPage";
import ProblemListPage from "./pages/ProblemListPage";
import ProblemDetailPage from "./pages/problem";
import NotFoundPage from "./pages/NotFoundPage";

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route path="/auth/callback/:provider" element={<OAuthCallbackPage />} />
          <Route element={<WorkspaceLayout />}>
            <Route path="problems/:slug" element={<ProblemDetailPage />} />
          </Route>
          <Route element={<Layout />}>
            <Route index element={<Navigate to="/problems" replace />} />
            <Route path="problems" element={<ProblemListPage />} />
            <Route path="*" element={<NotFoundPage />} />
          </Route>
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}

export default App;
