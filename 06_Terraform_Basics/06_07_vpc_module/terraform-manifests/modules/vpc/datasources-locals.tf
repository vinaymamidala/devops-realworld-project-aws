#Data source

data "aws_availability_zones" "available" {
  state = "available"  #us-east-1a, us-east-1b, us-east-1c are available az in us-east-1 region
}

#locas block

locals {
    azs = slice(data.aws_availability_zones.available.names, 0, 3)
    public_subnets = [for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k)]
    private_subnets = [for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k + 10)]
}