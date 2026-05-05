const { Router } = require("express");
const { makeRequireAuth } = require("./auth-middleware");

function buildAuthRoutes({ authController, tokenService, pool }) {
  const router = Router();
  const requireAuth = makeRequireAuth({ tokenService });

  router.get("/auth/health", async (_req, res) => {
    try {
      await pool.query("SELECT 1");
      res.json({ status: "ok" });
    } catch (err) {
      res.status(500).json({ status: "error", error: err.message });
    }
  });

  router.post("/auth/signup", authController.signup);
  router.post("/auth/login", authController.login);
  router.get("/auth/me", requireAuth, authController.me);

  return router;
}

module.exports = { buildAuthRoutes };
