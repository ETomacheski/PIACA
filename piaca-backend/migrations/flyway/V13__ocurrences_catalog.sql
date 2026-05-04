CREATE TABLE occurrences_catalog (
    id UUID DEFAULT gen_random_uuid(),
    type VARCHAR(100),
    created_at DATE,
    updated_at DATE,
    CONSTRAINT pk_occurrences_catalog PRIMARY KEY (id),
    CONSTRAINT uq_occurrences_catalog_type UNIQUE (type)
);