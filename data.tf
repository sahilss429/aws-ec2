data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc_id.id
  filter {
    name   = "tag:role"
    values = ["public"]
  }

  filter {
    name   = "tag:Environment"
    values = ["staging"]
  }
}

data "aws_subnet" "public" {
  for_each = data.aws_subnet_ids.public.ids
  id       = each.value
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc_id.id
  filter {
    name   = "tag:role"
    values = ["private"]
  }

  filter {
    name   = "tag:Environment"
    values = ["staging"]
  }
}

data "aws_subnet" "private" {
  for_each = data.aws_subnet_ids.private.ids
  id       = each.value
}

data "aws_vpc" "vpc_id" {
  filter {
    name   = "tag:Environment"
    values = ["staging"]
  }

}
