CREATE TABLE pet_details (
    id UUID DEFAULT gen_random_uuid(),
    pet_id UUID,
    breed VARCHAR(100),
    size VARCHAR(50),
    weight FLOAT,
    coat VARCHAR(100),
    color VARCHAR(100),
    reactivity TEXT,
    microchip BOOLEAN,
    CONSTRAINT pk_pet_details PRIMARY KEY (id),
    CONSTRAINT uq_pet_details_pet UNIQUE (pet_id),
    CONSTRAINT fk_pet_details_pet FOREIGN KEY (pet_id) REFERENCES pets(id)
);