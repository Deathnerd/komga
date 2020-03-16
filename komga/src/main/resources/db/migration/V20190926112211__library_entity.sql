CREATE TABLE IF NOT EXISTS library
(
    id                 BIGINT    NOT NULL,
    created_date       TIMESTAMP NOT NULL,
    last_modified_date TIMESTAMP NOT NULL,
    name               VARCHAR   NOT NULL,
    root               VARCHAR   NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE library
    ADD CONSTRAINT uk_library_name UNIQUE (name);

ALTER TABLE serie
    ADD COLUMN library_id BIGINT;

ALTER TABLE serie
    ADD CONSTRAINT fk_serie_library_library_id FOREIGN KEY (library_id) REFERENCES library (id);
