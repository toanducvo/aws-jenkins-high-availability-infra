locals {
  ingress_rules = [{
    port        = 80
    description = "Allow HTTP access"
    },
    {
      port        = 443
      description = "Allow HTTPS access"
    },
    {
      port        = 22
      description = "Allow SSH access"
  }]

  egress_rules = [{
    port        = 0
    description = "Allow all Egress traffic"
  }]
}