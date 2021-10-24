################################################################################
# Security Groups
################################################################################

module "security_group" {
  source  = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=v4.4.0"

  name        = local.name
  description = "Security group for example usage with EC2 instance"
  vpc_id      = data.aws_vpc.vpc_id.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "106.202.211.183/32,20.10.0.0/16"
    },
  ]
  tags = local.tags
}
