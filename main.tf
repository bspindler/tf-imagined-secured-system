module "global_variables" {
  source = "./global_variables"
}

provider "aws" {
    region = module.global_variables.aws_region
}

module "network" {  source = "./network"}
module "storage" {  source = "./storage"}