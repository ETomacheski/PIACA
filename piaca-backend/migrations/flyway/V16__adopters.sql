CREATE TABLE adopters (
    id UUID DEFAULT gen_random_uuid(),
    name VARCHAR(255),
    user_id UUID,
    created_at DATE,
    updated_at DATE,
    CONSTRAINT pk_adopters PRIMARY KEY (id),
    CONSTRAINT uq_adopters_user UNIQUE (user_id),
    CONSTRAINT fk_adopters_user FOREIGN KEY (user_id) REFERENCES users(id)
);