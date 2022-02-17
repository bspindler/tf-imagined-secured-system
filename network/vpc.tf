resource "aws_vpc" "webapp-main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = module.global_variables.webappname
  }
}
