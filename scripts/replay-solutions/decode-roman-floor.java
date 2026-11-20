class Solution {
    private static int value(char symbol) {
        switch (symbol) {
            case 'I': return 1;
            case 'V': return 5;
            case 'X': return 10;
            case 'L': return 50;
            case 'C': return 100;
            case 'D': return 500;
            default: return 1000;
        }
    }

    public int decodeZoneNumeral(String numeral) {
        int total = 0;
        for (int i = 0; i < numeral.length(); i++) {
            int value = value(numeral.charAt(i));
            if (i + 1 < numeral.length() && value < value(numeral.charAt(i + 1))) {
                total -= value;
            } else {
                total += value;
            }
        }
        return total;
    }
}
