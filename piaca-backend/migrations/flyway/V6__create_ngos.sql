CREATE TABLE ngos (
    id UUID DEFAULT gen_random_uuid(),
    name VARCHAR(255),
    CONSTRAINT pk_ngos PRIMARY KEY (id)
);