-- CREATE BASE TABLES
-- ADDED 0.1.0
-- Every id is a UUIDv7 generated in Rust (Uuid::now_v7()), so there is no DEFAULT.
-- unit has no DEFAULT: the app always supplies it.

CREATE TABLE users (
    id            UUID PRIMARY KEY,
    name          TEXT NOT NULL,
    mail          TEXT NOT NULL,
    password_hash TEXT NOT NULL
);

CREATE TABLE lists (
    id          UUID PRIMARY KEY,
    owner_id    UUID NOT NULL REFERENCES users,
    name        TEXT NOT NULL,
    description TEXT
);

CREATE TABLE items (
    id          UUID PRIMARY KEY,
    list_id     UUID           NOT NULL REFERENCES lists ON DELETE CASCADE,
    name        TEXT           NOT NULL,
    description TEXT,
    category    TEXT,
    price       NUMERIC(10, 2),
    amount      NUMERIC(10, 2) NOT NULL,
    unit        TEXT           NOT NULL,
    url         TEXT,
    photo       TEXT,
    bought      BOOLEAN        NOT NULL DEFAULT false
);

CREATE TABLE allowed_users (
    list_id UUID NOT NULL REFERENCES lists ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users ON DELETE CASCADE,
    access  TEXT NOT NULL CHECK (access IN ('view', 'edit')),
    PRIMARY KEY (list_id, user_id)
);

CREATE TABLE recipes (
    id       UUID PRIMARY KEY,
    owner_id UUID NOT NULL REFERENCES users,
    name     TEXT NOT NULL,
    steps    TEXT
);

CREATE TABLE recipe_ingredients (
    id        UUID PRIMARY KEY,
    recipe_id UUID           NOT NULL REFERENCES recipes ON DELETE CASCADE,
    name      TEXT           NOT NULL,
    amount    NUMERIC(10, 2) NOT NULL,
    unit      TEXT           NOT NULL
);

-- Case-insensitive: Adam@x.com and adam@x.com are one account. I just learned it xd
CREATE UNIQUE INDEX users_index              ON users (lower(mail));
CREATE        INDEX lists_index              ON lists (owner_id);
CREATE UNIQUE INDEX items_index              ON items (list_id, lower(trim(name)), unit);
CREATE        INDEX allowed_users_index      ON allowed_users (user_id);
CREATE        INDEX recipes_index            ON recipes (owner_id);
CREATE UNIQUE INDEX recipe_ingredients_index ON recipe_ingredients (recipe_id, lower(trim(name)), unit);
