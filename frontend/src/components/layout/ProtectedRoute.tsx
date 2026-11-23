import { Navigate, useLocation } from "react-router-dom";
import { useAuth } from "../../context/AuthContext";
import Spinner from "../ui/Spinner";
import { rememberReturn, returnTarget } from "@/lib/signInReturn";

export default function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { isAuthenticated, loading } = useAuth();
  const location = useLocation();

  if (loading) return <Spinner />;
  if (!isAuthenticated) {
    // OAuthCallbackPage comes back here after sign-in, as it does to the page the navbar's Log in left.
    rememberReturn(returnTarget(location));
    return <Navigate to="/login" replace />;
  }
  return <>{children}</>;
}
