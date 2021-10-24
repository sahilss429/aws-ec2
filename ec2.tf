################################################################################
# EC2 Module
################################################################################
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

module "ec2_complete" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ec2-instance.git?ref=v3.2.0"
  for_each = local.multiple_instances
  name = "${local.name}-multi-${each.key}"

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = each.value.instance_type
#  availability_zone      = each.value.availability_zone
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [module.security_group.security_group_id]
  key_name           = aws_key_pair.deployer.key_name
  root_block_device  = lookup(each.value, "root_block_device", [])

  associate_public_ip_address = false

  # only one of these can be enabled at a time
  hibernation = true
  # enclave_options_enabled = true

  user_data_base64 = base64encode(local.user_data)


  enable_volume_tags = true

  tags = local.tags
}

resource "aws_key_pair" "deployer" {
  key_name   = "temp_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlpcYuCpSuGteVci5EjXfij0uLzkfDxtFGnJU/AHb8J7bh0VfVEzUJjvsuO54D+PmrzVdvf1EvM8fb/g3kkwivflVrBK2k4NRVD13KlsXKb8qvKOlywZcuNcG+J3FKFdg7MrrgqvwGRc4W9CCyP6yIU7lYPnC2ON/NC4tkVtieqLthZGWJEmjVjTyDu7/+Is/JD8zOp+SoGduJDTN45j4vhHfIPsXBz8nDWikw67Jk1C3ryCitB968z4QvcR5rFDh/tjFc+UENAD9aV/7kcImm0acHEgClW3EGwQx4oywNiVklvTGmXnOw8jmX9XHrTq7eHwUMRG/6y+TDtxZ5tdsh"
}
