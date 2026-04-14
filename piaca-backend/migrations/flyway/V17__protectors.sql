CREATE TABLE protectors (
    id UUID DEFAULT gen_random_uuid(),
    name VARCHAR(255),
    user_id UUID,
    createdAt DATE,
    updatedAt DATE,
    CONSTRAINT pk_protectors PRIMARY KEY (id),
    CONSTRAINT uq_protectors_user UNIQUE (user_id),
    CONSTRAINT fk_protectors_user FOREIGN KEY (user_id) REFERENCES users(id)
);