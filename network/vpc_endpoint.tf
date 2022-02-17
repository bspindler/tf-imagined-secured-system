# data block allows us to read something from the environment, in this case
# the default security group id
data "aws_security_group" "selected" {
  vpc_id = aws_vpc.webapp-main.id

  filter {
    name   = "group-name"
    values = ["default"]
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.webapp-main.id
  service_name = "com.amazonaws.us-west-2.s3"
  vpc_endpoint_type = "Interface"

  subnet_ids = [aws_subnet.webapp-main.id]
  security_group_ids = [data.aws_security_group.selected.id]
}
