package db.migration;

import db.migration.V590__explain_level_order_arrays.Replacement;
import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

import java.util.List;

/**
 * Every Any-Order Result (GLOSSARY.md, #351) says so in one standard sentence that also names
 * why any order passes: the grader sorts the result before comparing. Each statement already said
 * the order was free, in many wordings, so each line is replaced where it stands. The problems
 * whose Drivers also sort each item's values say "both". list-bracket-pairings already had the
 * standard sentence.
 *
 * EN: "Return the <items> in any order: the grader sorts them before comparing."
 *     "Return the <items>, and the <values> within each, in any order: the grader sorts both before comparing."
 * KO: "<items>은 어떤 순서로 반환해도 됩니다. 채점기가 비교 전에 정렬합니다."
 *     "<items>도, 각 <item> 안의 <values>도 어떤 순서로 반환해도 됩니다. 채점기가 비교 전에 둘 다 정렬합니다."
 *
 * merge-duplicate-contacts keeps its rule that each entry's emails are sorted: its Driver sorts
 * them too, but the statement asks for it, so only the entries' order gets the sentence.
 */
public class V591__explain_any_order_results extends BaseJavaMigration {

    private static final String OUTER_EN = "in any order: the grader sorts them before comparing.";
    private static final String BOTH_EN = "in any order: the grader sorts both before comparing.";
    private static final String OUTER_KO = "어떤 순서로 반환해도 됩니다. 채점기가 비교 전에 정렬합니다.";
    private static final String BOTH_KO = "어떤 순서로 반환해도 됩니다. 채점기가 비교 전에 둘 다 정렬합니다.";

