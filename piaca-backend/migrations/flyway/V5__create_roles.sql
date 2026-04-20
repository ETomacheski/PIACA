CREATE TABLE roles (
    id UUID DEFAULT gen_random_uuid(),
    type_id VARCHAR(50),
    description TEXT,
    createdAt DATE,
    updatedAt DATE,
    CONSTRAINT pk_roles PRIMARY KEY (id)
);