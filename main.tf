#
#       Jenkins instance
#
resource "aws_instance" "iJenkins" {
  depends_on    = [aws_security_group.SG_jenkins]
  ami           = var.ami-2022
  instance_type = "t2.micro"
  key_name                    = "sparrow"
  associate_public_ip_address = true
  user_data                   = file("./install_jenkins.sh")
  subnet_id                   = aws_subnet.tf_subnet_public1.id
  vpc_security_group_ids      = [aws_security_group.SG_jenkins.id]
  tags = {
    Name = "jenkins_sparrow"
  }
}