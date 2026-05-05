const { User } = require("../../domain/entities/User");

function rowToUser(row) {
  return new User({
    id: row.id,
    email: row.email,
    status: row.status,
    createdAt: row.createdat,
    updatedAt: row.updatedat
  });
}

class PgUserRepository {
  constructor({ pool }) {
    this.pool = pool;
  }

  _exec(sql, params, ctx) {
    const runner = ctx?.tx || this.pool;
    return runner.query(sql, params);
  }

  async findById(id, ctx) {
    const { rows } = await this._exec(
      `SELECT id, email, status, createdAt, updatedAt
         FROM users
        WHERE id = $1`,
      [id],
      ctx
    );
    return rows[0] ? rowToUser(rows[0]) : null;
  }

  async findByEmail(email, ctx) {
    const { rows } = await this._exec(
      `SELECT id, email, status, createdAt, updatedAt
         FROM users
        WHERE email = $1`,
      [email],
      ctx
    );
    return rows[0] ? rowToUser(rows[0]) : null;
  }

  async findCredentialsByEmail(email, ctx) {
    const { rows } = await this._exec(
      `SELECT id, email, status, password_hash, createdAt, updatedAt
         FROM users
        WHERE email = $1`,
      [email],
      ctx
    );
    if (!rows[0]) return null;
    const row = rows[0];
    return {
      user: rowToUser(row),
      passwordHash: row.password_hash
    };
  }

  async create({ email, passwordHash }, ctx) {
    const { rows } = await this._exec(
      `INSERT INTO users (id, email, password_hash, status, createdAt, updatedAt)
       VALUES (gen_random_uuid(), $1, $2, 1, CURRENT_DATE, CURRENT_DATE)
       RETURNING id, email, status, createdAt, updatedAt`,
      [email, passwordHash],
      ctx
    );
    return rowToUser(rows[0]);
  }
}

module.exports = { PgUserRepository };
