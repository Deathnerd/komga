ALTER TABLE serie
    RENAME TO series;

ALTER TABLE series
    RENAME CONSTRAINT fk_serie_library_library_id TO fk_series_library_library_id;

ALTER INDEX IF EXISTS fk_serie_library_library_id_index_4 RENAME TO fk_series_library_library_id_index_4;


ALTER TABLE book
    RENAME COLUMN serie_id TO series_id;

ALTER TABLE book
    RENAME CONSTRAINT fk_book_serie_serie_id TO fk_book_series_series_id;

ALTER INDEX IF EXISTS fk_book_serie_serie_id_index_1 RENAME TO fk_book_series_series_id_index_1;
