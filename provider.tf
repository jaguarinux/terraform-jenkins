provider "aws" {
  profile = "default"
  region  = var.region

  default_tags {
    tags = {
      "project" = "${var.code_name}"
    }
  }
}