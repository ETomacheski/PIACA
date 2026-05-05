const { UserNotFoundError } = require("../../domain/errors");

class GetUserProfile {
  constructor({ userRepository, roleRepository }) {
    this.userRepository = userRepository;
    this.roleRepository = roleRepository;
  }

  async execute({ userId }) {
    const user = await this.userRepository.findById(userId);
    if (!user) throw new UserNotFoundError();

    const roles = await this.roleRepository.findRolesByUserId(user.id);
    return { user, roles };
  }
}

module.exports = { GetUserProfile };
