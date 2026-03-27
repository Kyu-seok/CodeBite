import client from "./client";

export function updateEditorSettings(editorSettings: string) {
  return client.patch("/users/settings", { editorSettings });
}

export function updateThemePreference(themePreference: string) {
  return client.patch("/users/settings", { themePreference });
}
