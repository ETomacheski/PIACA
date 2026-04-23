CREATE TABLE adoptions (
    id UUID DEFAULT gen_random_uuid(),
    status INT,
    adopter_id UUID,
    pet_id UUID,
    created_at DATE,
    updated_at DATE,
    CONSTRAINT pk_adoptions PRIMARY KEY (id),
    CONSTRAINT fk_adoptions_adopter FOREIGN KEY (adopter_id) REFERENCES adopters(id),
    CONSTRAINT fk_adoptions_pet FOREIGN KEY (pet_id) REFERENCES pets(id)
);
