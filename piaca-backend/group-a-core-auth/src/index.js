const { pool } = require("./infrastructure/db/pool");
const { PgTransactionRunner } = require("./infrastructure/db/PgTransactionRunner");
const { PgUserRepository } = require("./infrastructure/db/PgUserRepository");
const { PgRoleRepository } = require("./infrastructure/db/PgRoleRepository");
const { BcryptPasswordHasher } = require("./infrastructure/security/BcryptPasswordHasher");
const { JwtTokenService } = require("./infrastructure/security/JwtTokenService");
const { SignupUser } = require("./application/use-cases/SignupUser");
const { LoginUser } = require("./application/use-cases/LoginUser");
const { GetUserProfile } = require("./application/use-cases/GetUserProfile");
const { AuthController } = require("./infrastructure/http/auth-controller");
const { buildAuthRoutes } = require("./infrastructure/http/auth-routes");
const { buildServer } = require("./infrastructure/http/server");

const JWT_SECRET = process.env.JWT_SECRET;
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || "7d";
const PORT = Number(process.env.PORT || 3001);

if (!JWT_SECRET) {
  throw new Error("JWT_SECRET e obrigatorio no piaca-core-auth");
}

const transactionRunner = new PgTransactionRunner({ pool });
const userRepository = new PgUserRepository({ pool });
const roleRepository = new PgRoleRepository({ pool });
const passwordHasher = new BcryptPasswordHasher({ rounds: 10 });
const tokenService = new JwtTokenService({ secret: JWT_SECRET, expiresIn: JWT_EXPIRES_IN });

const signupUser = new SignupUser({
  userRepository,
  roleRepository,
  passwordHasher,
  tokenService,
  transactionRunner
});
const loginUser = new LoginUser({
  userRepository,
  roleRepository,
  passwordHasher,
  tokenService
});
const getUserProfile = new GetUserProfile({ userRepository, roleRepository });

const authController = new AuthController({ signupUser, loginUser, getUserProfile });
const routes = buildAuthRoutes({ authController, tokenService, pool });
const app = buildServer({ routes });

app.listen(PORT, () => {
  console.log(`piaca-core-auth listening on :${PORT}`);
});
