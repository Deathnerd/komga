ALTER TABLE book
    ADD COLUMN number FLOAT4 DEFAULT 0;
UPDATE book
SET number = (index + 1);
ALTER TABLE book
    DROP COLUMN index;
