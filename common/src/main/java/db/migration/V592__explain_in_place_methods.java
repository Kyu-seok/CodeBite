package db.migration;

import db.migration.V590__explain_level_order_arrays.Replacement;
import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;

import java.util.List;

/**
 * Every In-Place Method (GLOSSARY.md, #351) says that it returns nothing and which input the grader
 * reads after the call, in the wording capture-enclosed-tiles already had:
 *
 * EN: "... returns nothing, and the grader reads `x` after the call."
 * KO: "... 아무것도 반환하지 않고, 채점기는 호출이 끝난 뒤의 `x`를 읽습니다."
 *
 * Each problem's existing line is replaced where it stands; sort-colors and walls-and-gates never
 * said they return nothing, so the sentence follows their last sentence before the examples.
 */
public class V592__explain_in_place_methods extends BaseJavaMigration {

    private static final List<Replacement> REPLACEMENTS = List.of(
            new Replacement("flatten-agenda-tree",
                    "The function returns nothing: the grader follows the `right` pointers from `root` and lists "
                            + "the values it visits.",
                    "The function returns nothing, and the grader reads `root` after the call, following the "
                            + "`right` pointers and listing the values it visits.",
                    "함수는 아무것도 반환하지 않습니다. 채점기는 `root`에서부터 `right` 포인터를 따라가며 방문한 값을 나열합니다.",
                    "함수는 아무것도 반환하지 않고, 채점기는 호출이 끝난 뒤의 `root`에서부터 `right` 포인터를 따라가며 "
                            + "방문한 값을 나열합니다."),
            new Replacement("interleave-clip-chain",
                    "The method returns nothing: the list starting at `head` is checked after the call.",
                    "The method returns nothing, and the grader reads the list from `head` after the call.",
                    "메서드는 아무것도 반환하지 않으며, 호출이 끝난 뒤 `head`부터 이어지는 리스트로 채점합니다.",
                    "메서드는 아무것도 반환하지 않고, 채점기는 호출이 끝난 뒤의 `head`부터 이어지는 리스트를 읽습니다."),
            new Replacement("move-voided-scans",
                    "without allocating a new array. It returns nothing.",
                    "without allocating a new array. It returns nothing, and the grader reads `scans` after the call.",
                    "`scans`를 **제자리에서** 바꾸며, 아무것도 반환하지 않습니다.",
                    "`scans`를 **제자리에서** 바꾸세요. 함수는 아무것도 반환하지 않고, 채점기는 호출이 끝난 뒤의 "
                            + "`scans`를 읽습니다."),
            new Replacement("next-speaker-order",
                    "using only constant extra memory. Return nothing.",
                    "using only constant extra memory. The method returns nothing, and the grader reads `lineup` "
                            + "after the call.",
                    "추가 메모리는 상수 크기만 사용하고, 아무것도 반환하지 않습니다.",
                    "추가 메모리는 상수 크기만 사용하세요. 메서드는 아무것도 반환하지 않고, 채점기는 호출이 끝난 뒤의 "
                            + "`lineup`을 읽습니다."),
            new Replacement("rotate-pixel-art",
                    "- Modify `image` itself; `rotateImage` returns nothing.",
                    "- Modify `image` itself: `rotateImage` returns nothing, and the grader reads `image` after "
                            + "the call.",
                    "`rotateImage`는 아무것도 반환하지 않습니다.",
                    "`rotateImage`는 아무것도 반환하지 않고, 채점기는 호출이 끝난 뒤의 `image`를 읽습니다."),
            new Replacement("zero-out-rows-cols",
                    "Modify `board` **in place**; the method returns nothing.",
                    "Modify `board` **in place**: the method returns nothing, and the grader reads `board` after "
                            + "the call.",
                    "`board`를 **제자리에서** 수정하며, 메서드는 아무것도 반환하지 않습니다.",
                    "`board`를 **제자리에서** 수정하세요. 메서드는 아무것도 반환하지 않고, 채점기는 호출이 끝난 뒤의 "
                            + "`board`를 읽습니다."),
            new Replacement("sort-colors",
                    "You may not call any built-in sort routine.",
                    "You may not call any built-in sort routine. The method returns nothing, and the grader reads "
                            + "`nums` after the call.",
                    "내장 정렬 함수는 사용할 수 없습니다.",
                    "내장 정렬 함수는 사용할 수 없습니다. 메서드는 아무것도 반환하지 않고, 채점기는 호출이 끝난 뒤의 "
                            + "`nums`를 읽습니다."),
            new Replacement("walls-and-gates",
                    "Empty rooms with no reachable gate stay at `2147483647`.",
                    "Empty rooms with no reachable gate stay at `2147483647`. The method returns nothing, and the "
                            + "grader reads `rooms` after the call.",
                    "어떤 문에도 도달할 수 없는 빈 방은 그대로 `2147483647`로 둡니다.",
                    "어떤 문에도 도달할 수 없는 빈 방은 그대로 `2147483647`로 둡니다. 메서드는 아무것도 반환하지 않고, "
                            + "채점기는 호출이 끝난 뒤의 `rooms`를 읽습니다."));

    @Override
    public void migrate(Context ctx) throws Exception {
        for (Replacement r : REPLACEMENTS) V590__explain_level_order_arrays.replace(ctx.getConnection(), r);
    }
}
