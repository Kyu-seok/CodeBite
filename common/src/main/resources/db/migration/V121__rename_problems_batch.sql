-- V121: structural rename (slug + title) for one rewrite batch
-- Driver folders, starter folders, and embedded method names are moved
-- separately; this migration only updates the problems table.

UPDATE problems SET slug = 'shelf-stock-pair', title = 'Shelf Stock Pair' WHERE slug = 'pair-sum';
