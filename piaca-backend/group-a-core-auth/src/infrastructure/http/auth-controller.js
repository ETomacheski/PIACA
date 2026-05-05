const { DomainError } = require("../../domain/errors");
const { validateSignupBody, validateLoginBody } = require("./validators");

function userToDto(user) {
  return {
    id: user.id,
    email: user.email,
    status: user.status,
    createdAt: user.createdAt,
    updatedAt: user.updatedAt
  };
}

function roleToDto(role) {
  return {
    id: role.id,
    type: role.type,
    description: role.description
  };
}

function authResponse({ user, roles, token }) {
  return {
    token,
    user: userToDto(user),
    roles: roles.map(roleToDto)
  };
}

function handleError(res, err, label) {
  if (err instanceof DomainError) {
    return res.status(err.statusCode).json({ error: err.message, code: err.code });
  }
  console.error(`[${label}] erro:`, err);
  return res.status(500).json({ error: "internal error" });
}

class AuthController {
  constructor({ signupUser, loginUser, getUserProfile }) {
    this.signupUser = signupUser;
    this.loginUser = loginUser;
    this.getUserProfile = getUserProfile;
  }

  signup = async (req, res) => {
    const validationError = validateSignupBody(req.body);
    if (validationError) return res.status(400).json({ error: validationError });

    try {
      const result = await this.signupUser.execute({
        email: req.body.email,
        password: req.body.password,
        roleType: req.body.role
      });
      res.status(201).json(authResponse(result));
    } catch (err) {
      handleError(res, err, "/auth/signup");
    }
  };

  login = async (req, res) => {
    const validationError = validateLoginBody(req.body);
    if (validationError) return res.status(400).json({ error: validationError });

    try {
      const result = await this.loginUser.execute({
        email: req.body.email,
        password: req.body.password
      });
      res.json(authResponse(result));
    } catch (err) {
      handleError(res, err, "/auth/login");
    }
  };

  me = async (req, res) => {
    try {
      const result = await this.getUserProfile.execute({ userId: req.auth.sub });
      res.json({
        user: userToDto(result.user),
        roles: result.roles.map(roleToDto)
      });
    } catch (err) {
      handleError(res, err, "/auth/me");
    }
  };
}

module.exports = { AuthController };
