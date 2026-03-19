class JsonOutput {
    static String intArray(int[] arr) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < arr.length; i++) {
            if (i > 0) sb.append(",");
            sb.append(arr[i]);
        }
        sb.append("]");
        return sb.toString();
    }

    static String stringList(java.util.List<String> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("\"").append(list.get(i)).append("\"");
        }
        sb.append("]");
        return sb.toString();
    }

    static String charArray(char[] arr) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < arr.length; i++) {
            if (i > 0) sb.append(",");
            sb.append("\"").append(arr[i]).append("\"");
        }
        sb.append("]");
        return sb.toString();
    }

    static String intList2D(java.util.List<java.util.List<Integer>> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("[");
            for (int j = 0; j < list.get(i).size(); j++) {
                if (j > 0) sb.append(",");
                sb.append(list.get(i).get(j));
            }
            sb.append("]");
        }
        sb.append("]");
        return sb.toString();
    }
}
