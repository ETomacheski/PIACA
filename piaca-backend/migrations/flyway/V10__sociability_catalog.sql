CREATE TABLE sociability_catalog (
    id UUID DEFAULT gen_random_uuid(),
    title VARCHAR(100),
    CONSTRAINT pk_sociability_catalog PRIMARY KEY (id),
    CONSTRAINT uq_sociability_catalog_title UNIQUE (title)
);