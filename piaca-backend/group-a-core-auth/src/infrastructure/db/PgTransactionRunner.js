class PgTransactionRunner {
  constructor({ pool }) {
    this.pool = pool;
  }

  async run(callback) {
    const client = await this.pool.connect();
    try {
      await client.query("BEGIN");
      const result = await callback(client);
      await client.query("COMMIT");
      return result;
    } catch (err) {
      await client.query("ROLLBACK");
      throw err;
    } finally {
      client.release();
    }
  }
}

module.exports = { PgTransactionRunner };
