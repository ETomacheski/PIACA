CREATE TABLE attachments (
    id UUID DEFAULT gen_random_uuid(),
    occurrence_id UUID,
    file_name VARCHAR(255),
    s3_url TEXT,
    createdAt DATE,
    updatedAt DATE,
    CONSTRAINT pk_attachments PRIMARY KEY (id),
    CONSTRAINT fk_attachments_occurrence FOREIGN KEY (occurrence_id) REFERENCES occurrences(id)
);
