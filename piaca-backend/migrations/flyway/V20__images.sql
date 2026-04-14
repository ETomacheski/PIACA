CREATE TABLE images (
    id UUID DEFAULT gen_random_uuid(),
    file_name VARCHAR(255),
    s3_url TEXT,
    pet_id UUID,
    createdAt DATE,
    updatedAt DATE,
    CONSTRAINT pk_images PRIMARY KEY (id),
    CONSTRAINT fk_images_pet FOREIGN KEY (pet_id) REFERENCES pets(id)
);