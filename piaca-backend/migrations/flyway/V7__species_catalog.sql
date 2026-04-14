CREATE TABLE species_catalog (
    id UUID DEFAULT gen_random_uuid(),
    name VARCHAR(100),
    createdAt DATE,
    updatedAt DATE,
    CONSTRAINT pk_species_catalog PRIMARY KEY (id),
    CONSTRAINT uq_species_catalog_name UNIQUE (name)
);