    private static final List<Replacement> REPLACEMENTS = List.of(
            new Replacement("flip-phone-codes",
                    "Return the combinations in any order, and an empty list when `digits` is empty.",
                    "Return an empty list when `digits` is empty. Return the combinations " + OUTER_EN,
                    "조합의 순서는 상관없으며, `digits`가 비어 있으면 빈 리스트를 반환합니다.",
                    "`digits`가 비어 있으면 빈 리스트를 반환합니다. 조합은 " + OUTER_KO),
            new Replacement("restore-wifi-ip",
                    "can form, in any order, or an empty list when none is valid.",
                    "can form, or an empty list when none is valid. Return the addresses " + OUTER_EN,
                    "순서는 자유이며, 유효한 주소가 없으면 빈 리스트를 반환합니다.",
                    "유효한 주소가 없으면 빈 리스트를 반환합니다. 주소는 " + OUTER_KO),
            new Replacement("word-search-ii",
                    "Return the matched words in any order.",
                    "Return the matched words " + OUTER_EN,
                    "매칭된 단어들을 어떤 순서로든 반환하면 됩니다.",
                    "매칭된 단어는 " + OUTER_KO),
            new Replacement("repeat-attendance-codes",
                    "Return every code that appears twice, in any order. If no code repeats, return an empty list.",
                    "Return every code that appears twice, or an empty list if no code repeats. Return the codes "
                            + OUTER_EN,
                    "두 번 등장하는 코드를 모두 어떤 순서로든 반환하세요. 반복되는 코드가 없으면 빈 리스트를 반환합니다.",
                    "두 번 등장하는 코드를 모두 반환하고, 반복되는 코드가 없으면 빈 리스트를 반환하세요. 코드는 "
                            + OUTER_KO),
            new Replacement("top-espresso-machines",
                    "appear most often in `checkIns`, in any order. Each number in `checkIns` is the id of the "
                            + "espresso machine used for one coffee.",
                    "appear most often in `checkIns`. Each number in `checkIns` is the id of the espresso machine "
                            + "used for one coffee. Return the ids " + OUTER_EN,
                    "반환 순서는 상관없습니다. `checkIns`의 각 숫자는 커피 한 잔을 내릴 때 사용된 에스프레소 머신의 id입니다.",
                    "`checkIns`의 각 숫자는 커피 한 잔을 내릴 때 사용된 에스프레소 머신의 id입니다. id는 " + OUTER_KO),
            new Replacement("cafe-stop-orders",
                    "The orders may be returned in any order.",
                    "Return the visit orders " + OUTER_EN,
                    "순서들은 어떤 차례로 반환해도 됩니다.",
                    "방문 순서들은 어떤 차례로 반환해도 됩니다. 채점기가 비교 전에 정렬합니다."),
            new Replacement("list-skill-build-paths",
                    "Return the paths in any order, or an empty list when no path sums to `target`.",
                    "Return an empty list when no path sums to `target`. Return the paths " + OUTER_EN,
                    "경로는 어떤 순서로 반환해도 되며, 합이 `target`인 경로가 없으면 빈 리스트를 반환합니다.",
                    "합이 `target`인 경로가 없으면 빈 리스트를 반환합니다. 경로는 " + OUTER_KO),
            new Replacement("n-queens",
                    "Order of arrangements in the output does not matter.",
                    "Return the arrangements " + OUTER_EN,
                    "결과 배치들의 출력 순서는 상관없습니다.",
                    "배치는 " + OUTER_KO),
            new Replacement("palindrome-menu-splits",
                    "Outer list order doesn't matter.",
                    "Return the splits " + OUTER_EN,
                    "바깥 리스트의 순서는 상관없습니다.",
                    "분할은 " + OUTER_KO),
            new Replacement("dual-waterbowl-flow",
                    "Return the cells in any order.",
                    "Return the cells " + OUTER_EN,
                    "칸의 순서는 상관없습니다.",
                    "칸은 " + OUTER_KO),
            new Replacement("nearest-cafe-stops",
                    "Return the `k` nearest stops in any order; the answer is unique up to ordering.",
                    "The answer is unique up to ordering. Return the `k` nearest stops " + OUTER_EN,
                    "가장 가까운 `k`개의 배달지를 임의의 순서로 반환하면 되며, 정답은 순서를 빼면 유일합니다.",
                    "정답은 순서를 빼면 유일합니다. 가장 가까운 `k`개의 배달지는 " + OUTER_KO),
            new Replacement("merge-duplicate-contacts",
                    "The returned entries can be in any order.",
                    "Return the entries " + OUTER_EN,
                    "반환되는 항목들 자체의 순서는 상관없습니다.",
                    "항목은 " + OUTER_KO),
            new Replacement("group-anagrams",
                    "Order of groups, and order within each group, does not matter.",
                    "Return the groups, and the strings within each, " + BOTH_EN,
                    "그룹들 간의 순서나 그룹 안 문자열들의 순서는 상관없습니다.",
                    "그룹도, 각 그룹 안의 문자열도 " + BOTH_KO),
            new Replacement("four-tray-sum",
                    "Return the quadruplets in any order, and the values within each in any order.",
                    "Return the quadruplets, and the values within each, " + BOTH_EN,
                    "조합의 순서도, 각 조합 안의 값 순서도 자유입니다.",
                    "조합도, 각 조합 안의 값도 " + BOTH_KO),
            new Replacement("menu-combos-tab",
                    "Return the combos in any order, each combo's prices in any order, or an empty list when no "
                            + "combo sums to `tab`.",
                    "Return an empty list when no combo sums to `tab`. Return the combos, and the prices within "
                            + "each, " + BOTH_EN,
                    "조합의 순서와 각 조합 안의 가격 순서는 자유이며, 합이 `tab`인 조합이 없으면 빈 리스트를 반환합니다.",
                    "합이 `tab`인 조합이 없으면 빈 리스트를 반환합니다. 조합도, 각 조합 안의 가격도 " + BOTH_KO),
            new Replacement("power-set",
                    "Return the subsets in any order, and the elements of each subset in any order.",
                    "Return the subsets, and the elements within each, " + BOTH_EN,
                    "부분집합들의 순서와 각 부분집합 안의 원소 순서는 상관없습니다.",
                    "부분집합도, 각 부분집합 안의 원소도 " + BOTH_KO),
            new Replacement("snack-combo-picks",
                    "Return the combos in any order, with the flavors inside each combo in any order.",
                    "Return the combos, and the flavors within each, " + BOTH_EN,
                    "조합의 순서와 각 조합 안의 맛 순서는 상관없습니다.",
                    "조합도, 각 조합 안의 맛도 " + BOTH_KO),
            new Replacement("voucher-price-combos",
                    "- The prices inside a basket, and the baskets themselves, may be in any order.",
                    "- Return the baskets, and the prices within each, " + BOTH_EN,
                    "- 장바구니 안의 가격 순서와 장바구니들의 순서는 상관없습니다.",
                    "- 장바구니도, 각 장바구니 안의 가격도 " + BOTH_KO),
            new Replacement("zero-sum-trio",
                    "Return the trios, and the values inside each trio, in any order.",
                    "Return the trios, and the values within each, " + BOTH_EN,
                    "삼인방들의 순서와 각 삼인방 안의 값 순서는 자유입니다.",
                    "삼인방도, 각 삼인방 안의 값도 " + BOTH_KO));

    @Override
    public void migrate(Context ctx) throws Exception {
        for (Replacement r : REPLACEMENTS) V590__explain_level_order_arrays.replace(ctx.getConnection(), r);
    }
}
