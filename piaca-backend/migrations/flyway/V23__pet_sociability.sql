CREATE TABLE pet_sociability (
    id UUID DEFAULT gen_random_uuid(),
    pet_id UUID,
    title VARCHAR(100),
    createdAt DATE,
    updatedAt DATE,
    CONSTRAINT pk_pet_sociability PRIMARY KEY (id),
    CONSTRAINT fk_pet_sociability_pet FOREIGN KEY (pet_id) REFERENCES pets(id)
);