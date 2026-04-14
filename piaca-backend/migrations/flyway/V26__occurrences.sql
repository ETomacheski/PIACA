CREATE TABLE occurrences (
    id UUID DEFAULT gen_random_uuid(),
    pet_id UUID,
    type VARCHAR(100),
    title VARCHAR(255),
    description TEXT,
    createdAt DATE,
    updatedAt DATE,
    CONSTRAINT pk_occurrences PRIMARY KEY (id),
    CONSTRAINT fk_occurrences_pet FOREIGN KEY (pet_id) REFERENCES pets(id)
);
