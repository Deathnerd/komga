ALTER TABLE series
    ALTER COLUMN metadata_id SET NOT NULL;
ALTER TABLE series_metadata
    ADD COLUMN
        status_lock BOOLEAN DEFAULT FALSE;
ALTER TABLE series_metadata
    ADD COLUMN
        title VARCHAR;
ALTER TABLE series_metadata
    ADD COLUMN
        title_lock BOOLEAN DEFAULT FALSE;
ALTER TABLE series_metadata
    ADD COLUMN
        title_sort VARCHAR;
ALTER TABLE series_metadata
    ADD COLUMN
        title_sort_lock BOOLEAN DEFAULT FALSE;

UPDATE series_metadata AS m
SET title      = (SELECT name FROM series WHERE metadata_id = m.id),
    title_sort = (SELECT name FROM series WHERE metadata_id = m.id);

ALTER TABLE series_metadata
    ALTER COLUMN title SET NOT NULL;

ALTER TABLE series_metadata
    ALTER COLUMN title_sort SET NOT NULL;
