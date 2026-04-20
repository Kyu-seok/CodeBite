-- =============================================
-- Batch 14: Regenerate hidden test cases
-- Problems: remove-from-end, remove-sorted-dupes, reorder-list,
--           reverse-k-nodes, reverse-list, right-pointers,
--           right-side-view, ring-buffer, rising-tide, room-builder
-- =============================================

-- #1 remove-from-end
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'remove-from-end')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'remove-from-end')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'remove-from-end'), E'[1,2]\n2', '[2]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'remove-from-end'), E'[1,2,3,4,5,6,7]\n4', '[1,2,3,5,6,7]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'remove-from-end'), E'[1,2,3]\n3', '[2,3]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'remove-from-end'), E'[1,2,3]\n1', '[1,2]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'remove-from-end'), E'[10]\n1', '[]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'remove-from-end'), E'[100,200,300,400,500]\n5', '[200,300,400,500]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'remove-from-end'), E'[5,10]\n2', '[10]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'remove-from-end'), E'[1,2,3]\n2', '[1,3]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'remove-from-end'), E'[1,2,3,4,5,6,7,8,9,10]\n1', '[1,2,3,4,5,6,7,8,9]', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'remove-from-end'), E'[1,2,3,4,5,6,7,8,9,10]\n5', '[1,2,3,4,5,7,8,9,10]', FALSE, 13);

-- #2 remove-sorted-dupes
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'remove-sorted-dupes')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'remove-sorted-dupes')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'), '[5,5,5,5,5,5,5,5,5,5]', E'1\n[5]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'), '[1,2,3,4,5,6,7,8]', E'8\n[1,2,3,4,5,6,7,8]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'), '[3,3]', E'1\n[3]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'), '[1,2]', E'2\n[1,2]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'), '[0]', E'1\n[0]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'), '[-5,-5,-3,-1,-1,0,0,2,4,4,4]', E'6\n[-5,-3,-1,0,2,4]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'), '[-100,-100,0,0,100,100]', E'3\n[-100,0,100]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'), '[1,1,2,2,3,3,4,4,5,5]', E'5\n[1,2,3,4,5]', FALSE, 11);

-- #3 reorder-list
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reorder-list')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reorder-list')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'reorder-list'), '[1]', '[1]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'reorder-list'), '[1,2]', '[1,2]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'reorder-list'), '[1,2,3]', '[1,3,2]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'reorder-list'), '[1,2,3,4,5,6]', '[1,6,2,5,3,4]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'reorder-list'), '[1,2,3,4,5,6,7]', '[1,7,2,6,3,5,4]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'reorder-list'), '[1,2,3,4,5,6,7,8]', '[1,8,2,7,3,6,4,5]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'reorder-list'), '[10,20,30,40,50]', '[10,50,20,40,30]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'reorder-list'), '[1,2,3,4,5,6,7,8,9,10]', '[1,10,2,9,3,8,4,7,5,6]', FALSE, 10);

-- #4 reverse-k-nodes
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reverse-k-nodes')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reverse-k-nodes')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'reverse-k-nodes'), E'[1,2,3,4,5]\n1', '[1,2,3,4,5]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'reverse-k-nodes'), E'[1,2,3,4,5]\n5', '[5,4,3,2,1]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'reverse-k-nodes'), E'[1,2,3,4,5,6]\n2', '[2,1,4,3,6,5]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'reverse-k-nodes'), E'[1,2,3,4,5]\n2', '[2,1,4,3,5]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'reverse-k-nodes'), E'[1,2,3,4,5,6,7,8,9]\n3', '[3,2,1,6,5,4,9,8,7]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'reverse-k-nodes'), E'[1,2,3,4,5,6,7]\n4', '[4,3,2,1,5,6,7]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'reverse-k-nodes'), E'[1]\n1', '[1]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'reverse-k-nodes'), E'[1,2]\n2', '[2,1]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'reverse-k-nodes'), E'[1,2,3,4,5,6,7,8]\n3', '[3,2,1,6,5,4,7,8]', FALSE, 12);

-- #5 reverse-list
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reverse-list')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reverse-list')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'reverse-list'), '[]', '[]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'reverse-list'), '[1]', '[1]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'reverse-list'), '[1,2]', '[2,1]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'reverse-list'), '[1,2,3]', '[3,2,1]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'reverse-list'), '[1,2,3,4,5,6,7,8,9,10]', '[10,9,8,7,6,5,4,3,2,1]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'reverse-list'), '[-1,-2,-3]', '[-3,-2,-1]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'reverse-list'), '[5,10,15,20]', '[20,15,10,5]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'reverse-list'), '[7,7,7,7]', '[7,7,7,7]', FALSE, 11);

