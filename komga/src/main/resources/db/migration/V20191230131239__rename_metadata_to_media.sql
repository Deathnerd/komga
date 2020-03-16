ALTER TABLE book_metadata
    RENAME TO media;

ALTER TABLE book
    RENAME COLUMN book_metadata_id TO media_id;

ALTER TABLE book
    RENAME CONSTRAINT uk_book_book_metadata_id TO uk_book_media_id;

ALTER TABLE book
    RENAME CONSTRAINT fk_book_book_metadata_book_metadata_id TO fk_book_media_media_id;

ALTER TABLE book_metadata_page
    RENAME TO media_page;

ALTER TABLE media_page
    RENAME COLUMN book_metadata_id TO media_id;

ALTER TABLE media_page
    RENAME CONSTRAINT fk_book_metadata_page_book_metadata_book_metadata_id TO fk_media_page_media_media_id;

ALTER INDEX IF EXISTS uk_book_book_metadata_id_index_7 RENAME TO uk_book_media_id_index_7;
ALTER INDEX IF EXISTS fk_book_metadata_page_book_metadata_book_metadata_id_index_9 RENAME TO fk_media_page_media_media_id_index_9;
