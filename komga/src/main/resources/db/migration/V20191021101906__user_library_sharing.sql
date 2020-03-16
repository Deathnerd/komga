ALTER TABLE "user"
    ADD COLUMN shared_all_libraries BOOLEAN NOT NULL DEFAULT TRUE;

CREATE TABLE IF NOT EXISTS user_library_sharing
(
    user_id    BIGINT NOT NULL,
    library_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, library_id)
);

ALTER TABLE user_library_sharing
    ADD CONSTRAINT fk_user_library_sharing_library_id FOREIGN KEY (library_id) REFERENCES library (id);

ALTER TABLE user_library_sharing
    ADD CONSTRAINT fk_user_library_sharing_user_id FOREIGN KEY (user_id) REFERENCES "user" (id);
