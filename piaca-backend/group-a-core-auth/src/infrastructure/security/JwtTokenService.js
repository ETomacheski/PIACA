const jwt = require("jsonwebtoken");

class JwtTokenService {
  constructor({ secret, expiresIn = "7d" }) {
    if (!secret) throw new Error("JwtTokenService: secret e obrigatorio");
    this.secret = secret;
    this.expiresIn = expiresIn;
  }

  sign(payload) {
    return jwt.sign(payload, this.secret, { expiresIn: this.expiresIn });
  }

  verify(token) {
    return jwt.verify(token, this.secret);
  }
}

module.exports = { JwtTokenService };
