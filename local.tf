locals {
  name   = "example-ec2-complete"
  region = "eu-west-1"

  user_data = <<-EOT
  #!/bin/bash
  echo "Hello Terraform!"
  EOT

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
  multiple_instances = {
    one = {
      instance_type     = "t2.micro"
#      availability_zone = element(module.vpc.azs, 0)
#      subnet_id         = element(module.vpc.private_subnets, 0)
      subnet_id 	= element(tolist(data.aws_subnet_ids.public.ids), 0)
      root_block_device = [
        {
          encrypted   = true
          volume_type = "gp3"
          throughput  = 200
          volume_size = 50
        }
      ]
    }
    two = {
      instance_type     = "t2.micro"
#      availability_zone = element(module.vpc.azs, 1)
      subnet_id         = element(tolist(data.aws_subnet_ids.private.ids), 0)
      root_block_device = [
        {
          encrypted   = true
          volume_type = "gp2"
          volume_size = 50
        }
      ]
    }
#    three = {
#      instance_type     = "t2.micro"
#      availability_zone = element(module.vpc.azs, 2)
#      subnet_id         = element(module.vpc.private_subnets, 2)
#      root_block_device = [
#        {
#          encrypted   = true
#          volume_type = "gp2"
#          volume_size = 50
#        }
#      ]
#    }
  }
}
