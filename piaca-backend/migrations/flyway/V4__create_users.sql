CREATE TABLE users (
    id UUID DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL,
    password_hash TEXT NOT NULL,
    status INT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    CONSTRAINT pk_users PRIMARY KEY (id),
    CONSTRAINT uq_users_email UNIQUE (email)
);