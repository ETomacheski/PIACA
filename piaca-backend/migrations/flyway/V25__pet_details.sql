CREATE TABLE pet_details (
    id UUID DEFAULT gen_random_uuid(),
    pet_id UUID,
    breed VARCHAR(100),
    pet_size VARCHAR(50),
    pet_weight FLOAT,
    coat VARCHAR(100),
    color VARCHAR(100),
    reactivity TEXT,
    microchip BOOLEAN,
    createdAt DATE,
    updatedAt DATE,
    CONSTRAINT pk_pet_details PRIMARY KEY (id),
    CONSTRAINT uq_pet_details_pet UNIQUE (pet_id),
    CONSTRAINT fk_pet_details_pet FOREIGN KEY (pet_id) REFERENCES pets(id)
);