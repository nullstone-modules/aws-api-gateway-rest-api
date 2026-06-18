data "aws_partition" "this" {}
data "aws_region" "this" {}
data "aws_caller_identity" "this" {}

locals {
  partition  = data.aws_partition.this.partition
  region     = data.aws_region.this.region
  account_id = data.aws_caller_identity.this.account_id
}