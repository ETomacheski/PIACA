CREATE TABLE sponsors (
    id UUID DEFAULT gen_random_uuid(),
    name VARCHAR(255),
    user_id UUID,
    createdAt DATE,
    updatedAt DATE,
    CONSTRAINT pk_sponsors PRIMARY KEY (id),
    CONSTRAINT uq_sponsors_user UNIQUE (user_id),
    CONSTRAINT fk_sponsors_user FOREIGN KEY (user_id) REFERENCES users(id)
);