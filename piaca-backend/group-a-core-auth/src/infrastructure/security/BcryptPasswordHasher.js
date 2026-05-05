const bcrypt = require("bcryptjs");

class BcryptPasswordHasher {
  constructor({ rounds = 10 } = {}) {
    this.rounds = rounds;
  }

  hash(password) {
    return bcrypt.hash(password, this.rounds);
  }

  verify(password, hash) {
    return bcrypt.compare(password, hash);
  }
}

module.exports = { BcryptPasswordHasher };
