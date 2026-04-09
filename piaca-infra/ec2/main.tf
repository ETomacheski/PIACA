provider "aws" {
  region = "us-east-1"
}

variable "app_dir" {
  description = "Diretorio da aplicacao na EC2"
  type        = string
  default     = "/home/ec2-user/app"
}

variable "ami_id" {
  description = "AMI utilizada pela EC2"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "Tipo da instancia EC2"
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "Nome da instancia EC2"
  type        = string
  default     = "piaca-ec2"
}

data "aws_security_group" "ec2_sg" {
  name = "piaca-ec2-sg"
}

data "aws_key_pair" "key" {
  key_name = "piaca-key"
}

resource "aws_instance" "ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  key_name                    = data.aws_key_pair.key.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [
    data.aws_security_group.ec2_sg.id
  ]

  user_data = <<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
yum install -y awscli git
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
curl -L https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
mkdir -p ${var.app_dir}
chown -R ec2-user:ec2-user ${var.app_dir}
EOF

  tags = {
    Name        = var.instance_name
    Environment = "production"
  }
}

output "ip" {
  value = aws_instance.ec2.public_ip
}