import { Link, Outlet, useNavigate } from "react-router-dom";
import { useAuth } from "../../context/AuthContext";

function ChevronLeft() {
  return (
    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="m15 18-6-6 6-6" />
    </svg>
  );
}

function ChevronRight() {
  return (
    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="m9 18 6-6-6-6" />
    </svg>
  );
}

function ListIcon() {
  return (
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <line x1="3" x2="21" y1="6" y2="6" />
      <line x1="3" x2="21" y1="12" y2="12" />
      <line x1="3" x2="21" y1="18" y2="18" />
    </svg>
  );
}

export default function WorkspaceLayout() {
  const { user, isAuthenticated, logout } = useAuth();
  const navigate = useNavigate();

  const userInitial = user?.username?.charAt(0).toUpperCase() ?? "?";

  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="bg-gray-900 text-white border-b border-gray-800">
        <div className="px-3 h-12 flex items-center justify-between">
          <div className="flex items-center gap-1">
            <Link
              to="/problems"
              className="flex items-center justify-center w-8 h-8 rounded-md text-orange-400 hover:bg-gray-800 transition-colors font-bold text-lg"
              title="CodeBite Home"
            >
              C
            </Link>
            <div className="w-px h-5 bg-gray-700 mx-1" />
            <Link
              to="/problems"
              className="flex items-center gap-1.5 px-2 py-1.5 rounded-md text-sm text-gray-300 hover:text-white hover:bg-gray-800 transition-colors"
            >
              <ListIcon />
              <span>Problem List</span>
            </Link>
            <div className="flex items-center">
              <button
                onClick={() => navigate(-1)}
                className="flex items-center justify-center w-7 h-7 rounded-md text-gray-400 hover:text-white hover:bg-gray-800 transition-colors"
                title="Go back"
              >
                <ChevronLeft />
              </button>
              <button
                onClick={() => navigate(1)}
                className="flex items-center justify-center w-7 h-7 rounded-md text-gray-400 hover:text-white hover:bg-gray-800 transition-colors"
                title="Go forward"
              >
                <ChevronRight />
              </button>
            </div>
          </div>
          <div className="flex items-center gap-2">
            {isAuthenticated ? (
              <>
                <button
                  onClick={logout}
                  className="px-2.5 py-1 rounded-md text-xs text-gray-400 hover:text-white hover:bg-gray-800 transition-colors"
                >
                  Logout
                </button>
                {user?.avatarUrl ? (
                  <img
                    src={user.avatarUrl}
                    alt={user?.username}
                    className="w-7 h-7 rounded-full object-cover"
                    referrerPolicy="no-referrer"
                    title={user?.username}
                  />
                ) : (
                  <span
                    className="flex items-center justify-center w-7 h-7 rounded-full bg-gradient-to-br from-orange-400 to-amber-600 text-xs font-semibold text-white"
                    title={user?.username}
                  >
                    {userInitial}
                  </span>
                )}
              </>
            ) : (
              <Link
                to="/login"
                className="px-3 py-1 rounded-md text-sm text-gray-300 hover:text-white hover:bg-gray-800 transition-colors"
              >
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
