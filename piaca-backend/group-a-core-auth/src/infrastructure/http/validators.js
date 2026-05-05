const { ASSIGNABLE_AT_SIGNUP } = require("../../domain/entities/Role");

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const MIN_PASSWORD = 6;

function validateSignupBody(body) {
  const { email, password, role } = body || {};
  if (!email || !EMAIL_RE.test(email)) return "email invalido";
  if (!password || password.length < MIN_PASSWORD) {
    return `senha precisa de no minimo ${MIN_PASSWORD} caracteres`;
  }
  if (!role || !ASSIGNABLE_AT_SIGNUP.includes(role)) {
    return `role precisa ser um de: ${ASSIGNABLE_AT_SIGNUP.join(", ")}`;
  }
  return null;
}

function validateLoginBody(body) {
  const { email, password } = body || {};
  if (!email || !password) return "email e password obrigatorios";
  return null;
}

module.exports = { validateSignupBody, validateLoginBody };
