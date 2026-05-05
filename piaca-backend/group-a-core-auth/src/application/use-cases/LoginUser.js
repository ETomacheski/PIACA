const { InvalidCredentialsError } = require("../../domain/errors");

class LoginUser {
  constructor({ userRepository, roleRepository, passwordHasher, tokenService }) {
    this.userRepository = userRepository;
    this.roleRepository = roleRepository;
    this.passwordHasher = passwordHasher;
    this.tokenService = tokenService;
  }

  async execute({ email, password }) {
    const credentials = await this.userRepository.findCredentialsByEmail(email);
    if (!credentials) throw new InvalidCredentialsError();

    const ok = await this.passwordHasher.verify(password, credentials.passwordHash);
    if (!ok) throw new InvalidCredentialsError();

    const roles = await this.roleRepository.findRolesByUserId(credentials.user.id);

    const token = this.tokenService.sign({
      sub: credentials.user.id,
      email: credentials.user.email,
      roles: roles.map((r) => r.type)
    });

    return { user: credentials.user, roles, token };
  }
}

module.exports = { LoginUser };
