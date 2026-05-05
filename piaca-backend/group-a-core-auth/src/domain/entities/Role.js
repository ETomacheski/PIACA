const ROLE_TYPES = Object.freeze(["ngo", "protector", "adopter", "sponsor", "admin"]);
const ASSIGNABLE_AT_SIGNUP = Object.freeze(["ngo", "protector", "adopter", "sponsor"]);

class Role {
  constructor({ id, type, description }) {
    this.id = id;
    this.type = type;
    this.description = description;
  }
}

function isValidRoleType(type) {
  return ROLE_TYPES.includes(type);
}

function isAssignableAtSignup(type) {
  return ASSIGNABLE_AT_SIGNUP.includes(type);
}

module.exports = { Role, ROLE_TYPES, ASSIGNABLE_AT_SIGNUP, isValidRoleType, isAssignableAtSignup };
