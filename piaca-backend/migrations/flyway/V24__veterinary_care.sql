CREATE TABLE veterinary_care (
    id UUID DEFAULT gen_random_uuid(),
    pet_id UUID,
    type VARCHAR(100),
    CONSTRAINT pk_veterinary_care PRIMARY KEY (id),
    CONSTRAINT fk_veterinary_care_pet FOREIGN KEY (pet_id) REFERENCES pets(id)
);