import { Navigate, useLocation } from "react-router-dom";
import { useAuth } from "../../context/AuthContext";
import Spinner from "../ui/Spinner";

export default function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { isAuthenticated, loading } = useAuth();
  const location = useLocation();

  if (loading) return <Spinner />;
  if (!isAuthenticated) {
    // Same hand-off the navbar's login button uses: OAuthCallbackPage returns here after sign-in.
    sessionStorage.setItem("returnUrl", location.pathname + location.search);
    return <Navigate to="/login" replace />;
  }
  return <>{children}</>;
}
