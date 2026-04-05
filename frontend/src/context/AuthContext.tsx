import { createContext, useContext, useEffect, useState, type ReactNode } from "react";
import i18n from "@/lib/i18n";
import type { User } from "../types/auth";
import * as authApi from "../api/auth";
import { useEditorSettings } from "./EditorSettingsContext";
import { useTheme, type Theme } from "./ThemeContext";

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
  const { setTheme } = useTheme();

  const applyThemeFromUser = (themePreference: string | null) => {
    if (themePreference === "light" || themePreference === "dark") {
      setTheme(themePreference as Theme);
    }
  };

  const applyLocaleFromUser = (locale: string | null) => {
    if (locale && (locale === "ko" || locale === "en")) {
      i18n.changeLanguage(locale);
    }
  };

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
        applyThemeFromUser(res.data.themePreference);
        applyLocaleFromUser(res.data.locale);
      })
      .catch(() => localStorage.removeItem("token"))
      .finally(() => setLoading(false));
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const loginWithOAuth = async (provider: string, code: string, state: string) => {
    const res = await authApi.oauthCallback(provider, code, state);
    localStorage.setItem("token", res.data.token);
    setUser(res.data.user);
    initFromUser(res.data.user.editorSettings);
    applyThemeFromUser(res.data.user.themePreference);
    applyLocaleFromUser(res.data.user.locale);
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
