data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs      = data.aws_availability_zones.available.names
  az_count = length(local.azs)
}

locals {
  public_subnet_cidrs = {
    for index, az in local.azs : az => tomap({
      "cidr"              = element(var.jenkins_public_subnet_cidrs, index)
      "availability_zone" = az
    })
  }

  private_subnet_cidrs = {
    for index, az in local.azs : az => tomap({
      "cidr"              = element(var.jenkins_private_subnet_cidrs, index)
      "availability_zone" = az
    })
  }
}