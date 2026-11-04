-- V204: rotate-pet-cafe-map -> rotate-pixel-art, retitled "Rotate Pixel Art". A
-- pixel art image explains why the input is an integer grid; a cafe's seating map didn't.
-- The method is renamed from rotateParkMap to rotateImage and the parameter from
-- cafeMap to image. Drivers and Starter Code directories are renamed in the same
-- commit. Examples match the sample test cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$rotate-pet-cafe-map$$, id FROM problems WHERE slug = $$rotate-pet-cafe-map$$;

UPDATE problems SET
    slug = $$rotate-pixel-art$$,
    title = $$Rotate Pixel Art$$,
    description = $$You are developing a pixel art editor.

A pixel art image is represented as an `n x n` integer grid, where each integer represents the color of a pixel.

Users want to rotate their artwork 90 degrees clockwise. However, the editor has limited memory, so you cannot create a separate array to store the rotated image.

Given an `n x n` integer grid `image`, implement `rotateImage` to rotate the image 90 degrees clockwise.

- You must modify the original `image` array directly.
- Do not allocate a second `n x n` array.

**Example 1:**
```
Input: image = [[2,4,6],[8,1,3],[5,7,9]]
Output: [[5,8,2],[7,1,4],[9,3,6]]
```

```diagram-grid
cells: [[2,4,6],[8,1,3],[5,7,9]]
after: [[5,8,2],[7,1,4],[9,3,6]]
```

**Example 2:**
```
Input: image = [[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]
Output: [[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]
```

```diagram-grid
cells: [[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]
after: [[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]
```$$,
    constraints = $$- `n == image.length == image[i].length`
- `1 <= n <= 20`
- `-1000 <= image[i][j] <= 1000`$$
WHERE slug = $$rotate-pet-cafe-map$$;

UPDATE problem_translations SET
    title = $$픽셀 아트 회전$$,
    description = $$픽셀 아트 편집기를 개발하고 있습니다.

사용자가 만든 픽셀 아트 이미지는 각 픽셀의 색상 번호를 저장하는 `n x n` 정수 격자로 표현됩니다.

사용자가 이미지를 시계 방향으로 90도 회전하려고 합니다. 하지만 편집기의 메모리가 제한되어 있어 새로운 이미지 배열을 생성할 수 없습니다.

`n x n` 정수 격자 `image`가 주어집니다. `rotateImage` 함수를 구현하여 이미지를 시계 방향으로 90도 회전하세요.

- 기존 `image` 배열을 직접 수정해야 합니다.
- 새로운 `n x n` 배열을 생성해서는 안 됩니다.

**예시 1:**
```
입력: image = [[2,4,6],[8,1,3],[5,7,9]]
출력: [[5,8,2],[7,1,4],[9,3,6]]
```

```diagram-grid
cells: [[2,4,6],[8,1,3],[5,7,9]]
after: [[5,8,2],[7,1,4],[9,3,6]]
```

**예시 2:**
```
입력: image = [[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]
출력: [[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]
```

```diagram-grid
cells: [[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]
after: [[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]
```$$,
    constraints = $$- `n == image.length == image[i].length`
- `1 <= n <= 20`
- `-1000 <= image[i][j] <= 1000`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$rotate-pixel-art$$);
