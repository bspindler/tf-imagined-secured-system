resource "aws_subnet" "webapp-main" {
  vpc_id     = aws_vpc.webapp-main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = module.global_variables.webappname
  }
}