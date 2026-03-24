import { Link, Outlet } from "react-router-dom";
import { useAuth } from "../../context/AuthContext";

export default function Layout() {
  const { user, isAuthenticated, logout } = useAuth();

  return (
    <div className="min-h-screen bg-background">
      <nav className="bg-muted text-foreground border-b border-border">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-14 flex items-center justify-between">
          <div className="flex items-center gap-6">
            <Link to="/problems" className="text-lg font-bold">
              CodeBite
            </Link>
            <Link to="/problems" className="text-sm text-muted-foreground hover:text-foreground">
              Problems
            </Link>
          </div>
          <div className="flex items-center gap-4 text-sm">
            {isAuthenticated ? (
              <>
                <button
                  onClick={logout}
                  className="text-muted-foreground hover:text-foreground"
                >
                  Logout
                </button>
                {user?.avatarUrl ? (
                  <img
                    src={user.avatarUrl}
                    alt={user.username}
                    className="w-7 h-7 rounded-full object-cover"
                    referrerPolicy="no-referrer"
                  />
                ) : (
                  <span className="flex items-center justify-center w-7 h-7 rounded-full bg-gradient-to-br from-orange-400 to-amber-600 text-xs font-semibold text-white">
                    {user?.username?.charAt(0).toUpperCase() ?? "?"}
                  </span>
                )}
              </>
            ) : (
              <Link to="/login" className="text-muted-foreground hover:text-foreground">
                Login
              </Link>
            )}
          </div>
        </div>
      </nav>
      <main>
        <Outlet />
      </main>
    </div>
  );
}
