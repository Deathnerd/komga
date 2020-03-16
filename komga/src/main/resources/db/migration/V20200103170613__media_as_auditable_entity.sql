ALTER TABLE media
    ADD COLUMN created_date TIMESTAMP;
ALTER TABLE media
    ADD COLUMN last_modified_date TIMESTAMP;

UPDATE media
SET created_date       = CURRENT_TIMESTAMP,
    last_modified_date = CURRENT_TIMESTAMP;

ALTER TABLE media
    ALTER COLUMN created_date SET NOT NULL;
ALTER TABLE media
    ALTER COLUMN last_modified_date SET NOT NULL;
