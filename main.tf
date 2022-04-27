#
#       Jenkins instance
#
resource "aws_instance" "iJenkins" {
  depends_on                  = [aws_security_group.SG_jenkins]
  ami                         = var.ami-2022
  instance_type               = "t2.micro"
  key_name                    = "sparrow"
  associate_public_ip_address = true
  user_data                   = file("./install_jenkins.sh")
  subnet_id                   = aws_subnet.tf_subnet_public1.id
  vpc_security_group_ids      = [aws_security_group.SG_jenkins.id]
  tags = {
    Name = "jenkins_sparrow"
  }
}
# bucket for jenkins backup
resource "aws_s3_bucket" "BackupJenkins" {
  bucket        = "backup-jenkins2"
  force_destroy = true
  tags = {
    Name = "backup-jenkins2"
  }
}

resource "aws_s3_bucket_acl" "s3-acl" {
  bucket = aws_s3_bucket.BackupJenkins.id
  acl    = "private"
}

resource "aws_iam_policy" "tf_policy" {
  name        = "put_objects"
  path        = "/"
  description = "Politica poner objetos"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Effect = "Allow"
        "Resource" : [
          "${aws_s3_bucket.BackupJenkins.arn}",
          "${aws_s3_bucket.BackupJenkins.arn}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "tf_role" {
  name = "role_putobject"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    "Name" = "tfRole"
  }
}

resource "aws_iam_policy_attachment" "tf_attach_policy" {
  name       = "policy_attach"
  roles      = [aws_iam_role.tf_role.name]
  policy_arn = aws_iam_policy.tf_policy.arn
}

resource "aws_iam_role_policy_attachment" "bucket_policy" {
  role       = aws_iam_role.tf_role.name
  policy_arn = aws_iam_policy.tf_policy.arn
}

resource "aws_iam_instance_profile" "tf_profile" {
  name = "instance_profile"
  role = aws_iam_role.tf_role.name
}