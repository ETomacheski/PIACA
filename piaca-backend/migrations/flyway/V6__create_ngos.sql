CREATE TABLE ngos (
    id UUID DEFAULT gen_random_uuid(),
    name VARCHAR(255),
    created_at DATE,
    updated_at DATE,
    CONSTRAINT pk_ngos PRIMARY KEY (id)
);