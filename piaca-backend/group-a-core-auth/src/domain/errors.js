class DomainError extends Error {
  constructor(message, { code, statusCode } = {}) {
    super(message);
    this.name = this.constructor.name;
    this.code = code || "DOMAIN_ERROR";
    this.statusCode = statusCode || 400;
  }
}

class EmailAlreadyTakenError extends DomainError {
  constructor() {
    super("email ja cadastrado", { code: "EMAIL_ALREADY_TAKEN", statusCode: 409 });
  }
}

class InvalidCredentialsError extends DomainError {
  constructor() {
    super("credenciais invalidas", { code: "INVALID_CREDENTIALS", statusCode: 401 });
  }
}

class InvalidRoleError extends DomainError {
  constructor(roleType) {
    super(`role invalida: ${roleType}`, { code: "INVALID_ROLE", statusCode: 400 });
  }
}

class RoleNotFoundError extends DomainError {
  constructor(roleType) {
    super(`role nao encontrada: ${roleType}`, { code: "ROLE_NOT_FOUND", statusCode: 500 });
  }
}

class UserNotFoundError extends DomainError {
  constructor() {
    super("user nao encontrado", { code: "USER_NOT_FOUND", statusCode: 404 });
  }
}

module.exports = {
  DomainError,
  EmailAlreadyTakenError,
  InvalidCredentialsError,
  InvalidRoleError,
  RoleNotFoundError,
  UserNotFoundError
};
