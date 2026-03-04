resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
  #number  = false
}

resource "aws_s3_bucket" "demo_bucket" {
    bucket = "devopsdemo-${random_string.suffix.result}"

    tags = {
        Name = "Devops demo bucket"
        Environment = "Dev"
        #Owner = "Vinaykumar Mamidala"
        #Organization = "DevOPs path"
    }
}