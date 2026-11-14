class Solution {
    public boolean isInterleaving(String controllerA, String controllerB, String merged) {
        int a = controllerA.length(), b = controllerB.length();
        if (a + b != merged.length()) return false;
        boolean[] ok = new boolean[b + 1];
        ok[0] = true;
        for (int j = 1; j <= b; j++) ok[j] = ok[j - 1] && controllerB.charAt(j - 1) == merged.charAt(j - 1);
        for (int i = 1; i <= a; i++) {
            ok[0] = ok[0] && controllerA.charAt(i - 1) == merged.charAt(i - 1);
            for (int j = 1; j <= b; j++) {
                char letter = merged.charAt(i + j - 1);
                ok[j] = (ok[j] && controllerA.charAt(i - 1) == letter) || (ok[j - 1] && controllerB.charAt(j - 1) == letter);
            }
        }
        return ok[b];
    }
}
