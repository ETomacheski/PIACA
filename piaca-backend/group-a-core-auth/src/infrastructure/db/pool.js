const { Pool } = require("pg");

const dbHost = process.env.DB_HOST || "localhost";
const dbSslMode = (process.env.DB_SSL_MODE || "auto").toLowerCase();
const dbSslRejectUnauthorized =
  (process.env.DB_SSL_REJECT_UNAUTHORIZED || "false").toLowerCase() === "true";

const shouldUseSsl =
  dbSslMode === "require" ||
  (dbSslMode === "auto" && /rds\.amazonaws\.com$/i.test(dbHost));

const pool = new Pool({
  host: dbHost,
  port: Number(process.env.DB_PORT || 5432),
  database: process.env.DB_NAME || "piaca_db",
  user: process.env.DB_USER || "piaca_user",
  password: process.env.DB_PASSWORD || "piaca_pass",
  ssl: shouldUseSsl ? { rejectUnauthorized: dbSslRejectUnauthorized } : undefined
});

module.exports = { pool };
