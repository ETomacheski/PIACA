CREATE TABLE questionnaire_responses (
    id UUID DEFAULT gen_random_uuid(),
    family_size INT,
    routine TEXT,
    user_id UUID,
    CONSTRAINT pk_questionnaire PRIMARY KEY (id),
    CONSTRAINT uq_questionnaire_user UNIQUE (user_id),
    CONSTRAINT fk_questionnaire_user FOREIGN KEY (user_id) REFERENCES users(id)
);