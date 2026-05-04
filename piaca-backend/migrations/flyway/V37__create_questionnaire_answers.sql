CREATE TABLE questionnaire_answers (
    id UUID DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    submitted_at DATE,
    created_at DATE,
    updated_at DATE,
    CONSTRAINT pk_questionnaire_answers PRIMARY KEY (id),
    CONSTRAINT fk_questionnaire_answers_user
        FOREIGN KEY (user_id) REFERENCES users(id)
);