-- #6 right-pointers
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'right-pointers')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'right-pointers')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'right-pointers'), '[]', '[]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'right-pointers'), '[1]', '[1,#]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'right-pointers'), '[1,2,3]', '[1,#,2,3,#]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'right-pointers'), '[1,2,3,4,5,6,7]', '[1,#,2,3,#,4,5,6,7,#]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'right-pointers'), '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]', '[1,#,2,3,#,4,5,6,7,#,8,9,10,11,12,13,14,15,#]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'right-pointers'), '[10,20,30,40,50,60,70]', '[10,#,20,30,#,40,50,60,70,#]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'right-pointers'), '[-1,-2,-3,-4,-5,-6,-7]', '[-1,#,-2,-3,#,-4,-5,-6,-7,#]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'right-pointers'), '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]', '[1,#,2,3,#,4,5,6,7,#,8,9,10,11,12,13,14,15,#,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,#]', FALSE, 11);

-- #7 right-side-view
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'right-side-view')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'right-side-view')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'right-side-view'), '[]', '[]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'right-side-view'), '[1]', '[1]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'right-side-view'), '[1,2,null,3]', '[1,2,3]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'right-side-view'), '[1,null,2,null,3]', '[1,2,3]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'right-side-view'), '[1,2,3,4,5,6,7]', '[1,3,7]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'right-side-view'), '[1,2,3,4,5]', '[1,3,5]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'right-side-view'), '[1,2,3,null,5,null,4,null,null,6]', '[1,3,4,6]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'right-side-view'), '[1,2,null,3,null,4]', '[1,2,3,4]', FALSE, 11);

-- #8 ring-buffer
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ring-buffer')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ring-buffer')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'ring-buffer'), E'["RingBuffer","enQueue","isFull","enQueue","deQueue","enQueue","rear","front","isEmpty"]\n[[1],[42],[],[99],[],[99],[],[],[]]', '[null,true,true,false,true,true,99,99,false]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'ring-buffer'), E'["RingBuffer","enQueue","enQueue","deQueue","deQueue","enQueue","enQueue","front","rear"]\n[[3],[10],[20],[],[],[30],[40],[],[]]', '[null,true,true,true,true,true,true,30,40]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'ring-buffer'), E'["RingBuffer","isEmpty","front","rear","deQueue","enQueue","isEmpty"]\n[[5],[],[],[],[],[1],[]]', '[null,true,-1,-1,false,true,false]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'ring-buffer'), E'["RingBuffer","enQueue","enQueue","enQueue","isFull","deQueue","deQueue","deQueue","isEmpty","enQueue","enQueue","front","rear"]\n[[3],[1],[2],[3],[],[],[],[],[],[4],[5],[],[]]', '[null,true,true,true,true,true,true,true,true,true,true,4,5]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'ring-buffer'), E'["RingBuffer","enQueue","deQueue","enQueue","deQueue","enQueue","deQueue","enQueue","front","rear"]\n[[1],[1],[],[2],[],[3],[],[4],[],[]]', '[null,true,true,true,true,true,true,true,4,4]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'ring-buffer'), E'["RingBuffer","enQueue","enQueue","enQueue","front","rear","isFull","isEmpty","deQueue","front"]\n[[10],[100],[200],[300],[],[],[],[],[],[]]', '[null,true,true,true,100,300,false,false,true,200]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'ring-buffer'), E'["RingBuffer","enQueue","enQueue","deQueue","enQueue","deQueue","enQueue","front","rear","isFull"]\n[[2],[1],[2],[],[3],[],[4],[],[],[]]', '[null,true,true,true,true,true,true,3,4,true]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'ring-buffer'), E'["RingBuffer","deQueue","front","rear","enQueue","enQueue","enQueue","enQueue","isFull","front","rear"]\n[[3],[],[],[],[5],[10],[15],[20],[],[],[]]', '[null,false,-1,-1,true,true,true,false,true,5,15]', FALSE, 11);

-- #9 rising-tide
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rising-tide')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rising-tide')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'rising-tide'), '[[0]]', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'rising-tide'), '[[0,1],[2,3]]', '3', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'rising-tide'), '[[5,3,1],[2,4,6],[0,7,8]]', '8', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'rising-tide'), '[[0,10],[10,0]]', '10', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'rising-tide'), '[[0,1,2],[3,4,5],[6,7,8]]', '8', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'rising-tide'), '[[9,1,0],[8,2,3],[7,6,5]]', '9', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'rising-tide'), '[[0,100,100,100],[1,100,100,100],[2,100,100,100],[3,4,5,6]]', '6', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'rising-tide'), '[[0,1,2,3],[15,14,13,4],[8,9,10,5],[7,12,11,6]]', '6', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'rising-tide'), '[[0,2,4],[1,3,5],[6,7,8]]', '8', FALSE, 12);

-- #10 room-builder
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'room-builder')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'room-builder')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'room-builder'), '[-1]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'room-builder'), '[-1,0]', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'room-builder'), '[-1,0,0]', '2', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'room-builder'), '[-1,0,0,0,0]', '24', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'room-builder'), '[-1,0,0,1,1,2,2]', '80', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'room-builder'), '[-1,0,0,0,1,1,2,3,3]', '2240', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'room-builder'), '[-1,0,1,2,3]', '1', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'room-builder'), '[-1,0,0,2,2,1,1,1,1,8,1,9,6,0,0,1,6,7,16,0]', '678300570', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'room-builder'), '[-1,0,0,1,1,2,2,3,3,4,4,5,5,6,6]', '21964800', FALSE, 12);
