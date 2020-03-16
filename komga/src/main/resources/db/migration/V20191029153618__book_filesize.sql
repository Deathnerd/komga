ALTER TABLE book
    ADD COLUMN file_size BIGINT DEFAULT 0;

-- force rescan to update file size of all books
UPDATE series
SET file_last_modified = '1970-01-01 00:00:00';
UPDATE book
SET file_last_modified = '1970-01-01 00:00:00';
