const { Role } = require("../../domain/entities/Role");

function rowToRole(row) {
  return new Role({
    id: row.id,
    type: row.type_id,
    description: row.description
  });
}

class PgRoleRepository {
  constructor({ pool }) {
    this.pool = pool;
  }

  _exec(sql, params, ctx) {
    const runner = ctx?.tx || this.pool;
    return runner.query(sql, params);
  }

  async findByType(type, ctx) {
    const { rows } = await this._exec(
      `SELECT id, type_id, description FROM roles WHERE type_id = $1`,
      [type],
      ctx
    );
    return rows[0] ? rowToRole(rows[0]) : null;
  }

  async findRolesByUserId(userId, ctx) {
    const { rows } = await this._exec(
      `SELECT r.id, r.type_id, r.description
         FROM user_roles ur
         JOIN roles r ON r.id = ur.role_id
        WHERE ur.user_id = $1
        ORDER BY r.type_id`,
      [userId],
      ctx
    );
    return rows.map(rowToRole);
  }

  async assignRoleToUser(userId, roleId, ctx) {
    await this._exec(
      `INSERT INTO user_roles (user_id, role_id, createdAt, updatedAt)
       VALUES ($1, $2, CURRENT_DATE, CURRENT_DATE)
       ON CONFLICT DO NOTHING`,
      [userId, roleId],
      ctx
    );
  }
}

module.exports = { PgRoleRepository };
