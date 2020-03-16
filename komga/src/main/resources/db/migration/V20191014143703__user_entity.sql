CREATE TABLE IF NOT EXISTS "user"
(
    id                 BIGINT    NOT NULL,
    created_date       TIMESTAMP NOT NULL,
    last_modified_date TIMESTAMP NOT NULL,
    email              VARCHAR   NOT NULL,
    password           VARCHAR   NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE "user"
    ADD CONSTRAINT uk_user_login UNIQUE (email);

CREATE TABLE IF NOT EXISTS user_role
(
    user_id BIGINT NOT NULL,
    roles   VARCHAR
);

ALTER TABLE user_role
    ADD CONSTRAINT fk_user_role_user_user_id FOREIGN KEY (user_id) REFERENCES "user" (id);
