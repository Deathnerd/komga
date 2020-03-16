CREATE TABLE IF NOT EXISTS series_metadata
(
    id                 BIGINT    NOT NULL,
    created_date       TIMESTAMP NOT NULL,
    last_modified_date TIMESTAMP NOT NULL,
    status             VARCHAR   NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE series
    ADD COLUMN metadata_id BIGINT;

ALTER TABLE series
    ADD CONSTRAINT fk_series_series_metadata_metadata_id FOREIGN KEY (metadata_id) REFERENCES series_metadata (id);
