import { createContext, useContext, useEffect, useState, type ReactNode } from "react";
import type { User } from "../types/auth";
import * as authApi from "../api/auth";
import { useEditorSettings } from "./EditorSettingsContext";

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  loading: boolean;
  loginWithOAuth: (provider: string, code: string, state: string) => Promise<void>;
  logout: () => void;
  updateUser: (patch: Partial<User>) => void;
}

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const { initFromUser } = useEditorSettings();

  useEffect(() => {
    const token = localStorage.getItem("token");
    if (!token) {
      setLoading(false);
      return;
    }
    authApi
      .getMe()
      .then((res) => {
        setUser(res.data);
        initFromUser(res.data.editorSettings);
      })
      .catch(() => localStorage.removeItem("token"))
      .finally(() => setLoading(false));
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const loginWithOAuth = async (provider: string, code: string, state: string) => {
    const res = await authApi.oauthCallback(provider, code, state);
    localStorage.setItem("token", res.data.token);
    setUser(res.data.user);
    initFromUser(res.data.user.editorSettings);
  };

  const updateUser = (patch: Partial<User>) => {
    setUser((prev) => (prev ? { ...prev, ...patch } : prev));
  };

  const logout = () => {
    authApi.logout().catch(() => {});
    localStorage.removeItem("token");
    setUser(null);
  };

  return (
    <AuthContext.Provider
      value={{ user, isAuthenticated: !!user, loading, loginWithOAuth, logout, updateUser }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
}
