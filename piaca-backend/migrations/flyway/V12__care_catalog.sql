CREATE TABLE care_catalog (
    id UUID DEFAULT gen_random_uuid(),
    type VARCHAR(100),
    createdAt DATE,
    updatedAt DATE,
    CONSTRAINT pk_care_catalog PRIMARY KEY (id),
    CONSTRAINT uq_care_catalog_type UNIQUE (type)
);