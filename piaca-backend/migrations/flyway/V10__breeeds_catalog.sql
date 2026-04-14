CREATE TABLE breeds_catalog (
    id UUID DEFAULT gen_random_uuid(),
    name VARCHAR(100),
    createdAt DATE,
    updatedAt DATE,
    CONSTRAINT pk_breeds_catalog PRIMARY KEY (id),
    CONSTRAINT uq_breeds_catalog_name UNIQUE (name)
);