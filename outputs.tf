output "instance_ip_addr_jenkins" {
  value = aws_instance.iJenkins.public_ip
}