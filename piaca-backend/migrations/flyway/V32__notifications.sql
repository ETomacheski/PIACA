CREATE TABLE notifications (
    id UUID DEFAULT gen_random_uuid(),
    message TEXT,
    date TIMESTAMP,
    donation_id UUID,
    createdAt DATE,
    updatedAt DATE,
    CONSTRAINT pk_notifications PRIMARY KEY (id),
    CONSTRAINT uq_notifications_donation UNIQUE (donation_id),
    CONSTRAINT fk_notifications_donation FOREIGN KEY (donation_id) REFERENCES donations(id)
);
