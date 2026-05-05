function makeRequireAuth({ tokenService }) {
  return function requireAuth(req, res, next) {
    const header = req.headers.authorization || "";
    const [scheme, token] = header.split(" ");

    if (scheme !== "Bearer" || !token) {
      return res.status(401).json({ error: "missing bearer token" });
    }

    try {
      req.auth = tokenService.verify(token);
      next();
    } catch {
      return res.status(401).json({ error: "invalid token" });
    }
  };
}

module.exports = { makeRequireAuth };
