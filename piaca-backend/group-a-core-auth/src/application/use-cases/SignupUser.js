const {
  EmailAlreadyTakenError,
  InvalidRoleError,
  RoleNotFoundError
} = require("../../domain/errors");
const { isAssignableAtSignup } = require("../../domain/entities/Role");

class SignupUser {
  constructor({ userRepository, roleRepository, passwordHasher, tokenService, transactionRunner }) {
    this.userRepository = userRepository;
    this.roleRepository = roleRepository;
    this.passwordHasher = passwordHasher;
    this.tokenService = tokenService;
    this.transactionRunner = transactionRunner;
  }

  async execute({ email, password, roleType }) {
    if (!isAssignableAtSignup(roleType)) {
      throw new InvalidRoleError(roleType);
    }

    const passwordHash = await this.passwordHasher.hash(password);

    return this.transactionRunner.run(async (tx) => {
      const existing = await this.userRepository.findByEmail(email, { tx });
      if (existing) throw new EmailAlreadyTakenError();

      const role = await this.roleRepository.findByType(roleType, { tx });
      if (!role) throw new RoleNotFoundError(roleType);

      const user = await this.userRepository.create({ email, passwordHash }, { tx });
      await this.roleRepository.assignRoleToUser(user.id, role.id, { tx });

      const token = this.tokenService.sign({
        sub: user.id,
        email: user.email,
        roles: [role.type]
      });

      return { user, roles: [role], token };
    });
  }
}

module.exports = { SignupUser };
