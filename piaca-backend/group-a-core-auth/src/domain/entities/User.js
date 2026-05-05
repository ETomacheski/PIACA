class User {
  constructor({ id, email, status, createdAt, updatedAt }) {
    this.id = id;
    this.email = email;
    this.status = status;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }
}

module.exports = { User };
