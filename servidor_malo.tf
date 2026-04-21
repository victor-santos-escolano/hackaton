terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# Región no europea
provider "aws" {
  region = "us-east-1"
}

# Secretos hardcodeados
variable "db_password" {
  type    = string
  default = "SuperPassword123!"
}

# Naming pobre y sin tags corporativos
resource "aws_security_group" "bad_sg" {
  name        = "open-all-sg"
  description = "Security group intentionally full of bad practices for static analysis"

  # SSH abierto a todo Internet
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP abierto a todo Internet
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS abierto a todo Internet
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Puerto de aplicación abierto
  ingress {
    description = "App port from anywhere"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Base de datos abierta
  ingress {
    description = "MySQL from anywhere"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Todo el tráfico saliente permitido
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bad-sg"
  }
}

# IP pública explícita
resource "aws_instance" "bad_vm" {
  ami                         = "ami-xxxxxxxxxxxxxxxxx" # placeholder no válido a propósito
  instance_type               = "t3.micro"
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.bad_sg.id]

  # Disco raíz pequeño y sin cifrado explícito
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    encrypted   = false
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional" # IMDSv1 permitido
  }

  # User data con malas prácticas claras para detección
  user_data = <<-EOF
              #!/bin/bash
              useradd demo
              echo 'demo:demo123' | chpasswd
              sed -i 's/^#\\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
              systemctl restart sshd || systemctl restart ssh

              apt-get update -y || yum update -y
              apt-get install -y nginx curl || yum install -y nginx curl

              # Simulación de secreto en texto plano
              echo "DB_PASSWORD=${var.db_password}" >> /etc/environment

              # Servicio de ejemplo
              systemctl enable nginx
              systemctl start nginx
              EOF

  tags = {
    Name        = "bad-linux-vm"
    Environment = "test"
  }
}

output "public_ip_note" {
  value = "This fixture is intentionally insecure for static analysis and should not be applied."
}