CREATE TABLE questionnaire_answer_items (
    id UUID DEFAULT gen_random_uuid(),
    questionnaire_answer_id UUID NOT NULL,
    question_id UUID NOT NULL,
    value TEXT,
    created_at DATE,
    updated_at DATE,

    CONSTRAINT pk_questionnaire_answer_items PRIMARY KEY (id),
    CONSTRAINT fk_qai_questionnaire_answer
        FOREIGN KEY (questionnaire_answer_id)
        REFERENCES questionnaire_answers(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_qai_question
        FOREIGN KEY (question_id)
        REFERENCES questions(id)
);