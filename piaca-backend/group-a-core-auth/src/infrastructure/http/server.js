const express = require("express");

function buildServer({ routes }) {
  const app = express();
  app.use(express.json());

  app.use(routes);

  app.use((req, res) => {
    res.status(404).json({ error: "route not found", path: req.path });
  });

  return app;
}

module.exports = { buildServer };
