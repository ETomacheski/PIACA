CREATE TABLE temperament_catalog (
    id UUID DEFAULT gen_random_uuid(),
    type VARCHAR(100),
    createdAt DATE,
    updatedAt DATE,
    CONSTRAINT pk_temperament_catalog PRIMARY KEY (id),
    CONSTRAINT uq_temperament_catalog_type UNIQUE (type)
);