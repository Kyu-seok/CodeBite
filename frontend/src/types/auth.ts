export interface User {
  id: number;
  username: string;
  email: string;
  role: "USER" | "ADMIN";
  avatarUrl: string | null;
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
