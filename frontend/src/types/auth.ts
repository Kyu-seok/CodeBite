export interface User {
  id: number;
  username: string;
  email: string;
  role: "USER" | "ADMIN";
  avatarUrl: string | null;
  recentLanguage: string | null;
  editorSettings: string | null;
  themePreference: string | null;
  locale: string | null;
  curation: string | null;
  singlePage: boolean | null;
  createdAt: string;
}

export interface AuthResponse {
  token: string;
  tokenType: string;
  user: User;
}

export interface OAuthUrlResponse {
  authorizationUrl: string;
}
