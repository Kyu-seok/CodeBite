import client from "./client";

export function updateEditorSettings(editorSettings: string) {
  return client.patch("/users/settings", { editorSettings });
}
