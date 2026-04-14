CREATE TABLE pet_diseases (
    id UUID DEFAULT gen_random_uuid(),
    pet_id UUID,
    name VARCHAR(255),
    createdAt DATE,
    updatedAt DATE,
    CONSTRAINT pk_pet_diseases PRIMARY KEY (id),
    CONSTRAINT fk_pet_diseases_pet FOREIGN KEY (pet_id) REFERENCES pets(id)
);