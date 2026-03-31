provider "aws" {
  region = "us-east-1"
}

variable "db_name" {
  description = "Nome do banco"
  type        = string
  default     = "piaca_db"
}

variable "db_user" {
  description = "Usuario do banco"
  type        = string
  default     = "piaca_user"
}

variable "db_password_dev" {
  description = "Senha do banco de desenvolvimento"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password_dev) >= 8 && length(var.db_password_dev) <= 41 && length(regexall("[/@\" ]", var.db_password_dev)) == 0
    error_message = "db_password_dev deve ter 8-41 caracteres e nao pode conter /, @, aspas duplas ou espaco."
  }
}

variable "db_password_prod" {
  description = "Senha do banco de producao"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password_prod) >= 8 && length(var.db_password_prod) <= 41 && length(regexall("[/@\" ]", var.db_password_prod)) == 0
    error_message = "db_password_prod deve ter 8-41 caracteres e nao pode conter /, @, aspas duplas ou espaco."
  }
}

variable "db_instance_class" {
  description = "Classe da instancia RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Armazenamento alocado (GB)"
  type        = number
  default     = 20
}

locals {
  environments = {
    dev = {
      password = var.db_password_dev
    }
    prod = {
      password = var.db_password_prod
    }
  }
}

data "aws_security_group" "rds_sg" {
  name = "piaca-rds-sg"
}

resource "aws_db_instance" "postgres" {
  for_each = local.environments

  identifier = "piaca-${each.key}-db"

  engine = "postgres"
  engine_version = "16"

  instance_class = var.db_instance_class

  allocated_storage = var.db_allocated_storage

  db_name  = var.db_name
  username = var.db_user
  password = each.value.password

  vpc_security_group_ids = [
    data.aws_security_group.rds_sg.id
  ]

  publicly_accessible = false

  skip_final_snapshot = true
}

resource "aws_ssm_parameter" "db_host" {
  for_each = aws_db_instance.postgres

  name  = "/piaca/${each.key}/db/host"
  type  = "String"
  value = each.value.address
}

resource "aws_ssm_parameter" "db_port" {
  for_each = aws_db_instance.postgres

  name  = "/piaca/${each.key}/db/port"
  type  = "String"
  value = tostring(each.value.port)
}

resource "aws_ssm_parameter" "db_name" {
  for_each = local.environments

  name  = "/piaca/${each.key}/db/name"
  type  = "String"
  value = var.db_name
}

resource "aws_ssm_parameter" "db_user" {
  for_each = local.environments

  name  = "/piaca/${each.key}/db/user"
  type  = "String"
  value = var.db_user
}

resource "aws_ssm_parameter" "db_password" {
  for_each = local.environments

  name  = "/piaca/${each.key}/db/password"
  type  = "SecureString"
  value = each.value.password
}

output "endpoints" {
  value = {
    for env, db in aws_db_instance.postgres : env => db.address
  }
}

output "ssm_prefixes" {
  value = {
    dev  = "/piaca/dev/db"
    prod = "/piaca/prod/db"
  }
}