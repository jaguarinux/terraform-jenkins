# security group bastion
resource "aws_security_group" "SG_jenkins" {
  depends_on  = [aws_vpc.tf_vpc]
  name        = "${var.code_name}-sg-jenkins"
  description = "sg-jenkins-${var.code_name}"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    description = "Allow from Personal CIDR block"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.cdirAll]
  }

  ingress {
    description = "allow SSH"
    from_port   = var.iSSH
    to_port     = var.iSSH
    protocol    = "tcp"
    cidr_blocks = [var.cdirAll]
  }

  egress {
    from_port        = var.eAll
    to_port          = var.eAll
    protocol         = "-1"
    cidr_blocks      = [var.cdirAll]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "SG-jenkins-${var.code_name}"
  }
}