# https://troylindsayblog.wordpress.com/2018/04/12/one-way-to-implement-global-variables-in-terraform/
output "aws_region" {
  value = "us-west-2"
}
output "webappname" {
    value = "deebo"
}
output "loggingbucket" {
    value = "deebo-logging-bucket"
}
# reading account_id from environment 
data "aws_caller_identity" "current" {}
locals {
    account_id = data.aws_caller_identity.current.account_id
}
output "account_id" {
    value = locals.account_id
}