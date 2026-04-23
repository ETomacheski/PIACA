CREATE TABLE pet_temperament (
    id UUID DEFAULT gen_random_uuid(),
    pet_id UUID,
    type VARCHAR(100),
    created_at DATE,
    updated_at DATE,
    CONSTRAINT pk_pet_temperament PRIMARY KEY (id),
    CONSTRAINT fk_pet_temperament_pet FOREIGN KEY (pet_id) REFERENCES pets(id)
);